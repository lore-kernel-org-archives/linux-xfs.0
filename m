Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1E98A7F3F
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 15:07:49 -0500 (CDT)
Date: Wed, 24 Jul 2013 15:07:45 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 08/48] libxfs: add support for crc headers on remote
	symlinks
Message-ID: <20130724200745.GQ3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-9-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:25:31AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Ok, so this corresponds with commit f948dd76d and commit 19de7351a....


> diff --git a/include/xfs_symlink.h b/include/xfs_symlink.h
> new file mode 100644
> index 0000000..bb21e6a
> --- /dev/null
> +++ b/include/xfs_symlink.h
> @@ -0,0 +1,43 @@
> +/*
> + * Copyright (c) 2012 Red Hat, Inc. All rights reserved.
> + */

Please add the gpl header as you did in the kernel.


> diff --git a/libxfs/Makefile b/libxfs/Makefile
> index 28f71c8..75f365c 100644
> --- a/libxfs/Makefile
> +++ b/libxfs/Makefile
> @@ -17,7 +17,7 @@ CFILES = cache.c init.c kmem.c logitem.c radix-tree.c rdwr.c trans.c util.c \
>  	xfs_dir2.c xfs_dir2_leaf.c xfs_attr_leaf.c xfs_dir2_block.c \
>  	xfs_dir2_node.c xfs_dir2_data.c xfs_dir2_sf.c xfs_bmap.c \
>  	xfs_mount.c xfs_rtalloc.c xfs_trans.c xfs_attr.c \
> -	crc32.c
> +	crc32.c xfs_symlink.c
>  
>  CFILES += $(PKG_PLATFORM).c
>  PCFILES = darwin.c freebsd.c irix.c linux.c
> diff --git a/libxfs/xfs_symlink.c b/libxfs/xfs_symlink.c
> new file mode 100644
> index 0000000..e018abc
> --- /dev/null
> +++ b/libxfs/xfs_symlink.c
> @@ -0,0 +1,154 @@
> +/*
> + * Copyright 2013 Red Hat, Inc.
> + * All rights reserved.
> + */

Here too.

Else, this looks fine.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
