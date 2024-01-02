Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7582EADE
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 11:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MFSByq3u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=MFSByq3uabZN4cG7X39wJ/6T2+
	gMqtTGave5RvrznLlhNF5JyJltmEC4Byv3HSwF/wdAYmLtd281rbwQX0suQ5lO61YLXgSL774htlC
	J6S9MFZsL9ilGP/j9I8TrnfsB50VnuROqUFnpw9rGtN/SEp7ioB7EEFIncJlJ6rVtJ70NqB7pPHMl
	C2xfc0AiCTjk8tVmfZe0CVyBev1fQxtZqDZ0ZCKIdpJEjukbW/PbHVG7JeVc2rF4EPhjGKhZjBBf8
	q/0+GmozQMw3mQEDrX6YXBsGyk7q1586QDADcEdhl/npg4Ryndn8LYMmGmcU39/GJn+4F6WQmni+r
	h37Z9Tmw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKd7o-007mLr-1u;
	Tue, 02 Jan 2024 11:40:00 +0000
Date: Tue, 2 Jan 2024 03:40:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: cache a bunch of inodes for repair scans
Message-ID: <ZZP2ECB+b0rDtCtp@infradead.org>
References: <170404826492.1747630.1053076578437373265.stgit@frogsfrogsfrogs>
 <170404826603.1747630.1523391664280656042.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404826603.1747630.1523391664280656042.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
