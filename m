Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345F93E5ED7;
	Mon, 13 Jul 2026 10:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783937701; cv=none; b=iI4JQTqwJSvQtzU4RojMpv4vUgIcgGE2dX1rKgehNbGtbPdjG68G6mbeLKxauBNOiC/1EyJLCu2KuyJdnwuMgeWjBUzqs9YHIbyoRcKtRg4ZJAVAha6LCMlW7Lv4l/SgBQXRwPL5SrPQ97phFR42SM1UmD9M0JL0eMDKo0qjRAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783937701; c=relaxed/simple;
	bh=7VwCKc+6gngubshOb69xsa2+5g5oiIokycnL8OO584c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p8xdXoArDYvEaNgDRc6of4dxbcPlmNoiGulMrNgUgNZEXtLCzHEY7ARHrzV14naDNs8LEQ5qh5mf27RN8F7TXgH3bfXpU5G5Ra3iONuzAzueCv/HFS2jXVOgOeWaB78DWgeJVZJcJ53t68Uod61Y7W6A7YW/zr66rEBw1FxDzqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RTcCxrP5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RTcCxrP5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Wd5EK7fPsbF7saDZnaT6E+GdQJ31yQMyVH33vqfFEE0=; b=RTcCxrP5jqIPlAGrqZzkl/m4f0
	1wHzKniwlyX1iyIjAXbeRP9tWGjek9AIG3mHwI3AZ70C8QYsVzGDLpqiKG+HninpPngZnDolKsQPZ
	p5w6xJdPUkhzJHNb2tWmaOC8yZ7G48qqKrzekbvFmGeMvvj5SgkGUbH210vW20BLWbT8q2ZpnW4dW
	/7zjeCYb1vM0m6zVPW9IQMZscAZAz/XmgD+0wVL4ij0HMDKO0XLDZcD9jCGpGNRYxzyz3heGoL5LT
	p8AOqZcyyds1fCy9614PTG4SyLzI3QNxroQX8j98Z9M8ANmKT/DR+3plgB77riqSHcLO3pDGa6Yyy
	/qD0nbHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjDgg-00000008r8e-1gc4;
	Mon, 13 Jul 2026 10:14:58 +0000
Date: Mon, 13 Jul 2026 03:14:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	axboe@kernel.dk, jack@suse.cz, brauner@kernel.org, cem@kernel.org,
	jaegeuk@kernel.org, aalbersh@kernel.org, tytso@mit.edu,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 1/5] fs: add direct io attributes to file_getattr
Message-ID: <alS6oonYUoawuxBy@infradead.org>
References: <20260710210646.3576365-1-kbusch@meta.com>
 <20260710210646.3576365-2-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710210646.3576365-2-kbusch@meta.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jul 10, 2026 at 02:06:42PM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Direct I/O imposes alignment and layout constraints that come from both
> the filesystem and its backing storage. statx() reports some of these,
> but not all, and it can no longer be extended.

Well, it could be extended.  Although it would require a new flag,
and there's been a lot of pushback to adding non-fastpath attributes
to it.   So maybe update this blurb ad bit and also mention which
attributes are duplicated?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
