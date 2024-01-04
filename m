Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0014D1EB3E
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 07:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LAaEWH2i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=q5N2XJwsjzqzxR4XKrf93/wvLiPaCu7ftac672YOCWM=; b=LAaEWH2iROZAdelJSexoqT5L9g
	DUwCoFx7uhLVtrYKu2vF5r200EptxUTiZLgUhjfQckO+Ka4SSKjV8tNzaRB2Uf1xTfoStFR6Tyho/
	rIrIbTFXfJ0hOO+DINaHeDZX4HSpfcnIsj/ghZxAMRtQwQaMI0OYGohCQbAw28GwW4vyyKW38qEqB
	g6w/+7dygGXHMay6J/LpAQtg9MzB/Dk/8StCZi7wCQWDD96CkGceE5zDFi3uvPmHXQcwxkZIG7rcm
	J0T+WbHdKC5Is24MfQONXA6Sp6c82pM0dptETpNPJd4JDXAscoFn90U1/SV+7v/R1eqQ+A1JsoggK
	jj/IZoTw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLIL6-00D6Zm-0M;
	Thu, 04 Jan 2024 07:40:28 +0000
Date: Wed, 3 Jan 2024 23:40:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	willy@infradead.org
Subject: Re: [PATCH 8/9] xfs: support in-memory btrees
Message-ID: <ZZZg7JMoV2FnrkVi@infradead.org>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829708.1748854.10994305200199735396.stgit@frogsfrogsfrogs>
 <ZZZUkq145pW64Zzo@infradead.org>
 <20240104072752.GC361584@frogsfrogsfrogs>
 <ZZZek95Tyfuxz8RQ@infradead.org>
 <20240104073331.GE361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104073331.GE361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 03, 2024 at 11:33:31PM -0800, Darrick J. Wong wrote:
> > Happy to do it you don't complain about all the rebase pain it'll
> > cause..
> 
> You might want to wait a bit for my XFS_BTREE_ -> XFS_BTGEO_ change to
> finish testing so I can repost.  That alone will cause a fair amount of
> rebasing.

Good idea.

