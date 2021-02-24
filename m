Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0443C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99DE364F06
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236049AbhBXVkj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 16:40:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:50270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236046AbhBXVkg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Feb 2021 16:40:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D613064EFA;
        Wed, 24 Feb 2021 21:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614202794;
        bh=v9q2RG17LUOTxVTTkXgjxYbyd2lqfBthCgk5VGKMJb0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dfSyVivxobVH+p9jpivqsvBN2hBQDQuR0nX5pVF1BLKUZyovtkReHngkkmEOnyGEi
         BJGwMgJm4lbYT/Xa0jcm6UI309CVPy8MQxygKKwiD5M6xqyyFsryfj/ZTUF9fgAuOP
         E1GVgSMR+9oeIwObfTDAkBPIQ2xizmUnJsEh0ZniBlp9Qrl6Sy1Mhmr868XVlsb77n
         1EV3fxqWjV5RJBALNx4TMMMUtX1ZchLIZ3gQgwPUtXAoE1HZcoBf6Z4Yt9zUKsVGH1
         pH85V/qjC14oTcIt5aSAjE9qk6T9M/vR2V8zH+KaWds7nqx3nSHxe8iLamVpXiMWBh
         BsC7uQuJAa4TQ==
Date:   Wed, 24 Feb 2021 13:39:54 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: optimise xfs_buf_item_size/format for
 contiguous regions
Message-ID: <20210224213954.GA7272@magnolia>
References: <20210223044636.3280862-1-david@fromorbit.com>
 <20210223044636.3280862-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223044636.3280862-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 03:46:36PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We process the buf_log_item bitmap one set bit at a time with
