Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4172652BD
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 16:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752681872; cv=none; b=j7rkS7U0OQi6oRsRy5jhzG5XbgI2iz8B/X4sUlOVlN0VFlVhDngH/QqQiTDjiDdMGtdvc0nsFfFSnpGpeUHpcSTYxooDz4UFSF8Hu9FC9tjRyLa8qAXMfPD/wzJYTBdIPi3dsg7MqzOoQl9VM4oS5m7rhpq08HCxs6xpyCHbEUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752681872; c=relaxed/simple;
	bh=wPq4alSryW9Qz/HyQ9XwauKR4tn/rmbNDCA+KdCJuGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FnCvSvm0P+eY/dAzXmrmxwsV3JNQ7EfZV0oOuoqYyWLExSeowH5uzDaiaaOu3qgkQNWCeJGJfsRJ9YR8jD9erUi0o8YNPg5gnQWyTIZIW6dilcCIwxNR2tVFUqx8OOuyX9lOdNfxFSIS8ea5SxGrmWoZhJVoULWBQmyHb3P4KP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P3dpayp8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P3dpayp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C4CC4CEE7;
	Wed, 16 Jul 2025 16:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752681872;
	bh=wPq4alSryW9Qz/HyQ9XwauKR4tn/rmbNDCA+KdCJuGI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P3dpayp8S7TBC2bGSSnDrWcCfHePrpcSVbRyWLnpdCP/4FxG/9q6k9KbB+Xm2JDpZ
	 woPRW32ESlO/0g+08RLCdii3rU8SHRoDRHtnapQ1JNV5BsqvqbHplt/OZBcFvKIL4O
	 0YJg6WaThMTFJgg8aTC1adlRI96G8FVt6H+qqulunE8/xquNK9ep/5bXXDTBWKgPNI
	 aFxk+ZjQeS5caPTVWSakHhzgyHBk52lpRjkH0YUI1W4DJk+tuMjpPueO43HboMBk0D
	 WAn/MYo0Dcpy8MZDnMX1kpvsv2+IF5bWqBu+Po8PptyaV4ZxGSwH7kb87n8vclIbhX
	 b6ygzBTPQ3slw==
Date: Wed, 16 Jul 2025 09:04:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: improve the xg_active_ref check in xfs_group_free
Message-ID: <20250716160431.GO2672049@frogsfrogsfrogs>
References: <20250716130322.2149165-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716130322.2149165-1-hch@lst.de>

On Wed, Jul 16, 2025 at 03:03:19PM +0200, Christoph Hellwig wrote:
> Split up the XFS_IS_CORRUPT statement so that it immediately shows
> if the reference counter overflowed or underflowed.

Should we be using refcount_t for xg_active_ref to detect
over/underflows, then?

> I ran into this quite a bit when developing the zoned allocator, and had
> to reapply the patch for some work recently.  We might as well just apply
> it upstream given that freeing group is far removed from performance
> critical code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine though,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_group.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
> index 20ad7c309489..792f76d2e2a0 100644
> --- a/fs/xfs/libxfs/xfs_group.c
> +++ b/fs/xfs/libxfs/xfs_group.c
> @@ -172,7 +172,8 @@ xfs_group_free(
>  
>  	/* drop the mount's active reference */
>  	xfs_group_rele(xg);
> -	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_active_ref) != 0);
> +	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_active_ref) > 0);
> +	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_active_ref) < 0);
>  	kfree_rcu_mightsleep(xg);
>  }
>  
> -- 
> 2.47.2
> 
> 
