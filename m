Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1F2Vox6142349 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 20:31:50 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	LPXRDmAvn3Xenp7H (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Feb 2012 18:31:48 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RxUep-0004Qk-Ri
	for xfs@oss.sgi.com; Wed, 15 Feb 2012 02:31:47 +0000
Message-Id: <20120215023147.804149683@bombadil.infradead.org>
Date: Tue, 14 Feb 2012 21:29:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/9] xfs: remove the global xfs_Gqm structure
References: <20120215022926.577682146@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-kill-xfs-qm
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

Initialize the slab caches for the quote code as soon XFS is loaded, and
remove the now unused overhead of a reference counted global structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_dquot.c       |   38 ++++++++++++
 fs/xfs/xfs_qm.c          |  138 -----------------------------------------------
 fs/xfs/xfs_qm.h          |   15 -----
 fs/xfs/xfs_qm_bhv.c      |   18 ------
 fs/xfs/xfs_super.c       |   10 ++-
 fs/xfs/xfs_super.h       |    8 +-
 fs/xfs/xfs_trans_dquot.c |    4 -
 7 files changed, 49 insertions(+), 182 deletions(-)

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2012-02-12 13:22:49.553603603 -0800
+++ xfs/fs/xfs/xfs_dquot.c	2012-02-12 13:22:51.386936971 -0800
@@ -59,6 +59,9 @@ int xfs_dqreq_num;
 int xfs_dqerror_mod = 33;
 #endif
 
+struct kmem_zone		*xfs_qm_dqtrxzone;
+static struct kmem_zone		*xfs_qm_dqzone;
+
 static struct lock_class_key xfs_dquot_other_class;
 
 /*
@@ -71,7 +74,7 @@ xfs_qm_dqdestroy(
 	ASSERT(list_empty(&dqp->q_lru));
 
 	mutex_destroy(&dqp->q_qlock);
-	kmem_zone_free(xfs_Gqm->qm_dqzone, dqp);
+	kmem_zone_free(xfs_qm_dqzone, dqp);
 	XQM_STATS_DEC(xs_qm_dquots);
 }
 
@@ -490,7 +493,7 @@ xfs_qm_dqread(
 	int			cancelflags = 0;
 
 
-	dqp = kmem_zone_zalloc(xfs_Gqm->qm_dqzone, KM_SLEEP);
+	dqp = kmem_zone_zalloc(xfs_qm_dqzone, KM_SLEEP);
 
 	dqp->dq_flags = type;
 	dqp->q_core.d_id = cpu_to_be32(id);
@@ -1128,3 +1131,34 @@ xfs_dqflock_pushbuf_wait(
 out_lock:
 	xfs_dqflock(dqp);
 }
+
+int __init
+xfs_qm_init(void)
+{
+	xfs_qm_dqzone =
+		kmem_zone_init(sizeof(struct xfs_dquot), "xfs_dquot");
+	if (!xfs_qm_dqzone)
+		goto out;
+
+	xfs_qm_dqtrxzone =
+		kmem_zone_init(sizeof(struct xfs_dquot_acct), "xfs_dqtrx");
+	if (!xfs_qm_dqtrxzone)
+		goto out_free_dqzone;
+
+	xfs_qm_init_procfs();
+	return 0;
+
+out_free_dqzone:
+	kmem_zone_destroy(xfs_qm_dqzone);
+out:
+	return -ENOMEM;
+}
+
+void __exit
+xfs_qm_exit(void)
+{
+	xfs_qm_cleanup_procfs();
+
+	kmem_zone_destroy(xfs_qm_dqtrxzone);
+	kmem_zone_destroy(xfs_qm_dqzone);
+}
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2012-02-12 13:22:49.556936937 -0800
+++ xfs/fs/xfs/xfs_qm.c	2012-02-12 13:22:51.390270305 -0800
@@ -42,133 +42,11 @@
 #include "xfs_qm.h"
 #include "xfs_trace.h"
 
-/*
- * The global quota manager. There is only one of these for the entire
- * system, _not_ one per file system. XQM keeps track of the overall
- * quota functionality, including maintaining the freelist and hash
- * tables of dquots.
- */
-struct mutex	xfs_Gqm_lock;
-struct xfs_qm	*xfs_Gqm;
-
-kmem_zone_t	*qm_dqzone;
-kmem_zone_t	*qm_dqtrxzone;
-
 STATIC int	xfs_qm_init_quotainos(xfs_mount_t *);
 STATIC int	xfs_qm_init_quotainfo(xfs_mount_t *);
 STATIC int	xfs_qm_shake(struct shrinker *, struct shrink_control *);
 
 /*
- * Initialize the XQM structure.
- * Note that there is not one quota manager per file system.
- */
-STATIC struct xfs_qm *
-xfs_Gqm_init(void)
-{
-	xfs_qm_t	*xqm;
-
-	xqm = kmem_zalloc(sizeof(xfs_qm_t), KM_SLEEP);
-
-	/*
-	 * dquot zone. we register our own low-memory callback.
-	 */
-	if (!qm_dqzone) {
-		xqm->qm_dqzone = kmem_zone_init(sizeof(xfs_dquot_t),
-						"xfs_dquots");
-		qm_dqzone = xqm->qm_dqzone;
-	} else
-		xqm->qm_dqzone = qm_dqzone;
-
-	/*
-	 * The t_dqinfo portion of transactions.
-	 */
-	if (!qm_dqtrxzone) {
-		xqm->qm_dqtrxzone = kmem_zone_init(sizeof(xfs_dquot_acct_t),
-						   "xfs_dqtrx");
-		qm_dqtrxzone = xqm->qm_dqtrxzone;
-	} else
-		xqm->qm_dqtrxzone = qm_dqtrxzone;
-
-	xqm->qm_nrefs = 0;
-	return xqm;
-}
-
-/*
- * Destroy the global quota manager when its reference count goes to zero.
- */
-STATIC void
-xfs_qm_destroy(
-	struct xfs_qm	*xqm)
-{
-	ASSERT(xqm != NULL);
-	ASSERT(xqm->qm_nrefs == 0);
-
-	kmem_free(xqm);
-}
-
-/*
- * Called at mount time to let XQM know that another file system is
- * starting quotas. This isn't crucial information as the individual mount
- * structures are pretty independent, but it helps the XQM keep a
- * global view of what's going on.
- */
-/* ARGSUSED */
-STATIC int
-xfs_qm_hold_quotafs_ref(
-	struct xfs_mount *mp)
-{
-	/*
-	 * Need to lock the xfs_Gqm structure for things like this. For example,
-	 * the structure could disappear between the entry to this routine and
-	 * a HOLD operation if not locked.
-	 */
-	mutex_lock(&xfs_Gqm_lock);
-
-	if (!xfs_Gqm) {
-		xfs_Gqm = xfs_Gqm_init();
-		if (!xfs_Gqm) {
-			mutex_unlock(&xfs_Gqm_lock);
-			return ENOMEM;
-		}
-	}
-
-	/*
-	 * We can keep a list of all filesystems with quotas mounted for
-	 * debugging and statistical purposes, but ...
-	 * Just take a reference and get out.
-	 */
-	xfs_Gqm->qm_nrefs++;
-	mutex_unlock(&xfs_Gqm_lock);
-
-	return 0;
-}
-
-
-/*
- * Release the reference that a filesystem took at mount time,
- * so that we know when we need to destroy the entire quota manager.
- */
-/* ARGSUSED */
-STATIC void
-xfs_qm_rele_quotafs_ref(
-	struct xfs_mount *mp)
-{
-	ASSERT(xfs_Gqm);
-	ASSERT(xfs_Gqm->qm_nrefs > 0);
-
-	/*
-	 * Destroy the entire XQM. If somebody mounts with quotaon, this'll
-	 * be restarted.
-	 */
-	mutex_lock(&xfs_Gqm_lock);
-	if (--xfs_Gqm->qm_nrefs == 0) {
-		xfs_qm_destroy(xfs_Gqm);
-		xfs_Gqm = NULL;
-	}
-	mutex_unlock(&xfs_Gqm_lock);
-}
-
-/*
  * Just destroy the quotainfo structure.
  */
 void
