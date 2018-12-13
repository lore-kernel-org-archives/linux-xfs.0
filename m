Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f66.google.com ([209.85.166.66]:45342 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbeLMB0t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Dec 2018 20:26:49 -0500
Received: by mail-io1-f66.google.com with SMTP id n3so287267iog.12
        for <linux-xfs@vger.kernel.org>; Wed, 12 Dec 2018 17:26:48 -0800 (PST)
From: Nick Bowler <nbowler@draconx.ca>
Subject: [RFC PATCH 1/2] xfs: Fix bulkstat compat ioctls on x32 userspace.
Date: Wed, 12 Dec 2018 20:29:59 -0500
Message-Id: <20181213013000.15716-2-nbowler@draconx.ca>
In-Reply-To: <20181213013000.15716-1-nbowler@draconx.ca>
References: <20181213013000.15716-1-nbowler@draconx.ca>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

The bulkstat family of ioctls are problematic on x32, because there is
a mixup of native 32-bit and 64-bit conventions: the xfs_bulkstat struct
contains pointers and 32-bit integers so that fits the native 32-bit
layout fine.  However, one of those pointers is subsequently used to
refer to one of several structs which, on x32, all follow the native
64-bit way.

Fortunately the pointer chasing seems to end there, and the functions to
deal with this abstract things pretty well.  We just need a little tweak
to pass the right formatting function if called from x32 mode.

Signed-off-by: Nick Bowler <nbowler@draconx.ca>
---
 fs/xfs/xfs_ioctl32.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index fba115f4103a..6a759c0ffb54 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -241,6 +241,23 @@ xfs_compat_ioc_bulkstat(
 	int			done;
 	int			error;
 
+	/*
+	 * These functions and size are used later to handle individual
+	 * entries; x32 is annoying and needs different functions.
+	 */
+	inumbers_fmt_pf inumbers_func = xfs_inumbers_fmt_compat;
+	bulkstat_one_pf	bs_one_func = xfs_bulkstat_one_compat;
+	size_t bs_one_size = sizeof(compat_xfs_bstat_t);
+
+#ifdef CONFIG_X86_X32
+	if (in_x32_syscall()) {
+		/* x32 matches native amd64 bstat and inogrp layout */
+		inumbers_func = xfs_inumbers_fmt;
+		bs_one_func = xfs_bulkstat_one;
+		bs_one_size = sizeof(xfs_bstat_t);
+	}
+#endif
+
 	/* done = 1 if there are more stats to get and if bulkstat */
 	/* should be called again (unused here, but used in dmapi) */
 
@@ -272,15 +289,15 @@ xfs_compat_ioc_bulkstat(
 
 	if (cmd == XFS_IOC_FSINUMBERS_32) {
 		error = xfs_inumbers(mp, &inlast, &count,
-				bulkreq.ubuffer, xfs_inumbers_fmt_compat);
+				bulkreq.ubuffer, inumbers_func);
 	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE_32) {
 		int res;
 
-		error = xfs_bulkstat_one_compat(mp, inlast, bulkreq.ubuffer,
-				sizeof(compat_xfs_bstat_t), NULL, &res);
+		error = bs_one_func(mp, inlast, bulkreq.ubuffer,
+				bs_one_size, NULL, &res);
 	} else if (cmd == XFS_IOC_FSBULKSTAT_32) {
 		error = xfs_bulkstat(mp, &inlast, &count,
-			xfs_bulkstat_one_compat, sizeof(compat_xfs_bstat_t),
+			bs_one_func, bs_one_size,
 			bulkreq.ubuffer, &done);
 	} else
 		error = -EINVAL;
-- 
2.16.1
