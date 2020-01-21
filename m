Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B72DC2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 19:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D8002465B
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 19:04:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QBcdsBWS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgAUTE3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 14:04:29 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42528 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729414AbgAUTE3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 14:04:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LJ39Yl043545;
        Tue, 21 Jan 2020 19:04:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=kIEY2MEtIppD/QcxmiA3e+CctNxjjjWhBYZ9Hv10H14=;
 b=QBcdsBWSwNN6lwUh3iG/iu5zryQN9iDOVgCi9TQjQKqbzLLOgxCnvwj42PamiqAF3Okh
 3c6TzCEOwDsVH8KqlLxS3sW1GtQPN8ftDrPS68OM9PpO/0DyhyGVR+rVd+dnQIUpt2OW
 q5Z6y1DuvAT2Q2FZNgSoMP1rr2PhFUexw2i8CBDHmdgj4Y5qwmplKL7BTwmKkBWPKx+k
 FpVypjB8H55vC9Rdc1PcdHw2qHUVzv6UPVMenL4Wk3PaWhsOV7B8srU20FlpD+QKMlFS
 TZMgHAxKEfY+EanpxLFs+lmnB23yzJrTCEaIKzdIYZ56VYxjQVhxUyRHD80M9S1lzWJy 6g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xkseuf96f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 19:04:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LJ3exW178635;
        Tue, 21 Jan 2020 19:04:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xnpefgngb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 19:04:22 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LJ4LQT028407;
        Tue, 21 Jan 2020 19:04:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 11:04:21 -0800
Date:   Tue, 21 Jan 2020 11:04:18 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 29/29] xfs: embedded the attrlist cursor into struct
 xfs_attr_list_context
Message-ID: <20200121190418.GB8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-30-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-30-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:51AM +0100, Christoph Hellwig wrote:
> The attrlist cursor only exists as part of an attr list context, so
> embedd the structure instead of pointing to it.  Also give it a proper
> xfs_ prefix and remove the obsolete typedef.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

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
> index 2a379338d71b..3a29b0772bb2 100644
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
> index f4a188e28b7b..820cf02df159 100644
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
> index 063dc0d83453..d4e1ae5652c2 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -378,8 +378,7 @@ xfs_ioc_attr_list(
>  	int				flags,
>  	struct xfs_attrlist_cursor __user *ucursor)
>  {
> -	struct xfs_attr_list_context	context;
> -	struct attrlist_cursor_kern	cursor;
> +	struct xfs_attr_list_context	context = { 0 };
>  	struct xfs_attrlist		*alist;
>  	void				*buffer;
>  	int				error;
> @@ -397,12 +396,13 @@ xfs_ioc_attr_list(
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
> @@ -412,9 +412,7 @@ xfs_ioc_attr_list(
>  	/*
>  	 * Initialize the output buffer.
>  	 */
> -	memset(&context, 0, sizeof(context));
>  	context.dp = dp;
> -	context.cursor = &cursor;
>  	context.resynch = 1;
>  	context.attr_namespace = xfs_attr_namespace(flags);
>  	context.buffer = buffer;
> @@ -432,7 +430,7 @@ xfs_ioc_attr_list(
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
> -- 
> 2.24.1
> 
