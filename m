Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172115243
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J64+x0ET"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=J64+x0ETaf7H4ezC6aR7M9xAZs
	Sm0Z1aQV8wdh++57s0unCoqRo4H6LBoeUelBefrDfgH6jU6aNQ43mVeya2r2jmOmSKPRzogwTwLB7
	qGqPFHL6/DBhETveVN63+AFnQKGEg2atEa91BEDotY7EXPSDpfZIl367jL4Kk+zajX0EqUvEbd7yX
	g781XhmLEMMOyeU4QhJzkgee6wTZUsJ062SRnLH3FRzb9UTwqxNdDbo9T9HMBzbwH1J4ke7SsGeYD
	MDn7VoRKMsBbC7TDgiwnZ5ILfvdNdxRyjqDrA+RevkovLBxWYAp9keI7iPiO2fhrK0tr2uKdtSlhp
	Tjsxg0Ag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcOe-00FwxH-1s;
	Fri, 05 Jan 2024 05:05:28 +0000
Date: Thu, 4 Jan 2024 21:05:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_scrub: refactor scrub_meta_type out of existence
Message-ID: <ZZeOGLVhapoQGUx8@infradead.org>
References: <170404999861.1798060.18204009464583067612.stgit@frogsfrogsfrogs>
 <170404999904.1798060.4622752134580778159.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404999904.1798060.4622752134580778159.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
