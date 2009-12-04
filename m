Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB4IQbMZ241744 for <xfs@oss.sgi.com>; Fri, 4 Dec 2009 12:26:37 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C8B9CFA36
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2009 10:27:08 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id xeKMjI6ezVFVOvmE for
	<xfs@oss.sgi.com>; Fri, 04 Dec 2009 10:27:08 -0800 (PST)
Message-ID: <4B19547B.5000408@sandeen.net>
Date: Fri, 04 Dec 2009 12:27:07 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: kill xfs_bmbt_rec_32/64 types
References: <20091204101907.GA7459@infradead.org>
In-Reply-To: <20091204101907.GA7459@infradead.org>
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

Christoph Hellwig wrote:
> For a long time we've always stored bmap btree records in the 64bit format,
> so kill off the dead 32bit type, and make sure the 64bit type is named just
> xfs_bmbt_rec everywhere, without any size postfix.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yay for less confusion.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Index: xfs/fs/xfs/xfs_bmap_btree.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap_btree.h	2009-12-04 11:05:03.455004035 +0100
> +++ xfs/fs/xfs/xfs_bmap_btree.h	2009-12-04 11:06:51.674031547 +0100
> @@ -46,20 +46,12 @@ typedef struct xfs_bmdr_block {
>  #define BMBT_STARTBLOCK_BITLEN	52
>  #define BMBT_BLOCKCOUNT_BITLEN	21
>  
> -
> -#define BMBT_USE_64	1
> -
> -typedef struct xfs_bmbt_rec_32
> -{
> -	__uint32_t		l0, l1, l2, l3;
> -} xfs_bmbt_rec_32_t;
> -typedef struct xfs_bmbt_rec_64
> -{
> +typedef struct xfs_bmbt_rec {
>  	__be64			l0, l1;
> -} xfs_bmbt_rec_64_t;
> +} xfs_bmbt_rec_t;
>  
>  typedef __uint64_t	xfs_bmbt_rec_base_t;	/* use this for casts */
> -typedef xfs_bmbt_rec_64_t xfs_bmbt_rec_t, xfs_bmdr_rec_t;
> +typedef xfs_bmbt_rec_t xfs_bmdr_rec_t;
>  
>  typedef struct xfs_bmbt_rec_host {
>  	__uint64_t		l0, l1;
> Index: xfs/fs/xfs/xfs_inode_item.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode_item.h	2009-12-04 11:05:21.624026561 +0100
> +++ xfs/fs/xfs/xfs_inode_item.h	2009-12-04 11:05:33.307318764 +0100
> @@ -127,7 +127,7 @@ static inline int xfs_ilog_fdata(int w)
>  #ifdef __KERNEL__
>  
>  struct xfs_buf;
> -struct xfs_bmbt_rec_64;
> +struct xfs_bmbt_rec;
>  struct xfs_inode;
>  struct xfs_mount;
>  
> @@ -140,9 +140,9 @@ typedef struct xfs_inode_log_item {
>  	unsigned short		ili_flags;	   /* misc flags */
>  	unsigned short		ili_logged;	   /* flushed logged data */
>  	unsigned int		ili_last_fields;   /* fields when flushed */
> -	struct xfs_bmbt_rec_64	*ili_extents_buf;  /* array of logged
> +	struct xfs_bmbt_rec	*ili_extents_buf;  /* array of logged
>  						      data exts */
> -	struct xfs_bmbt_rec_64	*ili_aextents_buf; /* array of logged
> +	struct xfs_bmbt_rec	*ili_aextents_buf; /* array of logged
>  						      attr exts */
>  	unsigned int            ili_pushbuf_flag;  /* one bit used in push_ail */
>  
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
