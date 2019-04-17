Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58678 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfDQWnO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Apr 2019 18:43:14 -0400
Date: Wed, 17 Apr 2019 15:43:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: kill the xfs_dqtrx_t typedef
Message-ID: <20190417224306.GC5072@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

There's only a few uses left, so just kill the typedef while we're at
it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_quota.h       |    4 ++--
 fs/xfs/xfs_trans_dquot.c |   28 ++++++++++++++--------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index f3cf4fcf66e8..efe42ae7a2f3 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -56,7 +56,7 @@ xfs_quota_chkd_flag(
  * The structure kept inside the xfs_trans_t keep track of dquot changes
  * within a transaction and apply them later.
  */
-typedef struct xfs_dqtrx {
+struct xfs_dqtrx {
 	struct xfs_dquot *qt_dquot;	  /* the dquot this refers to */
 
 	uint64_t	qt_blk_res;	  /* blks reserved on a dquot */
@@ -71,7 +71,7 @@ typedef struct xfs_dqtrx {
 	uint64_t	qt_ino_res;	  /* inode reserved on a dquot */
 	uint64_t	qt_ino_res_used;  /* inodes used from the reservation */
 	int64_t		qt_icount_delta;  /* dquot inode count changes */
-} xfs_dqtrx_t;
+};
 
 #ifdef CONFIG_XFS_QUOTA
 extern void xfs_trans_dup_dqinfo(struct xfs_trans *, struct xfs_trans *);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 7d6253528aee..cd664a03613f 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -74,13 +74,13 @@ xfs_trans_log_dquot(
  */
 void
 xfs_trans_dup_dqinfo(
-	xfs_trans_t	*otp,
-	xfs_trans_t	*ntp)
+	struct xfs_trans	*otp,
+	struct xfs_trans	*ntp)
 {
-	xfs_dqtrx_t	*oq, *nq;
-	int		i, j;
-	xfs_dqtrx_t	*oqa, *nqa;
-	uint64_t	blk_res_used;
+	struct xfs_dqtrx	*oq, *nq;
+	int			i, j;
+	struct xfs_dqtrx	*oqa, *nqa;
+	uint64_t		blk_res_used;
 
 	if (!otp->t_dqinfo)
 		return;
@@ -191,12 +191,12 @@ xfs_trans_get_dqtrx(
  */
 void
 xfs_trans_mod_dquot(
-	xfs_trans_t	*tp,
-	xfs_dquot_t	*dqp,
-	uint		field,
-	int64_t		delta)
+	struct xfs_trans	*tp,
+	struct xfs_dquot	*dqp,
+	uint			field,
+	int64_t			delta)
 {
-	xfs_dqtrx_t	*qtrx;
+	struct xfs_dqtrx	*qtrx;
 
 	ASSERT(tp);
 	ASSERT(XFS_IS_QUOTA_RUNNING(tp->t_mountp));
@@ -288,8 +288,8 @@ xfs_trans_mod_dquot(
  */
 STATIC void
 xfs_trans_dqlockedjoin(
-	xfs_trans_t	*tp,
-	xfs_dqtrx_t	*q)
+	struct xfs_trans	*tp,
+	struct xfs_dqtrx	*q)
 {
 	ASSERT(q[0].qt_dquot != NULL);
 	if (q[1].qt_dquot == NULL) {
@@ -501,7 +501,7 @@ xfs_trans_unreserve_and_mod_dquots(
 {
 	int			i, j;
 	xfs_dquot_t		*dqp;
-	xfs_dqtrx_t		*qtrx, *qa;
+	struct xfs_dqtrx	*qtrx, *qa;
 	bool                    locked;
 
 	if (!tp->t_dqinfo || !(tp->t_flags & XFS_TRANS_DQ_DIRTY))
