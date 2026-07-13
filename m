Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE523EFFB9;
	Mon, 13 Jul 2026 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783944009; cv=none; b=UhdstMa8p9e3sN4j6PrtFo+f0HSVLfH/ANRrJ88ZYLki3BX2F7UFGchhAzTl4xOzmQM+0a5Hsp0ICIVhpaci49ASyaf5aKM1mvpakGZVIZQ2gY5bovhMgmXWthnlCII3DTTwSmf5zGT287+NHqUJrCfxTUntZWy0ElrqGaRMUrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783944009; c=relaxed/simple;
	bh=xrh7lf/j+INDpBIQuxKKEaAe66A3IiJwW82dONtLcSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hNOUAqn9o395UOkGlDuRT8raHG7TWafMSW8QhlxomJ3u9TGRfc9j7l9Vc/6slD6qSeIegibEhshiDA2xsu/+0Gn1I66JC3njzJt4KZhcW6vv4MeIvhK/B8KXgAEBIn5LL+6RkA6+C1wM9NJef5fYg7OglkZJhJgRyAi+THEZ2os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dCaEjrZ6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dCaEjrZ6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tQYMjoiTYjYW1olQ44tmxQBfF3EMsN52ax3nXVxNLJk=; b=dCaEjrZ6fLHwI0XLAxmjHgIYZa
	1IBSKVZzD0flrK2WUENb+JAbS3Rf02/YVO+5rgeQPlYKpYOvM9aK7/3JyShsIq2HX4RfbczOToBAM
	lRdB60hf8h2XcdDZehKZqEBoiFuKqe2Ew0jscy71bjR4ya1leGMkKBpbMU7YNLHFl3rEvU3uRdq6R
	eKTAfppC2AtOLbEy0ijYImRsh8dcqH0bojGZqwbdn5oXNLUtW8P59VEt4yRBq9KsLlvG+qY27oBh6
	5lRKqIx1aVStoEZXh182roeTFj3Bm4Ec+TMUIT8eQvcIkTjKgfeNpinZ6Jd9HVYNL690yV30dTqLD
	tLExMRHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjFKQ-000000096Qi-0M9M;
	Mon, 13 Jul 2026 12:00:06 +0000
Date: Mon, 13 Jul 2026 05:00:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	axboe@kernel.dk, jack@suse.cz, brauner@kernel.org, cem@kernel.org,
	jaegeuk@kernel.org, aalbersh@kernel.org, tytso@mit.edu,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 3/5] xfs: report direct io attributes through
 file_getattr
Message-ID: <alTTRoOEglwuf4vg@infradead.org>
References: <20260710210646.3576365-1-kbusch@meta.com>
 <20260710210646.3576365-4-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710210646.3576365-4-kbusch@meta.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jul 10, 2026 at 02:06:44PM -0700, Keith Busch wrote:
> +static void
> +xfs_fill_fsxattr_dio(
> +	struct xfs_inode	*ip,
> +	int			whichfork,
> +	struct file_kattr	*fa)
> +{
> +	struct xfs_buftarg *target;

Same alignment for the variables as for the arguments.

> +
> +	if (whichfork != XFS_DATA_FORK || !S_ISREG(VFS_I(ip)->i_mode))
> +		return;

Move this check to th caller?  Although this and similar check in
the other file system patches miss block device nodes, for which we'd
need a special case, or one in the caller to override the attrs.

Or maybe using the file attr for this isn't actually a good idea,
and we should do an ioctl instead which automatically gets routed to
the block device fops?

> +	target = xfs_inode_buftarg(ip);

.. and initialize the variable at declaration time?

