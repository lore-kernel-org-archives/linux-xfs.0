Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982755382
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 02:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710381733; cv=none; b=s2wM/60/CxEGq8DOk+zQpNi4wLmsDjhI6tvafRQ1yUYmYJUlSAIdat/3fYCi8iMEDsE7HNGyWnnEhbTg5gGeqOYhEK8u26PU6GcIN82cUOgj0p5w1v0vdPe/ByJq6Lhk8/tneOJx0ck0V8cgfIcq8NfJ+Uw/FcmntBNK/7b7PUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710381733; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bcAo1cr/sOL757ekOVS1l4DBr2an0RtGkHpoNFc0T9qrj8ojk6gtDelu+otu+oBVXV5FUOg5pLU8nEnEFOrhCywK/rVSE3MHVWtFuNs+/7ckK7yq6WUjO3Qbsn5x4HmACvTxBZqono+Y9nU0iUG88opDGo21i0A8leMb5K/lU2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m5xGRteo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m5xGRteo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=m5xGRteodiCqVT3tNfLStiYPab
	cJNDLgPlOhhuBHrXEBQGEbsnht9vESrwYzAiGfm8JJyiLH8h2iQ1VLrYdk/Rfy8U5jUOuz38I4G9q
	ZJRIu72BH3lYxyBS+rZNjEdy5e6LNSeR2Btx4/RhJgbROVqXP0lTriTE+tRVCdM7B8yoMsPir4UoQ
	caoE3jNSFbGClFL8l0AxvMWrQq0axM+vzVm2lH8Hd7oJGnyTzC8Mp4AyYd0HOwnfJgHqMHeqqA0Rq
	2v/w/1l4UbCetuM4Ks7Ld8f0cIAwVFb/jK4F7tZ+gihnoJa7cNbHt+iRIyjNjts0EPGVBTp63QyED
	xXwjYUmg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkaQ8-0000000Ccv7-0xrG;
	Thu, 14 Mar 2024 02:02:12 +0000
Date: Wed, 13 Mar 2024 19:02:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, "Darrick J. Wong" <djwong@djwong.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs_repair: slab and bag structs need to track more
 than 2^32 items
Message-ID: <ZfJapNWdEfAsT7Y3@infradead.org>
References: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
 <171029434757.2065824.2289397432209492810.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029434757.2065824.2289397432209492810.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
