Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F109EDDA6
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Kln3BrWu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Kln3BrWuQxnIiMLO2f0EIgiUUm
	0IDxYrrSq3i16PfaFdbVl2lTtmZOoYVxYoU5KuFZfQlZYkXXrxj3ydbWKRvQGBkmqIN0wsW3d1MCh
	zWZhDrnOPJWRdsW8dFlo4kBkTeAd2/v+cFiklS9OyOgFy1tnnwUGla35rjE+iiXFgDCnabJWJuUVF
	jcXlhagLY0i+FqN02bpaJW6/395z9rgC8LcVthGGMiqpNB5txRA/WJze8zLsTIOkyNURD2ytFQtKx
	e1vN96gQeGOOxUsYmS640O/mdfpjBSYGYhXXsqF/hoecheVV+qZfdbSrNvZYduxMf//F8d7zTpspz
	koE5FJ+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKc3w-007bCq-26;
	Tue, 02 Jan 2024 10:31:56 +0000
Date: Tue, 2 Jan 2024 02:31:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: set the btree cursor bc_ops in
 xfs_btree_alloc_cursor
Message-ID: <ZZPmHF7mc2tCuw+t@infradead.org>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
 <170404830527.1749286.13289496123261254387.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404830527.1749286.13289496123261254387.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
