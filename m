Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9B038389
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388973; cv=none; b=kpKVDp97F8eVFTDoLTsSDMKDoSvf309b1YFHgdxNvH0F17HOi3yFEvk2JrVTFT9+NIjtZWt4ddYdh03fpG/jfFufWHTvwx1Ok9oijQQAuY6qwYgqULM8+WOmpJiFIi9ysBBJca0YrFNAMzgJtM3sz3kPsLrT213x0jP9ga3tpZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388973; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j2EpVD9ntmF+J5gicwvGyLaoRUrMoJyzoE/AbvpXwf74OUlykhi2n7EZvqJEt5/yw6bJcaszpsKTI05pCdWWf4grppPM/H9yrXZW4oHDnBGFgPvMYz+1C0mpiJo8gVRpxeQyb0NkRCl8ZXHNeAWPx7T89jS83FrgwlDmmL4qgFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0FCRbj1b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0FCRbj1b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0FCRbj1bfPvao8BUyTk1Lm/mMM
	9w2VWNR6Rdh/gWHy9wvxrlHPnpz2ng93mun8o4ArKKMs9M2AH7dZcyCpWFng+2rAmbWYDM3/lkSgl
	ZtVtDknF9vk06FYNj0JIv51AMj6RiFbjilqqpY5II4cd0idd/xEJ9CNzeMbdE4q3dJ4sK/WKPQRpZ
	tP8a/N8YDFb4LgOXi2vARpLKEdyla47sdDnvglmNA1KbJ/y+pc7kYy1c90v9P0OROJMbjYYMrc8MQ
	Pdd3IXu8fH2ND1X9YbwzoMAXM5aiC9D8MCmgs97Wv9QqmDZaTuE3OSP91ZjWYjdz9ghApJeQmjbqq
	B+Vc3VXw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMLM-0000000FEqo-1Naz;
	Fri, 23 Aug 2024 04:56:12 +0000
Date: Thu, 22 Aug 2024 21:56:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/26] xfs: repair metadata directory file path
 connectivity
Message-ID: <ZsgWbNAdcgTzCcdG@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085623.57482.13203244447795959369.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085623.57482.13203244447795959369.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
