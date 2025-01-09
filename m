Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BA119F117
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jan 2025 06:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736402919; cv=none; b=Vh+84lS83Bn/1rAp/nageoQ9LnO+inueBRg/ibEA+umvNCIiq9Bj/IZJKLm7zcC78nLTjeMPe5lrbXMNNhEUGZYu23ITKQswmIMZmUzQPxwcS6klQ+awUyXtRorDQPwAP+Li7X7nIFST4t1ei+8E4lAZ9neucgOdEjVVIqJuT34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736402919; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JJNf6epO4c5oblgeprRCtu2mzuRCV8lhOD+i2nm2ag5qeMpThmiOgCl6u3awaU+YZ8yVckYQt0Y+22Re+4ciU+0M1KNX6XUgDD+rA2kIeRBktvIi/hEso2ucN/K3u5NJSYmcZ+IxPZ2pK4JPS5cdKOEfSYwyFivTL6lnuHqm8H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xSkOZH7A; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xSkOZH7A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xSkOZH7ArqsfbA0D00CmgPiEO2
	5hdCTLaf/bvgP3HWpxNfjjD/PwXqOYY8lbp9nV/W5LmSLb3HgB1UYCA5/4tLyehNFJapqNEj4Tqv3
	rIrW62NsjcEvkyuSeRpIEcijkEvmwY1tRXWKdSn9x6nq9al+2ojcDpB8RoaJik625ViQI6qhavtFq
	hPYoqobiYg7pTGKKHE4GZmVrRGuUW+fqd6ci/LughvZEoVFnAg7+987lEJZ40tPZvTIMLW1j4XEL6
	KxZdKtHJ1eYt4FcD72T3Q8PQP/Y0WkI0nmvu4cVHGinhM+4aiRB+8M9xfxB0qbrwqnQn8ZmFKJUVi
	RPPYhVew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tVlie-0000000AtVx-38rt;
	Thu, 09 Jan 2025 06:08:36 +0000
Date: Wed, 8 Jan 2025 22:08:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: don't obliterate return codes
Message-ID: <Z39n5OzHYE7VS6D0@infradead.org>
References: <20250109005650.GK1306365@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250109005650.GK1306365@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

