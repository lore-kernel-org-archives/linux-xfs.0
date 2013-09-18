Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 644BA7F5E
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 18:06:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 281DB304043
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 16:06:25 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5aqB8SXD9kqFEhOq for <xfs@oss.sgi.com>;
	Wed, 18 Sep 2013 16:06:23 -0700 (PDT)
Date: Thu, 19 Sep 2013 09:06:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: push down inactive transaction mgmt for ifree
Message-ID: <20130918230620.GE9901@dastard>
References: <1379520960-22972-1-git-send-email-bfoster@redhat.com>
	<1379520960-22972-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1379520960-22972-4-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 18, 2013 at 12:16:00PM -0400, Brian Foster wrote:
> Push the inode free work performed during xfs_inactive() down into
> a new xfs_inactive_ifree() helper. This clears xfs_inactive() from
> all inode locking and transaction management more directly
> associated with freeing the inode xattrs, extents and the inode
> itself.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 121 +++++++++++++++++++++++++++++++----------------------
>  1 file changed, 71 insertions(+), 50 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 9416462..a6ed69d 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1710,6 +1710,74 @@ error0:
>  }
>  
>  /*
> + * xfs_inactive_ifree()
> + *
> + * Perform the inode free when an inode is unlinked.
> + */
> +STATIC int
> +xfs_inactive_ifree(
> +	struct xfs_inode *ip)
> +{
> +	xfs_bmap_free_t		free_list;
> +	xfs_fsblock_t		first_block;
> +	int			committed;
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*tp;
> +	int			error;
> +
> +	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, 0, 0);
> +	if (error) {
> +		ASSERT(XFS_FORCED_SHUTDOWN(mp));
> +		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
> +		return error;
> +	}
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
> +
> +	xfs_bmap_init(&free_list, &first_block);
> +	error = xfs_ifree(tp, ip, &free_list);
> +	if (error) {
> +		/*
> +		 * If we fail to free the inode, shut down.  The cancel
> +		 * might do that, we need to make sure.  Otherwise the
> +		 * inode might be lost for a long time or forever.
> +		 */
> +		if (!XFS_FORCED_SHUTDOWN(mp)) {
> +			xfs_notice(mp, "%s: xfs_ifree returned error %d",
> +				__func__, error);
> +			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> +		}
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
> +		return error;
> +	}
> +
> +	/*
> +	 * Credit the quota account(s). The inode is gone.
> +	 */
> +	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_ICOUNT, -1);
> +
> +	/*
> +	 * Just ignore errors at this point.  There is nothing we can
> +	 * do except to try to keep going. Make sure it's not a silent
> +	 * error.
> +	 */
> +	error = xfs_bmap_finish(&tp,  &free_list, &committed);
> +	if (error)
> +		xfs_notice(mp, "%s: xfs_bmap_finish returned error %d",
> +			__func__, error);
> +	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> +	if (error)
> +		xfs_notice(mp, "%s: xfs_trans_commit returned error %d",
> +			__func__, error);
> +
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	return 0;
> +}

I suspect we can clean up the error handling here now, and make it
look like the symlink remove inactive handle where we cancel bmaps
and abort transactions and trigger shutdowns appropriately. I'd
leave that to a separate patchset, though ;)

> -				__func__, error);
> -	}
> +	error = xfs_inactive_ifree(ip);
> +	if (error)
> +		goto out;
>  
>  	/*
>  	 * Release the dquots held by inode, if any.
>  	 */
>  	xfs_qm_dqdetach(ip);
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  out:
>  	return VN_INACTIVE_CACHE;
>  }

I think it's time to kill VN_INACTIVE_CACHE, as well. It's a
hold-over from Irix, and it serves no purpose what-so-ever on
Linux...

Otherwise it looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
