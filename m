Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAJ4gXTv234601 for <xfs@oss.sgi.com>; Wed, 18 Nov 2009 22:42:33 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26DE49A2FB
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2009 20:42:55 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id pGdWHEPTRIoqeev7 for
	<xfs@oss.sgi.com>; Wed, 18 Nov 2009 20:42:55 -0800 (PST)
Message-ID: <4B04CCCD.4020206@sandeen.net>
Date: Wed, 18 Nov 2009 22:42:53 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 3/7] xfs: rename xfs_attr_fetch to xfs_attr_get_int
References: <20091114161717.233372584@bombadil.infradead.org>
	<20091114161801.612419979@bombadil.infradead.org>
In-Reply-To: <20091114161801.612419979@bombadil.infradead.org>
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

> Using a totally different name for the lowlevel get operation does not
> fit the _int convention used in the rest of the attr code, so rename it.
> 
> While we're at it also fix the prototype to use the normal convention
> and mark it static as it's never used outside of xfs_attr.c.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfs/fs/xfs/xfs_attr.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_attr.c	2009-11-12 17:10:20.047264798 +0100
> +++ xfs/fs/xfs/xfs_attr.c	2009-11-12 17:18:17.703273473 +0100
> @@ -123,9 +123,13 @@ xfs_inode_hasattr(
>   * Overall external interface routines.
>   *========================================================================*/
>  
> -int
> -xfs_attr_fetch(xfs_inode_t *ip, struct xfs_name *name,
> -		char *value, int *valuelenp, int flags)
> +STATIC int
> +xfs_attr_get_int(
> +	struct xfs_inode	*ip,
> +	struct xfs_name		*name,
> +	char			*value,
> +	int			*valuelenp,
> +	int			flags)
>  {
>  	xfs_da_args_t   args;
>  	int             error;
> @@ -188,7 +192,7 @@ xfs_attr_get(
>  		return error;
>  
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
> -	error = xfs_attr_fetch(ip, &xname, value, valuelenp, flags);
> +	error = xfs_attr_get_int(ip, &xname, value, valuelenp, flags);
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  	return(error);
>  }
> Index: xfs/fs/xfs/xfs_attr.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_attr.h	2009-11-12 17:10:20.056254911 +0100
> +++ xfs/fs/xfs/xfs_attr.h	2009-11-12 17:18:17.703273473 +0100
> @@ -131,7 +131,6 @@ typedef struct xfs_attr_list_context {
>   */
>  int xfs_attr_calc_size(struct xfs_inode *, int, int, int *);
>  int xfs_attr_inactive(struct xfs_inode *dp);
> -int xfs_attr_fetch(struct xfs_inode *, struct xfs_name *, char *, int *, int);
>  int xfs_attr_rmtval_get(struct xfs_da_args *args);
>  int xfs_attr_list_int(struct xfs_attr_list_context *);
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
