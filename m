Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19555243
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 04:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FXHi+cUb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=FXHi+cUbCX64ZhOHJ15ujh2Oa3
	O8bcMK1vDcECPjsWqoqVWVdJyHyuLc4mXqHG1oJbKo1HPy/bHlPX/b4H5OjCUTqEAt4LiOIYixYLS
	7TjB6VGlKsXFnpfgS03HBN8pO1AKo8w4ThMFnJtzrXgxdeVVEvP55yMjKZToML4pnrvbsJwjXH5up
	nvIMu++wrN0Aj1QFuLyQOJ602GcmQIFKobz74cDQq8u0q2xl0kXpFa0N4Hk/733qWnNZr+JcU23Xb
	DrH/3bDfvn60jRcmeVZeHJ0fl6uN+Sh65EOe/OXq8L5OJ9AK/6ZGw8wQI7H8ef51991wHmpaqXTUl
	BeZzCs8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcHy-00FwdX-1q;
	Fri, 05 Jan 2024 04:58:34 +0000
Date: Thu, 4 Jan 2024 20:58:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs_scrub: collapse trivial superblock scrub helpers
Message-ID: <ZZeMeu+mQmhxkXYQ@infradead.org>
References: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
 <170404999061.1797544.15540940981670714039.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404999061.1797544.15540940981670714039.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
