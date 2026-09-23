Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6283944210C;
	Wed, 23 Sep 2026 06:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790144972; cv=none; b=qlujvRd98BsBQ2JAUvL+f0t2MJUUp6iO/Ddf1g8/Gb8DT5fNR9Vd3nDi1ArbCOMaEuxQqHgD+PkCZkZgMYpWb4LSoZhMCaR305ofpMO4rYjaE2ubvXOV6iYP5xjIFU8twq7r2NXI3kZnm6lsu5eMqtX1KduZ2UQUacbP3ysxlfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790144972; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OkT54gLb1WONVyXx04f5UXN9oJB3/ESti/jcF7CbjSWkR1YMVAqMKzZ7JC7xqtVq0Bg5uhaHkaew+9H9DGa8aOyQIVGuzyeQwgYTeFlDUmMpUkEBbku4+R/fPAajTBp0G3mABZ14yuqSxi3TLjEIy+OWNXR4qf2LEH3ZXc0jpQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4Ttu2sVQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4Ttu2sVQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=4Ttu2sVQ4cYgedP5sv9+JkJx5a
	hpKQOjZH/EeeUrjlzN6HeFcD32VsLy5bk47pCragB7OTm0FEfHTH2AE2O2VnmUbXMgzfYK4MDM0u+
	Ghj5Zdqt/8pSAhbDPQ9JljK4BS1aUp9oacfnbnIEriZcT+WwUeTZNAfU8PRFsVleoEgEoW/Wlb0BM
	S8v3NZaF0YyEdJaglna6Yrw5UkySifM/XCqEiEgVRl928tPWPeHfM1JFxMg4KlDLpwYgqaVaRdNFX
	sf0l8Txj/uOllLvWmgnxiANuNOXZrOgJtV/gF5Nv7kDGo+pxxdKCIoxa+2F7T5O4KY7DaKWzldyr7
	lSJy6h3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9GTp-00000007HSZ-0CmN;
	Wed, 23 Sep 2026 06:29:21 +0000
Date: Tue, 22 Sep 2026 23:29:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/12] xfs: compute the correct fdblocks/frextents for
 repair when they're negative
Message-ID: <arNxwYZmAHuUzKT3@infradead.org>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
 <179014159565.1875436.6766402511927424553.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179014159565.1875436.6766402511927424553.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

