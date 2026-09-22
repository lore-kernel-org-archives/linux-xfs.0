Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E612251A134;
	Tue, 22 Sep 2026 07:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790061774; cv=none; b=nLw8/whGwhai2mOHzhs/FgFwt+eLoENBTtrZu7EPOkr7ZczcBtCmFVuWFCXEKnilJQjFHm6rdoNEolF0VHQTBFvmwPi98R9kgNlC5tqTNURoNP6IDs3cAB86+9oyhGeT8L+LzpBAQPMmotbXWn1A+2tMZhsAt7fuWN8IN/5MVx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790061774; c=relaxed/simple;
	bh=lNWsaHtoGlaRXpK2wg5WmocwLbXIopRGnV4hAuR8tuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tzzQglyd7HRcgqfq7lVbA25YxTmS4JCeQn9TSapfzvOFOcF4RAsMHxGCnwr70zIz8WK8Moh2d29CZSCwlypEH59EiydFBnY5512inwBcEYJP0FUyH7lMv0C3/fWJpUDhGq/oshGFUPNVUjA5IsLWCBs7BCNGA9XaKfk7rfn6s4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HFw1PEao; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HFw1PEao"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3qq0Y7EkYZQB8hy7/hh9R5IKZgsY5zc1hNog+FB/7qA=; b=HFw1PEaoKGRVVOHOulcFABvcvD
	qvfOH1H7/NrXCx1ZznRfNai3F1oyiRHGoIfcNQ04KDOfWBgugZIEryXn9ShwYQig1A4ivC4VL/9wl
	IqmFkQzyO4ddOgSJzTpDRVzIauMyZmxEwvOcJ7M4c1UJGKjZINI+ENGwbXlfIoVMxuxsXeZhqDmpj
	VpSU6tXGdTXjQohEss4haQPdrOBtjJqZ8BYvxar14WNAI5o5BTGgw5yPgFJjUGPgG+V5UjD/Oa0s/
	sAgxNvqQTkQgG+n3cAqojrWU9F2FQLnKwtPn/9OrYr3euBvpvXwPaptMfFuIbX/qrZLJhiJmEnRyK
	qshyy8+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8uq4-00000004Upg-1yFV;
	Tue, 22 Sep 2026 07:22:52 +0000
Date: Tue, 22 Sep 2026 00:22:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: djwong@kernel.org, ebiggers@kernel.org, hch@lst.de,
	Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
	david@fromorbit.com
Subject: Re: [PATCH v16 15/21] xfs: add fs-verity support
Message-ID: <arIszDCcy0VbRVFp@infradead.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-16-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918111539.1003439-16-aalbersh@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Sep 18, 2026 at 01:15:27PM +0200, Andrey Albershteyn wrote:
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
> +
> +	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));

We can't call truncate_inode_pages with the ilock held.

I also don't see what this is trying to protect to start with.
