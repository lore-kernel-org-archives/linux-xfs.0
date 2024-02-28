Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A70A1361A0
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 22:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709158135; cv=none; b=Kxfa29SK5xpYVnWLXg/PsGrcjcMVMQqL8J43BG6fBqB97nBYOrl+pwVECuAW0ll4bci3Zhsq/csxI12kRu4fpG2+xdJlpfnHm5SCZ/DK3dJ62vN028Fs4IBY6UmmnIk97iZXK/nsr/J9IVnj6Lebyqt+XMz/xKrO4eSEgbI9h2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709158135; c=relaxed/simple;
	bh=zoxzB1kiqHA5GSTx4L/97gZe4jyiKxfrzn6nojLTqFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mO40VfgnaDS9UBCGBiEOXUTsBX2Gg8hLt5qSuVHTb4Ld6nx6C77ZqeXXYnENOED+y7rud7+y3gnJM+8XPyja9AH4SXvllQa3rewKNTg7ZEALZ392aRpLg7/4iRMtNtelmRPr6tKNiXNlSNS4JO+hGJGxDakwvgqwg9txWW5mu4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vqKJ9Slv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vqKJ9Slv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IF1E6cEBm3zlGUwhPNQSFPyFzlY7uziVbGAbgEv1F40=; b=vqKJ9SlvhqpdFO34TE/l9yU0K6
	l6blzaeYFH2Bv1/en0G5Veu/BGgeXACKHuWkF0LAyHOQRxtswzHqv5Kipl2ajUQ/CcoZLMx0wy8FS
	4INMzcOqYuNNkiVKguFBmD6srEXn6YiGs53irOrwjeRbKwEinBFPpom2QHAU+6rZ5EBcPGGf6b1+6
	PWeG5ohCJkflyBMO94diPEQ+xbJTszzJSgBXWKw5WOyWyvMmh8ftO06cQeHoXsLgxKnchHj3Ky+IY
	U29spcsMXfbWHegXuM0LsQW5t/4VKeIhBrD5kVit75w+nyJxHRhomcmPAMaY4h1F8GGPMRQYmJo2e
	/EYIfkBQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfS6d-0000000B5w5-3V6f;
	Wed, 28 Feb 2024 22:08:51 +0000
Date: Wed, 28 Feb 2024 14:08:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 05/14] xfs: create deferred log items for file mapping
 exchanges
Message-ID: <Zd-u89-cPQAxsCIG@infradead.org>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011723.938268.9127095506680684172.stgit@frogsfrogsfrogs>
 <Zd9V8VIoA6WpZUDM@infradead.org>
 <20240228195532.GR1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240228195532.GR1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Feb 28, 2024 at 11:55:32AM -0800, Darrick J. Wong wrote:
> static inline bool
> xmi_can_merge_all(
> 	const struct xfs_bmbt_irec	*l,
> 	const struct xfs_bmbt_irec	*m,
> 	const struct xfs_bmbt_irec	*r)
> {
> 	xfs_filblks_t			new_len;
> 
> 	new_len = l->br_blockcount + m->br_blockcount + r->br_blockcount;
> 	return new_len <= XFS_MAX_BMBT_EXTLEN;
> }

Dumb question:  can the addition overflow?
