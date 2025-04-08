Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD19315A8
	for <linux-xfs@vger.kernel.org>; Tue,  8 Apr 2025 05:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744089070; cv=none; b=A+og56bDzKKkrMNIHWEXg7yg03fsGCLyxnp25I8gQDjrCZC/esuWlDvpKASk1ROrhD/4ipURkZKWKreMcXRX/dzm+JC1PEkfoKeBZVpw1vPPhfvJSszBMBZtnwwr1ESGsG/2v8vrCOTBHaK6ACIaflPKMSBPNyCWm1Dgk3idmL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744089070; c=relaxed/simple;
	bh=jrUlHZKBC9ezloRU6SL8uSAByhZwy3fklh+clndIlGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=utsMbxOax4Alnma669E6sHcUXTYCPCL8Kmbflf5F5ri6+nFti5O3OWcfhpEb0+x9Y7qr3WVv8YRgpDBHOVfKelZhmSgxmq4ZlNUQly39ScOTiUG5GF6QkDHHK1w3wVfKtKX7YpeBoVY4ZzcQwDqbe6vyf5NC3gE1poL9IeUgld0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xbdI2BXd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xbdI2BXd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=b98gHK/AscIDUcBznXZPjMmf0aM0aZDXw/MBZZ/ehBA=; b=xbdI2BXdszNZSLQBEJd8Wrjnq4
	zvmhlnVloCfSkwdHpFINSmEo8CQ834oWxMQWHRpU9wcLu9sxepFz8G356pjs1BX8K/jOxR3qRc3eW
	wqtERydyIuqieSra/+iqswoaWfa8LX2zJzhQuG4n+ecAO6z2bAnEKS/XziptLVqR+UQiMiruk5Ljt
	XiDY/fbQfMSj/tPHSKsDJc8Y4j5TjwvqxT5ddvCyIHCD2g45Axb5CLLQn4ScZ0unMLbYXs/w9Zegi
	Qj4GwOz+gvc/yhXsIDqrs9w+GBVcT2HJ/DioVOSjbHrmuUMCh0Q+YEkbf8dCHrkdPmWgDJNLpuc3F
	6GIWpQXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u21Eq-00000002kzi-16ah;
	Tue, 08 Apr 2025 05:11:08 +0000
Date: Mon, 7 Apr 2025 22:11:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH] xfs: compute buffer address correctly in
 xmbuf_map_backing_mem
Message-ID: <Z_Sv7MWFnIXtq--H@infradead.org>
References: <20250408003030.GD6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408003030.GD6283@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 07, 2025 at 05:30:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Prior to commit e614a00117bc2d, xmbuf_map_backing_mem relied on
> folio_file_page to return the base page for the xmbuf's loff_t in the
> xfile, and set b_addr to the page_address of that base page.
> 
> Now that folio_file_page has been removed from xmbuf_map_backing_mem, we
> always set b_addr to the folio_address of the folio.  This is correct
> for the situation where the folio size matches the buffer size, but it's
> totally wrong if tmpfs uses large folios.  We need to use
> offset_in_folio here.
> 
> Found via xfs/801, which demonstrated evidence of corruption of an
> in-memory rmap btree block right after initializing an adjacent block.

Hmm, I thought we'd never get large folios for our non-standard tmpfs
use.  I guess I was wrong on that..

The fix looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But a little note below:

> +	bp->b_addr = folio_address(folio) + offset_in_folio(folio, pos);

Given that this is or at least will become a common pattern, do we
want a mm layer helper for it?

