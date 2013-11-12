Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 454CE7F6A
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 03:29:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2F753304039
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 01:29:01 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id EBoRCg93u1PAyzDi (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 01:28:59 -0800 (PST)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAC9Swj6032022
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 09:28:59 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAC9Swlu027282
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 09:28:58 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAC9SwCf027272 for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 09:28:58 GMT
Message-ID: <5281F527.3040200@oracle.com>
Date: Tue, 12 Nov 2013 17:30:15 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [RFC PATCH 4/4] xfs: implement parallism quota check
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

XFS does quota check at mount time with a single thread if required,
and this process must done before a successful file system mount.
That is fun if the desired quota options has been enabled when user
creating/removing files, however, it need to travel the whole file
system to figure out the quota usages if previously those options
were not enabled.  Hence, the mount procedure will stuck for a long
time depending on the how many inodes resides on the storage as well
as the disk IO speed.

This patch is implement parallism quota check based on allocation
groups, therefore the quota check is performed among each AG via
work queues combine with a completion.  In this way, I can observed
significant speedup on faster devices.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/xfs/xfs_qm.c |  357 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_qm.h |   18 +++
 2 files changed, 359 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 14a4996..110df7b 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -35,8 +35,11 @@
 #include "xfs_trans.h"
 #include "xfs_trans_space.h"
 #include "xfs_qm.h"
+#include "xfs_btree.h"
+#include "xfs_ialloc_btree.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_inum.h"
 #include "xfs_cksum.h"
 #include "xfs_dinode.h"
 
@@ -51,6 +54,9 @@ STATIC int	xfs_qm_init_quotainfo(xfs_mount_t *);
 
 
 STATIC void	xfs_qm_dqfree_one(struct xfs_dquot *dqp);
+STATIC int	xfs_qm_dqusage_adjust(struct xfs_mount *mp, xfs_ino_t ino,
+				      int *res);
+
 /*
  * We use the batch lookup interface to iterate over the dquots as it
  * currently is the only interface into the radix tree code that allows
@@ -1349,9 +1355,6 @@ STATIC int
 xfs_qm_dqusage_adjust(
 	xfs_mount_t	*mp,		/* mount point for filesystem */
 	xfs_ino_t	ino,		/* inode number to get data for */
-	void		__user *buffer,	/* not used */
-	int		ubsize,		/* not used */
-	int		*ubused,	/* not used */
 	int		*res)		/* result code value */
 {
 	xfs_inode_t	*ip;
@@ -1439,6 +1442,337 @@ error0:
 	return error;
 }
 
