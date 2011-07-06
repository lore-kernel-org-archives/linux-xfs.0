Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p663ON2E063438 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 22:24:24 -0500
Subject: Re: [PATCH 14/27] xfs: kill struct xfs_dir2_sf
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110701094605.197942925@bombadil.infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094605.197942925@bombadil.infradead.org>
Date: Tue, 5 Jul 2011 22:24:18 -0500
Message-ID: <1309922658.3381.22.camel@doink>
MIME-Version: 1.0
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

On Fri, 2011-07-01 at 05:43 -0400, Christoph Hellwig wrote:
> The list field of it is never cactually used, so all uses can simply be
> replaced with the xfs_dir2_sf_hdr_t type that it has as first member.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks like a lot of places could be converted to use
"struct xfs_dir2_sf_hdr" rather than the typedef, but
it's not worth re-posting for that.  (Plus I suspect
such changes may be in forthcoming patches...)

Another few dumb little suggestions below--mostly
regarding a consistent naming scheme--but otherwise
this looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

> Index: xfs/fs/xfs/xfs_dir2_block.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dir2_block.c	2011-06-30 09:32:00.000000000 +0200
> +++ xfs/fs/xfs/xfs_dir2_block.c	2011-06-30 09:35:55.810069526 +0200
. . .
> @@ -1061,32 +1060,30 @@ xfs_dir2_sf_to_block(
>  		ASSERT(XFS_FORCED_SHUTDOWN(mp));
>  		return XFS_ERROR(EIO);
>  	}
> +
> +	oldsfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
> +
>  	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
>  	ASSERT(dp->i_df.if_u1.if_data != NULL);

	ASSERT(oldsfp != NULL);

> -	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
> -	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->hdr.i8count));
> +	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(oldsfp->i8count));

. . .

> Index: xfs/fs/xfs/xfs_dir2_sf.c
> ===================================================================

. . .

> @@ -67,10 +67,10 @@ static void xfs_dir2_sf_toino8(xfs_da_ar
>   */
>  static xfs_ino_t
>  xfs_dir2_sf_get_ino(
> -	struct xfs_dir2_sf	*sfp,
> +	struct xfs_dir2_sf_hdr	*hdr,

I think I like the name "hdr" better than "sfp";
was it just too widespread a change to do a
similar rename elsewhere?  (xfs_dir2_block_to_sf()
uses "sfhp" already, though I like just "hdr".)

>  	xfs_dir2_inou_t		*from)
>  {
> -	if (sfp->hdr.i8count)
> +	if (hdr->i8count)
>  		return XFS_GET_DIR_INO8(from->i8);
>  	else
>  		return XFS_GET_DIR_INO4(from->i4);

. . .

> @@ -237,7 +237,7 @@ xfs_dir2_block_to_sf(
>  	xfs_mount_t		*mp;		/* filesystem mount point */
>  	char			*ptr;		/* current data pointer */
>  	xfs_dir2_sf_entry_t	*sfep;		/* shortform entry */
> -	xfs_dir2_sf_t		*sfp;		/* shortform structure */
> +	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */

    xfs_dir2_sf_hdr_t       *hdr;   /* shortform directory header */
 
>  	trace_xfs_dir2_block_to_sf(args);
>  
. . .


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
