Return-Path: <SRS0=5CkV=34=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2374C04EB5
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Feb 2020 05:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BCA720715
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Feb 2020 05:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgBHFKi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Feb 2020 00:10:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34932 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725789AbgBHFKh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Feb 2020 00:10:37 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01856YEQ031914
        for <linux-xfs@vger.kernel.org>; Sat, 8 Feb 2020 00:10:37 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y0nngxxc9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sat, 08 Feb 2020 00:10:36 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sat, 8 Feb 2020 05:10:34 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 8 Feb 2020 05:10:31 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0185AVZu48037936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 8 Feb 2020 05:10:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00A6F42047;
        Sat,  8 Feb 2020 05:10:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A8FA4203F;
        Sat,  8 Feb 2020 05:10:30 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.56.128])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  8 Feb 2020 05:10:29 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 15/30] xfs: remove ATTR_ALLOC and XFS_DA_OP_ALLOCVAL
Date:   Sat, 08 Feb 2020 10:43:16 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-16-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-16-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20020805-0016-0000-0000-000002E4E550
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020805-0017-0000-0000-00003347D1B4
Message-Id: <12857653.2P3B7MtEj7@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-07_06:2020-02-07,2020-02-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 bulkscore=0 suspectscore=7 spamscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002080040
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:32 PM Christoph Hellwig wrote: 
> Use a NULL args->value as the indicator to lazily allocate a buffer
> instead, and let the caller always free args->value instead of
> duplicating the cleanup.

xfs_get_acl() now unconditionally invokes kmem_free() on args.value. This
matches the requirement set by xfs_attr_get().

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 20 +++++---------------
>  fs/xfs/libxfs/xfs_attr.h      |  7 ++-----
>  fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
>  fs/xfs/libxfs/xfs_types.h     |  2 --
>  fs/xfs/xfs_acl.c              | 20 ++++++++++----------
>  5 files changed, 18 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 469417786bfc..1382e51ef85e 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -98,15 +98,14 @@ xfs_attr_get_ilocked(
>   * indication whether the attribute exists and the size of the value if it
>   * exists. The size is returned in args.valuelen.
>   *
> + * If args->value is NULL but args->valuelen is non-zero, allocate the buffer
> + * for the value after existence of the attribute has been determined. The
> + * caller always has to free args->value if it is set, no matter if this
> + * function was successful or not.
> + *
>   * If the attribute is found, but exceeds the size limit set by the caller in
>   * args->valuelen, return -ERANGE with the size of the attribute that was found
>   * in args->valuelen.
> - *
> - * If ATTR_ALLOC is set in args->flags, allocate the buffer for the value after
> - * existence of the attribute has been determined. On success, return that
> - * buffer to the caller and leave them to free it. On failure, free any
> - * allocated buffer and ensure the buffer pointer returned to the caller is
> - * null.
>   */
>  int
>  xfs_attr_get(
> @@ -115,8 +114,6 @@ xfs_attr_get(
>  	uint			lock_mode;
>  	int			error;
> 
> -	ASSERT((args->flags & ATTR_ALLOC) || !args->valuelen || args->value);
> -
>  	XFS_STATS_INC(args->dp->i_mount, xs_attr_get);
> 
>  	if (XFS_FORCED_SHUTDOWN(args->dp->i_mount))
> @@ -128,18 +125,11 @@ xfs_attr_get(
> 
>  	/* Entirely possible to look up a name which doesn't exist */
>  	args->op_flags = XFS_DA_OP_OKNOENT;
> -	if (args->flags & ATTR_ALLOC)
> -		args->op_flags |= XFS_DA_OP_ALLOCVAL;
> 
>  	lock_mode = xfs_ilock_attr_map_shared(args->dp);
>  	error = xfs_attr_get_ilocked(args);
>  	xfs_iunlock(args->dp, lock_mode);
> 
> -	/* on error, we have to clean up allocated value buffers */
> -	if (error && (args->flags & ATTR_ALLOC)) {
> -		kmem_free(args->value);
> -		args->value = NULL;
> -	}
>  	return error;
>  }
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index fe064cd81747..a6de050675c9 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -35,10 +35,8 @@ struct xfs_attr_list_context;
> 
>  #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
> 
> -#define ATTR_ALLOC	0x8000	/* [kernel] allocate xattr buffer on demand */
> -
>  #define ATTR_KERNEL_FLAGS \
> -	(ATTR_KERNOTIME | ATTR_ALLOC)
> +	(ATTR_KERNOTIME)
> 
>  #define XFS_ATTR_FLAGS \
>  	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
> @@ -47,8 +45,7 @@ struct xfs_attr_list_context;
>  	{ ATTR_SECURE,		"SECURE" }, \
>  	{ ATTR_CREATE,		"CREATE" }, \
>  	{ ATTR_REPLACE,		"REPLACE" }, \
> -	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
> -	{ ATTR_ALLOC,		"ALLOC" }
> +	{ ATTR_KERNOTIME,	"KERNOTIME" }
> 
>  /*
>   * The maximum size (into the kernel or returned from the kernel) of an
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 5e700dfc48a9..b0658eb8fbcc 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -477,7 +477,7 @@ xfs_attr_copy_value(
>  		return -ERANGE;
>  	}
> 
> -	if (args->op_flags & XFS_DA_OP_ALLOCVAL) {
> +	if (!args->value) {
>  		args->value = kmem_alloc_large(valuelen, 0);
>  		if (!args->value)
>  			return -ENOMEM;
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 634814dd1d10..3379ebc0c7c5 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -223,7 +223,6 @@ typedef struct xfs_da_args {
>  #define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
>  #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
>  #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
> -#define XFS_DA_OP_ALLOCVAL	0x0020	/* lookup to alloc buffer if found  */
>  #define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
> 
>  #define XFS_DA_OP_FLAGS \
> @@ -232,7 +231,6 @@ typedef struct xfs_da_args {
>  	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
>  	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
>  	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
> -	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }, \
>  	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
> 
>  /*
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 780924984492..bc78b7c33401 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -125,7 +125,7 @@ xfs_get_acl(struct inode *inode, int type)
>  	struct posix_acl	*acl = NULL;
>  	struct xfs_da_args	args = {
>  		.dp		= ip,
> -		.flags		= ATTR_ALLOC | ATTR_ROOT,
> +		.flags		= ATTR_ROOT,
>  		.valuelen	= XFS_ACL_MAX_SIZE(mp),
>  	};
>  	int			error;
> @@ -144,19 +144,19 @@ xfs_get_acl(struct inode *inode, int type)
>  	}
>  	args.namelen = strlen(args.name);
> 
> +	/*
> +	 * If the attribute doesn't exist make sure we have a negative cache
> +	 * entry, for any other error assume it is transient.
> +	 */
>  	error = xfs_attr_get(&args);
> -	if (error) {
> -		/*
> -		 * If the attribute doesn't exist make sure we have a negative
> -		 * cache entry, for any other error assume it is transient.
> -		 */
> -		if (error != -ENOATTR)
> -			acl = ERR_PTR(error);
> -	} else  {
> +	if (!error) {
>  		acl = xfs_acl_from_disk(mp, args.value, args.valuelen,
>  					XFS_ACL_MAX_ENTRIES(mp));
> -		kmem_free(args.value);
> +	} else if (error != -ENOATTR) {
> +		acl = ERR_PTR(error);
>  	}
> +
> +	kmem_free(args.value);
>  	return acl;
>  }
> 
> 


-- 
chandan



