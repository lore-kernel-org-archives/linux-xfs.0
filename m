Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79CA1468F1
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 15:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709049011; cv=none; b=FzVVTH/K4yGEuiBPP5Fo5/IhTmqcICliwOVXVnasKU2EJ0aX715BVlaTevVTIFJotLyM/BswrszPjpnq+06FScDS3Ovd5M9n/mrxb68xSg9MjpaquJ7+gKrPgveQT/ttbDVtOAgIlz3s+h+QkjlBMBiGfCnNj+Lc2kuXI5CQUpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709049011; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mxzNziygY7AgzobDh+WY59sP/XSpy4XTV+35i+nJktwTnwMcI0413Ejg3TAnugdhujVI8qh8RU8RNc588mkVKz1Q9iogfZNhHrBU+KGkPighKFw8KAYs4VuMgb/jXoZgLylRLaQLs6ENiCmysVMgx1cP+AhnXkTd62NZS6KcBd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rtlFni1j; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rtlFni1j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rtlFni1jgmkTL+S25tBSsWhd89
	FWWDcbSD1+dLLL6mcAzlZ4EVG0g2JfWTbfODiZOw0xtG3m/PLEE4Db7TG99ENjtB2MOiQSOiaDNI7
	+3Z9KooH4PAv70uFmxTGIul4lUP6xj2FPH9bZplwLjFVy3gmPHX9d0z4RbmORiIMA2VkuOI28W34M
	q+VVfLbKOzZ2Yv30/bUnNKFjuFSr1n9VSvB1Mlwieoe5PT/Xu85LUGFN33+M1Xn14emh5PMw3+21L
	/RK3QuVLDs6k8qjj4CnfsI9Mf/0x63frkBfuYGdXKORnGJdiaPmTZYZhbfyUX9NGKazk0RUqyGBYC
	xmPOGAqQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rezib-00000005rHF-1o9p;
	Tue, 27 Feb 2024 15:50:09 +0000
Date: Tue, 27 Feb 2024 07:50:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/6] xfs: declare xfs_file.c symbols in xfs_file.h
Message-ID: <Zd4EseZrVSr-vXV6@infradead.org>
References: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
 <170900011182.938068.18381389908075575352.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011182.938068.18381389908075575352.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
