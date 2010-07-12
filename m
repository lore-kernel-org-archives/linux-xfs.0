Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6C3eF7x000704 for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 22:40:15 -0500
Subject: Re: [PATCH] xfs: writepage always has buffers
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100628143457.GC5473@infradead.org>
References: <20100628143457.GC5473@infradead.org>
Date: Sun, 11 Jul 2010 22:43:09 -0500
Message-ID: <1278906189.7456.22.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Mon, 2010-06-28 at 10:34 -0400, Christoph Hellwig wrote:
> These days we always have buffers thanks to ->page_mkwrite.  And we already
> have an assert a few lines above tripping in case that was not true due to
> a bug.

Should the ASSERT() be made stronger (i.e., BUG_ON())?
Looks to me like we'll crash if it ever happens in a
non-debug kernel, and a BUG() call would more directly
tell us what the problem was...

In an case, this looks OK to me.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>

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



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
