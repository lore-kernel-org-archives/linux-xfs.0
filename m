Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D88859B42
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 22:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367903; cv=none; b=l8C6KfrfEzG5ny8SpOMKNPWh63vCkXFeQ3H7E/SenSTnYlsYo0qL//TbG2aab95+DxCMozW2B8oZf9pPxGcRGeeF6/bqULRufxH/jIFHbNYp0oIg/CccR93obXhxcWX4kK1+XqbkM1rnmGsJ5OA7MsUlk5GR/WHg2ntbSvFSrlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367903; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kKpWZEwEToTwJsnxfxOmqNlpUQHCxwW79SP/61aFA14FZ8MMBqW+7+GhqmQsEggn70cYdn2bBmvBKWlYefEi+/7bxkuj7tjG/gz6SnYuz9uRS9wcIgEaPZaUXM3AgqWYLGk3v5eKeJ35MwT64rehBIw4irERc/7esVIXUIVfukk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TvnRTepX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TvnRTepX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=TvnRTepX5wSGasvbVHIRj+MivL
	RfwOZ03sTgdm4USEdXltE9ZliHVF5FEw7slBEE2mqOvaiEAd2DJh4f3NCal4n2w4a60Fj75RisBnx
	Ym6f8qexVfw3BK6tQyXdWvAZWsTTs1mnsWHhP6zrJ6KfDVmUkhdrXEwXd8f4rFJftmeoJjSI6EYs8
	RPsaQ7JetJ3/iThya+UUWpRzSHecZONv21rCaDbwdUeHFedQcb4zVKwDDCuT+tn0gHP9bSzBcfppK
	4GNuVye29mb0WaViJitDyhRvgagBHbhL2tJcVo4PIXhKSUpgEOMR4m4f6VUd2swe1UNFExIL96pyA
	4dW3+swA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWp3-0000000C5zu-0JzH;
	Wed, 13 Mar 2024 22:11:41 +0000
Date: Wed, 13 Mar 2024 15:11:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_repair: sync bulkload data structures with
 kernel newbt code
Message-ID: <ZfIknawMBZVjb1fA@infradead.org>
References: <171029434322.2065697.15834513610979167624.stgit@frogsfrogsfrogs>
 <171029434355.2065697.8914601331036024173.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029434355.2065697.8914601331036024173.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

