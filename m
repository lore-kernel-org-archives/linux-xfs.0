Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:39:45 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJdc4p004571
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:39:40 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7NJdZA5008686
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 21:39:35 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7NJdZgj008684
	for xfs@oss.sgi.com; Thu, 23 Aug 2007 21:39:35 +0200
Date: Thu, 23 Aug 2007 21:39:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/17] remove dependency of the quota module on behaviors.
Message-ID: <20070823193935.GL8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Mount options are now parsed by the main XFS module and rejected if quota
support is not available, and there are some new quota operation for the
quotactl syscall and calls to quote in the mount, unmount and sync
callchains.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm_bhv.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm_bhv.c	2007-08-23 14:54:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm_bhv.c	2007-08-23 14:57:38.000000000 +0200
@@ -48,172 +48,13 @@
 #include "xfs_buf_item.h"
 #include "xfs_qm.h"
 
-#define MNTOPT_QUOTA	"quota"		/* disk quotas (user) */
-#define MNTOPT_NOQUOTA	"noquota"	/* no quotas */
-#define MNTOPT_USRQUOTA	"usrquota"	/* user quota enabled */
-#define MNTOPT_GRPQUOTA	"grpquota"	/* group quota enabled */
-#define MNTOPT_PRJQUOTA	"prjquota"	/* project quota enabled */
-#define MNTOPT_UQUOTA	"uquota"	/* user quota (IRIX variant) */
-#define MNTOPT_GQUOTA	"gquota"	/* group quota (IRIX variant) */
-#define MNTOPT_PQUOTA	"pquota"	/* project quota (IRIX variant) */
-#define MNTOPT_UQUOTANOENF "uqnoenforce"/* user quota limit enforcement */
-#define MNTOPT_GQUOTANOENF "gqnoenforce"/* group quota limit enforcement */
-#define MNTOPT_PQUOTANOENF "pqnoenforce"/* project quota limit enforcement */
-#define MNTOPT_QUOTANOENF  "qnoenforce"	/* same as uqnoenforce */
 
-STATIC int
-xfs_qm_parseargs(
-	struct bhv_desc		*bhv,
-	char			*options,
-	struct xfs_mount_args	*args,
-	int			update)
-{
-	size_t			length;
-	char			*local_options = options;
-	char			*this_char;
-	int			error;
-	int			referenced = update;
-
-	while ((this_char = strsep(&local_options, ",")) != NULL) {
-		length = strlen(this_char);
-		if (local_options)
-			length++;
-
-		if (!strcmp(this_char, MNTOPT_NOQUOTA)) {
-			args->flags &= ~(XFSMNT_UQUOTAENF|XFSMNT_UQUOTA);
-			args->flags &= ~(XFSMNT_GQUOTAENF|XFSMNT_GQUOTA);
-			referenced = update;
-		} else if (!strcmp(this_char, MNTOPT_QUOTA) ||
-			   !strcmp(this_char, MNTOPT_UQUOTA) ||
-			   !strcmp(this_char, MNTOPT_USRQUOTA)) {
-			args->flags |= XFSMNT_UQUOTA | XFSMNT_UQUOTAENF;
-			referenced = 1;
-		} else if (!strcmp(this_char, MNTOPT_QUOTANOENF) ||
-			   !strcmp(this_char, MNTOPT_UQUOTANOENF)) {
-			args->flags |= XFSMNT_UQUOTA;
-			args->flags &= ~XFSMNT_UQUOTAENF;
-			referenced = 1;
-		} else if (!strcmp(this_char, MNTOPT_PQUOTA) ||
-			   !strcmp(this_char, MNTOPT_PRJQUOTA)) {
-			args->flags |= XFSMNT_PQUOTA | XFSMNT_PQUOTAENF;
-			referenced = 1;
-		} else if (!strcmp(this_char, MNTOPT_PQUOTANOENF)) {
-			args->flags |= XFSMNT_PQUOTA;
-			args->flags &= ~XFSMNT_PQUOTAENF;
-			referenced = 1;
-		} else if (!strcmp(this_char, MNTOPT_GQUOTA) ||
-			   !strcmp(this_char, MNTOPT_GRPQUOTA)) {
-			args->flags |= XFSMNT_GQUOTA | XFSMNT_GQUOTAENF;
-			referenced = 1;
-		} else if (!strcmp(this_char, MNTOPT_GQUOTANOENF)) {
-			args->flags |= XFSMNT_GQUOTA;
-			args->flags &= ~XFSMNT_GQUOTAENF;
-			referenced = 1;
-		} else {
-			if (local_options)
-				*(local_options-1) = ',';
-			continue;
-		}
-
-		while (length--)
-			*this_char++ = ',';
-	}
-
-	if ((args->flags & XFSMNT_GQUOTA) && (args->flags & XFSMNT_PQUOTA)) {
-		cmn_err(CE_WARN,
-			"XFS: cannot mount with both project and group quota");
-		return XFS_ERROR(EINVAL);
-	}
-
-	error = bhv_next_vfs_parseargs(BHV_NEXT(bhv), options, args, update);
-	if (!error && !referenced)
-		bhv_remove_vfsops(bhvtovfs(bhv), VFS_POSITION_QM);
-	return error;
-}
-
-STATIC int
-xfs_qm_showargs(
-	struct bhv_desc		*bhv,
-	struct seq_file		*m)
-{
-	struct bhv_vfs		*vfsp = bhvtovfs(bhv);
-	struct xfs_mount	*mp = XFS_VFSTOM(vfsp);
-
-	if (mp->m_qflags & XFS_UQUOTA_ACCT) {
-		(mp->m_qflags & XFS_UQUOTA_ENFD) ?
-			seq_puts(m, "," MNTOPT_USRQUOTA) :
-			seq_puts(m, "," MNTOPT_UQUOTANOENF);
-	}
-
-	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
-		(mp->m_qflags & XFS_OQUOTA_ENFD) ?
-			seq_puts(m, "," MNTOPT_PRJQUOTA) :
-			seq_puts(m, "," MNTOPT_PQUOTANOENF);
-	}
-
-	if (mp->m_qflags & XFS_GQUOTA_ACCT) {
-		(mp->m_qflags & XFS_OQUOTA_ENFD) ?
-			seq_puts(m, "," MNTOPT_GRPQUOTA) :
-			seq_puts(m, "," MNTOPT_GQUOTANOENF);
-	}
-
-	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
-		seq_puts(m, "," MNTOPT_NOQUOTA);
-
-	return bhv_next_vfs_showargs(BHV_NEXT(bhv), m);
-}
-
-STATIC int
-xfs_qm_mount(
-	struct bhv_desc		*bhv,
-	struct xfs_mount_args	*args,
-	struct cred		*cr)
-{
-	struct bhv_vfs		*vfsp = bhvtovfs(bhv);
-	struct xfs_mount	*mp = XFS_VFSTOM(vfsp);
-
-	if (args->flags & (XFSMNT_UQUOTA | XFSMNT_GQUOTA | XFSMNT_PQUOTA))
-		xfs_qm_mount_quotainit(mp, args->flags);
-	return bhv_next_vfs_mount(BHV_NEXT(bhv), args, cr);
-}
-
-/*
- * Directory tree accounting is implemented using project quotas, where
- * the project identifier is inherited from parent directories.
- * A statvfs (df, etc.) of a directory that is using project quota should
- * return a statvfs of the project, not the entire filesystem.
- * This makes such trees appear as if they are filesystems in themselves.
- */
-STATIC int
-xfs_qm_statvfs(
-	struct bhv_desc		*bhv,
+STATIC void
+xfs_fill_statvfs_from_dquot(
 	bhv_statvfs_t		*statp,
-	bhv_vnode_t		*vnode)
+	xfs_disk_dquot_t	*dp)
 {
-	xfs_mount_t		*mp;
-	xfs_inode_t		*ip;
-	xfs_dquot_t		*dqp;
-	xfs_disk_dquot_t	*dp;
 	__uint64_t		limit;
-	int			error;
-
-	error = bhv_next_vfs_statvfs(BHV_NEXT(bhv), statp, vnode);
-	if (error || !vnode)
-		return error;
-
-	mp = xfs_vfstom(bhvtovfs(bhv));
-	ip = xfs_vtoi(vnode);
-
-	if (!(ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT))
-		return 0;
-	if (!(mp->m_qflags & XFS_PQUOTA_ACCT))
-		return 0;
-	if (!(mp->m_qflags & XFS_OQUOTA_ENFD))
-		return 0;
-
-	if (xfs_qm_dqget(mp, NULL, ip->i_d.di_projid, XFS_DQ_PROJ, 0, &dqp))
-		return 0;
-	dp = &dqp->q_core;
 
 	limit = dp->d_blk_softlimit ?
 		be64_to_cpu(dp->d_blk_softlimit) :
@@ -234,37 +75,35 @@ xfs_qm_statvfs(
 			(statp->f_files > be64_to_cpu(dp->d_icount)) ?
 			 (statp->f_ffree - be64_to_cpu(dp->d_icount)) : 0;
 	}
-
-	xfs_qm_dqput(dqp);
-	return 0;
 }
 
