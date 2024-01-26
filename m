Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64471B59E;
	Fri, 26 Jan 2024 13:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275985; cv=none; b=E4fVnL8cOQNmDpJuARLmFyPuLs9AGehloYdpE5HXi576Irf/uAhwShpB2rzXR/AfXp59nASexrXT+m0JbTMOaDBIIGqIyB5wxlxhBucxZA5b+wfCOe7icuIlavSgP2A8MFE7/38FTMeuEsFaENt3fIQVAFEfGAFylFuBnQWf+Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275985; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BSzDmf1Ir/l8bY23FUM/vn5Ef3fvnm7AhI+jFESZfn73sAwbD+UcVP0LXaiT++lO+QGKk2h8XBhNao/zukhft25tKKyxCEx4Xi4jKv4Ko6kYG21w13Np5Y1fgtlzqTEKh0OcGQSpFxF1u6v0pwPbYee0CzoG8/GR76TVA2jdGtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=APDSzMyA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="APDSzMyA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=APDSzMyAATBEAfnMfhQBU0qONX
	EkKx6yF8Hv6aXiZi48e5ETfx//rsE8UNiFYNL6WeE3xo2b68ig7bqxSdNNzTEM5AdAumeKQZV5OKA
	iRkYTH6BG23JhGUPrj4byXiZzsUV+M43t9nzV5sgbBVZ0+QrNvWgVOL/GU7DEVGIKpxVqZg5z9gfw
	cyZzZJSulSkQN1IrBUPovL8vbSbyXudjEVttQk/sCldxpyX+YfDV1Yp8yCm0pTv71cv/YmiaW2O8Z
	ODCr9bdE5Xa2Cg64Ldvz5FOn7wx5V/4+xbv7JVkjn2tcnsY1JSjnHMbbR7dFLsNsVGxPyQMJzF25+
	wTi+BfUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMKJ-00000004DRi-0Mg9;
	Fri, 26 Jan 2024 13:32:59 +0000
Date: Fri, 26 Jan 2024 05:32:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, guan@eryu.me, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 03/10] common/populate: always metadump full metadata
 blocks
Message-ID: <ZbO0iw2d0d5p36J_@infradead.org>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
 <170620924408.3283496.10108828998772840672.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170620924408.3283496.10108828998772840672.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

