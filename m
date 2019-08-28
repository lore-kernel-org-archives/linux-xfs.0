Return-Path: <SRS0=H+3G=WY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F83C3A5A1
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 22:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2461722DA7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 22:02:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sJwJNLWq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfH1WC4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 18:02:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44274 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbfH1WC4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Aug 2019 18:02:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SLwmEM108958;
        Wed, 28 Aug 2019 22:02:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=CtYqLEDJtnp4lbazrbQzNijCuAMYC0ErVbulMmy115w=;
 b=sJwJNLWqsYEBXoILVZz9ZxQ69DnsnKw7Rx4urglew+E5L8LmL/pR9waqE8kyy36SAC5b
 s1VZIJOMtJSF9CCzt84CeP2BborE/s3KNXc91uLd9/7R+fvtu49rMo8AXF0sxikr9+5c
 50+6+jgEO1VIfeEyk0cReWV38Y6hmMDcD+yMJI8GLfgvWw28mhhCgFW3VwKWgF8Ptp6g
 GSPYLajVfI8pDog5L4ZGKrJEflfwt1i0atGt1kZ2Ul+LwCERtvf6TTw9qpInJrFHKlq9
 ZFZ4HJjX4L+jbPBa6ogbpcD9cPMWiju7M+NlP8PIA6U3No/e+EHKHuoeCO2iiZomz96w Bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2up1yqr0xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 22:02:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SLwNfe171947;
        Wed, 28 Aug 2019 22:00:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2unvtxx20p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 22:00:51 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7SM0o7i022711;
        Wed, 28 Aug 2019 22:00:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Aug 2019 15:00:50 -0700
Date:   Wed, 28 Aug 2019 15:00:49 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: allocate xattr buffer on demand
Message-ID: <20190828220049.GI1037350@magnolia>
References: <20190828042350.6062-1-david@fromorbit.com>
 <20190828042350.6062-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828042350.6062-4-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908280211
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908280211
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 28, 2019 at 02:23:50PM +1000, Dave Chinner wrote:
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

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c      | 42 +++++++++++++---
>  fs/xfs/libxfs/xfs_attr.h      |  6 ++-
>  fs/xfs/libxfs/xfs_attr_leaf.c | 95 +++++++++++++++++++++--------------
>  fs/xfs/libxfs/xfs_da_btree.h  |  4 +-
>  fs/xfs/xfs_acl.c              | 16 ++----
>  fs/xfs/xfs_ioctl.c            |  2 +-
>  fs/xfs/xfs_xattr.c            |  2 +-
>  7 files changed, 105 insertions(+), 62 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 5e6b6846e607..99f9e0cf05a6 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -118,12 +118,28 @@ xfs_attr_get_ilocked(
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
> @@ -131,6 +147,8 @@ xfs_attr_get(
>  	uint			lock_mode;
>  	int			error;
>  
> +	ASSERT((flags & (ATTR_ALLOC | ATTR_KERNOVAL)) || *value);
> +
>  	XFS_STATS_INC(ip->i_mount, xs_attr_get);
>  
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
> @@ -140,17 +158,29 @@ xfs_attr_get(
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
> -
>  	*valuelenp = args.valuelen;
> -	return error;
> +
> +	/* on error, we have to clean up allocated value buffers */
> +	if (error) {
> +		if (flags & ATTR_ALLOC) {
> +			kmem_free(args.value);
> +			*value = NULL;
> +		}
> +		return error;
> +	}
> +	*value = args.value;
> +	return 0;
>  }
>  
>  /*
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
> index e325cdbc9818..fe3c164d5cfe 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -393,6 +393,51 @@ xfs_attr_namesp_match(int arg_flags, int ondisk_flags)
>  	return XFS_ATTR_NSP_ONDISK(ondisk_flags) == XFS_ATTR_NSP_ARGS_TO_ONDISK(arg_flags);
>  }
>  
> +static int
> +xfs_attr_copy_value(
> +	struct xfs_da_args	*args,
> +	unsigned char		*value,
> +	int			valuelen)
> +{
> +	/*
> +	 * No copy if all we have to do is get the length
> +	 */
> +	if (args->flags & ATTR_KERNOVAL) {
> +		args->valuelen = valuelen;
> +		return 0;
> +	}
> +
> +	/*
> +	 * No copy if the length of the existing buffer is too small
> +	 */
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
> @@ -727,11 +772,12 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
>   * exist or we can't retrieve the value.
>   */
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
> +	int			i;
>  
>  	ASSERT(args->dp->i_afp->if_flags == XFS_IFINLINE);
>  	sf = (xfs_attr_shortform_t *)args->dp->i_afp->if_u1.if_data;
> @@ -744,18 +790,8 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
>  			continue;
>  		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
>  			continue;
> -		if (args->flags & ATTR_KERNOVAL) {
> -			args->valuelen = sfe->valuelen;
> -			return 0;
> -		}
> -		if (args->valuelen < sfe->valuelen) {
> -			args->valuelen = sfe->valuelen;
> -			return -ERANGE;
> -		}
> -		args->valuelen = sfe->valuelen;
> -		memcpy(args->value, &sfe->nameval[args->namelen],
> -						    args->valuelen);
> -		return 0;
> +		return xfs_attr_copy_value(args, &sfe->nameval[args->namelen],
> +						sfe->valuelen);
>  	}
>  	return -ENOATTR;
>  }
> @@ -2368,7 +2404,6 @@ xfs_attr3_leaf_getvalue(
>  	struct xfs_attr_leaf_entry *entry;
>  	struct xfs_attr_leaf_name_local *name_loc;
>  	struct xfs_attr_leaf_name_remote *name_rmt;
> -	int			valuelen;
>  
>  	leaf = bp->b_addr;
>  	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
> @@ -2380,18 +2415,9 @@ xfs_attr3_leaf_getvalue(
>  		name_loc = xfs_attr3_leaf_name_local(leaf, args->index);
>  		ASSERT(name_loc->namelen == args->namelen);
>  		ASSERT(memcmp(args->name, name_loc->nameval, args->namelen) == 0);
> -		valuelen = be16_to_cpu(name_loc->valuelen);
> -		if (args->flags & ATTR_KERNOVAL) {
> -			args->valuelen = valuelen;
> -			return 0;
> -		}
> -		if (args->valuelen < valuelen) {
> -			args->valuelen = valuelen;
> -			return -ERANGE;
> -		}
> -		args->valuelen = valuelen;
> -		memcpy(args->value, &name_loc->nameval[args->namelen], valuelen);
> -		return 0;
> +		return xfs_attr_copy_value(args,
> +					&name_loc->nameval[args->namelen],
> +					be16_to_cpu(name_loc->valuelen));
>  	}
>  
>  	name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
> @@ -2401,16 +2427,7 @@ xfs_attr3_leaf_getvalue(
>  	args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
>  	args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
>  					       args->rmtvaluelen);
> -	if (args->flags & ATTR_KERNOVAL) {
> -		args->valuelen = args->rmtvaluelen;
> -		return 0;
> -	}
> -	if (args->valuelen < args->rmtvaluelen) {
> -		args->valuelen = args->rmtvaluelen;
> -		return -ERANGE;
> -	}
> -	args->valuelen = args->rmtvaluelen;
> -	return xfs_attr_rmtval_get(args);
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