-STATIC int
-xfs_qm_syncall(
-	struct bhv_desc		*bhv,
-	int			flags,
-	cred_t			*credp)
+
+/*
+ * Directory tree accounting is implemented using project quotas, where
+ * the project identifier is inherited from parent directories.
+ * A statvfs (df, etc.) of a directory that is using project quota should
+ * return a statvfs of the project, not the entire filesystem.
+ * This makes such trees appear as if they are filesystems in themselves.
+ */
+STATIC void
+xfs_qm_statvfs(
+	xfs_inode_t		*ip,
+	bhv_statvfs_t		*statp)
 {
-	struct bhv_vfs		*vfsp = bhvtovfs(bhv);
-	struct xfs_mount	*mp = XFS_VFSTOM(vfsp);
-	int			error;
+	xfs_mount_t		*mp = ip->i_mount;
+	xfs_dquot_t		*dqp;
 
-	/*
-	 * Get the Quota Manager to flush the dquots.
-	 */
-	if (XFS_IS_QUOTA_ON(mp)) {
-		if ((error = xfs_qm_sync(mp, flags))) {
-			/*
-			 * If we got an IO error, we will be shutting down.
-			 * So, there's nothing more for us to do here.
-			 */
-			ASSERT(error != EIO || XFS_FORCED_SHUTDOWN(mp));
-			if (XFS_FORCED_SHUTDOWN(mp)) {
-				return XFS_ERROR(error);
-			}
-		}
+	if (!(ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) ||
+	    !((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))) ==
+	    		      (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))
+		return;
+
+	if (!xfs_qm_dqget(mp, NULL, ip->i_d.di_projid, XFS_DQ_PROJ, 0, &dqp)) {
+		xfs_disk_dquot_t	*dp = &dqp->q_core;
+
+		xfs_fill_statvfs_from_dquot(statp, dp);
+		xfs_qm_dqput(dqp);
 	}
-	return bhv_next_vfs_sync(BHV_NEXT(bhv), flags, credp);
 }
 
 STATIC int
@@ -382,7 +221,7 @@ xfs_qm_dqrele_null(
 }
 
 
