Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1L1mGRm126854 for <xfs@oss.sgi.com>; Mon, 20 Feb 2012 19:48:17 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	tbXecrO45Kym4QaQ (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Feb 2012 17:48:11 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Rzept-0004kG-Fg
	for xfs@oss.sgi.com; Tue, 21 Feb 2012 01:48:09 +0000
Date: Mon, 20 Feb 2012 20:48:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/8 v2] xfs: use common code for quota statistics
Message-ID: <20120221014809.GA18227@infradead.org>
References: <20120220022815.018921977@bombadil.infradead.org>
	<20120220022904.060961294@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120220022904.060961294@bombadil.infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Switch the quota code over to use the generic XFS statistics infrastructure.
While the legacy /proc/fs/xfs/xqm and /proc/fs/xfs/xqmstats interfaces are
preserved for now the statistics that still have a meaning with the current
code are now also available from /proc/fs/xfs/stats.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/Makefile       |    3 -
 fs/xfs/xfs_dquot.c    |   14 +++---
 fs/xfs/xfs_qm.c       |    9 ++--
 fs/xfs/xfs_qm.h       |    2 
 fs/xfs/xfs_qm_bhv.c   |    2 
 fs/xfs/xfs_qm_stats.c |  105 --------------------------------------------------
 fs/xfs/xfs_qm_stats.h |   53 -------------------------
 fs/xfs/xfs_stats.c    |   99 +++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_stats.h    |   10 ++++
 9 files changed, 110 insertions(+), 187 deletions(-)

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2012-02-20 15:12:45.759959013 -0800
+++ xfs/fs/xfs/xfs_dquot.c	2012-02-20 15:12:48.969959004 -0800
@@ -74,7 +74,7 @@ xfs_qm_dqdestroy(
 	mutex_destroy(&dqp->q_qlock);
 	kmem_zone_free(xfs_Gqm->qm_dqzone, dqp);
 
-	atomic_dec(&xfs_Gqm->qm_totaldquots);
+	XFS_STATS_DEC(xs_qm_dquot);
 }
 
 /*
@@ -516,7 +516,7 @@ xfs_qm_dqread(
 	if (!(type & XFS_DQ_USER))
 		lockdep_set_class(&dqp->q_qlock, &xfs_dquot_other_class);
 
-	atomic_inc(&xfs_Gqm->qm_totaldquots);
+	XFS_STATS_INC(xs_qm_dquot);
 
 	trace_xfs_dqread(dqp);
 
@@ -712,12 +712,12 @@ restart:
 	 */
 	switch (xfs_qm_dqlookup(mp, id, h, O_dqpp)) {
 	case -1:
-		XQM_STATS_INC(xqmstats.xs_qm_dquot_dups);
+		XFS_STATS_INC(xs_qm_dquot_dups);
 		mutex_unlock(&h->qh_lock);
 		delay(1);
 		goto restart;
 	case 0:
-		XQM_STATS_INC(xqmstats.xs_qm_dqcachehits);
+		XFS_STATS_INC(xs_qm_dqcachehits);
 		/*
 		 * The dquot was found, moved to the front of the chain,
 		 * taken off the freelist if it was on it, and locked
@@ -729,7 +729,7 @@ restart:
 		trace_xfs_dqget_hit(*O_dqpp);
 		return 0;	/* success */
 	default:
-		XQM_STATS_INC(xqmstats.xs_qm_dqcachemisses);
+		XFS_STATS_INC(xs_qm_dqcachemisses);
 		break;
 	}
 
@@ -804,7 +804,7 @@ restart:
 				xfs_qm_dqput(tmpdqp);
 			mutex_unlock(&h->qh_lock);
 			xfs_qm_dqdestroy(dqp);
-			XQM_STATS_INC(xqmstats.xs_qm_dquot_dups);
+			XFS_STATS_INC(xs_qm_dquot_dups);
 			goto restart;
 		default:
 			break;
@@ -873,6 +873,7 @@ recurse:
 	if (list_empty(&dqp->q_freelist)) {
 		list_add_tail(&dqp->q_freelist, &xfs_Gqm->qm_dqfrlist);
 		xfs_Gqm->qm_dqfrlist_cnt++;
+		XFS_STATS_INC(xs_qm_dquot_unused);
 	}
 	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 
@@ -1189,6 +1190,7 @@ xfs_qm_dqpurge(
 	ASSERT(!list_empty(&dqp->q_freelist));
 	list_del_init(&dqp->q_freelist);
 	xfs_Gqm->qm_dqfrlist_cnt--;
+	XFS_STATS_DEC(xs_qm_dquot_unused);
 	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 
 	xfs_qm_dqdestroy(dqp);
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2012-02-20 15:12:45.776625680 -0800
+++ xfs/fs/xfs/xfs_qm.c	2012-02-20 15:12:48.969959004 -0800
@@ -134,7 +134,6 @@ xfs_Gqm_init(void)
 	} else
 		xqm->qm_dqtrxzone = qm_dqtrxzone;
 
