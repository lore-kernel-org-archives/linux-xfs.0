Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDFB190072
	for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 06:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740031607; cv=none; b=tMq9+fRtbFieOzOdjKgl5a5hznMD8KsbBX10uko0MioB2M7n5YySXiRVihbR1p411ZS3a/Id2myl4H/YmJjJcwfC/kcFbF+YF+hkg99r0ATH5WLUeeYUqQZjRDpAZCsDWm9KCZNR6e5n3sNLk4U8M7+z+JL60x56UQ4+e0IWhec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740031607; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j0NYMdLEka+dcrDSyxrXs6jgLaAy6cn8GdFI/1OQuw1Gq0JzhMlWuoXgv2bs8sFmleIpKMKmEqcLlrBIMP1SpmCj0/lKWRjCGJFx9pJ04agghhJ+vFxS+nnvLFXN2kd8cMT+r+wYEo0BERwMm0Wf20ioE3cy6ySTBj3oVoHXKmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fuvHtl0l; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fuvHtl0l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=fuvHtl0lpI7cwiiB4Qx+sujsYd
	bfsV1Ut8QNDuVVHcPj4BoCNU4Mw0waxKOXqvUaBWWLbe0PURfYZ7vbnncCdnwimvOMI9eTi/1XeOv
	GOpKktreaZY5USWvZpaOU96yC4LVeFjqJsYIvs5iF2RJi/FLQ1+QBj+2QIYaPx/jFFMJPCNmSZ4gL
	3lEK1345e57PqRXh6hd/akQL5j98IVAATKa0WeFXvbhRIv34hzkLwg3UHOb+PBnNLaV831PF7/6Zj
	gZ7CYVb9diquHKDOHp0kS6ZlA4O5MWy0Uh2rWH77n+vEBDy1E7GmLPVOHL/4MvMlkAFrp2DtXyQ1A
	gH1dtXMw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkzhs-0000000Gsc0-1AKx;
	Thu, 20 Feb 2025 06:06:44 +0000
Date: Wed, 19 Feb 2025 22:06:44 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] iomap: make buffered writes work with RWF_DONTCACHE
Message-ID: <Z7bGdFZitwCCSJjd@infradead.org>
References: <20250204184047.356762-1-axboe@kernel.dk>
 <20250204184047.356762-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250204184047.356762-2-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

