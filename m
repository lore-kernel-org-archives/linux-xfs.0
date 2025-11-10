Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E2831E110
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 18:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762798406; cv=none; b=DSrT6bA7m2HxNPCsMOqeaS8gbdebLsYoW0crw757EacLJM7ldzpX7BhlFYvU827J6jvzcpVmjct3Z71g0h4tsQMuLe1rj0XzzUkWJ6lViaqWAPFvKsvpZVdK0kgyZAmQ/iM7pUaiLmFtALxgDOPKg8pBIHwRG7kDhccCFn+EfFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762798406; c=relaxed/simple;
	bh=npHRtzivJnghsMTrkWOxygXSuZADEbLtRMqTB2nEClc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=abRTUAiCsG/Jg+axjfolUPpxeBjs1KCeos76tQKs7Fix8p72ufVDDHxpp/9WmzvgY5zciI5LGwo3BzonM6n9J6KoHW3dT9Uwu8+siGqRNhEo+CB2bUUJ4kP0nxd1/3gjJ4HTCaQKqvoXX9a2bnOSNnNaxdgEjLtb7hMw6OTiG7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KYsrGJfE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KYsrGJfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF98AC4CEFB;
	Mon, 10 Nov 2025 18:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762798406;
	bh=npHRtzivJnghsMTrkWOxygXSuZADEbLtRMqTB2nEClc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KYsrGJfEw8IO91oJ6ubL8sjc1Uek25KRGuFt4tVXwCm4yvDZuBw3j3sCvPBXEPP/Y
	 OQBzXIhLs39jPdXyoNL56df+cc5TdgIVU81yD5ySD4zhJVpPcc0dO/JH2d6p6p8vxu
	 v67xH1Y3Iu8zUk11epbqy0AldNhPJwH8i/mOdPwjHXGj3Wfpy1qJGe7mgeFebKlU5d
	 IMn2GnOvy3GSX5hcyP9ZZIhuX41AG49WcxU/7BMSIc74h+k2qKO/pSp3Z5ZWTYL/Ky
	 udHik/Q6BbRCNvA6R6rek99IqocWHjvBVajIYoyEehC3oaJq3ZbJ65c4OBBf4rOKcW
	 RoaFsFWdGGvrQ==
Date: Mon, 10 Nov 2025 10:13:25 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/18] xfs: move q_qlock locking into
 xqcheck_compare_dquot
Message-ID: <20251110181325.GT196370@frogsfrogsfrogs>
References: <20251110132335.409466-1-hch@lst.de>
 <20251110132335.409466-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110132335.409466-15-hch@lst.de>

On Mon, Nov 10, 2025 at 02:23:06PM +0100, Christoph Hellwig wrote:
> Instead of having both callers do it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yeah, that makes sense now
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/quotacheck.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
> index 20220afd90f1..d412a8359784 100644
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
> @@ -589,7 +590,9 @@ xqcheck_compare_dquot(
>  		xchk_set_incomplete(xqc->sc);
>  		error = -ECANCELED;
>  	}
> +out_unlock:
>  	mutex_unlock(&xqc->lock);
> +	mutex_unlock(&dq->q_qlock);
>  	if (error)
>  		return error;
>  
> @@ -597,10 +600,6 @@ xqcheck_compare_dquot(
>  		return -ECANCELED;
>  
>  	return 0;
> -
> -out_unlock:
> -	mutex_unlock(&xqc->lock);
> -	return error;
>  }
>  
>  /*
> @@ -635,9 +634,7 @@ xqcheck_walk_observations(
>  		if (error)
>  			return error;
>  
> -		mutex_lock(&dq->q_qlock);
>  		error = xqcheck_compare_dquot(xqc, dqtype, dq);
> -		mutex_unlock(&dq->q_qlock);
>  		xfs_qm_dqrele(dq);
>  		if (error)
>  			return error;
> @@ -675,9 +672,7 @@ xqcheck_compare_dqtype(
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
