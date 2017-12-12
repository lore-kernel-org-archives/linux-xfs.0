Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:50225 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751949AbdLLVNY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Dec 2017 16:13:24 -0500
Date: Wed, 13 Dec 2017 08:13:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: include the XFS magic number in magic.h
Message-ID: <20171212211302.GW5858@dastard>
References: <1513088469.3476.48.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1513088469.3476.48.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Tue, Dec 12, 2017 at 09:21:09AM -0500, Mimi Zohar wrote:
> Move the XFS_SB_MAGIC definition to magic.h.
> 
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> ---
>  fs/xfs/libxfs/xfs_format.h | 3 ++-
>  include/uapi/linux/magic.h | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 1acb584fc5f7..05f7d83e5f88 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -18,6 +18,8 @@
>  #ifndef __XFS_FORMAT_H__
>  #define __XFS_FORMAT_H__
>  
> +#include <linux/magic.h>
> +
>  /*
>   * XFS On Disk Format Definitions
>   *
> @@ -38,7 +40,6 @@ struct xfs_ifork;
>   * Fits into a sector-sized buffer at address 0 of each allocation group.
>   * Only the first of these is ever updated except during growfs.
>   */
> -#define	XFS_SB_MAGIC		0x58465342	/* 'XFSB' */
>  #define	XFS_SB_VERSION_1	1		/* 5.3, 6.0.1, 6.1 */
>  #define	XFS_SB_VERSION_2	2		/* 6.2 - attributes */
>  #define	XFS_SB_VERSION_3	3		/* 6.2 - new inode version */

NAK.

The XFS superblock magic number is part of the on-disk format
definition of XFS. It belongs with all the other on-disk format
definitions in this file.

Besides, there is almost never a good reason to be doing stuff based
on filesystem magic numbers. What, exactly, do you need to know
filesystem magic numbers for in the kernel?

Cheers,

Dave.


-- 
Dave Chinner
david@fromorbit.com
