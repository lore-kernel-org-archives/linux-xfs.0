Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8A631E110
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 18:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762798429; cv=none; b=p4Izy1v9pi/Hh6fHtyetgm8UUg83S69vfJHpf13ReBskQoKadZxFY258yWoA75tu2N8zSVes47D/Azel5HLBElcT7kNB9SEIOTupZr2+tWHgJ1JHKPaOV3Gdh96n0E9mtFjaVgPj8pVyyJVYkO0VpjR8lnuCMkNDALTIxIuYTeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762798429; c=relaxed/simple;
	bh=ekngu/zX4YFhjUhwjR7AZDjf+FnrWQFXLXzJkjpo9iY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J48YaTltDKpaaRrv0xf73Bmc+vAesC41PW4L1fvHSbtie9V/7a8CF4Yy2g7Zxln3CakW6dDOkMm8dGO35bWG6Is70WwBCokcsZTWH9cdz1KBD90YkgnN69y71pMT08/v67aJMyzWqpxDowySHWYE6TMOcJuPuVdYlynqpWmUEV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gi777avV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gi777avV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4084C4CEF5;
	Mon, 10 Nov 2025 18:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762798428;
	bh=ekngu/zX4YFhjUhwjR7AZDjf+FnrWQFXLXzJkjpo9iY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gi777avVVZ/kaCJJgugjUpEaADX1SG/6SyvzzCoX5cIvGEI429m9yGm0fOJDlDMOA
	 YYB4BPqhhT3PsWLIFdNOCqZGEBpevR1Zirb+UPLCNp6wbjLR3gdrgIe59ORMQw/PWf
	 ZVrim8/CcPzik2cHws+hyVB9yQ2pWipV7gN9Ltxzh6eYjXfGJaYmgf6V46oH4BPWPU
	 JP30XdChcWr7xypdaTWd7dxoF+SlpP6oNnPqQ4L7Ynk9H85X5v8Iw1kCb4kKJYJLXk
	 2MUiS/d3Qn/sooqPaHWo5/zlZCOYnvGbWt8dcZLuFWlWuO+0gwnuneaGRTHbuwjE/0
	 r/Ljhmob4836Q==
Date: Mon, 10 Nov 2025 10:13:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/18] xfs: move quota locking into xqcheck_commit_dquot
Message-ID: <20251110181348.GU196370@frogsfrogsfrogs>
References: <20251110132335.409466-1-hch@lst.de>
 <20251110132335.409466-16-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110132335.409466-16-hch@lst.de>

On Mon, Nov 10, 2025 at 02:23:07PM +0100, Christoph Hellwig wrote:
> Drop two redundant lock roundtrips by not requiring q_lock to be held on
> entry and return.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Much better!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/quotacheck_repair.c | 21 ++-------------------
>  1 file changed, 2 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
> index 3013211fa6c1..51be8d8d261b 100644
> --- a/fs/xfs/scrub/quotacheck_repair.c
> +++ b/fs/xfs/scrub/quotacheck_repair.c
> @@ -52,13 +52,11 @@ xqcheck_commit_dquot(
>  	bool			dirty = false;
>  	int			error = 0;
>  
> -	/* Unlock the dquot just long enough to allocate a transaction. */
> -	mutex_unlock(&dq->q_qlock);
>  	error = xchk_trans_alloc(xqc->sc, 0);
> -	mutex_lock(&dq->q_qlock);
>  	if (error)
>  		return error;
>  
> +	mutex_lock(&dq->q_qlock);
>  	xfs_trans_dqjoin(xqc->sc->tp, dq);
>  
>  	if (xchk_iscan_aborted(&xqc->iscan)) {
> @@ -115,23 +113,12 @@ xqcheck_commit_dquot(
>  	if (dq->q_id)
>  		xfs_qm_adjust_dqtimers(dq);
>  	xfs_trans_log_dquot(xqc->sc->tp, dq);
> -
> -	/*
> -	 * Transaction commit unlocks the dquot, so we must re-lock it so that
> -	 * the caller can put the reference (which apparently requires a locked
> -	 * dquot).
> -	 */
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
> @@ -155,9 +142,7 @@ xqcheck_commit_dqtype(
>  	 */
>  	xchk_dqiter_init(&cursor, sc, dqtype);
>  	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
> -		mutex_lock(&dq->q_qlock);
>  		error = xqcheck_commit_dquot(xqc, dqtype, dq);
> -		mutex_unlock(&dq->q_qlock);
>  		xfs_qm_dqrele(dq);
>  		if (error)
>  			break;
> @@ -188,9 +173,7 @@ xqcheck_commit_dqtype(
>  		if (error)
>  			return error;
>  
> -		mutex_lock(&dq->q_qlock);
>  		error = xqcheck_commit_dquot(xqc, dqtype, dq);
> -		mutex_unlock(&dq->q_qlock);
>  		xfs_qm_dqrele(dq);
>  		if (error)
>  			return error;
> -- 
> 2.47.3
> 
> 
