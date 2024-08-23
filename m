Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454904DA00
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724392399; cv=none; b=kW2Pw2EliIut3x4kbKwhS22kk+op9d5VBDUbBa7ShiTu8wtkGqGfZUlnaNZ4sPtspOpM1t8t9+yVTiV34ygf0n+yHxLcTHIDXPDrHoASUIPkcJAc8MuUz7KYpbMEElWTnGeYFva/v2JxmaHgCaV5LrSlBAjK/kwRmGqGuAacKy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724392399; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VSEtt/RImVGcO02E70/RmWeniTrgJcd17nv4G+frgwZnn/rSBPxikeL4u7S6DsGYRnKRdVWiuZW9/BYX1VmH7UYD1oQF8AuTC7csPhW9EcA+qMB/DbvWo4onU36nh9XD9AEaXwYKRytNlEFCsvRVUOgyXwufjWOBJY33sw8ozJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PP7olC7o; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PP7olC7o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PP7olC7oozHNtUI179XzFH0Q+8
	GP0mvHgywiB/At3cCtEKMxD5XYKlgc58KWiGvKSWWYbHVWqykx1rFwDucfTIkh99pFTTkfOBT5ztv
	r+iqNj0NpA/IU3/HyhK9Op3CkbdDcvlGqNkWf/TOf7I438KfNyz9GKpQyVwCf20TusgUNkOZ7goHj
	IDGT7NzjUWhH4RubELhUQ61twpxVPMbLsuhu5tXFA2bU2hsi+Cr0SDpNIb70eW9V2WP+4V6N2Gxit
	3dLaNwQ6xloGRHH1naoFBKeXShNyHZPn/urc4W/ieaP1NLzR4EqJ2YoLO1u3/EQNg9UKQWw+tbQKa
	l3EsI8Sw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shNEb-0000000FNJI-3GwQ;
	Fri, 23 Aug 2024 05:53:17 +0000
Date: Thu, 22 Aug 2024 22:53:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: scrub quota file metapaths
Message-ID: <ZsgjzZbmi17RQR6B@infradead.org>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
 <172437089414.61495.2473580313151427630.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437089414.61495.2473580313151427630.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
