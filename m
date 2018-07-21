Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:57363 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728194AbeGVARn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jul 2018 20:17:43 -0400
Date: Sun, 22 Jul 2018 09:23:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: avoid COW fork extent lookups in writeback if
 the fork didn't change
Message-ID: <20180721232311.GA1691@dastard>
References: <20180717232405.18511-1-hch@lst.de>
 <20180717232405.18511-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180717232405.18511-7-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 17, 2018 at 04:24:05PM -0700, Christoph Hellwig wrote:
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

This seqno check is still racy against concurrent extent tree
modification. We aren't holding the ILOCK here at all, the sequence
numbers aren't atomic and there are no memory barriers to serialise
cross-cpu load/store operations...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
