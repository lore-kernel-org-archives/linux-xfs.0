Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4QHYt09153937 for <xfs@oss.sgi.com>; Tue, 26 May 2009 12:34:55 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C086D1A1ED97
	for <xfs@oss.sgi.com>; Tue, 26 May 2009 10:35:08 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id p8bO59O41Pgbse8n for <xfs@oss.sgi.com>;
	Tue, 26 May 2009 10:35:08 -0700 (PDT)
Message-ID: <4A1C2839.3010005@sandeen.net>
Date: Tue, 26 May 2009 12:34:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: kill xfs_qmops
References: <20090224143736.GA16616@infradead.org>
In-Reply-To: <20090224143736.GA16616@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Kill the quota ops function vector and replace it with direct calls or
> stubs in the CONFIG_XFS_QUOTA=n case.
> 
> Make sure we check XFS_IS_QUOTA_RUNNING in the right spots.  We can remove
> the number of those checks because the XFS_TRANS_DQ_DIRTY flag can't be set
> otherwise.
> 
> This brings us back closer to the way this code worked in IRIX and earlier
> Linux versions, but we keep a lot of the more useful factoring of common
> code.
> 
> Eventually we should also kill xfs_qm_bhv.c, but that's left for a later
> patch.
> 
> Reduces the size of the source code by about 250 lines and the size of
> XFS module by about 1.5 kilobytes with quotas enabled:
> 
>    text	   data	    bss	    dec	    hex	filename
>  615957	   2960	   3848	 622765	  980ad	fs/xfs/xfs.o
>  617231	   3152	   3848	 624231	  98667	fs/xfs/xfs.o.old
> 
> 
> Fallout:
> 
>  - xfs_qm_dqattach is split into xfs_qm_dqattach_locked which expects
>    the inode locked and xfs_qm_dqattach which does the locking around it,
>    thus removing XFS_QMOPT_ILOCKED.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

a few nitpicks & questions below

> @@ -1398,14 +1400,16 @@ xfs_create(
>  	uint			cancel_flags;
>  	int			committed;
>  	xfs_prid_t		prid;
> -	struct xfs_dquot	*udqp = NULL;
> -	struct xfs_dquot	*gdqp = NULL;
> +	struct xfs_dquot	*udqp, *gdqp;
>  	uint			resblks;
>  	uint			log_res;
>  	uint			log_count;
>  
>  	xfs_itrace_entry(dp);
>  
> +	udqp = NULL;
> +	gdqp = NULL;

Just wondering about the reason for this change?  in xfs_ioctl_setattr()
it's a little weird because you gave udqp & gdqp the same treatment, but
not olddquot (which is initialized to NULL in the declaration too)

...

> Index: xfs/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2009-02-24 15:32:16.141370566 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_super.c	2009-02-24 15:32:35.866394539 +0100
> @@ -416,6 +416,14 @@ xfs_parseargs(
>  		return EINVAL;
>  	}
>  
> +#ifndef CONFIG_XFS_QUOTA
> +	if (XFS_IS_QUOTA_RUNNING(mp)) {
> +		cmn_err(CE_WARN,
> +			"XFS: quota support not available in this kernel.");
> +		return EINVAL;
> +	}
> +#endif

The wording of the macro seems a little confusing in this location, how
can quota be "running" if we are just starting the mount and there is no
quota built in, but oh well, not really the fault of this patch I guess.

Would it make any more sense to just say "if (mp->m_qflags)" instead,
because  we just got done setting that bit of the structure in parseargs...?

...

> @@ -1214,7 +1222,10 @@ xfs_fs_statfs(
>  	statp->f_ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
>  	spin_unlock(&mp->m_sb_lock);
>  
> -	XFS_QM_DQSTATVFS(XFS_I(dentry->d_inode), statp);
> +	if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) ||
> +	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))) ==
> +			      (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))
> +		xfs_qm_statvfs(ip, statp);
>  	return 0;
>  }

Ok, so the tests for the ip & mp flags were removed from
xfs_qm_statvfs() because they are always set here in the only caller...
but would an ASSERT() of those be worth keeping in xfs_qm_statvfs?

