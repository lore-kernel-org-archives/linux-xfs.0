Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3AE4F895
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 06:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710830322; cv=none; b=NYyqgjRYU/qeqG7yqEaWzrQyC9p6GYILRvQxLiGD2pQE8Ly16mlDyQ2GpAD4IlZNspfBIOkU/UTCYgK6tMSaNSPAXagwEhlVDLIaoOnOJAn13bZ3MkwZY3lmF0FMm5KfRiX5oPgtUNQyFIxUq0i99tNuy/p69sGdqN6UlV+Xc8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710830322; c=relaxed/simple;
	bh=HtSTB8odnBQcuz29Lg5FEEBlZW5TPQLlC+abyIB2x34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AnZv8Dmba/5aUXZDuFQIYTnYmNxZb3lM8ET3vlcOeJtT96IQB/QBP5hObPgS5lhf4ECWIDxQfKywsF1oDieGGlLd0N4ad1uFHtqs2qKxW9k7lUw4vXzy3sQ9Msg1TvkpDKX4PmI7EG/VDSLkfV1/XW7QfX5IfM1nseUa8UlFX+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DHLB3Ojc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DHLB3Ojc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AgGw9kOZYnx3c2WdX1ttaz7AGS2CetSGSiZIJtPgmb0=; b=DHLB3OjcyHU8Sw0URRPEdQFiEs
	wWDLpCHhvs37wCOWbikeBPnhf2WdkueAnwXfVs1RIc5thHlu5hfPUFsJJbOM6Mzv9o9QEkgDv/e2p
	ddCfrWNIpzo/lzzs8OZo1mhAAtUJDf+RcnJ9P+iK416ZVsB8QAKBXXHXM1mAyt5VQvWziiyIeAvWK
	DJPhVTT2Iy7x6sSoSbD4PICDoHGBsBd1FOX4ywQ1DmO9pZ1eHkn9sooOdzP/9rDwiVXT7Xqi784Xb
	qYyWwF8cQxBAgXE5dTEe60f5AQ9dzufz828qglpNERg6ByNBDb+WI1uAX8zOGTVweIa53+XcV1IHL
	nVgfTzHQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmT7Q-0000000BX5J-1BDp;
	Tue, 19 Mar 2024 06:38:40 +0000
Date: Mon, 18 Mar 2024 23:38:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: use folios in the buffer cache
Message-ID: <Zfky8I5dPLQ7gV9O@infradead.org>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240318224715.3367463-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 19, 2024 at 09:45:53AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Convert the use of struct pages to struct folio everywhere. This
> is just direct API conversion, no actual logic of code changes
> should result.
> 
> Note: this conversion currently assumes only single page folios are
> allocated, and because some of the MM interfaces we use take
> pointers to arrays of struct pages, the address of single page
> folios and struct pages are the same. e.g alloc_pages_bulk_array(),
> vm_map_ram(), etc.

.. and this goes away by the end of the series.  Maybe that's worth
mentioning here?

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
