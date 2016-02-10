Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 98A0D7CA2
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 05:36:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7567B304062
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 03:36:12 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id iycftzDZjf3ECCuv (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2016 03:36:10 -0800 (PST)
Date: Wed, 10 Feb 2016 03:36:09 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] xfs: don't chain ioends during writepage submission
Message-ID: <20160210113609.GC15221@infradead.org>
References: <1455094043-9694-1-git-send-email-david@fromorbit.com>
	<1455094043-9694-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455094043-9694-7-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> -STATIC void
> +STATIC int
>  xfs_submit_ioend(
>  	struct writeback_control *wbc,
>  	xfs_ioend_t		*ioend,
>  	int			fail)

No that almost all of the function is rewritten can you rename
fail to error or status?  fail always suggests a boolean to me and
is rather confusing.

> + * Return the ioend we finished off so that the caller can submit it
> + * once it has finished processing the dirty page.
>   */
> -STATIC void
> +STATIC struct xfs_ioend *
>  xfs_add_to_ioend(
>  	struct inode		*inode,
>  	struct buffer_head	*bh,
>  	xfs_off_t		offset,
>  	struct xfs_writepage_ctx *wpc)
>  {
> +	struct xfs_ioend	*prev = NULL;
> +
>  	if (!wpc->ioend || wpc->io_type != wpc->ioend->io_type ||
>  	    bh->b_blocknr != wpc->last_block + 1) {
>  		struct xfs_ioend	*new;
>  
> +		prev = wpc->ioend;

Looking at the new list_head based code it might be either to just
pass in a pointer to the submit_list and just add the previous ioend
here directly.

> +	LIST_HEAD(submit_list);
> +	struct xfs_ioend	*ioend, *next;
>  	struct buffer_head	*bh, *head;
>  	ssize_t			len = 1 << inode->i_blkbits;
>  	int			error = 0;
>  	int			uptodate = 1;
>  	int			count = 0;

The count variable is pointless now - we only check for it being
non-zero, and we can do the same with a list_emptry on submit_list.

>  
> +
>  	bh = head = page_buffers(page);
>  	offset = page_offset(page);

nit: pointless second empty line added above

>  	ret = xfs_do_writepage(page, wbc, &wpc);
> -	return xfs_writepage_submit(&wpc, wbc, ret);
> +	if (wpc.ioend)
> +		xfs_submit_ioend(wbc, wpc.ioend, ret);
> +	return ret;
>  }
>  
>  STATIC int
> @@ -1019,7 +1022,9 @@ xfs_vm_writepages(
>  
>  	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
>  	ret = write_cache_pages(mapping, wbc, xfs_do_writepage, &wpc);
> -	return xfs_writepage_submit(&wpc, wbc, ret);
> +	if (wpc.ioend)
> +		xfs_submit_ioend(wbc, wpc.ioend, ret);
> +	return ret;

And this is where ignoreing the xfs_setfilesize_trans_alloc errors
reappears after a previous patch mostly fixed it up.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