@@ -711,13 +589,6 @@ xfs_qm_init_quotainfo(
 
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
-	/*
-	 * Tell XQM that we exist as soon as possible.
-	 */
-	if ((error = xfs_qm_hold_quotafs_ref(mp))) {
-		return error;
-	}
-
 	qinf = mp->m_quotainfo = kmem_zalloc(sizeof(xfs_quotainfo_t), KM_SLEEP);
 
 	/*
@@ -823,17 +694,9 @@ xfs_qm_destroy_quotainfo(
 
 	qi = mp->m_quotainfo;
 	ASSERT(qi != NULL);
-	ASSERT(xfs_Gqm != NULL);
 
 	unregister_shrinker(&qi->qi_shrinker);
 
-	/*
-	 * Release the reference that XQM kept, so that we know
-	 * when the XQM structure should be freed. We cannot assume
-	 * that xfs_Gqm is non-null after this point.
-	 */
-	xfs_qm_rele_quotafs_ref(mp);
-
 	if (qi->qi_uquotaip) {
 		IRELE(qi->qi_uquotaip);
 		qi->qi_uquotaip = NULL; /* paranoia */
@@ -1392,7 +1255,6 @@ xfs_qm_quotacheck(
 		 * We must turn off quotas.
 		 */
 		ASSERT(mp->m_quotainfo != NULL);
-		ASSERT(xfs_Gqm != NULL);
 		xfs_qm_destroy_quotainfo(mp);
 		if (xfs_mount_reset_sbqflags(mp)) {
 			xfs_warn(mp,
Index: xfs/fs/xfs/xfs_qm.h
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.h	2012-02-12 13:22:49.556936937 -0800
+++ xfs/fs/xfs/xfs_qm.h	2012-02-12 13:22:51.390270305 -0800
@@ -23,13 +23,9 @@
 #include "xfs_quota_priv.h"
 #include "xfs_qm_stats.h"
 
-struct xfs_qm;
 struct xfs_inode;
 
-extern struct mutex	xfs_Gqm_lock;
-extern struct xfs_qm	*xfs_Gqm;
-extern kmem_zone_t	*qm_dqzone;
-extern kmem_zone_t	*qm_dqtrxzone;
+extern struct kmem_zone	*xfs_qm_dqtrxzone;
 
 /*
  * This defines the unit of allocation of dquots.
@@ -43,15 +39,6 @@ extern kmem_zone_t	*qm_dqtrxzone;
 #define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
 
 /*
- * Quota Manager (global) structure. Lives only in core.
- */
-typedef struct xfs_qm {
-	uint		 qm_nrefs;	 /* file systems with quota on */
-	kmem_zone_t	*qm_dqzone;	 /* dquot mem-alloc zone */
-	kmem_zone_t	*qm_dqtrxzone;	 /* t_dqinfo of transactions */
-} xfs_qm_t;
-
-/*
  * Various quota information for individual filesystems.
  * The mount structure keeps a pointer to this.
  */
Index: xfs/fs/xfs/xfs_qm_bhv.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm_bhv.c	2012-02-12 13:18:57.546932636 -0800
+++ xfs/fs/xfs/xfs_qm_bhv.c	2012-02-12 13:22:51.390270305 -0800
@@ -86,21 +86,3 @@ xfs_qm_statvfs(
 		xfs_qm_dqput(dqp);
 	}
 }
-
-void __init
-xfs_qm_init(void)
-{
-	printk(KERN_INFO "SGI XFS Quota Management subsystem\n");
-	mutex_init(&xfs_Gqm_lock);
-	xfs_qm_init_procfs();
-}
-
-void __exit
-xfs_qm_exit(void)
-{
-	xfs_qm_cleanup_procfs();
-	if (qm_dqzone)
-		kmem_zone_destroy(qm_dqzone);
-	if (qm_dqtrxzone)
-		kmem_zone_destroy(qm_dqtrxzone);
-}
Index: xfs/fs/xfs/xfs_trans_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_dquot.c	2012-02-07 10:00:57.097917604 -0800
+++ xfs/fs/xfs/xfs_trans_dquot.c	2012-02-12 13:22:51.390270305 -0800
@@ -876,7 +876,7 @@ STATIC void
 xfs_trans_alloc_dqinfo(
 	xfs_trans_t	*tp)
 {
-	tp->t_dqinfo = kmem_zone_zalloc(xfs_Gqm->qm_dqtrxzone, KM_SLEEP);
+	tp->t_dqinfo = kmem_zone_zalloc(xfs_qm_dqtrxzone, KM_SLEEP);
 }
 
 void
@@ -885,6 +885,6 @@ xfs_trans_free_dqinfo(
 {
 	if (!tp->t_dqinfo)
 		return;
-	kmem_zone_free(xfs_Gqm->qm_dqtrxzone, tp->t_dqinfo);
+	kmem_zone_free(xfs_qm_dqtrxzone, tp->t_dqinfo);
 	tp->t_dqinfo = NULL;
 }
Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2012-02-12 13:18:57.220265963 -0800
+++ xfs/fs/xfs/xfs_super.c	2012-02-12 13:22:51.393603639 -0800
@@ -1658,13 +1658,17 @@ init_xfs_fs(void)
 	if (error)
 		goto out_cleanup_procfs;
 
-	vfs_initquota();
+	error = xfs_qm_init();
+	if (error)
+		goto out_sysctl_unregister;
 
 	error = register_filesystem(&xfs_fs_type);
 	if (error)
-		goto out_sysctl_unregister;
+		goto out_qm_exit;
 	return 0;
 
+ out_qm_exit:
+	xfs_qm_exit();
  out_sysctl_unregister:
 	xfs_sysctl_unregister();
  out_cleanup_procfs:
@@ -1686,7 +1690,7 @@ init_xfs_fs(void)
 STATIC void __exit
 exit_xfs_fs(void)
 {
-	vfs_exitquota();
+	xfs_qm_exit();
 	unregister_filesystem(&xfs_fs_type);
 	xfs_sysctl_unregister();
 	xfs_cleanup_procfs();
Index: xfs/fs/xfs/xfs_super.h
===================================================================
--- xfs.orig/fs/xfs/xfs_super.h	2012-02-07 10:00:57.111250937 -0800
+++ xfs/fs/xfs/xfs_super.h	2012-02-12 13:22:51.393603639 -0800
@@ -21,13 +21,11 @@
 #include <linux/exportfs.h>
 
 #ifdef CONFIG_XFS_QUOTA
-extern void xfs_qm_init(void);
+extern int xfs_qm_init(void);
 extern void xfs_qm_exit(void);
-# define vfs_initquota()	xfs_qm_init()
-# define vfs_exitquota()	xfs_qm_exit()
 #else
-# define vfs_initquota()	do { } while (0)
-# define vfs_exitquota()	do { } while (0)
+# define xfs_qm_init()	(0)
+# define xfs_qm_exit()	do { } while (0)
 #endif
 
 #ifdef CONFIG_XFS_POSIX_ACL

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
