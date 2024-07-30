Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E74145FEF
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 21:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722375626; cv=none; b=E3kAwFodkiC+IglvtoltPrJ0flAfJCwrJEx4ckaWhghXP5cLC4/qLhaNC3Sx2oIykQqc51TtXHC1J8LWvK1y90wacCaH4n9S7w1KrTqzPorCtG29waJ5XMOrIBNH8pI1q0a1Y057cEMjpUECIa9DRkjYdL3Z+Q82MgsRw6v5KGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722375626; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OQA2/uocdaPdt6T0Dwhj7PtauscsyhqQJVwfnkfv9Y5e/g2D0bIX1V1Y1xkT4gziQiSJQZaNOCWOWp2mUyokc3lcPKVD3mJm9baOI350siHn7V/puYhtB6do3A2oya+LPvikl/s+OOlfCpyTnLCAciKgfqmTTxYedxc5RBWuErc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ocTzcP++; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ocTzcP++"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ocTzcP++DE0pVyv+CJc6eL5sYn
	8/Yh1f8BoheKRBr+t5yEQqNPiXWzgipdyWfwj6eEYLB1mXikgN6TkzXe3p7W/HqkjDgeLfsPuAVl+
	W3bvHZQ/D0vWbem+Py38VQOJtgbT4Tdxkn60w7ssG6WxhZL69zLDtvr+eBMWSvKMvlWiNFFLWe5ZV
	AlOH2zex0EXdDflS7ogQy8ADbfYYtKWoHlf7wC4SBFDS/NRBLFO5iYRFr9ZgWXhgdu8WPBqiGW9XM
	D6S9Ui+wMj6fSLXucl1pd1TCc5y9PnesNoxcMaImrtstHP0D9WF4ae12jGYPSsXMwrhTW3DdXtg74
	KATXk2hA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sYua0-0000000GZ57-3P6c;
	Tue, 30 Jul 2024 21:40:24 +0000
Date: Tue, 30 Jul 2024 14:40:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] libfrog: support editing filesystem property sets
Message-ID: <ZqldyKh-2XfA-UOY@infradead.org>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
 <172230940585.1543753.1262767533961990704.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172230940585.1543753.1262767533961990704.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

