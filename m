Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8006C38389
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389057; cv=none; b=hIPwsAutqj4E/KSc4UBY3LAx+K1o4CY+2N+y5TbZMeFrBaB/QScZmxY8iQ2Aq+G68GN0bRGknrMB7y7mu+hkA3sukxViZhiBe5LZdwlim2gN+XAqBfcIRaJoiMPPLC+piNRk/ox9RZ5a3SosX3NeXhkXCc0FixVs+L9cIqgmCDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389057; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bICPgwk0SDACOK69nqWl8FnOpyJxJ9ti0fjniQHASi1bIjrCOkVAWi6MVM+SZUidu2r9YVmF+gD6lAKr3YNw9//ObMdTzPwwBsNMik6NDk98rBVXXQhQf+DqehIFARxlkQ7Xsz+XfrzMoDwzIhV7rsVZG19zh3frunNZXFO62qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Br6IXWGW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Br6IXWGW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Br6IXWGWj3J1DxPtIi1jTC4j7Q
	Me0td6PHKs78h//XL/jy+MgLMXFzfgiDC/PpxqHhdQBhzpSh6IWWckxqkGABzI3Sm7oSPqDNGowiY
	4NjdZzN51/0kko/9yMmVyOjhDrDAf20K2AZ1eBmQdss3nk3L7Ry55jHi+Bu6RRGCyn57Wc8OKMT50
	A3SOXbaE336+XeRJENTBF5xOER+3YJVMtGLNhX6q4T2kgwuNFyUkXUXtnlbHebna42Pa71Z/PsQag
	qWzlMS8mYtIVRe+wyN+oldVTd0w/ObK5DNtcMZ19G2m84mH7qNT+/INxGf86iNWFSwxq69cmdZh61
	Zm8eAF3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMMh-0000000FEwZ-43BU;
	Fri, 23 Aug 2024 04:57:35 +0000
Date: Thu, 22 Aug 2024 21:57:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] xfs: don't return too-short extents from
 xfs_rtallocate_extent_block
Message-ID: <ZsgWv9pAYJFlcTZK@infradead.org>
References: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
 <172437086668.59070.5713338461091119042.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437086668.59070.5713338461091119042.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

