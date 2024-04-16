Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3C5381D9
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713244383; cv=none; b=VXoRHebcdJA7wWzUGtZVuYe3LK3PmF6RVTcKsdlKjjaVdu/43KN4xdpKPKZiFcreXG7TXWJGedaZVIGM3eewxsQ866aNLLXccqXqngMF/KHNe5bOMn6ZCWjNsWowplulJjRaGpAuQXmF/ilG3fc8RZDDn02Aopk8BlzfzIEF74s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713244383; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tJYpnzbdqbBFMMnMvWSt5Dd3EF0SNL+iJj3BO5O1LhI0Zn4VQpmP1npB7SYDuZoi61QK1z7hDLC5dMF4f2QfkdQOXdxfB2//c5KWE0RoJuBFdq24WBciCqX3PXjGJM519A+CQT0IuyWKDO6n1KXrTtxin+7eSzVMcjHd3g4u6fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RdFZYIRz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RdFZYIRz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=RdFZYIRzjnn5hgrHcD97Xwvs3N
	FL2zMqgz3seITvu4jEB9B5cYtW7mV0Gg5iGnSu6ESHWmqFPk7v7TVh7IJ8pb0AzNHdxspq6r9xNRi
	x36CFNu7CHWqsgisEgzJVuuMDQJcDi2o1FrkqqAcdE857WZ1abQEyvAKYyByS59/Vp0NL9xssFFVe
	OtEP739UewqVZf8q9vFg975x190kR0bUMPu1pHwjhgwB84hXVgaPdTwiHlYZur2Q4BZCeisippW1K
	M30vpQ0tQ5VJQw412dd9cG5l67KMO4w1wQ2MXd8L0+xud1l6xfBfXe5wI6sWc9zHlqQiLHG9iuKp2
	7dQeY5kQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwb7u-0000000AudP-1zuR;
	Tue, 16 Apr 2024 05:13:02 +0000
Date: Mon, 15 Apr 2024 22:13:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	hch@infradead.org
Subject: Re: [PATCH 5/5] xfs: rearrange xfs_da_args a bit to use less space
Message-ID: <Zh4I3m5bkDHpclds@infradead.org>
References: <171323026574.250975.15677672233833244634.stgit@frogsfrogsfrogs>
 <171323026670.250975.6441911970898087708.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171323026670.250975.6441911970898087708.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

