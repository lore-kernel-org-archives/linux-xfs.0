Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BCFDDA7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g/8dOVZg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=g/8dOVZgzcVZQbsFaTwyPnQ+v6
	GSkOAqi35AAVCwRsyczpefz2izwh8phPDYaHbwiRrJnFF/GZ7NqtoJeyBNgJd3KjS/TT/Itq3aZ5m
	iO8WpI/r5qQXAE9pOQmX3aHLOnCnPSb3Y6DRNl0hL32Lk7WzW0fdoBkI+YOa7pLq/u+xxn3SxnpkR
	9S+wAwrHPAexI7spuUNczud9zKq+XBRIZRcjAiKG3vhmKR4Qc+FzTgzU97xOZk+Y/8qvgS36tFcQo
	bKgAYIQApcUX7gcZnpJJpBPuKS08fh+h1rc/5Ky9vEox4kNv9v3gdYeXkM+OZ8LY8PswNiynIkYKV
	jq2sR8oA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcIM-007dZe-13;
	Tue, 02 Jan 2024 10:46:50 +0000
Date: Tue, 2 Jan 2024 02:46:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: support recovering bmap intent items targetting
 realtime extents
Message-ID: <ZZPpmr0r5owmd90w@infradead.org>
References: <170404831869.1749931.14460733843503552627.stgit@frogsfrogsfrogs>
 <170404831924.1749931.14835443792114657795.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404831924.1749931.14835443792114657795.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
