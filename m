Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061833236;
	Tue,  4 Jun 2024 15:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717516610; cv=none; b=mgxocLGQ9xGJs666Z3EBZ0Y8ht7bu4kOQUhkcaBZgppcC2S8XEu0XczrLU1dlM6Thj2CIsSKeSJ+TBU54fsaIiHCM9ifMJFcbNv7+viiLu9IW1XDojLNLAzC/UVld9706p0JRF82p5XPqNlv3X/ZkCytnAy/NEHDEyurUKk6x8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717516610; c=relaxed/simple;
	bh=OjqQLm6ztta8QrQg9UbvZS7LmKeXUKHD0lmi31Sk8PE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qSOhlaumU2o2iXRAIJ9rOqipNGM7yruAfkVNvsAeGK33oRjEPOZddMdaiXcEAwYlGZleMzqvsWmKY8tzm1ZY4rBXDHTPDbbDdABjNW7hBCjUR74XRJCZqbQSKGR9tHxJisIcEuY5JTJ6Uk+c8Rh9Xwvhm9JbrD/QuJZdVBp/I6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kw7yXs5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kw7yXs5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871E9C2BBFC;
	Tue,  4 Jun 2024 15:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717516609;
	bh=OjqQLm6ztta8QrQg9UbvZS7LmKeXUKHD0lmi31Sk8PE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kw7yXs5dyNJ02LttL0xvKphFeSOAsXCidZH93L1hIL27xrOpq1no3Vu3Ip6CgUl12
	 pUgFj45rKJO/3j+Mpa20tlUtBwLmxgRf6eDO/4BbtHIg5b3on2MXtbeFP3Q0d1qNIj
	 Y2nZkQJPK1eBlt5fzCrGsBfLCB+mZFmKB2tuCAj2SdJQ78T8lpOAIGFw4amxIbtJs4
	 JISAHzGiocUXSdYOGFP1GJrGfgFBWbEhmt1DotCYco3T5+lT8B67tMhrm/0B1bhKIQ
	 wlYS83m5/xto6wEfNHnFuNG/jkPC6X3DANRFq/bkOHZb8CkkTG+7BrcxRAPx9YuW9T
	 CWuZNfc1r7ikA==
Date: Tue, 4 Jun 2024 08:56:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, yangerkun@huawei.com
Subject: Re: [PATCH] xfs: Fix file creation failure
Message-ID: <20240604155648.GF52987@frogsfrogsfrogs>
References: <20240604071121.3981686-1-wozizhi@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240604071121.3981686-1-wozizhi@huawei.com>

On Tue, Jun 04, 2024 at 03:11:21PM +0800, Zizhi Wo wrote:
> We have an xfs image that contains only 2 AGs, the first AG is full and
> the second AG is empty, then a concurrent file creation and little writing
> could unexpectedly return -ENOSPC error since there is a race window that
> the allocator could get the wrong agf->agf_longest.
> 
> Write file process steps:
> 1) Find the entry that best meets the conditions, then calculate the start
> address and length of the remaining part of the entry after allocation.
> 2) Delete this entry. Because the second AG is empty, the btree in its agf
> has only one record, and agf->agf_longest will be set to 0 after deletion.
> 3) Insert the remaining unused parts of this entry based on the
> calculations in 1), and update the agf->agf_longest.
> 
> Create file process steps:
> 1) Check whether there are free inodes in the inode chunk.
> 2) If there is no free inode, check whether there has space for creating
> inode chunks, perform the no-lock judgment first.
> 3) If the judgment succeeds, the judgment is performed again with agf lock
> held. Otherwire, an error is returned directly.
> 
> If the write process is in step 2) but not go to 3) yet, the create file
> process goes to 2) at this time, it will be mistaken for no space,
> resulting in the file system still has space but the file creation fails.
> 
> 	Direct write				Create file
> xfs_file_write_iter
>  ...
>  xfs_direct_write_iomap_begin
>   xfs_iomap_write_direct
>    ...
>    xfs_alloc_ag_vextent_near
>     xfs_alloc_cur_finish
>      xfs_alloc_fixup_trees
>       xfs_btree_delete
>        xfs_btree_delrec
> 	xfs_allocbt_update_lastrec
> 	// longest = 0 because numrec == 0.
> 	 agf->agf_longest = len = 0
> 					   xfs_create
> 					    ...
> 					     xfs_dialloc
> 					      ...
> 					      xfs_alloc_fix_freelist
> 					       xfs_alloc_space_available
> 					-> as longest=0, it will return
> 					false, no space for inode alloc.
> 
> Fix this issue by adding the bc_free_longest field to the xfs_btree_cur_t
> structure to store the potential longest count that will be updated. The
> assignment is done in xfs_alloc_fixup_trees() and xfs_free_ag_extent().

