Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573592C694
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390175; cv=none; b=UkEa4zPvnz0iie+e892g/ZFsQ1tbXEbaCeVtIAKP0dVZBzjXFPcx5EaVt2JpbKmRAfQFjGvoccBj6E6yDwLLdLHmSbmvJ4pf4Ia5yYbIvNfsDKchvK7P1cxPXvPFJLhxvBC7UR0fRmK473qYH7JJ2lO9FrSr1/PRiT2BsHN5T18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390175; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EmlEGLB9xHI38nwmk0n0/YsH3KatZNz7TcTrEHCQEW+SQFtBIhRowOmZfZiWkjisoaw1Fxj3ioZYwFLbMOvNsyhjMrSIwF4IMhOsvAcHWa5OCkl4W2nCDgtRCv2+MpNxrmgY0w4H18wyDiAozPDhUA8tbLL2dZzUBacspgO5vpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rpeKFxpl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rpeKFxpl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rpeKFxplQ4FJ5FuNRthiYkxSLl
	48sh9PimWZnITObrzbBnw9vFMcIp5DRA2CJH4BVNX5o8F7V4qOX81ruAhdqlbZzsewewXNwgGOPY0
	nkqFtdkwj6g9G6H3jqlm3Ye7qK/mJRkDeDHrE1RtggzMpCLsVwniqhRpdObAnOdQGqkoMqaWKceRO
	5dyGf9LCC0IwhpsJ0wZDVNTJ4k42cuCp5Ne0NgcBzH2/lSI9LCTBjReYwXp4KfNITsG1hOaODJkav
	l/vYwzboQgNlL0fZJyN5Oyc7nZBDBgRPLoJVZ0TNfOc8jUzC45c5GoLQFWPSRhUh17rcK9TnR8ngu
	b9dqLIXw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMej-0000000FHOO-43de;
	Fri, 23 Aug 2024 05:16:13 +0000
Date: Thu, 22 Aug 2024 22:16:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/26] xfs: grow the realtime section when realtime
 groups are enabled
Message-ID: <ZsgbHVr6wMAMefhD@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088764.60592.4708190326358663732.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088764.60592.4708190326358663732.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

