Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E067C2459F7
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 06:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764742877; cv=none; b=ENqAqhR8L6e/a2Vl3DX0kUKQcmlxKXoOKifI18sGnT4cCMKKI7mJpfdrL69xGGNh5Pqjb3GGSlJiPir0tlPoNpORtxwmVdfoswYR654KK4nNIBQ4oEA8JenUp0vwGS+Tm7VjEsPgFM7dGfHR3UwFfB3xd4CPQZJtYp7rYnZC/4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764742877; c=relaxed/simple;
	bh=ckNf+Vr1+rtkqCxAHTVp/q0Do84tomsadZyihsoEqmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SgTGLaAnEE/G3rfUBATM4T8oIieURgHnL0f+XV1Jek0GBwdjYnWo+3wekHc/1tqu/TWbPSEuYjGYUQzuAg/+PSZQHcofTq/2FFBBWGTDTxoUy1pdZQ4ONmMGcKXIMhCHO8vFtFDUf55c0PAIz8u1y0C7AgcDDIHdv1ie2ghndu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OXx1EZtu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OXx1EZtu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=X2BfIjFYDbzRxh35qGvz1Zg99WKllfNT/dS2zwLUY3I=; b=OXx1EZtuSM3xjIcqQDGTmMA9Kc
	ONnvFEqaPdNxUMLUKlXEV+0JcRxs7ca2zv/OHIYKnCNCs96oED2hc3CR+x9IpQyp7AhODLRcM2szB
	JFeWw4Sn6QfXui7Daf25Gx7QpLO7RlbJ8hpqrvF+PSjE7caXe02ZRDLlUawoHYEMPs7OAGrUZTlmW
	tuhOHK875KLt6DJiPHMr56wKJjhwdsao+C73pzbVGx1A0t5W/AQHrZWkffJHvK+/5910pWsll4Oz0
	kskmIYH4/GHwU0NxR+CS3oN6SSVmPvjx4gLyclQvQlxkO6qWFYwwYfZeE48WDeTUx1TDnDWXdJBjJ
	cJiPkDjg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQgEe-00000006BDT-3MVq;
	Wed, 03 Dec 2025 06:21:08 +0000
Date: Tue, 2 Dec 2025 22:21:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Cc: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs : Fix potential null pointer dereference in
 xfs_exchmaps_dir_to_sf()
Message-ID: <aS_W1IHbi3-vlLOm@infradead.org>
References: <20251125142205.432890-1-chelsyratnawat2001@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125142205.432890-1-chelsyratnawat2001@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 25, 2025 at 06:22:05AM -0800, Chelsy Ratnawat wrote:
> xfs_dir3_block_read() can return a NULL buffer with no error, but
> xfs_exchmaps_dir_to_sf() dereferences bp without checking it.
> Fix this by adding a check for NULL and returning -EFSCORRUPTED if bp is
> missing, since block-format directories must have a valid data block.

xfs_dir3_block_read is a thin wrapper around xfs_da_read_buf, which
like all the buffer functions should not return a NULL buffer unless
either an error occured, or the caller asked for read-ahead semantics,
which xfs_dir3_block_read never does.  It seems like it currently
could when an invalid mapping is passed in (see the invalid_mapping
case in xfs_dabuf_map).  I think we'd be much better off trying to
fix these inconsistencies than doctoring around them in the callers.

