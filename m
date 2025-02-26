Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E2B42A8F
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 16:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740588325; cv=none; b=qy9iSH3hqvmc4gHwTDnSmioi1IkxlJZYflWlkmlEGX/IwBB/DEyUz9OikgRmr7jfGRM3nk7UJonJFT0iH6J8mv+9ezZksFSWgeWl30JekRSlvVCc9VTGsqqyIhi/YRzvXukpu5ZCN3dRZRBxqeNap8F1ThyMf4WDTHO5fozgFX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740588325; c=relaxed/simple;
	bh=mEgqgX0asF+dhzv0L/ge2eQkPWBYreZZa5hPgfe2bbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iCbb/tm0EeiNI5T3JhT1kNkQmLbPgyPW4kHwRn2ulWxrpB+yeXfXyTlIe3Z4D2YiypKy8NGVksfkX8Xl6nGoOMXI5S7jQN3YY0P2WZtd5rej2TBzbCsi6Gh/H8l03DSA3WtVk5e+1FyxAQ17tR1Fg39gBI4Onb1l+FAifchmpyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R2zfmrAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R2zfmrAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2377CC4CED6;
	Wed, 26 Feb 2025 16:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740588325;
	bh=mEgqgX0asF+dhzv0L/ge2eQkPWBYreZZa5hPgfe2bbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R2zfmrAvXMSELM8Yvw+z+RPQYofXeqCW9eQhUOvh1jp3bmc7z9VUq4P01E7L3Fuz8
	 VHTEjX42vcPYobSi9tDBCoAhrKqbcC3IiASNqg3d2SD8X+WrgNfkOaihg7l4lpVlgK
	 pQHuOOCJFPWDFhlfgY3ozT9Miuq6h7YCQbFE/eWLkHELUfnkha8ojt7syotlw0O009
	 dYEA9B1CqpLXsnNyv2v9wpv+3QM+Tadn6Rvfeojn8qAM9La6xtLSZLitO1H2q72R3d
	 +o+nmHGG47XVayZLvneFTiUdbuwB3mEaZtzgdsLlkAB5wKoTqlIYturvTVvuecKKb9
	 2h5P6E/tOkf2A==
Date: Wed, 26 Feb 2025 08:45:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: trace what memory backs a buffer
Message-ID: <20250226164524.GL6242@frogsfrogsfrogs>
References: <20250226155245.513494-1-hch@lst.de>
 <20250226155245.513494-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226155245.513494-13-hch@lst.de>

On Wed, Feb 26, 2025 at 07:51:40AM -0800, Christoph Hellwig wrote:
> Add three trace points for the different backing memory allocators for
> buffers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c   | 4 ++++
>  fs/xfs/xfs_trace.h | 4 ++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 0393dd302cf6..a396b628e9b0 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -299,6 +299,7 @@ xfs_buf_alloc_kmem(
>  		return -ENOMEM;
>  	}
>  	bp->b_flags |= _XBF_KMEM;
> +	trace_xfs_buf_backing_kmem(bp, _RET_IP_);
>  	return 0;
>  }
>  
> @@ -379,9 +380,11 @@ xfs_buf_alloc_backing_mem(
>  	if (!folio) {
>  		if (size <= PAGE_SIZE)
>  			return -ENOMEM;
> +		trace_xfs_buf_backing_fallback(bp, _RET_IP_);
>  		goto fallback;
>  	}
>  	bp->b_addr = folio_address(folio);
> +	trace_xfs_buf_backing_folio(bp, _RET_IP_);
>  	return 0;
>  
>  fallback:
> @@ -395,6 +398,7 @@ xfs_buf_alloc_backing_mem(
>  		memalloc_retry_wait(gfp_mask);
>  	}
>  
> +	trace_xfs_buf_backing_vmalloc(bp, _RET_IP_);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index b29462363b81..c8f64daf6d75 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -545,6 +545,10 @@ DEFINE_BUF_EVENT(xfs_buf_iodone_async);
>  DEFINE_BUF_EVENT(xfs_buf_error_relse);
>  DEFINE_BUF_EVENT(xfs_buf_drain_buftarg);
>  DEFINE_BUF_EVENT(xfs_trans_read_buf_shut);
> +DEFINE_BUF_EVENT(xfs_buf_backing_folio);
> +DEFINE_BUF_EVENT(xfs_buf_backing_kmem);
> +DEFINE_BUF_EVENT(xfs_buf_backing_vmalloc);
> +DEFINE_BUF_EVENT(xfs_buf_backing_fallback);
>  
>  /* not really buffer traces, but the buf provides useful information */
>  DEFINE_BUF_EVENT(xfs_btree_corrupt);
> -- 
> 2.45.2
> 
> 
