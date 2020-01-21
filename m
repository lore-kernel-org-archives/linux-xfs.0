Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C20EC2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C7D721835
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:31:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V2sPMhMC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgAUSa7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:30:59 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46850 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729096AbgAUSa7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 13:30:59 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LISdZW187036;
        Tue, 21 Jan 2020 18:30:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=KK/8p2H1VnGfi/uXxuavrKmElo1F8rdDKouZ5gAXnms=;
 b=V2sPMhMCKzHvMbD7wtzC7RtPjz01tVWkY1fiUI/vrx8F5x/78bQjR0FGrS/VyLFvwL10
 VHBdVFtj2smdKhoSBl0XPkpE44oiM4qr0x6FSZYSJ6q6Xo7ebCwDCYZRKDDyC/4vb58n
 DGbH/4ATgl4aNjpsM79+MKbkQx1/mUt9WQiqWVBwFcpgZAqYdh1uMB1YaR8X5N1b4C9A
 bXgsGKjn5NRst2O98M3W0YniIPGBj+9r2o8sULeTFZ+iimn1GyqezUPXje4wGJ8s4UMe
 YmLUh+ziLyjCy9WsQLSzOm7YLz21Ax1nEQmDKgYNiLgjI88pjZeIlHqzH3iaSSSfy0ap Xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xktnr6tcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:30:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LISuxu086571;
        Tue, 21 Jan 2020 18:30:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xnpefbbjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:30:54 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00LIUs19029074;
        Tue, 21 Jan 2020 18:30:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 10:30:54 -0800
Date:   Tue, 21 Jan 2020 10:30:52 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 17/29] xfs: cleanup xfs_attr_list_context
Message-ID: <20200121183052.GQ8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-18-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-18-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:39AM +0100, Christoph Hellwig wrote:
> Replace the alist char pointer with a void buffer given that different
> callers use it in different ways.  Use the chance to remove the typedef
> and reduce the indentation of the struct defintion so that it doesn't

"definition"

> overflow 80 char lines all over.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
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

I hope nobody ever turns on -Wpointer-arith... but hey, checkpatch
doesn't complain.  With the changelog fixed,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

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
> -- 
> 2.24.1
> 
