Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC7B3203B9
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 18:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762798449; cv=none; b=tnZC3jxfeymF7pMXp1TYsuPbQXg4PlhB9BP5L6skRLVnaWNvI3mfmQD7ERQ2wRETN9mKDRwnYAu8TgbZzrAoLb75Xl1FOsINBCNS++MXIfupIddV29Y1MJs3PR0/isIX7uCg04FpFFxGEDZ0inTF7v/fYGKg5lz6pAi5UY78JZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762798449; c=relaxed/simple;
	bh=JUljyXdFU8qUxl9hQAgiI9pO0A7Ue6hwlpjXzDt/cfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nOGcnTgcOjqtPu8bBl1fn8g8YhRcDjiHjER4ZWIgpcBmFQfqN/5g9a5XnHvoyHsINwmU4KCH/46RL+guu2gKzA/GUoQj2TOjbHPxdHxgbBaDnt6Umg4R+FiW3NBkr7AREZz4DHJoWvYYuy4ktAtvlzxjTIbmUEdAxq0qAOmI5Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gpeMUqFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gpeMUqFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD04C116D0;
	Mon, 10 Nov 2025 18:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762798448;
	bh=JUljyXdFU8qUxl9hQAgiI9pO0A7Ue6hwlpjXzDt/cfo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gpeMUqFsg0MaiQVX2Eq0ATFk5j/SVERYeO01RcUH9iYZwn+PJjNWYXqp/SajEC1Hf
	 UmeSe2tWYkXrFI1FITfc7IIhC20GagT1AqYvvJWqVrwyHcsudc21anJ/20iVC8o3ia
	 B0YLfxGGHJ80YpyOlPwBrxwvIbzbmmfTdcQKQorLuqYHEs3s+bmXsdIljEDoTUx/3N
	 EXd1xBukbhUiXYjdbm7U0pDnG5ELkc/gC6l3ubDEqAJ4D3Z9fsxfYsBuffZxMHLeXP
	 Pcc6Xv9oGSwenY38ptiJgwWwuuYDnqr6Pd/fFDzNb0md7dy+NvDQVRNI/YzwBDoD8i
	 o5nZo64JVRxOw==
Date: Mon, 10 Nov 2025 10:14:07 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/18] xfs: move quota locking into xrep_quota_item
Message-ID: <20251110181407.GV196370@frogsfrogsfrogs>
References: <20251110132335.409466-1-hch@lst.de>
 <20251110132335.409466-17-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110132335.409466-17-hch@lst.de>

On Mon, Nov 10, 2025 at 02:23:08PM +0100, Christoph Hellwig wrote:
> Drop two redundant lock roundtrips by not requiring q_lock to be held on
> entry and return.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Same here! :)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/quota_repair.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
> index dae4889bdc84..b1d661aa5f06 100644
> --- a/fs/xfs/scrub/quota_repair.c
> +++ b/fs/xfs/scrub/quota_repair.c
> @@ -184,17 +184,13 @@ xrep_quota_item(
>  	/*
>  	 * We might need to fix holes in the bmap record for the storage
>  	 * backing this dquot, so we need to lock the dquot and the quota file.
> -	 * dqiterate gave us a locked dquot, so drop the dquot lock to get the
> -	 * ILOCK_EXCL.
>  	 */
> -	mutex_unlock(&dq->q_qlock);
>  	xchk_ilock(sc, XFS_ILOCK_EXCL);
>  	mutex_lock(&dq->q_qlock);
> -
>  	error = xrep_quota_item_bmap(sc, dq, &dirty);
>  	xchk_iunlock(sc, XFS_ILOCK_EXCL);
>  	if (error)
> -		return error;
> +		goto out_unlock_dquot;
>  
>  	/* Check the limits. */
>  	if (dq->q_blk.softlimit > dq->q_blk.hardlimit) {
> @@ -246,7 +242,7 @@ xrep_quota_item(
>  	xrep_quota_item_timer(sc, &dq->q_rtb, &dirty);
>  
>  	if (!dirty)
> -		return 0;
> +		goto out_unlock_dquot;
>  
>  	trace_xrep_dquot_item(sc->mp, dq->q_type, dq->q_id);
>  
> @@ -257,8 +253,10 @@ xrep_quota_item(
>  		xfs_qm_adjust_dqtimers(dq);
>  	}
>  	xfs_trans_log_dquot(sc->tp, dq);
> -	error = xfs_trans_roll(&sc->tp);
> -	mutex_lock(&dq->q_qlock);
> +	return xfs_trans_roll(&sc->tp);
> +
> +out_unlock_dquot:
> +	mutex_unlock(&dq->q_qlock);
>  	return error;
>  }
>  
> @@ -512,9 +510,7 @@ xrep_quota_problems(
>  
>  	xchk_dqiter_init(&cursor, sc, dqtype);
>  	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
> -		mutex_lock(&dq->q_qlock);
>  		error = xrep_quota_item(&rqi, dq);
> -		mutex_unlock(&dq->q_qlock);
>  		xfs_qm_dqrele(dq);
>  		if (error)
>  			break;
> -- 
> 2.47.3
> 
> 
