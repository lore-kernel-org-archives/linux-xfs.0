Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAE3308F34;
	Wed, 18 Feb 2026 06:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771396525; cv=none; b=A+gmykkZcQ+gvjHuJE0hyba51pPxVFNFx/WKpmWtyuRANsGntDS8iIENELg9n1lE/zOL9QEkNiGgI+79evfnR0QoF9sNUOClfhdR/93psRzuuQWm+YCe3FZD6Gt79gNkr4XhBYZ0Yc8NK0N0uCAfq52BpdpMDXVML7pq39l9/eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771396525; c=relaxed/simple;
	bh=M5Qog5hFYAZAY0vKnsCQGFRZoOyjAe9K/dBLlP1I3ho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R8huZ/mdQjsvQHmeiZ7NcZM7njndY6m60I8zWN4ovOVwgZ09AQyTlLXqmvHtFbVGwzxDorqs2KF/jm5MFzUOzgseX2H6DjM4kUld9kxR/eKm/CfJPtyOTJhoxULYia6B2p+nJwvELLbNX1eV65hs3GbGBqx2x2+tDCxxJGtihWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9706B68B05; Wed, 18 Feb 2026 07:35:21 +0100 (CET)
Date: Wed, 18 Feb 2026 07:35:21 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	djwong@kernel.org
Subject: Re: [PATCH v3 22/35] xfs: add iomap write/writeback and reading of
 Merkle tree pages
Message-ID: <20260218063521.GC8600@lst.de>
References: <20260217231937.1183679-1-aalbersh@kernel.org> <20260217231937.1183679-23-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217231937.1183679-23-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

> -	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, 0, XFS_WPC(wpc)->data_seq);
> +	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, iomap_flags, XFS_WPC(wpc)->data_seq);

Overly long line.

> +		if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION)) {
> +			wbc->range_start = fsverity_metadata_offset(VFS_I(ip));
> +			wbc->range_end = LLONG_MAX;
> +			wbc->nr_to_write = LONG_MAX;

Shouldn't this be taken care of by the caller?

> +			/*
> +			 * Set IOMAP_F_FSVERITY to skip initial EOF check
> +			 * The following iomap->flags would be set in
> +			 * xfs_map_blocks()
> +			 */
> +			wpc.ctx.iomap.flags |= IOMAP_F_FSVERITY;

I'm usually a fan of more comments rather than less, but I don't think
this adds any value.

