Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37938 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728514AbfDQBjw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Apr 2019 21:39:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3H1d62E097476
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:39:51 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2rusnewxk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:39:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3H1c8XX048731
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:39:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2rv2tv31wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:39:50 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3H1dn6w008201
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:39:50 GMT
Subject: [PATCH 1/2] xfs: widen quota block counters to 64-bit integers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 16 Apr 2019 18:39:48 -0700
Message-ID: <155546518873.176148.11756573764233413857.stgit@magnolia>
In-Reply-To: <155546518260.176148.16583864799178682873.stgit@magnolia>
References: <155546518260.176148.16583864799178682873.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Widen the incore quota transaction delta structure to treat block
counters as 64-bit integers.  This is a necessary addition so that we
can widen the i_delayed_blks counter to be a 64-bit integer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_qm.h          |    8 ++------
 fs/xfs/xfs_quota.h       |   31 +++++++++++++++++--------------
 fs/xfs/xfs_trans_dquot.c |   28 ++++++++++++++--------------
 3 files changed, 33 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 3ccf0fbc9071..b41b75089548 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -113,12 +113,8 @@ xfs_quota_inode(xfs_mount_t *mp, uint dq_flags)
 	return NULL;
 }
 
-extern void	xfs_trans_mod_dquot(struct xfs_trans *,
-					struct xfs_dquot *, uint, long);
-extern int	xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
-			struct xfs_mount *, struct xfs_dquot *,
-			struct xfs_dquot *, struct xfs_dquot *,
-			long, long, uint);
+extern void	xfs_trans_mod_dquot(struct xfs_trans *tp, struct xfs_dquot *dqp,
+				    uint field, int64_t delta);
 extern void	xfs_trans_dqjoin(struct xfs_trans *, struct xfs_dquot *);
 extern void	xfs_trans_log_dquot(struct xfs_trans *, struct xfs_dquot *);
 
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 55b798265ef7..215cb39e3a04 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -58,30 +58,33 @@ xfs_quota_chkd_flag(
  */
 typedef struct xfs_dqtrx {
 	struct xfs_dquot *qt_dquot;	  /* the dquot this refers to */
-	ulong		qt_blk_res;	  /* blks reserved on a dquot */
-	ulong		qt_ino_res;	  /* inode reserved on a dquot */
-	ulong		qt_ino_res_used;  /* inodes used from the reservation */
-	long		qt_bcount_delta;  /* dquot blk count changes */
-	long		qt_delbcnt_delta; /* delayed dquot blk count changes */
+
+	uint64_t	qt_blk_res;	  /* blks reserved on a dquot */
+	int64_t		qt_bcount_delta;  /* dquot blk count changes */
+	int64_t		qt_delbcnt_delta; /* delayed dquot blk count changes */
+
+	uint64_t	qt_rtblk_res;	  /* # blks reserved on a dquot */
+	uint64_t	qt_rtblk_res_used;/* # blks used from reservation */
+	int64_t		qt_rtbcount_delta;/* dquot realtime blk changes */
+	int64_t		qt_delrtb_delta;  /* delayed RT blk count changes */
+
+	unsigned long	qt_ino_res;	  /* inode reserved on a dquot */
+	unsigned long	qt_ino_res_used;  /* inodes used from the reservation */
 	long		qt_icount_delta;  /* dquot inode count changes */
-	ulong		qt_rtblk_res;	  /* # blks reserved on a dquot */
-	ulong		qt_rtblk_res_used;/* # blks used from reservation */
-	long		qt_rtbcount_delta;/* dquot realtime blk changes */
-	long		qt_delrtb_delta;  /* delayed RT blk count changes */
 } xfs_dqtrx_t;
 
 #ifdef CONFIG_XFS_QUOTA
 extern void xfs_trans_dup_dqinfo(struct xfs_trans *, struct xfs_trans *);
 extern void xfs_trans_free_dqinfo(struct xfs_trans *);
 extern void xfs_trans_mod_dquot_byino(struct xfs_trans *, struct xfs_inode *,
-		uint, long);
+		uint, int64_t);
 extern void xfs_trans_apply_dquot_deltas(struct xfs_trans *);
 extern void xfs_trans_unreserve_and_mod_dquots(struct xfs_trans *);
 extern int xfs_trans_reserve_quota_nblks(struct xfs_trans *,
-		struct xfs_inode *, long, long, uint);
+		struct xfs_inode *, int64_t, long, uint);
 extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
 		struct xfs_mount *, struct xfs_dquot *,
-		struct xfs_dquot *, struct xfs_dquot *, long, long, uint);
+		struct xfs_dquot *, struct xfs_dquot *, int64_t, long, uint);
 
 extern int xfs_qm_vop_dqalloc(struct xfs_inode *, xfs_dqid_t, xfs_dqid_t,
 		prid_t, uint, struct xfs_dquot **, struct xfs_dquot **,
@@ -121,14 +124,14 @@ xfs_qm_vop_dqalloc(struct xfs_inode *ip, xfs_dqid_t uid, xfs_dqid_t gid,
 #define xfs_trans_apply_dquot_deltas(tp)
 #define xfs_trans_unreserve_and_mod_dquots(tp)
 static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
-		struct xfs_inode *ip, long nblks, long ninos, uint flags)
+		struct xfs_inode *ip, int64_t nblks, long ninos, uint flags)
 {
 	return 0;
 }
 static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
 		struct xfs_mount *mp, struct xfs_dquot *udqp,
 		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp,
