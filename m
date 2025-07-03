Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE4C12B17C
	for <linux-xfs@vger.kernel.org>; Thu,  3 Jul 2025 13:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751550352; cv=none; b=LqYXtO7BHBU5LkFPWP6inFGCxaH6I35MB9iC1RBkJiElPDEKMauii8UmC7Tqq4oAgnREwslA2auLxrYC9eobTfXz15zX7it07Ha8C8Y+lHWa5yoGrnMD2TAa+bifoG1mk00r2XAyeOGVGOE9ZtLbsIkltIWiCZ2yyYpmA8BL4Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751550352; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cow9CdvUN68E0D2YGPVHsJY9B8riwOqcywSfJZL+nZKjthyS5z8Evh3FjwUF7dFXD1xlm1UZE2Fev+C5gIvRX9tbTP4D+lt8ZSiPo7ZVVYChxHl5Zywb5804vPGVtiMZh4WCRHna87pRwF3TKduNRikv1q+Lx3zALMUxeFiB+OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CEXynlc6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CEXynlc6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CEXynlc6Xi/TBXJp665tTgDlE5
	+FpL+7yRpJhEDVM04Uj2jzKP/oeNcbwZBPb40R3KciK8dmaEXRoHdDsQ44pBqmIsIHOcDWe5TEROw
	wSgYfm6ZV4QaUU7RNNixttrJ4naNGxu2rZWUdZBmly5XPdUmsIbvYuc8/rnwn3rI4pYwOL7J4whU1
	fmzt8ac42qBz1pspR3xTYczJHjGWBUAA94yCFWY/I9zUSUV47AHElFmU3rQQruP2PB6k0N02dtlxe
	Av5Y8HLn34tBKPekMd7ztafw5bqJWGePkooQbR8yUsVcPRok5e2v6zQaDc5sF20+R43w3E7e4r4YS
	EO1rI16g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uXKG6-0000000BXTW-16Fi;
	Thu, 03 Jul 2025 13:45:50 +0000
Date: Thu, 3 Jul 2025 06:45:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs_scrub: remove EXPERIMENTAL warnings
Message-ID: <aGaJjgYKd5M7UyDy@infradead.org>
References: <175139304129.916487.5190678533940893960.stgit@frogsfrogsfrogs>
 <175139304146.916487.764787367428200733.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175139304146.916487.764787367428200733.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

