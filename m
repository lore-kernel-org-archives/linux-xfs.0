Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q11E0gHK253120 for <xfs@oss.sgi.com>; Wed, 1 Feb 2012 08:00:43 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	MfjUVO0zvOo3p8xs (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Feb 2012 06:00:41 -0800 (PST)
Message-Id: <20120201140040.528279999@bombadil.infradead.org>
Date: Wed, 01 Feb 2012 08:57:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/7] xfs: user per-cpu stats for the total dquot numbers
References: <20120201135719.202171828@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-percpu-stats-2
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Switch the total number of dquots counter over to use the per-cpu stats
implementation, and reintroduce the number of unused dquots counter
dropped earlier in the series.

Btw, I wonder if we should simply add these counters to /proc/fs/xfs/xqmstat
instead of keeping the odd format and mostly superflous /proc/fs/xfs/xqm
around.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_dquot.c    |    7 ++++---
 fs/xfs/xfs_qm.c       |    3 ++-
 fs/xfs/xfs_qm.h       |    1 -
 fs/xfs/xfs_qm_stats.c |    4 ++--
 fs/xfs/xfs_qm_stats.h |    5 +++++
 5 files changed, 13 insertions(+), 7 deletions(-)

Index: xfs/fs/xfs/xfs_qm_stats.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm_stats.c	2012-02-01 12:30:02.000000000 +0100
+++ xfs/fs/xfs/xfs_qm_stats.c	2012-02-01 12:30:48.359059367 +0100
@@ -52,9 +52,9 @@ static int xqm_proc_show(struct seq_file
 	/* maximum; incore; ratio free to inuse; freelist */
 	seq_printf(m, "%d\t%d\t%d\t%u\n",
 			0,
-			xfs_Gqm? atomic_read(&xfs_Gqm->qm_totaldquots) : 0,
+			xqmstats_sum(XQMSTAT_END_XQMSTAT),
 			0,
-			0);
+			xqmstats_sum(XQMSTAT_END_XQMSTAT + 1));
 	return 0;
 }
 
Index: xfs/fs/xfs/xfs_qm_stats.h
===================================================================
--- xfs.orig/fs/xfs/xfs_qm_stats.h	2012-02-01 12:30:02.000000000 +0100
+++ xfs/fs/xfs/xfs_qm_stats.h	2012-02-01 12:30:48.362392682 +0100
@@ -33,6 +33,9 @@ struct xqmstats {
 	__uint32_t		xs_qm_dqshake_reclaims;
 	__uint32_t		xs_qm_dqinact_reclaims;
 #define XQMSTAT_END_XQMSTAT	8
+	__uint32_t		xs_qm_dquots;
+	__uint32_t		xs_qm_dquots_unused;
+#define XQMSTAT_END_XQM		(XQMSTAT_END_XQMSTAT + 4)
 };
 
 DECLARE_PER_CPU(struct xqmstats, xqmstats);
@@ -42,6 +45,7 @@ DECLARE_PER_CPU(struct xqmstats, xqmstat
  * wrong CPU's stat for now (also aggregated before reporting).
  */
 # define XQM_STATS_INC(v)	(per_cpu(xqmstats, current_cpu()).v++)
+# define XQM_STATS_DEC(v)	(per_cpu(xqmstats, current_cpu()).v--)
 
 extern void xfs_qm_init_procfs(void);
 extern void xfs_qm_cleanup_procfs(void);
@@ -49,6 +53,7 @@ extern void xfs_qm_cleanup_procfs(void);
 #else
 
 # define XQM_STATS_INC(v)	do { } while (0)
+# define XQM_STATS_DEC(v)	do { } while (0)
 
 static inline void xfs_qm_init_procfs(void) { };
 static inline void xfs_qm_cleanup_procfs(void) { };
Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2012-02-01 12:30:02.000000000 +0100
+++ xfs/fs/xfs/xfs_dquot.c	2012-02-01 12:30:48.362392682 +0100
@@ -72,8 +72,7 @@ xfs_qm_dqdestroy(
 
 	mutex_destroy(&dqp->q_qlock);
 	kmem_zone_free(xfs_Gqm->qm_dqzone, dqp);
-
-	atomic_dec(&xfs_Gqm->qm_totaldquots);
+	XQM_STATS_DEC(xs_qm_dquots);
 }
 
 /*
@@ -515,7 +514,7 @@ xfs_qm_dqread(
 	if (!(type & XFS_DQ_USER))
 		lockdep_set_class(&dqp->q_qlock, &xfs_dquot_other_class);
 
-	atomic_inc(&xfs_Gqm->qm_totaldquots);
+	XQM_STATS_INC(xs_qm_dquots);
 
 	trace_xfs_dqread(dqp);
 
@@ -786,6 +785,7 @@ recurse:
 		list_add_tail(&dqp->q_lru,
 			      &dqp->q_mount->m_quotainfo->qi_lru_list);
 		dqp->q_mount->m_quotainfo->qi_lru_count++;
+		XQM_STATS_INC(xs_qm_dquots_unused);
 	}
 	mutex_unlock(&dqp->q_mount->m_quotainfo->qi_lru_lock);
 
@@ -1104,6 +1104,7 @@ xfs_qm_dqpurge(
 	qi->qi_lru_count--;
 	mutex_unlock(&qi->qi_lru_lock);
 
+	XQM_STATS_DEC(xs_qm_dquots_unused);
 	xfs_qm_dqdestroy(dqp);
 	return 0;
 }
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2012-02-01 12:30:26.000000000 +0100
+++ xfs/fs/xfs/xfs_qm.c	2012-02-01 12:31:11.988931351 +0100
@@ -89,7 +89,6 @@ xfs_Gqm_init(void)
 	} else
 		xqm->qm_dqtrxzone = qm_dqtrxzone;
 
-	atomic_set(&xqm->qm_totaldquots, 0);
 	xqm->qm_nrefs = 0;
 	return xqm;
 }
@@ -1522,6 +1521,7 @@ xfs_qm_dqreclaim_one(
 
 		list_del_init(&dqp->q_lru);
 		qi->qi_lru_count--;
+		XQM_STATS_DEC(xs_qm_dquots_unused);
 		return;
 	}
 
@@ -1570,6 +1570,7 @@ xfs_qm_dqreclaim_one(
 	ASSERT(dqp->q_nrefs == 0);
 	list_move_tail(&dqp->q_lru, dispose_list);
 	qi->qi_lru_count--;
+	XQM_STATS_DEC(xs_qm_dquots_unused);
 
 	trace_xfs_dqreclaim_done(dqp);
 	XQM_STATS_INC(xs_qm_dqreclaims);
Index: xfs/fs/xfs/xfs_qm.h
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.h	2012-02-01 12:26:36.000000000 +0100
+++ xfs/fs/xfs/xfs_qm.h	2012-02-01 12:30:48.365725997 +0100
@@ -46,7 +46,6 @@ extern kmem_zone_t	*qm_dqtrxzone;
  * Quota Manager (global) structure. Lives only in core.
  */
 typedef struct xfs_qm {
-	atomic_t	 qm_totaldquots; /* total incore dquots */
 	uint		 qm_nrefs;	 /* file systems with quota on */
 	kmem_zone_t	*qm_dqzone;	 /* dquot mem-alloc zone */
 	kmem_zone_t	*qm_dqtrxzone;	 /* t_dqinfo of transactions */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
