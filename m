Return-Path: <SRS0=5CkV=34=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27687C04EB5
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Feb 2020 04:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E97BB20715
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Feb 2020 04:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgBHEeK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 Feb 2020 23:34:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57100 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727075AbgBHEeK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Feb 2020 23:34:10 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0184HqQ7016041
        for <linux-xfs@vger.kernel.org>; Fri, 7 Feb 2020 23:34:08 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y0nruwn6e-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 07 Feb 2020 23:34:08 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sat, 8 Feb 2020 04:34:06 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 8 Feb 2020 04:34:03 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0184Y28M39322018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 8 Feb 2020 04:34:02 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8DF4AE045;
        Sat,  8 Feb 2020 04:34:02 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F0E5AE051;
        Sat,  8 Feb 2020 04:34:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.56.128])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  8 Feb 2020 04:34:01 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 14/30] xfs: remove ATTR_KERNOVAL
Date:   Sat, 08 Feb 2020 10:06:47 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-15-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-15-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20020804-0028-0000-0000-000003D89CCF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020804-0029-0000-0000-0000249D0384
Message-Id: <2586423.ZVziITvyDh@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-07_06:2020-02-07,2020-02-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=1 clxscore=1015 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002080032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:32 PM Christoph Hellwig wrote: 
> We can just pass down the Linux convention of a zero valuelen to just
> query for the existance of an attribute to the low-level code instead.
> The use in the legacy xfs_attr_list code only used by the ioctl
> interface was already dead code, as the callers check that the flag
> is not present.
>

xfs_attrlist_by_handle() allows only ATTR_ROOT and ATTR_SECURE flags. Hence
the changes look good to me.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        |  8 ++++----
>  fs/xfs/libxfs/xfs_attr.h        |  4 +---
>  fs/xfs/libxfs/xfs_attr_leaf.c   | 14 +++++++-------
>  fs/xfs/libxfs/xfs_attr_remote.c |  2 +-
>  fs/xfs/xfs_attr_list.c          |  3 ---
>  fs/xfs/xfs_xattr.c              |  4 ----
>  6 files changed, 13 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index fd095e3d4a9a..469417786bfc 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -94,9 +94,9 @@ xfs_attr_get_ilocked(
>  /*
>   * Retrieve an extended attribute by name, and its value if requested.
>   *
> - * If ATTR_KERNOVAL is set in args->flags, then the caller does not want the
> - * value, just an indication whether the attribute exists and the size of the
> - * value if it exists. The size is returned in args.valuelen.
> + * If args->valuelen is zero, then the caller does not want the value, just an
> + * indication whether the attribute exists and the size of the value if it
> + * exists. The size is returned in args.valuelen.
>   *
>   * If the attribute is found, but exceeds the size limit set by the caller in
>   * args->valuelen, return -ERANGE with the size of the attribute that was found
> @@ -115,7 +115,7 @@ xfs_attr_get(
>  	uint			lock_mode;
>  	int			error;
> 
> -	ASSERT((args->flags & (ATTR_ALLOC | ATTR_KERNOVAL)) || args->value);
> +	ASSERT((args->flags & ATTR_ALLOC) || !args->valuelen || args->value);
> 
>  	XFS_STATS_INC(args->dp->i_mount, xs_attr_get);
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index b8c4ed27f626..fe064cd81747 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -34,12 +34,11 @@ struct xfs_attr_list_context;
>  #define ATTR_REPLACE	0x0020	/* pure set: fail if attr does not exist */
> 
>  #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
> -#define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
> 
>  #define ATTR_ALLOC	0x8000	/* [kernel] allocate xattr buffer on demand */
> 
>  #define ATTR_KERNEL_FLAGS \
> -	(ATTR_KERNOTIME | ATTR_KERNOVAL | ATTR_ALLOC)
> +	(ATTR_KERNOTIME | ATTR_ALLOC)
> 
>  #define XFS_ATTR_FLAGS \
>  	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
> @@ -49,7 +48,6 @@ struct xfs_attr_list_context;
>  	{ ATTR_CREATE,		"CREATE" }, \
>  	{ ATTR_REPLACE,		"REPLACE" }, \
>  	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
> -	{ ATTR_KERNOVAL,	"KERNOVAL" }, \
>  	{ ATTR_ALLOC,		"ALLOC" }
> 
>  /*
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index fed537a4353d..5e700dfc48a9 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -464,7 +464,7 @@ xfs_attr_copy_value(
>  	/*
>  	 * No copy if all we have to do is get the length
>  	 */
> -	if (args->flags & ATTR_KERNOVAL) {
> +	if (!args->valuelen) {
>  		args->valuelen = valuelen;
>  		return 0;
>  	}
> @@ -830,9 +830,9 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
>  /*
>   * Retrieve the attribute value and length.
>   *
> - * If ATTR_KERNOVAL is specified, only the length needs to be returned.
> - * Unlike a lookup, we only return an error if the attribute does not
> - * exist or we can't retrieve the value.
> + * If args->valuelen is zero, only the length needs to be returned.  Unlike a
> + * lookup, we only return an error if the attribute does not exist or we can't
> + * retrieve the value.
>   */
>  int
>  xfs_attr_shortform_getvalue(
> @@ -2444,9 +2444,9 @@ xfs_attr3_leaf_lookup_int(
>   * Get the value associated with an attribute name from a leaf attribute
>   * list structure.
>   *
> - * If ATTR_KERNOVAL is specified, only the length needs to be returned.
> - * Unlike a lookup, we only return an error if the attribute does not
> - * exist or we can't retrieve the value.
> + * If args->valuelen is zero, only the length needs to be returned.  Unlike a
> + * lookup, we only return an error if the attribute does not exist or we can't
> + * retrieve the value.
>   */
>  int
>  xfs_attr3_leaf_getvalue(
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index a266d05df146..023ac8b85b4a 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -397,7 +397,7 @@ xfs_attr_rmtval_get(
> 
>  	trace_xfs_attr_rmtval_get(args);
> 
> -	ASSERT(!(args->flags & ATTR_KERNOVAL));
> +	ASSERT(args->valuelen != 0);
>  	ASSERT(args->rmtvaluelen == args->valuelen);
> 
>  	valuelen = args->rmtvaluelen;
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 5139ef983cd6..ac8dc64447d6 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -568,7 +568,6 @@ xfs_attr_put_listent(
>  	int arraytop;
> 
>  	ASSERT(!context->seen_enough);
> -	ASSERT(!(context->flags & ATTR_KERNOVAL));
>  	ASSERT(context->count >= 0);
>  	ASSERT(context->count < (ATTR_MAX_VALUELEN/8));
>  	ASSERT(context->firstu >= sizeof(*alist));
> @@ -637,8 +636,6 @@ xfs_attr_list(
>  	 */
>  	if (((long)buffer) & (sizeof(int)-1))
>  		return -EFAULT;
> -	if (flags & ATTR_KERNOVAL)
> -		bufsize = 0;
> 
>  	/*
>  	 * Initialize the output buffer.
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index b3ce5e8777f9..c9c44f8aebed 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -31,10 +31,6 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
>  	};
>  	int			error;
> 
> -	/* Convert Linux syscall to XFS internal ATTR flags */
> -	if (!size)
> -		args.flags |= ATTR_KERNOVAL;
> -
>  	error = xfs_attr_get(&args);
>  	if (error)
>  		return error;
> 


-- 
chandan