+static int
+xfs_qm_dqusage_adjust_ichunk(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t			agno,
+	struct xfs_inobt_rec_incore	*irbp,
+	xfs_ino_t			*lastinop)
+{
+	xfs_ino_t			lastino = *lastinop;
+	int				chunkidx, clustidx;
+	int				error = 0;
+	xfs_agino_t			agino;
+
+	for (agino = irbp->ir_startino, chunkidx = clustidx = 0;
+	     irbp->ir_freecount < XFS_INODES_PER_CHUNK;
+	     chunkidx++, clustidx++, agino++) {
+		xfs_ino_t	ino = XFS_AGINO_TO_INO(mp, agno, agino);
+		int		stat;
+
+		ASSERT(chunkidx < XFS_INODES_PER_CHUNK);
+
+		/* Skip if this inode is free */
+		if (XFS_INOBT_MASK(chunkidx) & irbp->ir_free) {
+			lastino = ino;
+			continue;
+		}
+
+		/*
+		 * Count used inodes as free so we can tell when the
+		 * chunk is used up.
+		 */
+		irbp->ir_freecount++;
+
+		error = xfs_qm_dqusage_adjust(mp, ino, &stat);
+		if (stat == BULKSTAT_RV_NOTHING) {
+			if (error && error != ENOENT && error != EINVAL)
+				break;
+
+			lastino = ino;
+			continue;
+		}
+		if (stat == BULKSTAT_RV_GIVEUP) {
+			ASSERT(error);
+			break;
+		}
+		lastino = ino;
+	}
+
+	*lastinop = lastino;
+	return error;
+}
+
+static int
+xfs_qm_dqusage_adjust_perag(
+	struct xfs_dq_adjuster	*qa)
+{
+	struct xfs_mount	*mp = qa->qa_mp;
+	xfs_agnumber_t		agno = qa->qa_agno;
+	xfs_inobt_rec_incore_t	*irbp;	/* current irec buffer pointer */
+	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
+	xfs_inobt_rec_incore_t	*irbufend; /* end of good irec buffer entries */
+	xfs_btree_cur_t		*cur;	/* btree cursor for ialloc btree */
+	xfs_ino_t		lastino;/* last inode # in question */
+	xfs_agino_t		agino;	/* inode # in allocation group */
+	size_t			irbsize; /* size of irec buffer in bytes */
+	int			nirbuf;	/* size of irbuf */
+	int			rval;	/* return value error code */
+	int			error;	/* error code */
+
+	irbuf = kmem_zalloc_greedy(&irbsize, PAGE_SIZE, PAGE_SIZE * 4);
+	if (!irbuf)
+		return ENOMEM;
+	nirbuf = irbsize / sizeof(*irbuf);
+
+	rval = 0;
+	agino = 0;
+	lastino = 0;
+
+	/*
+	 * Loop over the allocation groups, starting from the last
+	 * inode returned; 0 means start of the allocation group.
+	 */
+	do {
+		xfs_buf_t	*agbp;	/* agi header buffer */
+		xfs_agi_t	*agi;	/* agi header data */
+		int		stat;	/* result value from btree calls */
+		bool		end_of_ag = false;
+
+		cond_resched();
+
+		irbp = irbuf;
+		irbufend = irbuf + nirbuf;
+
+		error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
+		if (error) {
+			rval = error;
+			break;
+		}
+		agi = XFS_BUF_TO_AGI(agbp);
+
+		/* Allocate and initialize a btree cursor for ialloc btree */
+		cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno);
+		error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE, &stat);
+
+		/*
+		 * Loop through inode btree records in this ag until we run out
+		 * of inodes or space in the buffer.
+		 */
+		while (irbp < irbufend) {
+			xfs_inobt_rec_incore_t r;
+
+			/* Loop as long as we're unable to read the inode btree */
+			while (error) {
+				agino += XFS_INODES_PER_CHUNK;
+				if (XFS_AGINO_TO_AGBNO(mp, agino) >=
+				    be32_to_cpu(agi->agi_length))
+					break;
+
+				error = xfs_inobt_lookup(cur, agino,
+							 XFS_LOOKUP_GE, &stat);
+				cond_resched();
+			}
+
+			/*
+			 * If ran off the end of the ag either with an error,
+			 * or the normal way, set end and stop collecting.
+			 */
+			if (error) {
+				end_of_ag = true;
+				break;
+			}
+
+			error = xfs_inobt_get_rec(cur, &r, &stat);
+			if (error || stat == 0) {
+				end_of_ag = true;
+				break;
+			}
+
+			/*
+			 * If this chunk has any allocated inodes, save it.
+			 * Also start read-ahead now for this chunk.
+			 */
+			if (r.ir_freecount < XFS_INODES_PER_CHUNK) {
+				struct blk_plug plug;
+
+				blk_start_plug(&plug);
+				xfs_inobt_reada_chunk(mp, agno, &r);
+				blk_finish_plug(&plug);
+
+				irbp->ir_startino = r.ir_startino;
+				irbp->ir_freecount = r.ir_freecount;
+				irbp->ir_free = r.ir_free;
+				irbp++;
+			}
+
+			/* Set agino to after this chunk and bump the cursor */
+			agino = r.ir_startino + XFS_INODES_PER_CHUNK;
+			error = xfs_btree_increment(cur, 0, &stat);
+			cond_resched();
+		}
+
+		/*
+		 * Drop the btree buffers and the agi buffer.  We can't hold
+		 * any of the locks these represent when calling iget.
+		 */
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		xfs_buf_relse(agbp);
+
+		irbufend = irbp;
+		for (irbp = irbuf; irbp < irbufend; irbp++) {
+			error = xfs_qm_dqusage_adjust_ichunk(mp, agno, irbp, &lastino);
+			if (error)
+				rval = error;
+			cond_resched();
+		}
+
+		if (end_of_ag)
+			break;
+
+		/* Set up for the next loop iteration */
+		agino = XFS_INO_TO_AGINO(mp, lastino);
+	} while (1);
+
+	/* Done, we're either out of filesystem or space to put the data */
+	kmem_free(irbuf);
+
+	return rval;
+}
+
+/*
+ * Iterate thru the file system to fetch all the inodes in the given
+ * inode range and adjusting the corresponding dquot counters in core.
+ */
+STATIC void
+xfs_qm_dq_adjust_worker(
+	struct work_struct	*work)
+{
+	struct xfs_dq_adjuster	*qa = container_of(work,
+				      struct xfs_dq_adjuster, qa_work);
+	int			error;
+
+	error = xfs_qm_dqusage_adjust_perag(qa);
+	complete(&qa->qa_complete);
+}
+
+STATIC int
+xfs_qm_init_quotacheck(
+	struct xfs_mount	*mp,
+	struct xfs_quotacheck	*qc)
+{
+	memset(qc, 0, sizeof(*qc));
+
+	INIT_LIST_HEAD(&qc->qc_adjusters);
+	spin_lock_init(&qc->qc_lock);
+	qc->qc_mp = mp;
+	qc->qc_wq = alloc_workqueue("xfs-dqcheck/%s", WQ_NON_REENTRANT,
+				    0, mp->m_fsname);
+	if (!qc->qc_wq) {
+		list_del(&qc->qc_adjusters);
+		return ENOMEM;
+	}
+
+	return 0;
+}
+
+STATIC void
+xfs_qm_destroy_quotacheck(
+	struct xfs_quotacheck	*qc)
+{
+	destroy_workqueue(qc->qc_wq);
+	spinlock_destroy(&qc->qc_lock);
+	list_del(&qc->qc_adjusters);
+}
+
+STATIC void
+xfs_qm_destroy_adjusters(
+	struct xfs_quotacheck	*qc)
+{
+	struct xfs_dq_adjuster	*qa, *tmp;
+
+	list_for_each_entry_safe(qa, tmp, &qc->qc_adjusters, qa_node) {
+		list_del(&qa->qa_node);
+		kfree(qa);
+	}
+}
+
+STATIC struct xfs_dq_adjuster *
+xfs_qm_alloc_adjuster(
+	struct xfs_quotacheck	*qc,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_dq_adjuster	*qa;
+
+	qa = kzalloc(sizeof(*qa), GFP_NOFS);
+	if (!qa)
+		return NULL;
+
+	qa->qa_qc = qc;
+	qa->qa_mp = qc->qc_mp;
+	qa->qa_agno = agno;
+	INIT_LIST_HEAD(&qa->qa_node);
+	INIT_WORK(&qa->qa_work, xfs_qm_dq_adjust_worker);
+	init_completion(&qa->qa_complete);
+	list_add_tail(&qa->qa_node, &qc->qc_adjusters);
+
+	return qa;
+}
+
+STATIC int
+xfs_qm_alloc_queue_adjusters(
+	struct xfs_quotacheck	*qc)
+{
+	xfs_agnumber_t		agcount = qc->qc_mp->m_sb.sb_agcount;
+	int			i, error = 0;
+
+	for (i = 0; i < agcount; i++) {
+		struct xfs_dq_adjuster	*qa;
+
+		spin_lock(&qc->qc_lock);
+		qa = xfs_qm_alloc_adjuster(qc, i);
+		if (!qa) {
+			error = ENOMEM;
+			spin_unlock(&qc->qc_lock);
+			goto out_destroy_adjusters;
+		}
+		queue_work(qc->qc_wq, &qa->qa_work);
+		spin_unlock(&qc->qc_lock);
+	}
+
+	return error;
+
+out_destroy_adjusters:
+	xfs_qm_destroy_adjusters(qc);
+	return error;
+}
+
+STATIC void
+xfs_qm_wait_for_adjusters(
+	struct xfs_quotacheck	*qc)
+{
+	struct xfs_dq_adjuster	*qa;
+
+	list_for_each_entry(qa, &qc->qc_adjusters, qa_node)
+		wait_for_completion(&qa->qa_complete);
+}
+
+STATIC int
+xfs_qm_do_quotacheck(
+	struct xfs_mount	*mp)
+{
+	struct xfs_quotacheck	qc;
+	int			error;
+
+	error = xfs_qm_init_quotacheck(mp, &qc);
+	if (error)
+		return error;
+
+	/* Allocate and queue adjusters */
+	error = xfs_qm_alloc_queue_adjusters(&qc);
+	if (error)
+		goto out_destroy_quotacheck;
+
+	xfs_qm_wait_for_adjusters(&qc);
+
+	xfs_qm_destroy_adjusters(&qc);
+
+out_destroy_quotacheck:
+	xfs_qm_destroy_quotacheck(&qc);
+
+	return error;
+}
+
 STATIC int
 xfs_qm_flush_one(
 	struct xfs_dquot	*dqp,
@@ -1474,7 +1808,7 @@ int
 xfs_qm_quotacheck(
 	xfs_mount_t	*mp)
 {
-	int			done, count, error, error2;
+	int			count, error, error2;
 	xfs_ino_t		lastino;
 	size_t			structsz;
 	uint			flags;
@@ -1522,18 +1856,9 @@ xfs_qm_quotacheck(
 		flags |= XFS_PQUOTA_CHKD;
 	}
 
-	do {
-		/*
-		 * Iterate thru all the inodes in the file system,
-		 * adjusting the corresponding dquot counters in core.
-		 */
-		error = xfs_bulkstat(mp, &lastino, &count,
-				     xfs_qm_dqusage_adjust,
-				     structsz, NULL, &done);
-		if (error)
-			break;
-
-	} while (!done);
+	error = xfs_qm_do_quotacheck(mp);
+	if (error)
+		goto error_return;
 
 	/*
 	 * We've made all the changes that we need to make incore.  Flush them
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index a788b66..c7e2e6d 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -26,6 +26,24 @@ struct xfs_inode;
 
 extern struct kmem_zone	*xfs_qm_dqtrxzone;
 
+struct xfs_dq_adjuster {
+	struct list_head	qa_node;
+	struct xfs_mount	*qa_mp;
+	struct xfs_quotacheck	*qa_qc;
+	xfs_agnumber_t		qa_agno;
+	int			qa_error;
+	struct work_struct	qa_work;
+	struct completion	qa_complete;
+};
+
+struct xfs_quotacheck {
+	struct list_head	qc_adjusters;
+	spinlock_t		qc_lock;
+	struct xfs_mount	*qc_mp;
+	int			qc_done;
+	struct workqueue_struct	*qc_wq;
+};
+
 /*
  * This defines the unit of allocation of dquots.
  * Currently, it is just one file system block, and a 4K blk contains 30
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
