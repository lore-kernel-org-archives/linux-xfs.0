Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265C4DF58
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hjo26b5N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=hjo26b5NcScmC2iP+AaM9eUsQp
	mFCK2xZChY2ModirSI+3sd+8pczzG0lN1aT0fqwlXZjM9Qi3LZldKHdXvLIfm2gv/fkalNRyf/rT3
	hi3rMhLRVGduwfKaQ5w/Bg3Ec7T84znabycrmO2UB5PJbsWBHvYs2PUrnTmnKHaK/P0vTF7keskZZ
	qlYpaXaH4v649GyOy1rAnWKrpz7Gfu9/92WdhHL5Th9j6KS5c5BNUNW6rbP1Kj6uNSkhWB6+VDFvq
	vd+AFEP2+Lt9QGKHkH4JACxIimEYw+URm/AQZHKGUaEjqKViFXqmw2BDYH0iG/YPO8XRuE0JiJzSP
	h3axZZKA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcGw-007dOh-24;
	Tue, 02 Jan 2024 10:45:22 +0000
Date: Tue, 2 Jan 2024 02:45:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: move xfs_bmap_defer_add to xfs_bmap_item.c
Message-ID: <ZZPpQmlKJiXnARzE@infradead.org>
References: <170404831410.1749708.14664484779809794342.stgit@frogsfrogsfrogs>
 <170404831519.1749708.10735905486343408951.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404831519.1749708.10735905486343408951.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
