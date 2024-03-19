Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9412C5A0F4
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 21:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710884014; cv=none; b=lLaz0R9rjcPTR64X5oFbpzVqTv+4CIf0jan+e4XOSsaOVuY733fvdKWiTHfqtWhZVjFFyhZ+7Au4h2/KyX1PA0Of990pVWPVLfNPu4dnH7vsXVA8ipE6jp2EKvxfyAismykJ2ddNp6bNRJ0YwmBG/77m0wJGFJ2ChIzoEWD1PEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710884014; c=relaxed/simple;
	bh=gTuT+UdHLW3TIqQF2x6bjUMOrC+vv1GB4ugGJ8l43/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hitkS8+5o+kwc6AeLVEjnpi5bN4nA39GGIPgu7lYAuXFtJyQIN5V360oYdj/OeBDnAQSm/yeEoI3rMQ+YYuBF0PdXbzM4Ig0ntZ2zLa4t4JOgd//xnpHW0EuJXbpDTEcbInlda5J5EUcFcWOIV4J/U0D1PcAHaTEkId+PO541IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oaollk/F; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oaollk/F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1yA4EsrkaW0mUDjiIPmc0vRemzw/CSbtaSjUpXUpFGc=; b=oaollk/FUk3RqJjN0Z3I/tHlSF
	L7U3e6P0J3h8h1bTumYsu881SFqWfzHZQ3MF2pZV9XwYhDFAX4/hm3+kBcLh2j/jsIovxYW/zwT3r
	2th6Yc8Enb0VmfJneIqn2k5gO6Q9xXckokgsxs4iuG009rnnkyAKfhHYEdXNlkwlb+OYv52DIJ3NE
	A7bw4MSnFKQlAPQ+f8KPI63OjeHP1+7sMG12dnARTPva0EswlsToUxChBK4Qi8CjFyTFjE9MoIFFS
	C40Xugf9dOYxHxw2AoaEsAAQyKi5eFECPeTqrvpyUoM9GjndGdfn7cIE8LKaUIz4yh06TrJVcpFIL
	Wg4gyK2w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmh5R-0000000EJJA-01Sb;
	Tue, 19 Mar 2024 21:33:33 +0000
Date: Tue, 19 Mar 2024 14:33:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: walk b_addr for buffer I/O
Message-ID: <ZfoErAfpmQnk6fR-@infradead.org>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-8-david@fromorbit.com>
 <20240319174229.GT1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319174229.GT1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> Huh.  So ... where does b_offset come into play here?
> 
> OH.  Since we're starting with b_addr and working our way /back/ to
> folios, we don't need b_offset anymore since we can compute that from
> (b_addr - folio_address()).  So then the @offset variable in
> _xfs_buf_ioapply is really a cursor into how far into the xfs_buf we've
> ioapply'd.

Yes.

> Would you mind adding a sentence to the commit message?
> 
> "Instead of walking the folio array just walk the kernel virtual address
> in ->b_addr.  This prepares for using vmalloc for buffers and removing
> the b_folio array.  Furthermore, b_offset goes away since we can compute
> that from b_addr and the folio."

Fine with me.

