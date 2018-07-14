Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:22417 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730683AbeGNAUH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jul 2018 20:20:07 -0400
Date: Sat, 14 Jul 2018 10:03:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: avoid COW fork extent lookups in writeback if
 the fork didn't change
Message-ID: <20180714000301.GY19934@dastard>
References: <20180712134910.30298-1-hch@lst.de>
 <20180712134910.30298-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180712134910.30298-7-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 12, 2018 at 03:49:10PM +0200, Christoph Hellwig wrote:
> @@ -333,12 +335,15 @@ xfs_map_blocks(
>  	 * COW fork blocks can overlap data fork blocks even if the blocks
>  	 * aren't shared.  COW I/O always takes precedent, so we must always
>  	 * check for overlap on reflink inodes unless the mapping is already a
> -	 * COW one.
> +	 * COW one, or the COW fork hasn't changed from the last time we looked
> +	 * at it.
>  	 */
>  	imap_valid = offset_fsb >= wpc->imap.br_startoff &&
>  		     offset_fsb < wpc->imap.br_startoff + wpc->imap.br_blockcount;
>  	if (imap_valid &&
> -	    (!xfs_inode_has_cow_data(ip) || wpc->io_type == XFS_IO_COW))
> +	    (!xfs_inode_has_cow_data(ip) ||
> +	     wpc->io_type == XFS_IO_COW ||
> +	     wpc->cow_seq == ip->i_cowfp->if_seq))
>  		return 0;

Isn't this racy? It's not an atomic variable, we hold no locks,
there are no memory barriers, etc. Hence we can miss changes made by
concurrent mapping changes...

Which makes me ask - is the sequence number bumped before or after
we modify the extent map? It seems to me that it needs to be done
before we make a modification so that we invalidate the current map
before we change the extent map to avoid issuing IO to an extent map
we are know we changing, right?

/me had prototype seqno patches like this from way back and kept
hitting races because of these "imap_valid checks are done without
locks" issues...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
