Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4096CEA4
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945470; cv=none; b=SjvVKN4MhPctnLF7V0ckV2KYUzokinuDyM4QR59upkqv8NJOjsP5e6jxgXb3vdaUxM5U5PzLjfxv2lcZZwXCLfCFxYL811xxxVyL13yCEz0DA2FGThjOaIYjRNqqf2hus/NwYhefu7AvSjw92JLeOp1hF2XCdv97N8kI2n1fP/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945470; c=relaxed/simple;
	bh=DhWih3nwYhbHUpJxmQ82s/vZo7123r2jjc5L9gnIPpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YkrYjyO0tLSbflS72TbvEDSSU4kZtv1Jenvy6siKeUSsQkiACe11CY7YBWd+K59ZYCBxPf9cNhE6Uup0g/MH2Ahe/FuBxLI0lG9aMtBLd5Jhn7U0ZBbHDSe+F/yCuMRZU3ahAgfakfZIWBX3Vd0G1lOSfKohGkmlPH3PAbgBrO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W+7q4nhg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W+7q4nhg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=raf5whsvrOerUeTynXazzABcbduGdrBpXzhDQyy2KX0=; b=W+7q4nhg9an9J6hMaxYfbdTbpu
	byRzXgQuletIzPAUc9wRAHvSm7+PvhiosdfBrVfcMVanSDon3zl+hrY1zHZbqNKk5pcYBElb+h+t6
	bEjhoYBWflECcMIPBCYy1ztuSBcdYocpHDgQkArCHdTTPEsLjR7iWtVCLKYQuy/u7M5BnsgDE2NtK
	57HfzFDhWjGYdKvkFNFZz5zdn1NgXBYpls2xFg8GgL0lLPGE9k2+PmchN7f0x0pouAMhfkbF0VGIg
	YsPP28UIgGBUjNnxLg5oDp2u1yUuzKaYs3BaWr1zCJHNSXrn+TQjO8FAz+OkMhTr6a2GOL1l2a9pF
	Dl/mTFXw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKWEs-00000007gkY-457c;
	Fri, 21 Jun 2024 04:51:06 +0000
Date: Thu, 20 Jun 2024 21:51:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: move xfs_rmap_update_defer_add to
 xfs_rmap_item.c
Message-ID: <ZnUGuj09tGR4KllC@infradead.org>
References: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
 <171892419387.3184396.13324698821553289330.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892419387.3184396.13324698821553289330.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 20, 2024 at 04:09:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move the code that adds the incore xfs_rmap_update_item deferred work
> data to a transaction live with the RUI log item code.  This means that

s/live/to live/?

Otherwise:

Reviewed-by: Christoph Hellwig <hch@lst.de>
