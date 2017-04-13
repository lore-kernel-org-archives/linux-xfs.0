Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19693 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753332AbdDMP7N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2017 11:59:13 -0400
Date: Thu, 13 Apr 2017 08:59:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: drop iolock from reclaim context to appease lockdep
Message-ID: <20170413155908.GX8502@birch.djwong.org>
References: <1491845792-7143-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1491845792-7143-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 10, 2017 at 01:36:32PM -0400, Brian Foster wrote:
> Lockdep complains about use of the iolock in inode reclaim context
> because it doesn't understand that reclaim has the last reference to
> the inode, and thus an iolock->reclaim->iolock deadlock is not
> possible.
> 
> The iolock is technically not necessary in xfs_inactive() and was
> only added to appease an assert in xfs_free_eofblocks(), which can
> be called from other non-reclaim contexts. Therefore, just kill the
> assert and drop the use of the iolock from reclaim context to quiet
> lockdep.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok, hasn't started any new fires...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_bmap_util.c | 8 +++-----
>  fs/xfs/xfs_inode.c     | 9 +++++----
>  2 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 4d1920e..de94798 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -903,9 +903,9 @@ xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
>  }
>  
>  /*
> - * This is called by xfs_inactive to free any blocks beyond eof
> - * when the link count isn't zero and by xfs_dm_punch_hole() when
> - * punching a hole to EOF.
> + * This is called to free any blocks beyond eof. The caller must hold
> + * IOLOCK_EXCL unless we are in the inode reclaim path and have the only
> + * reference to the inode.
>   */
>  int
>  xfs_free_eofblocks(
> @@ -920,8 +920,6 @@ xfs_free_eofblocks(
>  	struct xfs_bmbt_irec	imap;
>  	struct xfs_mount	*mp = ip->i_mount;
>  
> -	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> -
>  	/*
>  	 * Figure out if there are any blocks beyond the end
>  	 * of the file.  If not, then there is nothing to do.
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 7605d83..ec9826c 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1906,12 +1906,13 @@ xfs_inactive(
>  		 * force is true because we are evicting an inode from the
>  		 * cache. Post-eof blocks must be freed, lest we end up with
>  		 * broken free space accounting.
> +		 *
> +		 * Note: don't bother with iolock here since lockdep complains
> +		 * about acquiring it in reclaim context. We have the only
> +		 * reference to the inode at this point anyways.
>  		 */
> -		if (xfs_can_free_eofblocks(ip, true)) {
> -			xfs_ilock(ip, XFS_IOLOCK_EXCL);
> +		if (xfs_can_free_eofblocks(ip, true))
>  			xfs_free_eofblocks(ip);
> -			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> -		}
>  
>  		return;
>  	}
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
