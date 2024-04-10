Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D071C0DE0
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712725848; cv=none; b=LD5QQsVbqCUDbeQdfkAHdfBlqIR9ULGZLZGbjFUCy7Z+Ox7W6UtfV5CabxxbSlUvy3ey53YCbueTw7w95Rx4SsiS5imdsoTm4uIRGLp3LSQU9RzN6GPRI+Tv+gwVSPL+ZN5Z26Jl7NRJgiTscwPm84Swfhdcv2CN6LXfrvYn4vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712725848; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NXzS5mOnQto5gV9Dopd5+6kvaYR71EB14WBWjFjGXkgUXuLo90WvEwLAcscqocMgmrb2AftOAGy/pcahG5+2im86nDIxpLFQ0x+DFSpcOKdDnHEZ/C6UrHILH0qf3CksyE/vLdegGMr3Nge4DYcCBFKSkwgN47wd4am8eVps26E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PCpIvQjd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PCpIvQjd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PCpIvQjdbIaPlD52OzZ0d3zgpk
	WxzXItdPxO60MiNB/pxgVZaWXdCTHHXkNFdJV5Hyo19DMLkmzKHdY09R7fR+kjRcoJrJNGuI3sbSb
	cjT1QWOM836MBjR+r4SGy5s+Rdcr3XnfrIdnuwVinAal1Jy/HiKvxmxOVG8A8DHOJVypQ+KvCWdvr
	Amg38kZYUmgsYdsBL5n1f/isGdb7WSpJJubyM3JPNOWGzGI8eqkQssP5tLPC2OkMCeAlQN7wM406Q
	nROm+wNYVE89dqUkhgkPv/yDh7PaEJS5HRSQW1XbqjeKTvCWLtVtXr+bFNTt0U7VnxYGk6khJSvw6
	a1vV5Y2g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQEP-0000000584i-3J2V;
	Wed, 10 Apr 2024 05:10:45 +0000
Date: Tue, 9 Apr 2024 22:10:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/32] xfs: rearrange xfs_attr_match parameters
Message-ID: <ZhYfVVp42cavbp-D@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969575.3631889.6417849868606970393.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969575.3631889.6417849868606970393.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

