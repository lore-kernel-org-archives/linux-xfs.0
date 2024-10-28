Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE2242A82
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 08:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730104431; cv=none; b=dgSFlAi6zQJXP1JORaMO3tmN6bfllnhu1p51VVD7bowY3neTf5YzgpKjLLi7BhfWZ44fSOg2e68+u+3SvYwcFCFwRSfgUUNlaHuqp+N954v44TTbOsZNF3xuAgN9nZzLSYpfJYj6dqEG0G+C9GWDxHgNpCwHXAI1Y4GwUnwHOjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730104431; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pR4oh2QSXpnfMRsKEq0JMBKzy7mOFIyAvtNv4l1JBkuQJgaz+hA+kc7OIYAn1dSyLTfRdfYjQBZDAqqOj3QCpENofsmv3lO8DQ0aKZ/ihIdjsTTNIHw5sOQjLmG4nE0F2IA+31eF2b5+4fb/K0xE5/mYpUkYhlbOLuELsLx47hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0MixsZtN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0MixsZtN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0MixsZtNC3uGRh2nz38BzH13aC
	2PIaSu4IsF36S4cKsVMIk8nfy8w78uqa8WJmau4x3KKLIJW4zohI+4TGlAh/Pu4CcYhzgox5SDk0F
	wy4tDV6G3i3Whdl1E3cUYweYWs5VZ4Lvj1VygUaLijVZmxZ+SLJUD85VJtAOROq69XgrqV2lA1Gdr
	byTXqlcUYqHRAzBdnqK6WhiHS974jcTc/r1I6/wJska5aUfQGfvNOHRAIgiD4BnFTfnzxdon0CbeN
	OyxPLJN+Gr74LuXAI0hyNCH4JkcYSNDD235cki+MmkjLcZQzP49ZTt4xecVcC2CJ3G76AZOuqk1Bc
	07L2KW/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5LC9-0000000A6vX-1gVy;
	Mon, 28 Oct 2024 08:33:49 +0000
Date: Mon, 28 Oct 2024 01:33:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs_io: add atomic file update commands to exercise
 file commit range
Message-ID: <Zx9MbbGJLjh0paAt@infradead.org>
References: <172983773323.3040944.5615240418900510348.stgit@frogsfrogsfrogs>
 <172983773435.3040944.11571503838591968979.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172983773435.3040944.11571503838591968979.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

