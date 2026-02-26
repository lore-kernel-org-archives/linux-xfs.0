Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D666B3EFD1D
	for <linux-xfs@vger.kernel.org>; Thu, 26 Feb 2026 15:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772119910; cv=none; b=KTWGN8RgkXhiRh8TTuo9A4fZ63rW7On1u250+x1/faC+5juEApDfm8aU6R3MKC0mQ/KjAioPqSmhvKdczCuakn6SsXf1b4H76a1k0EB+Bs82tK0NsTTw6kPzZy69TZ2H+Cyau+zP8JoM5ROiQlW6a0VaPvARHxkmsonyY5YmJmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772119910; c=relaxed/simple;
	bh=2Rv21dcxlkWFMcHy9Fpbt5sXORxWl9mIh058ViyUjPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F2udwTw2IaOMM3r1EGlpv0pzDLEXxazycJBiP+4FujwfH6H8gG68OLowqfZG0XCXSuRb2SCBGOM7dindPTsV97LlpuzEO/p+z8BKjzvhlkmCRaLB67b7Polt3DUhDf7+yAGoa79QfmKf7MEtQfMQ+ejOwG0e2RaSUPDFqbiD4pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Btxf2Mx9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Btxf2Mx9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=f35/tuCgwOdoS1bITw0f1myInnjcrl7dr1CtVe1TRuw=; b=Btxf2Mx906/fxKR43RpjJvBbQc
	1rHqzcCP55w6BJmNu+jfWvrmHpEOHVXD8p6FQHtYGTWnfJTxvN/0MiOqQkOn70yYM+jLvLiXV+erT
	261ZBDApS5+bHTrjQZb95xhaCGwsUUYb9CSaZV3RzuSQ6yltmcKenDoZPL/qvlY7sxe88dgwstaWk
	qRgjrp7SWtViQciV0aFLPRjgofWUwnKtZsF106JU4kD5sLJcs53cVgmAqfh9NAL55T99lML/XBcUd
	18j2HbZ+F1In4oShpKnBY4xzcJGGa3i+mbaD7C7cahM6T5JDldeMZXG6pyoGpDe8vcaLUO+5Gy44P
	GA3Th4Cg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvdLA-00000006W80-1nti;
	Thu, 26 Feb 2026 15:31:48 +0000
Date: Thu, 26 Feb 2026 07:31:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH] xfs: remove scratch field from struct xfs_gc_bio
Message-ID: <aaBnZNe4MA3ppD-O@infradead.org>
References: <20260225224646.2103434-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225224646.2103434-1-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 26, 2026 at 07:46:46AM +0900, Damien Le Moal wrote:
> The scratch field in struct xfs_gc_bio is unused. Remove it.
> 
> Fixes: 102f444b57b3 ("xfs: rework zone GC buffer management")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