-	atomic_set(&xqm->qm_totaldquots, 0);
 	xqm->qm_nrefs = 0;
 	return xqm;
 
@@ -1637,10 +1636,11 @@ xfs_qm_dqreclaim_one(
 		xfs_dqunlock(dqp);
 
 		trace_xfs_dqreclaim_want(dqp);
-		XQM_STATS_INC(xqmstats.xs_qm_dqwants);
+		XFS_STATS_INC(xs_qm_dqwants);
 
 		list_del_init(&dqp->q_freelist);
 		xfs_Gqm->qm_dqfrlist_cnt--;
+		XFS_STATS_DEC(xs_qm_dquot_unused);
 		return;
 	}
 
@@ -1690,9 +1690,10 @@ xfs_qm_dqreclaim_one(
 	ASSERT(dqp->q_nrefs == 0);
 	list_move_tail(&dqp->q_freelist, dispose_list);
 	xfs_Gqm->qm_dqfrlist_cnt--;
+	XFS_STATS_DEC(xs_qm_dquot_unused);
 
 	trace_xfs_dqreclaim_done(dqp);
-	XQM_STATS_INC(xqmstats.xs_qm_dqreclaims);
+	XFS_STATS_INC(xs_qm_dqreclaims);
 	return;
 
 out_busy:
@@ -1704,7 +1705,7 @@ out_busy:
 	list_move_tail(&dqp->q_freelist, &xfs_Gqm->qm_dqfrlist);
 
 	trace_xfs_dqreclaim_busy(dqp);
-	XQM_STATS_INC(xqmstats.xs_qm_dqreclaim_misses);
+	XFS_STATS_INC(xs_qm_dqreclaim_misses);
 }
 
 STATIC int
