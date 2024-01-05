Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E204524C
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 04:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IuE1gCPt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=IuE1gCPtCVKG7z8Ii3fk6kNexY
	FmHyEQw5H12Q8Jc0Whu5PNSXAWivEFDSRFd2UXHjjq7KxmZpL0KrLlIvMfuRPK9oP9EWjIrGVCdHu
	Qe7dWPQf0GMZT9Rk57V/tLOKrkOR4t33B0XU9wX4q4LshWxvNNJ0n+FHkUdA+mo4Y/wijbZcTb6yH
	8b4SYkYNVs9lRP0gn3AA515t/4gD8F7PMYvG0owWfna4GLGJrUuma43mGKU3ruxoul2UpwVvQ4yc4
	G0LBVqtFu90i52rg3KgcCmfUe+bj6EPoJPVY5PyJkWsYhzjRdqR5/lSc2oCh+GvpSE5qi7i9S2GUo
	vYnM7Vvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcHO-00Fwbz-0e;
	Fri, 05 Jan 2024 04:57:58 +0000
Date: Thu, 4 Jan 2024 20:57:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs_scrub: actually try to fix summary counters
 ahead of repairs
Message-ID: <ZZeMVmUwUM1mwnGS@infradead.org>
References: <170404998642.1797322.3177048972598846181.stgit@frogsfrogsfrogs>
 <170404998739.1797322.2676507559663047353.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404998739.1797322.2676507559663047353.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
