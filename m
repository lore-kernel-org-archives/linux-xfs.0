Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C955662
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xo5dky/u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xo5dky/uPapzS6+2G1mNMRVIJ4
	eWthynSQUaZRuEu4MYlFjwSYEf+psSZ3js7OcEUSIXO4YVG1EglEP40Cwv25JPGYFM7BNd+zJydfK
	AKl3/TEXUctkUJ6B3XvWqm+E+22fusl5SgQqsZrtOl2sfTEmw+A3dNJc6HMzCwCCdEsG0LVyAyvyA
	aVsbOg6O/Zx6JSBEinJ423n2dSHrbX8FUBz5lk/bv+raZvJ05KCLSgCdxwidFv9Y3Fs8WjD8WR9tY
	RudskV5IngEn9Ba8qe/jt8hMWlwYfrtP8liQ80tXPZXvPIHVZjtf3wRtjSSYf0w1iMq3ebMK6ThS7
	WmmwcITQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLd47-00G0W8-2U;
	Fri, 05 Jan 2024 05:48:19 +0000
Date: Thu, 4 Jan 2024 21:48:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: repair summary counters
Message-ID: <ZZeYI1y8I6h83ACr@infradead.org>
References: <170404829188.1748775.2308941843971231003.stgit@frogsfrogsfrogs>
 <170404829206.1748775.17077365646453928685.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404829206.1748775.17077365646453928685.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
