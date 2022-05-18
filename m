Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E81DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 18:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241694AbiERSzS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 14:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241697AbiERSzR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:55:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECC31C7418
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:55:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC6C26189A
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54875C385A5;
        Wed, 18 May 2022 18:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900114;
        bh=jR1vFl8Bu7byBMQMnE2S+Ouilit3RSFg08+hmM8ANow=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BGgxEzxwfYDXC4oqb8Op7qDAxiL0Zd8EcdgMVbnuCbTQUoJdvL0oMKUoOMKjtPkKs
         6wIQOvcoD1b9/GxokXNcBEDLeVzyrV9YEq5qnhl7XkmZj6r3JNoIdTgaWii0DtLKmg
         DP7dlNB9XCEXrRIyruG7GgJ5t82+q8FxUO1PtAx81hhAtAsQIWTO9Yo262FmzNxXSK
         dHtWMnhMdKOk5IIE6EBGO3nhn+6XgFV3k6ug6t3R/dmLuyKZ6eGMjKASbGFDe49eBv
         1e/kSHmvNklRu29FRq4pE7wDFZ3MgJCHu8WGf1gAN9s7Nt+6UzTCi/xzHapvzYBjCw
         ijgtrlFOdmPwQ==
Subject: [PATCH 2/3] xfs: share xattr name and value buffers when logging
 xattr updates
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Wed, 18 May 2022 11:55:13 -0700
Message-ID: <165290011382.1646163.15379392968983343462.stgit@magnolia>
In-Reply-To: <165290010248.1646163.12346986876716116665.stgit@magnolia>
References: <165290010248.1646163.12346986876716116665.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While running xfs/297 and generic/642, I noticed a crash in
xfs_attri_item_relog when it tries to copy the attr name to the new
xattri log item.  I think what happened here was that we called
->iop_commit on the old attri item (which nulls out the pointers) as
part of a log force at the same time that a chained attr operation was
ongoing.  The system was busy enough that at some later point, the defer
ops operation decided it was necessary to relog the attri log item, but
as we've detached the name buffer from the old attri log item, we can't
copy it to the new one, and kaboom.

I think there's a broader refcounting problem with LARP mode -- the
setxattr code can return to userspace before the CIL actually formats
and commits the log item, which results in a UAF bug.  Therefore, the
xattr log item needs to be able to retain a reference to the name and
value buffers until the log items have completely cleared the log.
Furthermore, each time we create an intent log item, we allocate new
memory and (re)copy the contents; sharing here would be very useful.

Solve the UAF and the unnecessary memory allocations by having the log
code create a single refcounted buffer to contain the name and value
contents.  This buffer can be passed from old to new during a relog
operation, and the logging code can (optionally) attach it to the
xfs_attr_item for reuse when LARP mode is enabled.

