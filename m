Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9532B283FE5
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 13:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781615727; cv=none; b=LC+WBhFl2yQPXTVDlrZyhxVqOW5OJHW40lcjeGl1mIGtpmHvGPV1kQBUef5NdWLqHQvr/tLbSJfYYQ57IxDyF8au6tNqfuzaPzFOFTLLwpUGknX6bHzM0sTpv0LzMzdYmlk8czYH2hre3r80BoehwhiaaC0rBuJwll1aI6eS7lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781615727; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jux3zddsFjIKxmEaCRpTkvV7wS57sTsSSa9Gs9AwYvlP9yT2yMQukHuysVn+WsC2GTfAmxAobjx7wp8sgDPQHnOJvLP8muQAj8mSoPM3moSn5g1nC19b64/z9cIOHqyayM8lp+w1MDTgllh1osb3XmR2kUVH2o9v4FhqIZw1ybg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HE5qsywf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HE5qsywf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=HE5qsywfTRHXm7I9YV5PkwBgyr
	xDxM/yqhrde7NmN24Wk/bi4thcpz52dNqpT2TGnjaZyL5yViZiAnz8mheZMBXN4w6LZBlewj29Hb2
	jCCDSl2VaiGhMD9yDt0Xkfy/AaqjkoxJnZhKkTUCUt3XGrhNpYMpKwEQBDnOKHAETshtI7lJwHjT5
	5fJkby8Gl8QsrJ+HKotIIK3AaIiqYQ7L/OfMyRsHpXqSymSvSjG7b91LP3JcE5I+RDOCNes/gLx0C
	+RMiJD16ng+/sHFCjgwDgY1kuRwwez2K3YDtSluNj7yFcSZUpevFP6kG5eTIvjd0NWPXREITGHPXk
	02TNDd3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZTdV-0000000Fozw-3YBG;
	Tue, 16 Jun 2026 13:15:25 +0000
Date: Tue, 16 Jun 2026 06:15:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, lukas@herbolt.com,
	"Darrick J . Wong" <djwong@kernel.org>, dgc@kernel.org,
	gost.dev@samsung.com, pankaj.raghav@linux.dev, andres@anarazel.de,
	kundan.kumar@samsung.com, hch@lst.de, cem@kernel.org,
	hch@infradead.org
Subject: Re: [PATCH v6 2/3] xfs: add an allocation mode to
 xfs_alloc_file_space()
Message-ID: <ajFMbT9sLGflpZXg@infradead.org>
References: <20260611114029.176200-1-p.raghav@samsung.com>
 <20260611114029.176200-3-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611114029.176200-3-p.raghav@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

