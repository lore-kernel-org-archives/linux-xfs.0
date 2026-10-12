Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BB0413230
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 13:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810416; cv=none; b=omQZXs8Kh2qynXq4ipNaSTGKtVBLQ6RU5ErMCQNwyPcHIADbQJKHbQVb+GUL316QVTvx+jxsDNCz+H3uGFe6ZWAvl61CG9ugBzpZtmX2s/dQ/fWEQMH4+D7+PQ+K39NaLklivjM7LXKSEHPSI7TBdiJP3X7tHAgg85xR4KVVVWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810416; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZfsgCLRVjFPRsK2iK4S4WW8VAB3eZJxlHVp9B4JOWZtwCVRLlYhK128cMUBL+CaIfBxX0H4YxKCnK99AqX5Kix3gTPsgkcKbVHEiq35YC9TS2Ndc1Cryg4EiUUjLDlwIUNnxlSmJ5h/YAr3BCIWXzN6kUejvycq0X02Z+ZiFq5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vMZkVJ8T; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vMZkVJ8T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vMZkVJ8TgiI2LrF1/OofkSyf7w
	eEVqwAX3s34BctNASI7DnVMcX596ec20nBkPTBXt9SvLv3ZZsTT0kzlC8yQ8dGZMw4wIFyxBwUuIM
	gGHPE2PqvrwSTm9rbO6VcckN9WXZS69yQA3pTtttdZcBvruu05G3SbOwKHjHjL8SLEjaeH+rVaw4W
	rGs9iSwkLbHGpkELM8eKDDm7gwwbBdblJQ4/AlvzHJAB1fZPuSiKF5e41xp99A3nQhLrjx6UvUvK/
	rocSGecQDKvgSmC9LRR9SbrlBQYaxLG4UWemwdW6iHusXJlHUoldA2HnTqc+83Me0Y9YmYuLgun6I
	3JXh3oFQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFjz-0000000AWwg-0uoR;
	Mon, 12 Oct 2026 13:06:55 +0000
Date: Mon, 12 Oct 2026 06:06:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: avoid oversized space allocations when
 regenerating metadata
Message-ID: <aszbbwXLzHZoHQ8j@infradead.org>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
 <179178065259.1058326.14882859370057319539.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065259.1058326.14882859370057319539.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

