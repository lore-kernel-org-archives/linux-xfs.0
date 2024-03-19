Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473A740BF2
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 23:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710889432; cv=none; b=JF3Gfu3T9lOQmYdxv0na1UY+dTPPdoRfubmvLaZo037MAS4+6mBzmx88oCkY7nvfawtLp02gOV02GjbGinC2DmezdsJtKDHL5cChNvSsrEZkAhbR6fenqMitAYG0DTt9f3OSJrvLNeE6P5blqH40voD+14ylyCswQmdgeu3+T4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710889432; c=relaxed/simple;
	bh=+m0blcJuNbEbXzpke0NGzTyloVwgC9XirPkM0oF1pek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IbCe90GrGBCtvkvBcWlJseekaaWDb4nAjdbuX8RwK4pcXfrpeOZYYpK/ISQq9+mzbukXesaw5JW2E9RuQXs5GfTNiGGHEycVdXvXu/SfexbP3tOF/lMaB/t/RLgFQJXQZ1151AsPMCxrmb6G7CFi+cQuOOC9zFfSUpK6QFSx6NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BbyPUr2L; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BbyPUr2L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+m0blcJuNbEbXzpke0NGzTyloVwgC9XirPkM0oF1pek=; b=BbyPUr2LTKxlZ0i+puz2WO7nS1
	VzK22fuoluAhvyxFGr/FCh0lf6eExs73z536zbGY762kxfgSL4+chHWagN8Mup7Loz1/m3CeBs2yg
	ISye51BLBMSl7/uSHnUF2xYfEDk0670a6ZCQmCju6751qvG0B/xsLVpOne9B/TnMF+dyLrx9WpyTz
	JCrEiffUyYFmqWrJ3+nwzRdYxT3+qb+enyEUKKwnagCkVPjuTsflK+jVVTi4HDVnPJCvPnckS4QZG
	RyKBnY76nCWHaeZUtf4shGAWi69cblkGkyOCs9Vso0Z6Wxej8UmcgkJQbi3sZZZNjDRLfLiJyIsoc
	HRj3LHdQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmiUo-0000000EYjE-3c6y;
	Tue, 19 Mar 2024 23:03:50 +0000
Date: Tue, 19 Mar 2024 16:03:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: stop advertising SB_I_VERSION
Message-ID: <ZfoZ1miWetgjSWVd@infradead.org>
References: <20240318225406.3378998-1-david@fromorbit.com>
 <20240318225406.3378998-2-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240318225406.3378998-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

A bit sad, but with the curren tstate of affairs it's the right thing
to do:

Reviewed-by: Christoph Hellwig <hch@lst.de>