-		long nblks, long nions, uint flags)
+		int64_t nblks, long nions, uint flags)
 {
 	return 0;
 }
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index c23257a26c2b..840ec456c9a8 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -80,7 +80,7 @@ xfs_trans_dup_dqinfo(
 	xfs_dqtrx_t	*oq, *nq;
 	int		i, j;
 	xfs_dqtrx_t	*oqa, *nqa;
-	ulong		blk_res_used;
+	uint64_t	blk_res_used;
 
 	if (!otp->t_dqinfo)
 		return;
@@ -137,7 +137,7 @@ xfs_trans_mod_dquot_byino(
 	xfs_trans_t	*tp,
 	xfs_inode_t	*ip,
 	uint		field,
-	long		delta)
+	int64_t		delta)
 {
 	xfs_mount_t	*mp = tp->t_mountp;
 
@@ -194,7 +194,7 @@ xfs_trans_mod_dquot(
 	xfs_trans_t	*tp,
 	xfs_dquot_t	*dqp,
 	uint		field,
-	long		delta)
+	int64_t		delta)
 {
 	xfs_dqtrx_t	*qtrx;
 
@@ -219,14 +219,14 @@ xfs_trans_mod_dquot(
 		 * regular disk blk reservation
 		 */
 	      case XFS_TRANS_DQ_RES_BLKS:
-		qtrx->qt_blk_res += (ulong)delta;
+		qtrx->qt_blk_res += delta;
 		break;
 
 		/*
 		 * inode reservation
 		 */
 	      case XFS_TRANS_DQ_RES_INOS:
-		qtrx->qt_ino_res += (ulong)delta;
+		qtrx->qt_ino_res += (unsigned long)delta;
 		break;
 
 		/*
@@ -245,7 +245,7 @@ xfs_trans_mod_dquot(
 		 */
 	      case XFS_TRANS_DQ_ICOUNT:
 		if (qtrx->qt_ino_res && delta > 0) {
-			qtrx->qt_ino_res_used += (ulong)delta;
+			qtrx->qt_ino_res_used += (unsigned long)delta;
 			ASSERT(qtrx->qt_ino_res >= qtrx->qt_ino_res_used);
 		}
 		qtrx->qt_icount_delta += delta;
@@ -255,7 +255,7 @@ xfs_trans_mod_dquot(
 		 * rtblk reservation
 		 */
 	      case XFS_TRANS_DQ_RES_RTBLKS:
-		qtrx->qt_rtblk_res += (ulong)delta;
+		qtrx->qt_rtblk_res += delta;
 		break;
 
 		/*
@@ -263,7 +263,7 @@ xfs_trans_mod_dquot(
 		 */
 	      case XFS_TRANS_DQ_RTBCOUNT:
 		if (qtrx->qt_rtblk_res && delta > 0) {
-			qtrx->qt_rtblk_res_used += (ulong)delta;
+			qtrx->qt_rtblk_res_used += delta;
 			ASSERT(qtrx->qt_rtblk_res >= qtrx->qt_rtblk_res_used);
 		}
 		qtrx->qt_rtbcount_delta += delta;
@@ -320,8 +320,8 @@ xfs_trans_apply_dquot_deltas(
 	struct xfs_dquot	*dqp;
 	struct xfs_dqtrx	*qtrx, *qa;
 	struct xfs_disk_dquot	*d;
-	long			totalbdelta;
-	long			totalrtbdelta;
+	int64_t			totalbdelta;
+	int64_t			totalrtbdelta;
 
 	if (!(tp->t_flags & XFS_TRANS_DQ_DIRTY))
 		return;
@@ -413,7 +413,7 @@ xfs_trans_apply_dquot_deltas(
 			 * reservation that a transaction structure knows of.
 			 */
 			if (qtrx->qt_blk_res != 0) {
-				ulong blk_res_used = 0;
+				uint64_t	blk_res_used = 0;
 
 				if (qtrx->qt_bcount_delta > 0)
 					blk_res_used = qtrx->qt_bcount_delta;
@@ -585,7 +585,7 @@ xfs_trans_dqresv(
 	xfs_trans_t	*tp,
 	xfs_mount_t	*mp,
 	xfs_dquot_t	*dqp,
-	long		nblks,
+	int64_t		nblks,
 	long		ninos,
 	uint		flags)
 {
@@ -745,7 +745,7 @@ xfs_trans_reserve_quota_bydquots(
 	struct xfs_dquot	*udqp,
 	struct xfs_dquot	*gdqp,
 	struct xfs_dquot	*pdqp,
-	long			nblks,
+	int64_t			nblks,
 	long			ninos,
 	uint			flags)
 {
@@ -804,7 +804,7 @@ int
 xfs_trans_reserve_quota_nblks(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
-	long			nblks,
+	int64_t			nblks,
 	long			ninos,
 	uint			flags)
 {
