Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1K2T7OF040445 for <xfs@oss.sgi.com>; Sun, 19 Feb 2012 20:29:07 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	4wF7a5giE7HFzNBb (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 19 Feb 2012 18:29:05 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RzIzw-0004Xk-Re
	for xfs@oss.sgi.com; Mon, 20 Feb 2012 02:29:04 +0000
Message-Id: <20120220022904.826144748@bombadil.infradead.org>
Date: Sun, 19 Feb 2012 21:28:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 8/8] xfs: remove the global xfs_Gqm structure
References: <20120220022815.018921977@bombadil.infradead.org>
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

If we initialize the slab caches for the quote code when XFS is loaded there
is no need for a global and reference counted quota manager structure.  Drop
all this overhead and also fix the error handling during quota initialization.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_dquot.c       |   35 +++++++++++-
 fs/xfs/xfs_qm.c          |  132 -----------------------------------------------
 fs/xfs/xfs_qm.h          |   15 -----
 fs/xfs/xfs_qm_bhv.c      |   16 -----
 fs/xfs/xfs_super.c       |   10 ++-
 fs/xfs/xfs_super.h       |    8 +-
 fs/xfs/xfs_trans_dquot.c |    4 -
 7 files changed, 46 insertions(+), 174 deletions(-)

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2012-02-19 12:30:44.000000000 -0800
+++ xfs/fs/xfs/xfs_dquot.c	2012-02-19 12:44:23.176631178 -0800
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
 
 	XFS_STATS_DEC(xs_qm_dquot);
 }
@@ -491,7 +494,7 @@ xfs_qm_dqread(
 	int			cancelflags = 0;
 
 
-	dqp = kmem_zone_zalloc(xfs_Gqm->qm_dqzone, KM_SLEEP);
+	dqp = kmem_zone_zalloc(xfs_qm_dqzone, KM_SLEEP);
 
 	dqp->dq_flags = type;
 	dqp->q_core.d_id = cpu_to_be32(id);
@@ -1051,3 +1054,31 @@ xfs_dqflock_pushbuf_wait(
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
+	kmem_zone_destroy(xfs_qm_dqtrxzone);
+	kmem_zone_destroy(xfs_qm_dqzone);
+}
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2012-02-19 12:44:03.503297900 -0800
+++ xfs/fs/xfs/xfs_qm.c	2012-02-19 12:45:08.743297721 -0800
@@ -48,127 +48,11 @@
  * quota functionality, including maintaining the freelist and hash
  * tables of dquots.
  */
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
  * We use the batch lookup interface to iterate over the dquots as it
  * currently is the only interface into the radix tree code that allows
  * fuzzy lookups instead of exact matches.  Holding the lock over multiple
@@ -747,13 +631,6 @@ xfs_qm_init_quotainfo(
 
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
@@ -859,17 +736,9 @@ xfs_qm_destroy_quotainfo(
 
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
@@ -1457,7 +1326,6 @@ xfs_qm_quotacheck(
 		 * We must turn off quotas.
 		 */
 		ASSERT(mp->m_quotainfo != NULL);
-		ASSERT(xfs_Gqm != NULL);
 		xfs_qm_destroy_quotainfo(mp);
 		if (xfs_mount_reset_sbqflags(mp)) {
 			xfs_warn(mp,
Index: xfs/fs/xfs/xfs_qm.h
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.h	2012-02-19 12:30:44.346633394 -0800
+++ xfs/fs/xfs/xfs_qm.h	2012-02-19 12:44:23.179964511 -0800
@@ -22,13 +22,9 @@
 #include "xfs_dquot.h"
 #include "xfs_quota_priv.h"
 
-struct xfs_qm;
 struct xfs_inode;
 
-extern struct mutex	xfs_Gqm_lock;
-extern struct xfs_qm	*xfs_Gqm;
-extern kmem_zone_t	*qm_dqzone;
-extern kmem_zone_t	*qm_dqtrxzone;
+extern struct kmem_zone	*xfs_qm_dqtrxzone;
 
 /*
  * This defines the unit of allocation of dquots.
@@ -42,15 +38,6 @@ extern kmem_zone_t	*qm_dqtrxzone;
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
--- xfs.orig/fs/xfs/xfs_qm_bhv.c	2012-02-17 21:37:21.729990053 -0800
+++ xfs/fs/xfs/xfs_qm_bhv.c	2012-02-19 12:44:23.183297844 -0800
@@ -86,19 +86,3 @@ xfs_qm_statvfs(
 		xfs_qm_dqput(dqp);
 	}
 }
-
-void __init
-xfs_qm_init(void)
-{
-	printk(KERN_INFO "SGI XFS Quota Management subsystem\n");
-	mutex_init(&xfs_Gqm_lock);
-}
-
-void __exit
-xfs_qm_exit(void)
-{
-	if (qm_dqzone)
-		kmem_zone_destroy(qm_dqzone);
-	if (qm_dqtrxzone)
-		kmem_zone_destroy(qm_dqtrxzone);
-}
Index: xfs/fs/xfs/xfs_trans_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_dquot.c	2012-02-17 21:00:24.000000000 -0800
+++ xfs/fs/xfs/xfs_trans_dquot.c	2012-02-19 12:44:23.183297844 -0800
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
--- xfs.orig/fs/xfs/xfs_super.c	2012-02-17 21:00:24.000000000 -0800
+++ xfs/fs/xfs/xfs_super.c	2012-02-19 12:44:23.183297844 -0800
@@ -1651,13 +1651,17 @@ init_xfs_fs(void)
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
@@ -1679,7 +1683,7 @@ init_xfs_fs(void)
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
--- xfs.orig/fs/xfs/xfs_super.h	2012-02-17 21:00:24.000000000 -0800
+++ xfs/fs/xfs/xfs_super.h	2012-02-19 12:44:23.186631178 -0800
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
