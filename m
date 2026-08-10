Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07505436BFB;
	Mon, 10 Aug 2026 18:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786386823; cv=none; b=UlzrG48SeJr2EfphKdyOM03G52i6nizkmHcd15U46+FHgjO6dXflVqqHMSGmQTKdUaz0rwR2cY57BtfAe21F/TzDPH1cbObRJbZlJu9f8aLLkjMyFaj+yeGt3DNcpfUcgAeyMSkhkyTfXBIaa0FU7fBFCdVGu1HVASNm0LJi/Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786386823; c=relaxed/simple;
	bh=lgxVAfY6gebRrEmX6A68ZLj0anJ+wt4eJ1UBftq5IVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mHQfg6hq14Htsi5l23txhrqADt28QAXbwLygHKOEido9UoYp3f21h/XYJQEh5XY69gbSQHGp716/PQpw1TyLvDFqUtakTev5FTFMJ9R+Domo/Q1aTjkeTdHZ3VzfB2/Nky76KHx6bWRGtSx/8xIOoiua4q92Fkg8cWQHsxB7/nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SO6sMt6+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SO6sMt6+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8CDCA1F000E9;
	Mon, 10 Aug 2026 18:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786386821;
	bh=P+QII8ZKvaQfkVfr9AxrovrvQB4Skg9pDqF1L2zyIcM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SO6sMt6+vHopMH71sCFaOis9vqgkT0ZRd2fRBtR09eDrpxPNd4b94V+tYmMeZWBIq
	 wezIItJ/GyGKyJaMxS1e11n5guhsd+Z+VSfeZpdDup+ZroK69wkYKcfa7miOQHo4wl
	 d1BY1DNQYnmbsIYfSKqFb9C7iFdq+6WsvQNNfPUYj6DCMuoRaHNs8PYnzml/Gj/PE1
	 HLkf+l3UBsZEztqbFt3jFBNCOIDyO6Ci4LDvIWF5I4kdE9c71nyXmr6bMDhohhQ2ng
	 JUpMwWm+TXBaTXqpsuqOUR2wtaRIUj0giAqQ1mKPFEkUFjDq0cbY4jO1s9IeGl89Ir
	 m+uth/ywpIvBg==
Date: Mon, 10 Aug 2026 11:33:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: avoid double deferrals for RWF_DONTCACHE writes
Message-ID: <20260810183341.GZ3556460@frogsfrogsfrogs>
References: <20260810-xfs-dontcache-double-defer-v1-1-aea7484b3e49@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810-xfs-dontcache-double-defer-v1-1-aea7484b3e49@columbia.edu>

On Mon, Aug 10, 2026 at 12:39:19PM -0400, Tal Zussman wrote:
> XFS already defers some writes to a workqueue when transactions are
> needed to process the I/O completion. Disable the block layer bio task
> completion in this case to avoid a major performance drop.
> 
> Fixes: efbde6f9f449 ("iomap: use BIO_COMPLETE_IN_TASK for dropbehind writeback")

What commit is this?

(If we're fixing something that's not in Linus' tree then I think the
fixes tags aren't required)

> Link: https://lore.kernel.org/all/8124341f-3af2-4a16-897d-38db5ab5a9d4@columbia.edu/
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
> Follow-up fix for the RWF_DONTCACHE task-completion series. This is
> targeting the block tree. [1]
> 
> [1]: https://lore.kernel.org/linux-block/annkDbhXBEeMoNVT@infradead.org/
> ---
>  fs/xfs/xfs_aops.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index cd8de8c82d78..74a6089abadf 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -549,10 +549,14 @@ xfs_writeback_submit(
>  	}
>  
>  	/*
> -	 * Send ioends that might require a transaction to the completion wq.
> +	 * Send ioends that might require a transaction to the completion wq,
> +	 * and disable the block layer task completion for them as there is no
> +	 * need to defer twice.
>  	 */
> -	if (xfs_ioend_needs_wq_completion(ioend))
> +	if (xfs_ioend_needs_wq_completion(ioend)) {
>  		ioend->io_bio.bi_end_io = xfs_end_bio;
> +		bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
> +	}
>  
>  	return iomap_ioend_writeback_submit(wpc, error);
>  }
> @@ -663,7 +667,14 @@ xfs_zoned_writeback_submit(
>  {
>  	struct iomap_ioend		*ioend = wpc->wb_ctx;
>  
> +	/*
> +	 * Defer all completions to our workqueue as all zoned writes require a
> +	 * transaction to be persisted. This also means we never need the block
> +	 * layer in-task completion for a task context.
> +	 */
>  	ioend->io_bio.bi_end_io = xfs_end_bio;
> +	bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);

This makes sense to me;
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +
>  	if (error) {
>  		ioend->io_bio.bi_status = errno_to_blk_status(error);
>  		bio_endio(&ioend->io_bio);
> 
> ---
> base-commit: 30df3ab3c92d0e7854c54df6ae66f4aa6eb5b3d2
> change-id: 20260810-xfs-dontcache-double-defer-ae3fa50ba02c
> 
> Best regards,
> -- 
> Tal Zussman <tz2294@columbia.edu>
> 
> 
