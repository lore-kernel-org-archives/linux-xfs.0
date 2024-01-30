Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6528854730
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 08:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706602575; cv=none; b=X4FFreYHVFc1DxsGWkiZ0edJ+dqWgbcGSuXDbnA2vcUIxHm7hdIKLArzwRCuoj+bslImKxjrrejxHjgKUygaOP4axcpX/s+64TZFkGXJLFs7HbTnWQC9joRCIP3SMe6wN3XLTpX8SeBiYl8ZLjwVh+DlIROxnmJo5qzd9ubTm5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706602575; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZHZCC2yUzgCBpLtz4ZvfgNWmlo8xbhBtDGqys1nw9393TmRBiLbJvTbK4/MJw/ZeOfARsweAWCN4+T6fGSC9f7HADBHPnNfPXFNyM9Lfl8hvtiauC1cr9w1iVPEo/J3yrXWfTU7T3TSZM9YTDScHDXboK54Gj7OCUQGyHQW/Ck0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KytnY+NT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KytnY+NT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KytnY+NT24R0xTe/bsu7rXoWU0
	KwFMaCogQLx/2D+cZvvZUgw6v+KMAayRIIVBikZTqmPU8k0RqyOI5pYldqI18eIBO2TNlUisN7Zew
	H9g/X9zy75x/ofvtda4cut7fu+6p+MVcSVmCjgdsvL/FdotsB07LMW1Z3oJkEY5ESvXfsF5qioTbA
	CDIAwKf06M5Sm/6izZaHx17uzTy4/y57tekXxzjA1X5PePliOCu/jp31LKYIqsbASypZ4ZjPoy5De
	uIgkZzH+wbwaoiJUeqqSOxWDDTx2OCC0h65qyb5AN31lfKBcUTiLepTgklbXjH28swj/5b4i8NYVc
	XSHZ3GVA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUjHy-0000000Ff19-0ATe;
	Tue, 30 Jan 2024 08:16:14 +0000
Date: Tue, 30 Jan 2024 00:16:14 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/8] xfs: create a xchk_trans_alloc_empty helper for scrub
Message-ID: <ZbiwTrIGJAQHG1D7@infradead.org>
References: <170659062732.3353369.13810986670900011827.stgit@frogsfrogsfrogs>
 <170659062786.3353369.6856402292254216066.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170659062786.3353369.6856402292254216066.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
