Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p04LrB93046531 for <xfs@oss.sgi.com>; Tue, 4 Jan 2011 15:53:11 -0600
Subject: Re: [PATCH] xfs: add FITRIM support
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110102072202.GA26488@infradead.org>
References: <20110102072202.GA26488@infradead.org>
Date: Tue, 04 Jan 2011 15:55:15 -0600
Message-ID: <1294178115.2485.19.camel@doink>
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

On Sun, 2011-01-02 at 02:22 -0500, Christoph Hellwig wrote:
> Allow manual discards from userspace using the FITRIM ioctl.  This is not
> intended to be run during normal workloads, as the freepsace btree walks
> can cause large performance degradation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks good, but I mention three things below.
Correct them as you see fit, either way:

Reviewed-by: Alex Elder <aelder@sgi.com>


> ---
> 
> V1 -> V2
>  
>  - added __user annotations as noted by Alex
>  - removed non-blocking agf read as noted by Alex
>  - update range->len as noted by Alex
> 
> This does not implement the by-bno search or lock break suggestions from
> Dave.  Given that the 2.6.38 window is about to close those seem a bit
> risky to me.  I'll look into these later.

. . .

> 				   xfs_fs_subr.o \
> Index: xfs/fs/xfs/linux-2.6/xfs_discard.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfs/fs/xfs/linux-2.6/xfs_discard.c	2011-01-02 08:06:15.828014477 +0100
> @@ -0,0 +1,191 @@
> +/*
> + * Copyright (C) 2010 Red Hat, Inc.

Maybe 2011 now...

> + * All Rights Reserved.
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +#include "xfs.h"
> +#include "xfs_sb.h"

. . .

> +
> +STATIC int
> +xfs_trim_extents(
> +	struct xfs_mount	*mp,
. . .
> +
> +		/*
> +		 * If the extent is entirely outside of the range we are
> +		 * supposed to discard skip it.  Do not bother to trim
> +		 * down partially overlapping ranges for now.
> +		 */
> +		if (XFS_AGB_TO_FSB(mp, agno, fbno) + flen < start ||
> +		    XFS_AGB_TO_FSB(mp, agno, fbno) > start + len) {

                                                    ^
                                          I think this should be >=

> +			trace_xfs_discard_exclude(mp, agno, fbno, flen);
> +			goto next_extent;
> +		}

. . .

> Index: xfs/fs/xfs/linux-2.6/xfs_discard.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfs/fs/xfs/linux-2.6/xfs_discard.h	2011-01-02 07:11:43.693026629 +0100

Do you want to add a boilerplate copyright header here?

> @@ -0,0 +1,8 @@
> +#ifndef XFS_DISCARD_H
> +#define XFS_DISCARD_H 1
> +
> +struct fstrim_range;
> +
> +extern int	xfs_ioc_trim(struct xfs_mount *, struct fstrim_range __user *);
> +
> +#endif /* XFS_DISCARD_H */

. . .


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
