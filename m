Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09DA10958
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 04:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712724257; cv=none; b=ctB2Rv3ZoRcRujk+VCuW1wyx3d2GfqiwWCFdXRTx+/sDOlYLqeu0us4zBPJe4av8WxidKEOPzSB/6eR4vuXiKM0TkBbIUCFaoYJBNjIil+jGc29EdFrPv/EoCkqSBLAYWEvMx9l4YXUBV8rh+csd+JGuwzl7Uy9QGVM+B0fYJ7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712724257; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WD/sTojobsFm32tZ34DPAl9VyKqEDn/S2oSTqOo0RXv9aKGhZjU9qUdJmeEUZqens2uFEc6RjYY7hpbYSQ8/3TvkWbcbMj1PlRDSSmvdvC4RvlHZevjFAVSMxSp16V89AHXcaKp9xYFi3usxL1gHo4kZnDWD80EcnBNzhGbxzao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=C84lT/Gd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C84lT/Gd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=C84lT/Gd8K8xD3pkX/txo+O9Ac
	fnTCNEVAuTDeu+zGmor5GTy3cQGTM1wuqRi4x6NAK5IdrrLKYW+c60vDg9waaIzftqXPV7/nXxpDd
	scqVyl3csBiWSdQoe78O3PimT1TyZgaWM9mATIp2XYuv3cfyvA0+5sVYKLlNMm1RoBAk1QGDMTzXr
	wWpQ9dXfqyCTT1YMcY+hzm407nICTkui9+nJ6EUpE+KpwXlR6aAxjHMesnd1fVBBuniCxxHBaEkMk
	f30ABlWLmjHDBnUSjWFf19fFsA0nQfvIMreavTpzN+S+IPi/9OtMaiu6mOBz/7H+aI2Wvdk3+kZT7
	Iw6oCZeg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruPom-000000054Bk-1EE8;
	Wed, 10 Apr 2024 04:44:16 +0000
Date: Tue, 9 Apr 2024 21:44:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: remove XFS_DA_OP_NOTIME
Message-ID: <ZhYZII7GRgIegEs3@infradead.org>
References: <171270968374.3631393.14638451005338881895.stgit@frogsfrogsfrogs>
 <171270968418.3631393.17581873522746080377.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270968418.3631393.17581873522746080377.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
