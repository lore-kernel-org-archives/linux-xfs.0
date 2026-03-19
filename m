Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AC628030E
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895109; cv=none; b=LhR0p2Gl3U6AX5QgRUdOGFDgnDZxM9AC78YiG111mvAWb8TSKWR5MbPSua6x8eKDAVcle7rm9QfvewkXW0QPJvqH6QPX6SPg0RocR702Xk6YblYH0COr7O+Hr0v4atrK+hcrTCm7VaIzKqOGlal5+nstvTNJ6SZf5iVz2pD06m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895109; c=relaxed/simple;
	bh=NaZK7n2Z2vtJ7QLXOMIVKoFSeN5IMhwY1OcMwRwVtL8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RuN54qgNLDOIXmKjkAQgIGQ3Ggonzy3OagJkVnPygRoHRsEUI3/zQLPp4mwUo56nbryP6311dqG0aqXrrqUrHiy3BMHeLsYseVsWhprxhSweZJULlZI3i6rpGc7/NcgTyYt9d0aMybMxzeG+EIeR5+dhiC86W8Y4Yhnu6oWLpqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o5OF5TTB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o5OF5TTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47401C19425;
	Thu, 19 Mar 2026 04:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895109;
	bh=NaZK7n2Z2vtJ7QLXOMIVKoFSeN5IMhwY1OcMwRwVtL8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=o5OF5TTBpD1VuvAUVKegJkDqz6Pb+DnMjJlBDT7gaPlJE9VDlMlzuY6P3YAZ55uqX
	 2IEgAR7f5PGhkNikA/y+9HbuZbzPaDA+gR4eWtgafppODoUnYAcE9hvBRcZHyIVCoa
	 3lUIadgsxXcrC1MvF3fVuoaqqarW2rT63ToIfOJpMwR3ZuKwlDXH7F5T6jGga4/4aX
	 crvbL7cse7f7SkU4OtIsXkb/ERRe+F8zjpmpzc11LLb2jTHz5OaEgURvcGiQ8Kx2a3
	 u8ORfBsvF6aNtSnkZC33YbpbImCPt7Vgexa6stebZKo77mOcKWKbnA7ew2lIze6h0K
	 sqX4qGvoiL+PQ==
Date: Wed, 18 Mar 2026 21:38:28 -0700
Subject: [PATCHSET v10 1/2] xfsprogs: autonomous self healing of filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177389506017.3680139.913759001427336891.stgit@frogsfrogsfrogs>
In-Reply-To: <20260319043707.GO1770774@frogsfrogsfrogs>
References: <20260319043707.GO1770774@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This patchset builds new functionality to deliver live information about
filesystem health events to userspace.  This is done by creating an
anonymous file that can be read() for events by userspace programs.
Events are captured by hooking various parts of XFS and iomap so that
metadata health failures, file I/O errors, and major changes in
filesystem state (unmounts, shutdowns, etc.) can be observed by
programs.

When an event occurs, the hook functions queue an event object to each
event anonfd for later processing.  Programs must have CAP_SYS_ADMIN
to open the anonfd and there's a maximum event lag to prevent resource
overconsumption.  The events themselves can be read() from the anonfd
as C structs for the xfs_healer daemon.

In userspace, we create a new daemon program that will read the event
objects and initiate repairs automatically.  This daemon is managed
entirely by systemd and will not block unmounting of the filesystem
unless repairs are ongoing.  They are auto-started by a starter
service that uses fanotify.

v10: move the xfs_scrub cleanups and changes to their own patchset,
     improve the commit messages to explain why we use getmntent and
     statmount
v9: move listmount/statmount to libfrog; improve documentation about why
    we dance with getmntent; enhance getmntent reconnection with
    listmount; move --svcname helpers to xfs_{healer,scrub}; improve
    commit messages; various tweaks to fstests
v8: clean up userspace for merging now that the kernel part is upstream
v7: more cleanups of the media verification ioctl, improve comments, and
    reuse the bio
v6: fix pi-breaking bugs, make verify failures trigger health reports
v5: add verify-media ioctl, collapse small helper funcs with only
    one caller
v4: drop multiple client support so we can make direct calls into
    healthmon instead of chasing pointers and doing indirect calls
