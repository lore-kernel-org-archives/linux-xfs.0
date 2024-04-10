Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB36C10A03
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712725453; cv=none; b=cPEFJEP0N6NAcQ+jqvL2QidmiFJSQiwjDDR+VbEVVHtLMA2TGp1Y0lTuMh8BkCBAJTuVo+zh+7sFX1GSatKTXBWPlAjBf5+NGu31NsMhtbI9+wiPKgmVDdb/b0i2uGhMEWl+5eaPQoJZmyFW2+HzgK3kGv5SoojCoJ7qKF0I6DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712725453; c=relaxed/simple;
	bh=MxwI98CMN3UxMH6fHWj3EJMJ5BYoqruifhqWNHzWsUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uq3x7kbYhAATg6AbdiFkUA+gN2NHiXw3TbiMIA7MC5hwy92JluSa3bNFr4rKH5mEShqka5bP1WGUXOXdZBv+nLgRpZja5qVsV5BWooamksUARiGwTIzpqj5+xB/HrXR/H6A8DELenA15QEoeHpNmYxZ8mYN5Bg79qspHLYjWqps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xoLcorbt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xoLcorbt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sbEODFiGTREs2+k/tDUJcFsjKO0iTT8ri0eOrulztbU=; b=xoLcorbtwa+Tv4vwU3zR5P0VsI
	s0p45SyuhL3IPz0MzeJRwNMRxBw053WWjWoGflT/D42nB6NKQYW1XaSt9Tvv1WLLB0sJ4ik8N6R9J
	3rIs7EsjN/R2R9KApEGzu9ucLoHTCuq6ZH7Twjlpop/Gtg8zhitGKAaoyA9BxJa1sGWmK4LnHfFCG
	8UO1ceDZTF3SKqwJpuXlzwiqH1ek+x+lQl1zX1pRtuiAbI5BQizUmTCWCR9IlKiTiN2LLixLlKM1l
	yfwh5wYDzVDfdDVac0CK2x/n20NxdatyR4xZD51mx8iqK+ijBkf2ek7onkdRjS6HVXwuYznxn5uGo
	QBTSz5iw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQ83-0000000576W-1tgW;
	Wed, 10 Apr 2024 05:04:11 +0000
Date: Tue, 9 Apr 2024 22:04:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/12] xfs: attr fork iext must be loaded before calling
 xfs_attr_is_leaf
Message-ID: <ZhYdyz8n0EU4Hrpc@infradead.org>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
 <171270968870.3631545.18232340920205425116.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270968870.3631545.18232340920205425116.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 09, 2024 at 05:50:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Christoph noticed that the xfs_attr_is_leaf in xfs_attr_get_ilocked can
> access the incore extent tree of the attr fork, but nothing in the
> xfs_attr_get path guarantees that the incore tree is actually loaded.
> 
> Most of the time it is, but seeing as xfs_attr_is_leaf ignores the
> return value of xfs_iext_get_extent I guess we've been making choices
> based on random stack contents and nobody's complained?

Yes, I'm kinda puzzled.

Note that the dir code actually reads the extents in their
is_leaf/is_block helpers.  But given how the attr code is structured
that would thread through a lot of code so it might not be worth it.

Reviewed-by: Christoph Hellwig <hch@lst.de>
