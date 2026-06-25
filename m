Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AAC329E46;
	Thu, 25 Jun 2026 12:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389521; cv=none; b=EQu8LeGmbkYCxQx9NkKechh1zb1tcnDqw7coRbzgGvVg1DJnQmMKoyJlcduypTgBnbDjDJqE/4k+wyKnl0JfQ8DGD+aqwmspJbHinCPuJdn0jG0V3u59GPG66pNv+Ar4AUa5NgZwtBMQ21WDOC5MKM/tGMoJzEt0/PYZSMIt2mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389521; c=relaxed/simple;
	bh=KlmQV4tEVDrxf8sVOorcuSyS1DcYFMKjw0saPFmmK+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fwVPlKrvxVrCyd2EQB591VbfruBhy8Zoz8YSD9UDM/oucOutFKiOg8+S3ax0XP33C+QG+EdeGm10kcHUAjpUzHsL+iMTSxff7G0rVp6b+Ax9/CHbcm3KewaJjuXjHokLGdIkgcWvTCB91iZQ5N2lJKhHCU5/cVDF4mxrVGvez+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CRXNOXrV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CRXNOXrV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=HliYnva+5KN1E+V4bq3PVoEHb8bbV3JhWLB6Y70JEp4=; b=CRXNOXrV9IbbHk009wQGE7S2Zc
	63ozwRQpJek7txIp03qIs+/lptFXVmZRQV+QouHmJ/QXoL9wBwN7XjpcHbbtemwqtWlbn8B6K1bBx
	r1gUNMTrfaVAHMesutX96zlS2RsIJ5PLfE4Rvx3FAR0d655ALcZHKku8mc3zbNNmaTKpbwXakTdg1
	nBHOwBaggaeQzwtuyTwr5czwLSjbtI111M6oEpJYxH+YjgmDsTS8cazxmXRwkoeIPGsUgX0qr+mjf
	BEk8QDwwtmIxEs6/ai3Lkzl7M1H1pvXFe0N7EdsxAFbF6mVh14At8eLm+8PQsvE4bk+Au5pTMUzqv
	2+2DySuA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wciw2-00000009AIS-2CXF;
	Thu, 25 Jun 2026 12:11:58 +0000
Date: Thu, 25 Jun 2026 05:11:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: hch@infradead.org, ritesh.list@gmail.com, abuehaze@amazon.com,
	akpm@linux-foundation.org, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, david@kernel.org, dipietro.salvatore@gmail.com,
	djwong@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
	rppt@kernel.org, stable@vger.kernel.org, vbabka@kernel.org,
	vbabka@suse.com, willy@infradead.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order
 allocation
Message-ID: <aj0bDijqj1-Bjxq1@infradead.org>
References: <ajvc7fSDngyx0X5j@infradead.org>
 <20260625091039.24501-1-dipiets@amazon.it>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260625091039.24501-1-dipiets@amazon.it>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 25, 2026 at 09:10:37AM +0000, Salvatore Dipietro wrote:
> Yes — all the patches in the result table are shared within this thread:
> 
> v1 (original, iomap caller): The original PATCH 1/1 in this series
> Ritesh's suggestion (mm/filemap.c): Shared in Ritesh's reply on May 3rd [1]
> Matthew's suggestion (mm/filemap.c): Shared in Matthew's reply on April 4th [2]
> kcompactd background (mm/page_alloc.c): Shared in my reply on May 6th [3]

The page_alloc.c change definitively seems like the right thing to do from
the high-level POV.  It would also be nice to find a way to centralize
the logic for which flags to set in a central place as we have quite a
few other places that want to allocate large folios optimistically.

