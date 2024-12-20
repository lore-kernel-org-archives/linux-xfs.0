Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B3D18EAB;
	Fri, 20 Dec 2024 06:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734676881; cv=none; b=ExhBl970e6wjnEWt0vi/ottCG1LxKO8L6xGG3/MRtXaRF30qb8eAKMeUvyfg9QCsZs8tbUDYdp9s8zxf/iRblgg0o2V8S3KGeboodCPPpBvsnxzAY//H/d+ySVwRAQRfDWS/usfEZ4+GApANJ4tUxFW3QDZMc1Doqfi7/c53uYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734676881; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AwmooNUGECoUKCoo3J1ZrwhyqFdA2YQtanr9bQoXXhrn1eBk9Zog0WV3HVf2AOq8JX3OdeAr0eblm9qBSdBOQfU8pYM0Uhopf2UzNUxeUUb0+s7q2eGx3tFnIjZPPqkCD7f241+yWuBQSSKLmlCA+NVKlQ8889UngbMCRAxRwzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3i8VH38z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3i8VH38z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3i8VH38zjwbrWstuU1FCq7iDx0
	e/TEmwsKUhiqxY/cM++COOV34CCjIyjaKpfaYsEmv2cMc4XYUY7EoJtZxLDyKHXn8Uxr7fqaNg1b2
	2blAmuGpoRGNvR5zZEZ9jeaR3XBLBoKM3MaIIVqpf3t2VnOhpc0+UCE544IxxsEA4oN/GWWdjU/x3
	O0AS/6gzfLC+zqOOfefh/EqVXtIHIeGgZZxfszt2Zl6O5yiSbfJb1OXrw+p34xsfI22TeETutiou3
	eu5Wa9VkSPXRAf9ymGdtZ1Fcqgujf7GwfOcJ/AOIGAsUT/UpHqEXRyHrQ/7Xm2Z8iW3RZqmmWx9Zf
	R/QnjUzA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tOWhL-000000046yR-3PwJ;
	Fri, 20 Dec 2024 06:41:19 +0000
Date: Thu, 19 Dec 2024 22:41:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 35/37] xfs: don't shut down the filesystem for media
 failures beyond end of log
Message-ID: <Z2URj2eux-LeL1SG@infradead.org>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
 <173463580360.1571512.2097717624016935698.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173463580360.1571512.2097717624016935698.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

