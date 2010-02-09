Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o19KLhGW247951 for <xfs@oss.sgi.com>; Tue, 9 Feb 2010 14:21:43 -0600
Subject: Re: [PATCH] xfs: only clear the suid bit once in xfs_write
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100203194331.GA20199@infradead.org>
References: <20100203194331.GA20199@infradead.org>
Date: Tue, 09 Feb 2010 14:22:53 -0600
Message-ID: <1265746973.26394.9.camel@doink1>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2010-02-03 at 14:43 -0500, Christoph Hellwig wrote:
> file_remove_suid already calls into ->setattr to clear the suid and sgid
> bits if needed, no need to start a second transaction to do it ourselves.
> 
> Note that xfs_write_clear_setuid issues a sync transaction while the
> path through ->setattr doesn't, but that is consistant with the other
> filesystems.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.  Those S*ID bits sure get checked and
cleared in a lot of places...

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfs/fs/xfs/linux-2.6/xfs_lrw.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2010-02-03 20:37:45.956003749 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_lrw.c	2010-02-03 20:37:49.348003520 +0100
> @@ -630,18 +630,9 @@ start:
>  	 * by root.  This keeps people from modifying setuid and
>  	 * setgid binaries.
>  	 */
> -
> -	if (((xip->i_d.di_mode & S_ISUID) ||
> -	    ((xip->i_d.di_mode & (S_ISGID | S_IXGRP)) ==
> -		(S_ISGID | S_IXGRP))) &&
> -	     !capable(CAP_FSETID)) {
> -		error = xfs_write_clear_setuid(xip);
> -		if (likely(!error))
> -			error = -file_remove_suid(file);
> -		if (unlikely(error)) {
> -			goto out_unlock_internal;
> -		}
> -	}
> +	error = -file_remove_suid(file);
> +	if (unlikely(error))
> +		goto out_unlock_internal;
>  
>  	/* We can write back this queue in page reclaim */
>  	current->backing_dev_info = mapping->backing_dev_info;
> Index: xfs/fs/xfs/xfs_rw.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_rw.c	2010-02-03 20:37:45.965004126 +0100
> +++ xfs/fs/xfs/xfs_rw.c	2010-02-03 20:37:49.349010212 +0100
> @@ -47,48 +47,6 @@
>  #include "xfs_trace.h"
>  
>  /*
> - * This is a subroutine for xfs_write() and other writers (xfs_ioctl)
> - * which clears the setuid and setgid bits when a file is written.
> - */
> -int
> -xfs_write_clear_setuid(
> -	xfs_inode_t	*ip)
> -{
> -	xfs_mount_t	*mp;
> -	xfs_trans_t	*tp;
> -	int		error;
> -
> -	mp = ip->i_mount;
> -	tp = xfs_trans_alloc(mp, XFS_TRANS_WRITEID);
> -	if ((error = xfs_trans_reserve(tp, 0,
> -				      XFS_WRITEID_LOG_RES(mp),
> -				      0, 0, 0))) {
> -		xfs_trans_cancel(tp, 0);
> -		return error;
> -	}
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> -	xfs_trans_ihold(tp, ip);
> -	ip->i_d.di_mode &= ~S_ISUID;
> -
> -	/*
> -	 * Note that we don't have to worry about mandatory
> -	 * file locking being disabled here because we only
> -	 * clear the S_ISGID bit if the Group execute bit is
> -	 * on, but if it was on then mandatory locking wouldn't
> -	 * have been enabled.
> -	 */
> -	if (ip->i_d.di_mode & S_IXGRP) {
> -		ip->i_d.di_mode &= ~S_ISGID;
> -	}
> -	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -	xfs_trans_set_sync(tp);
> -	error = xfs_trans_commit(tp, 0);
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -	return 0;
> -}
> -
> -/*
>   * Force a shutdown of the filesystem instantly while keeping
>   * the filesystem consistent. We don't do an unmount here; just shutdown
>   * the shop, make sure that absolutely nothing persistent happens to
> Index: xfs/fs/xfs/xfs_rw.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_rw.h	2010-02-03 20:37:53.085003394 +0100
> +++ xfs/fs/xfs/xfs_rw.h	2010-02-03 20:37:57.946033654 +0100
> @@ -39,7 +39,6 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_
>  /*
>   * Prototypes for functions in xfs_rw.c.
>   */
> -extern int xfs_write_clear_setuid(struct xfs_inode *ip);
>  extern int xfs_read_buf(struct xfs_mount *mp, xfs_buftarg_t *btp,
>  			xfs_daddr_t blkno, int len, uint flags,
>  			struct xfs_buf **bpp);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
