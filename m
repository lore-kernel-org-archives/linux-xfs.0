Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF6626AD3
	for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2024 15:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724081023; cv=none; b=pa/Km/G+mzvznkk0IWK8g1mHhBKRrwqJqRDNfQJSSTyJlW+LkSrTrB4hH1dDrerjasMZxGztv8pQfNfzOPaHZ4l+oDg9jEPA1V/heJtU6yZils69+4UKVjvZ5gJhAoQPuYR8WGwmFw9kCi8xVAQ0vWbV2Qkttg2GO5QyqvG5fyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724081023; c=relaxed/simple;
	bh=icmtcVhzjOU4fJWrfxBcH4jZuAkdzAE+66RDH0CF8rs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AxGECd+fc/2EQ3ZaIt/4ZEW0XznrMm0mUhtrsg5P6YS9SOuTNeVzUEDp32O64K+Z8etbnvHczcD7018SLV87b+u5/MLBripwvHZPXKp5Jpd7yGuPxE+++Uga0jb4fHcvusROoUPNuDMNcLrC46OBA6oip/uB/OSgWz4gAo4c1Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=M/9ldPpm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M/9ldPpm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tUMZgluiZC9pAzDOJehfNz5ZWocRukIu0YfsNpIkWEQ=; b=M/9ldPpmDBAz/QZTsNyntA7FvT
	chSE0AZs4SANJNlKZ8pjcexn0OsP22eWx5acgAycXcIfYvxgoxuvrh0vtk5zYijE6rt8kjf6TBCD9
	h9ESaVxIsz+CztzneCHYQgqd3L7lJp/itlmqiizJuKau8ycCwfrQbjCmdpJ5SUHlLMrvGlXfiq5Yy
	8xWcHBz44Pjux0FkjqLFGQEgYp1JeGr5v7dV6w6DZcX8NLTjGjRMngaSpC5TdHqBRhdn1ZR8zd8lD
	bbxknrxNbein/tdr1SEoWnfBaYGJ809MIa153rM2tfKtXVP4Is/O9hwLRKA3CJCY/IO3QAYVM3lA1
	SKQHGhng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sg4EP-00000001vcl-1Ap6;
	Mon, 19 Aug 2024 15:23:41 +0000
Date: Mon, 19 Aug 2024 08:23:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libfrog: Unconditionally build fsprops.c
Message-ID: <ZsNjfXWaLc8w1r1S@infradead.org>
References: <20240819132222.219434-1-cem@kernel.org>
 <ZsNSHLekoGCThzaj@infradead.org>
 <20240819151216.GP865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819151216.GP865349@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 19, 2024 at 08:12:16AM -0700, Darrick J. Wong wrote:
> 
> How about we just opencode ATTR_ENTRY in libfrog and then we can get rid
> of the libattr dependency for it and xfs_scrub?  IIRC that's the only
> piece of libattr that those pieces actually need.

We'd also have to switch from attrlist_ent to xfs_attrlist_ent
and maybe a few similar substitutions, but otherwise it should work.

While we're at it, it might be worth to do the same for scrub and
get rid of the libattr dependency entirely.

