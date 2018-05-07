Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48788 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753309AbeEGVgX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 17:36:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w47LUtNG047548
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 21:36:22 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2hs59360nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 May 2018 21:36:22 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w47LaLPH018937
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 21:36:21 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w47LaLfj016896
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 21:36:21 GMT
Date: Mon, 7 May 2018 14:36:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 20/21] xfs: Add parent pointer ioctl
Message-ID: <20180507213620.GB11261@magnolia>
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
 <1525627494-12873-21-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525627494-12873-21-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, May 06, 2018 at 10:24:53AM -0700, Allison Henderson wrote:
> This patch adds a new file ioctl to retrieve the parent
> pointer of a given inode
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h     | 38 ++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_parent.c | 10 +++++++
>  fs/xfs/libxfs/xfs_parent.h |  2 ++
>  fs/xfs/xfs_attr_list.c     |  3 +++
>  fs/xfs/xfs_ioctl.c         | 61 +++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_parent_utils.c  | 66 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_parent_utils.h  |  2 ++
>  7 files changed, 181 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 641e0af..4e0ccdd 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -552,6 +552,43 @@ struct xfs_scrub_metadata {
>  				 XFS_SCRUB_OFLAG_WARNING)
>  #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
>  
> +#define XFS_PPTR_MAXNAMELEN				255
> +
> +/* return parents of the handle, not the open fd */
> +#define XFS_PPTR_IFLAG_HANDLE  (1U << 0)
> +
> +/* Get an inode parent pointer through ioctl */
> +struct xfs_parent_ptr {
> +	__u64		xpp_ino;			/* Inode */
> +	__u32		xpp_gen;			/* Inode generation */
> +	__u32		xpp_diroffset;			/* Directory offset */
> +	__u32		xpp_namelen;			/* File name length */
> +	__u8		xpp_name[XFS_PPTR_MAXNAMELEN];	/* File name */
> +};

Hmm, this structure probably needs padding to round up the size up to an
even multiple of 8 bytes so that 32-bit userspace can call it without
problems(?)

(I suggest dumping the structure definitions into a plain C program and
calling pahole...)

