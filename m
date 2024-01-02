Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B65AD515
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BkSDmEbo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BkSDmEbo/18u4TvefSy3O42XbW
	8vGtL3aq0vbXOAL9+wfEorivF5Y4YnBzV8yfRUqVJuooorQQlMN0+sMkgCC3XLoh4PzuQfNgusbMs
	nVM1NnYOEezz9yPQxbZrpRFM+KdiMYHONcOTlnTm0iDfsXTf/GbL9r+qc8ZbxYHw/SmnrTNwotuBc
	72W7YF07pnky8SbZsqa7uJzU0myk1s1DPMyNIYsOmMjnDYSn9vE6hyb74IJIkvAaYx3vgOX8V5Nvf
	dhMQhzBYC9rCkxFbGVH8sD+D7Nuudx1C/cZLOG59fyIQY/MifkhGJ6Xs4W3cdD4OLzaJvRMtIkGoz
	1ct7nOgw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcGH-007dJX-1h;
	Tue, 02 Jan 2024 10:44:41 +0000
Date: Tue, 2 Jan 2024 02:44:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: add a bi_entry helper
Message-ID: <ZZPpGSaHN9+Ctr0r@infradead.org>
References: <170404831410.1749708.14664484779809794342.stgit@frogsfrogsfrogs>
 <170404831489.1749708.9412724534892167170.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404831489.1749708.9412724534892167170.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
