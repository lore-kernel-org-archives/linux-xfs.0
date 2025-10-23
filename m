Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3D02BD590
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761177605; cv=none; b=Q6Qy0VPJtmtNWftzMKPrYBwVS4wPzPgmGYOERJEG85iKYtU2gXH8ilub73aYPE7FI0+GfKQn6uZWlUFtnsOQUuAQgHAQgxcqtgSW1+eX8WWWumJhoi/NhJbZtLYmYTEI4JZxYq7aYtUCXmyZ4yJ2HUcdFcX1aLL1ph2NpWDa/W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761177605; c=relaxed/simple;
	bh=PGbKs4kcDrLzPNnp0PDvq3L3GspHzic29W2gY4Oag0k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tjDhDNa2GQZipC8PErrz64QH50dRMG+9Wf4lOE++T9iwLcCZ4v4rgusRzfHpVCy6Eihxt1N8nkFatQgiHd6GsRRgBnd/U62Woo9ExA8LQBMsk+9gxvwdPoRRsPABouw3tsb7SO3HBwC9XFkeShYGnDTX2A1E/0wUJD1KJgJxMOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sdOknhfO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sdOknhfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A61C4CEE7;
	Thu, 23 Oct 2025 00:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761177604;
	bh=PGbKs4kcDrLzPNnp0PDvq3L3GspHzic29W2gY4Oag0k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sdOknhfO4fQifeTpnSxkPfht69zzlSQJvrifxi09/JuZN5d6I1qnC/lZ427/Em7Yz
	 OeZIEuuWNIV5Swve0sgnRyjXjZYXuz7/L9uPP/3EsftxOR7tWZVP0NGTLjBtBd4rk7
	 6D8r6ff++mpw471crBMeAXI7kqbfiatJ2AC4tMPln5kCa9+ww7ADqr39nIpRuyeKJz
	 E7edtnuw3+A915OMKyDga6//D+OE7I5PilfD45t3Gff3o04MH61S6esnKIbp2Uq3hP
	 wZFxiookg9uTb2h1VCRM4ZJYvp5ivg1TzkYoQ/hdIVMGfDYtQN1n08iKRo08H55aGq
	 HEHiz3polws3w==
Date: Wed, 22 Oct 2025 17:00:02 -0700
Subject: [PATCHSET V2 1/2] xfsprogs: autonomous self healing of filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
In-Reply-To: <20251022235646.GO3356773@frogsfrogsfrogs>
References: <20251022235646.GO3356773@frogsfrogsfrogs>
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
either as json objects for human readability, or as C structs for
daemons.

In userspace, we create a new daemon program that will read the event
objects and initiate repairs automatically.  This daemon is managed
entirely by systemd and will not block unmounting of the filesystem
unless repairs are ongoing.  It is autostarted via some udev rules.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
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
 * xfs: create hooks for monitoring health updates
 * xfs: create a special file to pass filesystem health to userspace
 * xfs: create event queuing, formatting, and discovery infrastructure
 * xfs: report metadata health events through healthmon
 * xfs: report shutdown events through healthmon
 * xfs: report media errors through healthmon
 * xfs: report file io errors through healthmon
 * xfs: validate fds against running healthmon
 * xfs: add media error reporting ioctl
 * xfs_io: monitor filesystem health events
 * xfs_io: add a media error reporting command
 * xfs_healer: create daemon to listen for health events
 * xfs_healer: check events against schema
 * xfs_healer: enable repairing filesystems
 * xfs_healer: check for fs features needed for effective repairs
 * xfs_healer: use getparents to look up file names
 * builddefs: refactor udev directory specification
 * xfs_healer: create a background monitoring service
 * xfs_healer: don't start service if kernel support unavailable
 * xfs_healer: use the autofsck fsproperty to select mode
 * xfs_healer: run full scrub after lost corruption events or targeted repair failure
 * xfs_healer: use getmntent to find moved filesystems
 * xfs_healer: validate that repair fds point to the monitored fs
 * xfs_healer: add a manual page
 * xfs_scrub: report media scrub failures to the kernel
 * debian: enable xfs_healer on the root filesystem by default
---
 io/io.h                          |    1 
 libxfs/xfs_fs.h                  |  173 +++++
 libxfs/xfs_health.h              |   52 +
 Makefile                         |    5 
 configure.ac                     |    8 
 debian/control                   |    2 
 debian/postinst                  |    8 
 debian/prerm                     |   13 
 debian/rules                     |    2 
 healer/Makefile                  |   68 ++
 healer/system-xfs_healer.slice   |   31 +
 healer/xfs_healer.py.in          | 1432 ++++++++++++++++++++++++++++++++++++++
 healer/xfs_healer.rules          |    7 
 healer/xfs_healer@.service.in    |  108 +++
 healer/xfs_healer_start          |   17 
 include/builddefs.in             |    5 
 io/Makefile                      |    1 
 io/healthmon.c                   |  183 +++++
 io/init.c                        |    1 
 io/shutdown.c                    |  113 +++
 libxfs/Makefile                  |   10 
 libxfs/xfs_healthmon.schema.json |  648 +++++++++++++++++
 m4/package_services.m4           |   30 -
 man/man8/xfs_healer.8            |   85 ++
 man/man8/xfs_io.8                |   46 +
 scrub/Makefile                   |    7 
 scrub/phase6.c                   |   25 +
 27 files changed, 3054 insertions(+), 27 deletions(-)
 create mode 100644 debian/prerm
 create mode 100644 healer/Makefile
 create mode 100644 healer/system-xfs_healer.slice
 create mode 100644 healer/xfs_healer.py.in
 create mode 100644 healer/xfs_healer.rules
 create mode 100644 healer/xfs_healer@.service.in
 create mode 100755 healer/xfs_healer_start
 create mode 100644 io/healthmon.c
 create mode 100644 libxfs/xfs_healthmon.schema.json
 create mode 100644 man/man8/xfs_healer.8

