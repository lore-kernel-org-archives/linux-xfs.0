Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1927FBDC;
	Wed,  6 Mar 2024 14:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709735807; cv=none; b=ISROkhWePIhCt+I5pN+4o9fa0fldcF5ah0bl55sRI/YlbdxD4P+xfCYrwPkI00RhrChDvhuaOUM3nGuKKM61IHnZMk/OXd4mxfxE6N4y+Jg4ubKogSK0f+ZAUCUKC5mGqsM0HF7koKE0pOE9RGKW90PgFdtgIGaXbGJoAF6qRp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709735807; c=relaxed/simple;
	bh=jOJY5zZ8mvtG66fKCffN8cwLOjFyGF6wcctejCjiG+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N/TrCedGr5h4O8rfNqvD9CZ8FKYJ/f2G3vlweRkS8l0LrgKyTwBOu0okXoRp9Gwr6chzPwKugIkSvyCcKqGBBwVGOsyDgzEp6k5ibTWEj9DJDjHDRmOwLSX5F69KVZTLc/uCnzGw/2zre8Q4/jHLTzv+Ajw3IkmPxs8GFGFjyrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EYqXczD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EYqXczD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52856C433C7;
	Wed,  6 Mar 2024 14:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709735806;
	bh=jOJY5zZ8mvtG66fKCffN8cwLOjFyGF6wcctejCjiG+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EYqXczD2957eAx/7ueuQEGjIbo7gvWQteWEum6LBQqndtQuNfqJr552vcmfP8Pr2h
	 IByelGi+NuRW0QOW/eJY45GQGOFOrt2KnwOYQAUwsI7QcXx4TtgI7E7x4gmM4ghggU
	 UhfCzXrIg4gtFRxor+sKHCt20H+dJ0JaD8lDasCMBZyP9+joF64Dut6lEu8rLuERaj
	 SUUnmU9RHSjyorTsUY+5Dq1tGMgm9SKqY/1NHSVRoAAOwks3E04L8c1tuYwgWs2iFw
	 u9J14ybaDj3q+2o05zxLlt5GLne77aHINSjpFX9Lcf9npQ/0fdgo9PETaxAavKaqge
	 jGGrQz5WqArSQ==
Date: Wed, 6 Mar 2024 07:36:43 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [BUG REPORT] General protection fault while discarding extents
 on XFS on next-20240305
Message-ID: <Zeh_e2tUpx-HzCed@kbusch-mbp>
References: <87y1avlsmw.fsf@debian-BULLSEYE-live-builder-AMD64>
 <Zehi_bLuwz9PcbN9@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zehi_bLuwz9PcbN9@infradead.org>

On Wed, Mar 06, 2024 at 04:35:09AM -0800, Christoph Hellwig wrote:
> On Wed, Mar 06, 2024 at 12:49:29PM +0530, Chandan Babu R wrote:
> > The above *probably* occured because __blkdev_issue_discard() noticed a pending
> > signal, processed the bio, freed the bio and returned a non-NULL bio pointer
> > to the caller (i.e. xfs_discard_extents()).
> > 
> > xfs_discard_extents() then tries to process the freed bio once again.
> 
> Yes, __blkdev_issue_discard really needs to clear *biop to NULL for
> this case, i.e.:
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index dc8e35d0a51d6d..26850d4895cdaf 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -99,6 +99,7 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  		cond_resched();
>  		if (fatal_signal_pending(current)) {
>  			await_bio_chain(bio);
> +			*biop = NULL;
>  			return -EINTR;
>  		}
>  	}

But everyone who calls this already sets their local bio to NULL by
default, and __blkdev_issue_discard updates *biop only on success, so
'*biop' should already be NULL here. ?
