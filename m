Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A7C14B07A;
	Fri, 23 May 2025 05:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747977467; cv=none; b=kerPdpJkBve+Lu+Qsok3Dt5rluBbn5XF9S03n0Xmyb5dPJ4ow7SpbI0ogkrkpqM7Y8/aDaQwHBbVqGFwXtqqgD5dCdFwt7rEEnM88HV0IoPZtRK6uOgLA8qWYU5xTy6qVvkJlOuOx4WDWkS40YDoQI+GdPdS5tTtH6N5Gf2Le54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747977467; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tiL5DkCdS+EJ3ItQV7EwYZP6a2/SPopHt0TX4v46AuxYyW98N0sQD+dmR6HOcg4srF64uJ1rAZ0HbZjAamm8As0yFPEnhS8g3y1GDnB0/+Mry0RwNadEVY5XlvT0xtx8o8wg8kHBXP6pw7c3Cfw2JfvzZo94QkDpcwN5tH6YnZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3y2BHT4O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3y2BHT4O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3y2BHT4Oap1dYOFF+PT9MHQrkD
	NeybACF9sMu8X51irbEwFUluXR0f6yyhCeZ9os/sc+vk9Z7xCMzrkwfOx1oIG2L0xpleDVmEkjHtP
	Toy12t7EZw2iyN61mZX33yqF/9khWzfCicanzRt3XFGqNQgLOGsS4ugcbhbMDAx6PpIkkgjw8eU+F
	YhMDyvLMj9NmVjpF2pBY4lLASWhEKdbzUjDy6eZUS2fX/1aM+v0PoTwal69yI6/AgwubH/WnOIFBj
	I/MMQn/OoFGe1dk/yKtanCHDpWCfVuTY1wb0GrE5suJKEsFslg03ClmSc5veSizU9/STh+B0qXU7c
	RsD+WKbQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uIKmv-00000002yuS-1kfr;
	Fri, 23 May 2025 05:17:45 +0000
Date: Thu, 22 May 2025 22:17:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs/259: drop the 512-byte fsblock logic from this
 test
Message-ID: <aDAE-fyttmRLPTtl@infradead.org>
References: <174786719374.1398726.14706438540221180099.stgit@frogsfrogsfrogs>
 <174786719427.1398726.17422210804621368417.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174786719427.1398726.17422210804621368417.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

