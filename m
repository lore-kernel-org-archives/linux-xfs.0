Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o69GAggC122132 for <xfs@oss.sgi.com>; Fri, 9 Jul 2010 11:10:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73E08BA1B64
	for <xfs@oss.sgi.com>; Fri,  9 Jul 2010 09:19:19 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id B2HmeBszTLmVJeAn for
	<xfs@oss.sgi.com>; Fri, 09 Jul 2010 09:19:19 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OXGCl-00077u-9T
	for xfs@oss.sgi.com; Fri, 09 Jul 2010 16:13:35 +0000
Date: Fri, 9 Jul 2010 12:13:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: writepage always has buffers
Message-ID: <20100709161335.GD26302@infradead.org>
References: <20100628143457.GC5473@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100628143457.GC5473@infradead.org>
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
To: xfs@oss.sgi.com

ping?

On Mon, Jun 28, 2010 at 10:34:57AM -0400, Christoph Hellwig wrote:
> These days we always have buffers thanks to ->page_mkwrite.  And we already
> have an assert a few lines above tripping in case that was not true due to
> a bug.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs-dev/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- xfs-dev.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-06-28 11:59:29.590253914 +0200
> +++ xfs-dev/fs/xfs/linux-2.6/xfs_aops.c	2010-06-28 11:59:48.341006462 +0200
> @@ -1072,13 +1072,6 @@ xfs_vm_writepage(
>  	if ((current->flags & PF_FSTRANS) && (delalloc || unwritten))
>  		goto out_fail;
>  
> -	/*
> -	 * Delay hooking up buffer heads until we have
> -	 * made our go/no-go decision.
> -	 */
> -	if (!page_has_buffers(page))
> -		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
> -
>  	/* Is this page beyond the end of the file? */
>  	offset = i_size_read(inode);
>  	end_index = offset >> PAGE_CACHE_SHIFT;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
