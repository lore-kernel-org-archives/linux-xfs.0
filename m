Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E6F43635C
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 07:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768979306; cv=none; b=k7rhzC8BmGO1HZifqmVdscdBTVAIeGUQY9cwq12JYQYnQsbaIP6QeWEUiuW6yVADI/pHkw7ZZVjuBtY+c8HBPCt961zc0ARloQj2hp7+SYG8/cujlepVG8sOSCVnNPpnakfHPggfv6Kn3+UMcYeLm8ish1TsxhVNS4Z3Bp90c+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768979306; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZxtaHN+dntPrpeRnFvPgjA7FQwBExwt5ev4iWG/saSvkXP0AISFVGlZ6sAkiB3HZX3aUabUMoYE+xA/0RD+5RKK92wT0ODR+Zs+aFlCTwxMWFI7S26b1EgXN6Okp1a3DOrkH4QqP+j7HcvPWfMV/8RcNu5xhz5PYooKCdf9KdJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GtQWR4kD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GtQWR4kD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=GtQWR4kDCoFbiXKHK765fnHwCl
	EpQH8s/7x/e5pZeH9iKboPXc+qPwrnGXsWqsj/WqiYfgQg7vVBpDKSShNcAWI31IeeYYCyNYXeryq
	3jAqQc2t+PLgDswIhWbbIT3MZc+UNTQf13tR3++Z59tWIy++Xpw9eLwl56lEo6t3sgWwkmYWx1pJt
	oO8UDry3XXCH6CFnXS/TsJSOQjpxDP5g26CGC5OAWapov5Hj6W7FUxN1/95TuyDHNCspV/hPusD7Z
	1awHULHSZN9jSopMfLiRyBSBZ+rlp6kcTH1sYT2BQkgY1DnRFWCIgQnaQnxr0X9Xd/PwmYUA4KuOY
	+v0m++FA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viSKG-00000004zJw-2p33;
	Wed, 21 Jan 2026 07:08:24 +0000
Date: Tue, 20 Jan 2026 23:08:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] mkfs: quiet down warning about insufficient write
 zones
Message-ID: <aXB7aIA-pdfmrfxN@infradead.org>
References: <176893137046.1079372.10421059565558082402.stgit@frogsfrogsfrogs>
 <176893137126.1079372.2017206002280736908.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176893137126.1079372.2017206002280736908.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

