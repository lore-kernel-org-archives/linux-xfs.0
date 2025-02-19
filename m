Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF331BEF71;
	Wed, 19 Feb 2025 07:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739951041; cv=none; b=a3Z5usRcQHROHyVg8KMJIpkDgqu5oUyycBZe8Sv71s7lHy/dUQ+z8nzsFH399mk7CdwZeMglPfacS5Bjb8je2Po+nWhJZq5ErBPuCph2upvUvIcFdCCoJTRw54Pt6TJG8we8vJz6BPmRaLPLtN+yBvqSKy5slNn1Jfn3BQJ8qy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739951041; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QSKsi5/aB06OmO8BwyoGIOTMd/3swLzMzPgiLRQPHEmEI29uRvs7Nft3tM1JbBbEVwwiXstiLBX27z03bBWjFeSX+Ge8ALbdVmQPTqACVSo5uFG5gl54dNgYpQKzPQ6QspWgbJLc8AqfLog62EwA5AGhdwNPxTj+aX/8VFQzq+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AgYyob3y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AgYyob3y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=AgYyob3yVAKxGw8krLd9yRVB4T
	1enAuadoncMkI+YYFafViPWsX6qjKsuVKSSFmmo1NLyUR3x/S/GMhHh24qIpWuGrh32ly2U40dJwa
	PIDLtZnQHxqVqLpIN9dF9FyRZ6zk0pIlWMrxwKyxg+rggmeR6+niPMrcelChfb68q0YbMIBAq+9Ul
	bErH4O61lVXO1ZQNeV1cGJ4pPvc8qpb4+6YTaGHcrLS34W3wkxxzv61wRFGxW2YWNtfKc6so7VH1s
	Uj0RjA0gdANMAy534MIDbDw3gr9HD5JOVDNxOwUZeSvUs5mjKvXS83WCdKf055fmQKwx1ELQrJ11n
	0RAHp5Uw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkekS-0000000BJsO-1egZ;
	Wed, 19 Feb 2025 07:44:00 +0000
Date: Tue, 18 Feb 2025 23:44:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 6/7] generic/331,xfs/240: support files that skip delayed
 allocation
Message-ID: <Z7WLwKqaU1MaXuo9@infradead.org>
References: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
 <173992591863.4081089.12040886084163242816.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591863.4081089.12040886084163242816.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

