Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B049EEBE
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944952; cv=none; b=hJEdqLQOTnwoSi+dzKvcN/5XtfkXglOYaChBpGzPDg7A/PKlBEA9Dk14CH5A7tCzoSyjboXsRxBk5SNERF/REMAFprgSZ9DrDPHPzcAGPzCffA3Xzw2ZlqqFWSVdROuqkGtd/d8eopx5dY6tdo76f0e3E1aKLexDA1hrYR+thr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944952; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mlGUiA3QIOfiE3fnNgSse1DoJRx/9xhIuuM4Vcp68bwVF4L24aUegKOOkm7MV3MgZq2U8MB1WhYxbSEfmOhNg4zSV1w6uUMjGWcXq3sD8vAEOO0lsp7h3LExuOc/SIPqwrOsy6tIJIoTYhstL/UcfYKlPxwbju0/Jb6kOLXjRaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QxZQTTOP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QxZQTTOP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QxZQTTOPgzoLY5bi4rcGVrNZ2Y
	rmHddtFnhPPCvRsvSCDo1r4HZR6Gynoj7saZ+jXI2laGZ5oRr9u78BnloBbAYA2aBGwxlMtdkMUNS
	b+5GKr/owWIPLsSMz9h6j0K+bV9yefDjg2UWhFNJOd2Ey97f8xtt2omxFylq454gdOLLRJz4dvhJH
	iiu7Xw5SNzTRoD0Hau+NuD1LPDVx2GE2ZozazO9xA5kCSTnw31fPLk06TtaWbt6fdOljQVhOQ/Ct1
	wy7jmYXmPMjd7xqrLdzpiX6mJ9xJ24De/xWagBzzQ9RTlFzVnYuCN7XBcao6a9V3L2JaxfAQhu5vE
	sW4Tjbsg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW6Z-00000007fkp-1oN9;
	Fri, 21 Jun 2024 04:42:31 +0000
Date: Thu, 20 Jun 2024 21:42:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/24] xfs: create libxfs helper to link a new inode into
 a directory
Message-ID: <ZnUEt3L1VyX-1TIs@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892418173.3183075.477214909437232970.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418173.3183075.477214909437232970.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
