Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:42116 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932768AbcLPA37 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 19:29:59 -0500
Date: Fri, 16 Dec 2016 11:28:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: adjust allocation length in
 xfs_alloc_space_available
Message-ID: <20161216002851.GW4219@dastard>
References: <1481644767-9098-1-git-send-email-hch@lst.de>
 <1481644767-9098-4-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1481644767-9098-4-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Tue, Dec 13, 2016 at 04:59:26PM +0100, Christoph Hellwig wrote:
> We must decide in xfs_alloc_fix_freelist if we can perform an
> allocation from a given AG is possible or not based on the available
> space, and should not fail the allocation past that point on a
> healthy file system.
> 
> But currently we have two additional places that second-guess
> xfs_alloc_fix_freelist: xfs_alloc_ag_vextent tries to adjust the
> maxlen parameter to remove the reservation before doing the
> allocation (but ignores the various minium freespace requirements),
> and xfs_alloc_fix_minleft tries to fix up the allocated length
> after we've found an extent, but ignores the reservations and also
> doesn't take the AGFL into account (and thus fails allocations
> for not matching minlen in some cases).
> 
> Remove all these later fixups and just correct the maxlen argument
> inside xfs_alloc_fix_freelist once we have the AGF buffer locked.

Ok, the concept seems solid....

> @@ -2073,10 +2015,19 @@ xfs_alloc_space_available(
>  
>  	/* do we have enough free space remaining for the allocation? */
>  	available = (int)(pag->pagf_freeblks + pag->pagf_flcount -
> -			  reservation - min_free - args->total);
> +			  reservation - min_free - args->minleft);

This is fine, but...

> -	if (available < (int)args->minleft || available <= 0)
> +	if (available < (int)args->total)
>  		return false;

this is where I begin to wonder. The "args->total" logic here just
doesn't read cleanly to me. xfs_bmapi_write() says:

 * An upper bound for the number of blocks to be allocated is supplied to
 * the first call in "total"; if no allocation group has that many free
 * blocks then the call will fail (return NULLFSBLOCK in "firstblock"). 

So if we are asked to allocate 1 block, but the AG doesn't have 10
total blocks free, then allocation will fail. What this is used for
is to chain multiple independent data block allocations together in
a single transaction to attempt to get them all from the one AG.
This is used only by the directory/attr code for ensuring all the
allocations needed to add an entry to the dir/attr tree will succeed.
It's essentially an "external block reservation" as the AGF will be
held locked across the multiple allocations once the first
allocation has been done.

The only time "total" is actually meaningful is the first
allocation in a chain. i.e. when firstblock is null. It's really a
"free blocks required to proceed" parameter , not a length
bound for the current allocation.

However, it's impact is to set a maximum length bound on the
allocation, so I'm left to wonder why this was is being hidden this
inside xfs_alloc_space_available() rather than dealing with it when
setting up args->maxlen/minlen/minleft in xfs_bmap_btalloc()?

i.e args->maxlen must always be less than args->total. And if we are
using minleft to protect against running out of space for
bmbt/rmapbt allocation, then I think it should be args->maxlen +
args->minleft < args->total.

If this can all be done and enforced in xfs_bmap_btalloc(), then we
can get rid of args->total from the allocargs completely...


> +	/*
> +	 * Clamp maxlen to the amount of free space available for the actual
> +	 * extent allocation.
> +	 */
> +	if (available < (int)args->maxlen && !(flags & XFS_ALLOC_FLAG_CHECK)) {
> +		args->maxlen = available;
> +		ASSERT(args->maxlen > 0);
> +	}

I'd love to get rid of all these (int) casts, too...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