This also fixes a problem where the xfs_attri_log_item objects weren't
being freed back to the same cache where they came from.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.h |    8 +
 fs/xfs/xfs_attr_item.c   |  279 +++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_attr_item.h   |   13 +-
 3 files changed, 182 insertions(+), 118 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 1af7abe29eef..17746dcc2268 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -501,6 +501,8 @@ enum xfs_delattr_state {
 	{ XFS_DAS_NODE_REMOVE_ATTR,	"XFS_DAS_NODE_REMOVE_ATTR" }, \
 	{ XFS_DAS_DONE,			"XFS_DAS_DONE" }
 
+struct xfs_attri_log_nameval;
+
 /*
  * Defines for xfs_attr_item.xattri_flags
  */
@@ -512,6 +514,12 @@ enum xfs_delattr_state {
 struct xfs_attr_item {
 	struct xfs_da_args		*xattri_da_args;
 
+	/*
+	 * Shared buffer containing the attr name and value so that the logging
+	 * code can share large memory buffers between log items.
+	 */
+	struct xfs_attri_log_nameval	*xattri_nameval;
+
 	/*
 	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
 	 */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 4976b1ddc09f..7d4469e8a4fc 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -39,12 +39,91 @@ static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_attri_log_item, attri_item);
 }
 
+/*
+ * Shared xattr name/value buffers for logged extended attribute operations
+ *
+ * When logging updates to extended attributes, we can create quite a few
+ * attribute log intent items for a single xattr update.  To avoid cycling the
+ * memory allocator and memcpy overhead, the name (and value, for setxattr)
+ * are kept in a refcounted object that is shared across all related log items
+ * and the upper-level deferred work state structure.  The shared buffer has
+ * a control structure, followed by the name, and then the value.
+ */
+
+static inline struct xfs_attri_log_nameval *
+xfs_attri_log_nameval_get(
+	struct xfs_attri_log_nameval	*anvl)
+{
+	BUG_ON(!refcount_inc_not_zero(&anvl->anvl_refcount));
+	return anvl;
+}
+
+static inline void
+xfs_attri_log_nameval_put(
+	struct xfs_attri_log_nameval	*anvl)
+{
+	if (refcount_dec_and_test(&anvl->anvl_refcount))
+		kvfree(anvl);
+}
+
+static inline void *
+xfs_attri_log_namebuf(
+	struct xfs_attri_log_item	*attrip)
+{
+	return attrip->attri_nameval + 1;
+}
+
+static inline void *
+xfs_attri_log_valbuf(
+	struct xfs_attri_log_item	*attrip)
+{
+	struct xfs_attri_log_nameval	*anvl = attrip->attri_nameval;
+
+	if (anvl->anvl_value_len == 0)
+		return NULL;
+
+	return (char *)xfs_attri_log_namebuf(attrip) + anvl->anvl_name_len;
+}
+
+static inline struct xfs_attri_log_nameval *
+xfs_attri_log_nameval_alloc(
+	const void			*name,
+	unsigned int			name_len,
+	const void			*value,
+	unsigned int			value_len)
+{
+	struct xfs_attri_log_nameval	*anvl;
+	void				*p;
+
+	/*
+	 * This could be over 64kB in length, so we have to use kvmalloc() for
+	 * this. But kvmalloc() utterly sucks, so we use our own version.
+	 */
+	anvl = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
+					name_len + value_len);
+	if (!anvl)
+		return anvl;
+
+	anvl->anvl_name_len = name_len;
+	anvl->anvl_value_len = value_len;
+	p = anvl + 1;
+	memcpy(p, name, name_len);
+	if (value_len) {
+		p += name_len;
+		memcpy(p, value, value_len);
+	}
+	refcount_set(&anvl->anvl_refcount, 1);
+	return anvl;
+}
+
 STATIC void
 xfs_attri_item_free(
 	struct xfs_attri_log_item	*attrip)
 {
 	kmem_free(attrip->attri_item.li_lv_shadow);
-	kvfree(attrip);
+	if (attrip->attri_nameval)
+		xfs_attri_log_nameval_put(attrip->attri_nameval);
+	kmem_cache_free(xfs_attri_cache, attrip);
 }
 
 /*
@@ -73,16 +152,17 @@ xfs_attri_item_size(
 	int				*nbytes)
 {
 	struct xfs_attri_log_item       *attrip = ATTRI_ITEM(lip);
+	struct xfs_attri_log_nameval	*anvl = attrip->attri_nameval;
 
 	*nvecs += 2;
 	*nbytes += sizeof(struct xfs_attri_log_format) +
-			xlog_calc_iovec_len(attrip->attri_name_len);
+			xlog_calc_iovec_len(anvl->anvl_name_len);
 
-	if (!attrip->attri_value_len)
+	if (!anvl->anvl_value_len)
 		return;
 
 	*nvecs += 1;
-	*nbytes += xlog_calc_iovec_len(attrip->attri_value_len);
+	*nbytes += xlog_calc_iovec_len(anvl->anvl_value_len);
 }
 
 /*
@@ -97,6 +177,7 @@ xfs_attri_item_format(
 {
 	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
 	struct xfs_log_iovec		*vecp = NULL;
+	struct xfs_attri_log_nameval	*anvl = attrip->attri_nameval;
 
 	attrip->attri_format.alfi_type = XFS_LI_ATTRI;
 	attrip->attri_format.alfi_size = 1;
@@ -108,22 +189,22 @@ xfs_attri_item_format(
 	 * the log recovery.
 	 */
 
-	ASSERT(attrip->attri_name_len > 0);
+	ASSERT(anvl->anvl_name_len > 0);
 	attrip->attri_format.alfi_size++;
 
-	if (attrip->attri_value_len > 0)
+	if (anvl->anvl_value_len > 0)
 		attrip->attri_format.alfi_size++;
 
 	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
 			&attrip->attri_format,
 			sizeof(struct xfs_attri_log_format));
 	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
-			attrip->attri_name,
-			attrip->attri_name_len);
-	if (attrip->attri_value_len > 0)
+			xfs_attri_log_namebuf(attrip),
+			anvl->anvl_name_len);
+	if (anvl->anvl_value_len > 0)
 		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