v3: drag out of rfc status

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=health-monitoring

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=health-monitoring

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=health-monitoring
---
Commits in this patchset:
 * libfrog: add a function to grab the path from an open fd and a file handle
 * libfrog: create healthmon event log library functions
 * libfrog: add support code for starting systemd services programmatically
 * libfrog: hoist a couple of service helper functions
 * libfrog: add wrappers for listmount and statmount
 * man2: document the healthmon ioctl
 * man2: document the media verification ioctl
 * xfs_io: monitor filesystem health events
 * xfs_io: add a media verify command
 * xfs_healer: create daemon to listen for health events
 * xfs_healer: enable repairing filesystems
 * xfs_healer: use getparents to look up file names
 * xfs_healer: create a per-mount background monitoring service
 * xfs_healer: create a service to start the per-mount healer service
 * xfs_healer: don't start service if kernel support unavailable
 * xfs_healer: use the autofsck fsproperty to select mode
 * xfs_healer: run full scrub after lost corruption events or targeted repair failure
 * xfs_healer: use getmntent to find moved filesystems
 * xfs_healer: use statmount to find moved filesystems even faster
 * xfs_healer: validate that repair fds point to the monitored fs
 * xfs_healer: add a manual page
 * xfs_scrub: print systemd service names
 * xfs_io: add listmount and statmount commands
 * mkfs: enable online repair if all backrefs are enabled
 * debian/control: listify the build dependencies
 * debian: enable xfs_healer on the root filesystem by default
---
 healer/xfs_healer.h                            |   92 +++
 include/linux.h                                |    8 
 io/io.h                                        |    8 
 libfrog/flagmap.h                              |   23 +
 libfrog/fsproperties.h                         |    5 
 libfrog/getparents.h                           |    4 
 libfrog/healthevent.h                          |   55 ++
 libfrog/statmount.h                            |  104 ++++
 libfrog/systemd.h                              |   55 ++
 scrub/xfs_scrub.h                              |    3 
 Makefile                                       |    5 
 configure.ac                                   |   13 
 debian/control                                 |   14 -
 debian/postinst                                |    8 
 debian/prerm                                   |   13 
 debian/rules                                   |    3 
 healer/Makefile                                |   69 ++
 healer/fsrepair.c                              |  342 ++++++++++++
 healer/system-xfs_healer.slice                 |   31 +
 healer/weakhandle.c                            |  296 +++++++++++
 healer/xfs_healer.c                            |  666 ++++++++++++++++++++++++
 healer/xfs_healer@.service.in                  |  108 ++++
 healer/xfs_healer_start.c                      |  368 +++++++++++++
 healer/xfs_healer_start.service.in             |   85 +++
 include/builddefs.in                           |   15 +
 io/Makefile                                    |    9 
 io/healthmon.c                                 |  186 +++++++
 io/init.c                                      |    3 
 io/listmount.c                                 |  361 +++++++++++++
 io/verify_media.c                              |  180 ++++++
 libfrog/Makefile                               |   19 +
 libfrog/flagmap.c                              |   79 +++
 libfrog/getparents.c                           |   93 +++
 libfrog/healthevent.c                          |  477 +++++++++++++++++
 libfrog/statmount.c                            |   76 +++
 libfrog/systemd.c                              |  177 ++++++
 m4/package_libcdev.m4                          |  129 +++++
 man/man2/ioctl_xfs_health_fd_on_monitored_fs.2 |   75 +++
 man/man2/ioctl_xfs_health_monitor.2            |  464 +++++++++++++++++
 man/man2/ioctl_xfs_verify_media.2              |  185 +++++++
 man/man8/Makefile                              |   40 +
 man/man8/xfs_healer.8                          |  109 ++++
 man/man8/xfs_healer_start.8                    |   37 +
 man/man8/xfs_io.8                              |  133 +++++
 mkfs/xfs_mkfs.c                                |    9 
 scrub/Makefile                                 |   14 -
 scrub/xfs_scrub.c                              |   82 ++-
 47 files changed, 5272 insertions(+), 58 deletions(-)
 create mode 100644 healer/xfs_healer.h
 create mode 100644 libfrog/flagmap.h
 create mode 100644 libfrog/healthevent.h
 create mode 100644 libfrog/statmount.h
 create mode 100644 libfrog/systemd.h
 create mode 100644 debian/prerm
 create mode 100644 healer/Makefile
 create mode 100644 healer/fsrepair.c
 create mode 100644 healer/system-xfs_healer.slice
 create mode 100644 healer/weakhandle.c
 create mode 100644 healer/xfs_healer.c
 create mode 100644 healer/xfs_healer@.service.in
 create mode 100644 healer/xfs_healer_start.c
 create mode 100644 healer/xfs_healer_start.service.in
 create mode 100644 io/healthmon.c
 create mode 100644 io/listmount.c
 create mode 100644 io/verify_media.c
 create mode 100644 libfrog/flagmap.c
 create mode 100644 libfrog/healthevent.c
 create mode 100644 libfrog/statmount.c
 create mode 100644 libfrog/systemd.c
 create mode 100644 man/man2/ioctl_xfs_health_fd_on_monitored_fs.2
 create mode 100644 man/man2/ioctl_xfs_health_monitor.2
 create mode 100644 man/man2/ioctl_xfs_verify_media.2
 create mode 100644 man/man8/xfs_healer.8
 create mode 100644 man/man8/xfs_healer_start.8

