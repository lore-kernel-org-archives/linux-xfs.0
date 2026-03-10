Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9EE2DC350;
	Tue, 10 Mar 2026 01:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773104703; cv=none; b=r0rR8N5emmXBY4uDmFKwTjfeW0Bqw1juASUjIaz3uk9pLb2kIpFmFkiCkJwSORSovyxW1Zr8BZK6wCpkvUOp6+RuF3RSQ6sVeA3oflkOBGd84FH/n7/4TgdtqRiLW8pbYrh3eN5OYM6SelHEt6Rv0SGkYudH3BZ4NFDwA6iiD6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773104703; c=relaxed/simple;
	bh=u6CMnuNY5RwqjHwe7VoD0sjIRo/Xi7apIs8nnxZUTlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dRox8yIVPt5ru4xhNIAfAdRYYIgqad1ZHIJfaPsOnIQqYpn9OmycAkivbWDvMB0JRKeP9x9yqucy9lEGBvMGSlNfLdMBA/6ccVZZIJb0ckvpQb3SC4E0FcBtkZOo/3ACaz6OPfPBvdP3/5M+XeJE5IVYCoQj2pPvgdQ0f3bRdEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kBzU40a2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kBzU40a2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE42C4CEF7;
	Tue, 10 Mar 2026 01:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104703;
	bh=u6CMnuNY5RwqjHwe7VoD0sjIRo/Xi7apIs8nnxZUTlM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kBzU40a2H1q3Hf1sSr4uUscCm4/RxwfXHxcwTveop3CP5QU5jPovQWgAuO4nBCqlS
	 jaOX/Ej0Oeyw1Dulq2AwhjmqDAUigZVGMwe1uzp8+HNZthbN0evXnzB0gDTHNfihhP
	 28ITyfcW//2l0A+a3kviKcUCklQc2sSiIrqCBPQJ27ykW6dLxT47jdMpTCm5buRCVo
	 Qne+Wln2pwpJ6qfXQy6CJ8A7xf1OM1rglOaSRxkbxnT6cQQPPmK3/GlAIExd9ff91W
	 PB+YhXDBgzOtziYJQdf72HPU/yoDUXFgjD6XdwDSyN4yNLYfqXhJ+IpdwccJz1QKsd
	 RlTARG4vrWgHg==
Date: Mon, 9 Mar 2026 18:05:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 10/25] iomap: teach iomap to handle fsverity holes and
 verify data holes
Message-ID: <20260310010502.GB1105363@frogsfrogsfrogs>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-11-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309192355.176980-11-aalbersh@kernel.org>

On Mon, Mar 09, 2026 at 08:23:25PM +0100, Andrey Albershteyn wrote:
> fsverity metadata has two kinds of holes - ones in merkle tree and one
> after fsverity descriptor.
> 
> Merkle tree holes are blocks full of hashes of zeroed data blocks. These
> are not stored on the disk but synthesized on the fly. This saves a bit
> of space for sparse files. Due to this iomap also need to lookup
> fsverity_info for folios with fsverity metadata. ->vi has a hash of the
> zeroed data block which will be used to fill the merkle tree block. This
> patch extends lookup of fsverity_info from just for file data but also
> for merkle tree holes.
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
>  fs/iomap/buffered-io.c | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 1d9481f00b41..31e39ab93a2e 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -542,9 +542,33 @@ static int iomap_read_folio_iter(struct iomap_iter *iter,
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
> +			/*
> +			 * Don't cause lookup if we already have fsverity
> +			 * context from the previous tree hole
> +			 */
> +			if (!ctx->vi)
> +				ctx->vi = fsverity_get_info(iter->inode);
> +			if (ctx->vi)

Is it an error if ctx->vi isn't set here?  We won't fill the folio
with the zerohash, but we'll set uptodate anyway...

> +				fsverity_folio_zero_hash(folio, poff, plen,
> +							 ctx->vi);
> +			iomap_set_range_uptodate(folio, poff, plen);

...though I suppose it's the case that the uninitialized folio contents
will most likely cause fsverity to report data corruption so at least
it's obvious.

OTOH it does seem a little strange to set uptodate having not
initialized the folio contents.

--D

> +		} else if (iomap_block_needs_zeroing(iter, pos)) {
> +			/* zero post-eof blocks as the page may be mapped */
>  			folio_zero_range(folio, poff, plen);
> +			if (ctx->vi &&
> +			    !fsverity_verify_blocks(ctx->vi, folio, plen, poff))
> +				return -EIO;
>  			iomap_set_range_uptodate(folio, poff, plen);
>  		} else {
>  			if (!*bytes_submitted)
> -- 
> 2.51.2
> 
> 
