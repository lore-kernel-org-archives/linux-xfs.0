Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7924B442399;
	Mon, 12 Oct 2026 12:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791809154; cv=none; b=ZRFIH//kW4G84O9WFfawrIov3jzXCQzsNAm9kjvSrFcHxMUB6DsKm7Kj2n1oa3MPr8oFuxbxiMAgQKnmBZEabWv2YK/bwiSyuiU6KB44GgIBYRXo2fJQvu6gDS/0wiQPsWj8QA48l/M2iIsMaBY6KvUHTPTDYaPvoeyqxQDNfsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791809154; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NmTVOXmAFFfvovl9xhP0yo1Kw9uFaltuufCm+OocxGUiZ1RFXD9fl64NlUTp4y1hib9LziYeJlBRDquUWxwMrZSgPXveq+5t07e7b7a52HURPW4wU8XkEa6EiM6H7WIj/wxAzSPnRUaohyyzBVfFu+8vVOwgL1ylhAo16kirIsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0DPKA4TR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0DPKA4TR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0DPKA4TRzLziyPRoSBO0mKmAvF
	JvFsR1KWybm3nKYQ0N3AdEq5XKVAB2f4ij/KkjZvU799pv4RSo7OOf4Y0gFxLWFRDlrhoXxpWe7Am
	4CYAZAGmNbpwr41L7UKBBtVqNcFklusDUDWi+64+xSwzdwKGA4SkP/KgxA8eVs/m+uljLLBaq7gK1
	EqNCLGPmMYI2Wg2DnA73Zb3q7XY2zUG4jRyX1xTj6yYQxFo4rEhmtY2OasNV1ubgLtltrvVvxRaMt
	jmxPmEzM46IFD7HfqjqoPh9TmwzqciJChx+JQTDz8sq8+ew/j6HL4q+9YAItgm85L3N4KLns0/iIc
	DSAzV7aw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFPc-0000000AUkT-3z9A;
	Mon, 12 Oct 2026 12:45:52 +0000
Date: Mon, 12 Oct 2026 05:45:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/13] xfs: clarify various parts of the bitmap API
Message-ID: <aszWgNrD6To9CJz4@infradead.org>
References: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
 <179151614880.3163896.16302102024358516968.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179151614880.3163896.16302102024358516968.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

