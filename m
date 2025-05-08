Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1969A134A8
	for <linux-xfs@vger.kernel.org>; Thu,  8 May 2025 05:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746683694; cv=none; b=NiITKzgbFHDl2CO42tiKb13ylmEGIFPrHLhM2MTa7P/tjFyZKgSirSHFseruvL19PYPJ//lJJhRb70xJPlJ0KrRSmvjpGUsqvPx0XxwC9aFRXBbvjAbqfGb8CO1i5f+ugLh5l4YuZnGeof98XxS/FOjQ/duq/RXOz0IvhHS0cWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746683694; c=relaxed/simple;
	bh=SCvrBOI5eKls2HwTMOE1BmHcOhVpcpmR/I/h+Bfjeyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MPxdyMWhLrgc2G6cdBexJX6ZcXmFBobdRBkK3M32vzSfKwn2JVQ70vVl63UyT/JAvInikIyjWPNSqO6jzpFih2ppKsBlOEOOsOs89ZbMm4D6Y6HHBNkKSc+x16fdMPSDpp4qYGx4PM04niTbg0SrA/kpNAAwA1DwfjXuv4ZboMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k4G6HmmV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k4G6HmmV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=r0mj/qLH15/lSr2WCujRuSib4VsfNz3AvhCNoH2/qCg=; b=k4G6HmmVkm4SaIn1J9BbA5ZmBu
	33zZFoCtTmeY7YZOBHs6pOJOo4v+vgaguO6n7XRp3zlygIlS6LaVx3f+zl82SXPpnnO5Pbpt1c+lM
	PjupQAqpwSbD2Jeq5oYHgbOaVqDPi5v0NQAurH3Aw4iDVxnNlUNJmS7KzRFEKde2VGQ5tp4hSIw6o
	0v3+HWzqFQi2Hk/FjWLVvrubzUg9gdyB72i4kg1h6P5Vj5YXE5+J0fKIqFUU/7g4DdtyGThXaOLQK
	xxzlHNLrI7IrXmROru1bSGVJxtJHICRa80aK8/7jCOAFNaK9UqYpvD4PrNRtDCAmaR2eRo2uEGM1B
	rs7D1xbQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCuDc-0000000HPLd-2wbo;
	Thu, 08 May 2025 05:54:52 +0000
Date: Wed, 7 May 2025 22:54:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: dump cache size with sysfs
Message-ID: <aBxHLBvotK0IH3tE@infradead.org>
References: <20250507212528.9964-1-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507212528.9964-1-wen.gang.wang@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This is an awful lot of code.  Why can't this be done in eBPF
using the existing tracepoints?

Btw, it would be nice to collect such scripts in say xfsprogs.

