Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE61C2BDC0C;
	Mon, 26 Jan 2026 07:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769412101; cv=none; b=n4cr1B0CL9JM18VslYt5jRCDKSWumDkRX0g9hMNblNyFvYXG2SxLpMyhxrVJ8z0thyZ3Xp5hbHzbM153hCZvcFCw69RjnkBcvRy9ZwlagMTyGDIo7BuuxJI6VNy18Lx7wO0Vt7B7dnnIzWfv5klB+oQBweQFf8DaglrZ9O+K9a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769412101; c=relaxed/simple;
	bh=hnkFfRxrdPdIQZghsS6RKZEQ/YOKmr0+lglFC7UGc0U=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=CytRuQIeR2kw9Jamv4pt4UegbwQ7FqG3yGFMb81c5cYp9H/HQfcYPeCQHsDd3c+6MxcbwjmfNCSzq7jQCBk85r7Qj/RdgBGiI7AL3IKmCUbHMLrKTrQHnhxv9Ll+EgIi2Ktq5f93Ro80dgA61Rexm/jBWRMfQCpMpVdHGdT3mlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dW/DPFuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dW/DPFuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707CAC116C6;
	Mon, 26 Jan 2026 07:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769412101;
	bh=hnkFfRxrdPdIQZghsS6RKZEQ/YOKmr0+lglFC7UGc0U=;
	h=Date:Subject:From:To:Cc:From;
	b=dW/DPFuTqRU8Iy919dV60RB7mHxugRewn8jZrWhcLymetga82CcQ8luyRCKcjoTZb
	 2Ex9R/ebFFkZ2RNHTo9BJNw63+6O0RZ4A+645Afl2IZ1SDaHjWsnVVoqe/R0sLosWg
	 2tWN5NGT2dSH+OSMqFS+xxAgUk06/7nrAuvpgogfYvEljFfp2oNm9kohKKfqgshaH7
	 k7Mx+L0szz7Y6Sa+Wmgnu8ldrhlZdaNu7jgWRLpm6fGlN85sIO4d9+SWqqo1IOKu7f
	 QjVLpsvvuSrFNal2tFk+vsU7ttre+eF4+J3xFymxEIHP/Oh8xs9ey722KVWXtZ/miQ
	 d2VtkfUV/CX4g==
Date: Sun, 25 Jan 2026 23:21:40 -0800
Subject: [GIT PULL 1/4] xfs: autonomous self healing of filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, stable@vger.kernel.org
Message-ID: <176919034772.1844314.23527352508595796012.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 7.0-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

Note that this branch is NOT based off the existing xfs-7.0-merge branch;
instead it's based off of brauner's vfs fserror branch.  You could merge it
into xfs-7.0-merge, but you could also push it straight to xfs/xfs-linux.git
and make for-next the merge of xfs-7.0-merge and health-monitoring-7.0 and send
two PRs to Linus.

Note also that you'll need to patch the two new files in this branch to include
xfs_platform.h when merging with the xfs-7.0-merge branch:

diff --git i/fs/xfs/xfs_healthmon.c w/fs/xfs/xfs_healthmon.c
index 3030fa93c1e575..ca7352dcd182fb 100644
--- i/fs/xfs/xfs_healthmon.c
+++ w/fs/xfs/xfs_healthmon.c
@@ -1,12 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
diff --git i/fs/xfs/xfs_verify_media.c w/fs/xfs/xfs_verify_media.c
index f4f620c98d92ca..069cd371619dc2 100644
--- i/fs/xfs/xfs_verify_media.c
+++ w/fs/xfs/xfs_verify_media.c
@@ -1,12 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2026 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_bit.h"

--D

The following changes since commit 347b7042fb26beaae1ea46d0f6c47251fb52985f:

  Merge patch series "fs: generic file IO error reporting" (2026-01-13 09:58:07 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/health-monitoring-7.0_2026-01-20

for you to fetch changes up to b8accfd65d31f25b9df15ec2419179b6fa0b21d5:

  xfs: add media verification ioctl (2026-01-20 18:06:52 -0800)

----------------------------------------------------------------
xfs: autonomous self healing of filesystems [v7]

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

This patchset depends on the new fserror code that Christian Brauner
has tentatively accepted for Linux 7.0:
https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=vfs-7.0.fserror

v7: more cleanups of the media verification ioctl, improve comments, and
    reuse the bio
v6: fix pi-breaking bugs, make verify failures trigger health reports
    and filter bio status flags better
v5: add verify-media ioctl, collapse small helper funcs with only
    one caller
v4: drop multiple client support so we can make direct calls into
    healthmon instead of chasing pointers and doing indirect calls
v3: drag out of rfc status

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (10):
      xfs: start creating infrastructure for health monitoring
      xfs: create event queuing, formatting, and discovery infrastructure
      xfs: convey filesystem unmount events to the health monitor
      xfs: convey metadata health events to the health monitor
      xfs: convey filesystem shutdown events to the health monitor
      xfs: convey externally discovered fsdax media errors to the health monitor
      xfs: convey file I/O errors to the health monitor
      xfs: allow toggling verbose logging on the health monitoring file
      xfs: check if an open file is on the health monitored fs
      xfs: add media verification ioctl

 fs/xfs/libxfs/xfs_fs.h      |  189 +++++++
 fs/xfs/libxfs/xfs_health.h  |    5 +
 fs/xfs/xfs_healthmon.h      |  184 +++++++
 fs/xfs/xfs_mount.h          |    4 +
 fs/xfs/xfs_trace.h          |  512 ++++++++++++++++++
 fs/xfs/xfs_verify_media.h   |   13 +
 fs/xfs/Makefile             |    2 +
 fs/xfs/xfs_fsops.c          |    2 +
 fs/xfs/xfs_health.c         |  124 +++++
 fs/xfs/xfs_healthmon.c      | 1255 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c          |    7 +
 fs/xfs/xfs_mount.c          |    2 +
 fs/xfs/xfs_notify_failure.c |   17 +-
 fs/xfs/xfs_super.c          |   12 +
 fs/xfs/xfs_trace.c          |    5 +
 fs/xfs/xfs_verify_media.c   |  445 +++++++++++++++
 16 files changed, 2773 insertions(+), 5 deletions(-)
 create mode 100644 fs/xfs/xfs_healthmon.h
 create mode 100644 fs/xfs/xfs_verify_media.h
 create mode 100644 fs/xfs/xfs_healthmon.c
 create mode 100644 fs/xfs/xfs_verify_media.c
