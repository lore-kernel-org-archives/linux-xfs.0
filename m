Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAB44052A2;
	Fri, 21 Aug 2026 05:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787290474; cv=none; b=BMoCoLyZhXZ9PGGGFn5oG+SaJShvbIeW8R6/OGGk2NaLVzkVT4brHJsqXe71bgZvTBBEo5cTJ7tSQfopnwEoPgoUkBUWqN8DBku11RqND/zPUxgDfiznkylJf+kr/fFigssvX7+tenSooTieD4G9GCN/KWnRfNNdO3eNlIsd92k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787290474; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sADzNtx258m2gQWXJbJPepcx1oylcByAB3qblTGLGulYdguJBS2GxmBHqu1NwHlF0mEa8IimXkytncGbbJMU1hdg+rHUyciDsa+kz/WksWRVigMsmE+c0HV2frRKvCpTnNa1TVN725vbGgM3cJkS9vZIJicWTSTnrqL/UAbtzW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=16spxNzA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="16spxNzA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=16spxNzA0fGwJqU4e5Rf1cZlKx
	F3OtYO8gAakomLDWYHYLHi5PNz6OPU+ojwWYFmcygbGzxwkk4mxE4QOYMUIuWbcwhC953rzalB8hP
	8kRKCh5fo0kZ+PYXEgk35lTicusUpQb7G6LB3wIrQgAYxyaMm53YJOgv/JPp5EyQzkJw4NHYNICFn
	mhwstxgTP4V00DhqdDZ75kjBugTXYFXxzvuNPZA30SKkiW1Pksq4IPEYRIjfQuEH/vZuKnD2bXzRr
	lF3YKy/zD8o02931pDx0umCBgyn18ut0PSjhqUaPtT63MWTwu/vg+Qa4Ih+1cI7XO+MgimE/bLFNt
	sryGSRwQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxHtf-0000000CZH1-2YN3;
	Fri, 21 Aug 2026 05:34:31 +0000
Date: Thu, 20 Aug 2026 22:34:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>, ljp1205831794@gmail.com
Subject: Re: [PATCH] xfs: test reflux with exchange-range
Message-ID: <aofjZ6PVmqHF6APG@infradead.org>
References: <20260819155121.GA839663@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819155121.GA839663@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

