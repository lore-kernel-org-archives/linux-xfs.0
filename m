Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E6F7FD
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738903595; cv=none; b=rGSsWj9t417vAcPVeoZ6qvm0l2joZ1S8DWNS7wJTsiIXAjDKVFyWGmOvBPtqN1Iy15SauIiftRcZS18wDwIH8U6ul3IkrmWfSb6ahCWBnyUT87HWWsFZ7AUz5eir50G4Qn2ABxeLw8lNp/aDeYj/1mNi2Aw+BhmAchVcdYDH6CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738903595; c=relaxed/simple;
	bh=FFzNLCoaG+SC+8iL4ovgj0kKLmjVd81CPhNxm6spDS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ofyq+xBtiVr1wEBSLa38QXEkOooc2X5skj7pf/mBG0/bAT4Qe2/HNCZu9CjEuvTDtq4G+nytoTHSSDmY3mr8lx4m/XbKvDJdQ/ONNGUxlldH4okOIb88iAG5SNQPPyVWWSoSxP+KThOKuIbPperqNlEkoWBx17J3AzObJD13XJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wI01yDfD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wI01yDfD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FFzNLCoaG+SC+8iL4ovgj0kKLmjVd81CPhNxm6spDS8=; b=wI01yDfDlqif2HYOm50tdb4wbv
	2mQmYQ7N3O+xQbNZ1fks0g+hs7Mov4Ntp2N8RRSvfAtuQf0NLz9cSpL7yajlLf/cXTe6n67ll6U+q
	tkmhlLKArArgs7Qx0jg/msKIj5uAG+R4alKinNpQ8xqnPPEmGzLTU1QHZI5ajp18Y7rFznh6FOFnR
	bWrrAZLVsGI/6F1fj7KXtprJFnCjKp0desaw+H/5gF3wvjZlmh8VzqvsmOPPwsQB3eJhIF328cmQo
	q05FdaceExlWVL4G58Gn7zGYkBpiGVVux+rzAcHzQePJ13oD3VZJq17J5RePIsQKqI29+ySShNRpL
	F+KXY6gg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGGA-00000008Jez-1GaR;
	Fri, 07 Feb 2025 04:46:34 +0000
Date: Thu, 6 Feb 2025 20:46:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/17] xfs_scrub: don't blow away new inodes in
 bulkstat_single_step
Message-ID: <Z6WQKi1Df-YlODzi@infradead.org>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086274.2738568.5398591109789938783.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888086274.2738568.5398591109789938783.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I think this commit is the best indication the inumbers + bulkstat
game was a really bad idea from the start, and we should have instead
added a bulkstat flag to return records for corrupted inodes instead.

I'll cook up a patch for that, but in the meantime we'll need
workarounds like this one.

Reviewed-by: Christoph Hellwig <hch@lst.de>
