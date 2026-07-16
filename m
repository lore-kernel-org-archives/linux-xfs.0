Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7083D9048;
	Thu, 16 Jul 2026 08:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784190271; cv=none; b=OGJNySze3vFRbhG1pXMHYL6O9IV5RuQYC+XaTZZSwDlo0iypm3BnbGpc5xTfxOB0AzPuz2WYgcW6HNDCn8Vh2icXw8K94Wca8P8FqGyJJ5xhqi4Inqznq1Tq7ND8RYIoaoB2kM2QF184uq/ii8WdLlOF8XMQbnO33aD/nydOJkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784190271; c=relaxed/simple;
	bh=xZhfIBtPPtuuuFCvnyWBR9kUG8ZRnrbdAiQP6va7zUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PFJjVurS0TEaDCt+y+Si+pYo9QixCTJ3akcrUeKtfWjXLPLlw9SRcjdEF/tp2x/7FXh3qOCG9Rn5DBjZ8twzN9KQfpdLC0O+HmE/zTx3FBAgm3fdOe5Z5dp/9dxUyM5hAXnkjXSFJ1Ps82G0yXgDxl7DDWZkgDS9XHP3in4TQEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 981176732A; Thu, 16 Jul 2026 10:24:21 +0200 (CEST)
Date: Thu, 16 Jul 2026 10:24:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: don't livelock in scrub on a circular
 unlinked list
Message-ID: <20260716082421.GH12330@lst.de>
References: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs> <178416797487.2008054.2580454314921003800.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178416797487.2008054.2580454314921003800.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 15, 2026 at 11:07:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM points out that online fsck can livelock if an unlinked inode list
> contains a loop.  Use a bitmap to detect cycles.

Didn't we recently have some AI generated patch for the same thing?

Either way, this does actually look reasonable.  But also complex
enough that I really want a test case that creates an image with
such a corruption to test this case before we merge the kernel code
as this is something that basically requires a maliciously crafted
image, and we trade new otherwise untested code for a theoretical
bug.

> +static int
> +xchk_iunlink_bucket(
> +	struct xfs_scrub	*sc,
> +	unsigned int		bucket,
> +	xfs_agino_t		agino)

Maybe add a comment what this function tests?

> +{
> +	struct xagino_bitmap	seen;
> +	struct xfs_inode	*ip;
> +	int			ret = 0;
> +
> +	xagino_bitmap_init(&seen);
> +
> +	while (agino != NULLAGINO) {
> +		unsigned int	len = 1;
> +
> +		if (agino % XFS_AGI_UNLINKED_BUCKETS != bucket) {
> +			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
> +			goto bad;
> +		}

Handle entries that should not be here, makes sense.

> +
> +		if (xagino_bitmap_test(&seen, agino, &len)) {
> +			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
> +			goto bad;
> +		}

Check that we don't have duplicates, makes sense.

> +		ip = xfs_iunlink_lookup(sc->sa.pag, agino);
> +		if (!ip) {
> +			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
> +			goto bad;
> +		}
> +
> +		if (!xfs_inode_on_unlinked_list(ip)) {
> +			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
> +			goto bad;
> +		}

The that that the inode actually is on the unlinked list, makes
sense.

>  	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
> -		xfs_agino_t	agino = be32_to_cpu(agi->agi_unlinked[i]);
> +		int		ret;
>  
> -		while (agino != NULLAGINO) {
> -			if (agino % XFS_AGI_UNLINKED_BUCKETS != i) {
> -				xchk_block_set_corrupt(sc, sc->sa.agi_bp);
> -				return;
> -			}

Ahh, and this is mostly existing code...

Maybe split the reactoring into a separate helper into a prep patch?

