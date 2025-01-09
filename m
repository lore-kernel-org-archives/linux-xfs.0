Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D5D1A23B0
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jan 2025 06:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736402942; cv=none; b=UFKp0zkxvVZe08WBgKP81hxfZJOaa7iEo1cRqjCCeqmqrHdsJN70+NSsSRJvD5EDH58SMdQrtkqjeSgUR2/631TFNXuvm6AcDDlxXInm6dDF8cSvE1YeqB4LjiShi9eEt6LnzQd2sibc6oT7ARyJK7b5sV1hMtJB7S0JnIK8cdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736402942; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cht0DTU7Z4k1dhK4xSDl5MoLbaL/byzgiu9YPjOOnVrToRS7HHQZCesQYz+VbxiwCTxEUPTFFYpbGiatAGH4yP9iLDl0An0ae70q4iVkwr8xBXANv+ml5GIm7KSDTEXOVz/1ooQU/Z2ABVSeot5CM4EznuUBibpgyDbJcww86OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zW6F3M/r; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zW6F3M/r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zW6F3M/r2wzbQNFKDPJHmzs20D
	6dPKcobrYE4MQg11eM2kM4zdmohXLh79LKkGiDdthJxdakYrTIvevzvUAAXzRyvPkkjvsRe04B4S+
	XjrbN+B7fCM1d+3IExnF+9wqIYicapv9vjfdoB0vJEi3BvL5pnaZEfU4mDZVTSPla+hi+SYVPARcL
	pj/cMliIoeglsrguYVafzVZwc0+lxT8lWdRjtFWlqP2Ji54OC3KsyEUobxMbrjgDMEJkry+mLwEcq
	ZZdX1kKKNmsGjnOsXMLRm3aSH5PaH64WqYadyOqYZloDIlRyXYCn2xnvwVIo9auvDA3Fhh5x2bv/d
	CrkxptNA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tVliy-0000000AtYB-2h17;
	Thu, 09 Jan 2025 06:08:56 +0000
Date: Wed, 8 Jan 2025 22:08:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] libxfs: fix uninit variable in libxfs_alloc_file_space
Message-ID: <Z39n-KNZJ9TS3CS9@infradead.org>
References: <20250109005716.GL1306365@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250109005716.GL1306365@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

