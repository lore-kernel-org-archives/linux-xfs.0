Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93833624C5
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 05:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790229139; cv=none; b=kZavmgSkuVAbixvieMUnswyeKtzqxDaYy8NuoB4GYeNsOvDgemck9DmrQ5HiDm8GjuisfykEV6gP69Y0h15o2MYQj0eJfehanzwdNtTosWJZcBndinvNY47aNgjHdtZPzOLsa1c3AWDtToL9k3pzUJC7J6fYkuS8xcukKj9ADwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790229139; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SAhWt2PTnbY21k43DPILePskoX5V/a/LPgcfKlyJcPBWEgO4hPOytGy6HSWoACxzdkUDuMLT2LbKkAb9Sp4eIlIO9UGEybP4uGVE8D8gYgIrR/0HvnB6clXA2Y5SvfMVYBGWpCjhXVUbUCRF+GMsV8kzYzkjDDV7PYG8JTNZJII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iZVACBcz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iZVACBcz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=iZVACBczWziX5wCKB6k/OtSKWO
	h/mHWPOClxl9CaSqBgVzOvg7jqfaJd4s6cgS5xTFklEGDWdw8pLGhhv0X/efYowq0SWpCbNq2BmsF
	k/5lDIzvMGrAf6NsqY6CS8MLNuZ/bSET/cCPSmPinm+/IxyXXIx5OgpwNWTKkoe0a0psrUlo4XgGS
	jBF+MBUauIoC8MaXLwZeExXFzJskL4BbXGi8oxa0q7JuzmwCNSPmKb8pLbh+BIaTlIdwu7YbAj3Sl
	Wgf6PevAf4J8298srriCekdxM5/qsNXEXz6gtyOeeJkMAIDviGN58afW66hkqDqg5xVvfNt294NCk
	0fgyLK0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9cNU-0000000A5jD-432R;
	Thu, 24 Sep 2026 05:52:16 +0000
Date: Wed, 23 Sep 2026 22:52:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: improve dir block reporting when
 cross-referencing dirents to pptrs
Message-ID: <arS6kDi44mTWSwwb@infradead.org>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
 <179014159735.1875436.16869787251613648986.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179014159735.1875436.16869787251613648986.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

