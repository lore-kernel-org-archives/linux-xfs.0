Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B932439A7E1;
	Wed, 15 Apr 2026 07:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776237649; cv=none; b=HUFL2O87RXXgsK+gX35wteIBidxltygFGCuoqvgLjWAFKP6oyPNkafsPwIqPEe1eYOqHwS6CJvCM1zCh/vf523nDMbq8UA5moDEGuIKvHOPcpARDqeYYHCgCHEXQP2iTRboFATFfreMCZ6++xnO2TilY9nHtIYFf6oF5P4FH8xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776237649; c=relaxed/simple;
	bh=2oBxvqOu9hUXkv1ICikY17ZShCPZ47uQRvJLf/HyTQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NHdHkNkejTHspNHx5P/MG2aCOElYgsui2F/otY2pQGJXl/d8D/DOnsoe325KXJksTtGXHBD/S9fmloLwCOXmr1Wqgb7/V4Cb5PwirLL+evFiJx0zs6TsQI/vDg5gRNQ4hBBdYn8LnxlsIxFPzZdi43BvZAMzBloOiB5/AmbubO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xo3qm61y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xo3qm61y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tIvye/jwvCO5cHGxupFYmXZaSDqpSIqAV8aqMrQ0utQ=; b=xo3qm61y3/ULBy/R9VupSOheAs
	cR5i1qcm71wjUZYPAWztNSPV7HUwYtrwgg1tfmabFhop925nvvjJ9ck4QuniSKkt3Rg8Mw3VHVbJS
	DvpVuGvURt84hTBGQevy2H1huQx/LPu8rr1Og52s4S5OkaGyuSQD9qbKlAVbgaHLs+m2LacWviT1i
	XtfL7D+MSlt9CTuUMXLV5/YCn/fFC6pqfh0ygXBwxx9Ai72IYG1pfw8J7cAaAh0m4m7xk3ZGvxeWW
	iQ3UGSL4ZdHaNMWvHuMbXaRw/6W1IwqrGidpjM1VMhxS5ju4fCe4sKzkjNO5yO0TCwJYbZOlfafHM
	Yc+IcZ9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCuYI-00000000i6d-1NrZ;
	Wed, 15 Apr 2026 07:20:46 +0000
Date: Wed, 15 Apr 2026 00:20:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ravi Singh <ravising@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	djwong@kernel.org, dchinner@redhat.com, esandeen@redhat.com,
	cem@kernel.org
Subject: Re: [PATCH] xfs: flush delalloc blocks on ENOSPC when creating
 symlinks
Message-ID: <ad88TluB4FIP3yJV@infradead.org>
References: <20260415071657.23412-1-ravising@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415071657.23412-1-ravising@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 15, 2026 at 07:16:57AM +0000, Ravi Singh wrote:
> When creating symlinks on a nearly-full XFS filesystem,
> xfs_symlink() fails with ENOSPC even though space could be
> reclaimed from speculative preallocations. xfs_create() already
> handles this by flushing outstanding delalloc blocks via
> xfs_flush_inodes() and retrying the transaction allocation, but
> xfs_symlink() returns the error immediately.
> 
> Add the same ENOSPC flush+retry logic to xfs_symlink() so that
> symlink creation behaves consistently with file creation.

While we're at it - do we also want it for tempfiles and scrub?
i.e., should we move this logic into xfs_trans_alloc_icreate,
similar to the quota logic?

