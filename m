Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8EB79FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 04:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806425; cv=none; b=uYQbL6KwBEyqy2mdpvaoWxfp1uYGkcBzov2P/cJh9lE2HBZXr6t9UXeM9ODstFR1G2TZAhNgwhYRlkBvzmfCHsoo5iT1w9W5bUb9T7xCdeRkjxi1jXrLLsaDriYZsBB/NwzVO93Klb0lQhDauBStc/LIP015PyB0wl0vx0o14cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806425; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QuosG2Sm6n2rOX5j2P74quFSVkhbiNb4AQGuxIPBM3replekaSf/+DkSoRtNdbTydbtdWHU0Nj8VluyP82kfAJjoWjyd7QWpFdbQk0SZQhs6kfuZarAWiJ1ttQqpX+Pda+pxf/OR3ehbyRuGKMSxJd0hxAWxNrtCK1ikFAiW/yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LCzpVelz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LCzpVelz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LCzpVelzxEPPJKvuv2jGLnfMJr
	NDLaBsrLbdJ9CF4gRmnrp51HrSCqcT7Fe2hErKG3uan0RGaCNCodSVSS45S4tbxMgJZNJaxsiSAG3
	4Vfdwzs8AtZnwMX7sPEYdoKaz/JLcHClhfwJLYpbTGoAQN1VNxIZxmJyg3uV3kaHmTyAbuXAUdjQ7
	Jy9feAV3rrz4esr1ydwEnNFJbiod+C5yAi4/I/wpWkVjEaoGO1KhvRTaPDaPXUZ73LWMl4fAPTVna
	QB9pcOXYrJ4wMyZ96Q/WgcmTkYnm6m66rzmObWBlExP9eI0fFwMyAyb/ruDUNggyzCXYxSdH3pyey
	SgAeaKRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsFj-0000000AEDe-3p7v;
	Tue, 10 Dec 2024 04:53:43 +0000
Date: Mon, 9 Dec 2024 20:53:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/41] libfrog: report metadata directories in the
 geometry report
Message-ID: <Z1fJVw-K4IArNymh@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748331.122992.4014549233561309416.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748331.122992.4014549233561309416.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

