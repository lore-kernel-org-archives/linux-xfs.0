Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7746D40859
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 21:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710884917; cv=none; b=EbZ71fdhoqHWyTPaTZ+LKBENWl8g+YYzZlj1oDGo9tu+yRzqmXab2Xt7EVjD4zkRnLJ5dljjz5Pi7jcvJzaBSbwOR/xex6QVCGvfezU3iApIs9fM4Lj40NUA/A3AWdWCbc4zFR8Oe8nRG6+gMUMzbNsuXm54Rrl+02O++b/b3iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710884917; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uWsUY4qUJDbl0pbeXyPfGZIl5wf2RsVvocy3o648BjXKTYOnivZwzrPekswDGHIXlhf0yUGsJd2G1ilFWRjv8IN8ZtI1plTIK+hDn+EqIitRj6G6geUjwDJcZadrETNRD29wui7IvfWS1RA8wkmIuhJq6nf350LGQSHtiLa0bvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S0euv24A; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S0euv24A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=S0euv24Am2H1s/OYBBvX5IOSdj
	LAiHaMdIB4t127P81RLT4R12OqTOIhFAyZYaV5bcE9iWBhWWhSTrJyauaJPB9zYn7wYW7uIau0t5f
	L5Njz056fPAXbwCUHN/zUlUX8RQNUyH16OiBpiG7ZMsnWgzUFJXvZixsZLR2Gcu7w624DhcurPGVu
	Ph4a3dD+kcBSWyl4bd9otstN6oS4/bx5dzDpCnITgEWe8neP78EgPoIftabGFznTm38ClZFIZRnjo
	AsGZR8MsGQRQ6E80AHg83786PHG/jVVNeTJCnZnZ6wAjVE7RSzwDRnUb9HO0fF/bA+E3sfm9oU/jR
	YFplqhzQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmhJy-0000000ELIX-3uRb;
	Tue, 19 Mar 2024 21:48:34 +0000
Date: Tue, 19 Mar 2024 14:48:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: consistently use struct xlog in buffer item
 recovery
Message-ID: <ZfoIMrg8uycOxjpQ@infradead.org>
References: <20240319021547.3483050-1-david@fromorbit.com>
 <20240319021547.3483050-6-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319021547.3483050-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
