Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A2079FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 04:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806774; cv=none; b=am9tYIMHDG9o++uSuIYevnYF+m6aIgTYhF9rFfM9Xyt1KgEgWHI5ibqo+ksLxvZnhl+1yRF2ecNcuoeVF2e1eqUAVxtezvATW7jAzPzOs7KQKJd/P5E8hgmqFiXDVnu5TaUnYItsznENMo/oxEZolregAqxR/438dSiw8ZDwKIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806774; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GgntdbgO1yr3zYH7aWoo3Xr9QZDeyuKceBU3ADkNVi8r/Lj0wpQXk40Djf+XbN9n1XPfO6yvzyvleafXKTctIzc3M7CJ4M+VVr2jXvg+DXZxbR91kjVuO75y+Q1WVRqgeunlVsLRFSBUR4dsqm15axZY9V3YewR0/yIvEf8sjAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qfmAknjm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qfmAknjm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qfmAknjmSTakzaBL5FuUUMCIZT
	Rxz3loYsqNBzahVTlcKyVlHLg2qbGW6TWh3I2opMlvTs6jIP0U6FddFBbgtnYKvhGS1Mb8lNx5QAj
	qHSKNseCnPz+PQmVhUfQr9jhDyRCRZb8V9eE4vZQsgOTv7S9m08wN7PlA4a+eJrOS1B6ZGFFdsyna
	4JXu4VV60Y/SmaJECb/pMv7SJv14p3DfVhpEYaRoRjnMskaIKVQDf79YZeSjvf2RO21SAzSkYYWJ/
	STE6wsEf5jONHIe/H85+N6BFgFkDEBjKC+k9pGIcRgEsIcYm1zo7NjTSVx6BhIct/yf1IQWtvcxMz
	bYU/mXyQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsLM-0000000AEoS-1v4j;
	Tue, 10 Dec 2024 04:59:32 +0000
Date: Mon, 9 Dec 2024 20:59:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/41] xfs_db: support metadata directories in the path
 command
Message-ID: <Z1fKtM83-kbpFsii@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748422.122992.12641165649796226498.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748422.122992.12641165649796226498.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
