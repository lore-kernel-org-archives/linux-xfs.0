Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6R6oMKY170799 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 01:50:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5BC2474C84
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 23:53:27 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id z8Ftpwp7At7nDTZM for
	<xfs@oss.sgi.com>; Mon, 26 Jul 2010 23:53:27 -0700 (PDT)
Date: Tue, 27 Jul 2010 02:53:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: use range primitives for xfs page cache
	operations
Message-ID: <20100727065326.GA32510@infradead.org>
References: <1280210129-10925-1-git-send-email-david@fromorbit.com>
	<1280210129-10925-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1280210129-10925-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 27, 2010 at 03:55:28PM +1000, Dave Chinner wrote:
> While XFS passes ranges to operate on from the core code, the
> functions being called ignore the either the entire range or the end
> of the range. This is historical because when the function were
> written linux didn't have the necessary range operations. Update the
> functions to use the correct operations.

Assuming you have actually tested this - given that we've ignore
these parameters so long that I'm really fearing some callers have
started to rely on that behaviour.

>  	if (mapping->nrpages) {

I'd drop this check ere as well - no other caller does it.

>  		xfs_iflags_clear(ip, XFS_ITRUNCATED);
> -		ret = filemap_write_and_wait(mapping);
> +		ret = filemap_write_and_wait_range(mapping, first,
> +					last == -1 ? LLONG_MAX : last);
>  		if (!ret)
> -			truncate_inode_pages(mapping, first);
> +			truncate_inode_pages_range(mapping, first, last);
>  	}
>  	return -ret;
>  }
> @@ -73,7 +71,8 @@ xfs_flush_pages(
>  
>  	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {

Same for this check.

>  		xfs_iflags_clear(ip, XFS_ITRUNCATED);
> -		ret = -filemap_fdatawrite(mapping);
> +		ret = -filemap_fdatawrite_range(mapping, first,
> +					last == -1 ? LLONG_MAX : last);

Also for the non-async case we should just use
filemap_write_and_wait_range, and kill off xfs_wait_on_pages.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
