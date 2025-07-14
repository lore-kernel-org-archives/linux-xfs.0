Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70E1C13B;
	Mon, 14 Jul 2025 05:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752472506; cv=none; b=RiIg5TnKD75RY6/Dmp178dGLNUpnOYdzjF3A6cgrSM6+1TsGswDZkjCNC95M5tu33EGz9etr5Ml/goAPfsRehpPSJ/pgbfZo2ZnCpAV5zIdkhNIqmzK8aRFvz2LayCsBgfr2gjCWz3cHrwyBbDMQyqG/8Xuqk8JNGF6dT36yMKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752472506; c=relaxed/simple;
	bh=mk34GIyH4yJUe9oiK58Yqndh2OPckjxtiftZuXychkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ov0xGcGNkpjosrCZwkPco3oYuVU69B25MCEO/taNlCMt3PMqRx1JH8WwRp5pTy1Mw6WVZHPzMW+4a9er5y77+6FznFQ+JXiC3hSchyRbZhM8o7ppbjtb1RkIvEANyiInwAOwjeph3YDKP9nY+yUx1VONNDbyv4Vg5t9e+GoLjMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WRqQL6V4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WRqQL6V4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mk34GIyH4yJUe9oiK58Yqndh2OPckjxtiftZuXychkw=; b=WRqQL6V4ApLOIlDwNX9kvQNOL4
	yEiafI9yz9BPOscGrZeLFab5IjIuLxYdldTCsPTUrZthMO9M97CJnuj708P50KZRBsvi8PJu/Hx/V
	42iI+3rR70iPXUTNYS2Ys+aasErd958mjz+Z1Q0Nody4CTosW+B3fJcnXO6HTkZnaK4lMCsKW2Q0p
	gxduMX9GaBtWuNXjOHKuQA5OB99qP4ci6UzuSGScYYyz248JlCxKa0aCn0ebA0CJ1lYoc30uKPMtX
	dvAFLtqwwOvU/VPTGMCgDeFRPjzKNgNJsH1RIz4ASrUjvgZnTd/KBs6BfVZyKrZwE/AbJ6HDGLZsC
	EUK/Vmng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubC9V-00000001Frn-0OIv;
	Mon, 14 Jul 2025 05:55:01 +0000
Date: Sun, 13 Jul 2025 22:55:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: George Hu <integral@archlinux.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: replace min & max with clamp() in
 xfs_max_open_zones()
Message-ID: <aHSbtRNhuU9p1NEt@infradead.org>
References: <20250712145741.41433-1-integral@archlinux.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250712145741.41433-1-integral@archlinux.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Jul 12, 2025 at 10:57:41PM +0800, George Hu wrote:
> Refactor the xfs_max_open_zones() function by replacing the usage
> of min() and max() macro with clamp() to simplify the code and
> improve readability.

Nit: you can use up to 73 characters in each commit message line:

Refactor the xfs_max_open_zones() function by replacing the usage of
min() and max() macro with clamp() to simplify the code and improve
readability.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

