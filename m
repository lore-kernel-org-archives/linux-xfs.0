Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59178 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbeJEXFc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 19:05:32 -0400
Date: Fri, 5 Oct 2018 09:06:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: move the define for superblock magic to uapi
Message-ID: <20181005160600.GR19324@magnolia>
References: <20181005122741.5100-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005122741.5100-1-kilobyte@angband.pl>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Adam Borowski <kilobyte@angband.pl>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 05, 2018 at 02:27:41PM +0200, Adam Borowski wrote:
> Needed by users of fstatfs().

NAK.

The XFS superblock magic number is part of the on-disk format definition
of XFS. It belongs with all the other on-disk format definitions in this
file.

I don't think it's a good idea for userspace to associate s_magic with
userspace API feature sets, though the cat's long escaped the bag on
that one.

With that being reality, "the XFS superblock magic number" has a
different semantic meaning than "the agreed upon statfs.f_type value for
XFS", which means the latter should have a different symbol name to
reflect that difference.

--D

> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>

> ---
>  fs/xfs/libxfs/xfs_format.h | 3 ++-
>  include/uapi/linux/magic.h | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 059bc44c27e8..837863c57e8c 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -14,6 +14,7 @@
>   * xfs_da_format.h, which log and log item formats are defined in
>   * xfs_log_format.h. Everything else goes here.
>   */
> +#include <linux/magic.h>
>  
>  struct xfs_mount;
>  struct xfs_trans;
> @@ -26,7 +27,7 @@ struct xfs_ifork;
>   * Fits into a sector-sized buffer at address 0 of each allocation group.
>   * Only the first of these is ever updated except during growfs.
>   */
> -#define	XFS_SB_MAGIC		0x58465342	/* 'XFSB' */
> +#define	XFS_SB_MAGIC		XFS_SUPER_MAGIC /* 0x58465342 = 'XFSB' */
>  #define	XFS_SB_VERSION_1	1		/* 5.3, 6.0.1, 6.1 */
>  #define	XFS_SB_VERSION_2	2		/* 6.2 - attributes */
>  #define	XFS_SB_VERSION_3	3		/* 6.2 - new inode version */
> diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> index 1a6fee974116..96c24478d8ce 100644
> --- a/include/uapi/linux/magic.h
> +++ b/include/uapi/linux/magic.h
> @@ -29,6 +29,7 @@
>  #define HPFS_SUPER_MAGIC	0xf995e849
>  #define ISOFS_SUPER_MAGIC	0x9660
>  #define JFFS2_SUPER_MAGIC	0x72b6
> +#define XFS_SUPER_MAGIC		0x58465342	/* "XFSB" */
>  #define PSTOREFS_MAGIC		0x6165676C
>  #define EFIVARFS_MAGIC		0xde5e81e4
>  #define HOSTFS_SUPER_MAGIC	0x00c0ffee
> -- 
> 2.19.0
> 
