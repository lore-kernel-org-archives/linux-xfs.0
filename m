Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1512825765
	for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 06:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734677008; cv=none; b=je+CAzzlthVqHZiskuAeZv5u+DDEGOiyHDLzABz9UKCcJRNjZI5sUb1uCv6LYnBhVqLJ3c4sN0Lkq3Aclo4M5cCpZJg+W52+sD+ej+d3Bikgd/hcVPmqIpReh741aQI1WPaEeQ5zq6JDEmezV/HJl8cNWaG0JpI2reKMXMMI8J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734677008; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BDDvsUzkQu4FjBsAQ+eGM+T3Hsdl+TvNThyT3eb/9RRWZZi5o7OUS+Ymi+7ipBnwLIBma5dfWqbNX7Ck7CCbHDsu96+a1iqcKYtr4usiWojpHF2Uk1w54dw8KEVCh0FB9mz6GX0SbfZsTHsAK5y+23E4bAiYMmAhU+82g6mFKkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JWg9vFJ2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JWg9vFJ2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=JWg9vFJ2NxE+nTLtS9WpLT2zkW
	FNjKi6QYhstpr//sKpX2agVLEomQJmQFXFSLPb4JjKZ7+JTByKQI5itE6chGyXl3rnxgY3z+bbSFP
	IwoZ0uYN1sjBEi+A/LNCgaPzRDPKnT1i4jxlbuLNPHo2t/szqMj2zPA9J2oTsVoCavJwn5wYIknv0
	fWOUef2Iy3d9+ATmhLEFpxfJQxD7ovi5EUPiHG4Vw1is82YAU8KMC7qEbGkk7j+6x/VwS6zUr9uQO
	w3Hoe4X6joadzd82B0Lkr0UvoDYIjuDAO+RWr9qAabZ0gIKJlGYW5gBd8aBfr49GFGePFZuBR4MsE
	vZH5W8rQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tOWjO-000000047A4-3WO7;
	Fri, 20 Dec 2024 06:43:26 +0000
Date: Thu, 19 Dec 2024 22:43:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 43/43] xfs: enable realtime reflink
Message-ID: <Z2USDtNp6I_-f69V@infradead.org>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
 <173463581714.1572761.16587749308470053999.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173463581714.1572761.16587749308470053999.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

