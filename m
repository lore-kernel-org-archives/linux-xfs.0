Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E23FC1D
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738907768; cv=none; b=A4muwvUYNWVPToXk4CEe0Tm3nP/M1imTFK0dy8XpFaYwfMyX/s+lC02bkP6XUl2MAD8Yu+vDACqBw2cMVF5+gs4V2dujf8TcnuWwMrlyTI7MmA3teYNb2IhkNNmzzvDsEN3xyNEyzYJW3Nu/qgHKyokh23ZcWBtuNxT+9DwqS6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738907768; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RmT4312+1Ye8bsxQl1/LNWcUfr34My7kHsPWi6bgNyxaESpPVLFoB3fozOfDKdWWSMF18Z9lLGMNQCkIQqIwGqfpN+i5o9bX+prYQQZXVm0aVZfjRTGd1HCkEnbRptqAdz99U1GrghDk2rCWK2MNxKr0G4NqQHCF56oEelaUFQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tm4mzPRq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tm4mzPRq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tm4mzPRqvLy7/o3NIEHStc4+ag
	YKPnDgUiF7sFGMV3GQ1Y1JuLE5O6Vg+A9EknY32qrzgpjWli12AAnwA/W8X6dHeg0JM2BvcCLqT6s
	YBhFnVgivoU7sl++M8SPDo6mSZI9d2Im8uAeXE5t/xwRQ3eJh/zJjWtNyPfVyXqBnJhfNqJY+MXnZ
	3qbXS/YQ0QiYJd5OhJeD1ECAOK3xvhdgDnYNOVQx3HxL8B3L6KfLpsOWWCxse4nbqYvsrRVFD00Ee
	EoE/R/nm4MmGyPC8nte3ppeVQi2PzL46ybXAUZSBX53XE8TaDluvJ/k3EF4oPk/Br/plYeVrSdqT7
	lP7tEgzw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgHLR-00000008QyS-3OQF;
	Fri, 07 Feb 2025 05:56:05 +0000
Date: Thu, 6 Feb 2025 21:56:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/27] xfs_repair: check for global free space concerns
 with default btree slack levels
Message-ID: <Z6WgdWW0AhMkr9u-@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088433.2741033.15187806936982398424.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088433.2741033.15187806936982398424.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

