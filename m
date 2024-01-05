Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFF65228
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 04:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qsJvJmzf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qsJvJmzfVIVQ8QYwuBhz9+Nzig
	/y0IACOzn7g8NNIMaH68+D+gKHLVTAnX5BceoEiPUZ5TRSMdmREgWp6n3Ue0F9DpjmJZLu88rttoB
	CDfelU7gNuQ5XQ3/U/mlUUYBmItc8L+4SKpg9Fe0O9QAlysIjqhusb+g4CWMd2isjIf8IBQtJqhbf
	TYrs30n0GY6TQgaRa7za3N9PEVBHNqVMu19RitD6SQrxNKe1on3FF4hTLko13wRjb16HIEeaxKiIR
	b/vCaXEi6LVXG9occ8yBT3GJIJN1kuY3q07oeYEkN4dpVS9o/ugkjZqS7DzEWjzYoSnmD0hBF8p7M
	FXizhf4Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcJK-00FwhF-0Z;
	Fri, 05 Jan 2024 04:59:58 +0000
Date: Thu, 4 Jan 2024 20:59:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs_scrub: any inconsistency in metadata should
 trigger difficulty warnings
Message-ID: <ZZeMzgnBKo3wMUQF@infradead.org>
References: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
 <170404999114.1797544.6397356360236587838.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404999114.1797544.6397356360236587838.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
