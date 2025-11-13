Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FBA3009DE
	for <linux-xfs@vger.kernel.org>; Thu, 13 Nov 2025 06:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763017184; cv=none; b=WIidZkwSS4N7tqcgKwVjCquZRZtrYjzujZBIVxW4+gC+KDhN5f2EmL/1k6cgpUnPZ9CaIgH3H7WuAM43Q/w6PO9jCd/41J0IyEMTZ6pmvD3n+ociCLLVCtjaVpvtnLRIiZZo+JvfvPGDC+29nM1hMJfQig2rhvBUwlzsxzyrjbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763017184; c=relaxed/simple;
	bh=3+Edf7Dxuk0T7FUBGOrdVek4COgtYC2/m0UXZvvSvro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o/hI6nmOePLRRhF7gC9Fjz/0i/8sth7x/3ylIyyVC2vLpp5ksPvgg8C95TFQJVLahMafwnloSoF22OgpDn3F+sKSjqgAKQNA1UFhOcJHpNF7EE9xzGyepfDTf/efBlZLZRPk3WiVV499aJmhEWvdgghHbI5J4ffdKab4yYVybIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2MeuzfJV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2MeuzfJV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TSjOZIKyqfDquniF7eTHOojr2krCckH34eTrKfbua/I=; b=2MeuzfJVgu/aYFtbM+Y/Uzdcr0
	ZR1UfoQov4hHsSWC/Fs9GIl0Wbb2yjb3OMvBqH1X+lIGCh3yDksqYGcD0V89wdGsi3y2j8863ZB+z
	TERBqx+IXYNmVmfjLmDnXLGkwQ1vK0BjgV3S9KRmIhVGIeSIx9yNc4oIhMBc1HZZyFh58h52NdOjt
	usdL7QAxFLTezF+rUtuZtaKWU/YhGPXbI6Z/8Rt6OkjRPvDDngN7qQOfZjwtYBH2RgK+SJzVPtyVW
	kv6UH1CRPlIg0r6PLJJW9Brs2bDlMxx340WvMo4Js64jYVKQY07FceOx0+lgYYv3txN7ExAcMZmfK
	HfAHuROw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJRIz-00000009yZf-0F8X;
	Thu, 13 Nov 2025 06:59:41 +0000
Date: Wed, 12 Nov 2025 22:59:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: hch@infradead.org, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <aRWB3ZCiCBQ8TcGR@infradead.org>
References: <aQMTYZTZIA2LF4h0@infradead.org>
 <20251112210244.1377664-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112210244.1377664-2-lukas@herbolt.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +/*
> + * Callers can specify bmapi_flags, if XFS_BMAPI_ZERO is used
> + * there are no further checks whether the hardware supports it
> + * and it can fallback to software zeroing.
> + */

Sorry for nitpicking more, but please try to use up the available 80
characters for block comments.

> +	if (mode & FALLOC_FL_WRITE_ZEROES) {
> +		if (xfs_is_always_cow_inode(ip) ||
> +				!bdev_write_zeroes_unmap_sectors(
> +				xfs_inode_buftarg(ip)->bt_bdev))
> +			return -EOPNOTSUPP;

The indentation is also still a bit odd here, although for this kind
of things there are no hard rules.  But I'd go for

		if (xfs_is_always_cow_inode(ip) ||
		    !bdev_write_zeroes_unmap_sectors(
				xfs_inode_buftarg(ip)->bt_bdev))

Functionally this looks good now:

Reviewed-by: Christoph Hellwig <hch@lst.de>
