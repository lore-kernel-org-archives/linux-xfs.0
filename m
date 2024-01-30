Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F2454F8E
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 08:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706602696; cv=none; b=HD3YAkl4Uwb30OKDLRMVqmwLpAOgFCUj9Y8CdFAkGDXc8ZcTRbUyLEZGldqG6+FTApiiBC8JpQ7RnTomWtthzBetsaDXm63Vr+NrKGLQ+KeLRAZYncxG7UFgHvRjyKYxPl6PEDAukvJJuQ/l3H+ose3JP1PajShzjT1OwcN5gPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706602696; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qhEQ0pv+czPocxsHrRTCK/70k6gEiZzXdk86iP8pCU4owwz1cS/rL5DDZk9yhw1SkcJMuU2fsqdjoer00QmzBYSDrrWTmexh29HR8y0WqRUU+ALOdZs5m2Ko0nAPO6QEHMfjcE5utA2Xr92xwuRd94afsARpViX6wmVtshFpxaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1lXvV4nr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1lXvV4nr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1lXvV4nry9/QLqgB1Jl7aHQX24
	eRegfefEdImj5iF51QSlMhUdHZTPH5RBKLxQIggHswmmO7YagaOHzm3TZXtY7skZnsYJMNa6RHp0g
	im1cIfqfNfYrbVfWAC/x+jOm76bj1/ZIfLQhEujtU7sgOZm2gz0L+kG6D7RUgIlra9EiZug56fmTc
	2ezzMSQ2hO60fITRpkWmQ/X0EdCOGzllFyBa2MMo7j8HSA/AEfRZQrq08Fs79QHPlDRVHRyNxlSUe
	KrrJ2YC7a9Z55o/WS92r7kDyFeuy98RLigj8+OcWJkYDZDRmEuIdOLQpoXUQ74AH5MmGwD7jd6nPw
	GfmVNxYg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUjJv-0000000FfWq-0KaB;
	Tue, 30 Jan 2024 08:18:15 +0000
Date: Tue, 30 Jan 2024 00:18:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 7/8] xfs: repair cannot update the summary counters when
 logging quota flags
Message-ID: <Zbiwxy7HRZgVOLZF@infradead.org>
References: <170659062732.3353369.13810986670900011827.stgit@frogsfrogsfrogs>
 <170659062869.3353369.8910186021209077091.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170659062869.3353369.8910186021209077091.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
