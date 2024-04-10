Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CBE11C94
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712726331; cv=none; b=tjW2Uhnzv4j1vg5am4z1wftG3M39sdUOwWxqYm6Xl7Wa/dInh9ymL6g1Tgkc3QDYhq2ueoHVVSjt0zfT1Ujq0vJ16nw4KlngVDOP9IqAH/hOSROHVWd24PuUm3zTLbuQkHuaftYqryX6Ukwh4soAX6t9k3i7NDNF3pst5w0OHNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712726331; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cIwFqBQEB4RuKjr7J63Yjyeagw8zrBfRvc1BocQzc1/IP3nu0HzUqWhCKT/O2X9FFGTxhBrx3uU5ylxYrGc7Xe6BOQWp4LR04Ni/7erv0rCOYMx2kH8f9R7rLsmI6Ou2iVUu2sSrr6UR/Z11G8tXaAmZPdVaC4OKvjpOzI7v4PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0QshZYTp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0QshZYTp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0QshZYTplZ/7vl3ArSIT8djhXz
	7tY5Eph5vFX+ROWLTsoE9+eZWPwYxdyWSh9WamW+uOKu6lu/78hebzuS82YgCN+CeP1hkiBXrnyPh
	09hQjFGMUklgzoCXhbaYVbQXoBTzoO4lGyP5X9UPEVUn4L6BMBCHIwfkL+Y5sXxhtXOyBq2fEpUaE
	g4QWsv6K7G4ENCDUtQTEX5pBtqkQkVs5lWSs1INT4ZsxLB9kvzXr3+VnbdIL4dWVXWVrEiIaOGR2E
	OFhe6dj1KGm/g6KeuGmVoRqVr5TkexmK5h3nwrra31ZGRHow9eU5ha7DXqeE5UZwv4B08IwQX85j4
	fxvUbbYQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQME-00000005ALy-0dGS;
	Wed, 10 Apr 2024 05:18:50 +0000
Date: Tue, 9 Apr 2024 22:18:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/32] xfs: log parent pointer xattr removal operations
Message-ID: <ZhYhOuWKKVols4pc@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969707.3631889.13730441376936994688.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969707.3631889.13730441376936994688.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
