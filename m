Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 18:53:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m331r3Cv009081
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 18:53:06 -0700
Date: Thu, 3 Apr 2008 11:53:31 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 2/7] XFS: ASCII case-insensitive support
Message-ID: <20080403015331.GP103491721@sgi.com>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062708.071715758@chook.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402062708.071715758@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, Apr 02, 2008 at 04:25:10PM +1000, Barry Naujok wrote:
> Implement ASCII case-insensitive support. It's primary purpose 
> is for supporting existing filesystems that already use this
> case-insensitive mode migrated from IRIX. But, if you only need
> ASCII-only case-insensitive support (ie. English only) and will
> never use another language, then this mode is perfectly adequate.
> 
> ASCII-CI is implemented by generating hashes based on lower-case
> letters and doing lower-case compares. It implements a new
> xfs_nameops vector for doing the hashes and comparisons for
> all filename operations.
> 
> It also overrides the Linux dentry cache operations with its
> own hash and compare functions (the same as used in the xfs_nameops
> vector).
> 
> To create a filesystem with this CI mode, use:
> # mkfs.xfs -n version=ci <device>
> 
> Signed-off-by: Barry Naujok <bnaujok@sgi.com>
> 
> ---
>  fs/xfs/linux-2.6/xfs_iops.c  |   46 +++++++++++++++++++++++++++++++++++++-
>  fs/xfs/linux-2.6/xfs_linux.h |    1
>  fs/xfs/linux-2.6/xfs_super.c |    4 +++
>  fs/xfs/xfs_dir2.c            |   52 ++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_fs.h              |    1
>  fs/xfs/linux-2.6/xfs_iops.c  |   46 +++++++++++++++++++++++++++++++++++++-
>  fs/xfs/linux-2.6/xfs_linux.h |    1 
>  fs/xfs/linux-2.6/xfs_super.c |    4 +++
>  fs/xfs/xfs_dir2.c            |   52 ++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_fs.h              |    1 
>  fs/xfs/xfs_fsops.c           |    4 ++-
>  fs/xfs/xfs_sb.h              |   10 +++++++-
>  7 files changed, 114 insertions(+), 4 deletions(-)
> 
> Index: kern_ci/fs/xfs/linux-2.6/xfs_iops.c
> ===================================================================
> --- kern_ci.orig/fs/xfs/linux-2.6/xfs_iops.c
> +++ kern_ci/fs/xfs/linux-2.6/xfs_iops.c
> @@ -47,6 +47,7 @@
>  #include "xfs_buf_item.h"
>  #include "xfs_utils.h"
>  #include "xfs_vnodeops.h"
> +#include "xfs_da_btree.h"
>  
>  #include <linux/capability.h>
>  #include <linux/xattr.h>
> @@ -54,6 +55,8 @@
>  #include <linux/security.h>
>  #include <linux/falloc.h>
>  
> +struct dentry_operations xfs_ci_dentry_operations;

static?

> +
> +STATIC int
> +xfs_ci_dentry_hash(
> +	struct dentry	*dir,
> +	struct qstr	*this)
> +{
> +	this->hash = xfs_dir_hashname(XFS_I(dir->d_inode),
> +				this->name, this->len);
> +	return 0;
> +}
> +
> +STATIC int
> +xfs_ci_dentry_compare(
> +	struct dentry	*dir,
> +	struct qstr	*a,
> +	struct qstr	*b)
> +{
> +	int	result = xfs_dir_compname(XFS_I(dir->d_inode), a->name, a->len,
> +					b->name, b->len) == XFS_CMP_DIFFERENT;
> +	/*
> +	 * result == 0 if a match is found, and if so, copy the name in "b"
> +	 * to "a" to cope with negative dentries getting the correct name.
> +	 */
> +	if (result == 0)
> +		memcpy((unsigned char *)a->name, b->name, a->len);
> +	return result;
> +}

large comment in the middle of a 5 line function? Move it above
the function. Also should not need a cast in memcpy()....

/*
 * xfs_dir_compname will return 0 if a match is found. If so, we
 * need to copy the name in "b" to "a" to cope with negative dentries
 * getting the correct name.
 */
STATIC int
xfs_ci_dentry_compare(
	struct dentry	*dir,
	struct qstr	*a,
	struct qstr	*b)
{
	int	result;
	
	result = xfs_dir_compname(XFS_I(dir->d_inode), a->name, a->len,
					b->name, b->len) == XFS_CMP_DIFFERENT;
	if (!result)
		memcpy(a->name, b->name, a->len);
	return result;
}

> +
> +struct dentry_operations xfs_ci_dentry_operations =
> +{
> +	.d_hash = xfs_ci_dentry_hash,
> +	.d_compare = xfs_ci_dentry_compare,
> +};

static.

You should probably move these functions and declarations to before
xfs_ci_dentry_operations is used so you can avoid the forward
declaration....

> ===================================================================
> --- kern_ci.orig/fs/xfs/linux-2.6/xfs_super.c
> +++ kern_ci/fs/xfs/linux-2.6/xfs_super.c
> @@ -67,6 +67,8 @@ static kmem_zone_t *xfs_vnode_zone;
>  static kmem_zone_t *xfs_ioend_zone;
>  mempool_t *xfs_ioend_pool;
>  
> +extern struct dentry_operations xfs_ci_dentry_operations;
> +
>  STATIC struct xfs_mount_args *
>  xfs_args_allocate(
>  	struct super_block	*sb,
> @@ -1359,6 +1361,8 @@ xfs_fs_fill_super(
>  		error = ENOMEM;
>  		goto fail_vnrele;
>  	}
> +	if (xfs_sb_version_hasoldci(&mp->m_sb))
> +		sb->s_root->d_op = &xfs_ci_dentry_operations;

Write a helper function for this: xfs_set_ci_dentry_ops(mp, dentry)
rather than exporting the xfs_ci_dentry_operations structure.

>  
> +/*
> + * V1/OLDCI case-insensitive support for directories
> + *
> + * This is ASCII only case support, ie. A-Z.
> + */

I'd mention that this is legacy code for supporting the Irix
format CI.

> @@ -629,7 +631,7 @@ xfs_fs_goingdown(
>  			xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
>  			thaw_bdev(sb->s_bdev, sb);
>  		}
> -	
> +
>  		break;

random whitespace change?

> Index: kern_ci/fs/xfs/xfs_sb.h
> ===================================================================
> --- kern_ci.orig/fs/xfs/xfs_sb.h
> +++ kern_ci/fs/xfs/xfs_sb.h
> @@ -46,10 +46,12 @@ struct xfs_mount;
>  #define XFS_SB_VERSION_SECTORBIT	0x0800
>  #define	XFS_SB_VERSION_EXTFLGBIT	0x1000
>  #define	XFS_SB_VERSION_DIRV2BIT		0x2000
> +#define XFS_SB_VERSION_OLDCIBIT		0x4000	/* ASCII only case-insens. */
>  #define	XFS_SB_VERSION_MOREBITSBIT	0x8000
>  #define	XFS_SB_VERSION_OKSASHFBITS	\

Whitespace. 

But it's a shame you're being sensible about this - I kinda liked
the Irix name for this feature (XFS_SB_VERSION_BORGBIT). :)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
