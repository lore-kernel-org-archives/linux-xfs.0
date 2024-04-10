Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A5819BA6
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712727987; cv=none; b=eJV38aN+L/IXgl0in9nqrfFn0JfhHWO6XVrGyqLRNPWpXekC5y/fwqrr/HLWogLZI+MPYIJIFTRDpOnbhz0VyXanUSTI9PEiv1HlLAMsHF1cUOoaoUsQ9atWYMeT1EDmlLQ9OvCzyyFE0ByrEfBfJjpCpyWQT9MKBqrCeU/KPUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712727987; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=idcRSgvMwuEh17uS4EJhRZCubvfbplFDqeSWgATT01h8rCdYjrRY0aK8AGjbnmxfnXlf41p223j5fbInodwpofILT2dszm/iDdoJeRNW9EMIrdNIsYWVq3X8evkE8EFW/wcgTY9OJl35jRtWZ/vBVWbmX5NHauk38VVh1jfrvcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZociOauf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZociOauf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ZociOauf39Z8bTNrCvxjmu6Alw
	wG68VDmjyw6ip4cprN2BF1g/3PFKLlRAhKTkru+t7h/crQPjChUc68lcYgsJHrdn5GLi8uxALuT6E
	CR62EF4wscS+yZrJyojRJHDh0SPjtGOp36DmqfJhrAgwho76iyCL46ZANrNnWEjs9IypG4NzQg0sy
	Fl6oe1S6GyEee/mweS5lIbAK3kkpToHjnnIIR64INfWXqw4eU8WfwQPsM3EJW4xNppvbF92sJyOeZ
	m81TFQwMJJnZ8/yENs2JDLzhCR9DRYBFmcm0VE8EzkBKPCiZEdGpIdWzDIhxXKb10mWaL0mTHUDnL
	PoV7FZ6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQmv-00000005FP1-0dZX;
	Wed, 10 Apr 2024 05:46:25 +0000
Date: Tue, 9 Apr 2024 22:46:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/32] xfs: Add parent pointers to rename
Message-ID: <ZhYnsXVO-jE3-aVU@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969908.3631889.12708632891559407279.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969908.3631889.12708632891559407279.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

