Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mALI1fFr024690 for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 12:01:42 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5DDB515BE9DB
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 10:01:41 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id e4ry3jLG0W1dJTjQ for
	<xfs@oss.sgi.com>; Fri, 21 Nov 2008 10:01:41 -0800 (PST)
Date: Fri, 21 Nov 2008 13:01:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFS: remove i_gen from incore inode
Message-ID: <20081121180110.GA31376@infradead.org>
References: <1216558002-838-1-git-send-email-david@fromorbit.com>
	<20080721075449.GB6692@infradead.org>
	<20080721110814.GC6761@disturbed>
	<20080721115228.GA14077@infradead.org>
	<20080721120440.GE6761@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080721120440.GE6761@disturbed>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Any chance we can get this patch in?  It's been out for exactly 4 month
in it's final reviewed form, and I still have patches that I rebased on
top of it waiting..

On Mon, Jul 21, 2008 at 10:04:40PM +1000, Dave Chinner wrote:
> XFS: remove i_gen from incore inode
> 
> i_gen is incremented in directory operations when the
> directory is changed. It is never read or otherwise used
> so it should be removed to help reduce the size of the
> struct xfs_inode.
> 
> The patch also removes a duplicate logging of the directory
> inode core. We only need to do this once per transaction
> so kill the one associated with the i_gen increment.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/xfs_inode.h    |    1 -
>  fs/xfs/xfs_rename.c   |   12 ++----------
>  fs/xfs/xfs_vnodeops.c |   29 ++---------------------------
>  3 files changed, 4 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 440b443..316c374 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -223,7 +223,6 @@ typedef struct xfs_inode {
>  	unsigned short		i_flags;	/* see defined flags below */
>  	unsigned char		i_update_core;	/* timestamps/size is dirty */
>  	unsigned char		i_update_size;	/* di_size field is dirty */
> -	unsigned int		i_gen;		/* generation count */
>  	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
>  
>  	xfs_icdinode_t		i_d;		/* most of ondisk inode */
> diff --git a/fs/xfs/xfs_rename.c b/fs/xfs/xfs_rename.c
> index d700dac..02f0e8f 100644
> --- a/fs/xfs/xfs_rename.c
> +++ b/fs/xfs/xfs_rename.c
> @@ -367,19 +367,11 @@ xfs_rename(
>  					&first_block, &free_list, spaceres);
>  	if (error)
>  		goto abort_return;
> -	xfs_ichgtime(src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  
> -	/*
> -	 * Update the generation counts on all the directory inodes
> -	 * that we're modifying.
> -	 */
> -	src_dp->i_gen++;
> +	xfs_ichgtime(src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
> -
> -	if (new_parent) {
> -		target_dp->i_gen++;
> +	if (new_parent)
>  		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
> -	}
>  
>  	/*
>  	 * If this is a synchronous mount, make sure that the
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index 94ec74b..426c574 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -1798,8 +1798,6 @@ xfs_create(
>  		xfs_trans_set_sync(tp);
>  	}
>  
> -	dp->i_gen++;
> -
>  	/*
>  	 * Attach the dquot(s) to the inodes and modify them incore.
>  	 * These ids of the inode couldn't have changed since the new
> @@ -2229,13 +2227,6 @@ xfs_remove(
>  	}
>  	xfs_ichgtime(dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  
> -	/*
> -	 * Bump the in memory generation count on the parent
> -	 * directory so that other can know that it has changed.
> -	 */
> -	dp->i_gen++;
> -	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
> -
>  	if (is_dir) {
>  		/*
>  		 * Drop the link from ip's "..".
> @@ -2253,8 +2244,8 @@ xfs_remove(
>  	} else {
>  		/*
>  		 * When removing a non-directory we need to log the parent
> -		 * inode here for the i_gen update.  For a directory this is
> -		 * done implicitly by the xfs_droplink call for the ".." entry.
> +		 * inode here.  For a directory this is done implicitly
> +		 * by the xfs_droplink call for the ".." entry.
>  		 */
>  		xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
>  	}
> @@ -2423,7 +2414,6 @@ xfs_link(
>  	if (error)
>  		goto abort_return;
>  	xfs_ichgtime(tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> -	tdp->i_gen++;
>  	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
>  
>  	error = xfs_bumplink(tp, sip);
> @@ -2600,18 +2590,10 @@ xfs_mkdir(
>  	}
>  	xfs_ichgtime(dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  
> -	/*
> -	 * Bump the in memory version number of the parent directory
> -	 * so that other processes accessing it will recognize that
> -	 * the directory has changed.
> -	 */
> -	dp->i_gen++;
> -
>  	error = xfs_dir_init(tp, cdp, dp);
>  	if (error)
>  		goto error2;
>  
> -	cdp->i_gen = 1;
>  	error = xfs_bumplink(tp, dp);
>  	if (error)
>  		goto error2;
> @@ -2898,13 +2880,6 @@ xfs_symlink(
>  	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
>  
>  	/*
> -	 * Bump the in memory version number of the parent directory
> -	 * so that other processes accessing it will recognize that
> -	 * the directory has changed.
> -	 */
> -	dp->i_gen++;
> -
> -	/*
>  	 * If this is a synchronous mount, make sure that the
>  	 * symlink transaction goes to disk before returning to
>  	 * the user.
> 
> 
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
