Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084CA21345
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388824; cv=none; b=DJLuG7m/1EGjM/8InjKw99emOqBQQEy0SB5zKgnNLfErGV5WyRA7iNx31pcnL45R0fcYYbr+it7Pe4IW3SD9bSeGCUUem+fc6o0rARwY8MbWFCitDYrY2me0MFIf4x5mHuSdAfWTva8Mo91qaPuhSD6nO6xGtn1F5ieYTtok1Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388824; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rGhp4Ht/+nOZ8vvDvKG89kSdhyfOY50EtUHcpbYWo4RZaBaB49Jum8+a5BMu5G/YyRa65ymwMe/KdWceWJu3sPqhDnoyM+8G9nLxTKKYqWvlVUO3UekbBjTStLvR/vlTPS72WwBQ+ZVfdqSeYy/+7bshu6b8pysavMV0HESSc6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sn45KB3s; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sn45KB3s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=sn45KB3stop/ZkBkrYiAsJ5xWp
	D78rfD/1FeMfANxdYSvUMtEzjE0+hq7KvVVHjzvFD2tgu0llFq1VBWWoNaDmJVkoyc8jSvBi88kUP
	Yx+uDpieIlBRbM1n4sjjN3KclZutpv44A64oFDBQMlk8ZmsAkUvItSReb3PYRoPRK1nv+lS+EV4aJ
	TjFI4ML9t99+AG8NYiUqFQos9ckky5LEYMzQuzxlp0eEmJGAFuPPUTTr/5LEVAacIOZ4qlzfVVGu4
	6TH/YAsyu5bVCFnqvJBD5iksBrZMl+5aaCgCvjyErEnkWylXXzhjQHkn5hxML2+Pxt0uxTQHTL9nt
	c5ZcsKow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMIw-0000000FEat-2WzZ;
	Fri, 23 Aug 2024 04:53:42 +0000
Date: Thu, 22 Aug 2024 21:53:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/26] xfs: scrub metadata directories
Message-ID: <ZsgV1mFY_GvfAkUf@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085535.57482.8296127723634916281.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085535.57482.8296127723634916281.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

