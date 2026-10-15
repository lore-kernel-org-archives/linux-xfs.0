Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CD53C345D
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 05:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792043849; cv=none; b=V7768SzKrnEa/PNW5v8MHkRHNLFzYm7zuUsd4goGllmA124TpPTCXCOajpG9XPpS9dhVEzbDhwzaNgHgXufmoVou1z5S39kSFccsl5sfRHs3R4ds/wOx2KztNnQOFxVopPtoC4ML/DrwElYi5iO/nCRfU7toIuRBXaRQEH3f/io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792043849; c=relaxed/simple;
	bh=V7vFuxeyVWzTt+HGiuWcyCXHmB8QST4cDqcAk1nO6dw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=McooPfprGo6Pc+uGFJM/bF/Hz4Rjf/TNxCNSTxmYrFOlBOPgpPIisSqYHiO8sjf6xcGvZPy8r+V7mjkbHBlmEtfZIlxI+JW1BpRG2mU2EyHwvXQ0F/iLi/4INDDC/dxmBiSC2ypwGg78ghvMfHB4NYLLj+2m4mG4+OXG2gEHi5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S+oAxwq1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S+oAxwq1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J/rxbr+Sc6h8ii2R24dmm29GoJwDfYC3Jzk3EP31GmY=; b=S+oAxwq11F3PqMEU0lnfk8Aqkc
	7xi0dmqEbhn9CiVJ4xkk99TPQwBVQJuvCJHy5z/64kuwd4DCbOkedIJOwne1KU0IHkvmdxyi44RMj
	rxP6KrbSvS9JXbBXhbbTeIwcCJvvROG7TG5xrUiN/yOTCB3pvGYfkgz//PDF9vAwsSNtCnWoFSw6V
	AfOtv/2f5zBgVW3LT1ALHV1JWzdijXWEjqGsF1kmq8yXmh50Mc7nfDFpzHGwTnchajYkqGfk+eUOk
	ceO7gep48R7D7mzqRLAVtLfsdgwb2yKof2CVgGkpRNfq2y4T8H0ZcbtQooy0Q8Hwi8Fdi8ddZjLmZ
	m1duPzhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xHET0-0000000GuUH-0Oh5;
	Thu, 15 Oct 2026 05:57:26 +0000
Date: Wed, 14 Oct 2026 22:57:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: fix compilation errors
Message-ID: <atBrRijDavx07ekv@infradead.org>
References: <20261014174442.GK2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014174442.GK2705364@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 14, 2026 at 10:44:42AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add includes to eliminate warnings from -Werror=missing-prototypes.
> It's not a good idea to let the compiler apply the default function
> declaration.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

