Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4865054F8D
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 22:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367237; cv=none; b=YujDsWvucGdFwJ4ixVx0HBZR9o4/UQfeudjg8K3aMOxoVXuhjAwF7HcBxLC0qeXsX9jbzCuyDor+ZnwDflW9RCkacDPL6dC/z1lE6mcNLTUnzNixsbPjOkR68GYhSlD+ax668VXaFNzdegUplJuN3HEZ1HwhLPpq/3sywvDk/+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367237; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E975YJ4Pig23VwSW2JwAE5JDTRAGR/V7qfGIS3qpJ26feVf/1DmPNtekPfRWL04Cbq9zzbk1rRf3DOsYQsveOCrRdJAAe9G3rgd3oJwMgAi7HhrDT1XW2fZ5qGzuo0Nbj/2c6/Fz9Bu/9TZZzZE3k25ukBVzVcIvECYvcYpiDOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zXAQxP0v; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zXAQxP0v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zXAQxP0v5kg9lI6L/ZOPQtWDDz
	R7w4D8BDxvi2U2UNN4zLsVg3ah54M8JSqRE8JdLRY/aj/Rd8sXQ1qv00rqr+Y89sojODcJUroCbhD
	AVuKREZq5IFEqVOT24Fy3OUTOBfxweNEhgSLQyiJInvOUR4KjvTewMxGw6mHi4d5SBqkb7suOHKxX
	1kS3YrFYDKam59mkjnUWMFEJr4N643wbVpb/O1XTSaL1PRVENawTLPseM10ePKb44UZScOSs5nYBy
	tyeCNRhdBV+vW0Lpcp9qdmBRIB8E0+xp2Pq44TnrsGYsIDbNutnbhLOBrdDjSHqy5yeaftm4dGXO1
	LtmE9oRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWeJ-0000000C3ns-2yeS;
	Wed, 13 Mar 2024 22:00:35 +0000
Date: Wed, 13 Mar 2024 15:00:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] libxfs: create a helper to compute leftovers of
 realtime extents
Message-ID: <ZfIiAxo2s_uIz_r7@infradead.org>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
 <171029430615.2061422.6487321208394360170.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029430615.2061422.6487321208394360170.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
