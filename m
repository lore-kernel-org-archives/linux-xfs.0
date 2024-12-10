Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06E479FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808970; cv=none; b=UxA7GUToXNk7GKhhLbHQTdHKqBzewOJMvQ0+r+RLlMHA0BP2ZbfkWBl1IB7xtTjjqeCNPQQvszmCWnQdFddB8TMrUvEkh2gtP8ThGg6/eUNVu9NKOZU3AUa8VjObzhhzKS8u7pZHI27ry7nVrNd6NRwEIRa3EMeus0c/EEnyUko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808970; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WnYzA2CMnC/5pwmpH2OGk+EmSNSfuTH7OnzJDSKy8+C4S37SGmM9k6ZAbl4aEx9T1f67hnFN5LKw3++MdRyEl/in76ebHXa1tWDLwY7H3D8ARYjFw5n0wAWWWPI5SuuS3dGyyzBH6sUvi8FzoE49p8ZC18ZBA9kWEijOSWFrDPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oVLeSo7N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oVLeSo7N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=oVLeSo7NVlVXECAyJd1iDfhqai
	vpilG3isULj4S6nujHlkMXBBzeTMfq7iKn379hAXn2d2u64QSsGCZn6vEE5kwOezXYcnHey03Qg7u
	oiSqiMSIkKEoEX0l65hbzT8Bb8Y1SIc107EMW+PXxKPoGwJ2ydR3Cv4sz13pORaYHhrESjuk1MDWb
	7kC9CsQwQc56oDSsjaAsHMjUYMOsM6xd/++4bRfTZdVwpfusrxDbxVcnIrvRM6LFqEotejkKE7xXg
	PzoFGLN15Q/b+dOjWkNvvTGzm3EP+F+lRmJ8KkVlHqL/46rNf8S1vJw+ZCYZhDRSBDU8DrIAV5TVw
	O3F7ozig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsum-0000000AIA6-1vTq;
	Tue, 10 Dec 2024 05:36:08 +0000
Date: Mon, 9 Dec 2024 21:36:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/50] xfs_repair: improve rtbitmap discrepancy reporting
Message-ID: <Z1fTSL_YZCI1sMmU@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752189.126362.11084949952818788504.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752189.126362.11084949952818788504.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

