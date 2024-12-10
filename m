Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663AB227560
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733811470; cv=none; b=fc0wOW1HaN/SjND2zd9YeKmG9/MPldp/LYLEZX79zpYB1NOIA2KmfmvMcw9SsmLqTebgAXpzN139AgwMxGNx+EMbrEFb/McWbHtKyx983gLyJQKIfHRRMYTNZQ/jertU/Onm7tIN8tz0/pnsjcPY793M7hGFJHGD8Ritp7rBH9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733811470; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hx/AHKM1QEgLlPuXGFSjieZ2jvy+aWdl0fgRtIKUDHRIp9vpOLNg1kTctvxi4uSOUi1XLQ3ZxHjimFQeIcRXrnpnH7jkuqr3SCYJ00c0uQhHJxz749+LLAZgQckLsl/DF6RAnBmwLVpz9RH2g8P0QHFXDml614EDXWygbtd/oCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Q7JNeSCb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q7JNeSCb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Q7JNeSCbk6LK3gZdhmgSygqjLY
	frp0Auca3uePX3vsBrkDDR503qoF4XjqMTwkBtjdwiiHtySkjkLRbnrD2cUopH/H0/DzuR+mIzH2f
	Hv4wLVCPp1Hg58y8WzB330x3XHfY/QM9EIrLlfgjrldQAb/fjJQHUQEgEUmLHRsm9sE62pHauxoQ8
	xzww31u7mt/Go9DWgPyzyaqhPB86Sbcqb8CewUB2qnhnKJAMkcoG/mEmqrFP/ol0jhSy2g9dZ59JZ
	iVfuvJBvpB3nbrPu2km9GmGkVTGimKr+r0GBFR4F1386JkM+5BXyIqA1D1SFSiC9Jit87XdxJi9Zf
	FuQMUj9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtZ7-0000000AORi-0HYG;
	Tue, 10 Dec 2024 06:17:49 +0000
Date: Mon, 9 Dec 2024 22:17:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs_repair: try not to trash qflags on metadir
 filesystems
Message-ID: <Z1fdDXrkRnuHFkBH@infradead.org>
References: <173352753222.129683.17995064282877591283.stgit@frogsfrogsfrogs>
 <173352753324.129683.11573020537942192605.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352753324.129683.11573020537942192605.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

