Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A433B1F2BAD
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 14:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752590985; cv=none; b=Es8XQhEngyatRxgKR0OViGCae/QL0tI5fEN25VYNgTcc74SuAi83iC0oPG1/oRVK7aTgxZg8bA7yR81T+6fn5V2WQz31BekQDYWn2G24hgNNfiQN++78KpbWviZOF/Ayi51OWL37O1k8X9VPkS2rUJnA7ZuVNQjtYC8AJBI3irM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752590985; c=relaxed/simple;
	bh=MMq7SxwZaP2Io+E74dHauj0fVGOYyPzb1xJjFr4zhyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IyvrJiN1IiyTAFToxq4l+MfKJFYIpezsr9A7YlWd20VXkisGLoSzyX4/F2HKPlu2mMM7GE56Iqkn/Ch+9j/tc1yJC6M07GiUUoU3qLhHUH2kd0uEqlTPGZJyE+epvGbUZJYYk14rvFegDYOhdB1TG1B/+P8Kh8gHYAmnYl25hhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J3tss93L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J3tss93L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8C0C4CEF1;
	Tue, 15 Jul 2025 14:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752590985;
	bh=MMq7SxwZaP2Io+E74dHauj0fVGOYyPzb1xJjFr4zhyE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J3tss93LSvuu8AIgASWMjtvYHkffrsMdZyIdCmWHyRLUgF6svjWYRY5x/mZmkKHHT
	 wAjhYzx8D1KBFMig+1BuPrDCnHF/jXAQAMIT+UDI5IdDeEZrF+sUdmR1DsVtbdUo/5
	 KJ5aqnDkmQkRJVhrx/NSYgj5tDDjaGy+7WpOO+r+O2y5pWkrwoWW+sfhJfcAy9RQn0
	 8fgM0W6K0nNJC8zJNNb6PJ9h6F2vqK2salP4F0n+Xf0uLUA2wQWekceUuyUsK2LCkn
	 Szn07ReCcuSPGNJ27S7iyh+vQSsyrgZbA2vW4F0O9/9OGgN67DfwEFiSsTgWDgHMCw
	 QjHDyMPwY7Ofw==
Date: Tue, 15 Jul 2025 07:49:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: don't use xfs_trans_reserve in
 xfs_trans_reserve_more
Message-ID: <20250715144944.GU2672049@frogsfrogsfrogs>
References: <20250715122544.1943403-1-hch@lst.de>
 <20250715122544.1943403-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715122544.1943403-3-hch@lst.de>

On Tue, Jul 15, 2025 at 02:25:35PM +0200, Christoph Hellwig wrote:
> xfs_trans_reserve_more just tries to allocate additional blocks and/or
> rtextents and is otherwise unrelated to the transaction reservation
> logic.  Open code the block and rtextent reservation in
> xfs_trans_reserve_more to prepare for simplifying xfs_trans_reserve.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_trans.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 8b15bfe68774..1fddea8d761a 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1146,9 +1146,18 @@ xfs_trans_reserve_more(
>  	unsigned int		blocks,
>  	unsigned int		rtextents)
>  {
> -	struct xfs_trans_res	resv = { };
> -
> -	return xfs_trans_reserve(tp, &resv, blocks, rtextents);
> +	bool			rsvd = tp->t_flags & XFS_TRANS_RESERVE;
> +
> +	if (blocks && xfs_dec_fdblocks(tp->t_mountp, blocks, rsvd))
> +		return -ENOSPC;
> +	if (rtextents && xfs_dec_frextents(tp->t_mountp, rtextents) < 0) {

xfs_dec_frextents is checked for a negative return value, then why isn't
xfs_dec_fdblocks given the same treatment?  Or, since IIRC both return 0
or -ENOSPC you could omit the "< 0" ?

I like how this eliminates the pointless empty resv object though.

--D

> +		if (blocks)
> +			xfs_add_fdblocks(tp->t_mountp, blocks);
> +		return -ENOSPC;
> +	}
> +	tp->t_blk_res += blocks;
> +	tp->t_rtx_res += rtextents;
> +	return 0;
>  }
>  
>  /*
> -- 
> 2.47.2
> 
> 
