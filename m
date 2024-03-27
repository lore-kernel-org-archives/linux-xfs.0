Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAE6208A8
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537516; cv=none; b=r8lXJX0YRXWysr3yccuUzOPpR0J68Wr8LpNn2vxFaSVfBHRlvftclMdz8jetoSejcP9vt2R4pT2CxIs/P5wYKwg2/bJEVFj6pCL2qp4ihd3v+1I4sWDxbCGYSTdyxz13mLraPWQpHenNQiSOn1W2BxQ+rNpGiZWU55YPSHZmFZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537516; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F+7vdAdGZ9gyV0SD9yQUOsJnTYYd3uboZmMettY+Vd0ZYyv++dxIzt78HGqZPz2/o2ulYhRucFom5+GdY1pJNLCKryJrSqfuVx+E7u0RYVntMLDGg7Xei+7TFWRWfDKex98q+2VlkdCH8rHenJrbl1IyvkICrH/cTSqlh0CljUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ca2PpuSl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ca2PpuSl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Ca2PpuSl6cogF0aQKNIRqMemo0
	agPu18GoJ1m59Ydv+4+y9rway8W+NLrtP/UhWEG7OKVCDa19f1gHS5qHAhEL7LWTF3an8T0u0/QaW
	9o9duDXgrT/VQvC6qrfNt4nDSVtJpc4Uox+xJHqhaLO7oxhKdlmtV0wR0NFif8lUN8lAN2hSnzjlW
	EckJSLx71p10TG9O5ioKWRLXKWRO6L+do8zMmH+SidEgqUdMxlHK9f9eGdgRU7f5XOYHImcLhZEM3
	etPnqoX+ucj2IVVbIroDfmcpeGFEnCqnWTijjI9hK0n4i09mT0DHkY6RlYufYZi4zarS5qkj0wIbs
	BntqEmgQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpR5l-00000008XHJ-2wKC;
	Wed, 27 Mar 2024 11:05:13 +0000
Date: Wed, 27 Mar 2024 04:05:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: hoist multi-fsb allocation unit detection to a
 helper
Message-ID: <ZgP9aVpEvn-OCQml@infradead.org>
References: <171150380117.3216450.660937377362010507.stgit@frogsfrogsfrogs>
 <171150380216.3216450.3675851752965499332.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150380216.3216450.3675851752965499332.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

