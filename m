Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3D1EA4
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945609; cv=none; b=BOqsWHkQnk2XDS1HYVge/ojnMA1d9VdVxdAW+VO63DoOIlJjuQnaehPrgyzzWhWw2QlFbvDmfOGDyZLfuaSMG8KAG7FgzkLTlsKzKT1S8xfxibcFGhAlXu1fztcsjVXow+zP6JTZWo3u7lzsBfocKPqVzI6liD3puaPkeJRsKSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945609; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ktY6yRtd1MUA6cQCTochGQZGen0de+TyqZSOjCD1dYwD/tz7rBAKHWbUhQz94qSJvRPWNbhhP1JPdb/qUBQNhPuDWh6TIaoj+Ue4sUOnqlkXsYcRoKPKkG/jRhxsMfMuGNUjigqIr5N0gXeNubR4D5k4AmFEwEs5tmABmgBBi0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R44GBHiz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R44GBHiz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=R44GBHizLoUI9cBbANeyOXiy/i
	UKQTxwnlYnQ+7A9LDKh5uRnyItUyh1TFOY8pGim6JuGj6cmsULNHwVZDbtmp2MiwXVKTSaygOv+EN
	+2qMJ8UDwlwts5DnhExZ0u5Ol4v3mVUq7MsEhtVZ/0toLXTMtiQDy6pciHDXanEB2TUBInH8UsFiz
	vwNBhNKBfMq6PdEfoyR3JxNSl5M0fe9MGkHoQMhmiFIGCdKDIQzpFHzIzs/io/H67UvGP1QM3DXzo
	dmHeUsXhCcfjFHajZAxXzPRonk2uTtvgnSR02ys73k8ZnJnwXFMfTt27oUpNIrBUNUf1YEWpQPcEg
	uELKFpbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKWHA-00000007gv9-0ajN;
	Fri, 21 Jun 2024 04:53:28 +0000
Date: Thu, 20 Jun 2024 21:53:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: add a ci_entry helper
Message-ID: <ZnUHSH5xca69C9Yw@infradead.org>
References: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
 <171892419875.3184748.10263305750216565433.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892419875.3184748.10263305750216565433.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
