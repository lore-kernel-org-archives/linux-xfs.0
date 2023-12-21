Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71092C2E3
	for <linux-xfs@vger.kernel.org>; Thu, 21 Dec 2023 05:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vb15Wulb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vb15Wulb943f7jth04sGL2rgau
	aCRO2ZZVGL+D44sMypw9/Lme/8stSTNk0Bvm85ESiviMLa4N9BpjbSChWVCd0HTiL/oytfblr0KQK
	vZZbyUka5WK5OgKe1R3yK+1evt6i8hL/o3BRbNAO2cf2kFJyqC467ivOIMHz0KdB6kDgsoicT/2y+
	WK61b1BKWCeSywVdURDIFQxMR/0T10h/KgYAI1zAHsSPpDcxb11F/YKMRbkIGYPmnHGZIv4ewT5l8
	CfmDxd/gRf9cfZiM8S0dnnvABBK7+6GTedmBJhrpTCIm7AUiTLKQtoUKgjFvxXfHG+/DNEdskGexE
	RLXjAaZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rGBfE-001kVH-0H;
	Thu, 21 Dec 2023 05:32:08 +0000
Date: Wed, 20 Dec 2023 21:32:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs_mdrestore: refactor progress printing and sb
 fixup code
Message-ID: <ZYPN2Df5rdd5V3wq@infradead.org>
References: <170309218716.1607943.7868749567386210342.stgit@frogsfrogsfrogs>
 <170309218796.1607943.2978536167133920710.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170309218796.1607943.2978536167133920710.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
