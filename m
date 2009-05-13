Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4D8AvAF128576 for <xfs@oss.sgi.com>; Wed, 13 May 2009 03:10:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBC57BFFE19
	for <xfs@oss.sgi.com>; Wed, 13 May 2009 01:15:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ep4I9U3WhT24OH5n for
	<xfs@oss.sgi.com>; Wed, 13 May 2009 01:15:41 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1M49YM-0007cq-9t
	for xfs@oss.sgi.com; Wed, 13 May 2009 08:11:02 +0000
Date: Wed, 13 May 2009 04:11:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/17] xfs: get rid of indirections in the quotaops
	implementation
Message-ID: <20090513081102.GA21962@infradead.org>
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126073202.961302000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090126073202.961302000@bombadil.infradead.org>
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

On Mon, Jan 26, 2009 at 02:31:49AM -0500, Christoph Hellwig wrote:
> Currently we call from the nicely abstracted linux quotaops into a ugly
> multiplexer just to split the calls out at the same boundary again.
> Rewrite the quota ops handling to remove that obfucation.

What's the chance of getting a full review for this one after almost
four month?

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2009-01-24 18:50:29.764553115 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_super.c	2009-01-24 18:52:52.180428678 +0100
> @@ -68,7 +68,6 @@
>  #include <linux/freezer.h>
>  #include <linux/parser.h>
>  
> -static struct quotactl_ops xfs_quotactl_operations;
>  static struct super_operations xfs_super_operations;
>  static kmem_zone_t *xfs_ioend_zone;
>  mempool_t *xfs_ioend_pool;
> @@ -1333,57 +1332,6 @@ xfs_fs_show_options(
>  	return -xfs_showargs(XFS_M(mnt->mnt_sb), m);
>  }
>  
> -STATIC int
> -xfs_fs_quotasync(
> -	struct super_block	*sb,
> -	int			type)
> -{
> -	return -XFS_QM_QUOTACTL(XFS_M(sb), Q_XQUOTASYNC, 0, NULL);
> -}
> -
> -STATIC int
> -xfs_fs_getxstate(
> -	struct super_block	*sb,
> -	struct fs_quota_stat	*fqs)
> -{
> -	return -XFS_QM_QUOTACTL(XFS_M(sb), Q_XGETQSTAT, 0, (caddr_t)fqs);
> -}
> -
> -STATIC int
> -xfs_fs_setxstate(
> -	struct super_block	*sb,
> -	unsigned int		flags,
> -	int			op)
> -{
> -	return -XFS_QM_QUOTACTL(XFS_M(sb), op, 0, (caddr_t)&flags);
> -}
> -
> -STATIC int
> -xfs_fs_getxquota(
> -	struct super_block	*sb,
> -	int			type,
> -	qid_t			id,
> -	struct fs_disk_quota	*fdq)
> -{
> -	return -XFS_QM_QUOTACTL(XFS_M(sb),
> -				 (type == USRQUOTA) ? Q_XGETQUOTA :
> -				  ((type == GRPQUOTA) ? Q_XGETGQUOTA :
> -				   Q_XGETPQUOTA), id, (caddr_t)fdq);
> -}
> -
> -STATIC int
> -xfs_fs_setxquota(
> -	struct super_block	*sb,
> -	int			type,
> -	qid_t			id,
> -	struct fs_disk_quota	*fdq)
> -{
> -	return -XFS_QM_QUOTACTL(XFS_M(sb),
> -				 (type == USRQUOTA) ? Q_XSETQLIM :
> -				  ((type == GRPQUOTA) ? Q_XSETGQLIM :
> -				   Q_XSETPQLIM), id, (caddr_t)fdq);
> -}
> -
>  /*
>   * This function fills in xfs_mount_t fields based on mount args.
>   * Note: the superblock _has_ now been read in.
> @@ -1466,7 +1414,9 @@ xfs_fs_fill_super(
>  	sb_min_blocksize(sb, BBSIZE);
>  	sb->s_xattr = xfs_xattr_handlers;
>  	sb->s_export_op = &xfs_export_operations;
> +#ifdef CONFIG_XFS_QUOTA
>  	sb->s_qcop = &xfs_quotactl_operations;
> +#endif
>  	sb->s_op = &xfs_super_operations;
>  
>  	error = xfs_dmops_get(mp);
> @@ -1609,14 +1559,6 @@ static struct super_operations xfs_super
>  	.show_options		= xfs_fs_show_options,
>  };
>  
> -static struct quotactl_ops xfs_quotactl_operations = {
> -	.quota_sync		= xfs_fs_quotasync,
> -	.get_xstate		= xfs_fs_getxstate,
> -	.set_xstate		= xfs_fs_setxstate,
> -	.get_xquota		= xfs_fs_getxquota,
> -	.set_xquota		= xfs_fs_setxquota,
> -};
> -
>  static struct file_system_type xfs_fs_type = {
>  	.owner			= THIS_MODULE,
>  	.name			= "xfs",
> Index: xfs/fs/xfs/Makefile
> ===================================================================
> --- xfs.orig/fs/xfs/Makefile	2009-01-21 21:03:27.824295159 +0100
> +++ xfs/fs/xfs/Makefile	2009-01-24 18:52:52.184428210 +0100
> @@ -33,6 +33,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= $(addprefix 
>  				   xfs_qm_syscalls.o \
>  				   xfs_qm_bhv.o \
>  				   xfs_qm.o)
> +xfs-$(CONFIG_XFS_QUOTA)		+= linux-2.6/xfs_quotaops.o
>  
>  ifeq ($(CONFIG_XFS_QUOTA),y)
>  xfs-$(CONFIG_PROC_FS)		+= quota/xfs_qm_stats.o
> Index: xfs/fs/xfs/linux-2.6/xfs_linux.h
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2009-01-21 21:03:27.828295110 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_linux.h	2009-01-24 18:52:52.191428473 +0100
> @@ -147,17 +147,6 @@
>  #define SYNCHRONIZE()	barrier()
>  #define __return_address __builtin_return_address(0)
>  
> -/*
> - * IRIX (BSD) quotactl makes use of separate commands for user/group,
> - * whereas on Linux the syscall encodes this information into the cmd
> - * field (see the QCMD macro in quota.h).  These macros help keep the
> - * code portable - they are not visible from the syscall interface.
> - */
> -#define Q_XSETGQLIM	XQM_CMD(8)	/* set groups disk limits */
> -#define Q_XGETGQUOTA	XQM_CMD(9)	/* get groups disk limits */
> -#define Q_XSETPQLIM	XQM_CMD(10)	/* set projects disk limits */
> -#define Q_XGETPQUOTA	XQM_CMD(11)	/* get projects disk limits */
> -
>  #define dfltprid	0
>  #define MAXPATHLEN	1024
>  
> Index: xfs/fs/xfs/linux-2.6/xfs_quotaops.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfs/fs/xfs/linux-2.6/xfs_quotaops.c	2009-01-24 18:52:52.192428740 +0100
> @@ -0,0 +1,157 @@
> +/*
> + * Copyright (c) 2008, Christoph Hellwig
> + * All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +#include "xfs.h"
> +#include "xfs_dmapi.h"
> +#include "xfs_sb.h"
> +#include "xfs_inum.h"
> +#include "xfs_ag.h"
> +#include "xfs_mount.h"
> +#include "xfs_quota.h"
> +#include "xfs_log.h"
> +#include "xfs_trans.h"
> +#include "xfs_bmap_btree.h"
> +#include "xfs_inode.h"
> +#include "quota/xfs_qm.h"
> +#include <linux/quota.h>
> +
> +
> +STATIC int
> +xfs_quota_type(int type)
> +{
> +	switch (type) {
> +	case USRQUOTA:
> +		return XFS_DQ_USER;
> +	case GRPQUOTA:
> +		return XFS_DQ_GROUP;
> +	default:
> +		return XFS_DQ_PROJ;
> +	}
> +}
> +
> +STATIC int
> +xfs_fs_quota_sync(
> +	struct super_block	*sb,
> +	int			type)
> +{
> +	struct xfs_mount	*mp = XFS_M(sb);
> +
> +	if (!XFS_IS_QUOTA_RUNNING(mp))
> +		return -ENOSYS;
> +	return -xfs_sync_inodes(mp, SYNC_DELWRI);
> +}
> +
> +STATIC int
> +xfs_fs_get_xstate(
> +	struct super_block	*sb,
> +	struct fs_quota_stat	*fqs)
> +{
> +	struct xfs_mount	*mp = XFS_M(sb);
> +
> +	if (!XFS_IS_QUOTA_RUNNING(mp))
> +		return -ENOSYS;
> +	return xfs_qm_scall_getqstat(mp, fqs);
> +}
> +
> +STATIC int
> +xfs_fs_set_xstate(
> +	struct super_block	*sb,
> +	unsigned int		uflags,
> +	int			op)
> +{
> +	struct xfs_mount	*mp = XFS_M(sb);
> +	unsigned int		flags = 0;
> +
> +	if (sb->s_flags & MS_RDONLY)
> +		return -EROFS;
> +	if (!XFS_IS_QUOTA_RUNNING(mp))
> +		return -ENOSYS;
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (uflags & XFS_QUOTA_UDQ_ACCT)
> +		flags |= XFS_UQUOTA_ACCT;
> +	if (uflags & XFS_QUOTA_PDQ_ACCT)
> +		flags |= XFS_PQUOTA_ACCT;
> +	if (uflags & XFS_QUOTA_GDQ_ACCT)
> +		flags |= XFS_GQUOTA_ACCT;
> +	if (uflags & XFS_QUOTA_UDQ_ENFD)
> +		flags |= XFS_UQUOTA_ENFD;
> +	if (uflags & (XFS_QUOTA_PDQ_ENFD|XFS_QUOTA_GDQ_ENFD))
> +		flags |= XFS_OQUOTA_ENFD;
> +
> +	switch (op) {
> +	case Q_XQUOTAON:
> +		return -xfs_qm_scall_quotaon(mp, flags);
> +	case Q_XQUOTAOFF:
> +		if (!XFS_IS_QUOTA_ON(mp))
> +			return -EINVAL;
> +		return -xfs_qm_scall_quotaoff(mp, flags);
> +	case Q_XQUOTARM:
> +		if (XFS_IS_QUOTA_ON(mp))
> +			return -EINVAL;
> +		return -xfs_qm_scall_trunc_qfiles(mp, flags);
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +STATIC int
> +xfs_fs_get_xquota(
> +	struct super_block	*sb,
> +	int			type,
> +	qid_t			id,
> +	struct fs_disk_quota	*fdq)
> +{
> +	struct xfs_mount	*mp = XFS_M(sb);
> +
> +	if (!XFS_IS_QUOTA_RUNNING(mp))
> +		return -ENOSYS;
> +	if (!XFS_IS_QUOTA_ON(mp))
> +		return -ESRCH;
> +
> +	return -xfs_qm_scall_getquota(mp, id, xfs_quota_type(type), fdq);
> +}
> +
> +STATIC int
> +xfs_fs_set_xquota(
> +	struct super_block	*sb,
> +	int			type,
> +	qid_t			id,
> +	struct fs_disk_quota	*fdq)
> +{
> +	struct xfs_mount	*mp = XFS_M(sb);
> +
> +	if (sb->s_flags & MS_RDONLY)
> +		return -EROFS;
> +	if (!XFS_IS_QUOTA_RUNNING(mp))
> +		return -ENOSYS;
> +	if (!XFS_IS_QUOTA_ON(mp))
> +		return -ESRCH;
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	return xfs_qm_scall_setqlim(mp, id, xfs_quota_type(type), fdq);
> +}
> +
> +struct quotactl_ops xfs_quotactl_operations = {
> +	.quota_sync		= xfs_fs_quota_sync,
> +	.get_xstate		= xfs_fs_get_xstate,
> +	.set_xstate		= xfs_fs_set_xstate,
> +	.get_xquota		= xfs_fs_get_xquota,
> +	.set_xquota		= xfs_fs_set_xquota,
> +};
> Index: xfs/fs/xfs/linux-2.6/xfs_super.h
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_super.h	2009-01-21 21:03:27.831294794 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_super.h	2009-01-24 18:52:52.192428740 +0100
> @@ -93,6 +93,7 @@ extern void xfs_blkdev_issue_flush(struc
>  
>  extern const struct export_operations xfs_export_operations;
>  extern struct xattr_handler *xfs_xattr_handlers[];
> +extern struct quotactl_ops xfs_quotactl_operations;
>  
>  #define XFS_M(sb)		((struct xfs_mount *)((sb)->s_fs_info))
>  
> Index: xfs/fs/xfs/linux-2.6/xfs_sync.h
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_sync.h	2009-01-24 17:58:49.029903800 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_sync.h	2009-01-24 18:52:52.203535043 +0100
> @@ -19,6 +19,7 @@
>  #define XFS_SYNC_H 1
>  
>  struct xfs_mount;
> +struct xfs_perag;
>  
>  typedef struct bhv_vfs_sync_work {
>  	struct list_head	w_list;
> Index: xfs/fs/xfs/quota/xfs_qm.h
> ===================================================================
> --- xfs.orig/fs/xfs/quota/xfs_qm.h	2009-01-21 21:03:27.835294745 +0100
> +++ xfs/fs/xfs/quota/xfs_qm.h	2009-01-24 18:52:52.206583965 +0100
> @@ -178,6 +178,16 @@ extern void		xfs_qm_dqdetach(xfs_inode_t
>  extern int		xfs_qm_dqpurge_all(xfs_mount_t *, uint);
>  extern void		xfs_qm_dqrele_all_inodes(xfs_mount_t *, uint);
>  
> +/* quota ops */
> +extern int		xfs_qm_scall_trunc_qfiles(xfs_mount_t *, uint);
> +extern int		xfs_qm_scall_getquota(xfs_mount_t *, xfs_dqid_t, uint,
> +					fs_disk_quota_t *);
> +extern int		xfs_qm_scall_setqlim(xfs_mount_t *, xfs_dqid_t, uint,
> +					fs_disk_quota_t *);
> +extern int		xfs_qm_scall_getqstat(xfs_mount_t *, fs_quota_stat_t *);
> +extern int		xfs_qm_scall_quotaon(xfs_mount_t *, uint);
> +extern int		xfs_qm_scall_quotaoff(xfs_mount_t *, uint);
> +
>  /* vop stuff */
>  extern int		xfs_qm_vop_dqalloc(xfs_mount_t *, xfs_inode_t *,
>  					uid_t, gid_t, prid_t, uint,
> @@ -196,10 +206,6 @@ extern void		xfs_qm_freelist_append(xfs_
>  extern void		xfs_qm_freelist_unlink(xfs_dquot_t *);
>  extern int		xfs_qm_freelist_lock_nowait(xfs_qm_t *);
>  
> -/* system call interface */
> -extern int		xfs_qm_quotactl(struct xfs_mount *, int, int,
> -				xfs_caddr_t);
> -
>  #ifdef DEBUG
>  extern int		xfs_qm_internalqcheck(xfs_mount_t *);
>  #else
> Index: xfs/fs/xfs/quota/xfs_qm_bhv.c
> ===================================================================
> --- xfs.orig/fs/xfs/quota/xfs_qm_bhv.c	2009-01-21 21:03:27.836295012 +0100
> +++ xfs/fs/xfs/quota/xfs_qm_bhv.c	2009-01-24 18:52:52.206583965 +0100
> @@ -235,7 +235,6 @@ struct xfs_qmops xfs_qmcore_xfs = {
>  	.xfs_dqvopchownresv	= xfs_qm_vop_chown_reserve,
>  	.xfs_dqstatvfs		= xfs_qm_statvfs,
>  	.xfs_dqsync		= xfs_qm_sync,
> -	.xfs_quotactl		= xfs_qm_quotactl,
>  	.xfs_dqtrxops		= &xfs_trans_dquot_ops,
>  };
>  EXPORT_SYMBOL(xfs_qmcore_xfs);
> Index: xfs/fs/xfs/quota/xfs_qm_syscalls.c
> ===================================================================
> --- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2009-01-21 21:03:27.836295012 +0100
> +++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2009-01-24 18:52:52.207553991 +0100
> @@ -57,135 +57,16 @@
>  # define qdprintk(s, args...)	do { } while (0)
>  #endif
>  
> -STATIC int	xfs_qm_scall_trunc_qfiles(xfs_mount_t *, uint);
> -STATIC int	xfs_qm_scall_getquota(xfs_mount_t *, xfs_dqid_t, uint,
> -					fs_disk_quota_t *);
> -STATIC int	xfs_qm_scall_getqstat(xfs_mount_t *, fs_quota_stat_t *);
> -STATIC int	xfs_qm_scall_setqlim(xfs_mount_t *, xfs_dqid_t, uint,
> -					fs_disk_quota_t *);
> -STATIC int	xfs_qm_scall_quotaon(xfs_mount_t *, uint);
> -STATIC int	xfs_qm_scall_quotaoff(xfs_mount_t *, uint, boolean_t);
>  STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
>  STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
>  					uint);
> -STATIC uint	xfs_qm_import_flags(uint);
>  STATIC uint	xfs_qm_export_flags(uint);
> -STATIC uint	xfs_qm_import_qtype_flags(uint);
>  STATIC uint	xfs_qm_export_qtype_flags(uint);
>  STATIC void	xfs_qm_export_dquot(xfs_mount_t *, xfs_disk_dquot_t *,
>  					fs_disk_quota_t *);
>  
>  
>  /*
> - * The main distribution switch of all XFS quotactl system calls.
> - */
> -int
> -xfs_qm_quotactl(
> -	xfs_mount_t	*mp,
> -	int		cmd,
> -	int		id,
> -	xfs_caddr_t	addr)
> -{
> -	int		error;
> -
> -	ASSERT(addr != NULL || cmd == Q_XQUOTASYNC);
> -
> -	/*
> -	 * The following commands are valid even when quotaoff.
> -	 */
> -	switch (cmd) {
> -	case Q_XQUOTARM:
> -		/*
> -		 * Truncate quota files. quota must be off.
> -		 */
> -		if (XFS_IS_QUOTA_ON(mp))
> -			return XFS_ERROR(EINVAL);
> -		if (mp->m_flags & XFS_MOUNT_RDONLY)
> -			return XFS_ERROR(EROFS);
> -		return (xfs_qm_scall_trunc_qfiles(mp,
> -			       xfs_qm_import_qtype_flags(*(uint *)addr)));
> -
> -	case Q_XGETQSTAT:
> -		/*
> -		 * Get quota status information.
> -		 */
> -		return (xfs_qm_scall_getqstat(mp, (fs_quota_stat_t *)addr));
> -
> -	case Q_XQUOTAON:
> -		/*
> -		 * QUOTAON - enabling quota enforcement.
> -		 * Quota accounting must be turned on at mount time.
> -		 */
> -		if (mp->m_flags & XFS_MOUNT_RDONLY)
> -			return XFS_ERROR(EROFS);
> -		return (xfs_qm_scall_quotaon(mp,
> -					  xfs_qm_import_flags(*(uint *)addr)));
> -
> -	case Q_XQUOTAOFF:
> -		if (mp->m_flags & XFS_MOUNT_RDONLY)
> -			return XFS_ERROR(EROFS);
> -		break;
> -
> -	case Q_XQUOTASYNC:
> -		return xfs_sync_inodes(mp, SYNC_DELWRI);
> -
> -	default:
> -		break;
> -	}
> -
> -	if (! XFS_IS_QUOTA_ON(mp))
> -		return XFS_ERROR(ESRCH);
> -
> -	switch (cmd) {
> -	case Q_XQUOTAOFF:
> -		if (mp->m_flags & XFS_MOUNT_RDONLY)
> -			return XFS_ERROR(EROFS);
> -		error = xfs_qm_scall_quotaoff(mp,
> -					    xfs_qm_import_flags(*(uint *)addr),
> -					    B_FALSE);
> -		break;
> -
> -	case Q_XGETQUOTA:
> -		error = xfs_qm_scall_getquota(mp, (xfs_dqid_t)id, XFS_DQ_USER,
> -					(fs_disk_quota_t *)addr);
> -		break;
> -	case Q_XGETGQUOTA:
> -		error = xfs_qm_scall_getquota(mp, (xfs_dqid_t)id, XFS_DQ_GROUP,
> -					(fs_disk_quota_t *)addr);
> -		break;
> -	case Q_XGETPQUOTA:
> -		error = xfs_qm_scall_getquota(mp, (xfs_dqid_t)id, XFS_DQ_PROJ,
> -					(fs_disk_quota_t *)addr);
> -		break;
> -
> -	case Q_XSETQLIM:
> -		if (mp->m_flags & XFS_MOUNT_RDONLY)
> -			return XFS_ERROR(EROFS);
> -		error = xfs_qm_scall_setqlim(mp, (xfs_dqid_t)id, XFS_DQ_USER,
> -					     (fs_disk_quota_t *)addr);
> -		break;
> -	case Q_XSETGQLIM:
> -		if (mp->m_flags & XFS_MOUNT_RDONLY)
> -			return XFS_ERROR(EROFS);
> -		error = xfs_qm_scall_setqlim(mp, (xfs_dqid_t)id, XFS_DQ_GROUP,
> -					     (fs_disk_quota_t *)addr);
> -		break;
> -	case Q_XSETPQLIM:
> -		if (mp->m_flags & XFS_MOUNT_RDONLY)
> -			return XFS_ERROR(EROFS);
> -		error = xfs_qm_scall_setqlim(mp, (xfs_dqid_t)id, XFS_DQ_PROJ,
> -					     (fs_disk_quota_t *)addr);
> -		break;
> -
> -	default:
> -		error = XFS_ERROR(EINVAL);
> -		break;
> -	}
> -
> -	return (error);
> -}
> -
> -/*
>   * Turn off quota accounting and/or enforcement for all udquots and/or
>   * gdquots. Called only at unmount time.
>   *
> @@ -193,11 +74,10 @@ xfs_qm_quotactl(
>   * incore, and modifies the ondisk dquot directly. Therefore, for example,
>   * it is an error to call this twice, without purging the cache.
>   */
> -STATIC int
> +int
>  xfs_qm_scall_quotaoff(
>  	xfs_mount_t		*mp,
> -	uint			flags,
> -	boolean_t		force)
> +	uint			flags)
>  {
>  	uint			dqtype;
>  	int			error;
> @@ -205,8 +85,6 @@ xfs_qm_scall_quotaoff(
>  	xfs_qoff_logitem_t	*qoffstart;
>  	int			nculprits;
>  
> -	if (!force && !capable(CAP_SYS_ADMIN))
> -		return XFS_ERROR(EPERM);
>  	/*
>  	 * No file system can have quotas enabled on disk but not in core.
>  	 * Note that quota utilities (like quotaoff) _expect_
> @@ -375,7 +253,7 @@ out_error:
>  	return (error);
>  }
>  
> -STATIC int
> +int
>  xfs_qm_scall_trunc_qfiles(
>  	xfs_mount_t	*mp,
>  	uint		flags)
> @@ -383,8 +261,6 @@ xfs_qm_scall_trunc_qfiles(
>  	int		error = 0, error2 = 0;
>  	xfs_inode_t	*qip;
>  
> -	if (!capable(CAP_SYS_ADMIN))
> -		return XFS_ERROR(EPERM);
>  	if (!xfs_sb_version_hasquota(&mp->m_sb) || flags == 0) {
>  		qdprintk("qtrunc flags=%x m_qflags=%x\n", flags, mp->m_qflags);
>  		return XFS_ERROR(EINVAL);
> @@ -416,7 +292,7 @@ xfs_qm_scall_trunc_qfiles(
>   * effect immediately.
>   * (Switching on quota accounting must be done at mount time.)
>   */
> -STATIC int
> +int
>  xfs_qm_scall_quotaon(
>  	xfs_mount_t	*mp,
>  	uint		flags)
> @@ -426,9 +302,6 @@ xfs_qm_scall_quotaon(
>  	uint		accflags;
>  	__int64_t	sbflags;
>  
> -	if (!capable(CAP_SYS_ADMIN))
> -		return XFS_ERROR(EPERM);
> -
>  	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
>  	/*
>  	 * Switching on quota accounting must be done at mount time.
> @@ -517,7 +390,7 @@ xfs_qm_scall_quotaon(
>  /*
>   * Return quota status information, such as uquota-off, enforcements, etc.
>   */
> -STATIC int
> +int
>  xfs_qm_scall_getqstat(
>  	xfs_mount_t	*mp,
>  	fs_quota_stat_t *out)
> @@ -582,7 +455,7 @@ xfs_qm_scall_getqstat(
>  /*
>   * Adjust quota limits, and start/stop timers accordingly.
>   */
> -STATIC int
> +int
>  xfs_qm_scall_setqlim(
>  	xfs_mount_t		*mp,
>  	xfs_dqid_t		id,
> @@ -595,9 +468,6 @@ xfs_qm_scall_setqlim(
>  	int			error;
>  	xfs_qcnt_t		hard, soft;
>  
> -	if (!capable(CAP_SYS_ADMIN))
> -		return XFS_ERROR(EPERM);
> -
>  	if ((newlim->d_fieldmask &
>  	    (FS_DQ_LIMIT_MASK|FS_DQ_TIMER_MASK|FS_DQ_WARNS_MASK)) == 0)
>  		return (0);
> @@ -742,7 +612,7 @@ xfs_qm_scall_setqlim(
>  	return error;
>  }
>  
> -STATIC int
> +int
>  xfs_qm_scall_getquota(
>  	xfs_mount_t	*mp,
>  	xfs_dqid_t	id,
> @@ -935,30 +805,6 @@ xfs_qm_export_dquot(
>  }
>  
>  STATIC uint
> -xfs_qm_import_qtype_flags(
> -	uint		uflags)
> -{
> -	uint		oflags = 0;
> -
> -	/*
> -	 * Can't be more than one, or none.
> -	 */
> -	if (((uflags & (XFS_GROUP_QUOTA | XFS_USER_QUOTA)) ==
> -			(XFS_GROUP_QUOTA | XFS_USER_QUOTA)) ||
> -	    ((uflags & (XFS_GROUP_QUOTA | XFS_PROJ_QUOTA)) ==
> -			(XFS_GROUP_QUOTA | XFS_PROJ_QUOTA)) ||
> -	    ((uflags & (XFS_USER_QUOTA | XFS_PROJ_QUOTA)) ==
> -			(XFS_USER_QUOTA | XFS_PROJ_QUOTA)) ||
> -	    ((uflags & (XFS_GROUP_QUOTA|XFS_USER_QUOTA|XFS_PROJ_QUOTA)) == 0))
> -		return (0);
> -
> -	oflags |= (uflags & XFS_USER_QUOTA) ? XFS_DQ_USER : 0;
> -	oflags |= (uflags & XFS_PROJ_QUOTA) ? XFS_DQ_PROJ : 0;
> -	oflags |= (uflags & XFS_GROUP_QUOTA) ? XFS_DQ_GROUP: 0;
> -	return oflags;
> -}
> -
> -STATIC uint
>  xfs_qm_export_qtype_flags(
>  	uint flags)
>  {
> @@ -979,26 +825,6 @@ xfs_qm_export_qtype_flags(
>  }
>  
>  STATIC uint
> -xfs_qm_import_flags(
> -	uint uflags)
> -{
> -	uint flags = 0;
> -
> -	if (uflags & XFS_QUOTA_UDQ_ACCT)
> -		flags |= XFS_UQUOTA_ACCT;
> -	if (uflags & XFS_QUOTA_PDQ_ACCT)
> -		flags |= XFS_PQUOTA_ACCT;
> -	if (uflags & XFS_QUOTA_GDQ_ACCT)
> -		flags |= XFS_GQUOTA_ACCT;
> -	if (uflags & XFS_QUOTA_UDQ_ENFD)
> -		flags |= XFS_UQUOTA_ENFD;
> -	if (uflags & (XFS_QUOTA_PDQ_ENFD|XFS_QUOTA_GDQ_ENFD))
> -		flags |= XFS_OQUOTA_ENFD;
> -	return (flags);
> -}
> -
> -
> -STATIC uint
>  xfs_qm_export_flags(
>  	uint flags)
>  {
> Index: xfs/fs/xfs/xfs_mount.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_mount.h	2009-01-24 18:32:57.980458591 +0100
> +++ xfs/fs/xfs/xfs_mount.h	2009-01-24 18:52:52.208554118 +0100
> @@ -136,7 +136,6 @@ typedef int	(*xfs_dqvopchownresv_t)(stru
>  			struct xfs_dquot *, struct xfs_dquot *, uint);
>  typedef void	(*xfs_dqstatvfs_t)(struct xfs_inode *, struct kstatfs *);
>  typedef int	(*xfs_dqsync_t)(struct xfs_mount *, int flags);
> -typedef int	(*xfs_quotactl_t)(struct xfs_mount *, int, int, xfs_caddr_t);
>  
>  typedef struct xfs_qmops {
>  	xfs_qminit_t		xfs_qminit;
> @@ -154,7 +153,6 @@ typedef struct xfs_qmops {
>  	xfs_dqvopchownresv_t	xfs_dqvopchownresv;
>  	xfs_dqstatvfs_t		xfs_dqstatvfs;
>  	xfs_dqsync_t		xfs_dqsync;
> -	xfs_quotactl_t		xfs_quotactl;
>  	struct xfs_dqtrxops	*xfs_dqtrxops;
>  } xfs_qmops_t;
>  
> @@ -188,8 +186,6 @@ typedef struct xfs_qmops {
>  	(*(ip)->i_mount->m_qm_ops->xfs_dqstatvfs)(ip, statp)
>  #define XFS_QM_DQSYNC(mp, flags) \
>  	(*(mp)->m_qm_ops->xfs_dqsync)(mp, flags)
> -#define XFS_QM_QUOTACTL(mp, cmd, id, addr) \
> -	(*(mp)->m_qm_ops->xfs_quotactl)(mp, cmd, id, addr)
>  
>  #ifdef HAVE_PERCPU_SB
>  
> Index: xfs/fs/xfs/xfs_qmops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_qmops.c	2009-01-21 21:03:27.866294994 +0100
> +++ xfs/fs/xfs/xfs_qmops.c	2009-01-24 18:52:52.208554118 +0100
> @@ -126,7 +126,6 @@ static struct xfs_qmops xfs_qmcore_stub 
>  	.xfs_dqvopchownresv	= (xfs_dqvopchownresv_t) fs_noerr,
>  	.xfs_dqstatvfs		= (xfs_dqstatvfs_t) fs_noval,
>  	.xfs_dqsync		= (xfs_dqsync_t) fs_noerr,
> -	.xfs_quotactl		= (xfs_quotactl_t) fs_nosys,
>  };
>  
>  int
> Index: xfs/fs/xfs/xfs_quota.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_quota.h	2009-01-21 21:03:27.866294994 +0100
> +++ xfs/fs/xfs/xfs_quota.h	2009-01-24 18:52:52.211583834 +0100
> @@ -18,6 +18,8 @@
>  #ifndef __XFS_QUOTA_H__
>  #define __XFS_QUOTA_H__
>  
> +struct xfs_trans;
> +
>  /*
>   * The ondisk form of a dquot structure.
>   */
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
