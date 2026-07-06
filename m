Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D193D667F
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jul 2026 06:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783320658; cv=none; b=RQQQQaoOTBpegyyR5cp94iqut6I4BjDqtdEqTiDaTELWjm/Bjs8RXe+1Vy8vVuALhSFE9k2S1kCYj7y8ToIDk0/INEmcY69VkshSZWRvmV7fUlQBqqN6eKXb8nwT1z4p5G58rIu8YlBpHjgWyOS7z0fgdpu+9k6PcdMZPmiUVNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783320658; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dg/cVUL7tozI41af9Hg9ekd55+PlYE4+b0VNHeZahljlknfvSAWqOU+T9l/R/wiMcdUT/94vFOBqFtsypL2pDX8+qv05eDC1PAukeonc2cEWN+CXHsnWDxKcml2v6GSRjZZGFK1MiXj5uLB2HOQhfl5LvdQiB111UHbVuPzkzEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=edjQT1EK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="edjQT1EK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=edjQT1EKGZpvlo8La8Oou10Z2K
	utL0nQ5vq/RY2l9JgwbwgPDFJBVR/MHw/zTz5wdmyMnBMvNnjiksE2QOQ6YQbVDnjZPX1PL85oXE5
	tZJCGznEnKDS3z5XBWSZDtOzKAdlBkXqtthJ5kcVMx0rE/6H1c2X/gzASL33NnwJshjvXzQHp/VLd
	x8hNG2EfIxJbs4olsCIpLjG7XeMi+pug0GU2NkzAupTxrMCuJGgFsZa3G1so/zNT5phVYU73wajoR
	+qdWmw2LAcqVwME4mxCv3Xcm9p+Y60VOZ4QuenbK8m/6+Z7mKe3VfLw8vdkPvHw+ZsVHKfHCD+qxb
	UYvBrP+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgdAI-0000000BewY-1E7q;
	Mon, 06 Jul 2026 06:50:50 +0000
Date: Sun, 5 Jul 2026 23:50:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/18] libxfs: convert diff_items helpers to cmp_int
Message-ID: <aktQSiC2KZJ5qFVz@infradead.org>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
 <178302226322.845537.14974268104031687429.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178302226322.845537.14974268104031687429.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

