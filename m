Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE6E3BED6A
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 03:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785123615; cv=none; b=TI2xwMRWSgEipbJ6gw7LZAAaATNZRGEzr0NhxAWAsndxWmqKEMWwoGoGLchQYFEukAm6evxY7Qcju75al2VX74HWOohrGGWeBCgYAIQU8XQSWZDpQvLGsPCfFUPFzFZ8bkqh7ZzNkCaX5dQVr8KelSUE7vg6gMpCROTczcegbNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785123615; c=relaxed/simple;
	bh=OPSmh4U++LnK9+sLJOZsu1QNSciskZEvU2bwtECmKlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B8yJTh1ULqgmbdbOlkowGZzEzQvrD95oN7h+DOjvUNkLOUlt/1GfaoP6CPLm7QDzj9IzKJL3xlVvajuIVLFno85UXNRlcjAmV2pmczT0jzb1U+Tdx2sMUb7AWEr7TmLLEzOIbjquGPV5FOAQwpZQWkRJ+pWaA+QrZPSQ/cEp8HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l51W8NLu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l51W8NLu"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4826F1F000E9;
	Mon, 27 Jul 2026 03:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785123613;
	bh=3FMPD6ozZ+ema3Uuo+33aMc3957SdFOaNmvjeGK3RHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l51W8NLuJ4BsEevoXtRv1ekhRFZVcxglA9puPdilmwuHKJB/7xRClOqYSPhP1pS9N
	 8mYiadZd5yfRrOIPRLpjnbXpRt4A6UApFuoIOzoczvfE/I54YsSp24pYFuKaRZVCTe
	 HFfY5ovacY+3cZldv8Oj4HeWmg9bb3MpOYo8KzUCx4RVj51HaJZMMETSQxl4cEdCc5
	 AXaIsjKtIiKBb/dvYMOJKi9++t6LA0aSz94sYCci7TmFbc6tJwwRgovwWjJ2B9GAYr
	 yO5wBGV4ki7zT6bSoy0o1DsVMGsRJkdpV5l5ichK4DAFhxo1dVdUNH17ZPkrZWVxNs
	 zNjTjw1l8EoTg==
Date: Sun, 26 Jul 2026 20:40:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH 1/2] xfs: fix ilock leak on error in xfs_dq_get_next_id
Message-ID: <20260727034012.GB2901224@frogsfrogsfrogs>
References: <20260727023849.3247961-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727023849.3247961-1-leo.lilong@huawei.com>

On Mon, Jul 27, 2026 at 10:38:48AM +0800, Long Li wrote:
> xfs_dq_get_next_id() takes the quota inode ILOCK before calling
> xfs_iread_extents().  If xfs_iread_extents() fails, the function returns
> immediately without releasing the lock, leaking the quota inode ILOCK.
> This can leave the quota inode locked and cause subsequent quota
> operations to hang.
> 
> Fix this by jumping to a common unlock path on error instead of returning
> directly.
> 
> Fixes: bda250dbaf39f ("xfs: rewrite xfs_dq_get_next_id using xfs_iext_lookup_extent")
> Cc: <stable@vger.kernel.org> # v4.12
> Signed-off-by: Long Li <leo.lilong@huawei.com>

Yeah, that's a bug!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_dquot.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index c311f61d9554..b4f6c594808c 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -778,7 +778,7 @@ xfs_dq_get_next_id(
>  	lock_flags = xfs_ilock_data_map_shared(quotip);
>  	error = xfs_iread_extents(NULL, quotip, XFS_DATA_FORK);
>  	if (error)
> -		return error;
> +		goto out_unlock;
>  
>  	if (xfs_iext_lookup_extent(quotip, &quotip->i_df, start, &cur, &got)) {
>  		/* contiguous chunk, bump startoff for the id calculation */
> @@ -789,6 +789,7 @@ xfs_dq_get_next_id(
>  		error = -ENOENT;
>  	}
>  
> +out_unlock:
>  	xfs_iunlock(quotip, lock_flags);
>  
>  	return error;
> -- 
> 2.52.0
> 
> 
