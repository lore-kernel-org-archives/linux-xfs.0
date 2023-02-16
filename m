Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E758C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjBPUlw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBPUlw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:41:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029B61ADE1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:41:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 530EEB826BA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF461C433EF;
        Thu, 16 Feb 2023 20:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580107;
        bh=aE2SglplaRZgiQrexg1JdZTyVG1vaKZiu4sylGaeNnU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=fInwa6Km+lnwi/U+VH3Rcf9cf/0nwupyFAnW8R/uPoKBSwNYHSbeiMjzl4bdhIXp/
         Bbelun3Z9EJ4Lct22o0hqhUKnYJy1/trznXtjsVzjvcgNR62d73nGje1qHaNviYmlp
         RxJbIIvJNCQLbizVXMtn6DKKYZB8s6ZWHXaQXWt0UEa6INVd4DrujXpnrtz9588ef+
         cQQaMDHDF97tq69chojI43OtXhU/vb4ZFI4MRypwp9YfN3gLlGMgdV3x7VPtv3NRAU
         biXyVf84WWNxii2CDr+v7BoeWLTaOOSwmTb5tjz8993Sg0IYAHIa9ju0vcxw+MQtGo
         rx8gkXalZ18og==
Date:   Thu, 16 Feb 2023 12:41:46 -0800
Subject: [PATCH 4/4] xfs: replace the XFS_IOC_GETPARENTS backend
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657873492.3474196.5665804667970020794.stgit@magnolia>
In-Reply-To: <167657873432.3474196.15004300376430244372.stgit@magnolia>
References: <167657873432.3474196.15004300376430244372.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that xfs_attr_list can pass local xattr values to the put_listent
function, build a new version of the GETPARENTS backend that supplies a
custom put_listent function to format parent pointer info directly into
the caller's buffer.  This uses a lot less memory and obviates the
iterate list and then grab the values logic, since parent pointers
aren't supposed to have remote values anyway.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_parent.c |   40 +++++++---
 fs/xfs/libxfs/xfs_parent.h |   21 +++++
 fs/xfs/xfs_ioctl.c         |    5 -
 fs/xfs/xfs_parent_utils.c  |  184 ++++++++++++++++++++++++--------------------
 fs/xfs/xfs_parent_utils.h  |    4 -
 fs/xfs/xfs_trace.c         |    1 
 fs/xfs/xfs_trace.h         |   73 +++++++++++++++++
 7 files changed, 227 insertions(+), 101 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 8cc264baf6c7..179b9bebaf25 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -29,16 +29,6 @@
 
 struct kmem_cache		*xfs_parent_intent_cache;
 
