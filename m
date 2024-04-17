Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEEF12FF8F
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 15:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713367338; cv=none; b=FJOB5KbmulAsSp1SjPqKWNZb8eK0CZtm8vvgsiToMdhWJcKPRk/eDL8uHXfKVCDWPi5SE9kzvx5pfI8StB4YywM7AI+rIls2XUt2DqYhcKDBkt1Wjs9GlQroJkiAly9hgmNgCVzkK3hboevuFgAhDY+uaiXziQADafI+S1E91so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713367338; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LDCbJ6pMxRQuzWfF1RAgziiremMNiYzJwSScEpXM+ReB4XYeDNkJ/yYo2d3mHn/izSZxEHQGI4btqAD49ISluaYoOaksD7/VrtYNXwUDWjn0Ri9yiwLIP/OeoacL4k7m3Ka8cQN5eq5Uzbxhx+PEIToaHHLEnySFGk+NdZd7j44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3DhwzQeN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3DhwzQeN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3DhwzQeNyzW4iR4B4cKTlPFdli
	4TH5E0A1Y7LvlOLERI8fazUiRLE0tyJ+FvWZmH4hM/693b3S+B9LfOFNoud5BPiIwxt3U+3mQ0039
	AyMT/83JobHVD3fALkz8GmOTr9I24n6I34xR2GY1De14tygufDlg6i1B+akxVvSQFAd4DKSwD6s4+
	Vl1cP99iFzj0IuG/9OGM1aRs2iWse7LE6nsBcNUiTNqkPLGJrugFSiU9mpBr+Qf2TXdfJ49vpo6MC
	UrOUHx4loUFoF6LCvjImSacxqpyUfKkIOicY7qMicgIrQaVnqc/f7Cf77S3kWuCTEEO00dbS6Af49
	xsOnLUTQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rx773-0000000GZGH-06CU;
	Wed, 17 Apr 2024 15:22:17 +0000
Date: Wed, 17 Apr 2024 08:22:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org,
	hch@infradead.org
Subject: Re: [PATCH v2 2/3] xfs_db: add helper for flist_find_type for
 clearer field matching
Message-ID: <Zh_pKGMLHs7r2koZ@infradead.org>
References: <20240417125937.917910-1-aalbersh@redhat.com>
 <20240417125937.917910-3-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417125937.917910-3-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

