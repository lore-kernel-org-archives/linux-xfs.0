Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FFB1C3306
	for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 06:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740031624; cv=none; b=BylsePF7AdVxWX8dJ7UDa/k/hAlMl/M/Mna1H+4FkIZZ1pgIuccoZe/TO1KpZ+/5cEpjJWfb8tkeR3iu74Nx91+aN9ZRiDkz20NhrYyyftoxYtxeW6/DnaRUGcJJSYsW831+8FRbdkeglUPWdY51aTd/jK8nrgYAqy9MlXDP0J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740031624; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sTkI356q/ANTQwZWA+PMucd/UUlrS+QP1iy4moEbXuC/up+uK8sVATZW5sDiDX6vSp3ZXviVjZyo8S5IBsNaLcbxpVVD28fAPNpYGWKSkoD94N9gzGWcrkUu3tXcw1yKdMjAtP/TeA1+/7eYuwX9fPpC8c7BU+Lu1yk7+qdzuxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=evFM721q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="evFM721q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=evFM721qvBewqzZhORfdS/a0IY
	sLWHNlNtDNjnPdzqzIxSL3SOryQPs/xYVM9IfvxEtmEM7pzr93aaeB+sxgaRqC/6Idb/gFVUOj/rp
	j90Qp6v2HtBM+OIuNQfF7tcbpSW5OpSAf/e42rDVoS/6I0dk4sqble3V569MkpWJkWgKMD5dRgNRr
	mHnf8EklVpdlStQiZnn3mJX8yatqDtcSkD7sqQoRGATuzI30UaSF7nhKPD3tdx/XcOz/LyxRR5QiM
	RCXpbkNwo4By56QOzyl38Gb/2X1LOQ2fiCDNmaRCLqGGe33+dcnPSV+PaSeueSkuVcjhoKai8DYms
	ervrQi+A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkzi9-0000000Gsey-3mfv;
	Thu, 20 Feb 2025 06:07:01 +0000
Date: Wed, 19 Feb 2025 22:07:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: flag as supporting FOP_DONTCACHE
Message-ID: <Z7bGhdlmlHtcjZvC@infradead.org>
References: <20250204184047.356762-1-axboe@kernel.dk>
 <20250204184047.356762-3-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250204184047.356762-3-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

