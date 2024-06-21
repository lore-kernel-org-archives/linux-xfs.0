Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C6912C470;
	Fri, 21 Jun 2024 04:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944529; cv=none; b=XOoakjFRvIExtP9B3WDWdJW2Bo8rAEmw42a8OHIct8ZxPOYDTJ2uI18wvT7AvA6Mj84JMTVCeBmodR2PecbISoQSoaqedktsu4B18einTDVtHFT30hFfq16xNSihQwEacbmWuVSEe6N3+Ya4ZvF/NyWz+9nId6ceG70X6WuSLTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944529; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sxQVflaa9lnK/f5TdpABLf6yNzJHAGWdfXuKVF2po2RTcx4s+tVC9sX93daTkldV9K1oe78M9ioElmi/TGKMAYjGbxHUQtQ+9yVdXOOn3sjf3Ke+qAl8MKX9wdEgFHGKK4mw4UBMu0ic31p8PypKXEn+jBE8iVLKi9rvsUi1aUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OIXJ77zZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OIXJ77zZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=OIXJ77zZOBBCxCtxc63Z0dpEFY
	ZbwQ6/sPXyrShpwwPtlG5rsogd4oQ267JkjFNVnjm1QIsmemoJ7VfNJqSP/YGMqcxKHTzNrQfWoX1
	OxPn8MPMMvCbEhNipScrVW6mpDl1eUnAtES66f+TFxTuO9m68LbEkbizBBBfoMUqqMyWjBVvY20KZ
	zlKR7hAfwDJYHVhycRznEbMxJoVXtiHUOPnpLez0h7ViMPxmHynaxCEucGHXNPRT+S1MIMijg/NtG
	PYHopRoE3SdnT3Ee2vI0jsTDmhMuLlfvexcDri3xG0ScLXuBN9Nr+O3HR+nYa7x64YPMBM+dB2tty
	fDikcQGw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKVzh-00000007elR-3tzt;
	Fri, 21 Jun 2024 04:35:25 +0000
Date: Thu, 20 Jun 2024 21:35:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] generic/709,710: rework these for exchangerange
 vs. quota testing
Message-ID: <ZnUDDRmOmaK4_b2v@infradead.org>
References: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
 <171891669159.3034840.3701471459033486232.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171891669159.3034840.3701471459033486232.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
