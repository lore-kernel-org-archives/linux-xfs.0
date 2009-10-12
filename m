Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9CJhwZZ052275 for <xfs@oss.sgi.com>; Mon, 12 Oct 2009 14:43:58 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2021C12ED2
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2009 12:45:09 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id zbC8T5BNlF4xuimI for
	<xfs@oss.sgi.com>; Mon, 12 Oct 2009 12:45:09 -0700 (PDT)
Message-ID: <4AD38744.3010702@sandeen.net>
Date: Mon, 12 Oct 2009 14:45:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 03/14] repair: kill B_IS_META flag
References: <20090902175531.469184575@bombadil.infradead.org>
	<20090902175840.224768080@bombadil.infradead.org>
In-Reply-To: <20090902175840.224768080@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:

> B_IS_META is the inverse flag of B_IS_INODE which is not really obvious
> from it's use.  So just use !B_IS_INODE to make it more clear.
>

Logic-wise it's fine, but is this change really helpful?   The comment says:

/*
 * Test if bit 0 or 2 is set in the "priority tag" of the buffer to see if
 * the buffer is for an inode or other metadata.
 */

so basically it distinguishes inodes from other metadata right.

!B_IS_INODE() seems less than helpful...

B_IS_INODE is clear; B_IS_META is pretty clear, "!B_IS_INODE" seems muddy; so
very many things are "not inodes" :)

-Eric
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: xfsprogs-dev/repair/prefetch.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/prefetch.c	2009-08-20 00:02:25.000000000 +0000
> +++ xfsprogs-dev/repair/prefetch.c	2009-08-20 00:05:36.000000000 +0000
> @@ -64,7 +64,6 @@
>   * the buffer is for an inode or other metadata.
>   */
>  #define B_IS_INODE(f)	(((f) & 5) == 0)
> -#define B_IS_META(f)	(((f) & 5) != 0)
>  
>  #define DEF_BATCH_BYTES	0x10000
>  
> @@ -131,7 +130,7 @@
>  
>  	if (fsbno > args->last_bno_read) {
>  		radix_tree_insert(&args->primary_io_queue, fsbno, bp);
> -		if (B_IS_META(flag))
> +		if (!B_IS_INODE(flag))
>  			radix_tree_tag_set(&args->primary_io_queue, fsbno, 0);
>  		else {
>  			args->inode_bufs_queued++;
> @@ -153,7 +152,7 @@
>  			(long long)XFS_BUF_ADDR(bp), args->agno, fsbno,
>  			args->last_bno_read);
>  #endif
> -		ASSERT(B_IS_META(flag));
> +		ASSERT(!B_IS_INODE(flag));
>  		XFS_BUF_SET_PRIORITY(bp, B_DIR_META_2);
>  		radix_tree_insert(&args->secondary_io_queue, fsbno, bp);
>  	}
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
