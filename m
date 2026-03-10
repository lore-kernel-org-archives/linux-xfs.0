Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89DF44104F
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 09:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773134967; cv=none; b=vGCNayG4FFv0E4jqF/EdEphcgcXp1RsNEOiIm+p8ZjlCOGf8LJUZf3nSaPfbb0thVDXgP8OtRdy3jEZCp8I48GT3faXz0frmhSd3f52OpRHzJU56SUIMmQeJmPa/9Oi//HGp9vucxzCd9X+CZJ11rljGTj6nEmfpJU1PlS4YOXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773134967; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mlco2o7Rd8HM7vPHmpJuu6Q+PUfbmg+Eoddjcpv21pfrothyzJMZF/aI+P+tD8PXY6hCSn3Sou1G9RCzt1l7rlvhwtGKKIqYPvf0W9iQ2ndWtqrhzQp9jsOlcDBY+dfaJurUiBcIqzVR5J8NKO7mPZTCy653z47v+NKmFUTkBEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YKVI5d7q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YKVI5d7q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=YKVI5d7qr/qNvuE7Kvh3dJZnYc
	i5sdKw3qCArlUTFDw4MrhOpsd9O48mqdSjNPpC5BLessgeOdec0Yl/Z6d5cxeo6rfQmC/3cpAHdSe
	HBDCYpU1AGkdcB4xFLg4iprkb6CbDx8RF4NWUhK/q5Jy8L7kCbbPYZmGXAo6KmIDrjqE9s1UY1n/N
	evN/cTpsFhXZrhd9Q9VzldYj2HMpw0NbSEIqyLNuwQrPfqvDSosejvDsPJtSup2NL3U2klqDGiHy2
	qtUGtuXZctw6L7jzDy96e8Zj+JEEHPiDbeiyO+KEpKZTIYvE93O80anJ9+ccvr7wGFwV7dPFocqdc
	stOqLzwA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vztP4-000000095gG-1yQk;
	Tue, 10 Mar 2026 09:29:26 +0000
Date: Tue, 10 Mar 2026 02:29:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/28] xfs_scrub: use the verify media ioctl during phase
 6 if possible
Message-ID: <aa_kdi8poTWH0za4@infradead.org>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
 <177311401861.1183235.9677228337197848690.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311401861.1183235.9677228337197848690.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

