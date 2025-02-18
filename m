Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93599475
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 20:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739910238; cv=none; b=lge0qbLvDmhGuBopEPEL3OJHg9Dyxg0Sug2pCnHDuNGFYbaVbezKCls1Cqp11/CBjlMqmV/QwW5DU++n2zNJSNAuDLzNtHdci+cVJpxJZG5vEDzIkv6iYvfHtefUAZ4qhsjnGn6SBbuvnXjRVEZFfuJJVXP42/HvbSabhqDoCMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739910238; c=relaxed/simple;
	bh=j9MzET98s7R8+JFIc0tcAUxhamo60VYziro75p2rQvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N61q+vFksNFI52prVRl05HEJNCHVWXGIIkmiUf2H0S7WZNvEZehLEhueBOVM8vTYKtVH34W5YxckC5OU8bTzzhUD4NKPp+lmyyjeXSNIxXDvncXqe/dqeoPnEqJUGDTrRHsJJzgQqWlEJ5rwyJufnNzNaeQKKGzLOF1tiATHfZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m5IF+HHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m5IF+HHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F91C4CEE2;
	Tue, 18 Feb 2025 20:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739910237;
	bh=j9MzET98s7R8+JFIc0tcAUxhamo60VYziro75p2rQvs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m5IF+HHqyCfc06pVU4Q/LodZxw5ZqJRgTrF86nwnx5GUkt0WIlhH71mYiLhssSlbi
	 rMywAThSealBl5jsaH7d79ReXeoMKG2zLgKS3N3rTQ/Pa/wDRrQLHmAO1Io43jkspt
	 aBXjrpR6FJ7QKyl4gnck7ektvumW6nNsa5Ujm4tlPTGwAj9PAJo+IhhsZ5omWFvwXq
	 KzQAK2KcuWzyELggQRBM+uZz7D+7sgdJyVsO4/aHKxzKHz4BYReQbBCSO4jzwYUnfj
	 /8c6iaaNFXwdzPoVfHaFSEBrYAmo45vVoiaqeex0g9QIIT0IyBpHJ4PbY/7KjciOCp
	 1k4sPu/NKNp+w==
Date: Tue, 18 Feb 2025 12:23:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: remove the XBF_STALE check from
 xfs_buf_rele_cached
Message-ID: <20250218202356.GJ21808@frogsfrogsfrogs>
References: <20250217093207.3769550-1-hch@lst.de>
 <20250217093207.3769550-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250217093207.3769550-5-hch@lst.de>

On Mon, Feb 17, 2025 at 10:31:29AM +0100, Christoph Hellwig wrote:
> xfs_buf_stale already set b_lru_ref to 0, and thus prevents the buffer
> from moving to the LRU.  Remove the duplicate check.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I'd long wondered why that was necessary...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f8efdee3c8b4..cf88b25fe3c5 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -99,12 +99,6 @@ xfs_buf_stale(
>  	 */
>  	bp->b_flags &= ~_XBF_DELWRI_Q;
>  
> -	/*
> -	 * Once the buffer is marked stale and unlocked, a subsequent lookup
> -	 * could reset b_flags. There is no guarantee that the buffer is
> -	 * unaccounted (released to LRU) before that occurs. Drop in-flight
> -	 * status now to preserve accounting consistency.
> -	 */
>  	spin_lock(&bp->b_lock);
>  	atomic_set(&bp->b_lru_ref, 0);
>  	if (!(bp->b_state & XFS_BSTATE_DISPOSE) &&
> @@ -1033,7 +1027,7 @@ xfs_buf_rele_cached(
>  	}
>  
>  	/* we are asked to drop the last reference */
> -	if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
> +	if (atomic_read(&bp->b_lru_ref)) {
>  		/*
>  		 * If the buffer is added to the LRU, keep the reference to the
>  		 * buffer for the LRU and clear the (now stale) dispose list
> -- 
> 2.45.2
> 
> 