-static struct xfs_qmops xfs_qmcore_xfs = {
+struct xfs_qmops xfs_qmcore_xfs = {
 	.xfs_qminit		= xfs_qm_newmount,
 	.xfs_qmdone		= xfs_qm_unmount_quotadestroy,
 	.xfs_qmmount		= xfs_qm_endmount,
@@ -396,30 +235,18 @@ static struct xfs_qmops xfs_qmcore_xfs =
 	.xfs_dqvoprename	= xfs_qm_vop_rename_dqattach,
 	.xfs_dqvopchown		= xfs_qm_vop_chown,
 	.xfs_dqvopchownresv	= xfs_qm_vop_chown_reserve,
+	.xfs_dqstatvfs		= xfs_qm_statvfs,
+	.xfs_dqsync		= xfs_qm_sync,
+	.xfs_quotactl		= xfs_qm_quotactl,
 	.xfs_dqtrxops		= &xfs_trans_dquot_ops,
 };
-
-struct bhv_module_vfsops xfs_qmops = { {
-	BHV_IDENTITY_INIT(VFS_BHV_QM, VFS_POSITION_QM),
-	.vfs_parseargs		= xfs_qm_parseargs,
-	.vfs_showargs		= xfs_qm_showargs,
-	.vfs_mount		= xfs_qm_mount,
-	.vfs_statvfs		= xfs_qm_statvfs,
-	.vfs_sync		= xfs_qm_syncall,
-	.vfs_quotactl		= xfs_qm_quotactl, },
-};
-
+EXPORT_SYMBOL(xfs_qmcore_xfs);
 
 static int __init
 xfs_qm_init(void)
 {
-	static char	message[] __initdata =
-		KERN_INFO "SGI XFS Quota Management subsystem\n";
-
-	printk(message);
+	printk(KERN_INFO "SGI XFS Quota Management subsystem\n");
 	mutex_init(&xfs_Gqm_lock);
-	vfs_bhv_set_custom(&xfs_qmops, &xfs_qmcore_xfs);
-	bhv_module_init(XFS_QMOPS, THIS_MODULE, &xfs_qmops);
 	xfs_qm_init_procfs();
 	return 0;
 }
@@ -428,8 +255,6 @@ static void __exit
 xfs_qm_exit(void)
 {
 	xfs_qm_cleanup_procfs();
-	bhv_module_exit(XFS_QMOPS);
-	vfs_bhv_clr_custom(&xfs_qmops);
 	if (qm_dqzone)
 		kmem_zone_destroy(qm_dqzone);
 	if (qm_dqtrxzone)
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2007-08-23 14:54:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2007-08-23 14:57:38.000000000 +0200
@@ -142,6 +142,9 @@ typedef struct xfs_dquot * (*xfs_dqvopch
 			struct xfs_dquot **, struct xfs_dquot *);
 typedef int	(*xfs_dqvopchownresv_t)(struct xfs_trans *, struct xfs_inode *,
 			struct xfs_dquot *, struct xfs_dquot *, uint);
+typedef void	(*xfs_dqstatvfs_t)(struct xfs_inode *, bhv_statvfs_t *);
+typedef int	(*xfs_dqsync_t)(struct xfs_mount *, int flags);
+typedef int	(*xfs_quotactl_t)(struct xfs_mount *, int, int, xfs_caddr_t);
 
 typedef struct xfs_qmops {
 	xfs_qminit_t		xfs_qminit;
@@ -157,35 +160,44 @@ typedef struct xfs_qmops {
 	xfs_dqvoprename_t	xfs_dqvoprename;
 	xfs_dqvopchown_t	xfs_dqvopchown;
 	xfs_dqvopchownresv_t	xfs_dqvopchownresv;
+	xfs_dqstatvfs_t		xfs_dqstatvfs;
+	xfs_dqsync_t		xfs_dqsync;
+	xfs_quotactl_t		xfs_quotactl;
 	struct xfs_dqtrxops	*xfs_dqtrxops;
 } xfs_qmops_t;
 
 #define XFS_QM_INIT(mp, mnt, fl) \
-	(*(mp)->m_qm_ops.xfs_qminit)(mp, mnt, fl)
+	(*(mp)->m_qm_ops->xfs_qminit)(mp, mnt, fl)
 #define XFS_QM_MOUNT(mp, mnt, fl, mfsi_flags) \
-	(*(mp)->m_qm_ops.xfs_qmmount)(mp, mnt, fl, mfsi_flags)
+	(*(mp)->m_qm_ops->xfs_qmmount)(mp, mnt, fl, mfsi_flags)
 #define XFS_QM_UNMOUNT(mp) \
-	(*(mp)->m_qm_ops.xfs_qmunmount)(mp)
+	(*(mp)->m_qm_ops->xfs_qmunmount)(mp)
 #define XFS_QM_DONE(mp) \
-	(*(mp)->m_qm_ops.xfs_qmdone)(mp)
+	(*(mp)->m_qm_ops->xfs_qmdone)(mp)
 #define XFS_QM_DQRELE(mp, dq) \
-	(*(mp)->m_qm_ops.xfs_dqrele)(dq)
+	(*(mp)->m_qm_ops->xfs_dqrele)(dq)
 #define XFS_QM_DQATTACH(mp, ip, fl) \
-	(*(mp)->m_qm_ops.xfs_dqattach)(ip, fl)
+	(*(mp)->m_qm_ops->xfs_dqattach)(ip, fl)
 #define XFS_QM_DQDETACH(mp, ip) \
-	(*(mp)->m_qm_ops.xfs_dqdetach)(ip)
+	(*(mp)->m_qm_ops->xfs_dqdetach)(ip)
 #define XFS_QM_DQPURGEALL(mp, fl) \
-	(*(mp)->m_qm_ops.xfs_dqpurgeall)(mp, fl)
+	(*(mp)->m_qm_ops->xfs_dqpurgeall)(mp, fl)
 #define XFS_QM_DQVOPALLOC(mp, ip, uid, gid, prid, fl, dq1, dq2) \
-	(*(mp)->m_qm_ops.xfs_dqvopalloc)(mp, ip, uid, gid, prid, fl, dq1, dq2)
+	(*(mp)->m_qm_ops->xfs_dqvopalloc)(mp, ip, uid, gid, prid, fl, dq1, dq2)
 #define XFS_QM_DQVOPCREATE(mp, tp, ip, dq1, dq2) \
-	(*(mp)->m_qm_ops.xfs_dqvopcreate)(tp, ip, dq1, dq2)
+	(*(mp)->m_qm_ops->xfs_dqvopcreate)(tp, ip, dq1, dq2)
 #define XFS_QM_DQVOPRENAME(mp, ip) \
-	(*(mp)->m_qm_ops.xfs_dqvoprename)(ip)
+	(*(mp)->m_qm_ops->xfs_dqvoprename)(ip)
 #define XFS_QM_DQVOPCHOWN(mp, tp, ip, dqp, dq) \
-	(*(mp)->m_qm_ops.xfs_dqvopchown)(tp, ip, dqp, dq)
+	(*(mp)->m_qm_ops->xfs_dqvopchown)(tp, ip, dqp, dq)
 #define XFS_QM_DQVOPCHOWNRESV(mp, tp, ip, dq1, dq2, fl) \
-	(*(mp)->m_qm_ops.xfs_dqvopchownresv)(tp, ip, dq1, dq2, fl)
+	(*(mp)->m_qm_ops->xfs_dqvopchownresv)(tp, ip, dq1, dq2, fl)
+#define XFS_QM_DQSTATVFS(ip, statp) \
+	(*(ip)->i_mount->m_qm_ops->xfs_dqstatvfs)(ip, statp)
+#define XFS_QM_DQSYNC(mp, flags) \
+	(*(mp)->m_qm_ops->xfs_dqsync)(mp, flags)
+#define XFS_QM_QUOTACTL(mp, cmd, id, addr) \
+	(*(mp)->m_qm_ops->xfs_quotactl)(mp, cmd, id, addr)
 
 
 /*
@@ -413,7 +425,7 @@ typedef struct xfs_mount {
 	struct xfs_chash	*m_chash;	/* fs private inode per-cluster
 						 * hash table */
 	struct xfs_dmops	*m_dm_ops;	/* vector of DMI ops */
-	struct xfs_qmops	m_qm_ops;	/* vector of XQM ops */
+	struct xfs_qmops	*m_qm_ops;	/* vector of XQM ops */
 	struct xfs_ioops	m_io_ops;	/* vector of I/O ops */
 	atomic_t		m_active_trans;	/* number trans frozen */
 #ifdef HAVE_PERCPU_SB
@@ -649,9 +661,10 @@ extern int	xfs_sb_validate_fsb_count(str
 
 extern int	xfs_dmops_get(struct xfs_mount *, struct xfs_mount_args *);
 extern void	xfs_dmops_put(struct xfs_mount *);
+extern int	xfs_qmops_get(struct xfs_mount *, struct xfs_mount_args *);
+extern void	xfs_qmops_put(struct xfs_mount *);
 
 extern struct xfs_dmops xfs_dmcore_xfs;
-extern struct xfs_qmops xfs_qmcore_stub;
 extern struct xfs_ioops xfs_iocore_xfs;
 
 extern int	xfs_init(void);
Index: linux-2.6-xfs/fs/xfs/xfs_quota.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_quota.h	2007-08-23 02:29:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_quota.h	2007-08-23 14:57:38.000000000 +0200
@@ -330,12 +330,12 @@ typedef struct xfs_dqtrxops {
 } xfs_dqtrxops_t;
 
 #define XFS_DQTRXOP(mp, tp, op, args...) \
-		((mp)->m_qm_ops.xfs_dqtrxops ? \
-		((mp)->m_qm_ops.xfs_dqtrxops->op)(tp, ## args) : 0)
+		((mp)->m_qm_ops->xfs_dqtrxops ? \
+		((mp)->m_qm_ops->xfs_dqtrxops->op)(tp, ## args) : 0)
 
 #define XFS_DQTRXOP_VOID(mp, tp, op, args...) \
-		((mp)->m_qm_ops.xfs_dqtrxops ? \
-		((mp)->m_qm_ops.xfs_dqtrxops->op)(tp, ## args) : (void)0)
+		((mp)->m_qm_ops->xfs_dqtrxops ? \
+		((mp)->m_qm_ops->xfs_dqtrxops->op)(tp, ## args) : (void)0)
 
 #define XFS_TRANS_DUP_DQINFO(mp, otp, ntp) \
 	XFS_DQTRXOP_VOID(mp, otp, qo_dup_dqinfo, ntp)
@@ -364,7 +364,7 @@ typedef struct xfs_dqtrxops {
 extern int xfs_qm_dqcheck(xfs_disk_dquot_t *, xfs_dqid_t, uint, uint, char *);
 extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
 
-extern struct bhv_module_vfsops xfs_qmops;
+extern struct xfs_qmops xfs_qmcore_xfs;
 
 #endif	/* __KERNEL__ */
 
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2007-08-23 14:54:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2007-08-23 14:57:38.000000000 +0200
@@ -402,6 +402,22 @@ xfs_finish_flags(
 			return XFS_ERROR(EINVAL);
 	}
 
+	if (ap->flags & XFSMNT_UQUOTA) {
+		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
+		if (ap->flags & XFSMNT_UQUOTAENF)
+			mp->m_qflags |= XFS_UQUOTA_ENFD;
+	}
+
+	if (ap->flags & XFSMNT_GQUOTA) {
+		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
+		if (ap->flags & XFSMNT_GQUOTAENF)
+			mp->m_qflags |= XFS_OQUOTA_ENFD;
+	} else if (ap->flags & XFSMNT_PQUOTA) {
+		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
+		if (ap->flags & XFSMNT_PQUOTAENF)
+			mp->m_qflags |= XFS_OQUOTA_ENFD;
+	}
+
 	return 0;
 }
 
@@ -435,12 +451,13 @@ xfs_mount(
 	error = xfs_dmops_get(mp, args);
 	if (error)
 		return error;
+	error = xfs_qmops_get(mp, args);
+	if (error)
+		return error;
 
 	/*
 	 * Setup xfs_mount function vectors from available behaviors
 	 */
-	p = vfs_bhv_lookup(vfsp, VFS_POSITION_QM);
-	mp->m_qm_ops = p ? *(xfs_qmops_t *) vfs_bhv_custom(p) : xfs_qmcore_stub;
 	p = vfs_bhv_lookup(vfsp, VFS_POSITION_IO);
 	mp->m_io_ops = p ? *(xfs_ioops_t *) vfs_bhv_custom(p) : xfs_iocore_xfs;
 
@@ -556,6 +573,7 @@ error1:
 		xfs_binval(mp->m_rtdev_targp);
 error0:
 	xfs_unmountfs_close(mp, credp);
+	xfs_qmops_put(mp);
 	xfs_dmops_put(mp);
 	return error;
 }
@@ -647,6 +665,7 @@ out:
 		 * and free the super block buffer & mount structures.
 		 */
 		xfs_unmountfs(mp, credp);
+		xfs_qmops_put(mp);
 		xfs_dmops_put(mp);
 		kmem_free(mp, sizeof(xfs_mount_t));
 	}
@@ -887,6 +906,8 @@ xfs_statvfs(
 	xfs_statvfs_fsid(statp, mp);
 	statp->f_namelen = MAXNAMELEN - 1;
 
+	if (vp)
+		XFS_QM_DQSTATVFS(xfs_vtoi(vp), statp);
 	return 0;
 }
 
@@ -941,6 +962,21 @@ xfs_sync(
 	cred_t		*credp)
 {
 	xfs_mount_t	*mp = XFS_BHVTOM(bdp);
+	int		error;
+
+	/*
+	 * Get the Quota Manager to flush the dquots.
+	 */
+	error = XFS_QM_DQSYNC(mp, flags);
+	if (error) {
+		/*
+		 * If we got an IO error, we will be shutting down.
+		 * So, there's nothing more for us to do here.
+		 */
+		ASSERT(error != EIO || XFS_FORCED_SHUTDOWN(mp));
+		if (XFS_FORCED_SHUTDOWN(mp))
+			return XFS_ERROR(error);
+	}
 
 	if (flags & SYNC_IOWAIT)
 		xfs_filestream_flush(mp);
@@ -1696,6 +1732,18 @@ xfs_vget(
 #define MNTOPT_ATTR2	"attr2"		/* do use attr2 attribute format */
 #define MNTOPT_NOATTR2	"noattr2"	/* do not use attr2 attribute format */
 #define MNTOPT_FILESTREAM  "filestreams" /* use filestreams allocator */
+#define MNTOPT_QUOTA	"quota"		/* disk quotas (user) */
+#define MNTOPT_NOQUOTA	"noquota"	/* no quotas */
+#define MNTOPT_USRQUOTA	"usrquota"	/* user quota enabled */
+#define MNTOPT_GRPQUOTA	"grpquota"	/* group quota enabled */
+#define MNTOPT_PRJQUOTA	"prjquota"	/* project quota enabled */
+#define MNTOPT_UQUOTA	"uquota"	/* user quota (IRIX variant) */
+#define MNTOPT_GQUOTA	"gquota"	/* group quota (IRIX variant) */
+#define MNTOPT_PQUOTA	"pquota"	/* project quota (IRIX variant) */
+#define MNTOPT_UQUOTANOENF "uqnoenforce"/* user quota limit enforcement */
+#define MNTOPT_GQUOTANOENF "gqnoenforce"/* group quota limit enforcement */
+#define MNTOPT_PQUOTANOENF "pqnoenforce"/* project quota limit enforcement */
+#define MNTOPT_QUOTANOENF  "qnoenforce"	/* same as uqnoenforce */
 #define MNTOPT_DMAPI	"dmapi"		/* DMI enabled (DMAPI / XDSM) */
 #define MNTOPT_XDSM	"xdsm"		/* DMI enabled (DMAPI / XDSM) */
 #define MNTOPT_DMI	"dmi"		/* DMI enabled (DMAPI / XDSM) */
@@ -1878,6 +1926,29 @@ xfs_parseargs(
 			args->flags &= ~XFSMNT_ATTR2;
 		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
 			args->flags2 |= XFSMNT2_FILESTREAMS;
+		} else if (!strcmp(this_char, MNTOPT_NOQUOTA)) {
+			args->flags &= ~(XFSMNT_UQUOTAENF|XFSMNT_UQUOTA);
+			args->flags &= ~(XFSMNT_GQUOTAENF|XFSMNT_GQUOTA);
+		} else if (!strcmp(this_char, MNTOPT_QUOTA) ||
+			   !strcmp(this_char, MNTOPT_UQUOTA) ||
+			   !strcmp(this_char, MNTOPT_USRQUOTA)) {
+			args->flags |= XFSMNT_UQUOTA | XFSMNT_UQUOTAENF;
+		} else if (!strcmp(this_char, MNTOPT_QUOTANOENF) ||
+			   !strcmp(this_char, MNTOPT_UQUOTANOENF)) {
+			args->flags |= XFSMNT_UQUOTA;
+			args->flags &= ~XFSMNT_UQUOTAENF;
+		} else if (!strcmp(this_char, MNTOPT_PQUOTA) ||
+			   !strcmp(this_char, MNTOPT_PRJQUOTA)) {
+			args->flags |= XFSMNT_PQUOTA | XFSMNT_PQUOTAENF;
+		} else if (!strcmp(this_char, MNTOPT_PQUOTANOENF)) {
+			args->flags |= XFSMNT_PQUOTA;
+			args->flags &= ~XFSMNT_PQUOTAENF;
+		} else if (!strcmp(this_char, MNTOPT_GQUOTA) ||
+			   !strcmp(this_char, MNTOPT_GRPQUOTA)) {
+			args->flags |= XFSMNT_GQUOTA | XFSMNT_GQUOTAENF;
+		} else if (!strcmp(this_char, MNTOPT_GQUOTANOENF)) {
+			args->flags |= XFSMNT_GQUOTA;
+			args->flags &= ~XFSMNT_GQUOTAENF;
 		} else if (!strcmp(this_char, MNTOPT_DMAPI)) {
 			args->flags |= XFSMNT_DMAPI;
 		} else if (!strcmp(this_char, MNTOPT_XDSM)) {
@@ -1912,6 +1983,12 @@ xfs_parseargs(
 		return EINVAL;
 	}
 
+	if ((args->flags & XFSMNT_GQUOTA) && (args->flags & XFSMNT_PQUOTA)) {
+		cmn_err(CE_WARN,
+			"XFS: cannot mount with both project and group quota");
+		return EINVAL;
+	}
+
 	if ((args->flags & XFSMNT_DMAPI) && *args->mtpt == '\0') {
 		printk("XFS: %s option needs the mount point option as well\n",
 			MNTOPT_DMAPI);
@@ -2011,9 +2088,32 @@ xfs_showargs(
 	if (vfsp->vfs_flag & VFS_GRPID)
 		seq_printf(m, "," MNTOPT_GRPID);
 
+	if (mp->m_qflags & XFS_UQUOTA_ACCT) {
+		if (mp->m_qflags & XFS_UQUOTA_ENFD)
+			seq_puts(m, "," MNTOPT_USRQUOTA);
+		else
+			seq_puts(m, "," MNTOPT_UQUOTANOENF);
+	}
+
+	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
+		if (mp->m_qflags & XFS_OQUOTA_ENFD)
+			seq_puts(m, "," MNTOPT_PRJQUOTA);
+		else
+			seq_puts(m, "," MNTOPT_PQUOTANOENF);
+	}
+
+	if (mp->m_qflags & XFS_GQUOTA_ACCT) {
+		if (mp->m_qflags & XFS_OQUOTA_ENFD)
+			seq_puts(m, "," MNTOPT_GRPQUOTA);
+		else
+			seq_puts(m, "," MNTOPT_GQUOTANOENF);
+	}
+
+	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
+		seq_puts(m, "," MNTOPT_NOQUOTA);
+
 	if (vfsp->vfs_flag & VFS_DMI)
 		seq_puts(m, "," MNTOPT_DMAPI);
-
 	return 0;
 }
 
@@ -2044,7 +2144,6 @@ bhv_vfsops_t xfs_vfsops = {
 	.vfs_statvfs		= xfs_statvfs,
 	.vfs_sync		= xfs_sync,
 	.vfs_vget		= xfs_vget,
-	.vfs_quotactl		= (vfs_quotactl_t)fs_nosys,
 	.vfs_get_inode		= xfs_get_inode,
 	.vfs_init_vnode		= xfs_initialize_vnode,
 	.vfs_force_shutdown	= xfs_do_force_shutdown,
Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm.c	2007-08-23 02:29:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm.c	2007-08-23 14:57:38.000000000 +0200
@@ -284,45 +284,6 @@ xfs_qm_rele_quotafs_ref(
 }
 
 /*
- * This is called at mount time from xfs_mountfs to initialize the quotainfo
- * structure and start the global quota manager (xfs_Gqm) if it hasn't done
- * so already.	Note that the superblock has not been read in yet.
- */
-void
-xfs_qm_mount_quotainit(
-	xfs_mount_t	*mp,
-	uint		flags)
-{
-	/*
-	 * User, projects or group quotas has to be on.
-	 */
-	ASSERT(flags & (XFSMNT_UQUOTA | XFSMNT_PQUOTA | XFSMNT_GQUOTA));
-
-	/*
-	 * Initialize the flags in the mount structure. From this point
-	 * onwards we look at m_qflags to figure out if quotas's ON/OFF, etc.
-	 * Note that we enforce nothing if accounting is off.
-	 * ie.	XFSMNT_*QUOTA must be ON for XFSMNT_*QUOTAENF.
-	 * It isn't necessary to take the quotaoff lock to do this; this is
-	 * called from mount.
-	 */
-	if (flags & XFSMNT_UQUOTA) {
-		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
-		if (flags & XFSMNT_UQUOTAENF)
-			mp->m_qflags |= XFS_UQUOTA_ENFD;
-	}
-	if (flags & XFSMNT_GQUOTA) {
-		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
-		if (flags & XFSMNT_GQUOTAENF)
-			mp->m_qflags |= XFS_OQUOTA_ENFD;
-	} else if (flags & XFSMNT_PQUOTA) {
-		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
-		if (flags & XFSMNT_PQUOTAENF)
-			mp->m_qflags |= XFS_OQUOTA_ENFD;
-	}
-}
-
-/*
  * Just destroy the quotainfo structure.
  */
 void
@@ -1035,7 +996,7 @@ xfs_qm_dqdetach(
 int
 xfs_qm_sync(
 	xfs_mount_t	*mp,
-	short		flags)
+	int		flags)
 {
 	int		recl, restarts;
 	xfs_dquot_t	*dqp;
Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm.h	2007-08-23 02:29:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm.h	2007-08-23 14:57:38.000000000 +0200
@@ -166,12 +166,11 @@ typedef struct xfs_dquot_acct {
 
 extern void		xfs_qm_destroy_quotainfo(xfs_mount_t *);
 extern int		xfs_qm_mount_quotas(xfs_mount_t *, int);
-extern void		xfs_qm_mount_quotainit(xfs_mount_t *, uint);
 extern int		xfs_qm_quotacheck(xfs_mount_t *);
 extern void		xfs_qm_unmount_quotadestroy(xfs_mount_t *);
 extern int		xfs_qm_unmount_quotas(xfs_mount_t *);
 extern int		xfs_qm_write_sb_changes(xfs_mount_t *, __int64_t);
-extern int		xfs_qm_sync(xfs_mount_t *, short);
+extern int		xfs_qm_sync(xfs_mount_t *, int);
 
 /* dquot stuff */
 extern boolean_t	xfs_qm_dqalloc_incore(xfs_dquot_t **);
@@ -199,7 +198,8 @@ extern void		xfs_qm_freelist_unlink(xfs_
 extern int		xfs_qm_freelist_lock_nowait(xfs_qm_t *);
 
 /* system call interface */
-extern int		xfs_qm_quotactl(bhv_desc_t *, int, int, xfs_caddr_t);
+extern int		xfs_qm_quotactl(struct xfs_mount *, int, int,
+				xfs_caddr_t);
 
 #ifdef DEBUG
 extern int		xfs_qm_internalqcheck(xfs_mount_t *);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.h	2007-08-23 14:42:53.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.h	2007-08-23 14:57:38.000000000 +0200
@@ -89,4 +89,7 @@ extern void xfs_blkdev_issue_flush(struc
 
 extern struct export_operations xfs_export_operations;
 
+#define XFS_M(sb) \
+	XFS_VFSTOM(vfs_from_sb(sb))
+
 #endif	/* __XFS_SUPER_H__ */
Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2007-08-23 02:29:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm_syscalls.c	2007-08-23 14:57:38.000000000 +0200
@@ -81,17 +81,14 @@ STATIC void	xfs_qm_export_dquot(xfs_moun
  */
 int
 xfs_qm_quotactl(
-	struct bhv_desc *bdp,
+	xfs_mount_t	*mp,
 	int		cmd,
 	int		id,
 	xfs_caddr_t	addr)
 {
-	xfs_mount_t	*mp;
-	bhv_vfs_t	*vfsp;
+	bhv_vfs_t	*vfsp = XFS_MTOVFS(mp);
 	int		error;
 
-	vfsp = bhvtovfs(bdp);
-	mp = XFS_VFSTOM(vfsp);
 
 	ASSERT(addr != NULL || cmd == Q_XQUOTASYNC);
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-08-23 14:54:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2007-08-23 14:57:38.000000000 +0200
@@ -199,7 +199,6 @@ EXPORT_SYMBOL(vfs_root);
 EXPORT_SYMBOL(vfs_statvfs);
 EXPORT_SYMBOL(vfs_sync);
 EXPORT_SYMBOL(vfs_vget);
-EXPORT_SYMBOL(vfs_quotactl);
 EXPORT_SYMBOL(vfs_get_inode);
 EXPORT_SYMBOL(vfs_init_vnode);
 EXPORT_SYMBOL(vfs_force_shutdown);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.c	2007-08-23 14:54:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.c	2007-08-23 14:57:38.000000000 +0200
@@ -155,21 +155,6 @@ vfs_vget(
 	return ((*bhvtovfsops(next)->vfs_vget)(next, vpp, fidp));
 }
 
-int
-vfs_quotactl(
-	struct bhv_desc		*bdp,
-	int			cmd,
-	int			id,
-	caddr_t			addr)
-{
-	struct bhv_desc		*next = bdp;
-
-	ASSERT(next);
-	while (! (bhvtovfsops(next))->vfs_quotactl)
-		next = BHV_NEXT(next);
-	return ((*bhvtovfsops(next)->vfs_quotactl)(next, cmd, id, addr));
-}
-
 struct inode *
 vfs_get_inode(
 	struct bhv_desc		*bdp,
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.h	2007-08-23 14:54:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h	2007-08-23 14:57:38.000000000 +0200
@@ -127,7 +127,6 @@ typedef int	(*vfs_statvfs_t)(bhv_desc_t 
 				struct inode *);
 typedef int	(*vfs_sync_t)(bhv_desc_t *, int, struct cred *);
 typedef int	(*vfs_vget_t)(bhv_desc_t *, struct inode **, struct fid *);
-typedef int	(*vfs_quotactl_t)(bhv_desc_t *, int, int, caddr_t);
 typedef void	(*vfs_init_vnode_t)(bhv_desc_t *,
 				struct inode *, struct xfs_inode *, int);
 typedef void	(*vfs_force_shutdown_t)(bhv_desc_t *, int, char *, int);
@@ -145,7 +144,6 @@ typedef struct bhv_vfsops {
 	vfs_statvfs_t		vfs_statvfs;	/* file system statistics */
 	vfs_sync_t		vfs_sync;	/* flush files */
 	vfs_vget_t		vfs_vget;	/* get vnode from fid */
-	vfs_quotactl_t		vfs_quotactl;	/* disk quota */
 	vfs_get_inode_t		vfs_get_inode;	/* bhv specific iget */
 	vfs_init_vnode_t	vfs_init_vnode;	/* initialize a new vnode */
 	vfs_force_shutdown_t	vfs_force_shutdown;	/* crash and burn */
@@ -165,7 +163,6 @@ typedef struct bhv_vfsops {
 #define bhv_vfs_statvfs(v, sp,vp)	vfs_statvfs(VFSHEAD(v), sp,vp)
 #define bhv_vfs_sync(v, flag,cr)	vfs_sync(VFSHEAD(v), flag,cr)
 #define bhv_vfs_vget(v, vpp,fidp)	vfs_vget(VFSHEAD(v), vpp,fidp)
-#define bhv_vfs_quotactl(v, c,id,p)	vfs_quotactl(VFSHEAD(v), c,id,p)
 #define bhv_vfs_get_inode(v, ino, fl)	vfs_get_inode(VFSHEAD(v), ino,fl)
 #define bhv_vfs_init_vnode(v, vp,b,ul)	vfs_init_vnode(VFSHEAD(v), vp,b,ul)
 #define bhv_vfs_force_shutdown(v,u,f,l)	vfs_force_shutdown(VFSHEAD(v), u,f,l)
@@ -183,7 +180,6 @@ typedef struct bhv_vfsops {
 #define bhv_next_vfs_statvfs(b, sp,vp)		vfs_statvfs(b, sp,vp)
 #define bhv_next_vfs_sync(b, flag,cr)		vfs_sync(b, flag,cr)
 #define bhv_next_vfs_vget(b, vpp,fidp)		vfs_vget(b, vpp,fidp)
-#define bhv_next_vfs_quotactl(b, c,id,p)	vfs_quotactl(b, c,id,p)
 #define bhv_next_vfs_get_inode(b, ino,fl)	vfs_get_inode(b, ino,fl)
 #define bhv_next_vfs_init_vnode(b, vp,b2,ul)	vfs_init_vnode(b, vp,b2,ul)
 #define bhv_next_force_shutdown(b, fl,f,l)	vfs_force_shutdown(b, fl,f,l)
@@ -198,7 +194,6 @@ extern int vfs_root(bhv_desc_t *, struct
 extern int vfs_statvfs(bhv_desc_t *, bhv_statvfs_t *, struct inode *);
 extern int vfs_sync(bhv_desc_t *, int, struct cred *);
 extern int vfs_vget(bhv_desc_t *, struct inode **, struct fid *);
-extern int vfs_quotactl(bhv_desc_t *, int, int, caddr_t);
 extern struct inode *vfs_get_inode(bhv_desc_t *, xfs_ino_t, int);
 extern void vfs_init_vnode(bhv_desc_t *, struct inode *, struct xfs_inode *, int);
 extern void vfs_force_shutdown(bhv_desc_t *, int, char *, int);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2007-08-23 14:54:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2007-08-23 14:57:38.000000000 +0200
@@ -735,7 +735,7 @@ xfs_fs_quotasync(
 	struct super_block	*sb,
 	int			type)
 {
-	return -bhv_vfs_quotactl(vfs_from_sb(sb), Q_XQUOTASYNC, 0, NULL);
+	return -XFS_QM_QUOTACTL(XFS_M(sb), Q_XQUOTASYNC, 0, NULL);
 }
 
 STATIC int
@@ -743,7 +743,7 @@ xfs_fs_getxstate(
 	struct super_block	*sb,
 	struct fs_quota_stat	*fqs)
 {
-	return -bhv_vfs_quotactl(vfs_from_sb(sb), Q_XGETQSTAT, 0, (caddr_t)fqs);
+	return -XFS_QM_QUOTACTL(XFS_M(sb), Q_XGETQSTAT, 0, (caddr_t)fqs);
 }
 
 STATIC int
@@ -752,7 +752,7 @@ xfs_fs_setxstate(
 	unsigned int		flags,
 	int			op)
 {
-	return -bhv_vfs_quotactl(vfs_from_sb(sb), op, 0, (caddr_t)&flags);
+	return -XFS_QM_QUOTACTL(XFS_M(sb), op, 0, (caddr_t)&flags);
 }
 
 STATIC int
@@ -762,7 +762,7 @@ xfs_fs_getxquota(
 	qid_t			id,
 	struct fs_disk_quota	*fdq)
 {
-	return -bhv_vfs_quotactl(vfs_from_sb(sb),
+	return -XFS_QM_QUOTACTL(XFS_M(sb),
 				 (type == USRQUOTA) ? Q_XGETQUOTA :
 				  ((type == GRPQUOTA) ? Q_XGETGQUOTA :
 				   Q_XGETPQUOTA), id, (caddr_t)fdq);
@@ -775,7 +775,7 @@ xfs_fs_setxquota(
 	qid_t			id,
 	struct fs_disk_quota	*fdq)
 {
-	return -bhv_vfs_quotactl(vfs_from_sb(sb),
+	return -XFS_QM_QUOTACTL(XFS_M(sb),
 				 (type == USRQUOTA) ? Q_XSETQLIM :
 				  ((type == GRPQUOTA) ? Q_XSETGQLIM :
 				   Q_XSETPQLIM), id, (caddr_t)fdq);
Index: linux-2.6-xfs/fs/xfs/xfs_qmops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_qmops.c	2007-08-23 02:29:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_qmops.c	2007-08-23 14:57:38.000000000 +0200
@@ -28,6 +28,8 @@
 #include "xfs_mount.h"
 #include "xfs_quota.h"
 #include "xfs_error.h"
+#include "xfs_clnt.h"
+
 
 STATIC struct xfs_dquot *
 xfs_dqvopchown_default(
@@ -110,7 +112,7 @@ xfs_noquota_init(
 	return error;
 }
 
-xfs_qmops_t	xfs_qmcore_stub = {
+static struct xfs_qmops xfs_qmcore_stub = {
 	.xfs_qminit		= (xfs_qminit_t) xfs_noquota_init,
 	.xfs_qmdone		= (xfs_qmdone_t) fs_noerr,
 	.xfs_qmmount		= (xfs_qmmount_t) fs_noerr,
@@ -124,4 +126,38 @@ xfs_qmops_t	xfs_qmcore_stub = {
 	.xfs_dqvoprename	= (xfs_dqvoprename_t) fs_noerr,
 	.xfs_dqvopchown		= xfs_dqvopchown_default,
 	.xfs_dqvopchownresv	= (xfs_dqvopchownresv_t) fs_noerr,
+	.xfs_dqstatvfs		= (xfs_dqstatvfs_t) fs_noval,
+	.xfs_dqsync		= (xfs_dqsync_t) fs_noerr,
+	.xfs_quotactl		= (xfs_quotactl_t) fs_noerr,
 };
+
+int
+xfs_qmops_get(struct xfs_mount *mp, struct xfs_mount_args *args)
+{
+	if (args->flags & (XFSMNT_UQUOTA | XFSMNT_PQUOTA | XFSMNT_GQUOTA)) {
+		struct xfs_qmops *ops;
+
+		ops = symbol_get(xfs_qmcore_xfs);
+		if (!ops) {
+			request_module("xfs_quota");
+			ops = symbol_get(xfs_qmcore_xfs);
+		}
+
+		if (!ops) {
+			cmn_err(CE_WARN, "XFS: no quota support available.");
+			return EINVAL;
+		}
+		mp->m_qm_ops = ops;
+	} else {
+		mp->m_qm_ops = &xfs_qmcore_stub;
+	}
+
+	return 0;
+}
+
+void
+xfs_qmops_put(struct xfs_mount *mp)
+{
+	if (mp->m_qm_ops != &xfs_qmcore_stub)
+		symbol_put(xfs_qmcore_xfs);
+}
