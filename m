Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7604E2C029D
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 23:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760484165; cv=none; b=DIOxPhA6z0VoA0keuPzrD1Gsiu4E1iEbp9KmYFgeMCbhk5fH413ch41GuGLIZDFc15wEJ6AmDK62RvjqifH3kkMdP/c/R/j/r0z6QCHgceNb4niqPWTbv+lGHQRa757qbTba9K3bwUYV13UGtnvnGkanpNdoDfSG13pDSOk95iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760484165; c=relaxed/simple;
	bh=Q71O4NVdeawcQ0X5oeCaLm1wTZ++lAxCTIqCmQNYMdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XiI66vbpENuRsPG9P312VhVweiz18RPVmp9xoC32HYqBgjyTt7+TX1vxNYqO6OLgsk4LnropQZ38Dz6IK+3py5zlwXhzYMD/SvtykY7QKgMPR8nm20RenvaTXNHVio7p2syzff4AdWyhsKzFiSIZGpJNnZTS3wmf26oO5jPVtEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cv20fkni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cv20fkni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E795DC4CEE7;
	Tue, 14 Oct 2025 23:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760484165;
	bh=Q71O4NVdeawcQ0X5oeCaLm1wTZ++lAxCTIqCmQNYMdU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cv20fkniUazJugl5T8o8ogFOfUGySm5DEkBI1DorgDdKf8tOgZ3Kv4apxlKLLaa99
	 33tRK9ZyfCTBsAVaB0He6ww+XMISStNCJGVx1/w56xlFsk/oGgunreQ2l03EMAiNWn
	 0c6vyqj2XlNwdCvE8Yklad17qyZu0EA44VCElYuZy4fS9Rcx4ZIAZl+jjedNGgEE96
	 370gUsQbqKST591Dya4SjiAP22AT4vnytIgl5taE0IFBbQomIF1O1gIFoDJX3xjiyp
	 ww4g5x2dZ7oAV0JtqLDpdN+nMd4hHsYokAKhCGNiyHR49AjiunaSbzd3XENZKuO0W7
	 ft3y9AHPn5p0A==
Date: Tue, 14 Oct 2025 16:22:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/17] xfs: don't lock the dquot before return in
 xqcheck_commit_dquot
Message-ID: <20251014232244.GS6188@frogsfrogsfrogs>
References: <20251013024851.4110053-1-hch@lst.de>
 <20251013024851.4110053-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024851.4110053-4-hch@lst.de>

On Mon, Oct 13, 2025 at 11:48:04AM +0900, Christoph Hellwig wrote:
> While xfs_qm_dqput requires the dquot to be locked, the callers can use
> the more common xfs_qm_dqrele helper that takes care of locking the dquot
> instead.

But the start of xqcheck_commit_dquot does:

	/* Unlock the dquot just long enough to allocate a transaction. */
	xfs_dqunlock(dq);
	error = xchk_trans_alloc(xqc->sc, 0);
>>	xfs_dqlock(dq);
	if (error)
		return error;

So that'll cause a livelock in xfs_qm_dqrele in the loop body below if
the transaction allocation fails.

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/quotacheck_repair.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
> index 415314911499..67bdc872996a 100644
> --- a/fs/xfs/scrub/quotacheck_repair.c
> +++ b/fs/xfs/scrub/quotacheck_repair.c
> @@ -121,17 +121,12 @@ xqcheck_commit_dquot(
>  	 * the caller can put the reference (which apparently requires a locked
>  	 * dquot).
>  	 */
> -	error = xrep_trans_commit(xqc->sc);
> -	mutex_lock(&dq->q_qlock);
> -	return error;
> +	return xrep_trans_commit(xqc->sc);
>  
>  out_unlock:
>  	mutex_unlock(&xqc->lock);
>  out_cancel:
>  	xchk_trans_cancel(xqc->sc);
> -
> -	/* Re-lock the dquot so the caller can put the reference. */
> -	mutex_lock(&dq->q_qlock);
>  	return error;
>  }
>  
> @@ -156,7 +151,7 @@ xqcheck_commit_dqtype(
>  	xchk_dqiter_init(&cursor, sc, dqtype);
>  	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
>  		error = xqcheck_commit_dquot(xqc, dqtype, dq);
> -		xfs_qm_dqput(dq);
> +		xfs_qm_dqrele(dq);
>  		if (error)
>  			break;
>  	}
> @@ -187,7 +182,7 @@ xqcheck_commit_dqtype(
>  			return error;
>  
>  		error = xqcheck_commit_dquot(xqc, dqtype, dq);
> -		xfs_qm_dqput(dq);
> +		xfs_qm_dqrele(dq);
>  		if (error)
>  			return error;
>  
> -- 
> 2.47.3
> 
> 
