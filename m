Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P78YdJ58"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC17D7F
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 21:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=P78YdJ58Mojokf7lHPaXMoluuH
	WjWP+p6eQXXtgjR3NO4t07MZUQB/nJ01P3FWsHggXxVH3B1rmeVfXzl0RhjFvyXXqXnBo9Cg8S7dW
	dRhV447anHsVKr+gqF6yMjK2ZDA9aVMOSSf2bs0SaDr0Hhz+53bH2LXQsKYnbk3kGXlvc/s0tTsUY
	BcBUpXe3G8E+h11ExiMQi7XHLRgp1KtGqYpoIDJps5NzRhaQo04q/JuJPdxhCURk2ogkJ/nIZPYKu
	UVoN9YWINA8d5S3r9xTSpaJZNgAZFT0LC7QpLmZJEL0KfwmknQDHnsxcc+pj541BgYMIcUNd+/4bm
	C3SoIPRg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB6uS-00Btdt-13;
	Thu, 07 Dec 2023 05:26:52 +0000
Date: Wed, 6 Dec 2023 21:26:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: add debug knobs to control btree bulk load
 slack factors
Message-ID: <ZXFXnIspmOMz/gA5@infradead.org>
References: <170191665134.1180191.6683537290321625529.stgit@frogsfrogsfrogs>
 <170191665210.1180191.2699697469994477580.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191665210.1180191.2699697469994477580.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
