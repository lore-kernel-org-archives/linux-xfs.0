Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706DA5228
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 04:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dbqH9V1H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dbqH9V1HSLEtzj2wP4vgD7ZJTs
	QDfno3+R0Cmv3Hxew9WT66u6Ry2cE70R7qSnOcNPAP7sUB4KMtf6ymrewHtIH/rR7fhR2PonAz/zc
	BmAwqG2Lg2tRlTgS2QYn3ju9u/exCeOgDLlXxoPa4i+qdNGxEj2j9JMh+YHt2uOzq0FiGLLKR/hL5
	V6tib40/jPjUDe/8CYT+KxUMWMr1Oj8iGb4HVdLu7G8Swk1VXExQbltzjchd7eGq6LIOVhLZxpfyx
	qgd1yromedrwd14wL1l+gklQuXK6eD5UfUuD37z+L9Mbvxw7XLSIkeqPTeCAxdu+l23a4/tQI6ZXj
	yznkO8hg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcCW-00FwFM-01;
	Fri, 05 Jan 2024 04:52:56 +0000
Date: Thu, 4 Jan 2024 20:52:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] libfrog: rename XFROG_SCRUB_TYPE_* to
 XFROG_SCRUB_GROUP_*
Message-ID: <ZZeLJ9+yyXcahYED@infradead.org>
References: <170404989741.1793028.128055906817020002.stgit@frogsfrogsfrogs>
 <170404989756.1793028.1204023687464547421.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404989756.1793028.1204023687464547421.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
