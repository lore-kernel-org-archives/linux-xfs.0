Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q11E0hSe253128 for <xfs@oss.sgi.com>; Wed, 1 Feb 2012 08:00:43 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	SFPbFsaDqUuCmqPF (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Feb 2012 06:00:40 -0800 (PST)
Message-Id: <20120201140040.286774465@bombadil.infradead.org>
Date: Wed, 01 Feb 2012 08:57:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/7] xfs: use per-cpu data for the quota statistics
References: <20120201135719.202171828@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-percpu-stats
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

Use the same per-cpu scheme used in the main XFS statistics, as well as
the VFS inode and dcache statistics for the quota code.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_dquot.c    |    6 +++---
 fs/xfs/xfs_qm.c       |    6 +++---
 fs/xfs/xfs_qm_stats.c |   28 +++++++++++++++++-----------
 fs/xfs/xfs_qm_stats.h |   11 ++++++++---
 4 files changed, 31 insertions(+), 20 deletions(-)

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2012-02-01 12:29:56.000000000 +0100
+++ xfs/fs/xfs/xfs_dquot.c	2012-02-01 12:30:02.839305968 +0100
@@ -666,13 +666,13 @@ restart:
 		mutex_unlock(&mp->m_quotainfo->qi_tree_lock);
 
 		trace_xfs_dqget_hit(dqp);
-		XQM_STATS_INC(xqmstats.xs_qm_dqcachehits);
+		XQM_STATS_INC(xs_qm_dqcachehits);
 		*O_dqpp = dqp;
 		return 0;
 	}
 	mutex_unlock(&mp->m_quotainfo->qi_tree_lock);
 
-	XQM_STATS_INC(xqmstats.xs_qm_dqcachemisses);
+	XQM_STATS_INC(xs_qm_dqcachemisses);
 
 	/*
 	 * Dquot cache miss. We don't want to keep the inode lock across
@@ -736,7 +736,7 @@ restart:
 		mutex_unlock(&mp->m_quotainfo->qi_tree_lock);
 		trace_xfs_dqget_dup(dqp);
 		xfs_qm_dqdestroy(dqp);
-		XQM_STATS_INC(xqmstats.xs_qm_dquot_dups);
+		XQM_STATS_INC(xs_qm_dquot_dups);
 		goto restart;
 	}
 
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2012-02-01 12:29:56.000000000 +0100
+++ xfs/fs/xfs/xfs_qm.c	2012-02-01 12:30:26.685843449 +0100
@@ -1518,7 +1518,7 @@ xfs_qm_dqreclaim_one(
 		xfs_dqunlock(dqp);
 
 		trace_xfs_dqreclaim_want(dqp);
-		XQM_STATS_INC(xqmstats.xs_qm_dqwants);
+		XQM_STATS_INC(xs_qm_dqwants);
 
 		list_del_init(&dqp->q_lru);
 		qi->qi_lru_count--;
@@ -1572,7 +1572,7 @@ xfs_qm_dqreclaim_one(
 	qi->qi_lru_count--;
 
 	trace_xfs_dqreclaim_done(dqp);
-	XQM_STATS_INC(xqmstats.xs_qm_dqreclaims);
+	XQM_STATS_INC(xs_qm_dqreclaims);
 	return;
 
 out_busy:
@@ -1584,7 +1584,7 @@ out_busy:
 	list_move_tail(&dqp->q_lru, &qi->qi_lru_list);
 
 	trace_xfs_dqreclaim_busy(dqp);
-	XQM_STATS_INC(xqmstats.xs_qm_dqreclaim_misses);
+	XQM_STATS_INC(xs_qm_dqreclaim_misses);
 }
 
 STATIC int
Index: xfs/fs/xfs/xfs_qm_stats.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm_stats.c	2012-02-01 12:22:12.000000000 +0100
+++ xfs/fs/xfs/xfs_qm_stats.c	2012-02-01 12:30:02.842639283 +0100
@@ -36,7 +36,16 @@
 #include "xfs_buf_item.h"
 #include "xfs_qm.h"
 
-struct xqmstats xqmstats;
+DEFINE_PER_CPU(struct xqmstats, xqmstats);
+
+static int xqmstats_sum(int idx)
+{
+	int val = 0, cpu;
+
+	for_each_possible_cpu(cpu)
+		val += *(((__u32 *)&per_cpu(xqmstats, cpu) + idx));
+	return max(val, 0);
+}
 
 static int xqm_proc_show(struct seq_file *m, void *v)
 {
@@ -64,16 +73,13 @@ static const struct file_operations xqm_
 
 static int xqmstat_proc_show(struct seq_file *m, void *v)
 {
-	/* quota performance statistics */
-	seq_printf(m, "qm %u %u %u %u %u %u %u %u\n",
-			xqmstats.xs_qm_dqreclaims,
-			xqmstats.xs_qm_dqreclaim_misses,
-			xqmstats.xs_qm_dquot_dups,
-			xqmstats.xs_qm_dqcachemisses,
-			xqmstats.xs_qm_dqcachehits,
-			xqmstats.xs_qm_dqwants,
-			xqmstats.xs_qm_dqshake_reclaims,
-			xqmstats.xs_qm_dqinact_reclaims);
+	int j;
+
+	seq_printf(m, "qm");
+	for (j = 0; j < XQMSTAT_END_XQMSTAT; j++)
+		seq_printf(m, " %u", xqmstats_sum(j));
+	seq_putc(m, '\n');
+
 	return 0;
 }
 
Index: xfs/fs/xfs/xfs_qm_stats.h
===================================================================
--- xfs.orig/fs/xfs/xfs_qm_stats.h	2012-02-01 12:05:06.000000000 +0100
+++ xfs/fs/xfs/xfs_qm_stats.h	2012-02-01 12:30:02.842639283 +0100
@@ -32,18 +32,23 @@ struct xqmstats {
 	__uint32_t		xs_qm_dqwants;
 	__uint32_t		xs_qm_dqshake_reclaims;
 	__uint32_t		xs_qm_dqinact_reclaims;
+#define XQMSTAT_END_XQMSTAT	8
 };
 
-extern struct xqmstats xqmstats;
+DECLARE_PER_CPU(struct xqmstats, xqmstats);
 
-# define XQM_STATS_INC(count)	( (count)++ )
+/*
+ * We don't disable preempt, not too worried about poking the
+ * wrong CPU's stat for now (also aggregated before reporting).
+ */
+# define XQM_STATS_INC(v)	(per_cpu(xqmstats, current_cpu()).v++)
 
 extern void xfs_qm_init_procfs(void);
 extern void xfs_qm_cleanup_procfs(void);
 
 #else
 
-# define XQM_STATS_INC(count)	do { } while (0)
+# define XQM_STATS_INC(v)	do { } while (0)
 
 static inline void xfs_qm_init_procfs(void) { };
 static inline void xfs_qm_cleanup_procfs(void) { };

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
