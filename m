Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D75446BA
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711431927; cv=none; b=sAwLVHHc6JwE9P21siCPIOi1O3iXWp/ICxdeXHAg6V4uuOfk4kDNK/THGa3ZOS7c1M5hZGmGw+Fj69JVvOGSdXuUUcwAIbRc6cWN4pKLNCEbHyI0w9qtYrBpflktl033LcOn0dthqOR8//73dzt6GmUBa/aIr8LwwwZb+Tthwsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711431927; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IcSZvaDRKeX+i/Dfp+K34XJjKOeJd8nq+9K1lionPt7QNFiEXrnfZr66gpq3CY6+sbYbeu1r20fE/zeWKuYK5T5rEiUFEQYvM/y/SzMFOXJGH2sFvTM6c5aLwPy68xuQNgvmHDoetdgcG0Vr5wuMHzKwCZ86NiVptvJP4C3tFKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CdOaqKT+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CdOaqKT+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CdOaqKT+EoM3+MeVbetLVqjb0t
	E//cyqrKRdloLeN7hElNYvUnKH7Dr3JLJLrWOYRFQIjTdaxzntLFdTG7mWmPEnyLzD17yvdyrQaMA
	FXcS31zsvwZeYzoshCW/IWqipuw89+4/SHXuMKHtt6jc/y5pYWY/lmRIGdznbAQIbNTM0RYTJX20w
	oOZgLQG46X5gWIRqfvjP41f8T9NpUmOwxnsS8DHsIULvKJ0BnI9/FAwhXglTjcR2zPZUVZ4JKssTc
	AzG7fXTcKxUyvQDyvv1rf38JfBuJKwI5obdMBAa0iJMDSjxvRNmi/jPnSVZKlBnvBFnilGDObZlTM
	e0VVbZHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozcj-00000003AkC-41wf;
	Tue, 26 Mar 2024 05:45:25 +0000
Date: Mon, 25 Mar 2024 22:45:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_scrub: upload clean bills of health
Message-ID: <ZgJg9QMvLyVXydjk@infradead.org>
References: <171142134302.2218196.4456442187285422971.stgit@frogsfrogsfrogs>
 <171142134381.2218196.9137573800975210117.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142134381.2218196.9137573800975210117.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
