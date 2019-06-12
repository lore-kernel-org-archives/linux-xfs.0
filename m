Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34490 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfFLGte (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 02:49:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6miGZ055077
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:33 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t05nqsbw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6n5tW178668
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2t1jphuw0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:32 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5C6nVOw014914
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:31 GMT
Subject: [PATCH 4/9] xfs: introduce v5 inode group structure
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 11 Jun 2019 23:49:29 -0700
Message-ID: <156032216980.3774581.8469638497602123307.stgit@magnolia>
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

Introduce a new "v5" inode group structure that fixes the alignment
and padding problems of the existing structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   11 +++++++++++
 fs/xfs/xfs_ioctl.c     |    9 ++++++---
 fs/xfs/xfs_ioctl.h     |    2 +-
 fs/xfs/xfs_ioctl32.c   |   10 +++++++---
 fs/xfs/xfs_itable.c    |   14 +++++++++++++-
 fs/xfs/xfs_itable.h    |    3 ++-
 fs/xfs/xfs_ondisk.h    |    1 +
 7 files changed, 41 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 132e364eb141..8b8fe78511fb 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -445,6 +445,17 @@ struct xfs_inogrp {
 	__u64		xi_allocmask;	/* mask of allocated inodes	*/
 };
 
+/* New inumbers structure that reports v5 features and fixes padding issues */
+struct xfs_inumbers {
+	uint64_t	xi_startino;	/* starting inode number	*/
+	uint64_t	xi_allocmask;	/* mask of allocated inodes	*/
+	uint8_t		xi_alloccount;	/* # bits set in allocmask	*/
+	uint8_t		xi_version;	/* version			*/
+	uint8_t		xi_padding[6];	/* zero				*/
+};
+
+#define XFS_INUMBERS_VERSION_V1	(1)
+#define XFS_INUMBERS_VERSION_V5	(5)
 
 /*
  * Error injection.
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0b8c631d53dd..47580762e154 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -738,10 +738,13 @@ xfs_fsbulkstat_one_fmt(
 
 int
 xfs_fsinumbers_fmt(
-	struct xfs_ibulk	*breq,
-	const struct xfs_inogrp	*igrp)
+	struct xfs_ibulk		*breq,
+	const struct xfs_inumbers	*igrp)
 {
-	if (copy_to_user(breq->ubuffer, igrp, sizeof(*igrp)))
+	struct xfs_inogrp		ig1;
+
+	xfs_inumbers_to_inogrp(&ig1, igrp);
+	if (copy_to_user(breq->ubuffer, &ig1, sizeof(struct xfs_inogrp)))
 		return -EFAULT;
 	return xfs_ibulk_advance(breq, sizeof(struct xfs_inogrp));
 }
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index 514d3028a134..654c0bb1bcf8 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -83,6 +83,6 @@ struct xfs_inogrp;
 
 int xfs_fsbulkstat_one_fmt(struct xfs_ibulk *breq,
 			   const struct xfs_bulkstat *bstat);
-int xfs_fsinumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inogrp *igrp);
+int xfs_fsinumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inumbers *igrp);
 
 #endif
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index ecc8109a3e96..4c1fcf38a983 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -87,10 +87,14 @@ xfs_compat_growfs_rt_copyin(
 
 STATIC int
 xfs_fsinumbers_fmt_compat(
-	struct xfs_ibulk	*breq,
-	const struct xfs_inogrp	*igrp)
+	struct xfs_ibulk		*breq,
+	const struct xfs_inumbers	*ig)
 {
-	struct compat_xfs_inogrp __user *p32 = breq->ubuffer;
+	struct compat_xfs_inogrp __user	*p32 = breq->ubuffer;
+	struct xfs_inogrp		ig1;
+	struct xfs_inogrp		*igrp = &ig1;
+
+	xfs_inumbers_to_inogrp(&ig1, ig);
 
 	if (put_user(igrp->xi_startino,   &p32->xi_startino) ||
 	    put_user(igrp->xi_alloccount, &p32->xi_alloccount) ||
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 7993566bd4a1..1ff95bba971f 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -332,10 +332,11 @@ xfs_inumbers_walk(
 	const struct xfs_inobt_rec_incore *irec,
 	void			*data)
 {
-	struct xfs_inogrp	inogrp = {
+	struct xfs_inumbers	inogrp = {
 		.xi_startino	= XFS_AGINO_TO_INO(mp, agno, irec->ir_startino),
 		.xi_alloccount	= irec->ir_count - irec->ir_freecount,
 		.xi_allocmask	= ~irec->ir_free,
+		.xi_version	= XFS_INUMBERS_VERSION_V5,
 	};
 	struct xfs_inumbers_chunk *ic = data;
 	xfs_agino_t		agino;
@@ -384,3 +385,14 @@ xfs_inumbers(
 
 	return error;
 }
+
+/* Convert an inumbers (v5) struct to a inogrp (v1) struct. */
+void
+xfs_inumbers_to_inogrp(
+	struct xfs_inogrp		*ig1,
+	const struct xfs_inumbers	*ig)
+{
+	ig1->xi_startino = ig->xi_startino;
+	ig1->xi_alloccount = ig->xi_alloccount;
+	ig1->xi_allocmask = ig->xi_allocmask;
+}
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index e2a448f69e24..d41a0a8a326c 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -49,8 +49,9 @@ void xfs_bulkstat_to_bstat(struct xfs_mount *mp, struct xfs_bstat *bs1,
 		const struct xfs_bulkstat *bstat);
 
 typedef int (*inumbers_fmt_pf)(struct xfs_ibulk *breq,
-		const struct xfs_inogrp *igrp);
+		const struct xfs_inumbers *igrp);
 
 int xfs_inumbers(struct xfs_ibulk *breq, inumbers_fmt_pf formatter);
+void xfs_inumbers_to_inogrp(struct xfs_inogrp *ig1, const struct xfs_inumbers *ig);
 
 #endif	/* __XFS_ITABLE_H__ */
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 0b4cdda68524..d8f941b4d51c 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -148,6 +148,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(struct xfs_attr3_leafblock, hdr.info.hdr, 0);
 
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
 }
 
 #endif /* __XFS_ONDISK_H */
