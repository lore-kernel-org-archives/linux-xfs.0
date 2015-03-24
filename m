Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5F4C07F54
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 16:04:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4CBBB30404E
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 14:04:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id KFgX1nMsTBzA3MD8 for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 14:04:39 -0700 (PDT)
Message-ID: <5511D166.7050201@sandeen.net>
Date: Tue, 24 Mar 2015 16:04:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] xfs: factor out xfs_rename_finish()
References: <1427194771-3105-1-git-send-email-david@fromorbit.com>
	<1427194771-3105-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1427194771-3105-4-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 3/24/15 5:59 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Rather than use a jump label for the final transaction commit in
> the rename, factor it into a simple helper function and call it
> appropriately. This slightly reduces the spaghetti nature of
> xfs_rename.

Nit, subject should be "xfs_finish_rename" not "xfs_rename_finish"

-Eric

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 48 +++++++++++++++++++++++++++---------------------
>  1 file changed, 27 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 981e036..4a13a48 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2716,6 +2716,31 @@ xfs_sort_for_rename(
>  	}
>  }
>  
> +static int
> +xfs_finish_rename(
> +	struct xfs_trans	*tp,
> +	struct xfs_bmap_free	*free_list)
> +{
> +	int			committed = 0;
> +	int			error;
> +
> +	/*
> +	 * If this is a synchronous mount, make sure that the rename transaction
> +	 * goes to disk before returning to the user.
> +	 */
> +	if (tp->t_mountp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
> +		xfs_trans_set_sync(tp);
> +
> +	error = xfs_bmap_finish(&tp, free_list, &committed);
> +	if (error) {
> +		xfs_bmap_cancel(free_list);
> +		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
> +		return error;
> +	}
> +
> +	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> +}
> +
>  /*
>   * xfs_cross_rename()
>   *
> @@ -2855,7 +2880,6 @@ xfs_rename(
>  	xfs_bmap_free_t free_list;
>  	xfs_fsblock_t   first_block;
>  	int		cancel_flags = 0;
> -	int		committed;
>  	xfs_inode_t	*inodes[__XFS_SORT_INODES];
>  	int		num_inodes = __XFS_SORT_INODES;
>  	int		spaceres;
> @@ -2932,7 +2956,7 @@ xfs_rename(
>  					 &free_list, &first_block, spaceres);
>  		if (error)
>  			goto out_trans_abort;
> -		goto finish_rename;
> +		return xfs_finish_rename(tp, &free_list);
>  	}
>  
>  	/*
> @@ -3074,25 +3098,7 @@ xfs_rename(
>  	if (new_parent)
>  		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
>  
> -finish_rename:
> -	/*
> -	 * If this is a synchronous mount, make sure that the
> -	 * rename transaction goes to disk before returning to
> -	 * the user.
> -	 */
> -	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC)) {
> -		xfs_trans_set_sync(tp);
> -	}
> -
> -	error = xfs_bmap_finish(&tp, &free_list, &committed);
> -	if (error)
> -		goto out_trans_abort;
> -
> -	/*
> -	 * trans_commit will unlock src_ip, target_ip & decrement
> -	 * the vnode references.
> -	 */
> -	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> +	return xfs_finish_rename(tp, &free_list);
>  
>  out_trans_abort:
>  	cancel_flags |= XFS_TRANS_ABORT;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
