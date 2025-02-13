Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAD92054F2
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420490; cv=none; b=CU8Dn3KVeKkjEzIU2C/27999YLKi69/ULUbZJtzg6GehHZNo+gagKZnXJc4LaGVBQkbnzsWzOV0+z3Yq6Bv2R5WCTaBgr0UR75e2nX52tJ0t15ZzCgIRU7k73wXgTxXrzmcIpu6uwZc1cO1stYJmzwkl+Jsoi1OcszjW/Lq16eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420490; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t7v/pmTiwtMg4PmXSfOcjGO3jP/RBwG0ggJEF2LmE1u7u6Y+haYtqHCETTrctrsGaISkNCELzo/o0p6bMj+Uk6r9MUoLZ1VieovVRzPuzZ0fsisSytlv7YakPrhTnDpOvLYgKAJ2dE+cFwncXf6sOZdIUHSD1l8rnfqcn+swRPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O5H99SPQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O5H99SPQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=O5H99SPQrZ53WeBz2Z1Hf44PSw
	qYMcT+qTIbbDhz1MTEcohELSJ07qWYQ4bWPU0lxXEAfm+bvPwpnq47jEZo96Oj5w6qlVkCDUj8Abd
	pA+opjOGt3pqKS+JGFkoaaIuSViHkEeCXtMn786NL33kcXgibEkFItUTlBeyMsxJqd6ZnGfK1xJt/
	SIcR7oCybwy8ezQxpHhqlGMc3DiAzfjRGLdJSpOw9BB0AQtBeFq7nfWHoY5XwZfzap/Tzypufg4Co
	zUNHUFiAgVX8+OVLSfvStr3t6k2OWn9F2v5I6BZh4fDQLywFAuegK+wVDO2sLngtJnCW7AFJ7sJsQ
	KZ/Dl3XA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQjB-00000009hwJ-17eT;
	Thu, 13 Feb 2025 04:21:29 +0000
Date: Wed, 12 Feb 2025 20:21:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/22] libfrog: enable scrubbing of the realtime refcount
 data
Message-ID: <Z61zScgT0I-j_NWh@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888088996.2741962.5133912501507693446.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088996.2741962.5133912501507693446.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

