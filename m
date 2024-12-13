Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B6E1AF0DB
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081543; cv=none; b=nX3/Vo67YTsJi13Z8EfLy/dBseec50Zm11J5jSqrOExeMv8yK/Ld/8VM+g2ATCzuimoWeV1JDA2/JRgpdBAEgCDV+uu1WQsFIj/+/BJ7bqTHXPC0vK5AdWx3xy0s2dEtx9IU2Z1DDA8kC6S16g4HuQ7xmd0aqfLlmY5H3tgWvKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081543; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=glEpMTzaQp5/Ogw0KJmBfg01k1ycuYrBTrWvQAwZrXJworFTStusw5zBczQE4gr0OC6tZfUs9zJmZ1EenbgwzbhJaHMwh/nnyOGMd6whsUCTaO/4juTD43zDvCWEw5uiLP5NdcM+cHNb2cgW+Byct4VTjXGmTECJ42HhwjfAJ8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UtGIk8yX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UtGIk8yX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UtGIk8yX99UR/pjedkB/PjpfNB
	mcMU+oYNutsebaUtYjeVDBUYube/brVTYCEkWQ0vly9FGz2QSYCPktJbofeC2EcMPp+pktK3mo1Xh
	mFdz0ZseybSX23ZfkFNSqWqzLNBxMQBYnyeO+1Y6JddKl+9scUvmKSz48dA5+djcLcpLa2/Nm5b83
	p9+yIU84/VDOOLqtDbh3Fg3wNFbBIHVV8THEicA34KApsw8W+5qLtAZfF/dMgAxij8XqiOCT7iLIr
	KbXDzTy2JiiO3KoK3H7rk+7PoSahwrh/FGxhnboQD/VFJQBBS8TeoNKgb/NLE/hA6X0rU5+6sbydH
	3zCUaisw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1p8-00000003Dup-1gvz;
	Fri, 13 Dec 2024 09:19:02 +0000
Date: Fri, 13 Dec 2024 01:19:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/43] xfs: allow overlapping rtrmapbt records for shared
 data extents
Message-ID: <Z1v8BmsyNoKtpvUL@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125082.1182620.1056977780292340402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405125082.1182620.1056977780292340402.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

