Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1906A1E87C
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 16:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716308704; cv=none; b=knpLpL1Avmmesje/rJdiYszhekU6dN4fMtzrhks2OfVqznGlWa41BgYA1AiuWJhKYVoko1JYgeeqn37CMJ5bmVhg348MLu+rMtQknQRuw8EH10bkTFiaJ6ieYOMD+59VH+zgkdofQpKAvzDNzgcFyxCq8A8TA6C+gFoOg154CcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716308704; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pDub0eIBIyfaDKNnUYp4MNF92P6k4b1d/mnVvELbWUEhI7+qXvTT7QcnJaeEiBxW1teV3j9upirLyS3A3vFa24n7QxE12IKVYfGzrRZXN5ZO2fH9WeSBhESxdhmfxzl9hhHFev2FFjN3ferqFnXzzMoq3Nl0cxv2FIbo0fpX+I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y7Y7StAd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y7Y7StAd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Y7Y7StAdYeW2zba8yORgL561DM
	S92/r419ZbrmGojE10QlL47VzfTB2J5hzEHqXXUtv/feJra7tCovq1mdhKwByuOpheITVKtY0Ytje
	6HHD1c9bICraDzh9BUbOicRbl4kvJWf0PrcXuZdGcGNSZu0Jys1Ec3qrvIBJzmgviuF+6mQjTTpub
	nL2IjdaZVkD/jbIl6tmu4BaUc8MW69y4ZR5iKxl3UuuDhiczXFYGo5rNAleDjj1K/YtIQIwyo/vIx
	dHz/ODwQP+NU+P/z6ofUgxCGcZNCnWIyg2pgpPFb2i7gBbq7/N3QAWljaD3nqq9T5bGKJEVJeNVdp
	L9V+WRiQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9SIQ-00000000Ult-18H1;
	Tue, 21 May 2024 16:25:02 +0000
Date: Tue, 21 May 2024 09:25:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: allow symlinks with short remote targets
Message-ID: <ZkzK3t_hLgX5dGqX@infradead.org>
References: <20240521010447.GM25518@frogsfrogsfrogs>
 <20240521160631.GS25518@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521160631.GS25518@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
