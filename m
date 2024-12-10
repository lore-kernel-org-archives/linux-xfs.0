Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2D423312A
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808150; cv=none; b=HuqB5OQ5qyiXFKkJe4EzBVvkyCzkirJb84hetbQQ5ocw0QYQoojZni6lAkU0JhRopZEhQk2Lx6CJmYkkd0SeEtsYxZIfkcWxYkHrjBuzTi1waf2inPTaw6wtw0ETy5sGAjS39RxTmIFkwA8lnJkDis/iHqbjR9C5f329MtxYctU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808150; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EH8C3Q4Oas9MZ+0my1s6VGjc39Fhnl7Tji0a0Kgj/wS73CY1cOh8anH3sk81nwlL5CC8BeJiUeIODHPDnQem0BIK68P/hfRS1gLX935Doy8wkSLSJgP6tWEKWtDgmDGgy6GagO5WpV/JwhnUh8GeCzndcrHISIoLHGEPftk1im0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V+d8tFO7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V+d8tFO7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=V+d8tFO74eFNzTdtnNU44n2mrq
	rcBvVCzRe1FX5cSJKS4p1HIvP8KNegNMfzg6YJR5ilDcVNEq8GDT6klNh9S7xE0eFCRWQ4qibrMmE
	eprBXCL5UAxO6BGVXI5T9zf0lLNIedNeXWUV7kDTMaKks5WMq+BX+mLF5cEDMIm+B3Qap8tKI9pCA
	WAclulUqZueELu6f4tmk70tszgsRR/EqvOqvbxGV2eJIJC/0sexMCFYd6Z/bRdfyXBomC+IdbS2St
	8AI3Ok1GUil1/7Qf5FpOlHByF/46GlijvxuDP4goNjUkgSsT3YZxhlf8/09jzRMAQs/5rHb/ztLzI
	rk132jzA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKshZ-0000000AGh1-0wUj;
	Tue, 10 Dec 2024 05:22:29 +0000
Date: Mon, 9 Dec 2024 21:22:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 41/41] mkfs.xfs: enable metadata directories
Message-ID: <Z1fQFZwcmlK3w2Em@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748859.122992.9390953232184167892.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748859.122992.9390953232184167892.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

