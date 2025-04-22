Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241AB196;
	Tue, 22 Apr 2025 04:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745295568; cv=none; b=IDvbhaMvs8nqY4jxS4+3zGXtgy5EMfJCtq01Yfv3fbbyBxV6QYsx2lNk5TLu5QyCNpeMeqjbUg2U1evuO+GnnTUD1AHGROsMtY0FaORa28CtEf4ffdOxZTRIB7TlZ1xjjmikekNVy2Dck4+dJqBHr6GHUk4N5cvfWZi/bvHaMHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745295568; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PDRjWKdT/tdwpLwyd0C4d2KXJRAVJsQtL4b1mLihXU4tt7blPv5YeLp2QXuy1ZyNHJvxH23avDiyAG/p8aZaFgK42erbP6QWeCF9wOGix5mZxOuet2Er5oLbDgbOEJQs+xm8mn0KTUAbYXEDUSpzeqcfNUyWOuvggMw+nq7q0bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gF9a3GiQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gF9a3GiQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=gF9a3GiQzNLNeC8ZYytWc/EP/4
	b4pJrQYqDxA2/vUDyaHSv1i7Cxd10Dxjbe0gvnGFcR7lUK9qJygo3nX8qDfIUi4/4Fq18ggOs2a+5
	LXzIqj/RtblS3t6GW7hA5YpkEKQ4M/PCTaqvcyXoBbWKy95gq+IL4+unX3BHxTzwoed0cZoK2anJk
	/XrmqwSgUu/mNcR2+m/oakGa9WmAksLr9XepAof20Q2O20pjWsY8C1MpRm+6AuBFelPNR0Bnh1dJG
	jtx4NkwNFZqVUuyZruRgBpm3eq4ongMJhT1NyUoii3Yn4Epua/kx8l8g/8pRqEONCkqJzaMVrH/u+
	ApGhAlag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u756T-00000005mK6-2haF;
	Tue, 22 Apr 2025 04:19:25 +0000
Date: Mon, 21 Apr 2025 21:19:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, axboe@kernel.dk, mcgrof@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	shinichiro.kawasaki@wdc.com, linux-xfs@vger.kernel.org,
	hch@infradead.org, willy@infradead.org
Subject: Re: [PATCH 2/3] block: hoist block size validation code to a
 separate function
Message-ID: <aAcYzaEvDVHuynS7@infradead.org>
References: <174528466886.2551621.12802195876907852208.stgit@frogsfrogsfrogs>
 <174528466942.2551621.2138548156826449549.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174528466942.2551621.2138548156826449549.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

