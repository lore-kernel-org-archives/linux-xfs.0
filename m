Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8BB524B
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JPltEKb+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=JPltEKb+YwDD0qCLBF1ui8Rt8q
	8CQ7UcG6CDp6sVsKZfh7+j/ulJleb6DdB+vq5rvL5AXh3YeVSJYziykaf1D95Q/NftEuKYc6cfrTh
	FREWPorokryktwevz8Rtz6nczy7MPp2wkp8/HAxl8pRh7hm9kEkD62MQidJ5WRTAa1xG4lyj4+vlv
	PD3C0FA4m9muvEU4eQ+6iBoxnpEjrP3nGglXT2zfdHvDI4xsTJKZwOoqH7EpICFM/mk5Y+xv/wDyY
	frg73DS4cVACMNFt0kWjGazNTW0frxHvWrCXSa4q4i0aI1OqWKaU5WymbY3D5cOQPZy6KHbLbfg6+
	oKyFd9DA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcRf-00FxU5-1N;
	Fri, 05 Jan 2024 05:08:35 +0000
Date: Thu, 4 Jan 2024 21:08:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_scrub: improve thread scheduling repair items
 during phase 4
Message-ID: <ZZeO0yY9G1ScEEYj@infradead.org>
References: <170405000222.1798235.1301416875511824495.stgit@frogsfrogsfrogs>
 <170405000251.1798235.18303542887655297623.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170405000251.1798235.18303542887655297623.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