-/* Initializes a xfs_parent_ptr from an xfs_parent_name_rec */
-void
-xfs_init_parent_ptr(struct xfs_parent_ptr		*xpp,
-		    const struct xfs_parent_name_rec	*rec)
-{
-	xpp->xpp_ino = be64_to_cpu(rec->p_ino);
-	xpp->xpp_gen = be32_to_cpu(rec->p_gen);
-	xpp->xpp_diroffset = be32_to_cpu(rec->p_diroffset);
-}
-
 /*
  * Parent pointer attribute handling.
  *
@@ -115,6 +105,36 @@ xfs_init_parent_name_rec(
 	rec->p_diroffset = cpu_to_be32(p_diroffset);
 }
 
+/*
+ * Convert an ondisk parent_name xattr to its incore format.  If @value is
+ * NULL, set @irec->p_namelen to zero and leave @irec->p_name untouched.
+ */
+void
+xfs_parent_irec_from_disk(
+	struct xfs_parent_name_irec	*irec,
+	const struct xfs_parent_name_rec *rec,
+	const void			*value,
+	int				valuelen)
+{
+	irec->p_ino = be64_to_cpu(rec->p_ino);
+	irec->p_gen = be32_to_cpu(rec->p_gen);
+	irec->p_diroffset = be32_to_cpu(rec->p_diroffset);
+
+	if (!value) {
+		irec->p_namelen = 0;
+		return;
+	}
+
+	ASSERT(valuelen > 0);
+	ASSERT(valuelen < MAXNAMELEN);
+
+	valuelen = min(valuelen, MAXNAMELEN);
+
+	irec->p_namelen = valuelen;
+	memcpy(irec->p_name, value, valuelen);
+	memset(&irec->p_name[valuelen], 0, sizeof(irec->p_name) - valuelen);
+}
+
 int
 __xfs_parent_init(
 	struct xfs_mount		*mp,
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 4ffcb81d399c..f4f5887d1133 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -15,6 +15,25 @@ bool xfs_parent_namecheck(struct xfs_mount *mp,
 bool xfs_parent_valuecheck(struct xfs_mount *mp, const void *value,
 		size_t valuelen);
 
+/*
+ * Incore version of a parent pointer, also contains dirent name so callers
+ * can pass/obtain all the parent pointer information in a single structure
+ */
+struct xfs_parent_name_irec {
+	/* Key fields for looking up a particular parent pointer. */
+	xfs_ino_t		p_ino;
+	uint32_t		p_gen;
+	xfs_dir2_dataptr_t	p_diroffset;
+
+	/* Attributes of a parent pointer. */
+	uint8_t			p_namelen;
+	unsigned char		p_name[MAXNAMELEN];
+};
+
+void xfs_parent_irec_from_disk(struct xfs_parent_name_irec *irec,
+		const struct xfs_parent_name_rec *rec,
+		const void *value, int valuelen);
+
 /*
  * Dynamically allocd structure used to wrap the needed data to pass around
  * the defer ops machinery
@@ -32,8 +51,6 @@ struct xfs_parent_defer {
 void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
 			      struct xfs_inode *ip,
 			      uint32_t p_diroffset);
-void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
-			 const struct xfs_parent_name_rec *rec);
 int __xfs_parent_init(struct xfs_mount *mp, bool grab_log,
 		struct xfs_parent_defer **parentp);
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index e6d1e69c6d4a..4c36ddd19dbd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1758,11 +1758,8 @@ xfs_ioc_get_parent_pointer(
 		}
 	}
 
-	if (call_ip->i_ino == mp->m_sb.sb_rootino)
-		ppi->pi_flags |= XFS_PPTR_OFLAG_ROOT;
-
 	/* Get the parent pointers */
-	error = xfs_attr_get_parent_pointer(call_ip, ppi);
+	error = xfs_getparent_pointers(call_ip, ppi);
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
index 771279731d42..5ff7d38bc375 100644
--- a/fs/xfs/xfs_parent_utils.c
+++ b/fs/xfs/xfs_parent_utils.c
@@ -23,104 +23,122 @@
 #include "xfs_da_btree.h"
 #include "xfs_parent_utils.h"
 
-/*
- * Get the parent pointers for a given inode
- *
- * Returns 0 on success and non zero on error
- */
+struct xfs_getparent_ctx {
+	struct xfs_attr_list_context	context;
+	struct xfs_parent_name_irec	pptr_irec;
+	struct xfs_pptr_info		*ppi;
+};
+
+static void
+xfs_getparent_listent(
+	struct xfs_attr_list_context	*context,
+	int				flags,
+	unsigned char			*name,
+	int				namelen,
+	void				*value,
+	int				valuelen)
+{
+	struct xfs_getparent_ctx	*gp;
+	struct xfs_pptr_info		*ppi;
+	struct xfs_parent_ptr		*pptr;
+	struct xfs_parent_name_irec	*irec;
+	struct xfs_mount		*mp = context->dp->i_mount;
+
+	gp = container_of(context, struct xfs_getparent_ctx, context);
+	ppi = gp->ppi;
+	irec = &gp->pptr_irec;
+
+	/* Ignore non-parent xattrs */
+	if (!(flags & XFS_ATTR_PARENT))
+		return;
+
+	/*
+	 * Report corruption for xattrs with any other flag set, or for a
+	 * parent pointer that has a remote value.  The attr list functions
+	 * filtered any INCOMPLETE attrs for us.
+	 */
+	if (XFS_IS_CORRUPT(mp,
+			   hweight32(flags & XFS_ATTR_NSP_ONDISK_MASK) > 1) ||
+	    XFS_IS_CORRUPT(mp, value == NULL)) {
+		context->seen_enough = -EFSCORRUPTED;
+		return;
+	}
+
+	/*
+	 * We found a parent pointer, but we've filled up the buffer.  Signal
+	 * to the caller that we did /not/ reach the end of the parent pointer
+	 * recordset.
+	 */
+	if (ppi->pi_ptrs_used >= ppi->pi_ptrs_size) {
+		context->seen_enough = 1;
+		return;
+	}
+
+	xfs_parent_irec_from_disk(&gp->pptr_irec, (void *)name, value,
+			valuelen);
+
+	trace_xfs_getparent_listent(context->dp, ppi, irec);
+
+	/* Format the parent pointer directly into the caller buffer. */
+	pptr = &ppi->pi_parents[ppi->pi_ptrs_used++];
+	pptr->xpp_ino = irec->p_ino;
+	pptr->xpp_gen = irec->p_gen;
+	pptr->xpp_diroffset = irec->p_diroffset;
+	pptr->xpp_rsvd = 0;
+
+	memcpy(pptr->xpp_name, irec->p_name, irec->p_namelen);
+	memset(pptr->xpp_name + irec->p_namelen, 0,
+			sizeof(pptr->xpp_name) - irec->p_namelen);
+}
+
+/* Retrieve the parent pointers for a given inode. */
 int
-xfs_attr_get_parent_pointer(
+xfs_getparent_pointers(
 	struct xfs_inode		*ip,
 	struct xfs_pptr_info		*ppi)
 {
+	struct xfs_getparent_ctx	*gp;
+	int				error;
 
-	struct xfs_attrlist		*alist;
-	struct xfs_attrlist_ent		*aent;
-	struct xfs_parent_ptr		*xpp;
-	struct xfs_parent_name_rec	*xpnr;
-	char				*namebuf;
-	unsigned int			namebuf_size;
-	int				name_len, i, error = 0;
-	unsigned int			lock_mode, flags = XFS_ATTR_PARENT;
-	struct xfs_attr_list_context	context;
-
-	/* Allocate a buffer to store the attribute names */
-	namebuf_size = sizeof(struct xfs_attrlist) +
-		       (ppi->pi_ptrs_size) * sizeof(struct xfs_attrlist_ent);
-	namebuf = kvzalloc(namebuf_size, GFP_KERNEL);
-	if (!namebuf)
+	gp = kzalloc(sizeof(struct xfs_getparent_ctx), GFP_KERNEL);
+	if (!gp)
 		return -ENOMEM;
-
-	memset(&context, 0, sizeof(struct xfs_attr_list_context));
-	error = xfs_ioc_attr_list_context_init(ip, namebuf, namebuf_size, 0,
-			&context);
-	if (error)
-		goto out_kfree;
+	gp->ppi = ppi;
+	gp->context.dp = ip;
+	gp->context.resynch = 1;
+	gp->context.put_listent = xfs_getparent_listent;
+	gp->context.bufsize = 1; /* always init cursor */
 
 	/* Copy the cursor provided by caller */
-	memcpy(&context.cursor, &ppi->pi_cursor,
-		sizeof(struct xfs_attrlist_cursor));
-	context.attr_filter = XFS_ATTR_PARENT;
+	memcpy(&gp->context.cursor, &ppi->pi_cursor,
+			sizeof(struct xfs_attrlist_cursor));
+	ppi->pi_ptrs_used = 0;
 
-	lock_mode = xfs_ilock_attr_map_shared(ip);
+	trace_xfs_getparent_pointers(ip, ppi, &gp->context.cursor);
 
-	error = xfs_attr_list_ilocked(&context);
+	error = xfs_attr_list(&gp->context);
 	if (error)
-		goto out_unlock;
-
-	alist = (struct xfs_attrlist *)namebuf;
-	for (i = 0; i < alist->al_count; i++) {
-		struct xfs_da_args args = {
-			.geo = ip->i_mount->m_attr_geo,
-			.whichfork = XFS_ATTR_FORK,
-			.dp = ip,
-			.namelen = sizeof(struct xfs_parent_name_rec),
-			.attr_filter = flags,
-		};
-
-		xpp = xfs_ppinfo_to_pp(ppi, i);
-		memset(xpp, 0, sizeof(struct xfs_parent_ptr));
-		aent = (struct xfs_attrlist_ent *)
-			&namebuf[alist->al_offset[i]];
-		xpnr = (struct xfs_parent_name_rec *)(aent->a_name);
-
-		if (aent->a_valuelen > XFS_PPTR_MAXNAMELEN) {
-			error = -EFSCORRUPTED;
-			goto out_unlock;
-		}
-		name_len = aent->a_valuelen;
-
-		args.name = (char *)xpnr;
-		args.hashval = xfs_da_hashname(args.name, args.namelen),
-		args.value = (unsigned char *)(xpp->xpp_name);
-		args.valuelen = name_len;
-
-		error = xfs_attr_get_ilocked(&args);
-		error = (error == -EEXIST ? 0 : error);
-		if (error) {
-			error = -EFSCORRUPTED;
-			goto out_unlock;
-		}
-
-		xfs_init_parent_ptr(xpp, xpnr);
-		if (!xfs_verify_ino(args.dp->i_mount, xpp->xpp_ino)) {
-			error = -EFSCORRUPTED;
-			goto out_unlock;
-		}
+		goto out_free;
+	if (gp->context.seen_enough < 0) {
+		error = gp->context.seen_enough;
+		goto out_free;
 	}
-	ppi->pi_ptrs_used = alist->al_count;
-	if (!alist->al_more)
+
+	/* Is this the root directory? */
+	if (ip->i_ino == ip->i_mount->m_sb.sb_rootino)
+		ppi->pi_flags |= XFS_PPTR_OFLAG_ROOT;
+
+	/*
+	 * If we did not run out of buffer space, then we reached the end of
+	 * the pptr recordset, so set the DONE flag.
+	 */
+	if (gp->context.seen_enough == 0)
 		ppi->pi_flags |= XFS_PPTR_OFLAG_DONE;
 
 	/* Update the caller with the current cursor position */
-	memcpy(&ppi->pi_cursor, &context.cursor,
+	memcpy(&ppi->pi_cursor, &gp->context.cursor,
 			sizeof(struct xfs_attrlist_cursor));
-
-out_unlock:
-	xfs_iunlock(ip, lock_mode);
-out_kfree:
-	kvfree(namebuf);
-
+out_free:
+	kfree(gp);
 	return error;
 }
-
diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
index ad60baee8b2a..9936c74e6f96 100644
--- a/fs/xfs/xfs_parent_utils.h
+++ b/fs/xfs/xfs_parent_utils.h
@@ -6,6 +6,6 @@
 #ifndef	__XFS_PARENT_UTILS_H__
 #define	__XFS_PARENT_UTILS_H__
 
-int xfs_attr_get_parent_pointer(struct xfs_inode *ip,
-				struct xfs_pptr_info *ppi);
+int xfs_getparent_pointers(struct xfs_inode *ip, struct xfs_pptr_info *ppi);
+
 #endif	/* __XFS_PARENT_UTILS_H__ */
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
index 6b0e9ae7c513..959aff69822d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -74,6 +74,9 @@ struct xfs_inobt_rec_incore;
 union xfs_btree_ptr;
 struct xfs_dqtrx;
 struct xfs_icwalk;
+struct xfs_pptr_info;
+struct xfs_parent_name_irec;
+struct xfs_attrlist_cursor_kern;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -4317,6 +4320,76 @@ TRACE_EVENT(xfs_force_shutdown,
 		__entry->line_num)
 );
 
+TRACE_EVENT(xfs_getparent_listent,
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_pptr_info *ppi,
+	         const struct xfs_parent_name_irec *irec),
+	TP_ARGS(ip, ppi, irec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, pused)
+		__field(unsigned int, psize)
+		__field(xfs_ino_t, parent_ino)
+		__field(unsigned int, parent_gen)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, irec->p_namelen)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->pused = ppi->pi_ptrs_used;
+		__entry->psize = ppi->pi_ptrs_size;
+		__entry->parent_ino = irec->p_ino;
+		__entry->parent_gen = irec->p_gen;
+		__entry->namelen = irec->p_namelen;
+		memcpy(__get_str(name), irec->p_name, irec->p_namelen);
+	),
+	TP_printk("dev %d:%d ino 0x%llx pptr %u/%u: parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->pused,
+		  __entry->psize,
+		  __entry->parent_ino,
+		  __entry->parent_gen,
+		  __entry->namelen,
+		  __get_str(name))
+);
+
+TRACE_EVENT(xfs_getparent_pointers,
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_pptr_info *ppi,
+		 const struct xfs_attrlist_cursor_kern *cur),
+	TP_ARGS(ip, ppi, cur),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, flags)
+		__field(unsigned int, psize)
+		__field(unsigned int, hashval)
+		__field(unsigned int, blkno)
+		__field(unsigned int, offset)
+		__field(int, initted)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->flags = ppi->pi_flags;
+		__entry->psize = ppi->pi_ptrs_size;
+		__entry->hashval = cur->hashval;
+		__entry->blkno = cur->blkno;
+		__entry->offset = cur->offset;
+		__entry->initted = cur->initted;
+	),
+	TP_printk("dev %d:%d ino 0x%llx flags 0x%x psize %u cur_init? %d hashval 0x%x blkno %u offset %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->flags,
+		  __entry->psize,
+		  __entry->initted,
+		  __entry->hashval,
+		  __entry->blkno,
+		  __entry->offset)
+);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

