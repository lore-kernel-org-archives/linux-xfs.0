Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54586 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751927AbdHIMgv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Aug 2017 08:36:51 -0400
Date: Wed, 9 Aug 2017 08:36:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: don't leak linked inodes during log recovery
Message-ID: <20170809123647.GB62448@bfoster.bfoster>
References: <20170809010444.GR24087@magnolia>
 <20170809010650.GF4474@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170809010650.GF4474@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Aug 08, 2017 at 06:06:50PM -0700, Darrick J. Wong wrote:
> When we introduced the bmap redo log items, we set MS_ACTIVE on the
> mountpoint and XFS_IRECOVERY on the inode to prevent unlinked inodes
> from being truncated prematurely during log recovery.  However, we
> neglected to drop linked inodes that are recovered, and if we don't use
> the inode between recovery and unmount, the inode will never be marked
> reclaimable and thus we fail to free it at umount time.  If we're in
> log recovery but IRECOVERY is /not/ set, the inode is linked and can be
> reclaimed.
> 

I follow the change in behavior in the previous commit and how this
restores the original behavior for linked inodes, so this patch makes
sense from that perspective. I'm not following where/how the leak occurs
from the description, however. Wouldn't the inode end up on the lru to
be shrunk/evicted/reclaimed at a later point? What happens if the inode
is subsequently used that prevents the leak? (Whatever I'm missing, it
would be nice to elaborate on in the commit log.)

Also, if there is a memory leak vector for !drop linked inodes here,
does that not apply to XFS_IRECOVERY inodes if log recovery itself
happens to fail between bui recovery and iunlink processing?

Brian

> Fixes: 17c12bcd30 ("xfs: when replaying bmap operations, don't let unlinked inodes get reaped")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_super.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 38aaacd..9b06ca2 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1040,6 +1040,13 @@ xfs_fs_drop_inode(
>  	if (ip->i_flags & XFS_IRECOVERY) {
>  		ASSERT(ip->i_mount->m_log->l_flags & XLOG_RECOVERY_NEEDED);
>  		return 0;
> +	} else if (ip->i_mount->m_log->l_flags & XLOG_RECOVERY_NEEDED) {
> +		/*
> +		 * This inode was loaded during recovery but is not
> +		 * being unlinked, so we can free it without fear of
> +		 * premature truncation.
> +		 */
> +		return 1;
>  	}
>  
>  	return generic_drop_inode(inode) || (ip->i_flags & XFS_IDONTCACHE);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
