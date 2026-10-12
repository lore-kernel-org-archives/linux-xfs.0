Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710D1474263;
	Mon, 12 Oct 2026 12:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791809169; cv=none; b=XLqXt6G1s2hFY1JGaIs3kvBlKjpiIfDGxaVI1Pq8JUdnhhRSzcVlPJFN1QDD5Gp1AzDZ+yyQrXMvotmWVaBGmzCGqVvKvV//g99HdiKMecoYB1RN9qLUY2GZqEnPm8wy/ZX6tUARqR0bC18pYaiXT+ba+Q5el3XqbnxMxY+ZXtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791809169; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UP+SYwybO9d5E9LOWv/Rw64+MOlAzOrJD80c8xHMDZ1CZ/6lywGjfrg/Wc3PVzAxxrBbdgsWpXAjf8TfS2jPO4SOyTdzJXiaaqcoX4uG5rM5NVVcmwdnKHfrktoD9k+UZUBFuSOMf5WHAyOeqbbUV1AHOIlsvd2hLqtGbFw7aqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Pb4ehOoQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Pb4ehOoQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Pb4ehOoQ75I5mYxfUiidk0aZxV
	sLFU+iO0EnDH+m2UJueJ86oA6ePzn6Ubom4tyt69tr3CaZ1FwdEj8x816pWzerg6/OZtc+U1tvOv0
	TiDCKqz8/DeKWmjfAvy/QvwGB2VARm15ApwfUlNsBazwvbS5U+r5XThHEqK6Bir/HO4nfvDTvtus3
	ZgyEg5iUGhNvcQ5T2p7a0B7hnSVGpwG1aqQuW1hwXJluxrWKfFwwFk0K9vc3n9VL2MO/3Iovo3XPJ
	+NRCrnLUrtk++htxbeusLnCC4WqQn+4u5P2iH2obyzyLwjIIMt5+gkbevz03k9qcA/CDD8B6qUFYi
	33tUsZ6w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFPs-0000000AUlY-0e3P;
	Mon, 12 Oct 2026 12:46:08 +0000
Date: Mon, 12 Oct 2026 05:46:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/13] xfs: complain loudly when dirtree checker finds
 broken links
Message-ID: <aszWkIIuZCLNIurU@infradead.org>
References: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
 <179151614902.3163896.7168931003277489322.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179151614902.3163896.7168931003277489322.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

