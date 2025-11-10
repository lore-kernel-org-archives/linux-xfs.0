Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E633625DAEA
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 18:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762797883; cv=none; b=KcE9eiw5zr/whHx/8vhUZhMjkUFqtJoIO//mdXxF7Qg+gFG8LOEb5ggMpvNlcVNGxm154jJ2C9o77xSZACFlsERkkdmLUKIAn8Ge9UcLHUemezT4mNDoqyjnBxXnIN61KSGvO3ymVAhuENzB2Ds9b4SULi61DqfDaw8HRzRqZDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762797883; c=relaxed/simple;
	bh=hayf5NbcrYKogZYKG85cdIoqYLm86rO5uHwD5gH7YjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uVtm4Umbl+W9Es3hr4TyKwE+kS8r3pHbLdMECe/21roIKCdYIQPWC7KJ8L07A5X5XFZK9CTPPm8Jz0BatYqW+708LHC/+pLJRt68MLT0tWey1KnTR+aiRTkXnOalEDxgeBOCtN8AY3GRkmgFFTeHuu8QX7QfKKhxA0FRRlmobGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tuD0fBDv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tuD0fBDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7529FC116B1;
	Mon, 10 Nov 2025 18:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762797882;
	bh=hayf5NbcrYKogZYKG85cdIoqYLm86rO5uHwD5gH7YjM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tuD0fBDvgHwnFMkjK3iytWhcowAlrzpX3Ujz6yhf4QS2K8lHfF8O7KWeCSlEsolU2
	 jjCw1rNRe+xV9PgqIiRbYWKjyL0kzGTTxObxDw/TJh/Y3yFzM3M0VRujPYhS9qJkoG
	 ATjJs0VTUNauvEm3zytYXX03ZwhnjP0OighbWFOAXgKi7dPUSxri5eIEc5n0cOjv92
	 RGElls71OytVv8k898xCTuNISxANFH0A4DUtoN2Chmxkexu02nCHY0OIfQgGOwjblk
	 F7umiMYhDRF0evi2uD818cGbQlYG/0PgcJ4YNC/qDyNonKu8SVrDdcX65/CyJCbwlf
	 EJePCAFarrKsA==
Date: Mon, 10 Nov 2025 10:04:41 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/18] xfs: don't treat all radix_tree_insert errors as
 -EEXIST
Message-ID: <20251110180441.GR196370@frogsfrogsfrogs>
References: <20251110132335.409466-1-hch@lst.de>
 <20251110132335.409466-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110132335.409466-4-hch@lst.de>

On Mon, Nov 10, 2025 at 02:22:55PM +0100, Christoph Hellwig wrote:
> Return other errors to the caller instead.  Note that there really
> shouldn't be any other errors because the entry is preallocated, but
> if there were, we'd better return them instead of retrying forever.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Good defensive strategy ;)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_dquot.c | 31 ++++++++++++++++++-------------
>  1 file changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 0bd8022e47b4..79e14ee1d7a0 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -860,7 +860,6 @@ xfs_qm_dqget_cache_insert(
>  	mutex_lock(&qi->qi_tree_lock);
>  	error = radix_tree_insert(tree, id, dqp);
>  	if (unlikely(error)) {
> -		/* Duplicate found!  Caller must try again. */
>  		trace_xfs_dqget_dup(dqp);
>  		goto out_unlock;
>  	}
> @@ -935,13 +934,16 @@ xfs_qm_dqget(
>  
>  	error = xfs_qm_dqget_cache_insert(mp, qi, tree, id, dqp);
>  	if (error) {
> -		/*
> -		 * Duplicate found. Just throw away the new dquot and start
> -		 * over.
> -		 */
>  		xfs_qm_dqdestroy(dqp);
> -		XFS_STATS_INC(mp, xs_qm_dquot_dups);
> -		goto restart;
> +		if (error == -EEXIST) {
> +			/*
> +			 * Duplicate found. Just throw away the new dquot and
> +			 * start over.
> +			 */
> +			XFS_STATS_INC(mp, xs_qm_dquot_dups);
> +			goto restart;
> +		}
> +		return error;
>  	}
>  
>  	trace_xfs_dqget_miss(dqp);
> @@ -1060,13 +1062,16 @@ xfs_qm_dqget_inode(
>  
>  	error = xfs_qm_dqget_cache_insert(mp, qi, tree, id, dqp);
>  	if (error) {
> -		/*
> -		 * Duplicate found. Just throw away the new dquot and start
> -		 * over.
> -		 */
>  		xfs_qm_dqdestroy(dqp);
> -		XFS_STATS_INC(mp, xs_qm_dquot_dups);
> -		goto restart;
> +		if (error == -EEXIST) {
> +			/*
> +			 * Duplicate found. Just throw away the new dquot and
> +			 * start over.
> +			 */
> +			XFS_STATS_INC(mp, xs_qm_dquot_dups);
> +			goto restart;
> +		}
> +		return error;
>  	}
>  
>  dqret:
> -- 
> 2.47.3
> 
> 
