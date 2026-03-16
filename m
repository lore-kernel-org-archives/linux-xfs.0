Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5605135B64F
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 22:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773699613; cv=none; b=FRnl9Ox3duO/6DIFMh8SRmR4UnffNYur3nEosB+nOphZuUxLHErGxVzDbgClnITL+K9Gc6GIaLrWaOYoHBFc9tuxEvWuT4Fi/XgOfwtCPPaFtlGurcBJBRUG62OpUBOTw2/Cj3Cyvy/YvGzpf8F6gPI8QFmtx1nyrwj//QwtEjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773699613; c=relaxed/simple;
	bh=kSk66LmXFCboN0OqXLOaJTOUuYhyztSyoRzXjeilz2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DHoyX/+oQQs831wdNcjVkFulPXe2evISp3lgSQSLmLTJYR4QMxK7hwZgqiXHpg4Mvp4AUD19XVUoL1UmokVFXKVXydpYmRo1ELFxDH3kLUQqMlKbYC46MLRqDgZns6tht+Ru96hi5WclYjxUVvtPESBjTZbMoPqa+MOFB3Msyh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p6pw6TCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p6pw6TCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8E6C19421;
	Mon, 16 Mar 2026 22:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773699612;
	bh=kSk66LmXFCboN0OqXLOaJTOUuYhyztSyoRzXjeilz2g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p6pw6TCq4pF9qj5qKD8gHoTBFUZHsXSoHXMz+wUDnvMQX3bpPFTiAjetZ7eLPuvOw
	 iiDV9lQkii1sRH/ez+leEkS7l0oNYS0wm+0PiMRBsIGCYXsKLAiVViTi9aLaakGBRD
	 L3zeBUHwivL3qrbJ5uyDBXh1CN+yTBikodfHeF49BqUdkOYwdauqmEg1laCF6uk0h6
	 EIMgqEdANcSX6ASgCCmOdQk/Rkbdyk5jaO7C6ovCEMLJdHIvbpBlIju3rvGL+jxrjj
	 NKCVCR4HADX3Nr+R8HHQzRRgpzTAILuG0k7cdV5x+4a1i8nyEJysWPf0hK54VSCEMw
	 1Cun7u0kRmoow==
Date: Mon, 16 Mar 2026 15:20:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: don't decrement the buffer LRU count for in-use
 buffers
Message-ID: <20260316222012.GA1770774@frogsfrogsfrogs>
References: <20260316154216.1598410-1-hch@lst.de>
 <20260316154216.1598410-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316154216.1598410-4-hch@lst.de>

On Mon, Mar 16, 2026 at 04:41:35PM +0100, Christoph Hellwig wrote:
> XFS buffers are added to the LRU when they are unused, but are only
> removed from the LRU lazily when the LRU list scan finds a used buffer.
> So far this only happen when the LRU counter hits 0, which is suboptimal
> as buffers that were added to the LRU, but are in use again still consume
> LRU scanning resources and are aged while actually in use.
> 
> Fix this by checking for in-use buffers and removing the from the LRU
> before decrementing the LRU counter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

That makes sense to me -- if someone holds the buffer, it's clearly not
cold and dead enough to get kicked out.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index c0a4d0a37f57..8ba9b74339a7 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1523,6 +1523,18 @@ xfs_buftarg_isolate(
>  	if (!spin_trylock(&bp->b_lockref.lock))
>  		return LRU_SKIP;
>  
> +	/*
> +	 * If the buffer is in use, remove it from the LRU for now.  We can't
> +	 * free it while someone is using it, and we should also not count
> +	 * eviction passed for it, just as if it hadn't been added to the LRU
> +	 * yet.
> +	 */
> +	if (bp->b_lockref.count > 0) {
> +		list_lru_isolate(lru, &bp->b_lru);
> +		spin_unlock(&bp->b_lockref.lock);
> +		return LRU_REMOVED;
> +	}
> +
>  	/*
>  	 * Decrement the b_lru_ref count unless the value is already
>  	 * zero. If the value is already zero, we need to reclaim the
> @@ -1533,16 +1545,6 @@ xfs_buftarg_isolate(
>  		return LRU_ROTATE;
>  	}
>  	
> -	/*
> -	 * If the buffer is in use, remove it from the LRU for now as we can't
> -	 * free it.  It will be freed when the last reference drops.
> -	 */
> -	if (bp->b_lockref.count > 0) {
> -		list_lru_isolate(lru, &bp->b_lru);
> -		spin_unlock(&bp->b_lockref.lock);
> -		return LRU_REMOVED;
> -	}
> -
>  	lockref_mark_dead(&bp->b_lockref);
>  	list_lru_isolate_move(lru, item, dispose);
>  	spin_unlock(&bp->b_lockref.lock);
> -- 
> 2.47.3
> 
> 