-				attrip->attri_value,
-				attrip->attri_value_len);
+				xfs_attri_log_valbuf(attrip),
+				anvl->anvl_value_len);
 }
 
 /*
@@ -158,41 +239,17 @@ xfs_attri_item_release(
 STATIC struct xfs_attri_log_item *
 xfs_attri_init(
 	struct xfs_mount		*mp,
-	uint32_t			name_len,
-	uint32_t			value_len)
-
+	struct xfs_attri_log_nameval	*anvl)
 {
 	struct xfs_attri_log_item	*attrip;
-	uint32_t			buffer_size = name_len + value_len;
 
-	if (buffer_size) {
-		/*
-		 * This could be over 64kB in length, so we have to use
-		 * kvmalloc() for this. But kvmalloc() utterly sucks, so we
-		 * use own version.
-		 */
-		attrip = xlog_kvmalloc(sizeof(struct xfs_attri_log_item) +
-					buffer_size);
-	} else {
-		attrip = kmem_cache_alloc(xfs_attri_cache,
-					GFP_NOFS | __GFP_NOFAIL);
-	}
-	memset(attrip, 0, sizeof(struct xfs_attri_log_item));
+	attrip = kmem_cache_zalloc(xfs_attri_cache, GFP_NOFS | __GFP_NOFAIL);
 
-	attrip->attri_name_len = name_len;
-	if (name_len)
-		attrip->attri_name = ((char *)attrip) +
-				sizeof(struct xfs_attri_log_item);
-	else
-		attrip->attri_name = NULL;
-
-	attrip->attri_value_len = value_len;
-	if (value_len)
-		attrip->attri_value = ((char *)attrip) +
-				sizeof(struct xfs_attri_log_item) +
-				name_len;
-	else
-		attrip->attri_value = NULL;
+	/*
+	 * Grab an extra reference to the name/value buffer for this log item.
+	 * The caller retains its own reference!
+	 */
+	attrip->attri_nameval = xfs_attri_log_nameval_get(anvl);
 
 	xfs_log_item_init(mp, &attrip->attri_item, XFS_LI_ATTRI,
 			  &xfs_attri_item_ops);
