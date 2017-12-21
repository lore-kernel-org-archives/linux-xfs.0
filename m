Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:34069 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750920AbdLUXB3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Dec 2017 18:01:29 -0500
Date: Thu, 21 Dec 2017 15:01:17 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: linux-next: manual merge of the xfs tree with Linus' tree
Message-ID: <20171221230117.GB12613@magnolia>
References: <20171222095041.3fe014ec@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171222095041.3fe014ec@canb.auug.org.au>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>

On Fri, Dec 22, 2017 at 09:50:41AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the xfs tree got a conflict in:
> 
>   fs/xfs/xfs_super.c
> 
> between commit:
> 
>   1751e8a6cb93 ("Rename superblock flags (MS_xyz -> SB_xyz)")
> 
> from Linus' tree and commit:
> 
>   10ddf64e420f ("xfs: remove leftover CoW reservations when remounting ro")
> 
> from the xfs tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

Ok, that's exactly the merge conflict that I was expecting to see.
I'll make a note if/when I get around to sending a pull request.
Thank you.

--D

> -- 
> Cheers,
> Stephen Rothwell
> 
> diff --cc fs/xfs/xfs_super.c
> index 5122d3021117,2db6a40a96bd..000000000000
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@@ -1368,7 -1369,15 +1369,15 @@@ xfs_fs_remount
>   	}
>   
>   	/* rw -> ro */
>  -	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & MS_RDONLY)) {
>  +	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & SB_RDONLY)) {
> + 		/* Get rid of any leftover CoW reservations... */
> + 		cancel_delayed_work_sync(&mp->m_cowblocks_work);
> + 		error = xfs_icache_free_cowblocks(mp, NULL);
> + 		if (error) {
> + 			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> + 			return error;
> + 		}
> + 
>   		/* Free the per-AG metadata reservation pool. */
>   		error = xfs_fs_unreserve_ag_blocks(mp);
>   		if (error) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
