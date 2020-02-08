Return-Path: <SRS0=5CkV=34=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09961C35250
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Feb 2020 15:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5C792082E
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Feb 2020 15:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbgBHPu5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Feb 2020 10:50:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16172 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727340AbgBHPu5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Feb 2020 10:50:57 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 018Fo1dJ142560
        for <linux-xfs@vger.kernel.org>; Sat, 8 Feb 2020 10:50:56 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1tn308m9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sat, 08 Feb 2020 10:50:56 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sat, 8 Feb 2020 15:50:54 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 8 Feb 2020 15:50:50 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 018FnucP45613526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 8 Feb 2020 15:49:56 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2EF2A404D;
        Sat,  8 Feb 2020 15:50:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C18ABA4040;
        Sat,  8 Feb 2020 15:50:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.68.130])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  8 Feb 2020 15:50:48 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 18/30] xfs: cleanup struct xfs_attr_list_context
Date:   Sat, 08 Feb 2020 21:23:34 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-19-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-19-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20020815-0028-0000-0000-000003D8B9B3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020815-0029-0000-0000-0000249D20FB
Message-Id: <11715290.WgMxQ6pyV5@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-08_04:2020-02-07,2020-02-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 suspectscore=1 bulkscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002080127
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:32 PM Christoph Hellwig wrote: 
> Replace the alist char pointer with a void buffer given that different
> callers use it in different ways.  Use the chance to remove the typedef
> and reduce the indentation of the struct definition so that it doesn't
> overflow 80 char lines all over.
>

The behaviour of the code is logically the same as before.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>


> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.h | 34 +++++++++++++-------------
>  fs/xfs/xfs_attr_list.c   | 53 ++++++++++++++++++++--------------------
>  fs/xfs/xfs_trace.h       | 16 ++++++------
>  fs/xfs/xfs_xattr.c       |  6 ++---
>  4 files changed, 55 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 0f369399effd..0c8f7c7a6b65 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -99,28 +99,28 @@ typedef struct attrlist_cursor_kern {
>  typedef void (*put_listent_func_t)(struct xfs_attr_list_context *, int,
>  			      unsigned char *, int, int);
> 
> -typedef struct xfs_attr_list_context {
> -	struct xfs_trans		*tp;
> -	struct xfs_inode		*dp;		/* inode */
> -	struct attrlist_cursor_kern	*cursor;	/* position in list */
> -	char				*alist;		/* output buffer */
> +struct xfs_attr_list_context {
> +	struct xfs_trans	*tp;
> +	struct xfs_inode	*dp;		/* inode */
> +	struct attrlist_cursor_kern *cursor;	/* position in list */
> +	void			*buffer;	/* output buffer */
> 
>  	/*
>  	 * Abort attribute list iteration if non-zero.  Can be used to pass
>  	 * error values to the xfs_attr_list caller.
>  	 */
> -	int				seen_enough;
> -	bool				allow_incomplete;
> -
> -	ssize_t				count;		/* num used entries */
> -	int				dupcnt;		/* count dup hashvals seen */
> -	int				bufsize;	/* total buffer size */
> -	int				firstu;		/* first used byte in buffer */
> -	int				flags;		/* from VOP call */
> -	int				resynch;	/* T/F: resynch with cursor */
> -	put_listent_func_t		put_listent;	/* list output fmt function */
> -	int				index;		/* index into output buffer */
> -} xfs_attr_list_context_t;
> +	int			seen_enough;
> +	bool			allow_incomplete;
> +
> +	ssize_t			count;		/* num used entries */
> +	int			dupcnt;		/* count dup hashvals seen */
> +	int			bufsize;	/* total buffer size */
> +	int			firstu;		/* first used byte in buffer */
> +	int			flags;		/* from VOP call */
> +	int			resynch;	/* T/F: resynch with cursor */
> +	put_listent_func_t	put_listent;	/* list output fmt function */
> +	int			index;		/* index into output buffer */
> +};
> 
> 
>  /*========================================================================
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index ac8dc64447d6..9c4acb6dc856 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -488,10 +488,11 @@ xfs_attr3_leaf_list_int(
>   * Copy out attribute entries for attr_list(), for leaf attribute lists.
>   */
>  STATIC int
> -xfs_attr_leaf_list(xfs_attr_list_context_t *context)
> +xfs_attr_leaf_list(
> +	struct xfs_attr_list_context	*context)
>  {
> -	int error;
> -	struct xfs_buf *bp;
> +	struct xfs_buf			*bp;
> +	int				error;
> 
>  	trace_xfs_attr_leaf_list(context);
> 
> @@ -527,11 +528,11 @@ xfs_attr_list_int_ilocked(
> 
>  int
>  xfs_attr_list_int(
> -	xfs_attr_list_context_t *context)
> +	struct xfs_attr_list_context	*context)
>  {
> -	int error;
> -	xfs_inode_t *dp = context->dp;
> -	uint		lock_mode;
> +	struct xfs_inode		*dp = context->dp;
> +	uint				lock_mode;
> +	int				error;
> 
>  	XFS_STATS_INC(dp->i_mount, xs_attr_list);
> 
> @@ -557,15 +558,15 @@ xfs_attr_list_int(
>   */
>  STATIC void
>  xfs_attr_put_listent(
> -	xfs_attr_list_context_t *context,
> -	int		flags,
> -	unsigned char	*name,
> -	int		namelen,
> -	int		valuelen)
> +	struct xfs_attr_list_context	*context,
> +	int			flags,
> +	unsigned char		*name,
> +	int			namelen,
> +	int			valuelen)
>  {
> -	struct attrlist *alist = (struct attrlist *)context->alist;
> -	attrlist_ent_t *aep;
> -	int arraytop;
> +	struct attrlist		*alist = context->buffer;
> +	struct attrlist_ent	*aep;
> +	int			arraytop;
> 
>  	ASSERT(!context->seen_enough);
>  	ASSERT(context->count >= 0);
> @@ -593,7 +594,7 @@ xfs_attr_put_listent(
>  		return;
>  	}
> 
> -	aep = (attrlist_ent_t *)&context->alist[context->firstu];
> +	aep = context->buffer + context->firstu;
>  	aep->a_valuelen = valuelen;
>  	memcpy(aep->a_name, name, namelen);
>  	aep->a_name[namelen] = 0;
> @@ -612,15 +613,15 @@ xfs_attr_put_listent(
>   */
>  int
>  xfs_attr_list(
> -	xfs_inode_t	*dp,
> -	char		*buffer,
> -	int		bufsize,
> -	int		flags,
> -	attrlist_cursor_kern_t *cursor)
> +	struct xfs_inode		*dp,
> +	char				*buffer,
> +	int				bufsize,
> +	int				flags,
> +	struct attrlist_cursor_kern	*cursor)
>  {
> -	xfs_attr_list_context_t context;
> -	struct attrlist *alist;
> -	int error;
> +	struct xfs_attr_list_context	context;
> +	struct attrlist			*alist;
> +	int				error;
> 
>  	/*
>  	 * Validate the cursor.
> @@ -645,12 +646,12 @@ xfs_attr_list(
>  	context.cursor = cursor;
>  	context.resynch = 1;
>  	context.flags = flags;
> -	context.alist = buffer;
> +	context.buffer = buffer;
>  	context.bufsize = (bufsize & ~(sizeof(int)-1));  /* align */
>  	context.firstu = context.bufsize;
>  	context.put_listent = xfs_attr_put_listent;
> 
> -	alist = (struct attrlist *)context.alist;
> +	alist = context.buffer;
>  	alist->al_count = 0;
>  	alist->al_more = 0;
>  	alist->al_offset[0] = context.bufsize;
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index a86be7f807ee..8358a92987f9 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -45,7 +45,7 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
>  		__field(u32, hashval)
>  		__field(u32, blkno)
>  		__field(u32, offset)
> -		__field(void *, alist)
> +		__field(void *, buffer)
>  		__field(int, bufsize)
>  		__field(int, count)
>  		__field(int, firstu)
> @@ -58,21 +58,21 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
>  		__entry->hashval = ctx->cursor->hashval;
>  		__entry->blkno = ctx->cursor->blkno;
>  		__entry->offset = ctx->cursor->offset;
> -		__entry->alist = ctx->alist;
> +		__entry->buffer = ctx->buffer;
>  		__entry->bufsize = ctx->bufsize;
>  		__entry->count = ctx->count;
>  		__entry->firstu = ctx->firstu;
>  		__entry->flags = ctx->flags;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx cursor h/b/o 0x%x/0x%x/%u dupcnt %u "
> -		  "alist %p size %u count %u firstu %u flags %d %s",
> +		  "buffer %p size %u count %u firstu %u flags %d %s",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		   __entry->ino,
>  		   __entry->hashval,
>  		   __entry->blkno,
>  		   __entry->offset,
>  		   __entry->dupcnt,
> -		   __entry->alist,
> +		   __entry->buffer,
>  		   __entry->bufsize,
>  		   __entry->count,
>  		   __entry->firstu,
> @@ -169,7 +169,7 @@ TRACE_EVENT(xfs_attr_list_node_descend,
>  		__field(u32, hashval)
>  		__field(u32, blkno)
>  		__field(u32, offset)
> -		__field(void *, alist)
> +		__field(void *, buffer)
>  		__field(int, bufsize)
>  		__field(int, count)
>  		__field(int, firstu)
> @@ -184,7 +184,7 @@ TRACE_EVENT(xfs_attr_list_node_descend,
>  		__entry->hashval = ctx->cursor->hashval;
>  		__entry->blkno = ctx->cursor->blkno;
>  		__entry->offset = ctx->cursor->offset;
> -		__entry->alist = ctx->alist;
> +		__entry->buffer = ctx->buffer;
>  		__entry->bufsize = ctx->bufsize;
>  		__entry->count = ctx->count;
>  		__entry->firstu = ctx->firstu;
> @@ -193,7 +193,7 @@ TRACE_EVENT(xfs_attr_list_node_descend,
>  		__entry->bt_before = be32_to_cpu(btree->before);
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx cursor h/b/o 0x%x/0x%x/%u dupcnt %u "
> -		  "alist %p size %u count %u firstu %u flags %d %s "
> +		  "buffer %p size %u count %u firstu %u flags %d %s "
>  		  "node hashval %u, node before %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		   __entry->ino,
> @@ -201,7 +201,7 @@ TRACE_EVENT(xfs_attr_list_node_descend,
>  		   __entry->blkno,
>  		   __entry->offset,
>  		   __entry->dupcnt,
> -		   __entry->alist,
> +		   __entry->buffer,
>  		   __entry->bufsize,
>  		   __entry->count,
>  		   __entry->firstu,
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index c9c44f8aebed..8880dee3400f 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -132,7 +132,7 @@ __xfs_xattr_put_listent(
>  	if (context->count < 0 || context->seen_enough)
>  		return;
> 
> -	if (!context->alist)
> +	if (!context->buffer)
>  		goto compute_size;
> 
>  	arraytop = context->count + prefix_len + namelen + 1;
> @@ -141,7 +141,7 @@ __xfs_xattr_put_listent(
>  		context->seen_enough = 1;
>  		return;
>  	}
> -	offset = (char *)context->alist + context->count;
> +	offset = context->buffer + context->count;
>  	strncpy(offset, prefix, prefix_len);
>  	offset += prefix_len;
>  	strncpy(offset, (char *)name, namelen);			/* real name */
> @@ -227,7 +227,7 @@ xfs_vn_listxattr(
>  	context.dp = XFS_I(inode);
>  	context.cursor = &cursor;
>  	context.resynch = 1;
> -	context.alist = size ? data : NULL;
> +	context.buffer = size ? data : NULL;
>  	context.bufsize = size;
>  	context.firstu = context.bufsize;
>  	context.put_listent = xfs_xattr_put_listent;
> 


-- 
chandan