> @@ -1422,16 +1433,13 @@ xfs_fs_fill_super(
>  	error = xfs_dmops_get(mp);
>  	if (error)
>  		goto out_free_fsname;
> -	error = xfs_qmops_get(mp);
> -	if (error)
> -		goto out_put_dmops;
>  
>  	if (silent)
>  		flags |= XFS_MFSI_QUIET;
>  
>  	error = xfs_open_devices(mp);
>  	if (error)
> -		goto out_put_qmops;
> +		goto out_put_dmops;
>  
>  	if (xfs_icsb_init_counters(mp))
>  		mp->m_flags |= XFS_MOUNT_NO_PERCPU_SB;
> @@ -1500,8 +1508,6 @@ xfs_fs_fill_super(
>   out_destroy_counters:
>  	xfs_icsb_destroy_counters(mp);
>  	xfs_close_devices(mp);
> - out_put_qmops:
> -	xfs_qmops_put(mp);
>   out_put_dmops:
>  	xfs_dmops_put(mp);
>   out_free_fsname:
> Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-02-24 15:32:16.149399312 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2009-02-24 15:32:35.867425537 +0100
> @@ -43,6 +43,7 @@
>  #include "xfs_buf_item.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_rw.h"
> +#include "xfs_quota.h"
>  
>  #include <linux/kthread.h>
>  #include <linux/freezer.h>
> @@ -311,12 +312,12 @@ xfs_quiesce_data(
>  
>  	/* push non-blocking */
>  	xfs_sync_inodes(mp, SYNC_DELWRI|SYNC_BDFLUSH);
> -	XFS_QM_DQSYNC(mp, SYNC_BDFLUSH);
> +	xfs_qm_sync(mp, SYNC_BDFLUSH);
>  	xfs_filestream_flush(mp);
>  
>  	/* push and block */
>  	xfs_sync_inodes(mp, SYNC_DELWRI|SYNC_WAIT|SYNC_IOWAIT);
> -	XFS_QM_DQSYNC(mp, SYNC_WAIT);
> +	xfs_qm_sync(mp, SYNC_WAIT);
>  
>  	/* write superblock and hoover up shutdown errors */> Index: xfs/fs/xfs/quota/xfs_dquot.c
> ===================================================================
> --- xfs.orig/fs/xfs/quota/xfs_dquot.c	2009-02-24 15:32:16.080370342 +0100
> +++ xfs/fs/xfs/quota/xfs_dquot.c	2009-02-24 15:32:35.867425537 +0100
> @@ -1194,7 +1194,9 @@ void
>  xfs_qm_dqrele(
>  	xfs_dquot_t	*dqp)
>  {
> -	ASSERT(dqp);
> +	if (!dqp)
> +		return;
> +
>  	xfs_dqtrace_entry(dqp, "DQRELE");
>  
>  	xfs_dqlock(dqp);

dumb question, maybe - how do we get here w/ dqp == NULL when before it
was an ASSERT?

...

> @@ -2469,8 +2479,10 @@ xfs_qm_vop_chown(
>  	uint		bfield = XFS_IS_REALTIME_INODE(ip) ?
>  				 XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
>  
> +	if (!XFS_IS_QUOTA_RUNNING(ip->i_mount))
> +		return NULL;
> +
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -	ASSERT(XFS_IS_QUOTA_RUNNING(ip->i_mount));
>  
>  	/* old dquot */
>  	prevdq = *IO_olddq;

seems a little weird to call this & return, should the (3) callers just
check first?  I guess similar questions on other tests...

> @@ -2508,14 +2520,15 @@ xfs_qm_vop_chown_reserve(
>  	xfs_dquot_t	*gdqp,
>  	uint		flags)
>  {
> -	int		error;
> -	xfs_mount_t	*mp;
> +	xfs_mount_t	*mp = ip->i_mount;
>  	uint		delblks, blkflags, prjflags = 0;
>  	xfs_dquot_t	*unresudq, *unresgdq, *delblksudq, *delblksgdq;
> +	int		error;
> +
> +	if (!XFS_IS_QUOTA_RUNNING(mp))
> +		return 0;

same question here

>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> -	mp = ip->i_mount;
> -	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
>  
>  	delblks = ip->i_delayed_blks;
>  	delblksudq = delblksgdq = unresudq = unresgdq = NULL;
> @@ -2582,28 +2595,23 @@ xfs_qm_vop_chown_reserve(
>  
>  int
>  xfs_qm_vop_rename_dqattach(
> -	xfs_inode_t	**i_tab)
> +	struct xfs_inode	**i_tab)
>  {
> -	xfs_inode_t	*ip;
> -	int		i;
> -	int		error;
> -
> -	ip = i_tab[0];
> +	struct xfs_mount	*mp = i_tab[0]->i_mount;
> +	int			i;
>  
> -	if (! XFS_IS_QUOTA_ON(ip->i_mount))
> +	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
>  		return 0;
>  
> -	if (XFS_NOT_DQATTACHED(ip->i_mount, ip)) {
> -		error = xfs_qm_dqattach(ip, 0);
> -		if (error)
> -			return error;
> -	}
>  	for (i = 1; (i < 4 && i_tab[i]); i++) {
> +		struct xfs_inode	*ip = i_tab[i];
> +		int			error;
> +
>  		/*
>  		 * Watch out for duplicate entries in the table.
>  		 */
> -		if ((ip = i_tab[i]) != i_tab[i-1]) {
> -			if (XFS_NOT_DQATTACHED(ip->i_mount, ip)) {
> +		if (i == 0 || ip != i_tab[i-1]) {


                    ^^^^^^ how is that ever true?


> +			if (XFS_NOT_DQATTACHED(mp, ip)) {
>  				error = xfs_qm_dqattach(ip, 0);
>  				if (error)
>  					return error;

> Index: xfs/fs/xfs/xfs_mount.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_mount.c	2009-02-24 15:32:16.164399755 +0100
> +++ xfs/fs/xfs/xfs_mount.c	2009-02-24 15:32:35.871518446 +0100

...

> @@ -1163,9 +1230,19 @@ xfs_mountfs(
>  	/*
>  	 * Complete the quota initialisation, post-log-replay component.
>  	 */
> -	error = XFS_QM_MOUNT(mp, quotamount, quotaflags);
> -	if (error)
> -		goto out_rtunmount;
> +	if (quotamount) {
> +		ASSERT(mp->m_qflags == 0);
> +		mp->m_qflags = quotaflags;
> +
> +		xfs_qm_mount_quotas(mp);

Seems odd to me that this is a void, and quota mount failure doesn't
stop the mount, but oh well, I guess it's always been that way.


Aside from those nitpicks seems ok, though TBH I'm a bit confused about
when we check XFS_IS_QUOTA_RUNNING vs XFS_IS_QUOTA_ON in this new world ....

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
