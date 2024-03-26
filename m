Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DF0442C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 17:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711472804; cv=none; b=XYSgsTgN+/R/+A1wrBzyCaBWoUSUSXbXbJgbXGmbr+HEM4fuf7+dS7niFEEIPWoA1STDsPG2JNRUzAruyvV5kc3laEyRN4JTYCjFn7/hEDd+64Ef4/3QCIPXzF1rkCHk2JRPdDn/bKx0E5vK+iyyo5qzFjPbIsfAE+7n4ggoTAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711472804; c=relaxed/simple;
	bh=6oO4m7KAB71naObvizdDYGCmVzQA7LNR49xa0JEW8D4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DpCokni4J7IHLb8ZItNRLKvE/TkTnNxWaYUXZN4bJJV8ZcdjC1axlZOHgaeaojsdnur1UyFjaQWQpXnSo+TWbsgw74CvM87PjZjMn3oUGl/L+sKiXTy/ZGi4zjE5gDJXjBVYdW0/5cQ8MnuU52o31Gi713t2qyAUpvLUSFfXCn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NipWfs+Z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NipWfs+Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6oO4m7KAB71naObvizdDYGCmVzQA7LNR49xa0JEW8D4=; b=NipWfs+Zh56cuzrPrchD2xfnFr
	Dn3yoTDlSVqAr8bWAtHSnaZliWMEEcFpfVZIVDjANQENCjxAdDgzwDrUWSLPWM0ELdXbY6sqeEP2E
	bnsuE/iy9tDgwCZboCXqpbftjyuRcypMxNbc2qEjw1U0f7uC3i6u8+ZRKvE8Efa6dHRCSTceQKNwg
	gh/7oIxI+WX88BHmnhodTOr6J+QI3T3JREE5tdZtCKfM+yeQGhGZ9wGQH7QZbAOkHqH4YlrBkCXBT
	uLM75/GSQusO+dL8hU8jszZFg1Vudp3/PeHCDxeN0CtYdU5Ca3/BvLrPhUNEZiDy9FtFRHTKWOS4g
	nCd5qWoQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpAG2-00000005dcn-0LEl;
	Tue, 26 Mar 2024 17:06:42 +0000
Date: Tue, 26 Mar 2024 10:06:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 094/110] xfs: support in-memory btrees
Message-ID: <ZgMAojJhue7NMJaL@infradead.org>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
 <171142132733.2215168.1215845331783138642.stgit@frogsfrogsfrogs>
 <ZgJd9eJ5qbiX0fPY@infradead.org>
 <20240326170244.GN6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326170244.GN6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 26, 2024 at 10:02:44AM -0700, Darrick J. Wong wrote:
> Done.

Thanks!

