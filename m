Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B4518D621
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734072854; cv=none; b=h/DdQV+F2gMIMlAkKo9sxWlc2Br2xKeyL79rCp5vlKjJCQgYDVoyJIorwRC3DJG7DG6gGSsSNhTbUK3z6fgXUc/bfMeaywis8H3D0FwZac1jIdeXj4telHTXIaUBG05jWvaygn7RUfVlpEnBa16ft6GmHPsYgKxBUsYBV98KcA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734072854; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i+r3ez5n0DT9TJgd4cHr76DSGxjxfxqrFrHzCOyLPfHnZ2P1iaacBYenQImwvh9z+APoY57xAGTKs1Pk4sRdRskyiJ9xLApxZBQPJzdxsfGDFwR0t5HlBKOzcQNBpFOYNw/CZFi7Vo6EyiOXo4L8zCccqPJZfxTj2dqEiX+aJBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lKTMaBQr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lKTMaBQr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lKTMaBQrsNwmXqpnODydYuaP/o
	+vcr5mMbTrWmdJ0+C05vowINSXKdv0bPhhQobPzBaJKCioGOBb9s8GH8RNW96lJFGlikPngzxNGCi
	Wb5HmZjPDqf0EcK6js5s6J6/TSbm44NxBL691HUng2gUamxRK2L/7bD7ucQsj/FRmIhxwuiuwBDTe
	TeoR+t+EsipW7cGYd6gt0ay4GK5MA3fWS0P1345pKfZ5FIvlsSGxA+X9RxMnN7qvIT3ACKhnILiP2
	8oFmokeIGn668fK7uJ3jLVZJg/98AB+NNHEsKjO+tluaT5GwubD9+n+dt8BDXEuXzLXVsMLbRStyR
	njPGp+lw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzYy-00000002uL4-3eic;
	Fri, 13 Dec 2024 06:54:12 +0000
Date: Thu, 12 Dec 2024 22:54:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/37] xfs: report realtime rmap btree corruption errors
 to the health system
Message-ID: <Z1vaFA7gRfB0-lKR@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123640.1181370.2788362731455898690.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123640.1181370.2788362731455898690.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

