Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 014397F54
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 19:10:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B9B08304039
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 17:10:42 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	fJyiWFhI0E58TLSd for <xfs@oss.sgi.com>;
	Sun, 11 Oct 2015 17:10:36 -0700 (PDT)
Date: Mon, 12 Oct 2015 11:10:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v10 24/46] xfs: Add richacl support
Message-ID: <20151012001033.GA27164@dastard>
References: <1444604337-17651-1-git-send-email-andreas.gruenbacher@gmail.com>
	<1444604337-17651-25-git-send-email-andreas.gruenbacher@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1444604337-17651-25-git-send-email-andreas.gruenbacher@gmail.com>
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
To: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

On Mon, Oct 12, 2015 at 12:58:35AM +0200, Andreas Gruenbacher wrote:
> From: Andreas Gruenbacher <agruenba@redhat.com>
> 
> The richacl feature flag (mkfs.xfs -m richacl=1) determines whether an xfs
> filesystem supports posix acls or richacls.  Richacls are stored in
> "system.richacl" xattrs.
> 
> If richacls are not compiled into the kernel, mounting richacl filesystems
> will fail.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/ext4/richacl.h          |  1 -
>  fs/xfs/Kconfig             | 11 ++++++
>  fs/xfs/Makefile            |  1 +
>  fs/xfs/libxfs/xfs_format.h | 16 +++++++-
>  fs/xfs/xfs_iops.c          | 42 +++++++++++++++-----
>  fs/xfs/xfs_richacl.c       | 97 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_richacl.h       | 34 ++++++++++++++++
>  fs/xfs/xfs_super.c         | 14 ++++++-
>  fs/xfs/xfs_super.h         |  9 ++++-
>  fs/xfs/xfs_xattr.c         |  4 ++
>  10 files changed, 215 insertions(+), 14 deletions(-)
>  create mode 100644 fs/xfs/xfs_richacl.c
>  create mode 100644 fs/xfs/xfs_richacl.h
> 
> diff --git a/fs/ext4/richacl.h b/fs/ext4/richacl.h
> index fc7826f..f26fbdd 100644
> --- a/fs/ext4/richacl.h
> +++ b/fs/ext4/richacl.h
> @@ -24,7 +24,6 @@
>  
>  extern struct richacl *ext4_get_richacl(struct inode *);
>  extern int ext4_set_richacl(struct inode *, struct richacl *);
> -
>  extern int ext4_init_richacl(handle_t *, struct inode *, struct inode *);
>  
>  #else  /* CONFIG_EXT4_FS_RICHACL */

stray hunk.

> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index 5d47b4d..05dd312 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -52,6 +52,17 @@ config XFS_POSIX_ACL
>  
>  	  If you don't know what Access Control Lists are, say N.
>  
> +config XFS_RICHACL
> +        bool "XFS Rich Access Control Lists (EXPERIMENTAL)"
> +        depends on XFS_FS
> +        select FS_RICHACL
> +        help
> +          Richacls are an implementation of NFSv4 ACLs, extended by file masks
> +          to cleanly integrate into the POSIX file permission model.  To learn
> +	  more about them, see http://www.bestbits.at/richacl/.
> +
> +          If you don't know what Richacls are, say N.
> +

So now we have multiple compile time ACL configs that we have to
test. Personally, I see no reason for making either posix or rich
acls compile time dependent. How about we just change CONFIG_FS_XFS
to have "select FS_POSIX_ACL" and "select FS_RICHACL"
unconditionally, and then we can get rid of all the conditional
code?

> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 9590a06..8c6da45 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -461,10 +461,18 @@ xfs_sb_has_ro_compat_feature(
>  #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
>  #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
>  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
> +
> +#ifdef CONFIG_XFS_RICHACL
> +#define XFS_SB_FEAT_INCOMPAT_RICHACL	(1 << 3)	/* richacls */
> +#else
> +#define XFS_SB_FEAT_INCOMPAT_RICHACL	0
> +#endif
> +

Regardless of whether we build in richacl support, this is wrong.
Feature bits are on-disk format definitions, so it will always have
this value whether or not the kernel supports the feature.

> @@ -722,7 +737,10 @@ xfs_setattr_nonsize(
>  	 * 	     Posix ACL code seems to care about this issue either.
>  	 */
>  	if ((mask & ATTR_MODE) && !(flags & XFS_ATTR_NOACL)) {
> -		error = posix_acl_chmod(inode, inode->i_mode);
> +		if (XFS_IS_RICHACL(inode))
> +			error = richacl_chmod(inode, inode->i_mode);
> +		else
> +			error = posix_acl_chmod(inode, inode->i_mode);
>  		if (error)
>  			return error;
>  	}

This sort of thing could do with a helper like:

static inline int
xfs_acl_chmod(struct inode *inode, int mode)
{
	if (IS_RICHACL(inode))
		return richacl_chmod(inode, mode);
	return posix_acl_chmod(inode, mode);
}

> +#include "xfs.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_inode.h"
> +#include "xfs_attr.h"
> +
> +#include <linux/richacl_xattr.h>
> +
> +struct richacl *
> +xfs_get_richacl(struct inode *inode)
> +{

...

If we always build in ACL support, this can all go in xfs_acl.c.

> +	struct xfs_inode *ip = XFS_I(inode);
> +	struct richacl *acl;
> +	int size = XATTR_SIZE_MAX;
> +	void *value;
> +	int error;
> +
> +	value = kmem_zalloc_large(size, KM_SLEEP);
> +	if (!value)
> +		return ERR_PTR(-ENOMEM);
> +
> +	error = xfs_attr_get(ip, XATTR_NAME_RICHACL, value, &size, ATTR_ROOT);
> +	if (error) {
> +		/*
> +		 * If the attribute doesn't exist make sure we have a negative
> +		 * cache entry, for any other error assume it is transient and
> +		 * leave the cache entry as ACL_NOT_CACHED.
> +		 */
> +		acl = (error == -ENOATTR) ? NULL : ERR_PTR(error);

I rather dislike ternaries in code like this - it's hard to read the
logic. Initalise acl to NULL, and then this simply becomes:

		if (error != -ENOATTR)
			acl = ERR_PTR(error);

> +	} else
> +		acl = richacl_from_xattr(&init_user_ns, value, size);
> +
> +	if (!IS_ERR(acl))
> +		set_cached_richacl(inode, acl);
> +	kfree(value);
> +
> +	return acl;
> +}
> +
> +int
> +xfs_set_richacl(struct inode *inode, struct richacl *acl)
> +{
> +	struct xfs_inode *ip = XFS_I(inode);
> +	umode_t mode = inode->i_mode;
> +	int error;
> +
> +	if (acl) {
> +		/* Don't allow acls with unmapped identifiers. */
> +		if (richacl_has_unmapped_identifiers(acl))
> +			return -EINVAL;
> +
> +		if (richacl_equiv_mode(acl, &mode) == 0) {
> +			xfs_set_mode(inode, mode);
> +			acl = NULL;
> +		}

Comment needed here - why does this now seem to accidentally fall
through to removing the ACL?  Also, why is this in the XFS specific
code when it's generic richacl functionality that is being checked?

Also, I really dislike the API where passing a NULL acl means to
"set this acl" actually means "remove the existing ACL". Why no
->remove_acl method called from the generic code?


> +#ifndef __FS_XFS_RICHACL_H
> +#define __FS_XFS_RICHACL_H
> +
> +#include <linux/richacl.h>
> +
> +#ifdef CONFIG_XFS_RICHACL
> +
> +#define XFS_IS_RICHACL(inode) IS_RICHACL(inode)

No. Just use IS_RICHACL() everywhere, and whatever build
conditional that uses.

> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1500,7 +1500,19 @@ xfs_fs_fill_super(
>  	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
>  	sb->s_max_links = XFS_MAXLINK;
>  	sb->s_time_gran = 1;
> -	set_posix_acl_flag(sb);
> +
> +	if (xfs_sb_version_hasrichacl(&mp->m_sb)) {
> +#ifdef CONFIG_XFS_RICHACL
> +		sb->s_flags |= MS_RICHACL;
> +#else
> +		error = -EOPNOTSUPP;
> +		goto out_free_sb;
> +#endif
> +	} else {
> +#ifdef CONFIG_XFS_POSIX_ACL
> +		sb->s_flags |= MS_POSIXACL;
> +#endif

The whole point of having set_posix_acl_flag() is that it keeps
the ifdef hackery out of the code. If we are going to keep build
time config options for these, then please keep the wrappers to hide
this mess...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
