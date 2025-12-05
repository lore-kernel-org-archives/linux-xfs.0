Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DE12F1FD3
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 08:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764925052; cv=none; b=E3L+OHQwfqidxzfA0wbSITpFXi+ZpiCchZicDTbn9FWUo7sW+YMnzFPnLfZK8F+3XBl364gBAE4vShU2ZFr7qyMpW7lniPDsb+rVof1/9oad3zavT2KPCI3y/wlBsAEbW2SoDBZu4/BDkMcSx82CCf2pbYiF5KfzxCZkUxSeiSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764925052; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L8wMT7xDfrn66i0VdsrRzxa9mLK7mRsi1oS1WuTqDwDQO1LInzOrgXZHioWuwmJjVYLXiWlOwh4j+Xnn/nEYc1wrgN0IJ/R8RleOCYvBP+6r60wXzLui7IkxP+4G8P5epuehb2M0mbJMIUQz27CnSEwR9p4NegwWCOQdYGlPQCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sy6MbRbb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sy6MbRbb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=sy6MbRbb50XBDzQ3mlMxAokN2s
	Z2nfPZrDK5FaXqwELtbkU5fgTPBMyeKWmKJTOPGI6SS6KKJpdqMF2EFIGMZ0DsSIsLF8lHiaNjZHy
	1KMeriWKULXhBUKmi9PyxwsOcwocTPfjYCYzfGiYBn0Cha18Wy9SOnh86AohPl574Jv5YjKMyrhLi
	e5kxvqgpueGNqUyJH9F10DNcCz7t8y67xUkkqO3UzTasmeQjPDTSMbWPxM+R0J6/zam4u76GMyQKq
	doHC6xX1u7P3WpDTA212IoJC7oxZ2KghBL0wbuWyMvYpAcLX8t+Uy9LMNQ5sWs0828FYwxCmzv3ok
	KCTyydbA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vRRcn-00000009FUw-21kz;
	Fri, 05 Dec 2025 08:57:13 +0000
Date: Fri, 5 Dec 2025 00:57:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libfrog: pass correct structure to FS_IOC_FSSETXATTR
Message-ID: <aTKeaT6VwqICIDQP@infradead.org>
References: <aS_XwUDcaQsNl6Iu@infradead.org>
 <20251204192827.2371839-1-arekm@maven.pl>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204192827.2371839-1-arekm@maven.pl>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

