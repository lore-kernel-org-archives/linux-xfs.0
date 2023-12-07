Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a3xgpfG3"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2287010C9
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 21:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=a3xgpfG3OGm8ueClPFq9DBwN1v
	/RZdejIiCe1kcDU7gLxf+FH0cdYDX4RvoNsvvlDEQSr5IVLWSqj0+rxdn52WSusvCwiHOdn9e+uvL
	KIsPp+ZD6cCLoQgYMrKAznBRbP3FQXneW0MJkZIRkKUzPaGo3VqI00+GFF6JE7I+5h9jCe+7QJn4y
	aSwRu9MSb2mnQgIDoeAuuTHIvc/0JJPa2YDgomVh8z47FqNkJEVcuuQkqWi3zlI7vdGDkJw7s84YP
	DsaFCDIO7L1dlJPtN/O1Hv2+SpWCJTE0j+ITy0AaM5w1dWFGjMQlJ16Ixq+Q4HHHIcGvCTgmAaUzb
	5TJdd3+w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB6wA-00BtoH-2V;
	Thu, 07 Dec 2023 05:28:38 +0000
Date: Wed, 6 Dec 2023 21:28:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: remove trivial bnobt/inobt scrub helpers
Message-ID: <ZXFYBkBVbY++Us1S@infradead.org>
References: <170191665599.1181880.961660208270950504.stgit@frogsfrogsfrogs>
 <170191665680.1181880.14296800294050969079.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191665680.1181880.14296800294050969079.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
