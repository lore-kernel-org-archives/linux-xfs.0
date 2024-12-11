Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2B21DE2BA
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 17:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733938399; cv=none; b=p9YmO8zWdZXY8RcDzL7wrZIp0lkGoFq3rpvzYjzm30195j3y5dN9ufhhhik9Psud8onZW6TA6o2V4sVpeDeicAYVVPOoAzW3XBM6oRP6BMZ9v4mYfQFqlQNy4riUPSEjiJfB7GOMeaGUn4S9FC8sT5gGol7t+04pJAqal9DQt9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733938399; c=relaxed/simple;
	bh=hUD1I+3muupAlxpWixD0rAJVcQpEB6eFlSqKpOvlhnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=thR9BW4qtJBSCaO7LHkGn2k/zZBJe+ZID8A1DIdMLASds3Xfl4TY7rwYuQ9q0YpjgQo3VJUKh2lw8pgXIavlb2cmeHSKfk2VbvysXoHOZohlCyJOqdSBIGCVfQPyf/Qb2sN/1d/AirIMZiqpKpB6rxK4mmJvKZOnTnutm6293+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jUeQ3Srq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jUeQ3Srq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6001C4CED2;
	Wed, 11 Dec 2024 17:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733938398;
	bh=hUD1I+3muupAlxpWixD0rAJVcQpEB6eFlSqKpOvlhnk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jUeQ3SrqtQDMfQoDsASEYyddy3HzyYbZFJiMkQvDBYalu32eNHoAuvLMD6KcH9XN9
	 4421wciwin5u/yFETmB0r6lh1X1s+APOEGne4nQUN9UUe3yZ7INuMNfFpBJsp2XK43
	 gYGOvKErHaQD3+18yeQQ5ebfphgt0TPnwoz5YVv2WBQ1pxfXc2OqpDCgP9mi4Gg2bI
	 EFrZ48nHAH4k1rq1UyNNb7mx+kVLZ2On7NAu7SynQwQBEcSN043d46qHBxg7UyKwLd
	 Dizsxrb85otacSWRrqPZSt6LcHukqS9vJp6V74U/JSa6lGJUX3ZCqbR4OViis8/4+F
	 mowZfda/yA9VQ==
Date: Wed, 11 Dec 2024 09:33:18 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] xfs: fix !quota build
Message-ID: <20241211173318.GB6698@frogsfrogsfrogs>
References: <20241211035433.1321051-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211035433.1321051-1-hch@lst.de>

On Wed, Dec 11, 2024 at 04:54:32AM +0100, Christoph Hellwig wrote:
> fix the !quota stub for xfs_trans_apply_dquot_deltas.
> 
> Fixes: 03d23e3ebeb7 ("xfs: don't lose solo dquot update transactions")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Doh, looks like I got confused by all the bot reports and modified both.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Also, can we get rid of CONFIG_XFS_{QUOTA,POSIX_ACL}?  Maintaining all
these dummy macros is ... irritating.

--D

> ---
>  fs/xfs/xfs_quota.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index b864ed597877..d7565462af3d 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -173,7 +173,7 @@ static inline void xfs_trans_mod_dquot_byino(struct xfs_trans *tp,
>  		struct xfs_inode *ip, uint field, int64_t delta)
>  {
>  }
> -#define xfs_trans_apply_dquot_deltas(tp, a)
> +#define xfs_trans_apply_dquot_deltas(tp)
>  #define xfs_trans_unreserve_and_mod_dquots(tp, a)
>  static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
>  		struct xfs_inode *ip, int64_t dblocks, int64_t rblocks,
> -- 
> 2.45.2
> 
