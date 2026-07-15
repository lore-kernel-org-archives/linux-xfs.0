Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE1025B0AC;
	Wed, 15 Jul 2026 04:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784090274; cv=none; b=AkX2+mH7MBF62VxHDbGwp0VJNAgwsK19PlSNB46yL4BCa9MTqONdqwM1bVcsIXvR0EIoJ7c3TARVhWC01wQICkwpEKDXV7HmNUU30AbtJdxbXUflegVw8/GkgsRQF82KcN61/fBVnoDdiO4jsRUE6X5KujgkYLa89u9U8eXKhJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784090274; c=relaxed/simple;
	bh=r0SqiVeMhF2SBo6JufpB88bfKeyb6Ma+6a9R9fSnn+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hc7+6GFIzKxyrVhgc6Kx1cskYhYTosCydAve9EWN/adxoJRgn6K4Tvkp99hsY24+2DfytS9upGta57FOcDAdKK1CYP1tkh4/7f75e9ZwNFojIuWJBPDNmyfCjpvMlsZTELNvo/0JnK1ktoPJMKKBa2jUCW8Mbv2kLqQw/Cyh+y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u4q7plxZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u4q7plxZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=u9l8GbK/d939mjwNaaNEQLRSf13jlumm11AfM0M2g/E=; b=u4q7plxZwPseunwhumiGW9Hrt0
	fjsIF0kRFLxuM3vxKj9zGRJ0F9uWcOIIH7dSpCMuxRbpYcb9YMVcNn6znGTML1SNR7IsunPS4e9O/
	qZGv9rj74KEvzk07q0dkHsR4L5LPP/hHubVtiRko5ceSBc5KyuSbwxiU+ou5zWhzn1T8O2n/dyGz5
	alNkVbFQ3lSLmQIp0A0cdzN+WytTwT3LZqzA6zNHRz0B6FcHDNUE59gTXiTupBb/3uvOx15DXqsOW
	IPQmkmhkhj17fRkbI50G76w3UGXJPw5vOvU8s1H9/jNwLLL4CglkEr2ewoL8LlLFq08xEkPGJn8a/
	22ErO57A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjrNS-0000000Dk9k-41S3;
	Wed, 15 Jul 2026 04:37:46 +0000
Date: Tue, 14 Jul 2026 21:37:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	axboe@kernel.dk, jack@suse.cz, brauner@kernel.org, cem@kernel.org,
	jaegeuk@kernel.org, aalbersh@kernel.org, tytso@mit.edu
Subject: Re: [PATCHv2 3/5] xfs: report direct io attributes through
 file_getattr
Message-ID: <alcOmorM0Sa0nHHE@infradead.org>
References: <20260710210646.3576365-1-kbusch@meta.com>
 <20260710210646.3576365-4-kbusch@meta.com>
 <alTTRoOEglwuf4vg@infradead.org>
 <alalpRYxjqtdJhVR@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alalpRYxjqtdJhVR@kbusch-mbp>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jul 14, 2026 at 03:09:57PM -0600, Keith Busch wrote:
> +void bdev_dio_align(struct block_device *bdev, struct fs_dio_align *align)

Nit: I'd usually pass the filled in structure before the source of the
information.

> +	case FS_IOC_GETDIOALIGN: {
> +		struct fs_dio_align align = {};
> +
> +		bdev_dio_align(bdev, &align);
> +		return copy_to_user(argp, &align, sizeof(align)) ? -EFAULT : 0;
> +	}

... and I'd probably split this into a little helper function as the
ioctl handlers sooner or later become a mess otherwise.

> +	case FS_IOC_GETDIOALIGN: {
> +		struct fs_dio_align	align = {};
> +
> +		if (!S_ISREG(inode->i_mode))
> +			return -ENOTTY;
> +		bdev_dio_align(xfs_inode_buftarg(ip)->bt_bdev, &align);
> +		if (xfs_is_cow_inode(ip))
> +			align.dio_offset_align = xfs_inode_alloc_unitsize(ip);
> +		if (copy_to_user(arg, &align, sizeof(align)))
> +			return -EFAULT;

Same here.

Otherwise this looks good to me.
