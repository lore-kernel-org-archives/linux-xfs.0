Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4967F38886B;
	Tue, 13 Oct 2026 07:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876979; cv=none; b=Ry4cEM268VRQejhG6PPT7FVg5ZLSw6vai6iSL1sfUzGRhtOdhWCvimVa8ORfZXb8i/bHl+6Fg+XxA4CmWv9gyqMb4+lW01127nAvY36MTQERdZfcgeAscGKmqYVCJtM/qyajPWbvb2mobkDzQjRHyZ4sAIglNyZg2+Hh4Glwxbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876979; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uYXq3GYq25K/CuNF/yHAlY+A0oYHRVOIOtHV5+obUGjw41WxZa2Ez/5j3Pi16MI7QgaP+0cB3QVPQ3PTDUQrZ4vaciSHVSlVQSkfh+bL0E+QZ2XElsnPDFm/xgNFuQlq4pccJVLzzR3D7KjulOzJof/DA9swTLuRSwEfXW87cI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dvYPrUAt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dvYPrUAt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dvYPrUAt+bfXZG8MmiQg1nLENq
	Nayan4dmIBoqdwtq7MhkvIlSmwl6wgG6GCNPPd6P2mrNtafdQcUrzqHTZ2/WZP1Do17Bk4hCzPU0H
	p9YZ5rtCg7uMsFGrwdCTn6QPakQflm58c5qDcsD+VIUdlhyw7d9c+aOPHVMsNwOPuHr6zVuJ89dJD
	EgaGQ+YYKRJkRN1VHD+q4V/3H1soiumTSXwv/dvz6qriJFWQvRz2406V0E8miXYsrFyGMsvE0l3+6
	fYD8BFT4NaIk80j4IFgTmmdT6WEybDtlvtp3UV3O5nA+kTLbPJs/eCWaanfQay1LqimjlOY5kH85s
	O1NPXmGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGX3Z-0000000CEAi-1LPG;
	Tue, 13 Oct 2026 07:36:17 +0000
Date: Tue, 13 Oct 2026 00:36:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] xfs: reduce new btree slack factor if free space
 is negative
Message-ID: <as3fcV6u9WDLzaNt@infradead.org>
References: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
 <179186107225.1898400.12841478564368550599.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179186107225.1898400.12841478564368550599.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

