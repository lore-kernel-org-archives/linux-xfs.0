Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19981E520A;
	Fri, 12 Jun 2026 05:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781243414; cv=none; b=uZ0xfMXV3OXWxTBmdiBn/yMKXaAwmhNQmd60D5EBlMTvOf93Sox49Or43l2uAXBDv77iSvNkAS5f7yf2bfHzlYze6UhI6ZYwEcJXuVKjzb0537QeKP1Ue2Y2yNMGmok4vJnXeras1XOSw9kOiTODxJiHSQav/Ya2d8RR8i1dNuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781243414; c=relaxed/simple;
	bh=sJcorI8kXv6sNEbzVgYiohAUjmnd6tAfIRdIHeRvJh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iLcAzaHfpf7OIEa+GBfwbX/mkiuvVBsZhfwkIgpq8sfoxc8lBUvgo/4XgXNI1PFPFuZLkhWHzPDA4JPZv9UXX+HXpt/mvW7gG0a7wHmLa2nvZTgAV0KVeqg4RbiXHlA9YFVN6UiiarhBEfCNXcQZ6Wn8lw/YwOKMt+IDTD0slR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KIPaCG3U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KIPaCG3U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=57ZXJIZh/265KZo0ha93shExeVaE559PIx2KES8RnMs=; b=KIPaCG3Upy10C811Gpz/DQH5Pq
	yvx/SYvEi9qtuYMq1hmKbA22jlLh0ej+EUYlHky88AiPJwp2DzAhLjq/dx4HcTozauNw7IK5bxXk9
	3wj8MFzAeaq+gHwtz6d/kmb6OB2eOLFJGNBO38N2GVAl/xCkkJCU6tZaDx0RlXcnFtQEN0A38L4UR
	ITJKXj7xPqL63PU/usp61bRsYOAj5WFxbAWTqaldYG+NVicQQdMdmL7iXP3mzkHV3gBFy7ZGaTFLW
	zqlxiD7VbUyOWYXpoQt+CaxPzPvATnk0Royba9BlV7PJ5RpCa0smOPxmNyZYBGF2uFNibr69pm3FW
	IV0l/ASw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXumS-0000000AO9U-12zW;
	Fri, 12 Jun 2026 05:50:12 +0000
Date: Thu, 11 Jun 2026 22:50:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Aditya Srivastava <aditya.ansh182@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: prevent close() from hanging on frozen
 filesystems
Message-ID: <aiueFE1yWmLJGIFA@infradead.org>
References: <ailmd8JNOT62E6vD@infradead.org>
 <20260611180532.1725-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260611180532.1725-1-aditya.ansh182@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Aditya,

this looks mosltly good.  A few procedural comments first, I'll then
move on to the code nitpicks.

 - please don't respond to the previous patch, always post standalone.
   git₋send-email gets this right.
 - a lot of the history in this commit log belongs into a cover letter,
   not the commit log itself.  Same for the reproducer.
 - please split this up into multiple patches dong one thing a a time,
   e.g.

xfs: add a XFS_TRANS_TRYLOCK flag
xfs: prevent close() from hanging on frozen filesystems

> A simple GPLv2-licensed C reproducer demonstrating the hang (compile
> with -pthread):

Can you also wire this up to xfstests?

> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 0ab00615f1ad..56c7919bf1e5 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -574,7 +574,8 @@ xfs_can_free_eofblocks(
>   */
>  int
>  xfs_free_eofblocks(
> -	struct xfs_inode	*ip)
> +	struct xfs_inode	*ip,
> +	uint			flags)

Maybe name this trans_flags so that the usage sticks out?

> @@ -1807,8 +1807,17 @@ xfs_file_release(
>  	if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
>  	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
>  		if (xfs_can_free_eofblocks(ip) &&
> -		    !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
> -			xfs_free_eofblocks(ip);
> +		    !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED)) {
> +			int error = xfs_free_eofblocks(ip, XFS_TRANS_TRYLOCK);
> +
> +			/*
> +			 * If transaction allocation fails due to a frozen/freezing
> +			 * filesystem, clear the released flag so that subsequent
> +			 * releases or background blockgc can retry post-thaw.
> +			 */
> +			if (error == -EAGAIN)
> +				xfs_iflags_clear(ip, XFS_EOFBLOCKS_RELEASED);

The comment has two overly long lines.

Also the resetting the flag on error is a bit odd.  As far as I can tell
there is no need to clear it before the action, so I think we can just
move to clearing it only on successful return, e.g.:

	if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
                if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
		    xfs_can_free_eofblocks(ip) &&
		    !xfs_free_eofblocks(ip, XFS_TRANS_TRYLOCK))
			xfs_iflags_set(ip, XFS_EOFBLOCKS_RELEASED);


> +	if (!(flags & XFS_TRANS_NO_WRITECOUNT)) {
> +		/*
> +		 * If TRYLOCK is specified, attempt a non-blocking lock to
> +		 * avoid blocking indefinitely on frozen/freezing filesystems.
> +		 */

This would be a bit cleaner as:

	if (flags & XFS_TRANS_TRYLOCK) {
		if (!sb_start_intwrite_trylock(mp->m_super)) {
			kmem_cache_free(xfs_trans_cache, tp);
			return ERR_PTR(-EAGAIN);
		}
	} else if (!(flags & XFS_TRANS_NO_WRITECOUNT)) {
		sb_start_intwrite(mp->m_super);
	}

And maybe the flag name would better match XFS_TRANS_NO_WRITECOUNT
a bit, e.g. XFS_TRANS_WRITECOUNT_TRYLOCK?

Maybe also add an assert that XFS_TRANS_NO_WRITECOUNT and
XFS_TRANS_NO_WRITECOUNT are not specified at the same time.

