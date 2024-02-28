Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB16115B0EA
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709140901; cv=none; b=PrtrZLWxLLl9Aa2nKsdPpm0PFlka4lt5zz58RrHXWNEn0tL7eAxqgOyVCcKHmPFk+VKRSmRy3/74BH674lzwpV2n5CvPDFmhNXpv3vTqfBx22W4hfZwQgFrXHdY2EsrnUijMHYk42H26m/9ISCYDk4prnHoOAWKxNEVDXXD04AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709140901; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tqwvKBbDrvLw7cdBKa4q5bSwtgdbLr33qKkfrXbjAPKUTJrlY02w86EDhmIXJJSMqdrIRmuhreicNPeoAsh0tU+mxuH7LfI5m8t4wOz5k9GuChte2up1PlReQSgmJeYj0VuWJDSvOlxqgnfCmmMaP60ztSiJJ0kh9VoCDG05L+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kYOAYTgf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kYOAYTgf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=kYOAYTgfyzM0SkNLiMMuqyZGnd
	QpcWRkTdT0BYOg97+S4toniiWrxTt/QzVNrTXk9rycnMKMbaLnXVPm6tGaLtSEkODi1il4BYY59Bu
	o8CFtqxyM9uuxLN7PVaN3W+TbW4mYV+PXQovY2GRv+V0+yC6Nsiy5J6e4aS+RBoCUzVQGqEvjZ3TJ
	3zWRdWx7QtqwsV4ivIBgQ36h5Y1Zw8lljSaXCld3XVuuQtk/B0IskZ96PRxRL5SPQet2ZC8aali4T
	vVMIxbPz2PsfzIx0scKKXdpO/c0gtTEc06uIXhjeIu3GFt0dvhMM/bld/A4vPi1w5GROIrdG/uhLG
	8YKIUT4w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNch-0000000AH0y-1L1l;
	Wed, 28 Feb 2024 17:21:39 +0000
Date: Wed, 28 Feb 2024 09:21:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/3] xfs: move orphan files to the orphanage
Message-ID: <Zd9ro0RlLNQR_ayC@infradead.org>
References: <170900014852.939668.10415471648919853088.stgit@frogsfrogsfrogs>
 <170900014876.939668.5379275567646177981.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900014876.939668.5379275567646177981.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
