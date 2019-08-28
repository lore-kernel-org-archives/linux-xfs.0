Return-Path: <SRS0=H+3G=WY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FACC3A5A3
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 01:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A4842173E
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 01:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfH1BBr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 21:01:47 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45440 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726092AbfH1BBr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 21:01:47 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CA6CD36153C
        for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2019 11:01:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2mLF-0002Bj-37
        for linux-xfs@vger.kernel.org; Wed, 28 Aug 2019 11:01:41 +1000
Date:   Wed, 28 Aug 2019 11:01:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: allocate xattr buffer on demand
Message-ID: <20190828010141.GK1119@dread.disaster.area>
References: <20190828001845.13945-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828001845.13945-1-david@fromorbit.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=ewu6-xTRCns7g4R5_oQA:9
        a=Ouet5EjUZWUsO8d_:21 a=xYJJL4_q7gEYUGU6:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Ignore this for now. Turns out fstests doesn't appear to exercise
leaf form attribute forks on v5 filesystems. A v4 filesystem let the
smoke out in generic/318 because the 88 byte acl doesn't fit in the
inode....

Cheers,

Dave.

On Wed, Aug 28, 2019 at 10:18:45AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When doing file lookups and checking for permissions, we end up in
> xfs_get_acl() to see if there are any ACLs on the inode. This
> requires and xattr lookup, and to do that we have to supply a buffer
> large enough to hold an maximum sized xattr.
> 
> On workloads were we are accessing a wide range of cache cold files
> under memory pressure (e.g. NFS fileservers) we end up spending a
> lot of time allocating the buffer. The buffer is 64k in length, so
> is a contiguous multi-page allocation, and if that then fails we
> fall back to vmalloc(). Hence the allocation here is /expensive/
> when we are looking up hundreds of thousands of files a second.
> 
> Initial numbers from a bpf trace show average time in xfs_get_acl()
> is ~32us, with ~19us of that in the memory allocation. Note these
> are average times, so there are going to be affected by the worst
> case allocations more than the common fast case...
> 
> To avoid this, we could just do a "null"  lookup to see if the ACL
> xattr exists and then only do the allocation if it exists. This,
> however, optimises the path for the "no ACL present" case at the
> expense of the "acl present" case. i.e. we can halve the time in
> xfs_get_acl() for the no acl case (i.e down to ~10-15us), but that
> then increases the ACL case by 30% (i.e. up to 40-45us).
> 
> To solve this and speed up both cases, drive the xattr buffer
> allocation into the attribute code once we know what the actual
> xattr length is. For the no-xattr case, we avoid the allocation
> completely, speeding up that case. For the common ACL case, we'll
> end up with a fast heap allocation (because it'll be smaller than a
> page), and only for the rarer "we have a remote xattr" will we have
> a multi-page allocation occur. Hence the common ACL case will be
> much faster, too.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 51 +++++++++++++------
>  fs/xfs/libxfs/xfs_attr.h      |  6 ++-
>  fs/xfs/libxfs/xfs_attr_leaf.c | 93 ++++++++++++++++++++++-------------
>  fs/xfs/libxfs/xfs_da_btree.h  |  4 +-
>  fs/xfs/xfs_acl.c              | 16 ++----
>  fs/xfs/xfs_ioctl.c            |  2 +-
>  fs/xfs/xfs_xattr.c            |  2 +-
>  7 files changed, 107 insertions(+), 67 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d48fcf11cc35..875b35b373cb 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -115,12 +115,28 @@ xfs_attr_get_ilocked(
>  		return xfs_attr_node_get(args);
>  }
>  
> -/* Retrieve an extended attribute by name, and its value. */
> +/*
> + * Retrieve an extended attribute by name, and its value if requested.
> + *
> + * If ATTR_KERNOVAL is set in @flags, then the caller does not want the value,
> + * just an indication whether the attribute exists and the size of the value if
> + * it exists. The size is returned in @valuelenp,
> + *
> + * If the attribute is found, but exceeds the size limit set by the caller in
> + * @valuelenp, return -ERANGE with the size of the attribute that was found in
> + * @valuelenp.
> + *
> + * If ATTR_ALLOC is set in @flags, allocate the buffer for the value after
> + * existence of the attribute has been determined. On success, return that
> + * buffer to the caller and leave them to free it. On failure, free any
> + * allocated buffer and ensure the buffer pointer returned to the caller is
> + * null.
> + */
>  int
>  xfs_attr_get(
>  	struct xfs_inode	*ip,
>  	const unsigned char	*name,
> -	unsigned char		*value,
> +	unsigned char		**value,
>  	int			*valuelenp,
>  	int			flags)
>  {
> @@ -128,6 +144,8 @@ xfs_attr_get(
>  	uint			lock_mode;
>  	int			error;
>  
> +	ASSERT((flags & (ATTR_ALLOC | ATTR_KERNOVAL)) || *value);
> +
>  	XFS_STATS_INC(ip->i_mount, xs_attr_get);
>  
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
> @@ -137,17 +155,29 @@ xfs_attr_get(
>  	if (error)
>  		return error;
>  
> -	args.value = value;
> -	args.valuelen = *valuelenp;
>  	/* Entirely possible to look up a name which doesn't exist */
>  	args.op_flags = XFS_DA_OP_OKNOENT;
> +	if (flags & ATTR_ALLOC)
> +		args.op_flags |= XFS_DA_OP_ALLOCVAL;
> +	else
> +		args.value = *value;
> +	args.valuelen = *valuelenp;
>  
>  	lock_mode = xfs_ilock_attr_map_shared(ip);
>  	error = xfs_attr_get_ilocked(ip, &args);
>  	xfs_iunlock(ip, lock_mode);
>  
>  	*valuelenp = args.valuelen;
> -	return error == -EEXIST ? 0 : error;
> +	if (error == -EEXIST) {
> +		*value = args.value;
> +		return 0;
> +	}
> +
> +	if (flags & ATTR_ALLOC) {
> +		kmem_free(args.value);
> +		*value = NULL;
> +	}
> +	return error;
>  }
>  
>  /*
> @@ -789,9 +819,6 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>  	}
>  	error = xfs_attr3_leaf_getvalue(bp, args);
>  	xfs_trans_brelse(args->trans, bp);
> -	if (!error && (args->rmtblkno > 0) && !(args->flags & ATTR_KERNOVAL)) {
> -		error = xfs_attr_rmtval_get(args);
> -	}
>  	return error;
>  }
>  
> @@ -1298,15 +1325,7 @@ xfs_attr_node_get(xfs_da_args_t *args)
>  		blk = &state->path.blk[ state->path.active-1 ];
>  		ASSERT(blk->bp != NULL);
>  		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -
> -		/*
> -		 * Get the value, local or "remote"
> -		 */
>  		retval = xfs_attr3_leaf_getvalue(blk->bp, args);
> -		if (!retval && (args->rmtblkno > 0)
> -		    && !(args->flags & ATTR_KERNOVAL)) {
> -			retval = xfs_attr_rmtval_get(args);
> -		}
>  	}
>  
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index ff28ebf3b635..94badfa1743e 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -37,6 +37,7 @@ struct xfs_attr_list_context;
>  #define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
>  
>  #define ATTR_INCOMPLETE	0x4000	/* [kernel] return INCOMPLETE attr keys */
> +#define ATTR_ALLOC	0x8000	/* allocate xattr buffer on demand */
>  
>  #define XFS_ATTR_FLAGS \
>  	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
> @@ -47,7 +48,8 @@ struct xfs_attr_list_context;
>  	{ ATTR_REPLACE,		"REPLACE" }, \
>  	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
>  	{ ATTR_KERNOVAL,	"KERNOVAL" }, \
> -	{ ATTR_INCOMPLETE,	"INCOMPLETE" }
> +	{ ATTR_INCOMPLETE,	"INCOMPLETE" }, \
> +	{ ATTR_ALLOC,		"ALLOC" }
>  
>  /*
>   * The maximum size (into the kernel or returned from the kernel) of an
> @@ -143,7 +145,7 @@ int xfs_attr_list_int(struct xfs_attr_list_context *);
>  int xfs_inode_hasattr(struct xfs_inode *ip);
>  int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
>  int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
> -		 unsigned char *value, int *valuelenp, int flags);
> +		 unsigned char **value, int *valuelenp, int flags);
>  int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
>  		 unsigned char *value, int valuelen, int flags);
>  int xfs_attr_set_args(struct xfs_da_args *args);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 70eb941d02e4..dc5f45d2f6af 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -393,6 +393,40 @@ xfs_attr_namesp_match(int arg_flags, int ondisk_flags)
>  	return XFS_ATTR_NSP_ONDISK(ondisk_flags) == XFS_ATTR_NSP_ARGS_TO_ONDISK(arg_flags);
>  }
>  
> +static int
> +xfs_attr_copy_value(
> +	struct xfs_da_args	*args,
> +	unsigned char		*value,
> +	int			valuelen)
> +{
> +	if (args->valuelen < valuelen) {
> +		args->valuelen = valuelen;
> +		return -ERANGE;
> +	}
> +
> +	if (args->op_flags & XFS_DA_OP_ALLOCVAL) {
> +		args->value = kmem_alloc_large(valuelen, KM_SLEEP);
> +		if (!args->value)
> +			return -ENOMEM;
> +	}
> +	args->valuelen = valuelen;
> +
> +	/* remote block xattr requires IO for copy-in */
> +	if (args->rmtblkno)
> +		return xfs_attr_rmtval_get(args);
> +
> +	/*
> +	 * This is to prevent a GCC warning because the remote xattr case
> +	 * doesn't have a value to pass in. In that case, we never reach here,
> +	 * but GCC can't work that out and so throws a "passing NULL to
> +	 * memcpy" warning.
> +	 */
> +	if (!value)
> +		return -EINVAL;
> +	memcpy(args->value, value, valuelen);
> +	return 0;
> +}
> +
>  
>  /*========================================================================
>   * External routines when attribute fork size < XFS_LITINO(mp).
> @@ -724,11 +758,13 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
>   */
>  /*ARGSUSED*/
>  int
> -xfs_attr_shortform_getvalue(xfs_da_args_t *args)
> +xfs_attr_shortform_getvalue(
> +	struct xfs_da_args	*args)
>  {
> -	xfs_attr_shortform_t *sf;
> -	xfs_attr_sf_entry_t *sfe;
> -	int i;
> +	struct xfs_attr_shortform *sf;
> +	struct xfs_attr_sf_entry *sfe;
> +	int			error;
> +	int			i;
>  
>  	ASSERT(args->dp->i_afp->if_flags == XFS_IFINLINE);
>  	sf = (xfs_attr_shortform_t *)args->dp->i_afp->if_u1.if_data;
> @@ -745,13 +781,10 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
>  			args->valuelen = sfe->valuelen;
>  			return -EEXIST;
>  		}
> -		if (args->valuelen < sfe->valuelen) {
> -			args->valuelen = sfe->valuelen;
> -			return -ERANGE;
> -		}
> -		args->valuelen = sfe->valuelen;
> -		memcpy(args->value, &sfe->nameval[args->namelen],
> -						    args->valuelen);
> +		error = xfs_attr_copy_value(args, &sfe->nameval[args->namelen],
> +						sfe->valuelen);
> +		if (error)
> +			return error;
>  		return -EEXIST;
>  	}
>  	return -ENOATTR;
> @@ -2378,31 +2411,23 @@ xfs_attr3_leaf_getvalue(
>  			args->valuelen = valuelen;
>  			return 0;
>  		}
> -		if (args->valuelen < valuelen) {
> -			args->valuelen = valuelen;
> -			return -ERANGE;
> -		}
> -		args->valuelen = valuelen;
> -		memcpy(args->value, &name_loc->nameval[args->namelen], valuelen);
> -	} else {
> -		name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
> -		ASSERT(name_rmt->namelen == args->namelen);
> -		ASSERT(memcmp(args->name, name_rmt->name, args->namelen) == 0);
> -		args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
> -		args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
> -		args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
> -						       args->rmtvaluelen);
> -		if (args->flags & ATTR_KERNOVAL) {
> -			args->valuelen = args->rmtvaluelen;
> -			return 0;
> -		}
> -		if (args->valuelen < args->rmtvaluelen) {
> -			args->valuelen = args->rmtvaluelen;
> -			return -ERANGE;
> -		}
> +		return xfs_attr_copy_value(args,
> +					&name_loc->nameval[args->namelen],
> +					valuelen);
> +	}
> +
> +	name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
> +	ASSERT(name_rmt->namelen == args->namelen);
> +	ASSERT(memcmp(args->name, name_rmt->name, args->namelen) == 0);
> +	args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
> +	args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
> +	args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
> +					       args->rmtvaluelen);
> +	if (args->flags & ATTR_KERNOVAL) {
>  		args->valuelen = args->rmtvaluelen;
> +		return 0;
>  	}
> -	return 0;
> +	return xfs_attr_copy_value(args, NULL, args->rmtvaluelen);
>  }
>  
>  /*========================================================================
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 84dd865b6c3d..ae0bbd20d9ca 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -81,13 +81,15 @@ typedef struct xfs_da_args {
>  #define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
>  #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
>  #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
> +#define XFS_DA_OP_ALLOCVAL	0x0020	/* lookup to alloc buffer if found  */
>  
>  #define XFS_DA_OP_FLAGS \
>  	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
>  	{ XFS_DA_OP_RENAME,	"RENAME" }, \
>  	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
>  	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
> -	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }
> +	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
> +	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }
>  
>  /*
>   * Storage for holding state during Btree searches and split/join ops.
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index cbda40d40326..78c5e590b771 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -112,7 +112,7 @@ xfs_get_acl(struct inode *inode, int type)
>  {
>  	struct xfs_inode *ip = XFS_I(inode);
>  	struct posix_acl *acl = NULL;
> -	struct xfs_acl *xfs_acl;
> +	struct xfs_acl *xfs_acl = NULL;
>  	unsigned char *ea_name;
>  	int error;
>  	int len;
> @@ -130,17 +130,9 @@ xfs_get_acl(struct inode *inode, int type)
>  		BUG();
>  	}
>  
> -	/*
> -	 * If we have a cached ACLs value just return it, not need to
> -	 * go out to the disk.
> -	 */
>  	len = XFS_ACL_MAX_SIZE(ip->i_mount);
> -	xfs_acl = kmem_zalloc_large(len, KM_SLEEP);
> -	if (!xfs_acl)
> -		return ERR_PTR(-ENOMEM);
> -
> -	error = xfs_attr_get(ip, ea_name, (unsigned char *)xfs_acl,
> -							&len, ATTR_ROOT);
> +	error = xfs_attr_get(ip, ea_name, (unsigned char **)&xfs_acl, &len,
> +				ATTR_ALLOC|ATTR_ROOT);
>  	if (error) {
>  		/*
>  		 * If the attribute doesn't exist make sure we have a negative
> @@ -151,8 +143,8 @@ xfs_get_acl(struct inode *inode, int type)
>  	} else  {
>  		acl = xfs_acl_from_disk(xfs_acl, len,
>  					XFS_ACL_MAX_ENTRIES(ip->i_mount));
> +		kmem_free(xfs_acl);
>  	}
> -	kmem_free(xfs_acl);
>  	return acl;
>  }
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6f7848cd5527..5f73feb40384 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -438,7 +438,7 @@ xfs_attrmulti_attr_get(
>  	if (!kbuf)
>  		return -ENOMEM;
>  
> -	error = xfs_attr_get(XFS_I(inode), name, kbuf, (int *)len, flags);
> +	error = xfs_attr_get(XFS_I(inode), name, &kbuf, (int *)len, flags);
>  	if (error)
>  		goto out_kfree;
>  
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 3123b5aaad2a..cb895b1df5e4 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -30,7 +30,7 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
>  		value = NULL;
>  	}
>  
> -	error = xfs_attr_get(ip, (unsigned char *)name, value, &asize, xflags);
> +	error = xfs_attr_get(ip, name, (unsigned char **)&value, &asize, xflags);
>  	if (error)
>  		return error;
>  	return asize;
> -- 
> 2.23.0.rc1
> 
> 

-- 
Dave Chinner
david@fromorbit.com
