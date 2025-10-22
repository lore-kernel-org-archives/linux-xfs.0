Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C4A2D97B5
	for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 05:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761109207; cv=none; b=EkE5wa7yQCixpUu2VMwMUj+ihN5CjMtx7w0RyELcLcM1BY3GAnha8mcqoAAG2dnsTq9uO7PjPndLSIFFdEFE+CeZPOvZkhkVnIkfwY+47jXzfaUalss/USquTdq+DCH0F19iUc8ruhJz24JTn+zqBWN3R1ejpeq4jc1xJ1OPVec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761109207; c=relaxed/simple;
	bh=st4yPeHw1PUPV8tMNXuzuRRgomCItJRqm9w2dyi8LHI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=d6s7hTrl3V47tuZjwtqJ6VcOQOcFI7yqtfU2gWUz6XV4HPPzCwIb7NMchbheUqZ55B09juDnc3Egw9HqdmMsXDhDv4LhbUKPJtG8fmY61f9IfOOOmYtFyADAEwjLtmvNxFJtp/sdFDq2kV/Bv5kWm23nmaaRJlXku8PMJnJWjJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iLj9L9kN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iLj9L9kN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
	:Content-ID:Content-Description:References;
	bh=A5fEZ5d+ews0iqfzUoX8WWQSeRkw7n53JMFf7KRM1l0=; b=iLj9L9kNTC720QUlRmPhqFMaEx
	N2dOOemE7dJbT54QpDAF+4bQtcXD182coBrrzcuu5p+T2PH9V0e/a9hb8KIcSNnP8lodospKStiFt
	EvEte9kipvi0F8Y+ZHLrwg7CFz+AFaWl6eGtmXtVZAPeoOaXb6JBMNcaF5jmocJqHW0Xmd9gbabQa
	ioEfkCY8ALvgIXwTSxpdA/5a3WdkCZCmphZy9l7i7rYoFgfUvNUAUsxeA4g7AgLqp9jDXPYm3wxwF
	+Kf4IWl0ufDYS9mbLbxZsztrZinirUoF6CYvby1yqkEtdMpzfijajm3Dwcf4cptw2iVLkweLd1C2z
	iASxzhyw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBQxA-00000001Udx-1DDc;
	Wed, 22 Oct 2025 05:00:04 +0000
Date: Tue, 21 Oct 2025 22:00:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org,
	Zhang Yi <yi.zhang@huawei.com>
Subject: Re: [PATCH] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <aPhk1O0TBOx_fl30@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021141744.1375627-3-lukas@herbolt.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 21, 2025 at 04:17:44PM +0200, Lukas Herbolt wrote:
> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
> -		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
> -				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
> -				&nimaps);
> +		error = xfs_bmapi_write(tp, ip, startoffset_fsb, allocatesize_fsb,
> +				flags, 0, imapp, &nimaps);

Please drop the reformatting that introduces an overly long line.

> -int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
> -		xfs_off_t len);
> +int	xfs_alloc_file_space(struct xfs_inode *ip, uint32_t flags,
> +		xfs_off_t offset, xfs_off_t len);

Also normal argument order in XFS would keep the flags last, I think
it's best to stick to that.

> -	int			mode,
> +	int				mode,

Spurious whitespace changes here.

>  	len = round_up(offset + len, blksize) - round_down(offset, blksize);
>  	offset = round_down(offset, blksize);
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	if (mode & FALLOC_FL_WRITE_ZEROES) {
> +		if (!bdev_write_zeroes_unmap_sectors(xfs_inode_buftarg(ip)->bt_bdev))
> +			return -EOPNOTSUPP;

Overly long line.

> +		xfs_alloc_file_space(ip, XFS_BMAPI_ZERO, offset, len);

As already mentioned, missing error return.


Also how is the interaction of FALLOC_FL_WRITE_ZEROES and
FALLOC_FL_KEEP_SIZE defined?

