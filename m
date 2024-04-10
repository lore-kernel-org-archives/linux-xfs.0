Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABD228684
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712729556; cv=none; b=gbZTfSaQYOT1LRNeFxeUHx630ypH7jGXV6aGDFmQEZ+ykekKbDe40/lRUEp1JOyzr3xp93OHDqZZR+U+o4mtF0A9rraxTNSM4/qXB1b1noIhNaMk0SxsS3Gi/5MqHS0RnLaRRWRqNcSirXP2EttLvizVylS+OgB5iRbICqfa07k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712729556; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lVupLAdRU1N7T/a+V4BENwloFXshUHPIRYXvI2rkP3tkLVa4993j8eru0kQMOyfXSJZBIQt1z3SwGBVyiJJoSDes0aDq1+7Ex94o/jvUsGyvGryJTGL6CuXio9jXNcr7SeNxOavynmnenaPzk6UZlyeBJFFCHKa6nbJTlkro700=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Q8xuI7Nw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q8xuI7Nw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Q8xuI7Nw7IMcSccAUhvVJ0Oil8
	XqZ2i87iL5lGvBLOP/TpR8nF1F+U8UCNFsKUwkj8lMr1e9k2gWq9aWo+f3famF4UfSP1/pYMSiRX3
	8a7bJEw7tGqKQqPO7khR6Yd2cXAUC8XylpnbD2BwKfn6sQZiXTSBztPoH9blIXE3HAFg4i03fsMOJ
	gqGwJ5XfoRg1csgf0Bsn9CPf1pvF+oxQMv4r0Ew8jU4ph7/xZTMk51IjlDGXt6VbUHuKwmvUcgQxK
	6NNThNA8VbVTbLDC4eKtd9V0lri0GscxY5CNKzpjVLtgjfcPlRlTcmAKyEizXd4xXR9gMtXGsJp3U
	vdby4IDw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruRCD-00000005KNt-4Bov;
	Wed, 10 Apr 2024 06:12:34 +0000
Date: Tue, 9 Apr 2024 23:12:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: check dirents have parent pointers
Message-ID: <ZhYt0XxD-XRMS5g1@infradead.org>
References: <171270970449.3632713.16827511408040390390.stgit@frogsfrogsfrogs>
 <171270970483.3632713.2430218014853007760.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270970483.3632713.2430218014853007760.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

