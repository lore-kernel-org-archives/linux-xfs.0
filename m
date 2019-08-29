Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD9FC3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 21:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C74D21874
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 21:27:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iENQRSkT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbfH2V16 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 17:27:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34008 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbfH2V16 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 17:27:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLPMLe157133;
        Thu, 29 Aug 2019 21:27:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=k8cG45vtf5bvVxKapiCPwjg+IVYka32OZae17FMp2ek=;
 b=iENQRSkTLZJi6OvfhfKlVFDggMruSSOXcOhCXP1y5Gy1BhcdcrLE7FvZVkktuZQ72bRy
 d39cb71SpN3FK64goBQ7acQO+cOsTmYLi0vYU60xhvwWSNtWD0ZLQ8jaNla2XcyXFc0h
 XqEvJJHfNP5JqvPlpNb1jY2keRGclpxb1zCtqO1TGJ29JNLGCQosMQyL8/6w9x+va4jp
 AwV5rHRq04gVsHtHAfXipmh87BJ2c5Ccd247utqfRGy6On19wQF0KKao4R3oJA9YIKZy
 q2XTx12QM6NALP6Ow86+721ELwsszVu4PjYLR4uhr6KJeqj7On/tbNSvcVpTRJr8Yocz ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2upphkg16y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:27:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLE5iJ187390;
        Thu, 29 Aug 2019 21:27:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2upkrffv0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:27:55 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7TLRqBG001287;
        Thu, 29 Aug 2019 21:27:52 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 14:27:52 -0700
Date:   Thu, 29 Aug 2019 14:27:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: allocate xattr buffer on demand
Message-ID: <20190829212751.GR5354@magnolia>
References: <20190829113505.27223-1-david@fromorbit.com>
 <20190829113505.27223-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829113505.27223-6-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290214
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290215
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 09:35:05PM +1000, Dave Chinner wrote:
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

Looks ok, will throw this (and the dir speedup series) at the testing
machine...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c      | 42 ++++++++++++++++++++++++++++++-----
>  fs/xfs/libxfs/xfs_attr.h      |  6 +++--
>  fs/xfs/libxfs/xfs_attr_leaf.c |  6 +++++
>  fs/xfs/libxfs/xfs_da_btree.h  |  4 +++-
>  fs/xfs/xfs_acl.c              | 12 ++++------
>  fs/xfs/xfs_ioctl.c            |  2 +-
>  fs/xfs/xfs_xattr.c            |  2 +-
>  7 files changed, 55 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 4773eef9d3de..510ca6974604 100644
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
> index f6a595e76343..b9f019603d0b 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -414,6 +414,12 @@ xfs_attr_copy_value(
>  		args->valuelen = valuelen;
>  		return -ERANGE;
>  	}
> +
> +	if (args->op_flags & XFS_DA_OP_ALLOCVAL) {
> +		args->value = kmem_alloc_large(valuelen, 0);
> +		if (!args->value)
> +			return -ENOMEM;
> +	}
>  	args->valuelen = valuelen;
>  
>  	/* remote block xattr requires IO for copy-in */
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
> index 86c0697870a5..96d7071cfa46 100644
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
> @@ -135,12 +135,8 @@ xfs_get_acl(struct inode *inode, int type)
>  	 * go out to the disk.
>  	 */
>  	len = XFS_ACL_MAX_SIZE(ip->i_mount);
> -	xfs_acl = kmem_zalloc_large(len, 0);
> -	if (!xfs_acl)
> -		return ERR_PTR(-ENOMEM);
> -
> -	error = xfs_attr_get(ip, ea_name, (unsigned char *)xfs_acl,
> -							&len, ATTR_ROOT);
> +	error = xfs_attr_get(ip, ea_name, (unsigned char **)&xfs_acl, &len,
> +				ATTR_ALLOC | ATTR_ROOT);
>  	if (error) {
>  		/*
>  		 * If the attribute doesn't exist make sure we have a negative
> @@ -151,8 +147,8 @@ xfs_get_acl(struct inode *inode, int type)
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
> index 9ea51664932e..6ad63b57b6ca 100644
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
