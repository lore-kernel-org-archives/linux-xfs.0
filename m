Return-Path: <SRS0=yyqk=36=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3373C352A3
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 14:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8624C20658
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 14:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgBJOyv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Feb 2020 09:54:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42480 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727570AbgBJOyv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Feb 2020 09:54:51 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01AEoIUq086680
        for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2020 09:54:49 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y1u9p1sv8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2020 09:54:49 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 10 Feb 2020 14:54:47 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 10 Feb 2020 14:54:44 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01AEshUa12189850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 14:54:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2918A4040;
        Mon, 10 Feb 2020 14:54:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92071A405D;
        Mon, 10 Feb 2020 14:54:42 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.94.7])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Feb 2020 14:54:42 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 30/30] xfs: embedded the attrlist cursor into struct xfs_attr_list_context
Date:   Mon, 10 Feb 2020 20:27:29 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-31-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-31-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20021014-0020-0000-0000-000003A8D4F0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021014-0021-0000-0000-00002200B013
Message-Id: <41617252.So8b1D6agH@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-10_04:2020-02-10,2020-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=5 clxscore=1015 mlxlogscore=999 mlxscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002100115
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:33 PM Christoph Hellwig wrote: 
> The attrlist cursor only exists as part of an attr list context, so
> embedd the structure instead of pointing to it.  Also give it a proper
> xfs_ prefix and remove the obsolete typedef.
>