> +
> +/* Iterate though an inodes parent pointers */
> +struct xfs_pptr_info {
> +	struct xfs_handle		pi_handle;
> +	struct xfs_attrlist_cursor	pi_cursor;
> +	__u32				pi_flags;
> +	__u32				pi_reserved;
> +	__u32				pi_ptrs_size;
> +	__u32				pi_ptrs_used;
> +	__u64				pi_reserved2[6];
> +
> +	/*
> +	 * An array of struct xfs_pptr follows the header
> +	 * information. Use XFS_PPINFO_TO_PP() to access the
> +	 * parent pointer array entries.
> +	 */
> +};
> +
> +#define XFS_PPTR_INFO_SIZEOF(nr_ptrs) sizeof (struct xfs_pptr_info) + \
> +				      nr_ptrs * sizeof(struct xfs_parent_ptr)
> +
> +#define XFS_PPINFO_TO_PP(info, idx)    \
> +	(&(((struct xfs_parent_ptr *)((char *)(info) + sizeof(*(info))))[(idx)]))
> +
>  /*
>   * ioctl limits
>   */
> @@ -596,6 +633,7 @@ struct xfs_scrub_metadata {
>  #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
>  /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
>  #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
> +#define XFS_IOC_GETPPOINTER	_IOR ('X', 61, struct xfs_parent_ptr)
>  
>  /*
>   * ioctl commands that replace IRIX syssgi()'s
> diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
> index e6de97c..61f1961 100644
> --- a/fs/xfs/libxfs/xfs_parent.c
> +++ b/fs/xfs/libxfs/xfs_parent.c
> @@ -32,6 +32,16 @@
>  #include "xfs_attr_sf.h"
>  #include "xfs_bmap.h"
>  
> +/* Initializes a xfs_parent_ptr from an xfs_parent_name_rec */
> +void
> +xfs_init_parent_ptr(struct xfs_parent_ptr		*xpp,
> +		     struct xfs_parent_name_rec	*rec)
> +{
> +	xpp->xpp_ino = be64_to_cpu(rec->p_ino);
> +	xpp->xpp_gen = be32_to_cpu(rec->p_gen);
> +	xpp->xpp_diroffset = be32_to_cpu(rec->p_diroffset);
> +}
> +
>  /*
>   * Parent pointer attribute handling.
>   *
> diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
> index 298562b..1a321db 100644
> --- a/fs/xfs/libxfs/xfs_parent.h
> +++ b/fs/xfs/libxfs/xfs_parent.h
> @@ -33,4 +33,6 @@ int xfs_parent_add(struct xfs_trans *tp, struct xfs_inode *parent,
>  		   struct xfs_inode *child, struct xfs_name *child_name,
>  		   uint32_t diroffset, xfs_fsblock_t *firstblock,
>  		   struct xfs_defer_ops *dfops);
> +void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
> +			 struct xfs_parent_name_rec *rec);
>  #endif	/* __XFS_PARENT_H__ */
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 3e59a34..bdbe9fb 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -581,6 +581,9 @@ xfs_attr_put_listent(
>  	if (((context->flags & ATTR_ROOT) == 0) !=
>  	    ((flags & XFS_ATTR_ROOT) == 0))
>  		return;
> +	if (((context->flags & ATTR_PARENT) == 0) !=
> +	    ((flags & XFS_ATTR_PARENT) == 0))
> +		return;
>  
>  	arraytop = sizeof(*alist) +
>  			context->count * sizeof(alist->al_offset[0]);
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 844480a..ee544f2 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -46,6 +46,8 @@
>  #include "xfs_fsmap.h"
>  #include "scrub/xfs_scrub.h"
>  #include "xfs_sb.h"
> +#include "xfs_da_format.h"
> +#include "xfs_parent_utils.h"
>  
>  #include <linux/capability.h>
>  #include <linux/cred.h>
> @@ -1738,6 +1740,62 @@ xfs_ioc_scrub_metadata(
>  	return 0;
>  }
>  
> +/*
> + * IOCTL routine to get the parent pointer of an inode and return it to user
> + * space.  Caller must pass an struct xfs_parent_name_irec with a name buffer
> + * large enough to hold the file name.  Returns 0 on success or non-zero on
> + * failure
> + */
> +STATIC int
> +xfs_ioc_get_parent_pointer(
> +	struct file			*filp,
> +	void				__user *arg)
> +{
> +	struct xfs_inode		*ip;
> +	struct xfs_pptr_info		*ppi;
> +	struct dentry			*dentry;
> +	int				error = 0;

At least initially this ought to be restricted by capabilities.

if (!capable(CAP_SYS_ADMIN))
	return -EPERM;

I'd be open to allowing a few other capabilities?  Maybe the DAC
override one?

Also needs to check for invalid pi_flags and nonzero reserved fields.

> +
> +	/* Allocate an xfs_pptr_info to put the user data */
> +	ppi = kmem_alloc(sizeof(struct xfs_pptr_info), KM_SLEEP);
> +	if (!ppi)
> +		return -ENOMEM;
> +
> +	/* Copy the data from the user */
> +	copy_from_user(ppi, arg, sizeof(struct xfs_pptr_info));

Please do not throw away the return value.

> +
> +	/*
> +	 * Now that we know how big the trailing buffer is, expand
> +	 * our kernel xfs_pptr_info to be the same size
> +	 */
> +	ppi = kmem_realloc(ppi, XFS_PPTR_INFO_SIZEOF(ppi->pi_ptrs_size),

Hmm, pi_ptrs_size probably needs some kind of check so that userspace
can't ask for insane large allocations.  64k, perhaps?  ~230 records per
call ought to be enough for anyone... :P

if (XFS_PPTR_INFO_SIZEOFI(...) > XFS_XATTR_LIST_MAX)
	return -ENOMEM;
ppi = kmem_realloc(...);

> +			     KM_SLEEP);
> +	if (!ppi)
> +		return -ENOMEM;
> +
> +	if (ppi->pi_flags == XFS_PPTR_IFLAG_HANDLE) {
> +		dentry = xfs_handle_to_dentry(filp, &ppi->pi_handle,
> +					      sizeof(struct xfs_handle));
> +		if (IS_ERR(dentry))
> +			return PTR_ERR(dentry);
> +		ip = XFS_I(d_inode(dentry));

I would've thought that between the dentry and the ip that at least one
of those would require a dput/iput, and that we'd need to do something
to prevent the dentry or the inode from disappearing from underneath us...

...but you could also extract the inode and generation numbers from the
handle information and call xfs_iget directly.  The exportfs code tries
to reconnect dentry parent information up to the root, which will turn
out badly if some mid-level directory is corrupt and scrub is trying to
reconstruct the former path of a now inaccessible file.

That said, I could just fix this myself to satisfy the requirements of
the, uh, single consumer of this information. :)

(Particularly since my dorky rfc used this exact exportfs_decode_fh
mechanism. :p)

((You could also replace this hunk with 'return -EPERM' and let me sort
the whole thing out. :) ))

> +	} else
> +		ip = XFS_I(file_inode(filp));
> +
> +	/* Get the parent pointers */
> +	error = xfs_attr_get_parent_pointer(ip, ppi);
> +
> +	if (error)
> +		goto out;
> +
> +	/* Copy the parent pointers back to the user */
> +	copy_to_user(arg, ppi, XFS_PPTR_INFO_SIZEOF(ppi->pi_ptrs_size));

Need to check the return values here too.

> +
> +out:
> +	kmem_free(ppi);
> +	return error;
> +}
> +
>  int
>  xfs_ioc_swapext(
>  	xfs_swapext_t	*sxp)
> @@ -1894,7 +1952,8 @@ xfs_file_ioctl(
>  		return xfs_ioc_getxflags(ip, arg);
>  	case XFS_IOC_SETXFLAGS:
>  		return xfs_ioc_setxflags(ip, filp, arg);
> -
> +	case XFS_IOC_GETPPOINTER:
> +		return xfs_ioc_get_parent_pointer(filp, arg);
>  	case XFS_IOC_FSSETDM: {
>  		struct fsdmidata	dmi;
>  
> diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
> index 0fd48b8..1df003a 100644
> --- a/fs/xfs/xfs_parent_utils.c
> +++ b/fs/xfs/xfs_parent_utils.c
> @@ -68,3 +68,69 @@ xfs_parent_remove_deferred(
>  					ATTR_PARENT);
>  }
>  
> +/*
> + * Get the parent pointers for a given inode
> + *
> + * Returns 0 on success and non zero on error
> + */
> +int
> +xfs_attr_get_parent_pointer(struct xfs_inode		*ip,
> +			     struct xfs_pptr_info	*ppi)
> +
> +{
> +
> +	struct attrlist			*alist;
> +	struct attrlist_ent		*aent;
> +	struct xfs_parent_ptr		*xpp;
> +	struct xfs_parent_name_rec	*xpnr;
> +	char				*namebuf;
> +	unsigned int			namebuf_size;
> +	int				name_len;
> +	int				error = 0;
> +	unsigned int			flags = ATTR_PARENT;
> +	int				i;
> +
> +	/* Allocate a buffer to store the attribute names */
> +	namebuf_size = sizeof(struct attrlist) +
> +		       (ppi->pi_ptrs_size) * sizeof(struct attrlist_ent);
> +	namebuf = kmem_zalloc_large(namebuf_size, KM_SLEEP);
> +	if (!namebuf)
> +		return -ENOMEM;
> +
> +	error = xfs_attr_list(ip, namebuf, namebuf_size, flags,

I suspect we need to hold the ILOCK across the xfs_attr_list call and
the xfs_attr_get loop so that we hold the attr list consistent while
extracting parent pointer information; see xfs_attr_list_int_ilocked and
xfs_attr_get_ilocked...

--D

> +			      (attrlist_cursor_kern_t *)&ppi->pi_cursor);
> +	if (error)
> +		goto out_kfree;
> +
> +	alist = (struct attrlist *)namebuf;
> +
> +	for (i = 0; i < alist->al_count; i++) {
> +		xpp = XFS_PPINFO_TO_PP(ppi, i);
> +		memset(xpp, 0, sizeof(struct xfs_parent_ptr));
> +		aent = (struct attrlist_ent *) &namebuf[alist->al_offset[i]];
> +		xpnr = (struct xfs_parent_name_rec *)(aent->a_name);
> +
> +		if (aent->a_valuelen > XFS_PPTR_MAXNAMELEN) {
> +			error = -ERANGE;
> +			goto out_kfree;
> +		}
> +
> +		name_len = aent->a_valuelen;
> +		error = xfs_attr_get(ip, (char *)xpnr,
> +					sizeof(struct xfs_parent_name_rec),
> +					(unsigned char *)(xpp->xpp_name),
> +					&name_len, flags);
> +		if (error)
> +			goto out_kfree;
> +
> +		xpp->xpp_namelen = name_len;
> +		xfs_init_parent_ptr(xpp, xpnr);
> +	}
> +	ppi->pi_ptrs_used = alist->al_count;
> +
> +out_kfree:
> +	kmem_free(namebuf);
> +
> +	return error;
> +}
> +
> diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
> index 9e0ac13..33e3b2c 100644
> --- a/fs/xfs/xfs_parent_utils.h
> +++ b/fs/xfs/xfs_parent_utils.h
> @@ -27,4 +27,6 @@ int xfs_parent_remove_deferred(struct xfs_inode *parent,
>  			       struct xfs_inode *child,
>  			       xfs_dir2_dataptr_t diroffset,
>  			       struct xfs_defer_ops *dfops);
> +int xfs_attr_get_parent_pointer(struct xfs_inode *ip,
> +				struct xfs_pptr_info *ppi);
>  #endif	/* __XFS_PARENT_UTILS_H__ */
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
