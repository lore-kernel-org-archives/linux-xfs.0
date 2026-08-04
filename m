Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A8C34F46D;
	Tue,  4 Aug 2026 18:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785869170; cv=none; b=g7MRvey33OaKB94N97RGnEK7meI47a5+7fqX73WVgHkn4gbocKK+xaj/axjO6dJoS8grprLVGf0eWiJ7SbaJMt2nckeAZppnwcU5rzbOKF1IiRkbxLYKSLlTq0+mCXR9ixN/39blMfdmA7Lc3+EAYonjVqgQtLIMG1KtlUw0WYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785869170; c=relaxed/simple;
	bh=DmPkr4gw4tpMES9HPzUjrPXjk5IhGZ0GPckfHPNBG9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gf3DhdtGWBl8kii/TbciQZDk1wKAdIAQUGngl8U8cGEmO0ObEpnmzNmtYASrJde4HtFyH/lackQNsA/IlcwLXhp89j190wOcxdQh8rWCKjtaIGg+/td7+ay19UJawaeViPwtX65X4+kjoaZcUh8bKw1URRl9LAnMSfzXA1mJ0xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S5gEwsVZ; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S5gEwsVZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YEg8nX4QR7Tnv1Pjl2JIvJuTWffr1MeWTUmFwQGwg3Q=; b=S5gEwsVZR1pLMAenBZ15Zq/7rH
	wxFDRQqwxNXNaQ7AX1yKsc9SBc1k/SG44ZHUwpLoRvEeuPx/OjrX/pEXSCOJ1H5KXLblGcoswVXzu
	OEI7spEqXl2vUF5i7ATHNOmBfaKeiRygC1edO3wGpTEV91rggC/V1/7OQo4iCgvHN10ODQm5JOE/F
	gWQHqvYhrh4UlanIfxG3h8Io9FWh+G4upcuq8CZ/0sRvLUyKxp3pZ2AHd8UBcBHe4HaFlkj5nDY7D
	Sq9AY5JQTM6p1cgbblFFN6lJ9u785f/DNycwQw9uTJtREy3d95eLYx3tG0LQmWI0ef8IiMZn+V7rk
	C5+AfzlA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrK9L-00000004Wkx-1OWC;
	Tue, 04 Aug 2026 18:46:03 +0000
Date: Tue, 4 Aug 2026 19:46:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v14 05/21] fsverity: improve flushing performance of
 fsverity_fill_zerohash
Message-ID: <anIzawflI11C0FT2@casper.infradead.org>
References: <20260803200820.393203-1-aalbersh@kernel.org>
 <20260803200820.393203-6-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803200820.393203-6-aalbersh@kernel.org>

On Mon, Aug 03, 2026 at 10:07:55PM +0200, Andrey Albershteyn wrote:
> The current version calls flush_dcache_folio(), in memcpy_to_folio(), to
> flush whole folio on every digest (which is 128 for 4k) on the HIGHMEM
> systems. Open code folio mapping and flushing to copy all digests at
> once.

Have you looked at the implementations of flush_dcache_folio()?  On
any architecture we actually care about, all it does is set one bit
in folio->flags noting that the folio will need to be flushed if
it's going to be accessed by userspace.

But, um, do we support mapping folios containing fsverity data into
userspace?  Can't we just delete the calls to flush_dcache_folio()?
