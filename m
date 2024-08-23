Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561FD22EEF
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389442; cv=none; b=lNdEew5/fQ3WblmgFIE1TaSefLMUn2IRyN8lyvEmD15k/Abhj8ds/spNsenx+uKjJV1lhf64dIgRrFvnV+3U11O0efBpNzwuIWOSO4UODXxsJ40Vf4qfTq4tZcHsruE3oP6CHdVIlYA6ovbM3+BxFGqB9h45mO0uDuQNc8dHaMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389442; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jT/AXwgCIs8+jsyII3c911QGyO5eGv9GIQFES6UTs09pS+68ygXMa/jLbmPjZ+u5CkmoRYNmGADj1eHYXQcycIeuuOYTLXfnda/z9EWPct2+R5UOPTQnMqOGpv/47yERj2fnpvv6s+1VRxe4788ESo1h7LwZVh9YNlILHSGewf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eLyENpbo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eLyENpbo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=eLyENpboq3gmgnozI7Yp3dOBWY
	V2UVla3L2roqBf3bqywNjX2LnC70Kr6vvwpcn7NzcmtIKVx6tZ2HfOrJJwIGmQ0lvhEc6mvozwXaF
	qFQJsR7kiGUUqgowGSGu0T348v5va8D7ODNO/rWv2OV77Vw/OnXH6UI682M0OeEh3+xQWhVDT86f1
	B+R5jjPNz5Rg6edTwbSf7AapDSfRQlUOi+yHuV4GR4EjQQFT3Zf04CezAkqFWqbxB8bzFsIJ+9sCQ
	UN0W0aqoiVIkOx2uEQRNaqgd5S6iqYsK9yEQY7S5aI6uzdcjkz4w5gQXIreDAHf2e4UC9VPfIYYDZ
	so33HJNA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMSv-0000000FFrg-0DSB;
	Fri, 23 Aug 2024 05:04:01 +0000
Date: Thu, 22 Aug 2024 22:04:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/24] xfs: remove XFS_ILOCK_RT*
Message-ID: <ZsgYQQx_gGvjqHA9@infradead.org>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087542.59588.13853236455832390956.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437087542.59588.13853236455832390956.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
