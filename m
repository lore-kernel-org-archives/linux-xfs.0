Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f194.google.com ([209.85.166.194]:35070 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbeLOBWX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Dec 2018 20:22:23 -0500
Received: by mail-it1-f194.google.com with SMTP id p197so12345377itp.0
        for <linux-xfs@vger.kernel.org>; Fri, 14 Dec 2018 17:22:23 -0800 (PST)
From: Nick Bowler <nbowler@draconx.ca>
Subject: [RFC PATCH v2 3/3] xfs: Fix x32 ioctls when cmd numbers differ from ia32.
Date: Fri, 14 Dec 2018 20:22:59 -0500
Message-Id: <20181215012259.28358-4-nbowler@draconx.ca>
In-Reply-To: <20181215012259.28358-1-nbowler@draconx.ca>
References: <20181215012259.28358-1-nbowler@draconx.ca>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

Several ioctl structs change size between native 32-bit (ia32) and x32
applications, because x32 follows the native 64-bit (amd64) integer
alignment rules and uses 64-bit time_t.  In these instances, the ioctl
number changes so userspace simply gets -ENOTTY.  This scenario can be
handled by simply adding more cases.

Looking at the different ioctls implemented here:

- All the ones marked 'No size or alignment issue on any arch' should
  presumably all be fine.

- All the ones under BROKEN_X86_ALIGNMENT are different under integer
  alignment rules.  Since x32 matches amd64 here, we just need both
  sets of cases handled.

- XFS_IOC_SWAPEXT has both integer alignment differences and time_t
  differences.  Since x32 matches amd64 here, we need to add a case
  which calls the native implementation.

- The remaining ioctls have neither 64-bit integers nor time_t, so
  x32 matches ia32 here and no change is required at this level.  The
  bulkstat ioctl implementations have some pointer chasing which is
  handled separately.

Signed-off-by: Nick Bowler <nbowler@draconx.ca>
---
 fs/xfs/xfs_ioctl32.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 1cdc75dca779..bd9ffad0f65e 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -579,8 +579,12 @@ xfs_file_compat_ioctl(
 	case FS_IOC_GETFSMAP:
 	case XFS_IOC_SCRUB_METADATA:
 		return xfs_file_ioctl(filp, cmd, p);
-#ifndef BROKEN_X86_ALIGNMENT
-	/* These are handled fine if no alignment issues */
+#if !defined(BROKEN_X86_ALIGNMENT) || defined(CONFIG_X86_X32)
+	/*
+	 * These are handled fine if no alignment issues.  To support x32
+	 * which uses native 64-bit alignment we must emit these cases in
+	 * addition to the ia-32 compat set below.
+	 */
 	case XFS_IOC_ALLOCSP:
 	case XFS_IOC_FREESP:
 	case XFS_IOC_RESVSP:
@@ -593,8 +597,16 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_FSGROWFSDATA:
 	case XFS_IOC_FSGROWFSRT:
 	case XFS_IOC_ZERO_RANGE:
+#ifdef CONFIG_X86_X32
+	/*
+	 * x32 special: this gets a different cmd number from the ia-32 compat
+	 * case below; the associated data will match native 64-bit alignment.
+	 */
+	case XFS_IOC_SWAPEXT:
+#endif
 		return xfs_file_ioctl(filp, cmd, p);
-#else
+#endif
+#if defined(BROKEN_X86_ALIGNMENT)
 	case XFS_IOC_ALLOCSP_32:
 	case XFS_IOC_FREESP_32:
 	case XFS_IOC_ALLOCSP64_32:
-- 
2.16.1
