Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475133624C5;
	Thu, 24 Sep 2026 05:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790229103; cv=none; b=hcMcmfA4sKcqd08DiqnfqukN/jDNgkjwLxtmPrR4t/3jeloXSfRVWYXKbHiW/fqj5VySOFgdlUQux1o5PZVQzIEiFd+GGfxdFO8rpnZgvUkMiCzG/VJBwe6HzIKvfktTNuWI3W/2JXekSXSttFHxJilWn/r/lP7Nazzr3YhdTtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790229103; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bR17Qwm4/GKQ0Y1NqC1py8ZMjkvpySam3dIn0oWpfs/qQrrW8LX5eLgvggLBKKV/4/53d2bqRpPEOrThBU5E1PmxKCuIYF3mZU4pg2q4ZOsDjvU05FVrI29ZtTHDYxEiGMOXpHCnVOUnjOHYi8TSiXocOwrIeB6Re9Sn/ceyygY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0XMyV87i; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0XMyV87i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0XMyV87iHF3AqZIChKZxAaZCy6
	pDFlIryvfkJcoHb0k4ydsirYLqSsCpdh7TZSCq80FkeUQe/VqUBix/h4PjbNZ89+zgdUj5UcUrMSS
	f3LEI9k0kDEjvIoRxxchwXK8CaWhOB5ZVUuKrfYVHtfsIZ1MqEnVpZGj8uwsLWOA70CRoKFFaQHvQ
	iIMwRRyM3e5Y7sTElYMcoLmLYvSvWts/XHIt/i1fh8UlWmBnlE2mfnekY8EbKhrUCRiYemmQHp+Fw
	1AzMgXcxIp/OmsQ/Vg18KO93K/RYNfNPAXsvdZfviJr6HrSpU5AC0y6J3JjK7en7LAD5YTkoKK1X5
	OYLj/shw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9cMv-0000000A5ac-3TbT;
	Thu, 24 Sep 2026 05:51:41 +0000
Date: Wed, 23 Sep 2026 22:51:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: fix buffer overflow in corrupt inline attr
 structure
Message-ID: <arS6bYfoN4iLpeSH@infradead.org>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
 <179014159692.1875436.11611001761091180522.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179014159692.1875436.11611001761091180522.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
