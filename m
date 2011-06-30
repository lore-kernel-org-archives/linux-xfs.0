Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U6ZHFd186937 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 01:35:17 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 372F41E570FE
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 23:35:15 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	oKN8LlEYRIpeaz9J for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 23:35:15 -0700 (PDT)
Date: Thu, 30 Jun 2011 16:35:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/27] xfs: cleanup shortform directory inode number
	handling
Message-ID: <20110630063508.GH561@dastard>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140339.266356959@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110629140339.266356959@bombadil.infradead.org>
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

On Wed, Jun 29, 2011 at 10:01:23AM -0400, Christoph Hellwig wrote:
> Refactor the shortform directory helpers that deal with the 32-bit vs
> 64-bit wide inode numbers into more sensible helpers, and kill the
> xfs_intino_t typedef that is now superflous.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

A few consistency things, and a bit whitespacy, otherwise:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> 
> Index: xfs/fs/xfs/xfs_dir2_sf.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dir2_sf.c	2010-05-25 11:40:59.357006075 +0200
> +++ xfs/fs/xfs/xfs_dir2_sf.c	2010-05-27 14:48:16.709004470 +0200
> @@ -59,6 +59,83 @@ static void xfs_dir2_sf_toino4(xfs_da_ar
>  static void xfs_dir2_sf_toino8(xfs_da_args_t *args);
>  #endif /* XFS_BIG_INUMS */
>  
> +
> +/*
> + * Inode numbers in short-form directories can come in two versions,
> + * either 4 bytes or 8 bytes wide.  These helpers deal with the
> + * two forms transparently by looking at the headers i8count field.
> + */
> +
> +static xfs_ino_t

Extra line there...

> +xfs_dir2_sf_get_ino(
> +	struct xfs_dir2_sf	*sfp,
> +	xfs_dir2_inou_t		*from)
> +{
> +	if (sfp->hdr.i8count)
> +		return XFS_GET_DIR_INO8(from->i8);
> +	else
> +		return XFS_GET_DIR_INO4(from->i4);
> +}
> +static void

And none there.

> +xfs_dir2_sf_put_inumber(
> +	struct xfs_dir2_sf	*sfp,
> +	xfs_dir2_inou_t		*to,
> +	xfs_ino_t		ino)
> +{
> +	if (sfp->hdr.i8count)
> +		XFS_PUT_DIR_INO8(ino, to->i8);
> +	else
> +		XFS_PUT_DIR_INO4(ino, to->i4);
> +}

Also, xfs_dir2_sf_get_ino() vs xfs_dir2_sf_put_inumber() - either
use _ino or _inumber as the suffix for both. _ino is probably more
consistent with the other functions...

> +
> +xfs_ino_t
> +xfs_dir2_sf_get_parent_ino(
> +	struct xfs_dir2_sf	*sfp)
> +{
> +	return xfs_dir2_sf_get_ino(sfp, &sfp->hdr.parent);
> +}
> +
> +

Extra whitespace.

> +static void
> +xfs_dir2_sf_put_parent_ino(
> +	struct xfs_dir2_sf	*sfp,
> +	xfs_ino_t		ino)
> +{
> +	xfs_dir2_sf_put_inumber(sfp, &sfp->hdr.parent, ino);
> +}
> +
> +

Extra whitespace.

> +/*
> + * In short-form directory entries the inode numbers are stored at variable
> + * offset behind the entry name.  The inode numbers may only be accessed
> + * through the helpers below.
> + */
> +

Extra whitespace.

> +static xfs_dir2_inou_t *
> +xfs_dir2_sf_inop(
> +	struct xfs_dir2_sf_entry *sfep)
> +{
> +	return (xfs_dir2_inou_t *)&sfep->name[sfep->namelen];
> +}

Probably should be called xfs_dir2_sfe_inop()  because it takes a
xfs_dir2_sf_entry, similar to the following functions use "sfe".

> +
> +xfs_ino_t
> +xfs_dir2_sfe_get_ino(
> +	struct xfs_dir2_sf	*sfp,
> +	struct xfs_dir2_sf_entry *sfep)
> +{
> +	return xfs_dir2_sf_get_ino(sfp, xfs_dir2_sf_inop(sfep));
> +}
> +
> +static void
> +xfs_dir2_sfe_put_ino(
> +	struct xfs_dir2_sf	*sfp,
> +	struct xfs_dir2_sf_entry *sfep,
> +	xfs_ino_t		ino)
> +{
> +	xfs_dir2_sf_put_inumber(sfp, xfs_dir2_sf_inop(sfep), ino);
> +}
> +
> +

Extra whitespace.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