This is going to be a reverse-order review due to the way that diff
ordered the chunks, which means that the bulk of my questions are at the
end.

> Reported by: Ye Bin <yebin10@huawei.com>
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c       | 14 ++++++++++++++
>  fs/xfs/libxfs/xfs_alloc_btree.c |  9 ++++++++-
>  fs/xfs/libxfs/xfs_btree.h       |  1 +
>  3 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 6c55a6e88eba..86ba873d57a8 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -577,6 +577,13 @@ xfs_alloc_fixup_trees(
>  		nfbno2 = rbno + rlen;
>  		nflen2 = (fbno + flen) - nfbno2;
>  	}
> +
> +	/*
> +	 * Record the potential maximum free length in advance.
> +	 */
> +	if (nfbno1 != NULLAGBLOCK || nfbno2 != NULLAGBLOCK)
> +		cnt_cur->bc_ag.bc_free_longest = XFS_EXTLEN_MAX(nflen1, nflen2);

Ok, so if we're allocating space then this sets bc_free_longest to the
longer of the two remaining sections, if any.  But if we just allocated
the entirety of the longest extent in the cntbt, then we don't set
bc_free_longest, which means its zero, right?  I guess that's ok because
that implies there's zero space left in the AG, so the longest freespace
is indeed zero.

If we just allocated the entirety of a non-longest extent in the cntbt
then we don't call ->lastrec_update so the value of bc_free_longest
doesn't matter?

> +
>  	/*
>  	 * Delete the entry from the by-size btree.
>  	 */
> @@ -2044,6 +2051,13 @@ xfs_free_ag_extent(
>  	 * Now allocate and initialize a cursor for the by-size tree.
>  	 */
>  	cnt_cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
> +	/*
> +	 * Record the potential maximum free length in advance.
> +	 */
> +	if (haveleft)
> +		cnt_cur->bc_ag.bc_free_longest = ltlen;
> +	if (haveright)
> +		cnt_cur->bc_ag.bc_free_longest = gtlen;

What happens in the haveleft && haveright case?  Shouldn't
bc_free_longest be set to ltlen + len + gtlen?  You could just push the
setting of bc_free_longest into the haveleft/haveright code below.

>  	/*
>  	 * Have both left and right contiguous neighbors.
>  	 * Merge all three into a single free block.
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 6ef5ddd89600..8e7d1e0f1a63 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -161,7 +161,14 @@ xfs_allocbt_update_lastrec(
>  			rrp = XFS_ALLOC_REC_ADDR(cur->bc_mp, block, numrecs);
>  			len = rrp->ar_blockcount;
>  		} else {
> -			len = 0;
> +			/*
> +			 * Update in advance to prevent file creation failure
> +			 * for concurrent processes even though there is no
> +			 * numrec currently.
> +			 * And there's no need to worry as the value that no
> +			 * less than bc_free_longest will be inserted later.
> +			 */
> +			len = cpu_to_be32(cur->bc_ag.bc_free_longest);

Humm.  In this case, we've called ->update_lastrec on the cntbt cursor
having deleted all the records in this record block.  Presumably that
means that we're going to add rec->alloc.ar_blockcount blocks to the
rightmost record in the left sibling of @block?  Or already have?

Ahh, right, the pagf_longest checks are done without holding AGF lock.
The concurrent creat call sees this intermediate state (DELREC sets
pagf_longest to zero, a moment later INSREC/UPDATE set it to the correct
nonzero value) and decides to ENOSPC because "nobody" has sufficient
free space.

I think this phony zero never gets written to disk because although
we're logging zero into the ondisk and incore agf_longest here, the next
btree operation will reset it to the correct value.  Right?

Would it be simpler to handle this case by duplicating the cntbt cursor
and walking one record leftward in the tree to find the longest extent,
rather than using this "bc_free_longest" variable?

>  		}
>  
>  		break;
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index f93374278aa1..985b1885a643 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -281,6 +281,7 @@ struct xfs_btree_cur
>  			struct xfs_perag	*pag;
>  			struct xfs_buf		*agbp;
>  			struct xbtree_afakeroot	*afake;	/* for staging cursor */
> +			xfs_extlen_t		bc_free_longest; /* potential longest free space */

This is only used for bnobt/cntbt trees, put it in the per-format
private data area, please.

If the answer to the question about duplicating the btree cursor is "no"
then I think this deserves a much longer comment that captures the fact
that the variable exists to avoid setting pagf_longest to zero for
benefit of the code that does unlocked scanning of AGs for free space.

I also wonder if the unlocked ag scan should just note that it observed
a zero pagf_longest and if no space can be found across all the AGs, to
try again with locks?

--D

>  		} bc_ag;
>  		struct {
>  			struct xfbtree		*xfbtree;
> -- 
> 2.39.2
> 
> 
