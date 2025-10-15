Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EEB2475CB
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 21:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760563189; cv=none; b=Wos6Gi+55DW4GZisNTfsj4yA56PpPmdfxCgLk8cXqtLbY3vEOX1fLBqRNQjF8fuUBTn4xAIS/Wsvlh26Gy8TROIVXRd1OS48xsnN5wm0ptJhS+9Z0Wxm6rRgPGeUueVSwZbpIlZ076draH2kzoxD6lhgZvlNnsScMwR5cNURrFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760563189; c=relaxed/simple;
	bh=BEuFrz+fBiIyAK5yng3CPShbWEMAdaSc/bpzWOiBo4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dI5G9WKO5piJVQ7lag0SuUIogEXN/TT24NsX4ot3//2YZ1utiJGbulbelEtqLC0EzcFxn4mPTU3U0PNlbjBYKsiUkrbJB3EYoeFY5S/e18Kba/+cxA6ur1aQeU6T6notrOfPEhgc7Rr9NpVk+hA99/UZ9lbx7ToGq/Q7A05R/vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u+eG7Gd6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u+eG7Gd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362F9C4CEF8;
	Wed, 15 Oct 2025 21:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760563189;
	bh=BEuFrz+fBiIyAK5yng3CPShbWEMAdaSc/bpzWOiBo4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u+eG7Gd60M9W+Q2VGWmpyYDavHonaST31EZVNr4Ov4GFezkB4C6lYRiiLFwKJrvIo
	 VFxVDrXGr9CSKPrzwx6p1ESMdXRt4u65H4nzJNknN2rDD31Uwg3onFjbiSp3LLDxzg
	 jQQH1HvazVrWZLGRY+GT+gedRnhbG7FI7TxBQ1eOmfRa6icDrMeYG1+fKsanY1NnY0
	 +jEAQv7/2B3d8gi1GNFxMGcqtSDOwl8T029tY/KQXI8NNHcW6Kf7UIMgl8+D7peTOm
	 ERs76WpciV5kACRKgqSeolcEx4yMjWWmkEk3w2EQpb+E03JA/0QY/YlmKBp6z+Ki0z
	 WPZmwz2FJfgcQ==
Date: Wed, 15 Oct 2025 14:19:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/17] xfs: move q_qlock locking into xchk_quota_item
Message-ID: <20251015211948.GI2591640@frogsfrogsfrogs>
References: <20251013024851.4110053-1-hch@lst.de>
 <20251013024851.4110053-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024851.4110053-14-hch@lst.de>

On Mon, Oct 13, 2025 at 11:48:14AM +0900, Christoph Hellwig wrote:
> This avoids a pointless roundtrip because ilock needs to be taken first.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yep!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/quota.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index b711d36c5ec9..5c5374c44c5a 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -155,10 +155,7 @@ xchk_quota_item(
>  	 * We want to validate the bmap record for the storage backing this
>  	 * dquot, so we need to lock the dquot and the quota file.  For quota
>  	 * operations, the locking order is first the ILOCK and then the dquot.
> -	 * However, dqiterate gave us a locked dquot, so drop the dquot lock to
> -	 * get the ILOCK.
>  	 */
> -	mutex_unlock(&dq->q_qlock);
>  	xchk_ilock(sc, XFS_ILOCK_SHARED);
>  	mutex_lock(&dq->q_qlock);
>  
> @@ -251,6 +248,7 @@ xchk_quota_item(
>  	xchk_quota_item_timer(sc, offset, &dq->q_rtb);
>  
>  out:
> +	mutex_unlock(&dq->q_qlock);
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		return -ECANCELED;
>  
> @@ -329,9 +327,7 @@ xchk_quota(
>  	/* Now look for things that the quota verifiers won't complain about. */
>  	xchk_dqiter_init(&cursor, sc, dqtype);
>  	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
> -		mutex_lock(&dq->q_qlock);
>  		error = xchk_quota_item(&sqi, dq);
> -		mutex_unlock(&dq->q_qlock);
>  		xfs_qm_dqrele(dq);
>  		if (error)
>  			break;
> -- 
> 2.47.3
> 
> 
