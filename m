Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78E43FD156;
	Wed, 25 Mar 2026 16:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774456185; cv=none; b=J0y8YE9UpSlcqpxSLzjapsoC2cT5lVjSKC4tN21BYPKFZnsebGbE5PIeQqvfpoUXqoK+fAYLNLGuXYuWNZbl3xKb2fc8Zzauf0PeGDekZrKsUO8iWLQ/f7OhZG/fmEeIvEAW6VLd/3QMewsLpshHlaIlJn8v3gGSffX4fJYkiIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774456185; c=relaxed/simple;
	bh=n2gRWPCdrqEgD1r99jloHoyKEK1RWoOWxovpSSliabY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EKfPd4xtop7CtlByaadqjzRQW/GEbOlgLXxDUZcGKDvVYkv70DDbgUDbH7En65Vuw4XhHmPVtm0qTu8NoqA5oWAgp62Yibw+Y5mOSa8yuT3J32tcBpMbgLY3czRDvMeJP7y0mbhP/qK7aQZLjG6qKn3iNbnnF9HwHjmGQ3Tiuak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jRW8E5mS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jRW8E5mS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C85EC19423;
	Wed, 25 Mar 2026 16:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774456184;
	bh=n2gRWPCdrqEgD1r99jloHoyKEK1RWoOWxovpSSliabY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jRW8E5mS6J4EcMYEQr+bOsYTBewNb/a/XEOSvoeUK+BcjkBUTALNKJvYAhH9m1hmy
	 y2XhkiI334saOIwU0QEv0tNnI9cee2HQUBLyTYa8zZhhmUSVRGG/4tVnfaKqhRsmsD
	 fn3YGiAg43LeBruHIB5MKoFIuWT4yeujFECdfvfurLFHCXrnq5YlzKQS0IRSGPg/iH
	 STDgmiMByFcawnk+ZHVvhuGfnrtmrqCpRLvHQpZu9HgnHnOD+rT+Xpnz7wSdw+Hgz0
	 QZneJz8p1vYSEVtLpAmhGUVAvZTX2t4OIdVi8f4a6X0tu3kXDGjsopMgyupkFe1iNw
	 9x+HPGlpHz32Q==
Date: Wed, 25 Mar 2026 09:29:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 10/25] iomap: teach iomap to handle fsverity holes and
 verify data holes
Message-ID: <20260325162943.GW6223@frogsfrogsfrogs>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
 <20260319170231.1455553-11-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319170231.1455553-11-aalbersh@kernel.org>

On Thu, Mar 19, 2026 at 06:01:57PM +0100, Andrey Albershteyn wrote:
> fsverity metadata has two kinds of holes - ones in merkle tree and one
> after fsverity descriptor.
> 
> Merkle tree holes are blocks full of hashes of zeroed data blocks. These
> are not stored on the disk but synthesized on the fly. This saves a bit
> of space for sparse files. Due to this iomap also need to lookup
> fsverity_info for folios with fsverity metadata. ->vi has a hash of the
> zeroed data block which will be used to fill the merkle tree block. This
> patch extends lookup of fsverity_info from just for file data but also
> for all fsverity metadata.
> 
> The hole past descriptor is interpreted as end of metadata region. As we
> don't have EOF here we use this hole as an indication that rest of the
> folio is empty. This patch marks rest of the folio beyond fsverity
> descriptor as uptodate.
> 
> For file data, fsverity needs to verify consistency of the whole file
> against the root hash, hashes of holes are included in the merkle tree.
> Verify them too.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/iomap/buffered-io.c | 40 ++++++++++++++++++++++++++++++++--------
>  1 file changed, 32 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index a11e54975df8..fce748dfb2cf 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -551,9 +551,27 @@ static int iomap_read_folio_iter(struct iomap_iter *iter,
>  		if (plen == 0)
>  			return 0;
>  
> -		/* zero post-eof blocks as the page may be mapped */
> -		if (iomap_block_needs_zeroing(iter, pos)) {
> +		/*
> +		 * Handling of fsverity "holes". We hit this for two case:
> +		 *   1. No need to go further, the hole after fsverity
> +		 *	descriptor is the end of the fsverity metadata.
> +		 *
> +		 *   2. This folio contains merkle tree blocks which need to be
> +		 *	synthesized. If we already have fsverity info (ctx->vi)
> +		 *	synthesize these blocks.
> +		 */
> +		if ((iomap->flags & IOMAP_F_FSVERITY) &&
> +		    iomap->type == IOMAP_HOLE) {
> +			if (ctx->vi)
> +				fsverity_folio_zero_hash(folio, poff, plen,
> +							 ctx->vi);

Let me nitpick one more time... should this ^^ function be named
fsverify_fill_zerohash, since it fills the folio with a repeating
pattern of the hash of a zeroed block?

(I'm nitpicking because zero is a noun and a verb)

Otherwise the logic looks fine to me, and like hch says this probably
ought to be rolled into patch 8.

--D

> +			iomap_set_range_uptodate(folio, poff, plen);
> +		} else if (iomap_block_needs_zeroing(iter, pos)) {
> +			/* zero post-eof blocks as the page may be mapped */
>  			folio_zero_range(folio, poff, plen);
> +			if (ctx->vi &&
> +			    !fsverity_verify_blocks(ctx->vi, folio, plen, poff))
> +				return -EIO;
>  			iomap_set_range_uptodate(folio, poff, plen);
>  		} else {
>  			if (!*bytes_submitted)
> @@ -600,9 +618,12 @@ void iomap_read_folio(const struct iomap_ops *ops,
>  
>  	trace_iomap_readpage(iter.inode, 1);
>  
> -	if (iter.pos < i_size_read(iter.inode))
> -		ctx->vi = fsverity_get_info(iter.inode);
> -	if (ctx->vi)
> +	/*
> +	 * Fetch fsverity_info for both data and fsverity metadata, as iomap
> +	 * needs zeroed hash for merkle tree block synthesis
> +	 */
> +	ctx->vi = fsverity_get_info(iter.inode);
> +	if (ctx->vi && iter.pos < i_size_read(iter.inode))
>  		fsverity_readahead(ctx->vi, folio->index,
>  				   folio_nr_pages(folio));
>  
> @@ -673,9 +694,12 @@ void iomap_readahead(const struct iomap_ops *ops,
>  
>  	trace_iomap_readahead(rac->mapping->host, readahead_count(rac));
>  
> -	if (iter.pos < i_size_read(iter.inode))
> -		ctx->vi = fsverity_get_info(iter.inode);
> -	if (ctx->vi)
> +	/*
> +	 * Fetch fsverity_info for both data and fsverity metadata, as iomap
> +	 * needs zeroed hash for merkle tree block synthesis
> +	 */
> +	ctx->vi = fsverity_get_info(iter.inode);
> +	if (ctx->vi && iter.pos < i_size_read(iter.inode))
>  		fsverity_readahead(ctx->vi, readahead_index(rac),
>  				readahead_count(rac));
>  
> -- 
> 2.51.2
> 
> 
