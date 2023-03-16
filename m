Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42345C6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjCPTVI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbjCPTVE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:21:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014F065050
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:21:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26728B82302
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D89C433EF;
        Thu, 16 Mar 2023 19:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994458;
        bh=5uXMN/3qyUIedZ99E96+r858zvKb42drg2Cl33pomHY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=HEm1AooWWtkR4Ke55CSz0y6Fnx3Swuz9f4mZcwJgGD+fUiM6/4ssKrxYRf0z/UZbP
         tsw6pua7Q1RpG7uqFAnUlCy+hoTgkGzk6vcl+t+fseSGnxzSO6woDwJU23Pl2Lq0vn
         59jIVULkKUy8RCgbf6SeCCY032tTWmvHFPZdr43z64aZMz+JxeZ/VfIffUV1XCHmni
         O5KUkLqXNn1YcqStpQb7WNO1Rl0TaXnLgwqXBhj7CajFj8EQCJmWNQPCFtQB5/qGEH
         0uc4Y0ip7E9BH2iuXS+dZaipM9wLz7dWyA/VYl1QlwfGIv6TVMLN5Ex9Md2rRMtSjj
         dI8zqkyMGAn4Q==
Date:   Thu, 16 Mar 2023 12:20:58 -0700
Subject: [PATCH 5/7] xfs: add tracing to the GETPARENTS ioctl
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899413998.15157.13586240752307571300.stgit@frogsfrogsfrogs>
In-Reply-To: <167899413920.15157.15106630627506949304.stgit@frogsfrogsfrogs>
References: <167899413920.15157.15106630627506949304.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add some tracing to the getparents ioctl for easier debugging.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_parent_utils.c |    4 ++
 fs/xfs/xfs_trace.c        |    1 +
 fs/xfs/xfs_trace.h        |   76 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 80 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
index 059454c43934..5a4f72cd5711 100644
--- a/fs/xfs/xfs_parent_utils.c
+++ b/fs/xfs/xfs_parent_utils.c
@@ -86,6 +86,8 @@ xfs_getparent_listent(
 		return;
 	}
 
+	trace_xfs_getparent_listent(context->dp, ppi, irec);
+
 	/* Format the parent pointer directly into the caller buffer. */
 	ppi->gp_offsets[ppi->gp_count] = context->firstu;
 	pptr = xfs_getparents_rec(ppi, ppi->gp_count);
@@ -123,6 +125,8 @@ xfs_getparent_pointers(
 			sizeof(struct xfs_attrlist_cursor));
 	ppi->gp_count = 0;
 
+	trace_xfs_getparent_pointers(ip, ppi, &gp->context.cursor);
+
 	error = xfs_attr_list(&gp->context);
 	if (error)
 		goto out_free;
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 8a5dc1538aa8..c1f339481697 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -36,6 +36,7 @@
 #include "xfs_error.h"
 #include <linux/iomap.h>
 #include "xfs_iomap.h"
+#include "xfs_parent.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 9c0006c55fec..31f7871908dd 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -75,11 +75,15 @@ union xfs_btree_ptr;
 struct xfs_dqtrx;
 struct xfs_icwalk;
 struct xfs_perag;
+struct xfs_getparents;
+struct xfs_parent_name_irec;
+struct xfs_attrlist_cursor_kern;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
 	{ XFS_ATTR_SECURE,	"SECURE" }, \
-	{ XFS_ATTR_INCOMPLETE,	"INCOMPLETE" }
+	{ XFS_ATTR_INCOMPLETE,	"INCOMPLETE" }, \
+	{ XFS_ATTR_PARENT,	"PARENT" }
 
 DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	TP_PROTO(struct xfs_attr_list_context *ctx),
@@ -4325,6 +4329,76 @@ TRACE_EVENT(xfs_force_shutdown,
 		__entry->line_num)
 );
 
+TRACE_EVENT(xfs_getparent_listent,
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_getparents *ppi,
+	         const struct xfs_parent_name_irec *irec),
+	TP_ARGS(ip, ppi, irec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, count)
+		__field(unsigned int, bufsize)
+		__field(xfs_ino_t, parent_ino)
+		__field(unsigned int, parent_gen)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, irec->p_namelen)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->count = ppi->gp_count;
+		__entry->bufsize = ppi->gp_bufsize;
+		__entry->parent_ino = irec->p_ino;
+		__entry->parent_gen = irec->p_gen;
+		__entry->namelen = irec->p_namelen;
+		memcpy(__get_str(name), irec->p_name, irec->p_namelen);
+	),
+	TP_printk("dev %d:%d ino 0x%llx bufsize %u count %u: parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->bufsize,
+		  __entry->count,
+		  __entry->parent_ino,
+		  __entry->parent_gen,
+		  __entry->namelen,
+		  __get_str(name))
+);
+
+TRACE_EVENT(xfs_getparent_pointers,
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_getparents *ppi,
+		 const struct xfs_attrlist_cursor_kern *cur),
+	TP_ARGS(ip, ppi, cur),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, flags)
+		__field(unsigned int, bufsize)
+		__field(unsigned int, hashval)
+		__field(unsigned int, blkno)
+		__field(unsigned int, offset)
+		__field(int, initted)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->flags = ppi->gp_flags;
+		__entry->bufsize = ppi->gp_bufsize;
+		__entry->hashval = cur->hashval;
+		__entry->blkno = cur->blkno;
+		__entry->offset = cur->offset;
+		__entry->initted = cur->initted;
+	),
+	TP_printk("dev %d:%d ino 0x%llx flags 0x%x bufsize %u cur_init? %d hashval 0x%x blkno %u offset %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->flags,
+		  __entry->bufsize,
+		  __entry->initted,
+		  __entry->hashval,
+		  __entry->blkno,
+		  __entry->offset)
+);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

