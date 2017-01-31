Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51544 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752864AbdAaDMK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Jan 2017 22:12:10 -0500
Subject: Re: [PATCH 1/7] xfs: fix toctou race when locking an inode to access
 the data map
References: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
 <148582219035.12293.12084220786527965512.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f8b63827-e2f3-c906-6d7f-628330cb9eb2@sandeen.net>
Date: Mon, 30 Jan 2017 21:01:58 -0600
MIME-Version: 1.0
In-Reply-To: <148582219035.12293.12084220786527965512.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 1/30/17 6:23 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We use di_format and if_flags to decide whether we're grabbing the ilock
> in btree mode (btree extents not loaded) or shared mode (anything else),
> but the state of those fields can be changed by other threads that are
> also trying to load the btree extents -- IFEXTENTS gets set before the
> _bmap_read_extents call and cleared if it fails.  Therefore, once we've
> grabbed the shared ilock we have to re-check the fields to see if we
> actually need to upgrade to the exclusive ilock in order to try loading
> the extents.
> 
> Without this patch, we trigger ilock assert failures when a bunch of
> threads try to access a btree format directory with a corrupt bmbt root
> and corrupt the incore data structures, leading to a crash.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I'm a little surprised this hasn't been hit before, TBH.

Seems right -

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_inode.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index de32f0f..7d7206c 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -125,6 +125,18 @@ xfs_ilock_data_map_shared(
>  	    (ip->i_df.if_flags & XFS_IFEXTENTS) == 0)
>  		lock_mode = XFS_ILOCK_EXCL;
>  	xfs_ilock(ip, lock_mode);
> +	/*
> +	 * We can change if_flags under ilock if we try to read the
> +	 * extents and fail.  Since we hadn't grabbed the ilock at check
> +	 * time, we have to re-check and upgrade the lock now.
> +	 */
> +	if (lock_mode == XFS_ILOCK_SHARED &&
> +	    ip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
> +	    (ip->i_df.if_flags & XFS_IFEXTENTS) == 0) {
> +		xfs_iunlock(ip, lock_mode);
> +		lock_mode = XFS_ILOCK_EXCL;
> +		xfs_ilock(ip, lock_mode);
> +	}
>  	return lock_mode;
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
