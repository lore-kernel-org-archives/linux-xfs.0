Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F972475CB
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 21:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760563213; cv=none; b=k4df6fgyNz+3ndWb6hQz6nvwO+Df/NVHLg0FAM9SddNcBatTK2U23YcBw7mYNBXparIViRAeVLBO9ua8FJM1eieMJe3QELH3bkoXkbWuUJWkt2hUok7QlmazmdACX4ku0700Y8z0GMkojTzCkvJxziURUZMq/A/zhf14V/jgt24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760563213; c=relaxed/simple;
	bh=q1ppWYKPBi5LXGJ/qF+VHk31N2Jd/iSkss8yF3tg/5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p1bmaYtoz3ttKcBPNSqpnKynHKMWh9bjFIxWwmtx/ei7zZmaIKuIT/axDiBHRiIBuKyAbqVxoZRBEWwz6bE14aFzM72LSxK+JyZkyJkxYw5AdlfDzYECwxmys2U69Uf16cgjyws2uT17YYRXvxubgvSeke8X57AOOI9+m4V8pDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UHUBzQ73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UHUBzQ73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240B3C4CEF8;
	Wed, 15 Oct 2025 21:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760563213;
	bh=q1ppWYKPBi5LXGJ/qF+VHk31N2Jd/iSkss8yF3tg/5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UHUBzQ738DsEboIN55eqyQiczKeaVW+Ctl5tVM7q7o4nyxo4v085h9iQcwgutAP9X
	 mpYWPu5jomc4vT/D6Gm4smFdmcK/vbmqb9eF298STtN4RPEvVMTkCew5QqH99+s8VT
	 bZAuqtKX9RkiguZpocRAeN20fuyzvonypZpzTLnSugjfO7aC51UGC/j/QofHwNPQpm
	 Dg4HKPkJgX66bYEYI2FgXYO0ZYY8ERstbS1OmNrYWgh2BRgADvbghG1wDX3s8pJXCJ
	 6Qj+0fomieZxyhFM25MF1oM/MxdUn59Xl1l0fA6/li+qE5JXjx7/VZQ5AwJO/FDh4W
	 JjGO0/0F4gVPQ==
Date: Wed, 15 Oct 2025 14:20:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/17] xfs: move q_qlock locking into
 xqcheck_compare_dquot
Message-ID: <20251015212012.GJ2591640@frogsfrogsfrogs>
References: <20251013024851.4110053-1-hch@lst.de>
 <20251013024851.4110053-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024851.4110053-15-hch@lst.de>

On Mon, Oct 13, 2025 at 11:48:15AM +0900, Christoph Hellwig wrote:
> Instead of having both callers do it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yay less lock cycling!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/quotacheck.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
> index 20220afd90f1..cc2b2dfc9261 100644
> --- a/fs/xfs/scrub/quotacheck.c
> +++ b/fs/xfs/scrub/quotacheck.c
> @@ -563,6 +563,7 @@ xqcheck_compare_dquot(
>  		return -ECANCELED;
>  	}
>  
> +	mutex_lock(&dq->q_qlock);
>  	mutex_lock(&xqc->lock);
>  	error = xfarray_load_sparse(counts, dq->q_id, &xcdq);
>  	if (error)
> @@ -590,6 +591,7 @@ xqcheck_compare_dquot(
>  		error = -ECANCELED;
>  	}
>  	mutex_unlock(&xqc->lock);
> +	mutex_unlock(&dq->q_qlock);
>  	if (error)
>  		return error;
>  
> @@ -635,9 +637,7 @@ xqcheck_walk_observations(
>  		if (error)
>  			return error;
>  
> -		mutex_lock(&dq->q_qlock);
>  		error = xqcheck_compare_dquot(xqc, dqtype, dq);
> -		mutex_unlock(&dq->q_qlock);
>  		xfs_qm_dqrele(dq);
>  		if (error)
>  			return error;
> @@ -675,9 +675,7 @@ xqcheck_compare_dqtype(
>  	/* Compare what we observed against the actual dquots. */
>  	xchk_dqiter_init(&cursor, sc, dqtype);
>  	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
> -		mutex_lock(&dq->q_qlock);
>  		error = xqcheck_compare_dquot(xqc, dqtype, dq);
> -		mutex_unlock(&dq->q_qlock);
>  		xfs_qm_dqrele(dq);
>  		if (error)
>  			break;
> -- 
> 2.47.3
> 
> 
