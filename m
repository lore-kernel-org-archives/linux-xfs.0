Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207A113CFA6
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738906550; cv=none; b=iAgrwrZYd0WgLI8mnIaVmWsFl4Wn0uM/ykHDSxKDEvi5IYg4sLQ8IdaBBeP3dLQHSi1oXsFohpqUWB1Yw4pIoNeeweF0c1ipAqYfurTDQulAA7pjP1CbsQ9w5eDnGbnZ0/6ex22i+tYjJMPcpSbM0xsWt9IJx70y3Ygor8GwSAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738906550; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pBGaz0DaoHRMAHLj/cuUTHMnJFFdOvZWB+6jU4FvumOZAbgY9+YVUucvS2AnE6P2McXI3ypSz8M34E1xyP2+minE1csKtVV+0ecHbHs2TJFY4BL9h402ZcDuLofmj3+v1UkqPmkIrQX4CpWIwHum/1BsclmaSNKRDlLPT3xxRmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tcEn2PfA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tcEn2PfA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tcEn2PfAp7JnlfpgEaSqAqND9T
	0umxqn/qSDvTyiTMProAqtWOEl7nb+e74figlm/cTKIG82W6AAWxzXhigWuQ/pQOKUP9hyvjwynid
	jFX/2uGz0BLvRFP7M17mArtG+CkjqtTvm5tSiKBtWpx0HxaiYVF8ENYSyko0GKNz8y59mCMJEnz1k
	Kk3X82jXvwFS7cYxoXgibbEWFfoU28V8TjSXcpBjwGLh+/jJWqjvQrKJ1/pxZHaj3zpGn0ipBbvLI
	CyUY6Kn4KcO5d7gbTq14exLjY9wvX6PKKsT0/8pbCHbjYqf11f4lcNvPd5HUO38dqtSVLdVPG4ld5
	+o4DIyUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgH1o-00000008Nga-3KkT;
	Fri, 07 Feb 2025 05:35:48 +0000
Date: Thu, 6 Feb 2025 21:35:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/27] xfs_repair: always check realtime file mappings
 against incore info
Message-ID: <Z6WbtE9hWy2w3ub7@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088402.2741033.16711596957542694304.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088402.2741033.16711596957542694304.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