The changes look good to me.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.h      |  6 +++---
>  fs/xfs/libxfs/xfs_attr_leaf.h |  1 -
>  fs/xfs/scrub/attr.c           |  2 --
>  fs/xfs/xfs_attr_list.c        | 19 ++++++-------------
>  fs/xfs/xfs_ioctl.c            | 16 +++++++---------
>  fs/xfs/xfs_ioctl.h            |  1 -
>  fs/xfs/xfs_trace.h            | 12 ++++++------
>  fs/xfs/xfs_xattr.c            |  2 --
>  8 files changed, 22 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 7a3525dff411..861c81f9bb91 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -31,14 +31,14 @@ struct xfs_attr_list_context;
>  /*
>   * Kernel-internal version of the attrlist cursor.
>   */
> -typedef struct attrlist_cursor_kern {
> +struct xfs_attrlist_cursor_kern {
>  	__u32	hashval;	/* hash value of next entry to add */
>  	__u32	blkno;		/* block containing entry (suggestion) */
>  	__u32	offset;		/* offset in list of equal-hashvals */
>  	__u16	pad1;		/* padding to match user-level */
>  	__u8	pad2;		/* padding to match user-level */
>  	__u8	initted;	/* T/F: cursor has been initialized */
> -} attrlist_cursor_kern_t;
> +};
> 
> 
>  /*========================================================================
> @@ -53,7 +53,7 @@ typedef void (*put_listent_func_t)(struct xfs_attr_list_context *, int,
>  struct xfs_attr_list_context {
>  	struct xfs_trans	*tp;
>  	struct xfs_inode	*dp;		/* inode */
> -	struct attrlist_cursor_kern *cursor;	/* position in list */
> +	struct xfs_attrlist_cursor_kern cursor;	/* position in list */
>  	void			*buffer;	/* output buffer */
> 
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index 73615b1dd1a8..6dd2d937a42a 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -8,7 +8,6 @@
>  #define	__XFS_ATTR_LEAF_H__
> 
>  struct attrlist;
> -struct attrlist_cursor_kern;
>  struct xfs_attr_list_context;
>  struct xfs_da_args;
>  struct xfs_da_state;
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index d84237af5455..6dd3f5f78251 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -471,7 +471,6 @@ xchk_xattr(
>  	struct xfs_scrub		*sc)
>  {
>  	struct xchk_xattr		sx;
> -	struct attrlist_cursor_kern	cursor = { 0 };
>  	xfs_dablk_t			last_checked = -1U;
>  	int				error = 0;
> 
> @@ -490,7 +489,6 @@ xchk_xattr(
> 
>  	/* Check that every attr key can also be looked up by hash. */
>  	sx.context.dp = sc->ip;
> -	sx.context.cursor = &cursor;
>  	sx.context.resynch = 1;
>  	sx.context.put_listent = xchk_xattr_listent;
>  	sx.context.tp = sc->tp;
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index ea79219859a0..6af71edaa30e 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -52,24 +52,19 @@ static int
>  xfs_attr_shortform_list(
>  	struct xfs_attr_list_context	*context)
>  {
> -	struct attrlist_cursor_kern	*cursor;
> +	struct xfs_attrlist_cursor_kern	*cursor = &context->cursor;
> +	struct xfs_inode		*dp = context->dp;
>  	struct xfs_attr_sf_sort		*sbuf, *sbp;
>  	struct xfs_attr_shortform	*sf;
>  	struct xfs_attr_sf_entry	*sfe;
> -	struct xfs_inode		*dp;
>  	int				sbsize, nsbuf, count, i;
>  	int				error = 0;
> 
> -	ASSERT(context != NULL);
> -	dp = context->dp;
> -	ASSERT(dp != NULL);
>  	ASSERT(dp->i_afp != NULL);
>  	sf = (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
>  	ASSERT(sf != NULL);
>  	if (!sf->hdr.count)
>  		return 0;
> -	cursor = context->cursor;
> -	ASSERT(cursor != NULL);
> 
>  	trace_xfs_attr_list_sf(context);
> 
> @@ -205,7 +200,7 @@ xfs_attr_shortform_list(
>  STATIC int
>  xfs_attr_node_list_lookup(
>  	struct xfs_attr_list_context	*context,
> -	struct attrlist_cursor_kern	*cursor,
> +	struct xfs_attrlist_cursor_kern	*cursor,
>  	struct xfs_buf			**pbp)
>  {
>  	struct xfs_da3_icnode_hdr	nodehdr;
> @@ -288,8 +283,8 @@ STATIC int
>  xfs_attr_node_list(
>  	struct xfs_attr_list_context	*context)
>  {
> +	struct xfs_attrlist_cursor_kern	*cursor = &context->cursor;
>  	struct xfs_attr3_icleaf_hdr	leafhdr;
> -	struct attrlist_cursor_kern	*cursor;
>  	struct xfs_attr_leafblock	*leaf;
>  	struct xfs_da_intnode		*node;
>  	struct xfs_buf			*bp;
> @@ -299,7 +294,6 @@ xfs_attr_node_list(
> 
>  	trace_xfs_attr_node_list(context);
> 
> -	cursor = context->cursor;
>  	cursor->initted = 1;
> 
>  	/*
> @@ -394,7 +388,7 @@ xfs_attr3_leaf_list_int(
>  	struct xfs_buf			*bp,
>  	struct xfs_attr_list_context	*context)
>  {
> -	struct attrlist_cursor_kern	*cursor;
> +	struct xfs_attrlist_cursor_kern	*cursor = &context->cursor;
>  	struct xfs_attr_leafblock	*leaf;
>  	struct xfs_attr3_icleaf_hdr	ichdr;
>  	struct xfs_attr_leaf_entry	*entries;
> @@ -408,7 +402,6 @@ xfs_attr3_leaf_list_int(
>  	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
>  	entries = xfs_attr3_leaf_entryp(leaf);
> 
> -	cursor = context->cursor;
>  	cursor->initted = 1;
> 
>  	/*
> @@ -496,7 +489,7 @@ xfs_attr_leaf_list(
> 
>  	trace_xfs_attr_leaf_list(context);
> 
> -	context->cursor->blkno = 0;
> +	context->cursor.blkno = 0;
>  	error = xfs_attr3_leaf_read(context->tp, context->dp, 0, &bp);
>  	if (error)
>  		return error;
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d2318857497b..2e8e86d5c01c 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -374,8 +374,7 @@ xfs_ioc_attr_list(
>  	int				flags,
>  	struct xfs_attrlist_cursor __user *ucursor)
>  {
> -	struct xfs_attr_list_context	context;
> -	struct attrlist_cursor_kern	cursor;
> +	struct xfs_attr_list_context	context = { 0 };
>  	struct xfs_attrlist		*alist;
>  	void				*buffer;
>  	int				error;
> @@ -395,12 +394,13 @@ xfs_ioc_attr_list(
>  	/*
>  	 * Validate the cursor.
>  	 */
> -	if (copy_from_user(&cursor, ucursor, sizeof(cursor)))
> +	if (copy_from_user(&context.cursor, ucursor, sizeof(context.cursor)))
>  		return -EFAULT;
> -	if (cursor.pad1 || cursor.pad2)
> +	if (context.cursor.pad1 || context.cursor.pad2)
>  		return -EINVAL;
> -	if ((cursor.initted == 0) &&
> -	    (cursor.hashval || cursor.blkno || cursor.offset))
> +	if (!context.cursor.initted &&
> +	    (context.cursor.hashval || context.cursor.blkno ||
> +	     context.cursor.offset))
>  		return -EINVAL;
> 
>  	buffer = kmem_zalloc_large(bufsize, 0);
> @@ -410,9 +410,7 @@ xfs_ioc_attr_list(
>  	/*
>  	 * Initialize the output buffer.
>  	 */
> -	memset(&context, 0, sizeof(context));
>  	context.dp = dp;
> -	context.cursor = &cursor;
>  	context.resynch = 1;
>  	context.attr_namespace = xfs_attr_namespace(flags);
>  	context.buffer = buffer;
> @@ -430,7 +428,7 @@ xfs_ioc_attr_list(
>  		goto out_free;
> 
>  	if (copy_to_user(ubuf, buffer, bufsize) ||
> -	    copy_to_user(ucursor, &cursor, sizeof(cursor)))
> +	    copy_to_user(ucursor, &context.cursor, sizeof(context.cursor)))
>  		error = -EFAULT;
>  out_free:
>  	kmem_free(buffer);
> diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
> index d6e8000ad825..bab6a5a92407 100644
> --- a/fs/xfs/xfs_ioctl.h
> +++ b/fs/xfs/xfs_ioctl.h
> @@ -6,7 +6,6 @@
>  #ifndef __XFS_IOCTL_H__
>  #define __XFS_IOCTL_H__
> 
> -struct attrlist_cursor_kern;
>  struct xfs_bstat;
>  struct xfs_ibulk;
>  struct xfs_inogrp;
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index a064b1523fa5..f886c0a5dbe1 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -59,9 +59,9 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ctx->dp)->i_sb->s_dev;
>  		__entry->ino = ctx->dp->i_ino;
> -		__entry->hashval = ctx->cursor->hashval;
> -		__entry->blkno = ctx->cursor->blkno;
> -		__entry->offset = ctx->cursor->offset;
> +		__entry->hashval = ctx->cursor.hashval;
> +		__entry->blkno = ctx->cursor.blkno;
> +		__entry->offset = ctx->cursor.offset;
>  		__entry->buffer = ctx->buffer;
>  		__entry->bufsize = ctx->bufsize;
>  		__entry->count = ctx->count;
> @@ -186,9 +186,9 @@ TRACE_EVENT(xfs_attr_list_node_descend,
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ctx->dp)->i_sb->s_dev;
>  		__entry->ino = ctx->dp->i_ino;
> -		__entry->hashval = ctx->cursor->hashval;
> -		__entry->blkno = ctx->cursor->blkno;
> -		__entry->offset = ctx->cursor->offset;
> +		__entry->hashval = ctx->cursor.hashval;
> +		__entry->blkno = ctx->cursor.blkno;
> +		__entry->offset = ctx->cursor.offset;
>  		__entry->buffer = ctx->buffer;
>  		__entry->bufsize = ctx->bufsize;
>  		__entry->count = ctx->count;
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 1d2c8615b335..b4e740a6b372 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -188,7 +188,6 @@ xfs_vn_listxattr(
>  	size_t		size)
>  {
>  	struct xfs_attr_list_context context;
> -	struct attrlist_cursor_kern cursor = { 0 };
>  	struct inode	*inode = d_inode(dentry);
>  	int		error;
> 
> @@ -197,7 +196,6 @@ xfs_vn_listxattr(
>  	 */
>  	memset(&context, 0, sizeof(context));
>  	context.dp = XFS_I(inode);
> -	context.cursor = &cursor;
>  	context.resynch = 1;
>  	context.buffer = size ? data : NULL;
>  	context.bufsize = size;
> 


-- 
chandan



