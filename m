Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93E06BFA5;
	Wed, 19 Jun 2024 06:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777675; cv=none; b=HmAXOBic4tyStbryo78PD5Ky5OJ82wmTAucctazmJBetkQssw+tQqA74ui8AEDu6fv4gNRUbfXCD6i5dZYwi8WIvoKiY5nDtMzOOM5BloG8m0IlvSSgF9ZiB9+hlOKf1nsKMb9Eg9U2mpoAo5xf+UA6/zTM9V5aS15BhgQewanI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777675; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kjxRJrsN9EKIoQGd/XVyj14Oka+ToD/dBQ8GVaecKSmXCJcaXAguecuBXzlqt2W4OUbaJhdzNme3enl4OHTiyzzMFNx8eyN0QuJW/TkpQ2TjZDKM5e/XgcfISWZ5vLh7E3THRJ4bIjUzVvkPzw+CnFrZlECy+XR21jlImOLtiwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ca1gjUMK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ca1gjUMK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Ca1gjUMKsybyPa4vXDGC830nan
	GaJYjLh80UmSK3dGc4+IfRPQ43WuHSIQ6tWuIhQhxGg5UAXV9EvONnURk36PiOfn4B5mFo9UjkoHk
	y6cmfen6KHnM51i3cF2Xafxg+q/5iat07aLnHribPmsDW6sEzVEKqBkOQHjRPRRrgsYzxJdy/yfGc
	BcxQrj0+nD48B5GS89vnDK2jiC2KDfpnpLb5xr5+TxoZURbsHpwhMdHdyy3BIG2ko3fdnVjhhq6fN
	CfDAJe4NhGRjdRM2tFT52CkQd/tipSs0zQOUUmAW4awH1gNydHrqjGAlxfd/alE1STVI4WwKySvlw
	nSU18gfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJoaX-000000001cU-2Ylr;
	Wed, 19 Jun 2024 06:14:33 +0000
Date: Tue, 18 Jun 2024 23:14:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
	catherine.hoang@oracle.com
Subject: Re: [PATCH 05/11] xfs/021: adapt golden output files for parent
 pointers
Message-ID: <ZnJ3SWkgTufwW5Fv@infradead.org>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
 <171867145884.793846.2979345753114061846.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145884.793846.2979345753114061846.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
