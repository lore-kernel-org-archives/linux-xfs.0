Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FACC38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 23:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiJXXNW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 19:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbiJXXNB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 19:13:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175801C77F5
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 14:34:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D434615B7
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 21:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FAEC433D6;
        Mon, 24 Oct 2022 21:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666647185;
        bh=+vGIOHbkmRYwsG9ydSMa4JWUySSm4pF8/EV5VD5O92o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HvAkDUZTdQhVt7gFvUMCH00vvpS/GAQB1rZXL0A5JpOSKd0/XMZoPMM1n/5SMB+Mp
         hxGxvujxSQwY+AypzlVF/Zt51ETJEfjRpjdeuQda8zdy9zTjNfm1s8P4LxEYTZiuNM
         879nI1THcJLFaXqxAHtphQk/2D6hFkSUvS5STSzqGV7Au1I36JxqXvUqXJ5nGy6JAX
         I+/yZerjsaSeCyxeKw8IqAqro5uf2uZRdvF5ujFJG4NrwGZgnbCoR8nN5nB2u7DicM
         pSX4VyWl9UkLoFs248szKGKMNKBsxoJRfdE5CEl/WOGoUIhplc7Xb0+fWS7558nMVu
         7zYtd35Z/1Bdw==
Subject: [PATCH 6/6] xfs: refactor all the EFI/EFD log item sizeof logic
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Mon, 24 Oct 2022 14:33:05 -0700
Message-ID: <166664718541.2688790.5847203715269286943.stgit@magnolia>
In-Reply-To: <166664715160.2688790.16712973829093762327.stgit@magnolia>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Refactor all the open-coded sizeof logic for EFI/EFD log item and log
format structures into common helper functions whose names reflect the
struct names.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_format.h |   48 ++++++++++++++++++++++++++++
 fs/xfs/xfs_extfree_item.c      |   69 ++++++++++++----------------------------
 fs/xfs/xfs_extfree_item.h      |   16 +++++++++
 fs/xfs/xfs_super.c             |   12 ++-----
 4 files changed, 88 insertions(+), 57 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 2f41fa8477c9..f13e0809dc63 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -616,6 +616,14 @@ typedef struct xfs_efi_log_format {
 	xfs_extent_t		efi_extents[];	/* array of extents to free */
 } xfs_efi_log_format_t;
 
