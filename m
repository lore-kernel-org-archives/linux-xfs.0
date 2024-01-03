Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0176179A1
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Edffm483"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w0H6DGeFkN/a699Cd5dFBbQXdACnAyfBxsZYd+SCE/A=; b=Edffm483dyhCuOUBVogJwUHmwC
	fHALPkrNCJ0fauPh+iv7+KhrFgDaNMRWdANGKsHLczJtJ0RDf2dfK/VB10JYyQI+ccW1E9qSCdE9W
	uUkyLJUgLXniE3deYN4gAWihzsvGqY5jjIvWxU+7Oq/TxpFt3CGrYMRZ3fcNwiYEdHbswoHoCnGoa
	GbGc6VV6JqOU2Mk2gfzlUIy0gOXJ+DMJR7+qbSc3yPtzwt2TBWEofrpiZSLpbtujbB+8omMOsJav+
	+mWgx5mzSAlU5qdF74R5IAtPrryNoGnN0/FF7zos24lxekgiBtQWI9+qPknyUxDWKKFITYt6hzYwk
	SV4iYsNQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwvF-00A7Zh-0v;
	Wed, 03 Jan 2024 08:48:21 +0000
Date: Wed, 3 Jan 2024 00:48:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfile: implement write caching
Message-ID: <ZZUfVVJSkvDRHZsp@infradead.org>
References: <170404837590.1754104.3601847870577015044.stgit@frogsfrogsfrogs>
 <170404837645.1754104.3271871045806193458.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404837645.1754104.3271871045806193458.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:40:40PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Mapping a page into the kernel's address space is expensive.

What do you mean with mapping into the kernel's address space?

Mormally that owuld point to the kmap* family of helpers, but those
are complete no-ops on the typical xfs setups without highmem.  But
even with highmem at least kmap_local_page isn't too expensive.

My xfile diet patches actually change the xfile mapping to never
allocate highmem, which simplifies things a bit (and fixes a bug
in the xfs_buf use that just uses page_address instead of a kmap).

So I suspect this is something else and more about looking up pages?
