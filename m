Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932273A260
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 04:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713243332; cv=none; b=HfbOknLdlC5S/mT+1v/6eoQaTOlL5RExYgxMOe4ofIgfuCjG3dn/7jQRYlVwZoSRznmmF4KL6wyG1o1mjaGQGAOTwS+bAqxPW7EWlZ2RayTtVIy6I9pz7n9RQ+TesNsgbdnk8WibUkc0PwERlSOiHTZsqroHBzPBXF5ZLcAnjUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713243332; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G7mmLUWdbIU1MRibWSQjgrQG0lWp3mbcj+ZPvQq34z6fMfgvx56XSYNK4W9lt4sRLruXdLPrM7WLsLptizplkkZVfmvlj1ilqIv5sKUdvBrr30L7w41vIYDCG3z3PC2STRODB8cREwTDtSkseS03vWNGtnN0VAS/Xntpm8NAGu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uwpCmLNP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uwpCmLNP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uwpCmLNPnQyOOTNAGKzhCpAmTq
	IoYojN2Gr0K/E6kXOkU7+FtUuI986Otzm3zESQ0lA/DZv8D96Ml1swTjvDNeaQFiKYkBl6TDZZN2L
	jbN27kVK++6M70LE65YWQtCwezF6GJBeLwlIdLYNVTK29cXeCI0fGKhlkzQGRWYeLQS289oPb4flJ
	CJhJovE+qIc6Ng7zFdGZ8/yFYmRCAl/ZoO/3CAxof0N8LwkUAv+RsdI37AJyZitCW7RJP/lzsphGg
	KKxI/3w3tWS/yomI9sS1XKc6BmiUPHlTiv4VZt7KRDuEDyGE+PrFk81rd3ju46JfWNG1di/BWHNTh
	Zo+dJblQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwaqw-0000000As5V-3o4t;
	Tue, 16 Apr 2024 04:55:30 +0000
Date: Mon, 15 Apr 2024 21:55:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, cmaiolino@redhat.com, linux-xfs@vger.kernel.org,
	hch@infradead.org
Subject: Re: [PATCH 1/4] libxfs: remove kmem_alloc, kmem_zalloc, and kmem_free
Message-ID: <Zh4EwmUgxZgLQZgZ@infradead.org>
References: <171322884095.214718.11929947909688882584.stgit@frogsfrogsfrogs>
 <171322884111.214718.800611638377657922.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171322884111.214718.800611638377657922.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

