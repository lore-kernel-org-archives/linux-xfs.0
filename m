Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8514D40BE3
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388941; cv=none; b=a7IaaUmaussrdja4eEEPtJDTCIgfuW2E8v73DlQEULIRFlxmmTDo4ZfyxbaY/5XNV7cM3gWEZojr4YQWP6BqM7j1A4IzBbonbJrKnutkboJSrgxKyqnt0Ql3e1cXyc7krW9zmMjeG0Kc6UMneDQ3t0sbH1DJLHsEOSWIewgkPV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388941; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IWEeYyMISUyJCcWcQFq25pGVQPGvBwkiD+TPtCJnXIOufWlFCnw2SJLW47GZycY8jUAku0n6ZmA9m01z/A4qEHUGSnf9RbACvX6kmQ5XmQxAxeYE6daseX0IFrZ35PbjQBD39YBPZHJBDcM0KV2ALbP4FeI6htWLcF3zo2NpcvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=twHTacB4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="twHTacB4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=twHTacB49nGwQTAToqH8coJ+zV
	CY28N2JddCx1tGKKAE/CjxCVOUm+izA4JHCW6y1IPDRv2nlE8uxjpG+0eMw226FvAjbfjMU1MtNgr
	bLrAdHR4JzEsxwP90j3wVWkEQTsAX/KlffL9N33/hgVO7LIIIkdjuoXKoiPMJN8ZxUvBJ3mpX0txY
	MRb7BpqEQ/AhpPA83jLMG9A0wVqBrB3oG2WeHrwoPEME8+XWSGqj9CRlH9w6Ww+LfhEhmonXCHBRK
	alfzCSs46wtWE/8Y8Zlf0812z7r5FescWRWgYb5HHD4XGdflVXw9h/Zba+8U98lKY3LR/XUdzDY+v
	sovQ/EeQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMKq-0000000FEpP-0lko;
	Fri, 23 Aug 2024 04:55:40 +0000
Date: Thu, 22 Aug 2024 21:55:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/26] xfs: confirm dotdot target before replacing it
 during a repair
Message-ID: <ZsgWTK_e-AWaFSiq@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085606.57482.15990942213279998510.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085606.57482.15990942213279998510.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

