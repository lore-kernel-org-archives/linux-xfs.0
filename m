Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E208214830F
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738904954; cv=none; b=JlsGr5L13j/bLSF6ucRXcL5zC8fytUbrvbCNa9MluM840u/x1pbTYJfvgnkAbe4V/hZRGVB3XqPz34OMboehuMwGdLK2N9v4/LMWaWnkdRwlse/sj1zNy0VQEIGRKLBB59LJPLWXuTnIIm75AmGkj4/Q9FVUppHAhlpBlkOOtkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738904954; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=klaAIt/ZA0NNcTixe6vxwJ4P7FKEDpW39gp/bfwIr+ZwGQUQc0nv0P+xvqFAhDqi+K6UBdSbDN9Iip9dwwIXhwN6PjidGww0E1h2pVe8L1hTBlh9wCDZAqfS1QLmWbn7u+yxEDXKYAwpi+mp5zBZO/etGWeBz2mj/dasgx73Tt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hFoNPMOn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hFoNPMOn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=hFoNPMOnsKZNTcNBGugyvuC/nn
	bQxQyr/Lm+IYKNIupJRb5BULBjNnU9b2TWvZjV6Nh+hYYYAsDwms3G/MTYWILHtYbbMcSw7wcKF92
	DmxCU9Gt1GBZ4RgWtC+KkiN0NQQUpUMxpkIjUGIQH4t9JHRjS4ZVyXAfwxlkJpuIL/WxquamIIjah
	eFX6OfNHrWq8pCXHEGIu15KBYgiTVR0rFXMMTButNJ6LAtdG3yi+rKDkrDJQdChi5FiuPU9P1nsE+
	S3B7dVNDSNF/S0ksuqIaNvRa6Nyp7QCcXaAXqpst9/6rAaDfeCIH0SALakX/iOiCR3+MJseMbtPph
	8ra88CxQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGc4-00000008LXM-2s03;
	Fri, 07 Feb 2025 05:09:12 +0000
Date: Thu, 6 Feb 2025 21:09:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/27] xfs_db: compute average btree height
Message-ID: <Z6WVeCYgyfgtXhZj@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088172.2741033.4230304960811159164.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088172.2741033.4230304960811159164.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

