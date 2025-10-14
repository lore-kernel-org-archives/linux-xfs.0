Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF6A1DB122
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 23:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760484253; cv=none; b=SO2q2B9Y9ro8FLsSjQ9Z0GRCD3lErcGWahIgvftxhbv0rDb79CMgJ2acUCZT8CFppZoObECXFIQIjTeWB6OIZJXZ4vZ5ekuGKkTaoVRcDyxINtNSNEx1FCqMtKbVcdNrngZ2VInrwn7LeUS4PSNuxWXOTxZXzvQ3aVzGXV3EzW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760484253; c=relaxed/simple;
	bh=5YPGIjEWbmg/f2QIueZDS/4hshrDVBvmjrIPS6QaLek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lq1ZnE8iM7H6ielFwJ4RzYsiwfXV76njkofQffSvToF9hYo79PznwLVaWEaMUmMqoavP+qTwQIBhLggyq9iLN6PHTcqu28+ir1Nml6QV4C/hUVyY8Myr1FUzDKFqILD3locWbKD7S+B7jNjz2tuDdMGrfdepALO7mXcFPLhlflM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZchqnqjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZchqnqjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B29BC4CEE7;
	Tue, 14 Oct 2025 23:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760484252;
	bh=5YPGIjEWbmg/f2QIueZDS/4hshrDVBvmjrIPS6QaLek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZchqnqjIKDN2IEstabpg2H04zjGhc3+9rR8Rr6V3vX38sb6NsDLjpRRRgwz37rzuu
	 cZJ+dKkfD4FyWScgz0OU8XcOGwB5OJH9ww3d+aw4pr/YD5ZMFPtxH5lFbxm9cnpwlF
	 CYdRVv7elAFYuj/lZdlTHUUaG9UEOWx3m/vi99N27/q5fD21O1UL+s1nrwpVQ9nWXn
	 oIFkWPQNCn2Kn/P7iWXiXOMT+JblapE2TgKtFvVub06iJRzGsC1PDoTquQ1c2KVbcq
	 /ind45skxqOk80PULhV/trRCrdy+gQC4MupgOAqtqxjjpGsxgBbkvQNUWgDXu4q59Z
	 VlclqKUdW/HJg==
Date: Tue, 14 Oct 2025 16:24:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/17] xfs: don't lock the dquot before return in
 xrep_quota_item
Message-ID: <20251014232411.GT6188@frogsfrogsfrogs>
References: <20251013024851.4110053-1-hch@lst.de>
 <20251013024851.4110053-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024851.4110053-5-hch@lst.de>

On Mon, Oct 13, 2025 at 11:48:05AM +0900, Christoph Hellwig wrote:
> While xfs_qm_dqput requires the dquot to be locked, the caller can use
> the more common xfs_qm_dqrele helper that takes care of locking the
> dquot instead.

Similar problem here -- there are other paths out of xrep_quota_item
that return with the dqlock held, and the new xfs_qm_dqrele will try to
re-take the lock and livelock.

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/quota_repair.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
> index 8c89c6cc2950..00a4d2e75797 100644
> --- a/fs/xfs/scrub/quota_repair.c
> +++ b/fs/xfs/scrub/quota_repair.c
> @@ -257,9 +257,7 @@ xrep_quota_item(
>  		xfs_qm_adjust_dqtimers(dq);
>  	}
>  	xfs_trans_log_dquot(sc->tp, dq);
> -	error = xfs_trans_roll(&sc->tp);
> -	mutex_lock(&dq->q_qlock);
> -	return error;
> +	return xfs_trans_roll(&sc->tp);
>  }
>  
>  /* Fix a quota timer so that we can pass the verifier. */
> @@ -513,7 +511,7 @@ xrep_quota_problems(
>  	xchk_dqiter_init(&cursor, sc, dqtype);
>  	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
>  		error = xrep_quota_item(&rqi, dq);
> -		xfs_qm_dqput(dq);
> +		xfs_qm_dqrele(dq);
>  		if (error)
>  			break;
>  	}
> -- 
> 2.47.3
> 
> 
