Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A80FDF57
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 11:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zGw47rCl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zGw47rClvKvWLgG7B1k+Q8wwri
	DRbPa1PgZG0/jbENAJ+ExhZiEmoD9hKRO4MM5ayZvurXhFFe+SLQj6IYV0BJNUBwkA8d/ImV2poes
	LBOmC5/B6Wo6/FDq0Y+/Cq9eLNoTq3yZS2/GIVIbUkLC62Ks8QByJISE9xWQXdrwav24u27d2iiRn
	k5c5NbPg0Bq4NnybO6K0h6hp3VWnjIBABVfDOVf+4Mf/CUa6+gu0b0+ORDDj8tAg5TUQLHfqAGuEZ
	eZlwmNTGLN+T6UNJhky8/ASBaJiBFYg40gLMC9L/5COzFdGjo36ohLWAVJZIpqhWMupGCp4mtEIse
	TtW7Z2Lw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcgG-007gNj-0B;
	Tue, 02 Jan 2024 11:11:32 +0000
Date: Tue, 2 Jan 2024 03:11:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: create a static name for the dot entry too
Message-ID: <ZZPvZOYHJ4qiHJyX@infradead.org>
References: <170404826964.1747851.15684326001874060927.stgit@frogsfrogsfrogs>
 <170404826988.1747851.15202607805712467013.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404826988.1747851.15202607805712467013.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

