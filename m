Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56218 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756065AbdLWAQD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 19:16:03 -0500
Date: Fri, 22 Dec 2017 16:07:10 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v4 17/19] xfs: avoid setting XFS_ILOG_CORE if i_version
 doesn't need incrementing
Message-ID: <20171223000710.GF12613@magnolia>
References: <20171222120556.7435-1-jlayton@kernel.org>
 <20171222120556.7435-18-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171222120556.7435-18-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com

On Fri, Dec 22, 2017 at 07:05:54AM -0500, Jeff Layton wrote:
> From: Jeff Layton <jlayton@redhat.com>
> 
> If XFS_ILOG_CORE is already set then go ahead and increment it.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Looks ok,
Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_trans_inode.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
> index 225544327c4f..4a89da4b6fe7 100644
> --- a/fs/xfs/xfs_trans_inode.c
> +++ b/fs/xfs/xfs_trans_inode.c
> @@ -112,15 +112,17 @@ xfs_trans_log_inode(
>  
>  	/*
>  	 * First time we log the inode in a transaction, bump the inode change
> -	 * counter if it is configured for this to occur. We don't use
> -	 * inode_inc_version() because there is no need for extra locking around
> -	 * i_version as we already hold the inode locked exclusively for
> -	 * metadata modification.
> +	 * counter if it is configured for this to occur. While we have the
> +	 * inode locked exclusively for metadata modification, we can usually
> +	 * avoid setting XFS_ILOG_CORE if no one has queried the value since
> +	 * the last time it was incremented. If we have XFS_ILOG_CORE already
> +	 * set however, then go ahead and bump the i_version counter
> +	 * unconditionally.
>  	 */
>  	if (!(ip->i_itemp->ili_item.li_desc->lid_flags & XFS_LID_DIRTY) &&
>  	    IS_I_VERSION(VFS_I(ip))) {
> -		inode_inc_iversion(VFS_I(ip));
> -		flags |= XFS_ILOG_CORE;
> +		if (inode_maybe_inc_iversion(VFS_I(ip), flags & XFS_ILOG_CORE))
> +			flags |= XFS_ILOG_CORE;
>  	}
>  
>  	tp->t_flags |= XFS_TRANS_DIRTY;
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
