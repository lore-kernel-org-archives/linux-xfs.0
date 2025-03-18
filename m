Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26BD1714B2
	for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 12:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742301337; cv=none; b=tH7/H2I/Rpu71eU5l+UbgB66bRKdfse/YSiKhXsWcQ3/BwEvDbzVjEDgapmEn5nQ/xcbTKFjHqDd+g4Aunz9RqXjOdvuieLFUgQFBOLPvpHZzYe3RmQMbjheBj3NQWplZYaArbxtNZ8RuFhgkBn3HZlbg/B4fAFBv3c3seXskuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742301337; c=relaxed/simple;
	bh=VOBHZRXAMUS9vPG0GnRq3vnjG4v1BCm47yUcqxj3Mkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C51nF0B7KUt493nGvc6gMHmeR31Zgx+B5Et+uw8BiOnUKl+BF2MHhIq0pIxzVGWKYjFW75DA72fY7qSpuNWmXqimB0UXaylMAIn3rM147DyzuZS+o0PeYhQuqWiq3bESlZAqihBCjCluQsWWYNhbd5KDHgOqE5XCwVivp9gzaBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LmeokaWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LmeokaWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BE0C4CEDD;
	Tue, 18 Mar 2025 12:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742301337;
	bh=VOBHZRXAMUS9vPG0GnRq3vnjG4v1BCm47yUcqxj3Mkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LmeokaWZZRq5/1zHiZpxyCdx5C7v9kv+sAGZBLTQruvoP87f1TgmWD8yEy/SQRST+
	 m8wlMEswDo5vWYKVx+Q+9G2QTIupzS7qCiS/w5EegTJeHUfxYTYU/XvKqMu2D1ar4w
	 IISxLKA+NVhSzJJ8Ks9H0u1/yWhP9RraqpsCUxrmPNTN/6v+F5vrMEJ5CI+Fc37z6Z
	 C0XoGEO5sR+K3xOw4GckIbZENoXkdyggBtImTWlpEwPoTPmkNQAg2rU5EvoE1SYlfr
	 OSsmC0KRns7MWZ7HDRF8/9mbs2GcFcQ3GmfLX58/rq1vRirZCI00I0PZW8yyNP6BWl
	 9ETNL9b+qowvA==
Date: Tue, 18 Mar 2025 13:35:30 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: remove xfs_buf_get_maps
Message-ID: <xcfsjlchyq2vfkv2gk3j6ffyt5qabvcvgmlvjbfylqq7i6i3rb@qpbxhwu3ln7p>
References: <20250317054850.1132557-1-hch@lst.de>
 <_XGsnSufWG5xHe0cPbCKHzAXXDddCBcfdhwMM9IWQU57sQexLIO_5BAvmyvDXUAuC-dHtT1fSR57fdU2xzapgQ==@protonmail.internalid>
 <20250317054850.1132557-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317054850.1132557-3-hch@lst.de>

On Mon, Mar 17, 2025 at 06:48:33AM +0100, Christoph Hellwig wrote:
> xfs_buf_get_maps has a single caller, and can just be open coded there.
> When doing that, stop handling the allocation failure as we always pass
> __GFP_NOFAIL to the slab allocator, and use the proper kcalloc helper for
> array allocations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 33 ++++++---------------------------
>  1 file changed, 6 insertions(+), 27 deletions(-)
> 


Looks good.
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f42f6e47f783..878dc0f108d1 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -88,26 +88,6 @@ xfs_buf_stale(
>  	spin_unlock(&bp->b_lock);
>  }
> 
> -static int
> -xfs_buf_get_maps(
> -	struct xfs_buf		*bp,
> -	int			map_count)
> -{
> -	ASSERT(bp->b_maps == NULL);
> -	bp->b_map_count = map_count;
> -
> -	if (map_count == 1) {
> -		bp->b_maps = &bp->__b_map;
> -		return 0;
> -	}
> -
> -	bp->b_maps = kzalloc(map_count * sizeof(struct xfs_buf_map),
> -			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
> -	if (!bp->b_maps)
> -		return -ENOMEM;
> -	return 0;
> -}
> -
>  static void
>  xfs_buf_free_maps(
>  	struct xfs_buf	*bp)
> @@ -317,15 +297,14 @@ xfs_buf_alloc(
>  	bp->b_target = target;
>  	bp->b_mount = target->bt_mount;
>  	bp->b_flags = flags;
> -
> -	error = xfs_buf_get_maps(bp, nmaps);
> -	if (error)  {
> -		kmem_cache_free(xfs_buf_cache, bp);
> -		return error;
> -	}
> -
>  	bp->b_rhash_key = map[0].bm_bn;
>  	bp->b_length = 0;
> +	bp->b_map_count = nmaps;
> +	if (nmaps == 1)
> +		bp->b_maps = &bp->__b_map;
> +	else
> +		bp->b_maps = kcalloc(nmaps, sizeof(struct xfs_buf_map),
> +				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
>  	for (i = 0; i < nmaps; i++) {
>  		bp->b_maps[i].bm_bn = map[i].bm_bn;
>  		bp->b_maps[i].bm_len = map[i].bm_len;
> --
> 2.45.2
> 
