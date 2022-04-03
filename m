Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4301CC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Apr 2022 23:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351311AbiDCXGx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Apr 2022 19:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237761AbiDCXGw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Apr 2022 19:06:52 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9946915A3A
        for <linux-xfs@vger.kernel.org>; Sun,  3 Apr 2022 16:04:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C12F1534336;
        Mon,  4 Apr 2022 09:04:53 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nb9HA-00DRYQ-Iu; Mon, 04 Apr 2022 09:04:52 +1000
Date:   Mon, 4 Apr 2022 09:04:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: remove a superflous hash lookup when inserting
 new buffers
Message-ID: <20220403230452.GP1544202@dread.disaster.area>
References: <20220403120119.235457-1-hch@lst.de>
 <20220403120119.235457-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220403120119.235457-4-hch@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=624a2816
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=oyv8vky7fTzTBncbwvoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 03, 2022 at 02:01:17PM +0200, Christoph Hellwig wrote:
> xfs_buf_get_map has a bit of a strange structure where the xfs_buf_find
> helper is called twice before we actually insert a new buffer on a cache
> miss.  Given that the rhashtable has an interface to insert a new entry
> and return the found one on a conflict we can easily get rid of the
> double lookup by using that.

We can do that without completely rewriting this code.

        spin_lock(&pag->pag_buf_lock);
	if (!new_bp) {
		bp = rhashtable_lookup_fast(&pag->pag_buf_hash, &cmap,
					    xfs_buf_hash_params);
		if (!bp) {
			error = -ENOENT;
			goto not_found;
		}
	} else {
		bp = rhashtable_lookup_get_insert_fast(&pag->pag_buf_hash,
				&new_bp->b_rhash_head, xfs_buf_hash_params);
		if (IS_ERR(bp)) {
			error = PTR_ERR(*bpp);
			goto not_found;
		}
		if (!bp) {
			/*
			 * Inserted new buffer, it keeps the perag reference until
			 * it is freed.
			 */
			new_bp->b_pag = pag;
			spin_unlock(&pag->pag_buf_lock);
			*found_bp = new_bp;
			return 0;
		}
	}

	atomic_inc(&bp->b_hold);
        spin_lock(&pag->pag_buf_lock);
	xfs_perag_put(pag);

	<lock buffer>

	*found_bp = bp;
	return 0;

not_found:
	spin_lock(&pag->pag_buf_lock); 
	xfs_perag_put(pag);
	return error;
}

And now we have the existing code with the the optimised rhashtable
insertion. I'd much prefer this be separated out like this so that
this rhashtable usage change is a separate bisectable commit to all
the other changes.

I'm also not sold on moving where we allocate the buffer allocation
as done in this patch because:

> +static int
> +xfs_buf_insert(
> +	struct xfs_buftarg	*btp,
> +	struct xfs_buf_map	*map,
> +	int			nmaps,
> +	xfs_buf_flags_t		flags,
> +	struct xfs_perag	*pag,
> +	struct xfs_buf		**bpp)
> +{
> +	int			error;
> +	struct xfs_buf		*bp;
> +
> +	error = _xfs_buf_alloc(btp, map, nmaps, flags, &bp);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * For buffers that fit entirely within a single page, first attempt to
> +	 * allocate the memory from the heap to minimise memory usage. If we
> +	 * can't get heap memory for these small buffers, we fall back to using
> +	 * the page allocator.
> +	 */
> +	if (BBTOB(bp->b_length) >= PAGE_SIZE ||
> +	    xfs_buf_alloc_kmem(bp, flags) < 0) {
> +		error = xfs_buf_alloc_pages(bp, flags);
> +		if (error)
> +			goto out_free_buf;
> +	}
> +
> +	/* the buffer keeps the perag reference until it is freed */
> +	bp->b_pag = pag;
> +
> +	spin_lock(&pag->pag_buf_lock);
> +	*bpp = rhashtable_lookup_get_insert_fast(&pag->pag_buf_hash,
> +			&bp->b_rhash_head, xfs_buf_hash_params);
> +	if (IS_ERR(*bpp)) {
> +		error = PTR_ERR(*bpp);
> +		goto out_unlock;
> +	}
> +	if (*bpp) {
> +		/* found an existing buffer */
> +		atomic_inc(&(*bpp)->b_hold);
> +		error = -EEXIST;
> +		goto out_unlock;
> +	}
> +	spin_unlock(&pag->pag_buf_lock);
> +	*bpp = bp;
> +	return 0;

The return cases of this function end up being a bit of a mess. We can return:

 - error = 0 and a locked buffer in *bpp
 - error = -EEXIST and an unlocked buffer in *bpp
 - error != 0 and a modified *bpp pointer
 - error != 0 and an unmodified *bpp pointer

So we end up with a bunch of logic here to separate out the return
cases into different error values, then have to add logic to the
caller to handle the different return cases.

And if we look at the new caller:

> +	if (unlikely(!bp)) {
> +		if (flags & XBF_NOALLOC) {
> +			XFS_STATS_INC(mp, xb_miss_locked);
> +			xfs_perag_put(pag);
> +			return -ENOENT;
> +		}
> +
> +		error = xfs_buf_insert(btp, map, nmaps, flags, pag, &bp);
> +		if (!error)
> +			goto finish;
> +		if (error != -EEXIST) {
> +			xfs_perag_put(pag);
> +			return error;
> +		}
> +	}
>  	xfs_perag_put(pag);

	<lock the buffer>

It took me quite some time to realise this wasn't buggy - it looks
for all the world like the "!error" case here fails to lock the
buffer and leaks the perag reference. It isn't at all clear that the
new buffer is inserted locked into the hash and that it steals the
callers perag reference, whilst the -EEXIST case does neither yet
still returns a buffer.

Hence while I like the idea of changing up how we allocate the
buffer on lookup failure, I'm not sold on this interface yet. Hence
I think splitting the rhashtable insert optimisation from the
allocation rework might help clean this up more.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