Index: xfs/fs/xfs/xfs_qm_stats.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm_stats.c	2012-02-20 15:12:45.786625679 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,105 +0,0 @@
-/*
- * Copyright (c) 2000-2003 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_inum.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_alloc.h"
-#include "xfs_quota.h"
-#include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_inode.h"
-#include "xfs_itable.h"
-#include "xfs_bmap.h"
-#include "xfs_rtalloc.h"
-#include "xfs_error.h"
-#include "xfs_attr.h"
-#include "xfs_buf_item.h"
-#include "xfs_qm.h"
-
-struct xqmstats xqmstats;
-
-static int xqm_proc_show(struct seq_file *m, void *v)
-{
-	/* maximum; incore; ratio free to inuse; freelist */
-	seq_printf(m, "%d\t%d\t%d\t%u\n",
-			0,
-			xfs_Gqm? atomic_read(&xfs_Gqm->qm_totaldquots) : 0,
-			0,
-			xfs_Gqm? xfs_Gqm->qm_dqfrlist_cnt : 0);
-	return 0;
-}
-
-static int xqm_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, xqm_proc_show, NULL);
-}
-
-static const struct file_operations xqm_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= xqm_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int xqmstat_proc_show(struct seq_file *m, void *v)
-{
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
-	return 0;
-}
-
-static int xqmstat_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, xqmstat_proc_show, NULL);
-}
-
-static const struct file_operations xqmstat_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= xqmstat_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-void
-xfs_qm_init_procfs(void)
-{
-	proc_create("fs/xfs/xqmstat", 0, NULL, &xqmstat_proc_fops);
-	proc_create("fs/xfs/xqm", 0, NULL, &xqm_proc_fops);
-}
-
-void
-xfs_qm_cleanup_procfs(void)
-{
-	remove_proc_entry("fs/xfs/xqm", NULL);
-	remove_proc_entry("fs/xfs/xqmstat", NULL);
-}
Index: xfs/fs/xfs/xfs_qm_stats.h
===================================================================
--- xfs.orig/fs/xfs/xfs_qm_stats.h	2012-02-20 15:12:45.799959014 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,53 +0,0 @@
-/*
- * Copyright (c) 2002 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_QM_STATS_H__
-#define __XFS_QM_STATS_H__
-
-#if defined(CONFIG_PROC_FS) && !defined(XFS_STATS_OFF)
-
-/*
- * XQM global statistics
- */
-struct xqmstats {
-	__uint32_t		xs_qm_dqreclaims;
-	__uint32_t		xs_qm_dqreclaim_misses;
-	__uint32_t		xs_qm_dquot_dups;
-	__uint32_t		xs_qm_dqcachemisses;
-	__uint32_t		xs_qm_dqcachehits;
-	__uint32_t		xs_qm_dqwants;
-	__uint32_t		xs_qm_dqshake_reclaims;
-	__uint32_t		xs_qm_dqinact_reclaims;
-};
-
-extern struct xqmstats xqmstats;
-
-# define XQM_STATS_INC(count)	( (count)++ )
-
-extern void xfs_qm_init_procfs(void);
-extern void xfs_qm_cleanup_procfs(void);
-
-#else
-
-# define XQM_STATS_INC(count)	do { } while (0)
-
-static inline void xfs_qm_init_procfs(void) { };
-static inline void xfs_qm_cleanup_procfs(void) { };
-
-#endif
-
-#endif	/* __XFS_QM_STATS_H__ */
Index: xfs/fs/xfs/xfs_stats.h
===================================================================
--- xfs.orig/fs/xfs/xfs_stats.h	2012-02-20 15:12:45.806625680 -0800
+++ xfs/fs/xfs/xfs_stats.h	2012-02-20 15:12:48.976625671 -0800
@@ -183,6 +183,16 @@ struct xfsstats {
 	__uint32_t		xs_ibt_2_alloc;
 	__uint32_t		xs_ibt_2_free;
 	__uint32_t		xs_ibt_2_moves;
+#define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_IBT_V2+6)
+	__uint32_t		xs_qm_dqreclaims;
+	__uint32_t		xs_qm_dqreclaim_misses;
+	__uint32_t		xs_qm_dquot_dups;
+	__uint32_t		xs_qm_dqcachemisses;
+	__uint32_t		xs_qm_dqcachehits;
+	__uint32_t		xs_qm_dqwants;
+#define XFSSTAT_END_QM			(XFSSTAT_END_XQMSTAT+2)
+	__uint32_t		xs_qm_dquot;
+	__uint32_t		xs_qm_dquot_unused;
 /* Extra precision counters */
 	__uint64_t		xs_xstrat_bytes;
 	__uint64_t		xs_write_bytes;
Index: xfs/fs/xfs/xfs_qm.h
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.h	2012-02-20 15:12:45.813292346 -0800
+++ xfs/fs/xfs/xfs_qm.h	2012-02-20 15:12:48.976625671 -0800
@@ -21,7 +21,6 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_quota_priv.h"
-#include "xfs_qm_stats.h"
 
 struct xfs_qm;
 struct xfs_inode;
@@ -60,7 +59,6 @@ typedef struct xfs_qm {
 	struct list_head qm_dqfrlist;	 /* freelist of dquots */
 	struct mutex	 qm_dqfrlist_lock;
 	int		 qm_dqfrlist_cnt;
-	atomic_t	 qm_totaldquots; /* total incore dquots */
 	uint		 qm_nrefs;	 /* file systems with quota on */
 	kmem_zone_t	*qm_dqzone;	 /* dquot mem-alloc zone */
 	kmem_zone_t	*qm_dqtrxzone;	 /* t_dqinfo of transactions */
Index: xfs/fs/xfs/xfs_qm_bhv.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm_bhv.c	2012-02-20 15:12:45.819959013 -0800
+++ xfs/fs/xfs/xfs_qm_bhv.c	2012-02-20 15:12:48.976625671 -0800
@@ -92,13 +92,11 @@ xfs_qm_init(void)
 {
 	printk(KERN_INFO "SGI XFS Quota Management subsystem\n");
 	mutex_init(&xfs_Gqm_lock);
-	xfs_qm_init_procfs();
 }
 
 void __exit
 xfs_qm_exit(void)
 {
-	xfs_qm_cleanup_procfs();
 	if (qm_dqzone)
 		kmem_zone_destroy(qm_dqzone);
 	if (qm_dqtrxzone)
Index: xfs/fs/xfs/xfs_stats.c
===================================================================
--- xfs.orig/fs/xfs/xfs_stats.c	2012-02-20 15:12:45.826625681 -0800
+++ xfs/fs/xfs/xfs_stats.c	2012-02-20 15:14:20.359958757 -0800
@@ -20,9 +20,18 @@
 
 DEFINE_PER_CPU(struct xfsstats, xfsstats);
 
+static int counter_val(int idx)
+{
+	int val = 0, cpu;
+
+	for_each_possible_cpu(cpu)
+		val += *(((__u32 *)&per_cpu(xfsstats, cpu) + idx));
+	return val;
+}
+
 static int xfs_stat_proc_show(struct seq_file *m, void *v)
 {
-	int		c, i, j, val;
+	int		i, j;
 	__uint64_t	xs_xstrat_bytes = 0;
 	__uint64_t	xs_write_bytes = 0;
 	__uint64_t	xs_read_bytes = 0;
@@ -50,20 +59,16 @@ static int xfs_stat_proc_show(struct seq
 		{ "abtc2",		XFSSTAT_END_ABTC_V2		},
 		{ "bmbt2",		XFSSTAT_END_BMBT_V2		},
 		{ "ibt2",		XFSSTAT_END_IBT_V2		},
+		/* we print both series of quota information together */
+		{ "qm",			XFSSTAT_END_QM			},
 	};
 
 	/* Loop over all stats groups */
-	for (i=j = 0; i < ARRAY_SIZE(xstats); i++) {
+	for (i = j = 0; i < ARRAY_SIZE(xstats); i++) {
 		seq_printf(m, "%s", xstats[i].desc);
 		/* inner loop does each group */
-		while (j < xstats[i].endpoint) {
-			val = 0;
-			/* sum over all cpus */
-			for_each_possible_cpu(c)
-				val += *(((__u32*)&per_cpu(xfsstats, c) + j));
-			seq_printf(m, " %u", val);
-			j++;
-		}
+		for (; j < xstats[i].endpoint; j++)
+			seq_printf(m, " %u", counter_val(j));
 		seq_putc(m, '\n');
 	}
 	/* extra precision counters */
@@ -97,6 +102,58 @@ static const struct file_operations xfs_
 	.release	= single_release,
 };
 
+/* legacy quota interfaces */
+#ifdef CONFIG_XFS_QUOTA
+static int xqm_proc_show(struct seq_file *m, void *v)
+{
+	/* maximum; incore; ratio free to inuse; freelist */
+	seq_printf(m, "%d\t%d\t%d\t%u\n",
+			0,
+			counter_val(XFSSTAT_END_XQMSTAT),
+			0,
+			counter_val(XFSSTAT_END_XQMSTAT + 1));
+	return 0;
+}
+
+static int xqm_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, xqm_proc_show, NULL);
+}
+
+static const struct file_operations xqm_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= xqm_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+/* legacy quota stats interface no 2 */
+static int xqmstat_proc_show(struct seq_file *m, void *v)
+{
+	int j;
+
+	seq_printf(m, "qm");
+	for (j = XFSSTAT_END_IBT_V2; j < XFSSTAT_END_XQMSTAT; j++)
+		seq_printf(m, " %u", counter_val(j));
+	seq_putc(m, '\n');
+	return 0;
+}
+
+static int xqmstat_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, xqmstat_proc_show, NULL);
+}
+
+static const struct file_operations xqmstat_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= xqmstat_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+#endif /* CONFIG_XFS_QUOTA */
+
 int
 xfs_init_procfs(void)
 {
@@ -105,10 +162,24 @@ xfs_init_procfs(void)
 
 	if (!proc_create("fs/xfs/stat", 0, NULL,
 			 &xfs_stat_proc_fops))
-		goto out_remove_entry;
+		goto out_remove_xfs_dir;
+#ifdef CONFIG_XFS_QUOTA
+	if (!proc_create("fs/xfs/xqmstat", 0, NULL,
+			 &xqmstat_proc_fops))
+		goto out_remove_stat_file;
+	if (!proc_create("fs/xfs/xqm", 0, NULL,
+			 &xqm_proc_fops))
+		goto out_remove_xqmstat_file;
+#endif
 	return 0;
 
- out_remove_entry:
+#ifdef CONFIG_XFS_QUOTA
+ out_remove_xqmstat_file:
+	remove_proc_entry("fs/xfs/xqmstat", NULL);
+ out_remove_stat_file:
+	remove_proc_entry("fs/xfs/stat", NULL);
+#endif
+ out_remove_xfs_dir:
 	remove_proc_entry("fs/xfs", NULL);
  out:
 	return -ENOMEM;
@@ -117,6 +188,10 @@ xfs_init_procfs(void)
 void
 xfs_cleanup_procfs(void)
 {
+#ifdef CONFIG_XFS_QUOTA
+	remove_proc_entry("fs/xfs/xqm", NULL);
+	remove_proc_entry("fs/xfs/xqmstat", NULL);
+#endif
 	remove_proc_entry("fs/xfs/stat", NULL);
 	remove_proc_entry("fs/xfs", NULL);
 }
Index: xfs/fs/xfs/Makefile
===================================================================
--- xfs.orig/fs/xfs/Makefile	2012-02-20 15:12:45.839959013 -0800
+++ xfs/fs/xfs/Makefile	2012-02-20 15:12:48.976625671 -0800
@@ -96,9 +96,6 @@ xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o
 				   xfs_qm_bhv.o \
 				   xfs_qm.o \
 				   xfs_quotaops.o
-ifeq ($(CONFIG_XFS_QUOTA),y)
-xfs-$(CONFIG_PROC_FS)		+= xfs_qm_stats.o
-endif
 xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o
 xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
 xfs-$(CONFIG_PROC_FS)		+= xfs_stats.o

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
