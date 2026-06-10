Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5A032B124
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jun 2026 05:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781070988; cv=none; b=Bde2otxaIK0wdz47t5e/9F9GulxgtpvaIs4eATkcb2qZgPFStyzDAFmE24ImCZdF5OA+Hwq3MqdALWsJ0eBHgESKZiYdz8Dw3S4ObUCKTK4YUzWFYJRJsb0mUUm4K1T7J7wdf3c/XQRwnl7S9js8Ezr2XqfqWEDRHtebTtRpauQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781070988; c=relaxed/simple;
	bh=X/Q9fcGEjNuckPz0PRAGVuKdbkxTriizRKw9jhTgDHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fZT2NwEECCJyaNwuJdiaV6uQpYvqz15k0+emhdRQKdfffBV8BrvKQbbEC+FYPEfZ5hKaCGLroeQ2e3BC98aecg52SqdzNBUCRmieKd9zV24JBWuUj/TiEs0EWtEdsugaXND2bGsgS8c8i1VTIzC8HvYejbzVs+eLesCv38OZy64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2tNLIQxP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2tNLIQxP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eHH6CXFILK0fJwgs4Oh7lZKlQ49O3BUNo+xsyvmXYDk=; b=2tNLIQxP7leLMUSkx7ktq0DIWp
	m04IkGEm1KENn1YdZFMpszecwsIXZGF4qFbpWLBxSXwb9/RperS4mBPe8eNHkrTf4TnZIvBlbsd94
	AruaW25xrS6utCcBajo6yprPGsmjxPaQtuSSMK9+Zmt9v08cvsL+Qn93BDNpNn1w7T9XEiAJEM5gu
	5b2wZlXehJ+m/SRIsu1VKEAxkfs3Z4RIXLW9pw0WkH562YURBgctoxONruscfQNlYFGMDIzkqDpLZ
	nG63lGGvFNx/QaE5COOh5KoPKorKrjXYo9bcGWPvEs0NjMcmmq+Jqbl2pxjJTylqQaygC98JnE+xn
	kyG4LBpw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXBvN-00000006qZf-08b1;
	Wed, 10 Jun 2026 05:56:25 +0000
Date: Tue, 9 Jun 2026 22:56:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pankaj Raghav <pankaj.raghav@linux.dev>
Cc: Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org,
	dgc@kernel.org, bfoster@redhat.com, lukas@herbolt.com,
	"Darrick J . Wong" <djwong@kernel.org>, gost.dev@samsung.com,
	andres@anarazel.de
Subject: Re: [PATCH v5 2/2] xfs: add support for FALLOC_FL_WRITE_ZEROES
Message-ID: <aij8idPnIDnDZVvb@infradead.org>
References: <20260604101442.2613872-1-p.raghav@samsung.com>
 <20260604101442.2613872-3-p.raghav@samsung.com>
 <7084832c-800b-4248-aaee-3da5ea266c1f@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7084832c-800b-4248-aaee-3da5ea266c1f@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 08, 2026 at 12:20:29PM +0200, Pankaj Raghav wrote:
> Sashiko reported:
> On 32-bit systems where size_t is 32 bits, lengths exceeding 4GB will be
> truncated, which might cause the on-disk inode size to be permanently updated
> to a severely incorrect smaller size.
> 
> So a simple fix would be the following as we already store the value of offset + len locally:

xfs_setfilesize only cares about offset and len vs the final size
for tracing, so this works fine.  Not sure if we care about the exact
tracing here.  The other option would be to extend the sizse of the len
argument.

