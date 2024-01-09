Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE89E8F40
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jan 2024 05:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yqGE9vo0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=yqGE9vo09UuxO2AdRFzrw5WPOi
	XmtWETVLSAzXaZnRlMkU667iisWsy5aFAgrbfbVILM6zmXEqEQiF+dnJeacdrHepziG1deLj1eHo3
	CL1tPMtL/s0uctOYG7tai9G9CMJfOjyY2SEuMB7NYpQLkweKzONIbKXiGKeXtQsGr0DsOjSILov0D
	SbPfBRW6DoFFYkjbS+feEDFQ4kg/V0HA29h0NwhT2fcZ8WzBkJbcdY4/KSDYXrlrCnLquibmso715
	TKYBWmcPU2RU7CSzpR4AuKzCLszBV1EJy9r2di+H2YtdTTXD+nfJ9I78ZZ5A1UvLxtGSaomzNj8hP
	fqO1UKSA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rN53j-0071S2-0a;
	Tue, 09 Jan 2024 05:53:55 +0000
Date: Mon, 8 Jan 2024 21:53:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] libxfs: fix krealloc to allow freeing data
Message-ID: <ZZzfcz6bmYBrOo7A@infradead.org>
References: <20240109055118.GC722975@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240109055118.GC722975@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

