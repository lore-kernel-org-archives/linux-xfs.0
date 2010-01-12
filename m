Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0CD8SEH015782 for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 07:08:29 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 52B0415D763
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 05:09:24 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9nsaVG3pYYuUVtLj for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2010 05:09:24 -0800 (PST)
Date: Tue, 12 Jan 2010 08:09:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: xfs_swap_extents needs to handle dynamic fork offsets
Message-ID: <20100112130922.GA30985@infradead.org>
References: <1263272506-15085-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263272506-15085-1-git-send-email-david@fromorbit.com>
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

> +	TP_printk("dev %d:%d %s inode 0x%llx, %s format, num_extents %d, "
> +		  "Max in-fork extents %d, broot size %d, fork offset %d",

It would be nice to keep the

	"dev %d:%d ino 0x%llx"

prefix as a convention so that all trace records are similar at their
beginning.

>  #undef TRACE_INCLUDE_PATH
> diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
> @@ -53,7 +53,7 @@ xfs_swapext(
>  	xfs_swapext_t	*sxp)
>  {
>  	xfs_inode_t     *ip, *tip;
> -	struct file	*file, *target_file;
> +	struct file	*file, *tmp_file;

I think these xfs_swapext belong into a separate patch.  While they
make the code quite a bit more redable they're purely cleanups and
can wait for 2.6.34.  And while you're at it you might also want to
merge xfs_swap_extents into xfs_swapext - there's no need for that
split at all.

> +static int
> +xfs_swap_extents_check_format(
> +	xfs_inode_t	*ip,	/* target inode */
> +	xfs_inode_t	*tip)	/* tmp inode */

What about just using struct xfs_inode * for new code?

> +	/* Should never get a local format */
> +	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL ||
> +	    tip->i_d.di_format == XFS_DINODE_FMT_LOCAL)
> +		return EINVAL;

Ok, same check as in the old code.  Any reason we drop the XFS_ERROR
here?

> +	/*
> +	 * if the target inode has less extents that then temporary inode then
> +	 * why did userspace call us?
> +	 */
> +	if (ip->i_d.di_nextents < tip->i_d.di_nextents)
> +		return EINVAL;

Ok.
> +	/*
> +	 * if the target inode is in extent form and the temp inode is in btree
> +	 * form then we will end up with the target inode in the wrong format
> +	 * as we already know there are less extents in the temp inode.
> +	 */
> +	if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
> +	    tip->i_d.di_format == XFS_DINODE_FMT_BTREE)
> +		return EINVAL;

Ok.

> +	/* Check temp in extent form to max in target */
> +	if (tip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
> +	    XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) > ip->i_df.if_ext_max)
> +		return EINVAL;
> +
> +	/* Check target in extent form to max in temp */
> +	if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
> +	    XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) > tip->i_df.if_ext_max)
> +		return EINVAL;

So we check this either way just to be sure, ok.

> +	/* Check root block of temp in btree form to max in target */
> +	if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
> +	    XFS_IFORK_BOFF(ip) &&
> +	    tip->i_df.if_broot_bytes > XFS_IFORK_BOFF(ip))
> +		return EINVAL;
> +
> +	/* Check root block of target in btree form to max in temp */
> +	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
> +	    XFS_IFORK_BOFF(tip) &&
> +	    ip->i_df.if_broot_bytes > XFS_IFORK_BOFF(tip))
> +		return EINVAL;

Same here.


Patch looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
