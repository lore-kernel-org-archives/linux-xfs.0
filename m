Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BD443CEC2;
	Tue, 10 Mar 2026 09:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773134079; cv=none; b=RtMCpymxud1bI9yoblJmDs3Iu0gikiwZh/1RROuy9s/hSWMDorxE6GPZcJEdODO1MWY+51mJzUvWnGijozz/fEsGZCnx98gVlZhqznX61b8XMLOb51kj/UD93/yU1K59IO50n/3nwlt9qcs0pwHJRrBLfzXi9SZpFW6Dd1rEo3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773134079; c=relaxed/simple;
	bh=+PKQSpfrj5dAClmLIdJ8EDHg7wrNyg/a+y3cXENbXuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EoaqzrBJddkHodIHPdOXtX0ykUzh6pVeNpk1t4eJtcgdgbpqMDj+kSAQg+0j+zMOgg/rl+jrA1afHa0Nazvro6VFDj/mMEmaPfwvr93E7+ShLAVsb0QzDvtBiA738Es1rUtzAHnkFWngMXs/rSimuJIdYvKm5GUrJJfQU0W2SMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9CFF868C4E; Tue, 10 Mar 2026 10:14:34 +0100 (CET)
Date: Tue, 10 Mar 2026 10:14:33 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v4 10/25] iomap: teach iomap to handle fsverity holes
 and verify data holes
Message-ID: <20260310091433.GB18959@lst.de>
References: <20260309192355.176980-1-aalbersh@kernel.org> <20260309192355.176980-11-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309192355.176980-11-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 09, 2026 at 08:23:25PM +0100, Andrey Albershteyn wrote:
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

This makes the ctx->vi rules really weird, as it;s only set for
the file data initially, but can later get set here for reading the
fsverity data.  I think it might be better to just always set it in
the higher level code if fsveirty is active, and then document how
our rules subtly differ from ext4/f2fs.

