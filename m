Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E89F3D64
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 03:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718337037; cv=none; b=qp8Pz0MzEOQyY0T1PuKgRCHC2uUDolu1PVUHKBtZLod/1+vLBDq7cSAEuI4zTufdgvSI1+23PGByrOa4hBRt/FLz6rvyYXHfrvHEyj28/ZyeXtQ6HG780Ap8UXNEjA+95SbxVOUZuGZfyadyQbtTSeaG61+2ZnXhrw30h4i9LtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718337037; c=relaxed/simple;
	bh=MB+AvrTIDw/ryvQb2AFMgz+rIHBGst5mqRcNMa68v18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=euYAjY7ZJaXRFqbQKCuo0gBf74Q+wJFnqJ9iRtxnwLx728+nKM9yAVdiQBCUZT+e9IA+4dpxObGuPxjnlFJZ9Z3/uIPNQW37Cc5KJDjEueDfZaRGS7XzuqGXMjLLrbo5B0CNl8BJrqAoMlxxXoOgKpLKSKr7GIHgHqjXKKn0y5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dcR0rn5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dcR0rn5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3741C2BD10;
	Fri, 14 Jun 2024 03:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718337036;
	bh=MB+AvrTIDw/ryvQb2AFMgz+rIHBGst5mqRcNMa68v18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dcR0rn5WPuDY8cKp8cgrnRUPKGr6p2Th2Cr1u7pGmGdKrOYku8RrVWKvZEp/8yDP/
	 0BmlurOKaQtq+8pZ3LFjMVSazoEYYrAbW1JN6gGtVoebs+uIei6ha66dE8HY1FMgQg
	 jLu5seLO7sbCUsxk4zIjklwQYDljo2QxryappJjKx7kX/sBkB7B4EFawili5BeRr+D
	 L2kG+TgkkNJ7npBLmwRSQmmx7p1AGi52ECPF40Eh0dpNaeJOgCYd1SyM+cOJqb9mRZ
	 ySDAYNs5rkhBwmi80SgqsIV7VM/0jj75bZRo5KCDquUpFUEAGJJVntiHsJXpxATYIS
	 ov11IYBr6+zfg==
Date: Thu, 13 Jun 2024 20:50:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, cmaiolino@redhat.com
Subject: Re: [PATCH v2 1/4] mkfs.xfs: avoid potential overflowing expression
 in xfs_mkfs.c
Message-ID: <20240614035036.GB6125@frogsfrogsfrogs>
References: <20240613211933.1169581-1-bodonnel@redhat.com>
 <20240613211933.1169581-2-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613211933.1169581-2-bodonnel@redhat.com>

On Thu, Jun 13, 2024 at 04:09:15PM -0500, Bill O'Donnell wrote:
> Cast max_tx_bytes to uint64_t to avoid overflowing expression in
> calc_concurrency_logblocks().
> 
> Coverity-id: 1596603
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

(didn't hch rvb this earlier?)

--D

> ---
>  mkfs/xfs_mkfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index f4a9bf20..2f801dd4 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3678,7 +3678,7 @@ calc_concurrency_logblocks(
>  	 * without blocking for space.  Increase the figure by 50% so that
>  	 * background threads can also run.
>  	 */
> -	log_bytes = max_tx_bytes * 3 * cli->log_concurrency / 2;
> +	log_bytes = (uint64_t)max_tx_bytes * 3 * cli->log_concurrency / 2;
>  	new_logblocks = min(XFS_MAX_LOG_BYTES >> cfg->blocklog,
>  				log_bytes >> cfg->blocklog);
>  
> -- 
> 2.45.2
> 
> 
