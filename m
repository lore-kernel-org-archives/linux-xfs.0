Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6342D7F81
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 09:50:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 52713304070
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 07:50:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id b5j94KlqrK7zsW1Z for
	<xfs@oss.sgi.com>; Mon, 18 Mar 2013 07:49:59 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2IEnwOE026161
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 10:49:58 -0400
Received: from bfoster.bfoster (dhcp-189-135.bos.redhat.com [10.16.189.135])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r2IEnw7X021455
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 10:49:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 4/6] xfs: xfs_dquot prealloc throttling watermarks and low
	free space
Date: Mon, 18 Mar 2013 10:51:46 -0400
Message-Id: <1363618308-53594-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1363618308-53594-1-git-send-email-bfoster@redhat.com>
References: <1363618308-53594-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Enable tracking of high and low watermarks for preallocation
throttling of files under quota restrictions. These values are
calculated when the quota limit is read from disk or modified and
cached for later use by the throttling algorithm.

The high watermark specifies when preallocation is disabled, the
low watermark specifies when throttling is enabled and the low free
space data structure contains precalculated low free space limits
to serve as input to determine the level of throttling required.

Note that the low free space data structure is based on the
existing global low free space data structure with the exception of
using three stages (5%, 3% and 1%) rather than five to reduce the
impact of xfs_dquot memory overhead.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_dquot.c       |   41 +++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_dquot.h       |   12 ++++++++++++
 fs/xfs/xfs_qm.h          |    2 +-
 fs/xfs/xfs_qm_syscalls.c |    9 +++++----
 4 files changed, 57 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 9c5869e..45bb08f 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -90,13 +90,18 @@ xfs_qm_adjust_dqlimits(
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	struct xfs_disk_dquot	*d = &dq->q_core;
+	int			prealloc = 0;
 
 	ASSERT(d->d_id);
 
-	if (q->qi_bsoftlimit && !d->d_blk_softlimit)
+	if (q->qi_bsoftlimit && !d->d_blk_softlimit) {
 		d->d_blk_softlimit = cpu_to_be64(q->qi_bsoftlimit);
-	if (q->qi_bhardlimit && !d->d_blk_hardlimit)
+		prealloc = 1;
+	}
+	if (q->qi_bhardlimit && !d->d_blk_hardlimit) {
 		d->d_blk_hardlimit = cpu_to_be64(q->qi_bhardlimit);
+		prealloc = 1;
+	}
 	if (q->qi_isoftlimit && !d->d_ino_softlimit)
 		d->d_ino_softlimit = cpu_to_be64(q->qi_isoftlimit);
 	if (q->qi_ihardlimit && !d->d_ino_hardlimit)
@@ -105,6 +110,9 @@ xfs_qm_adjust_dqlimits(
 		d->d_rtb_softlimit = cpu_to_be64(q->qi_rtbsoftlimit);
 	if (q->qi_rtbhardlimit && !d->d_rtb_hardlimit)
 		d->d_rtb_hardlimit = cpu_to_be64(q->qi_rtbhardlimit);
+
+	if (prealloc)
+		xfs_dquot_set_prealloc_limits(dq);
 }
 
 /*
@@ -249,6 +257,32 @@ xfs_qm_init_dquot_blk(
 	xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
 }
 
+/*
+ * Initialize the dynamic speculative preallocation thresholds. The lo/hi
+ * watermarks correspond to the soft and hard limits by default. If a soft limit
+ * is not specified, we use 95% of the hard limit.
+ */
+void
+xfs_dquot_set_prealloc_limits(struct xfs_dquot *dqp)
+{
+	__uint64_t space;
+
+	dqp->q_prealloc_hi_wmark = be64_to_cpu(dqp->q_core.d_blk_hardlimit);
+	dqp->q_prealloc_lo_wmark = be64_to_cpu(dqp->q_core.d_blk_softlimit);
+	if (!dqp->q_prealloc_lo_wmark) {
+		dqp->q_prealloc_lo_wmark = dqp->q_prealloc_hi_wmark;
+		do_div(dqp->q_prealloc_lo_wmark, 100);
+		dqp->q_prealloc_lo_wmark *= 95;
+	}
+
+	space = dqp->q_prealloc_hi_wmark;
+
+	do_div(space, 100);
+	dqp->q_low_space[XFS_QLOWSP_1_PCNT] = space;
+	dqp->q_low_space[XFS_QLOWSP_3_PCNT] = space * 3;
+	dqp->q_low_space[XFS_QLOWSP_5_PCNT] = space * 5;
+}
+
 static void
 xfs_dquot_buf_verify(
 	struct xfs_buf		*bp)
@@ -649,6 +683,9 @@ xfs_qm_dqread(
 	dqp->q_res_icount = be64_to_cpu(ddqp->d_icount);
 	dqp->q_res_rtbcount = be64_to_cpu(ddqp->d_rtbcount);
 
+	/* initialize the dquot speculative prealloc thresholds */
+	xfs_dquot_set_prealloc_limits(dqp);
+
 	/* Mark the buf so that this will stay incore a little longer */
 	xfs_buf_set_ref(bp, XFS_DQUOT_REF);
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index f77b711..4f0ebfc 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -32,6 +32,13 @@
 struct xfs_mount;
 struct xfs_trans;
 
+enum {
+	XFS_QLOWSP_1_PCNT = 0,
+	XFS_QLOWSP_3_PCNT,
+	XFS_QLOWSP_5_PCNT,
+	XFS_QLOWSP_MAX
+};
+
 /*
  * The incore dquot structure
  */
@@ -51,6 +58,9 @@ typedef struct xfs_dquot {
 	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
 	xfs_qcnt_t	 q_res_icount;	/* total inos allocd+reserved */
 	xfs_qcnt_t	 q_res_rtbcount;/* total realtime blks used+reserved */
+	xfs_qcnt_t	 q_prealloc_lo_wmark;/* prealloc throttle wmark */
+	xfs_qcnt_t	 q_prealloc_hi_wmark;/* prealloc disabled wmark */
+	int64_t		 q_low_space[XFS_QLOWSP_MAX];
 	struct mutex	 q_qlock;	/* quota lock */
 	struct completion q_flush;	/* flush completion queue */
 	atomic_t          q_pincount;	/* dquot pin count */
@@ -153,6 +163,8 @@ extern void		xfs_qm_dqput(xfs_dquot_t *);
 
 extern void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
 
+extern void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
+
 static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 {
 	xfs_dqlock(dqp);
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 44b858b..82c2108 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -116,7 +116,7 @@ extern void		xfs_qm_dqrele_all_inodes(xfs_mount_t *, uint);
 extern int		xfs_qm_scall_trunc_qfiles(xfs_mount_t *, uint);
 extern int		xfs_qm_scall_getquota(xfs_mount_t *, xfs_dqid_t, uint,
 					fs_disk_quota_t *);
-extern int		xfs_qm_scall_setqlim(xfs_mount_t *, xfs_dqid_t, uint,
+extern int		xfs_qm_scall_setqlim(struct xfs_mount *, xfs_dqid_t, uint,
 					fs_disk_quota_t *);
 extern int		xfs_qm_scall_getqstat(xfs_mount_t *, fs_quota_stat_t *);
 extern int		xfs_qm_scall_quotaon(xfs_mount_t *, uint);
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index cf9a340..c41190c 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -472,15 +472,15 @@ xfs_qm_scall_getqstat(
  */
 int
 xfs_qm_scall_setqlim(
-	xfs_mount_t		*mp,
+	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
 	uint			type,
 	fs_disk_quota_t		*newlim)
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	xfs_disk_dquot_t	*ddq;
-	xfs_dquot_t		*dqp;
-	xfs_trans_t		*tp;
+	struct xfs_disk_dquot	*ddq;
+	struct xfs_dquot	*dqp;
+	struct xfs_trans	*tp;
 	int			error;
 	xfs_qcnt_t		hard, soft;
 
@@ -529,6 +529,7 @@ xfs_qm_scall_setqlim(
 	if (hard == 0 || hard >= soft) {
 		ddq->d_blk_hardlimit = cpu_to_be64(hard);
 		ddq->d_blk_softlimit = cpu_to_be64(soft);
+		xfs_dquot_set_prealloc_limits(dqp);
 		if (id == 0) {
 			q->qi_bhardlimit = hard;
 			q->qi_bsoftlimit = soft;
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
