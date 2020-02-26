Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC46EC4BA24
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 744722072D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:24:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rJjk3ROQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgBZUYn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 15:24:43 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35030 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbgBZUYm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 15:24:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=AMp9nvbQYfe8CyosEqZmp/mnFbRBjWzws0X+yE6SELA=; b=rJjk3ROQf4lerN8871uWfD58PK
        0DkzNsBL+OKFwBkeR1ayWZ84Zz3fxNboEc63x1V0nGjeqyKTrqYvwO1hvG/53LCtps4QhF3c9kFF3
        +YiDz7MmVhIWMIMc0ss/qQB+4su9lTI/FfiCU6ucyU/8a5VG/i3Emz+IlHvyo1jfz0/xEhDeJlr3V
        EvSKf2AeE29DsQgttlcuv21AoEkkNF/6b9z33/2eem5XN6L5yFkUGhukSBLipT1rUCylbp6fcN+S1
        Eq9Aq4ji3gLgHpDQSJrQjROnWjb9c4SnOXloG0TtrjKvk0rX+RLCYuAekFU9FDsK5JGd8joS182W+
        A4Wuj2cw==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j73EY-0008U7-L9; Wed, 26 Feb 2020 20:24:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 17/32] xfs: cleanup struct xfs_attr_list_context