> xfs_next_bit() so we can detect if a region crosses a memcpy
> discontinuity in the buffer data address. This has massive overhead
> on large buffers (e.g. 64k directory blocks) because we do a lot of
> unnecessary checks and xfs_buf_offset() calls.
> 
> For example, 16-way concurrent create workload on debug kernel
> running CPU bound has this at the top of the profile at ~120k
> create/s on 64kb directory block size:
> 
>   20.66%  [kernel]  [k] xfs_dir3_leaf_check_int
>    7.10%  [kernel]  [k] memcpy
>    6.22%  [kernel]  [k] xfs_next_bit
>    3.55%  [kernel]  [k] xfs_buf_offset
>    3.53%  [kernel]  [k] xfs_buf_item_format
>    3.34%  [kernel]  [k] __pv_queued_spin_lock_slowpath
>    3.04%  [kernel]  [k] do_raw_spin_lock
>    2.84%  [kernel]  [k] xfs_buf_item_size_segment.isra.0
>    2.31%  [kernel]  [k] __raw_callee_save___pv_queued_spin_unlock
>    1.36%  [kernel]  [k] xfs_log_commit_cil
> 
> (debug checks hurt large blocks)
> 
> The only buffers with discontinuities in the data address are
> unmapped buffers, and they are only used for inode cluster buffers
> and only for logging unlinked pointers. IOWs, it is -rare- that we
> even need to detect a discontinuity in the buffer item formatting
> code.
> 
> Optimise all this by using xfs_contig_bits() to find the size of
> the contiguous regions, then test for a discontiunity inside it. If
> we find one, do the slow "bit at a time" method we do now. If we
> don't, then just copy the entire contiguous range in one go.
> 
> Profile now looks like:
> 
>   25.26%  [kernel]  [k] xfs_dir3_leaf_check_int
>    9.25%  [kernel]  [k] memcpy
>    5.01%  [kernel]  [k] __pv_queued_spin_lock_slowpath
>    2.84%  [kernel]  [k] do_raw_spin_lock
>    2.22%  [kernel]  [k] __raw_callee_save___pv_queued_spin_unlock
>    1.88%  [kernel]  [k] xfs_buf_find
>    1.53%  [kernel]  [k] memmove
>    1.47%  [kernel]  [k] xfs_log_commit_cil
> ....
>    0.34%  [kernel]  [k] xfs_buf_item_format
> ....
>    0.21%  [kernel]  [k] xfs_buf_offset
> ....
>    0.16%  [kernel]  [k] xfs_contig_bits
> ....
>    0.13%  [kernel]  [k] xfs_buf_item_size_segment.isra.0
> 
> So the bit scanning over for the dirty region tracking for the
> buffer log items is basically gone. Debug overhead hurts even more
> now...
> 
> Perf comparison
> 
> 		dir block	 creates		unlink
> 		size (kb)	time	rate		time
> 
> Original	 4		4m08s	220k		 5m13s
> Original	64		7m21s	115k		13m25s
> Patched		 4		3m59s	230k		 5m03s
> Patched		64		6m23s	143k		12m33s
> 
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Seems straightforward enough...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf_item.c | 102 +++++++++++++++++++++++++++++++++++-------
>  1 file changed, 87 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 91dc7d8c9739..14d1fefcbf4c 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -59,12 +59,18 @@ static inline bool
>  xfs_buf_item_straddle(
>  	struct xfs_buf		*bp,
>  	uint			offset,
> -	int			next_bit,
> -	int			last_bit)
> +	int			first_bit,
> +	int			nbits)
>  {
> -	return xfs_buf_offset(bp, offset + (next_bit << XFS_BLF_SHIFT)) !=
> -		(xfs_buf_offset(bp, offset + (last_bit << XFS_BLF_SHIFT)) +
> -		 XFS_BLF_CHUNK);
> +	void			*first, *last;
> +
> +	first = xfs_buf_offset(bp, offset + (first_bit << XFS_BLF_SHIFT));
> +	last = xfs_buf_offset(bp,
> +			offset + ((first_bit + nbits) << XFS_BLF_SHIFT));
> +
> +	if (last - first != nbits * XFS_BLF_CHUNK)
> +		return true;
> +	return false;
>  }
>  
>  /*
> @@ -84,20 +90,51 @@ xfs_buf_item_size_segment(
>  	int				*nbytes)
>  {
>  	struct xfs_buf			*bp = bip->bli_buf;
> +	int				first_bit;
> +	int				nbits;
>  	int				next_bit;
>  	int				last_bit;
>  
> -	last_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
> -	if (last_bit == -1)
> +	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
> +	if (first_bit == -1)
>  		return;
>  
> -	/*
> -	 * initial count for a dirty buffer is 2 vectors - the format structure
> -	 * and the first dirty region.
> -	 */
> -	*nvecs += 2;
> -	*nbytes += xfs_buf_log_format_size(blfp) + XFS_BLF_CHUNK;
> +	(*nvecs)++;
> +	*nbytes += xfs_buf_log_format_size(blfp);
> +
> +	do {
> +		nbits = xfs_contig_bits(blfp->blf_data_map,
> +					blfp->blf_map_size, first_bit);
> +		ASSERT(nbits > 0);
> +
> +		/*
> +		 * Straddling a page is rare because we don't log contiguous
> +		 * chunks of unmapped buffers anywhere.
> +		 */
> +		if (nbits > 1 &&
> +		    xfs_buf_item_straddle(bp, offset, first_bit, nbits))
> +			goto slow_scan;
> +
> +		(*nvecs)++;
> +		*nbytes += nbits * XFS_BLF_CHUNK;
> +
> +		/*
> +		 * This takes the bit number to start looking from and
> +		 * returns the next set bit from there.  It returns -1
> +		 * if there are no more bits set or the start bit is
> +		 * beyond the end of the bitmap.
> +		 */
> +		first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
> +					(uint)first_bit + nbits + 1);
> +	} while (first_bit != -1);
>  
> +	return;
> +
> +slow_scan:
> +	/* Count the first bit we jumped out of the above loop from */
> +	(*nvecs)++;
> +	*nbytes += XFS_BLF_CHUNK;
> +	last_bit = first_bit;
>  	while (last_bit != -1) {
>  		/*
>  		 * This takes the bit number to start looking from and
> @@ -115,11 +152,14 @@ xfs_buf_item_size_segment(
>  		if (next_bit == -1) {
>  			break;
>  		} else if (next_bit != last_bit + 1 ||
> -		           xfs_buf_item_straddle(bp, offset, next_bit, last_bit)) {
> +		           xfs_buf_item_straddle(bp, offset, first_bit, nbits)) {
>  			last_bit = next_bit;
> +			first_bit = next_bit;
>  			(*nvecs)++;
> +			nbits = 1;
>  		} else {
>  			last_bit++;
> +			nbits++;
>  		}
>  		*nbytes += XFS_BLF_CHUNK;
>  	}
> @@ -276,6 +316,38 @@ xfs_buf_item_format_segment(
>  	/*
>  	 * Fill in an iovec for each set of contiguous chunks.
>  	 */
> +	do {
> +		ASSERT(first_bit >= 0);
> +		nbits = xfs_contig_bits(blfp->blf_data_map,
> +					blfp->blf_map_size, first_bit);
> +		ASSERT(nbits > 0);
> +
> +		/*
> +		 * Straddling a page is rare because we don't log contiguous
> +		 * chunks of unmapped buffers anywhere.
> +		 */
> +		if (nbits > 1 &&
> +		    xfs_buf_item_straddle(bp, offset, first_bit, nbits))
> +			goto slow_scan;
> +
> +		xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
> +					first_bit, nbits);
> +		blfp->blf_size++;
> +
> +		/*
> +		 * This takes the bit number to start looking from and
> +		 * returns the next set bit from there.  It returns -1
> +		 * if there are no more bits set or the start bit is
> +		 * beyond the end of the bitmap.
> +		 */
> +		first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
> +					(uint)first_bit + nbits + 1);
> +	} while (first_bit != -1);
> +
> +	return;
> +
> +slow_scan:
> +	ASSERT(bp->b_addr == NULL);
>  	last_bit = first_bit;
>  	nbits = 1;
>  	for (;;) {
> @@ -300,7 +372,7 @@ xfs_buf_item_format_segment(
>  			blfp->blf_size++;
>  			break;
>  		} else if (next_bit != last_bit + 1 ||
> -		           xfs_buf_item_straddle(bp, offset, next_bit, last_bit)) {
> +		           xfs_buf_item_straddle(bp, offset, first_bit, nbits)) {
>  			xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
>  						first_bit, nbits);
>  			blfp->blf_size++;
> -- 
> 2.28.0
> 
