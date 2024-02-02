Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0071754E
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706855275; cv=none; b=oZno888u4Q0qo+aNIrKPDemQIW+73jerGaDGWwlwbheYh5vM0AwBHwCH+CLoip2aheHNINl/AFud3Be5ZBQ4f1BCd9vDu8GAFbpC2hqeUO/fxDmrQ6zX1vDdyhPSTiZ55HrTbjh6k+Hdus4k/8jvK0Msv/NK1fntbpB4vCVGZ1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706855275; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QUzlxEEI2ZStMyKW3Odvu35oOhJRymR/iq02dmHKlnCcWbRf4tD0SRReZlPv/KkO3fWNX6FBoJp6RFipNSsQhiw2jGys01fTTDP200GxH+/2Ly1Q2TjQZkUTKgYwfzIsxR8/DMZ5Ga6va9ylm6R9Y4PasuzBpZSnRsULOaxSTDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=24LdG8KA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="24LdG8KA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=24LdG8KAHDIKZWdnj+jCNXI3Ji
	v5qLYcs5vVo7A7s/wp/wIWUWCCNvrmoNaT/aooUr7GRCLXy1o/NPt1P3Qz3fry2tcBptrT9xCrxa5
	aTkNFdULnsPZqM7IdzD+7QWkOVHaciCY7kRZTwgM7s+tmd6bPkKY7dd6plo2vx9NIFKZlcJ7+e9Ey
	knJ8wSqsl1sI7NkPS9upI/2/wIkcyRumGtqndTxTHkABLzINfwFGZUr0dZkNKvPFfzGC7cxiEDs5l
	EJjuTCtC+4CtnxQcWxzlw4AxdMOXUJwh42/K910GcDl91RZY37opDhmDUm3MgDpJZwHO+jVb3HJR+
	43KqCZlA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVn1m-0000000APui-17MC;
	Fri, 02 Feb 2024 06:27:54 +0000
Date: Thu, 1 Feb 2024 22:27:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 5/5] xfs: launder in-memory btree buffers before
 transaction commit
Message-ID: <ZbyLasyzL33r791l@infradead.org>
References: <170681336944.1608400.1205655215836749591.stgit@frogsfrogsfrogs>
 <170681337043.1608400.926783069179071619.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681337043.1608400.926783069179071619.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