Date:   Wed, 26 Feb 2020 12:22:51 -0800
Message-Id: <20200226202306.871241-18-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226202306.871241-1-hch@lst.de>
References: <20200226202306.871241-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace the alist char pointer with a void buffer given that different
callers use it in different ways.  Use the chance to remove the typedef
and reduce the indentation of the struct definition so that it doesn't
overflow 80 char lines all over.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.h | 34 +++++++++++++-------------
 fs/xfs/xfs_attr_list.c   | 53 ++++++++++++++++++++--------------------
 fs/xfs/xfs_trace.h       | 16 ++++++------
 fs/xfs/xfs_xattr.c       |  6 ++---
 4 files changed, 55 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 0f369399effd..0c8f7c7a6b65 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -99,28 +99,28 @@ typedef struct attrlist_cursor_kern {
 typedef void (*put_listent_func_t)(struct xfs_attr_list_context *, int,
 			      unsigned char *, int, int);
 
-typedef struct xfs_attr_list_context {
-	struct xfs_trans		*tp;
-	struct xfs_inode		*dp;		/* inode */
-	struct attrlist_cursor_kern	*cursor;	/* position in list */
-	char				*alist;		/* output buffer */
+struct xfs_attr_list_context {
+	struct xfs_trans	*tp;
+	struct xfs_inode	*dp;		/* inode */
+	struct attrlist_cursor_kern *cursor;	/* position in list */
+	void			*buffer;	/* output buffer */
 
 	/*
 	 * Abort attribute list iteration if non-zero.  Can be used to pass
 	 * error values to the xfs_attr_list caller.
 	 */
-	int				seen_enough;
-	bool				allow_incomplete;
-
-	ssize_t				count;		/* num used entries */
-	int				dupcnt;		/* count dup hashvals seen */
-	int				bufsize;	/* total buffer size */
-	int				firstu;		/* first used byte in buffer */
-	int				flags;		/* from VOP call */
-	int				resynch;	/* T/F: resynch with cursor */
-	put_listent_func_t		put_listent;	/* list output fmt function */
-	int				index;		/* index into output buffer */
-} xfs_attr_list_context_t;
+	int			seen_enough;
+	bool			allow_incomplete;
+
+	ssize_t			count;		/* num used entries */
+	int			dupcnt;		/* count dup hashvals seen */
+	int			bufsize;	/* total buffer size */
+	int			firstu;		/* first used byte in buffer */
+	int			flags;		/* from VOP call */
+	int			resynch;	/* T/F: resynch with cursor */
+	put_listent_func_t	put_listent;	/* list output fmt function */
+	int			index;		/* index into output buffer */
+};
 
 
 /*========================================================================
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index b4305217bcc0..0fe12474a952 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -488,10 +488,11 @@ xfs_attr3_leaf_list_int(
  * Copy out attribute entries for attr_list(), for leaf attribute lists.
  */
 STATIC int
-xfs_attr_leaf_list(xfs_attr_list_context_t *context)
+xfs_attr_leaf_list(
+	struct xfs_attr_list_context	*context)
 {
-	int error;
-	struct xfs_buf *bp;
+	struct xfs_buf			*bp;
+	int				error;
 
 	trace_xfs_attr_leaf_list(context);
 
@@ -527,11 +528,11 @@ xfs_attr_list_int_ilocked(
 
 int
 xfs_attr_list_int(
-	xfs_attr_list_context_t *context)
+	struct xfs_attr_list_context	*context)
 {
-	int error;
-	xfs_inode_t *dp = context->dp;
-	uint		lock_mode;
+	struct xfs_inode		*dp = context->dp;
+	uint				lock_mode;
+	int				error;
 
 	XFS_STATS_INC(dp->i_mount, xs_attr_list);
 
@@ -557,15 +558,15 @@ xfs_attr_list_int(
  */
 STATIC void
 xfs_attr_put_listent(
-	xfs_attr_list_context_t *context,
-	int		flags,
-	unsigned char	*name,
-	int		namelen,
-	int		valuelen)
+	struct xfs_attr_list_context	*context,
+	int			flags,
+	unsigned char		*name,
+	int			namelen,
+	int			valuelen)
 {
-	struct attrlist *alist = (struct attrlist *)context->alist;
-	attrlist_ent_t *aep;
-	int arraytop;
+	struct attrlist		*alist = context->buffer;
+	struct attrlist_ent	*aep;
+	int			arraytop;
 
 	ASSERT(!context->seen_enough);
 	ASSERT(context->count >= 0);
@@ -593,7 +594,7 @@ xfs_attr_put_listent(
 		return;
 	}
 
-	aep = (attrlist_ent_t *)&context->alist[context->firstu];
+	aep = context->buffer + context->firstu;
 	aep->a_valuelen = valuelen;
 	memcpy(aep->a_name, name, namelen);
 	aep->a_name[namelen] = 0;
@@ -612,15 +613,15 @@ xfs_attr_put_listent(
  */
 int
 xfs_attr_list(
-	xfs_inode_t	*dp,
-	char		*buffer,
-	int		bufsize,
-	int		flags,
-	attrlist_cursor_kern_t *cursor)
+	struct xfs_inode		*dp,
+	char				*buffer,
+	int				bufsize,
+	int				flags,
+	struct attrlist_cursor_kern	*cursor)
 {
-	xfs_attr_list_context_t context;
-	struct attrlist *alist;
-	int error;
+	struct xfs_attr_list_context	context;
+	struct attrlist			*alist;
+	int				error;
 
 	/*
 	 * Validate the cursor.
@@ -645,12 +646,12 @@ xfs_attr_list(
 	context.cursor = cursor;
 	context.resynch = 1;
 	context.flags = flags;
-	context.alist = buffer;
+	context.buffer = buffer;
 	context.bufsize = (bufsize & ~(sizeof(int)-1));  /* align */
 	context.firstu = context.bufsize;
 	context.put_listent = xfs_attr_put_listent;
 
-	alist = (struct attrlist *)context.alist;
+	alist = context.buffer;
 	alist->al_count = 0;
 	alist->al_more = 0;
 	alist->al_offset[0] = context.bufsize;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index e242988f57fb..43b1b03ae00f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -45,7 +45,7 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
 		__field(u32, hashval)
 		__field(u32, blkno)
 		__field(u32, offset)
-		__field(void *, alist)
+		__field(void *, buffer)
 		__field(int, bufsize)
 		__field(int, count)
 		__field(int, firstu)
@@ -58,21 +58,21 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
 		__entry->hashval = ctx->cursor->hashval;
 		__entry->blkno = ctx->cursor->blkno;
 		__entry->offset = ctx->cursor->offset;
-		__entry->alist = ctx->alist;
+		__entry->buffer = ctx->buffer;
 		__entry->bufsize = ctx->bufsize;
 		__entry->count = ctx->count;
 		__entry->firstu = ctx->firstu;
 		__entry->flags = ctx->flags;
 	),
 	TP_printk("dev %d:%d ino 0x%llx cursor h/b/o 0x%x/0x%x/%u dupcnt %u "
-		  "alist %p size %u count %u firstu %u flags %d %s",
+		  "buffer %p size %u count %u firstu %u flags %d %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		   __entry->ino,
 		   __entry->hashval,
 		   __entry->blkno,
 		   __entry->offset,
 		   __entry->dupcnt,
-		   __entry->alist,
+		   __entry->buffer,
 		   __entry->bufsize,
 		   __entry->count,
 		   __entry->firstu,
@@ -169,7 +169,7 @@ TRACE_EVENT(xfs_attr_list_node_descend,
 		__field(u32, hashval)
 		__field(u32, blkno)
 		__field(u32, offset)
-		__field(void *, alist)
+		__field(void *, buffer)
 		__field(int, bufsize)
 		__field(int, count)
 		__field(int, firstu)
@@ -184,7 +184,7 @@ TRACE_EVENT(xfs_attr_list_node_descend,
 		__entry->hashval = ctx->cursor->hashval;
 		__entry->blkno = ctx->cursor->blkno;
 		__entry->offset = ctx->cursor->offset;
-		__entry->alist = ctx->alist;
+		__entry->buffer = ctx->buffer;
 		__entry->bufsize = ctx->bufsize;
 		__entry->count = ctx->count;
 		__entry->firstu = ctx->firstu;
@@ -193,7 +193,7 @@ TRACE_EVENT(xfs_attr_list_node_descend,
 		__entry->bt_before = be32_to_cpu(btree->before);
 	),
 	TP_printk("dev %d:%d ino 0x%llx cursor h/b/o 0x%x/0x%x/%u dupcnt %u "
-		  "alist %p size %u count %u firstu %u flags %d %s "
+		  "buffer %p size %u count %u firstu %u flags %d %s "
 		  "node hashval %u, node before %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		   __entry->ino,
@@ -201,7 +201,7 @@ TRACE_EVENT(xfs_attr_list_node_descend,
 		   __entry->blkno,
 		   __entry->offset,
 		   __entry->dupcnt,
-		   __entry->alist,
+		   __entry->buffer,
 		   __entry->bufsize,
 		   __entry->count,
 		   __entry->firstu,
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 05c1d6d057a0..b5f2831fad95 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -134,7 +134,7 @@ __xfs_xattr_put_listent(
 	if (context->count < 0 || context->seen_enough)
 		return;
 
-	if (!context->alist)
+	if (!context->buffer)
 		goto compute_size;
 
 	arraytop = context->count + prefix_len + namelen + 1;
@@ -143,7 +143,7 @@ __xfs_xattr_put_listent(
 		context->seen_enough = 1;
 		return;
 	}
-	offset = (char *)context->alist + context->count;
+	offset = context->buffer + context->count;
 	strncpy(offset, prefix, prefix_len);
 	offset += prefix_len;
 	strncpy(offset, (char *)name, namelen);			/* real name */
@@ -229,7 +229,7 @@ xfs_vn_listxattr(
 	context.dp = XFS_I(inode);
 	context.cursor = &cursor;
 	context.resynch = 1;
-	context.alist = size ? data : NULL;
+	context.buffer = size ? data : NULL;
 	context.bufsize = size;
 	context.firstu = context.bufsize;
 	context.put_listent = xfs_xattr_put_listent;
-- 
2.24.1