+static inline size_t
+xfs_efi_log_format_sizeof(
+	unsigned int		nr)
+{
+	return sizeof(struct xfs_efi_log_format) +
+			nr * sizeof(struct xfs_extent);
+}
+
 typedef struct xfs_efi_log_format_32 {
 	uint16_t		efi_type;	/* efi log item type */
 	uint16_t		efi_size;	/* size of this item */
@@ -624,6 +632,14 @@ typedef struct xfs_efi_log_format_32 {
 	xfs_extent_32_t		efi_extents[];	/* array of extents to free */
 } __attribute__((packed)) xfs_efi_log_format_32_t;
 
+static inline size_t
+xfs_efi_log_format32_sizeof(
+	unsigned int		nr)
+{
+	return sizeof(struct xfs_efi_log_format_32) +
+			nr * sizeof(struct xfs_extent_32);
+}
+
 typedef struct xfs_efi_log_format_64 {
 	uint16_t		efi_type;	/* efi log item type */
 	uint16_t		efi_size;	/* size of this item */
@@ -632,6 +648,14 @@ typedef struct xfs_efi_log_format_64 {
 	xfs_extent_64_t		efi_extents[];	/* array of extents to free */
 } xfs_efi_log_format_64_t;
 
+static inline size_t
+xfs_efi_log_format64_sizeof(
+	unsigned int		nr)
+{
+	return sizeof(struct xfs_efi_log_format_64) +
+			nr * sizeof(struct xfs_extent_64);
+}
+
 /*
  * This is the structure used to lay out an efd log item in the
  * log.  The efd_extents array is a variable size array whose
@@ -645,6 +669,14 @@ typedef struct xfs_efd_log_format {
 	xfs_extent_t		efd_extents[];	/* array of extents freed */
 } xfs_efd_log_format_t;
 
+static inline size_t
+xfs_efd_log_format_sizeof(
+	unsigned int		nr)
+{
+	return sizeof(struct xfs_efd_log_format) +
+			nr * sizeof(struct xfs_extent);
+}
+
 typedef struct xfs_efd_log_format_32 {
 	uint16_t		efd_type;	/* efd log item type */
 	uint16_t		efd_size;	/* size of this item */
@@ -653,6 +685,14 @@ typedef struct xfs_efd_log_format_32 {
 	xfs_extent_32_t		efd_extents[];	/* array of extents freed */
 } __attribute__((packed)) xfs_efd_log_format_32_t;
 
+static inline size_t
+xfs_efd_log_format32_sizeof(
+	unsigned int		nr)
+{
+	return sizeof(struct xfs_efd_log_format_32) +
+			nr * sizeof(struct xfs_extent_32);
+}
+
 typedef struct xfs_efd_log_format_64 {
 	uint16_t		efd_type;	/* efd log item type */
 	uint16_t		efd_size;	/* size of this item */
@@ -661,6 +701,14 @@ typedef struct xfs_efd_log_format_64 {
 	xfs_extent_64_t		efd_extents[];	/* array of extents freed */
 } xfs_efd_log_format_64_t;
 
+static inline size_t
+xfs_efd_log_format64_sizeof(
+	unsigned int		nr)
+{
+	return sizeof(struct xfs_efd_log_format_64) +
+			nr * sizeof(struct xfs_extent_64);
+}
+
 /*
  * RUI/RUD (reverse mapping) log format definitions
  */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 466cc5c5cd33..bffb2b91e39a 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -66,27 +66,16 @@ xfs_efi_release(
 	xfs_efi_item_free(efip);
 }
 
-/*
- * This returns the number of iovecs needed to log the given efi item.
- * We only need 1 iovec for an efi item.  It just logs the efi_log_format
- * structure.
- */
-static inline int
-xfs_efi_item_sizeof(
-	struct xfs_efi_log_item *efip)
-{
-	return sizeof(struct xfs_efi_log_format) +
-	       efip->efi_format.efi_nextents * sizeof(xfs_extent_t);
-}
-
 STATIC void
 xfs_efi_item_size(
 	struct xfs_log_item	*lip,
 	int			*nvecs,
 	int			*nbytes)
 {
+	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
+
 	*nvecs += 1;
-	*nbytes += xfs_efi_item_sizeof(EFI_ITEM(lip));
+	*nbytes += xfs_efi_log_format_sizeof(efip->efi_format.efi_nextents);
 }
 
 /*
@@ -112,7 +101,7 @@ xfs_efi_item_format(
 
 	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_EFI_FORMAT,
 			&efip->efi_format,
-			xfs_efi_item_sizeof(efip));
+			xfs_efi_log_format_sizeof(efip->efi_format.efi_nextents));
 }
 
 
@@ -155,13 +144,11 @@ xfs_efi_init(
 
 {
 	struct xfs_efi_log_item	*efip;
-	uint			size;
 
 	ASSERT(nextents > 0);
 	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
-		size = (uint)(sizeof(struct xfs_efi_log_item) +
-			(nextents * sizeof(xfs_extent_t)));
-		efip = kmem_zalloc(size, 0);
+		efip = kmem_zalloc(xfs_efi_log_item_sizeof(nextents),
+				GFP_KERNEL | __GFP_NOFAIL);
 	} else {
 		efip = kmem_cache_zalloc(xfs_efi_cache,
 					 GFP_KERNEL | __GFP_NOFAIL);
@@ -188,12 +175,9 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
 {
 	xfs_efi_log_format_t *src_efi_fmt = buf->i_addr;
 	uint i;
-	uint len = sizeof(xfs_efi_log_format_t) +
-		src_efi_fmt->efi_nextents * sizeof(xfs_extent_t);
-	uint len32 = sizeof(xfs_efi_log_format_32_t) +
-		src_efi_fmt->efi_nextents * sizeof(xfs_extent_32_t);
-	uint len64 = sizeof(xfs_efi_log_format_64_t) +
-		src_efi_fmt->efi_nextents * sizeof(xfs_extent_64_t);
+	uint len = xfs_efi_log_format_sizeof(src_efi_fmt->efi_nextents);
+	uint len32 = xfs_efi_log_format32_sizeof(src_efi_fmt->efi_nextents);
+	uint len64 = xfs_efi_log_format64_sizeof(src_efi_fmt->efi_nextents);
 
 	if (buf->i_len == len) {
 		memcpy(dst_efi_fmt, src_efi_fmt,
@@ -251,27 +235,16 @@ xfs_efd_item_free(struct xfs_efd_log_item *efdp)
 		kmem_cache_free(xfs_efd_cache, efdp);
 }
 
-/*
- * This returns the number of iovecs needed to log the given efd item.
- * We only need 1 iovec for an efd item.  It just logs the efd_log_format
- * structure.
- */
-static inline int
-xfs_efd_item_sizeof(
-	struct xfs_efd_log_item *efdp)
-{
-	return sizeof(xfs_efd_log_format_t) +
-	       efdp->efd_format.efd_nextents * sizeof(xfs_extent_t);
-}
-
 STATIC void
 xfs_efd_item_size(
 	struct xfs_log_item	*lip,
 	int			*nvecs,
 	int			*nbytes)
 {
+	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
+
 	*nvecs += 1;
-	*nbytes += xfs_efd_item_sizeof(EFD_ITEM(lip));
+	*nbytes += xfs_efd_log_format_sizeof(efdp->efd_format.efd_nextents);
 }
 
 /*
@@ -296,7 +269,7 @@ xfs_efd_item_format(
 
 	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_EFD_FORMAT,
 			&efdp->efd_format,
-			xfs_efd_item_sizeof(efdp));
+			xfs_efd_log_format_sizeof(efdp->efd_format.efd_nextents));
 }
 
 /*
@@ -345,9 +318,8 @@ xfs_trans_get_efd(
 	ASSERT(nextents > 0);
 
 	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
-		efdp = kmem_zalloc(sizeof(struct xfs_efd_log_item) +
-				nextents * sizeof(struct xfs_extent),
-				0);
+		efdp = kmem_zalloc(xfs_efd_log_item_sizeof(nextents),
+				GFP_KERNEL | __GFP_NOFAIL);
 	} else {
 		efdp = kmem_cache_zalloc(xfs_efd_cache,
 					GFP_KERNEL | __GFP_NOFAIL);
@@ -738,8 +710,7 @@ xlog_recover_efi_commit_pass2(
 
 	efi_formatp = item->ri_buf[0].i_addr;
 
-	if (item->ri_buf[0].i_len <
-			offsetof(struct xfs_efi_log_format, efi_extents)) {
+	if (item->ri_buf[0].i_len < xfs_efi_log_format_sizeof(0)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 		return -EFSCORRUPTED;
 	}
@@ -782,10 +753,10 @@ xlog_recover_efd_commit_pass2(
 	struct xfs_efd_log_format	*efd_formatp;
 
 	efd_formatp = item->ri_buf[0].i_addr;
-	ASSERT((item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_32_t) +
-		(efd_formatp->efd_nextents * sizeof(xfs_extent_32_t)))) ||
-	       (item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_64_t) +
-		(efd_formatp->efd_nextents * sizeof(xfs_extent_64_t)))));
+	ASSERT(item->ri_buf[0].i_len == xfs_efd_log_format32_sizeof(
+						efd_formatp->efd_nextents) ||
+	       item->ri_buf[0].i_len == xfs_efd_log_format64_sizeof(
+						efd_formatp->efd_nextents));
 
 	xlog_recover_release_intent(log, XFS_LI_EFI, efd_formatp->efd_efi_id);
 	return 0;
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 186d0f2137f1..da6a5afa607c 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -52,6 +52,14 @@ struct xfs_efi_log_item {
 	xfs_efi_log_format_t	efi_format;
 };
 
+static inline size_t
+xfs_efi_log_item_sizeof(
+	unsigned int		nr)
+{
+	return offsetof(struct xfs_efi_log_item, efi_format) +
+			xfs_efi_log_format_sizeof(nr);
+}
+
 /*
  * This is the "extent free done" log item.  It is used to log
  * the fact that some extents earlier mentioned in an efi item
@@ -64,6 +72,14 @@ struct xfs_efd_log_item {
 	xfs_efd_log_format_t	efd_format;
 };
 
+static inline size_t
+xfs_efd_log_item_sizeof(
+	unsigned int		nr)
+{
+	return offsetof(struct xfs_efd_log_item, efd_format) +
+			xfs_efd_log_format_sizeof(nr);
+}
+
 /*
  * Max number of extents in fast allocation path.
  */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8485e3b37ca0..ee4b429a2f2c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2028,18 +2028,14 @@ xfs_init_caches(void)
 		goto out_destroy_trans_cache;
 
 	xfs_efd_cache = kmem_cache_create("xfs_efd_item",
-					(sizeof(struct xfs_efd_log_item) +
-					XFS_EFD_MAX_FAST_EXTENTS *
-					sizeof(struct xfs_extent)),
-					0, 0, NULL);
+			xfs_efd_log_item_sizeof(XFS_EFD_MAX_FAST_EXTENTS),
+			0, 0, NULL);
 	if (!xfs_efd_cache)
 		goto out_destroy_buf_item_cache;
 
 	xfs_efi_cache = kmem_cache_create("xfs_efi_item",
-					 (sizeof(struct xfs_efi_log_item) +
-					 XFS_EFI_MAX_FAST_EXTENTS *
-					 sizeof(struct xfs_extent)),
-					 0, 0, NULL);
+			xfs_efi_log_item_sizeof(XFS_EFI_MAX_FAST_EXTENTS),
+			0, 0, NULL);
 	if (!xfs_efi_cache)
 		goto out_destroy_efd_cache;
 

