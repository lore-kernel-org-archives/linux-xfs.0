Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CAD912CDA5
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497999; cv=none; b=o6IXBgQ8Zo8tJHho/S1rFvUw+nfKhxykyvtWFrJmFsliffhXciqowUxtjO6z05rR6dWU/OgRcjG1yCe7YKlxGnEellMElGMujr0bfaUs6QyXiiGM8VH+plyWgfdNhbEJZBUTxCnbwqh911UPHTgUXsG2dqPvNepWAs2csY1rYes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497999; c=relaxed/simple;
	bh=MxeJmSlWeQupyQ8OUqyyd/OMlDo+y3/DtntHthNZNNQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BvHWCVpanohUjszrgg26AfjN5QZt1XyoRetkCKdQedPUWR+FDAjhWKSTJSVnNx3MmXoXhVZ37GRYxUlattFjsgesjuQuVrziLSy8knwAgoQC6+poYnrG/WHNVWTyutymj3Ul6Q3VUZ2HgFuvdjvq8QpD92wQQEFXKpz85+PayAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TNWVZ9Xf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TNWVZ9Xf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7FAC19423;
	Tue,  3 Mar 2026 00:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497999;
	bh=MxeJmSlWeQupyQ8OUqyyd/OMlDo+y3/DtntHthNZNNQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TNWVZ9XfWq5azeSF/kvnorCwlNaWWwkETGsUenhysInbBPx7wHFJlm/UzNI4m4fo+
	 HXPgDOOpotr6NlfUaK1h44JA5ptPIYK7Es5tmq2PqnrnEi8NNuk+lRSGK7jNLWQFX3
	 jQ9xru3hnBUM/a+1UkxGkA2nzLlIBfZ+ocRJyStjVnvH7uQo92hFGZ7/XVs7Ry/zSK
	 1uxbWzSpXiLpqrXTbb6NCrVPHQEGlVD5gF0e93hw89C2NI3OV6Zh2adjAo7ysl7gVL
	 HqGTKwAfXv4AE9ZO3alt6uxUAEbtHhJXD6Ij3ccNVFqhrKbXyJb3Fam+wU0or4aBi8
	 RGVXrh39aS/8Q==
Date: Mon, 02 Mar 2026 16:33:18 -0800
Subject: [PATCHSET v8] xfsprogs: autonomous self healing of filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
In-Reply-To: <20260303002508.GB57948@frogsfrogsfrogs>
References: <20260303002508.GB57948@frogsfrogsfrogs>
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
 * xfs_healer: validate that repair fds point to the monitored fs
 * xfs_healer: add a manual page
 * xfs_scrub: use the verify media ioctl during phase 6 if possible
 * xfs_scrub: perform media scanning of the log region
 * xfs_io: add listmount command
 * xfs_io: print systemd service names
 * mkfs: enable online repair if all backrefs are enabled
 * debian: enable xfs_healer on the root filesystem by default
 * debian/control: listify the build dependencies
---
 healer/xfs_healer.h                            |   88 +++
 io/io.h                                        |    8 
 libfrog/flagmap.h                              |   23 +
 libfrog/fsproperties.h                         |    5 
 libfrog/getparents.h                           |    4 
 libfrog/healthevent.h                          |   55 ++
 libfrog/systemd.h                              |   55 ++
 scrub/disk.h                                   |   11 
 Makefile                                       |    5 
 configure.ac                                   |   12 
 debian/control                                 |   14 +
 debian/postinst                                |    8 
 debian/prerm                                   |   13 +
 debian/rules                                   |    3 
 healer/Makefile                                |   70 +++
 healer/fsrepair.c                              |  342 ++++++++++++++
 healer/system-xfs_healer.slice                 |   31 +
 healer/weakhandle.c                            |  266 +++++++++++
 healer/xfs_healer.c                            |  605 ++++++++++++++++++++++++
 healer/xfs_healer@.service.in                  |  108 ++++
 healer/xfs_healer_start.c                      |  372 +++++++++++++++
 healer/xfs_healer_start.service.in             |   85 +++
 include/builddefs.in                           |   12 
 io/Makefile                                    |   16 +
 io/healthmon.c                                 |  186 +++++++
 io/init.c                                      |    3 
 io/listmount.c                                 |  383 +++++++++++++++
 io/scrub.c                                     |   75 +++
 io/verify_media.c                              |  180 +++++++
 libfrog/Makefile                               |   10 
 libfrog/flagmap.c                              |   79 +++
 libfrog/getparents.c                           |   93 +++-
 libfrog/healthevent.c                          |  477 +++++++++++++++++++
 libfrog/systemd.c                              |  181 +++++++
 m4/package_libcdev.m4                          |   97 ++++
 man/man2/ioctl_xfs_health_fd_on_monitored_fs.2 |   75 +++
 man/man2/ioctl_xfs_health_monitor.2            |  464 ++++++++++++++++++
 man/man2/ioctl_xfs_verify_media.2              |  185 +++++++
 man/man8/Makefile                              |   40 +-
 man/man8/xfs_healer.8                          |  109 ++++
 man/man8/xfs_healer_start.8                    |   37 +
 man/man8/xfs_io.8                              |  134 +++++
 mkfs/xfs_mkfs.c                                |    9 
 scrub/Makefile                                 |   13 -
 scrub/disk.c                                   |   40 ++
 scrub/phase1.c                                 |   25 +
 scrub/phase6.c                                 |   11 
 scrub/read_verify.c                            |    2 
 scrub/xfs_scrub.c                              |   32 -
 49 files changed, 5090 insertions(+), 61 deletions(-)
 create mode 100644 healer/xfs_healer.h
 create mode 100644 libfrog/flagmap.h
 create mode 100644 libfrog/healthevent.h
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
 create mode 100644 libfrog/systemd.c
 create mode 100644 man/man2/ioctl_xfs_health_fd_on_monitored_fs.2
 create mode 100644 man/man2/ioctl_xfs_health_monitor.2
 create mode 100644 man/man2/ioctl_xfs_verify_media.2
 create mode 100644 man/man8/xfs_healer.8
 create mode 100644 man/man8/xfs_healer_start.8

