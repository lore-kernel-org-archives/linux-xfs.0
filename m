Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268F713CF82;
	Thu, 10 Sep 2026 05:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789016692; cv=none; b=KJDRiT1VzUrkQNgWbMPvTsQWqvgdhc3cMAvpJP1WnplZoh/W8Grh6Vvoi0yflLENvsXJ7YsE2wEGweYU8A/FyhVu+ltaPhqqDEyKLFH6/0SxmYboT50EMRKnTFInALfjQ/ESZq8m6CW0vy5L/5gwxjnPyYLEk4xOv9xGpSxcwgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789016692; c=relaxed/simple;
	bh=DnnWU1GWOVwLcApWHiC5Dz3SQKRTecgSxWaNNFv7MDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ksaK3k4OTpA7dVBLBwiz9yYqRVIghbw6QPUaEcAms5mJRyDasr8tdb7071zkz9j1TBS7AoqvEWqltJQEzqWpr6sA1+LpPVq37TH91OdIKcxChhQY9tG3zi/Nwa5LKAgrtGFU67lUQzzMfz1zafeRYLZC4bvWU8I7mJfqt/Rbbfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3511968BFE; Thu, 10 Sep 2026 07:04:47 +0200 (CEST)
Date: Thu, 10 Sep 2026 07:04:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: advance the findparent inode scan cursor
 while holding ILOCK
Message-ID: <20260910050446.GG26687@lst.de>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs> <178892936771.4057962.16778990010632981835.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892936771.4057962.16778990010632981835.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +static inline bool
> +xrep_findparent_want_scan_file(
> +	const struct xrep_findparent_info	*fpi)
>  {
> -	struct xfs_scrub		*sc = fpi->sc;
> -	struct xfs_inode		*dp = fpi->dp;
> -	unsigned int			lock_mode;
> -	int				error = 0;
> +	const struct xfs_scrub			*sc = fpi->sc;
> +	const struct xfs_inode			*dp = fpi->dp;
> +
> +	/* Only directories can be parents */
> +	if (!S_ISDIR(VFS_IC(dp)->i_mode))
> +		return false;

Not very inclusive :)

The patch looks good:


Reviewed-by: Christoph Hellwig <hch@lst.de>
