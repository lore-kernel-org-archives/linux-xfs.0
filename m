Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982F4146A6B
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806974; cv=none; b=S6MgPTWkbwycUOmTNGePNhL75Xue9gbS9g+g7tTnBDFb4GjY/lSabvDY56LcQNpyRV3pUeuatnJwHk9Rh0o0YiFpl6j79FplGrWBliRGN6gau2ICQ8HGQwTZGkF+5um1XI/WmyMgDk16MxVV3V5p6OC9SzUdqjzqWNArfnO+o/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806974; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iDEvW6H01w7Oe77t83zCwTVCA1lKf66bvPl/PNH3mz/j/YKgC5V39Q6l0cInBP/+/u5R9CcWUcpM97pHW5Ce4FZp9rc8YUnZIjLdK1MDXoYGJp7FajfWPzxLKKN9vPO8LokHKEyD+EyCrMOR8UQxx2Dc43gYwcJrsin9gGbsuvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g8QIAd0K; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g8QIAd0K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=g8QIAd0KUoZuq+kaTOgyjExHKA
	kd9WtsisnMVBhWx86IWR7Flx44M58uk1zaDTgdSpLsGGlOb1/kK0AXhK5Qh3kDTDBn6G2LbE6rHzm
	zwxM5Yyhiki+1Wcwbwhw16ikdNQTUwHKTLpr9BWY+JZ166FdEQiE7iL2ofHU4EaH70YvFVXX2uDgA
	5nmTH39UGLJUMfd0KAW/MlObAQuUO7k0I77qQb2rAVUks/5XjcStCEjPhx1AaRknSdghYeKTmlTj+
	7pH0Gvg1YbOkvUYb0BpAfONxe1ZUHLPaeJvkn4xpnKEllcE/h5iwumxoyrAfRYFuwfphJkxot5GRQ
	zHg2EdTg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsOb-0000000AF61-12yl;
	Tue, 10 Dec 2024 05:02:53 +0000
Date: Mon, 9 Dec 2024 21:02:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/41] xfs_scrub: tread zero-length read verify as an IO
 error
Message-ID: <Z1fLfUpni3zb69mw@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748513.122992.17419278779179180704.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748513.122992.17419278779179180704.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

