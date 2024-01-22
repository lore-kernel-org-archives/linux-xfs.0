Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3601A6FC6
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 06:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705905556; cv=none; b=KEUr9KEDiGMSf8R7K7bBAvyt1ppyDMFM2hFPeHTY05jnm5EaM8Xdd0rg6uevQfPlzFGed2i8uTA95I5m/njGsbKFtjty3Rd8UwEDDg2I2sdP16gyJwoMceXYvR7RUk3PV2FnWKLMP3alwGMGta1CWLJOKmyk4GF1BoNiP683Veg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705905556; c=relaxed/simple;
	bh=GZ1vyZLBeG6C7yxi4czJ9SBtHxH/dOypH3JAv/OLl50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hLuVrcgCFigEvqHwFTvO/TSROzm+ru7ZT0taJB8UMdUGENbKMQzNIF/xm7gPvS00cwZKuMtjANOKq+obCDqZHqC5kTGOfCB1N45jMY+wQ5Lz1PCeabk5NDXY93+KlwtXyE1bRkzUQgclQZdtLTKz1hEBY1MVdcZlPPUAjjXKtbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eotifFW6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eotifFW6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Al8BzeKCJa/SU229J/wH0y+VrQO/ruk7m6AVYzxSD+Y=; b=eotifFW6SEJQTsqAnrzqc5kACn
	L8GrmggaHMvhHhOlTW/Z1EpymDDkYp40fflc01jzbgpiH4k4DdGfY+8ttMzc+gMHDqNYwvRiBx5a7
	E5wh4SQtTPpe8ruwVuCXMZTxuyRKSK6ujxPOs6LtFjVUojZY9pF0Gh664202Msk9StWAPWAN+0uCi
	2ID1zRwcTBHtoZr18fW94pOKpvBVKplVqkf3CFimEwvl3G9ZVqwmmVUMnVAPT8fETwFKYlJbThUu+
	dIMZoPRmlpo1IK+ooIr7wxStH8+yaK2bL+heU5byB03uXqF+Zz3KBu71FiN99vuehpCdTLR9ID4Rw
	tFlI977Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rRnxg-00AlG0-2Y;
	Mon, 22 Jan 2024 06:39:12 +0000
Date: Sun, 21 Jan 2024 22:39:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] xfs: use folios in the buffer cache
Message-ID: <Za4NkMYRhYrVnb1l@infradead.org>
References: <20240118222216.4131379-1-david@fromorbit.com>
 <20240118222216.4131379-3-david@fromorbit.com>
 <20240119012624.GQ674499@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240119012624.GQ674499@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jan 18, 2024 at 05:26:24PM -0800, Darrick J. Wong wrote:
> Ugh, pointer casting.  I suppose here is where we might want an
> alloc_folio_bulk_array that might give us successively smaller
> large-folios until b_page_count is satisfied?  (Maybe that's in the next
> patch?)
> 
> I guess you'd also need a large-folio capable vm_map_ram. 

We need to just stop using vm_map_ram, there is no reason to do that
even right now.  It was needed when we used the page cache to back
pagebuf, but these days just sing vmalloc is the right thing for
!unmapped buffers that can't use large folios.  And I'm seriously
wondering if we should bother with unmapped buffers in the long run
if we end up normally using larger folios or just consolidate down to:

 - kmalloc for buffers < PAGE_SIZE
 - folio for buffers >= PAGE_SIZE
 - vmalloc if allocation a larger folios is not possible

