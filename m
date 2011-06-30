Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U20Jjr164889 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 21:00:19 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A74854C25CF
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 19:00:17 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	cUyqOikSE5xpjGEz for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 19:00:17 -0700 (PDT)
Date: Thu, 30 Jun 2011 12:00:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/27] xfs: use write_cache_pages for writeback clustering
Message-ID: <20110630020013.GX561@dastard>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140336.950805096@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110629140336.950805096@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Jun 29, 2011 at 10:01:12AM -0400, Christoph Hellwig wrote:
> Instead of implementing our own writeback clustering use write_cache_pages
> to do it for us.  This means the guts of the current writepage implementation
> become a new helper used both for implementing ->writepage and as a callback
> to write_cache_pages for ->writepages.  A new struct xfs_writeback_ctx
> is used to track block mapping state and the ioend chain over multiple
> invocation of it.
> 
> The advantage over the old code is that we avoid a double pagevec lookup,
> and a more efficient handling of extent boundaries inside a page for
> small blocksize filesystems, as well as having less XFS specific code.

Yes, it should be, but I can't actually measure any noticable CPU
usage difference @800MB/s writeback. The profiles change shape
around the changed code, but overall cpu usage does not change. I
think this is because the second pagevec lookup is pretty much free
because the radix tree is already hot in cache when we do the second
lookup...

> The downside is that we don't do writeback clustering when called from
> kswapd anyore, but that is a case that should be avoided anyway.  Note
> that we still convert the whole delalloc range from ->writepage, so
> the on-disk allocation pattern is not affected.

All the more reason to ensure the mm subsystem doesn't do this....

.....
>  error:
> -	if (iohead)
> -		xfs_cancel_ioend(iohead);
> -
> -	if (err == -EAGAIN)
> -		goto redirty;
> -

Should this EAGAIN handling be dealt with in the removing-the-non-
blocking-mode patch?

> +STATIC int
>  xfs_vm_writepages(
>  	struct address_space	*mapping,
>  	struct writeback_control *wbc)
>  {
> +	struct xfs_writeback_ctx ctx = { };
> +	int ret;
> +
>  	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
> -	return generic_writepages(mapping, wbc);
> +
> +	ret = write_cache_pages(mapping, wbc, __xfs_vm_writepage, &ctx);
> +
> +	if (ctx.iohead) {
> +		if (ret)
> +			xfs_cancel_ioend(ctx.iohead);
> +		else
> +			xfs_submit_ioend(wbc, ctx.iohead);
> +	}

I think this error handling does not work. If we have put pages into
the ioend (i.e. successful ->writepage calls) and then have a
->writepage call fail, we'll get all the pages under writeback (i.e.
those on the ioend) remain in that state, and not ever get written
back (so move into the clean state) or redirtied (so written again
later)

xfs_cancel_ioend() was only ever called for the first page sent down
to ->writepage, and on error that page was redirtied separately.
Hence it doesn't handle this case at all as it never occurs in the
existing code.

I'd suggest that regardless of whether an error is returned here,
the existence of ctx.iohead indicates a valid ioend that needs to be
submitted....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
