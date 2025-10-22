Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3530278158;
	Wed, 22 Oct 2025 04:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761106648; cv=none; b=epog8mNlwPFTaDVlzSaBr7VMAWoSe/pjQnuNTF+Ee94FVp5yo7WXGLxFfjJ+dHVfjOFBslCbA4FltP3ZF3RAEmXepCkB+zoAEyUD5KK/z6Q3cRJsDgaki32GzTfVzczEbc5r1Wbu8SquPBn9mHmamOpL0808Xc1JkRbO0fjN1Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761106648; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fecdy4xYyMbP4FrTj9N8c3OMuFCkP6VwnJRJ7FJWC+bALFuulnnD4FRBnviIwYc33EC/GP9AXTdaP3juaCUAzkFVS+dUGg4h+rLdPVPvKOkrRf7mVhpWzJlydRTFAEEPWMxb6MTFn2DiT3EPZo5VRaP2+2thnrzuUo9ffMjPDdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oa0Pry3y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oa0Pry3y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=oa0Pry3ybv8m9Lvbdsaw/5dpJY
	5Bs6CdWIakxbRDOKrHxJkQPNBjU3lmVsQUz3iKv+ZXInW0XMQ7X3hL4ATBJBMRek6ZT0msd/hcYTu
	APmvdt9hJPuYoP90OrZ6aeJJZoMW4yI0IVgJ93kPR2kLmYEX352FYGndWrHZ/GF8ZoSUdbFureDG3
	UBrThjg3b8VhwxVPOSPcqjcE2R/x1R4luMMFrB/ujqqgDulRBbW+iDXH6qzwt59xi/WWwfkOBLeYm
	WMIejoEjhxDdHOnkFO6DKD5VMqmzs/jKgMycwcUcxnTadjYXVmhN7DsmN/dmK/gQYhh8rQavOy4QL
	lCPOpPaw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBQHu-00000001PxB-04Vs;
	Wed, 22 Oct 2025 04:17:26 +0000
Date: Tue, 21 Oct 2025 21:17:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] generic/{482,757}: skip test if there are no FUA
 writes
Message-ID: <aPha1RcPYLFSF72o@infradead.org>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
 <176107188743.4163693.13401813487181708360.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176107188743.4163693.13401813487181708360.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

