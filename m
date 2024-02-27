Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F156513A890;
	Tue, 27 Feb 2024 14:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709045683; cv=none; b=ZHLTLmu/dwIYFeGQ2Nj8OgGqPPHWmkkimWm49x7Ns5ZpMd3fIqswzZJDiidmv43kbjGpx7T1JyGFTmScs+MKeRpUZ8lFBG986oco5jg/LPSIDjmJZjuF1YWe/AOxgKrbWRdg2GeWkQHc9g5IE61cX2MezCi49d6GcTjzBO9G9eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709045683; c=relaxed/simple;
	bh=nSf+WEczevsB7x0Q7g1k1rKqLGX2YwUU8MRLGHEnDok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aPoSStT7VA3ncxCNfjDmmEKkhLnNqPLRyWqbdLFcgISjFej4qP/SWuG3WYmr8u0Brepfp2vabhUIZWcEyjFZUQ2wyprQM1BDGkB8O/8jnzkD5+ywj40mWG5KYVJKpJIRna0kVZ48GpH1BULCkvtkLgo7ZPDc1GpNfcUKHoKWOR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0oZ0G7Wh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0oZ0G7Wh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=F5leWEpNJnuwCEHS+uHtrRn7PAiIrtYnGGSsInrqgrE=; b=0oZ0G7WhgKiNGT/PTYcUJ5Toga
	cG3VMblWYlnEg3VRwbw0qg2ondfmyzU/ZnwUpP2biyDlE6dSd/nUKWe/+vKwoGczLiQ/SXuLV81JM
	URvX3qwTvoIJ3FkK10YctetfgMCr8XZQ5qz04/FqiUSGH1619z0dK9MhiWU/OOsF5RouXK0m4mIRS
	jqNbErhLPaxQ8+HTtBNHm37TvhAV86qpgltn+MIm6MfYNQd52SaZl5FVI6pwoGh2me0ntWXOWcEsp
	tM5S8yfkK17LKw7WeXLhWpkmcowIrLcRijjbh4QcDzk0PblvJF9G8qITrcnB9JfvjYtqG+do4BPYq
	fZlty/Fg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reyqv-00000005evh-2Dt2;
	Tue, 27 Feb 2024 14:54:41 +0000
Date: Tue, 27 Feb 2024 06:54:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, guan@eryu.me,
	fstests@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs/122: update test to pick up rtword/suminfo
 ondisk unions
Message-ID: <Zd33sVBc4GSA5y1I@infradead.org>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915304.896550.17104868811908659798.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170899915304.896550.17104868811908659798.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Can we please just kill the goddamn test?  Just waiting for the
xfsprogs 6.8 resync to submit the static_asserts for libxfs that
will handle this much better.

