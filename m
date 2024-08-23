Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C138493
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389953; cv=none; b=MJSTGyZiHvRMTller3FL1I6WeTxBxSpcAY2VCdXbfDjJ15LOwjC+uU3DEXl7BOo9/rPwaUMERKCqpW08t+7emXxrhfViC4mcPfVBL/Yn28TS/KHAnAsN9g+aOKfXOBgkFCnGDEfmOd3Zrs/WHExxsdIchNFX/K6uiaB5T09zRxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389953; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lGTmHKoraK7uVchTIPHn7V4CczIbOXpmDapR3anlR6LQZLqCsw0l8cr+QCa35MgSAfdQyMwKvyW9yescFhsOml+Vyhf0lYVCFxaUWjSinjAxZj8ZxQW1enMOR82E15QDjQzKay42yBDJng5lU5Mjz9zpu5Xpy9VxzyK8m0hLpLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gPDoJC/m; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gPDoJC/m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=gPDoJC/mNGEvTOYKtIrctw9gBZ
	GK5O7dfdQySdMNYqNgHg7CJtp5PZvfDYn7MVRf9oBduVC6eTtGx78dS4xm9MFoFLOn2v8JxzIucTB
	Kd43XIotpAqceBppesM+j5Lx2OZoXliKscmwrmz2GFLtM0VPnjNENgqSNrtwT0B79Ia4FxCXCd8nK
	Ah7VvdLYhWiDpVrFByIZ4/XWf33BwRNDOsndXSCaLuco8MMQB8iPK925CE58qBHsC4rFmz0/KVwzi
	2xzido/+d2v8gw8AyN7Z/nVm3ZnC+md8ofe5lwf/kz+SvmYybQdtOEKpGY6KytRMW7zt/nLDnzr9w
	SEshe03g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMb9-0000000FGv0-3rUX;
	Fri, 23 Aug 2024 05:12:31 +0000
Date: Thu, 22 Aug 2024 22:12:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/26] xfs: export realtime group geometry via
 XFS_FSOP_GEOM
Message-ID: <ZsgaP_6zIbs5_XN3@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088588.60592.14229821430878166126.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088588.60592.14229821430878166126.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
