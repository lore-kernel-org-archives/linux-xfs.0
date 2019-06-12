Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34322 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfFLGtV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 02:49:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6nKaw055709
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:20 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t05nqsbvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6mg4b099172
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2t0p9rq317-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:19 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5C6nIWM030934
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:18 GMT
Subject: [PATCH 2/9] xfs: rename bulkstat functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 11 Jun 2019 23:49:17 -0700
Message-ID: <156032215702.3774581.162933705652978520.stgit@magnolia>
In-Reply-To: <156032214432.3774581.1304900948974476604.stgit@magnolia>
References: <156032214432.3774581.1304900948974476604.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, allison.henderson@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Rename the bulkstat functions to 'fsbulkstat' so that they match the
ioctl names.  We will be introducing a new set of bulkstat/inumbers
ioctls soon, and it will be important to keep the names straight.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/xfs_ioctl.c   |   14 +++++++-------
 fs/xfs/xfs_ioctl.h   |    5 +++--
 fs/xfs/xfs_ioctl32.c |   18 +++++++++---------
 3 files changed, 19 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 34b38d8e8dc9..5e0476003763 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -724,7 +724,7 @@ xfs_ioc_space(
 
 /* Return 0 on success or positive error */
 int
-xfs_bulkstat_one_fmt(
+xfs_fsbulkstat_one_fmt(
 	struct xfs_ibulk	*breq,
 	const struct xfs_bstat	*bstat)
 {
@@ -734,7 +734,7 @@ xfs_bulkstat_one_fmt(
 }
 
 int
-xfs_inumbers_fmt(
+xfs_fsinumbers_fmt(
 	struct xfs_ibulk	*breq,
 	const struct xfs_inogrp	*igrp)
 {
@@ -744,7 +744,7 @@ xfs_inumbers_fmt(
 }
 
 STATIC int
-xfs_ioc_bulkstat(
+xfs_ioc_fsbulkstat(
 	xfs_mount_t		*mp,
 	unsigned int		cmd,
 	void			__user *arg)
@@ -794,16 +794,16 @@ xfs_ioc_bulkstat(
 	 */
 	if (cmd == XFS_IOC_FSINUMBERS) {
 		breq.startino = lastino ? lastino + 1 : 0;
-		error = xfs_inumbers(&breq, xfs_inumbers_fmt);
+		error = xfs_inumbers(&breq, xfs_fsinumbers_fmt);
 		lastino = breq.startino - 1;
 	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE) {
 		breq.startino = lastino;
 		breq.icount = 1;
-		error = xfs_bulkstat_one(&breq, xfs_bulkstat_one_fmt);
+		error = xfs_bulkstat_one(&breq, xfs_fsbulkstat_one_fmt);
 		lastino = breq.startino;
 	} else {	/* XFS_IOC_FSBULKSTAT */
 		breq.startino = lastino ? lastino + 1 : 0;
-		error = xfs_bulkstat(&breq, xfs_bulkstat_one_fmt);
+		error = xfs_bulkstat(&breq, xfs_fsbulkstat_one_fmt);
 		lastino = breq.startino - 1;
 	}
 
@@ -1983,7 +1983,7 @@ xfs_file_ioctl(
 	case XFS_IOC_FSBULKSTAT_SINGLE:
 	case XFS_IOC_FSBULKSTAT:
 	case XFS_IOC_FSINUMBERS:
-		return xfs_ioc_bulkstat(mp, cmd, arg);
+		return xfs_ioc_fsbulkstat(mp, cmd, arg);
 
 	case XFS_IOC_FSGEOMETRY_V1:
 		return xfs_ioc_fsgeometry(mp, arg, 3);
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index fb303eaa8863..cb34bc821201 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -81,7 +81,8 @@ struct xfs_ibulk;
 struct xfs_bstat;
 struct xfs_inogrp;
 
-int xfs_bulkstat_one_fmt(struct xfs_ibulk *breq, const struct xfs_bstat *bstat);
-int xfs_inumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inogrp *igrp);
+int xfs_fsbulkstat_one_fmt(struct xfs_ibulk *breq,
+			   const struct xfs_bstat *bstat);
+int xfs_fsinumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inogrp *igrp);
 
 #endif
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index d69bff304768..464114439a5d 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -86,7 +86,7 @@ xfs_compat_growfs_rt_copyin(
 }
 
 STATIC int
-xfs_inumbers_fmt_compat(
+xfs_fsinumbers_fmt_compat(
 	struct xfs_ibulk	*breq,
 	const struct xfs_inogrp	*igrp)
 {
@@ -101,7 +101,7 @@ xfs_inumbers_fmt_compat(
 }
 
 #else
-#define xfs_inumbers_fmt_compat xfs_inumbers_fmt
+#define xfs_fsinumbers_fmt_compat xfs_fsinumbers_fmt
 #endif	/* BROKEN_X86_ALIGNMENT */
 
 STATIC int
@@ -171,7 +171,7 @@ xfs_bstime_store_compat(
 
 /* Return 0 on success or positive error (to xfs_bulkstat()) */
 STATIC int
-xfs_bulkstat_one_fmt_compat(
+xfs_fsbulkstat_one_fmt_compat(
 	struct xfs_ibulk	*breq,
 	const struct xfs_bstat	*buffer)
 {
@@ -206,7 +206,7 @@ xfs_bulkstat_one_fmt_compat(
 
 /* copied from xfs_ioctl.c */
 STATIC int
-xfs_compat_ioc_bulkstat(
+xfs_compat_ioc_fsbulkstat(
 	xfs_mount_t		  *mp,
 	unsigned int		  cmd,
 	struct compat_xfs_fsop_bulkreq __user *p32)
@@ -226,8 +226,8 @@ xfs_compat_ioc_bulkstat(
 	 * to userpace memory via bulkreq.ubuffer.  Normally the compat
 	 * functions and structure size are the correct ones to use ...
 	 */
-	inumbers_fmt_pf		inumbers_func = xfs_inumbers_fmt_compat;
-	bulkstat_one_fmt_pf	bs_one_func = xfs_bulkstat_one_fmt_compat;
+	inumbers_fmt_pf		inumbers_func = xfs_fsinumbers_fmt_compat;
+	bulkstat_one_fmt_pf	bs_one_func = xfs_fsbulkstat_one_fmt_compat;
 
 #ifdef CONFIG_X86_X32
 	if (in_x32_syscall()) {
@@ -239,8 +239,8 @@ xfs_compat_ioc_bulkstat(
 		 * the data written out in compat layout will not match what
 		 * x32 userspace expects.
 		 */
-		inumbers_func = xfs_inumbers_fmt;
-		bs_one_func = xfs_bulkstat_one_fmt;
+		inumbers_func = xfs_fsinumbers_fmt;
+		bs_one_func = xfs_fsbulkstat_one_fmt;
 	}
 #endif
 
@@ -670,7 +670,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_FSBULKSTAT_32:
 	case XFS_IOC_FSBULKSTAT_SINGLE_32:
 	case XFS_IOC_FSINUMBERS_32:
-		return xfs_compat_ioc_bulkstat(mp, cmd, arg);
+		return xfs_compat_ioc_fsbulkstat(mp, cmd, arg);
 	case XFS_IOC_FD_TO_HANDLE_32:
 	case XFS_IOC_PATH_TO_HANDLE_32:
 	case XFS_IOC_PATH_TO_FSHANDLE_32: {
