Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B7C12D1F1;
	Tue, 28 Jul 2026 03:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785208570; cv=none; b=eLFsRQvFyJAnFmvKs5TyCSZMRVM/f9lxgK7tc1W7iZDykeOPq4TeA21Bb1aKtj/89wIh8VvqT6HTMoNx/wJcWtNdB4l6Je0EyP+o1mhUWqr4kyVOAJJBLzox8VPYKSObDbeNjdswlHGbk6FeDQej14tAAvoiRSUrVybdVUprxLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785208570; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o/VS9OZfANN4OerIehPixdRKKHfzbAuY5AA2e7CTyRznMjtBvunn22kQc++prUia2cu5aMbrGxSmOX6A1yF0nIENOC8WS2ywbvqLjkPl2zVmcmieQzmpRK85HRgNABZXFCE5fqte3Dri35fxnzl1dF6FHuzUaPqgaWHBRfUM5c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Yrxc0i8R; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Yrxc0i8R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Yrxc0i8RmLnt+4NGXVzTXil/HG
	wrYT5uWsH446sxPUwpcnmxNjRtIQRtbgwQJ9RwMINf9dE6++UE3C9/Ez4oTqYBszub1CsfrFqgXA8
	XjHIVYuVT33H2pw9Tt62MiIteUFFBwYu5BDDP/vdP7WoFWOOU1NuPFFtK3zfODLeOYQA3sVawoJKL
	tISytTShFiGIzHYakRLfMdLSTBdA6caNcAFKvwUnj+1RngAfBUkjQjVTlWrVagI1Gp3tdOs32kPkv
	xGvUjL7NM2aIZb/eyuuy2d544lbJbk8Tg2UNVWbaS1eBqAuRm6v7M/pwtnw/Vu7z9nkW24dD13lGg
	iAhiSElg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woYIZ-00000004JeH-3ojB;
	Tue, 28 Jul 2026 03:16:07 +0000
Date: Mon, 27 Jul 2026 20:16:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: don't ignore runtime errors in
 xrep_iunlink_reload_next
Message-ID: <amge97hC9cRoDzMy@infradead.org>
References: <178512389537.1495075.1621818931849629575.stgit@frogsfrogsfrogs>
 <178512389808.1495075.18295643958709747985.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178512389808.1495075.18295643958709747985.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

