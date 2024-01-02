Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA29D26A
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1/CdXNvh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1/CdXNvhmXgvIKXn4FwefqeWRY
	L9Br6/pvMAWmqE6lEfYE8+3iwIup6vnmL4Qy92K1Yd62UwsZBLppSia5K5KxqBK9XQUI5BBdCCswB
	dDPy2vusZRrGUTWXLWyMXW9DGJispL9apH9pgDFn9xWMIqdXlBbXeRk0KjsKk8StylAWNYwaFWFgs
	rNzB3fpkZ/0CdeK6vMZpZlD3qeD+nC1MUgbeUffp7I8dgfLZQc7lnRTq5fFK84ZYQUa0hccH3v45r
	vs4c2cvaZo/L5clwjUcNQ7We3WA7rx8vJSGhILxuauoO7nQ2HXmyQuKNTk2nxSfGlH3K+swddm6Hu
	gNxxkILg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKc24-007auA-3D;
	Tue, 02 Jan 2024 10:30:01 +0000
Date: Tue, 2 Jan 2024 02:30:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: report the health of quota counts
Message-ID: <ZZPlqNDWRD5t7ri6@infradead.org>
References: <170404827380.1748002.1474710373694082536.stgit@frogsfrogsfrogs>
 <170404827409.1748002.15298270435251252315.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404827409.1748002.15298270435251252315.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
