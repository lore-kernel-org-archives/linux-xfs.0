Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47228 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbeJIFqF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Oct 2018 01:46:05 -0400
Date: Mon, 8 Oct 2018 15:31:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: add a define for statfs magic to uapi
Message-ID: <20181008223152.GG28243@magnolia>
References: <20181005234009.GJ12041@dastard>
 <20181006220811.21482-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181006220811.21482-1-kilobyte@angband.pl>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Adam Borowski <kilobyte@angband.pl>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Sun, Oct 07, 2018 at 12:08:11AM +0200, Adam Borowski wrote:
> Needed by userspace programs that call fstatfs().
> 
> It'd be natural to publish XFS_SB_MAGIC in uapi, but while these two have
> identical values, they have different semantic meaning: one is an enum
> cookie meant for statfs, the other a signature of the on-disk format.
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
> > > include/uapi/linux/magic.h would get:
> > >
> > > #define XFS_STATFS_MAGIC      0x58465342      /* 'XFSB' */
> >
> > $ man statfs |grep 0x5846
> >            XFS_SUPER_MAGIC       0x58465342
> 
> Indeed, not only it is documented this way, but almost every other
> filesystem has the define named FOO_SUPER_MAGIC.  Thus, inventing something
> else doesn't seem to be a good idea to me.
> 
> On the other hand, this might be considered bikeshedding, and you're the
> maintainer of this particular shed...
> 
> 
>  fs/xfs/xfs_super.c         | 5 +++--
>  include/uapi/linux/magic.h | 1 +
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 207ee302b1bb..90b08051a4f3 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -43,6 +43,7 @@
>  #include <linux/dax.h>
>  #include <linux/init.h>
>  #include <linux/slab.h>
> +#include <linux/magic.h>
>  #include <linux/mount.h>
>  #include <linux/mempool.h>
>  #include <linux/writeback.h>
> @@ -1097,7 +1098,7 @@ xfs_fs_statfs(
>  	xfs_extlen_t		lsize;
>  	int64_t			ffree;
>  
> -	statp->f_type = XFS_SB_MAGIC;
> +	statp->f_type = XFS_SUPER_MAGIC;
>  	statp->f_namelen = MAXNAMELEN - 1;
>  
>  	id = huge_encode_dev(mp->m_ddev_targp->bt_dev);
> @@ -1650,7 +1651,7 @@ xfs_fs_fill_super(
>  	 * we must configure the block size in the superblock before we run the
>  	 * full mount process as the mount process can lookup and cache inodes.
>  	 */
> -	sb->s_magic = XFS_SB_MAGIC;
> +	sb->s_magic = XFS_SUPER_MAGIC;
>  	sb->s_blocksize = mp->m_sb.sb_blocksize;
>  	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
>  	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
> diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> index 1a6fee974116..96c24478d8ce 100644
> --- a/include/uapi/linux/magic.h
> +++ b/include/uapi/linux/magic.h
> @@ -29,6 +29,7 @@
>  #define HPFS_SUPER_MAGIC	0xf995e849
>  #define ISOFS_SUPER_MAGIC	0x9660
>  #define JFFS2_SUPER_MAGIC	0x72b6
> +#define XFS_SUPER_MAGIC		0x58465342	/* "XFSB" */

Looks ok to me...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  #define PSTOREFS_MAGIC		0x6165676C
>  #define EFIVARFS_MAGIC		0xde5e81e4
>  #define HOSTFS_SUPER_MAGIC	0x00c0ffee
> -- 
> 2.19.1
> 