@@ -335,7 +392,7 @@ STATIC void
 xfs_attr_log_item(
 	struct xfs_trans		*tp,
 	struct xfs_attri_log_item	*attrip,
-	struct xfs_attr_item		*attr)
+	const struct xfs_attr_item	*attr)
 {
 	struct xfs_attri_log_format	*attrp;
 
@@ -351,17 +408,10 @@ xfs_attr_log_item(
 	attrp->alfi_ino = attr->xattri_da_args->dp->i_ino;
 	ASSERT(!(attr->xattri_op_flags & ~XFS_ATTR_OP_FLAGS_TYPE_MASK));
 	attrp->alfi_op_flags = attr->xattri_op_flags;
-	attrp->alfi_value_len = attr->xattri_da_args->valuelen;
-	attrp->alfi_name_len = attr->xattri_da_args->namelen;
+	attrp->alfi_value_len = attr->xattri_nameval->anvl_value_len;
+	attrp->alfi_name_len = attr->xattri_nameval->anvl_name_len;
 	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
 	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
-
-	memcpy(attrip->attri_name, attr->xattri_da_args->name,
-	       attr->xattri_da_args->namelen);
-	memcpy(attrip->attri_value, attr->xattri_da_args->value,
-	       attr->xattri_da_args->valuelen);
-	attrip->attri_name_len = attr->xattri_da_args->namelen;
-	attrip->attri_value_len = attr->xattri_da_args->valuelen;
 }
 
 /* Get an ATTRI. */
@@ -385,16 +435,33 @@ xfs_attr_create_intent(
 	 * Each attr item only performs one attribute operation at a time, so
 	 * this is a list of one
 	 */
-	list_for_each_entry(attr, items, xattri_list) {
-		attrip = xfs_attri_init(mp, attr->xattri_da_args->namelen,
-					attr->xattri_da_args->valuelen);
-		if (attrip == NULL)
-			return NULL;
+	attr = list_first_entry_or_null(items, struct xfs_attr_item,
+			xattri_list);
 
-		xfs_trans_add_item(tp, &attrip->attri_item);
-		xfs_attr_log_item(tp, attrip, attr);
+	/*
+	 * Create a buffer to store the attribute name and value.  This buffer
+	 * will be shared between the higher level deferred xattr work state
+	 * and the lower level xattr log items.
+	 */
+	if (!attr->xattri_nameval) {
+		struct xfs_da_args	*args = attr->xattri_da_args;
+
+		/*
+		 * Transfer our reference to the name/value buffer to the
+		 * deferred work state structure.
+		 */
+		attr->xattri_nameval = xfs_attri_log_nameval_alloc(args->name,
+				args->namelen, args->value, args->valuelen);
+	}
+	if (!attr->xattri_nameval) {
+		xlog_force_shutdown(mp->m_log, SHUTDOWN_LOG_IO_ERROR);
+		return NULL;
 	}
 
+	attrip = xfs_attri_init(mp, attr->xattri_nameval);
+	xfs_trans_add_item(tp, &attrip->attri_item);
+	xfs_attr_log_item(tp, attrip, attr);
+
 	return &attrip->attri_item;
 }
 
@@ -404,6 +471,8 @@ xfs_attr_free_item(
 {
 	if (attr->xattri_da_state)
 		xfs_da_state_free(attr->xattri_da_state);
+	if (attr->xattri_nameval)
+		xfs_attri_log_nameval_put(attr->xattri_nameval);
 	kmem_free(attr);
 }
 
@@ -455,29 +524,6 @@ xfs_attr_cancel_item(
 	xfs_attr_free_item(attr);
 }
 
-STATIC xfs_lsn_t
-xfs_attri_item_committed(
-	struct xfs_log_item		*lip,
-	xfs_lsn_t			lsn)
-{
-	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
-
-	/*
-	 * The attrip refers to xfs_attr_item memory to log the name and value
-	 * with the intent item. This already occurred when the intent was
-	 * committed so these fields are no longer accessed. Clear them out of
-	 * caution since we're about to free the xfs_attr_item.
-	 */
-	attrip->attri_name = NULL;
-	attrip->attri_value = NULL;
-
-	/*
-	 * The ATTRI is logged only once and cannot be moved in the log, so
-	 * simply return the lsn at which it's been logged.
-	 */
-	return lsn;
-}
-
 STATIC bool
 xfs_attri_item_match(
 	struct xfs_log_item	*lip,
@@ -541,6 +587,7 @@ xfs_attri_item_recover(
 	struct xfs_trans		*tp;
 	struct xfs_trans_res		tres;
 	struct xfs_attri_log_format	*attrp;
+	struct xfs_attri_log_nameval	*anvl = attrip->attri_nameval;
 	int				error, ret = 0;
 	int				total;
 	int				local;
@@ -552,7 +599,8 @@ xfs_attri_item_recover(
 	 */
 	attrp = &attrip->attri_format;
 	if (!xfs_attri_validate(mp, attrp) ||
-	    !xfs_attr_namecheck(attrip->attri_name, attrip->attri_name_len))
+	    !xfs_attr_namecheck(xfs_attri_log_namebuf(attrip),
+			anvl->anvl_name_len))
 		return -EFSCORRUPTED;
 
 	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
@@ -567,10 +615,17 @@ xfs_attri_item_recover(
 	attr->xattri_op_flags = attrp->alfi_op_flags &
 						XFS_ATTR_OP_FLAGS_TYPE_MASK;
 
+	/*
+	 * We're reconstructing the deferred work state structure from the
+	 * recovered log item.  Grab a reference to the name/value buffer and
+	 * attach it to the new work state.
+	 */
+	attr->xattri_nameval = xfs_attri_log_nameval_get(anvl);
+
 	args->dp = ip;
 	args->geo = mp->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
-	args->name = attrip->attri_name;
+	args->name = xfs_attri_log_namebuf(attrip);
 	args->namelen = attrp->alfi_name_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
@@ -579,7 +634,7 @@ xfs_attri_item_recover(
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTR_OP_FLAGS_SET:
 	case XFS_ATTR_OP_FLAGS_REPLACE:
-		args->value = attrip->attri_value;
+		args->value = xfs_attri_log_valbuf(attrip);
 		args->valuelen = attrp->alfi_value_len;
 		args->total = xfs_attr_calc_size(args, &local);
 		if (xfs_inode_hasattr(args->dp))
@@ -654,8 +709,11 @@ xfs_attri_item_relog(
 	attrdp = xfs_trans_get_attrd(tp, old_attrip);
 	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
 
-	new_attrip = xfs_attri_init(tp->t_mountp, old_attrp->alfi_name_len,
-				    old_attrp->alfi_value_len);
+	/*
+	 * Create a new log item that shares the same name/value buffer as the
+	 * old log item.
+	 */
+	new_attrip = xfs_attri_init(tp->t_mountp, old_attrip->attri_nameval);
 	new_attrp = &new_attrip->attri_format;
 
 	new_attrp->alfi_ino = old_attrp->alfi_ino;
@@ -664,13 +722,6 @@ xfs_attri_item_relog(
 	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
-	memcpy(new_attrip->attri_name, old_attrip->attri_name,
-		new_attrip->attri_name_len);
-
-	if (new_attrip->attri_value_len > 0)
-		memcpy(new_attrip->attri_value, old_attrip->attri_value,
-		       new_attrip->attri_value_len);
-
 	xfs_trans_add_item(tp, &new_attrip->attri_item);
 	set_bit(XFS_LI_DIRTY, &new_attrip->attri_item.li_flags);
 
@@ -684,14 +735,15 @@ xlog_recover_attri_commit_pass2(
 	struct xlog_recover_item        *item,
 	xfs_lsn_t                       lsn)
 {
-	int                             error;
 	struct xfs_mount                *mp = log->l_mp;
 	struct xfs_attri_log_item       *attrip;
 	struct xfs_attri_log_format     *attri_formatp;
+	struct xfs_attri_log_nameval	*anvl;
+	const void			*attr_value = NULL;
 	const void			*attr_name;
-	int				region = 0;
+	int                             error;
 
-	attri_formatp = item->ri_buf[region].i_addr;
+	attri_formatp = item->ri_buf[0].i_addr;
 	attr_name = item->ri_buf[1].i_addr;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
@@ -705,27 +757,25 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
-	/* memory alloc failure will cause replay to abort */
-	attrip = xfs_attri_init(mp, attri_formatp->alfi_name_len,
-				attri_formatp->alfi_value_len);
-	if (attrip == NULL)
+	if (attri_formatp->alfi_value_len)
+		attr_value = item->ri_buf[2].i_addr;
+
+	/*
+	 * Memory alloc failure will cause replay to abort.  We attach the
+	 * name/value buffer to the recovered incore log item and drop our
+	 * reference.
+	 */
+	anvl = xfs_attri_log_nameval_alloc(attr_name,
+			attri_formatp->alfi_name_len, attr_value,
+			attri_formatp->alfi_value_len);
+	if (!anvl)
 		return -ENOMEM;
 
-	error = xfs_attri_copy_format(&item->ri_buf[region],
-				      &attrip->attri_format);
+	attrip = xfs_attri_init(mp, anvl);
+	error = xfs_attri_copy_format(&item->ri_buf[0], &attrip->attri_format);
 	if (error)
 		goto out;
 
-	region++;
-	memcpy(attrip->attri_name, item->ri_buf[region].i_addr,
-	       attrip->attri_name_len);
-
-	if (attrip->attri_value_len > 0) {
-		region++;
-		memcpy(attrip->attri_value, item->ri_buf[region].i_addr,
-		       attrip->attri_value_len);
-	}
-
 	/*
 	 * The ATTRI has two references. One for the ATTRD and one for ATTRI to
 	 * ensure it makes it into the AIL. Insert the ATTRI into the AIL
@@ -734,9 +784,11 @@ xlog_recover_attri_commit_pass2(
 	 */
 	xfs_trans_ail_insert(log->l_ailp, &attrip->attri_item, lsn);
 	xfs_attri_release(attrip);
+	xfs_attri_log_nameval_put(anvl);
 	return 0;
 out:
 	xfs_attri_item_free(attrip);
+	xfs_attri_log_nameval_put(anvl);
 	return error;
 }
 
@@ -816,7 +868,6 @@ static const struct xfs_item_ops xfs_attri_item_ops = {
 	.iop_size	= xfs_attri_item_size,
 	.iop_format	= xfs_attri_item_format,
 	.iop_unpin	= xfs_attri_item_unpin,
-	.iop_committed	= xfs_attri_item_committed,
 	.iop_release    = xfs_attri_item_release,
 	.iop_recover	= xfs_attri_item_recover,
 	.iop_match	= xfs_attri_item_match,
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index c3b779f82adb..2475e68712e1 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -11,6 +11,14 @@
 struct xfs_mount;
 struct kmem_zone;
 
+struct xfs_attri_log_nameval {
+	refcount_t		anvl_refcount;
+	unsigned int		anvl_name_len;
+	unsigned int		anvl_value_len;
+
+	/* name and value follow the end of this struct */
+};
+
 /*
  * This is the "attr intention" log item.  It is used to log the fact that some
  * extended attribute operations need to be processed.  An operation is
@@ -26,10 +34,7 @@ struct kmem_zone;
 struct xfs_attri_log_item {
 	struct xfs_log_item		attri_item;
 	atomic_t			attri_refcount;
-	int				attri_name_len;
-	int				attri_value_len;
-	void				*attri_name;
-	void				*attri_value;
+	struct xfs_attri_log_nameval	*attri_nameval;
 	struct xfs_attri_log_format	attri_format;
 };
 

