Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99012DF72
	for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 17:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758560481; cv=none; b=gFW0d81Q04gx59IR4a9g0l85ITjp3rYt0w+dHL1sY/hZLJDwza212gDCO+FcWlNJCddSFGqhJ71rwABOC0adszyvZXkXMDJ2s5BOCEShbAsdRaBjJv0CI5iCJv5HLcTyxVq9t+diqaodQoJzBi1cfYXvbedkA61C6Bi9P1wQku4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758560481; c=relaxed/simple;
	bh=DI2GrqX8DqqIQjHMw/w/yfI6HqZIKtgZbBMBBZCjdRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IwsDxFD5BPdQn6uC+FIJRdFNfyhnfKhPjken3vaRB1LeKyCyi/ppmtU8PEsCqpBbc8xMuCqLjsZHZRc4Eld73AiSVEfmHL1xtLkgSurZKML1l1/Ts0XKKy42Ebf/y4IRFAuZYqnbFFFkVZImoKYColudmQTemS7LbbfbCayzTIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z5gRCRC5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z5gRCRC5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=v1itXuo01svEGUzpBR/nrhhb81J8LWj8WUd686xhsrw=; b=z5gRCRC5XcCrB8jPtGSye7SsHC
	IrFmNBpXJ2o8//n8cK6XyY/xYj5YHEiZrkKJlrjEmRy2sGP8q3PcELwa5ZwA3Gt7EMA6PRw6dkoVw
	HQfQ56sFtUXcMtqOqiKaTWVSfmI8oEBya4cYDeLVURFePwPwmOJ6/iPFIBqk3xiBjBlXzqOUPYnfq
	uhR+kUcgFy2ROl5Ohv0s1mqH5pHWisWJ2dWvAuBA64iw11ie1an6Tb3LIWgaMQR2cRt+erjLn/2DI
	IVyydD2Yaln5LXvOOPjdKEPxICLuKNkxLFyJC3l+stNvvbJ4pUjuLid3ihuE04hRNmvzCY3T4VHB4
	PfPjx/7A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v0juf-0000000B32w-3OUw;
	Mon, 22 Sep 2025 17:01:17 +0000
Date: Mon, 22 Sep 2025 10:01:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	"A. Wilcox" <AWilcox@wilcox-tech.com>,
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs_scrub: fix strerror_r usage yet again
Message-ID: <aNGA3WV3vO5PXhOH@infradead.org>
References: <20250919161400.GO8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919161400.GO8096@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The autoconf maigc looks good (as good as autoconf can look anyway),
but why is this code using strerror_r to start with?  AFAIK on Linux
strerror is using thread local storage since the damn of time, so
just doing this as:

	fprintf(stream, _("%s."), strerror(error));

should be perfectly fine, while also simpler and more portable.

