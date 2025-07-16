Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B820A25CC64
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 15:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752679855; cv=none; b=kpzcdyoR46j9RZzB30mkt2odJ9BTeRJ5YqrrCyFr/kdTBraxsj9ujV2Ro0Q9lqJ8b7/3HqZ2tOqLsqNS9ryhVibFxcxRNhh/gsB8PpUu70j9nvsZTIjuNMRE2jZas0d0+cBUZH5ghgUGCbEELCNymNqhc/FYl24zRbeFMcbvEqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752679855; c=relaxed/simple;
	bh=G0PkXZ0j3sGdJ/DSPkaXOeGnRqwMrYLiMohrXA+BS6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UJtBkg3QJZnoG3Ph8bSQtaIeHb9+UhVWNNiftQdj3B3NtyzfoH7tbyz76eNe8rrwJtzQFF2Sjt+9MDlhVTkWH68ViwOyJO074AAwMjm6xyYe2B5EgPatmQFFIUxdBCzxLlI9VKPJDWWe+71erov0dQQ2+TSqDcmLVuqOSxwhYqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EQxZxpwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EQxZxpwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0D2C4CEF0;
	Wed, 16 Jul 2025 15:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752679854;
	bh=G0PkXZ0j3sGdJ/DSPkaXOeGnRqwMrYLiMohrXA+BS6Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EQxZxpwtov2XSFRV2RIGpfXc4pQj4DiPPBWshIfMpuVyfvJ4VT+9kjcO4srojWpjl
	 WlfK4fGWHU+RP1jnefBriQfXpRybjzryvKnvXTBSrl+UlmY8b9Fni8wD39K7WhPQ8V
	 IYWT5fIxafL1JmdkO/3rkjceobM7DhihQXUNoD81TnHV1NoStIJj0F6+1oIYl8QA1u
	 2HzeFLLX/9ta8xIqDrmvJvtKlwAHQohXZ5AGdmunWnt+vFvkXnN2FJB6N+/c3koSFV
	 Hs3RUBBkdJ1EuwPhCxoNTjco7dpRxZoNJ48rHA5s47Zy4156hQXLuFXSLxJ3a5vOM3
	 Q1qcE/GSKuwFQ==
Date: Wed, 16 Jul 2025 08:30:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: don't use xfs_trans_reserve in
 xfs_trans_reserve_more
Message-ID: <20250716153053.GD2672049@frogsfrogsfrogs>
References: <20250716124352.2146673-1-hch@lst.de>
 <20250716124352.2146673-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716124352.2146673-3-hch@lst.de>

On Wed, Jul 16, 2025 at 02:43:12PM +0200, Christoph Hellwig wrote:
> xfs_trans_reserve_more just tries to allocate additional blocks and/or
> rtextents and is otherwise unrelated to the transaction reservation
> logic.  Open code the block and rtextent reservation in
> xfs_trans_reserve_more to prepare for simplifying xfs_trans_reserve.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_trans.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 8b15bfe68774..2213cb2278d2 100644
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
> +	if (rtextents && xfs_dec_frextents(tp->t_mountp, rtextents)) {
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
