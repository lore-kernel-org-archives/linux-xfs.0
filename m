Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE462C67871
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 23:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbiJXXNP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 19:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiJXXMv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 19:12:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F00194F90
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 14:33:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA2A4B80D99
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 21:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D54C433D6;
        Mon, 24 Oct 2022 21:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666647174;
        bh=iXUsf6elovPqzrpMsnim9Iby3kj3wLrGOSNtrLroRmI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HhN6OS43M5gAfoT6d0r3w+ohJYjstzMMNcEYCgtmyeubh1Z/BdQNWslNqfi4GgbTk
         mns/yA8VfRcXF9hcqKvW8WXljjvkWNU/oOWRR1Q2WmCb/Yljll8IiaJaD2XWaF/S3H
         EMHug0VlRwvGklMdvn3TE5YQWueIaPwuXgmCnQwV6hjQAz0sj6004y4QIKGrA5zEww
         cwi4j2crvnuGVqaQSNLrQLAhpsKysiH/9Z7Wzh/jpa4sBUfU6/sFN1EznSMdDZh6TA
         p86YxgI4D5L4X7r8h9iglzZVLww5o/pz9fw2i3ZUHf1dpBJDLk1gLjeXAGf1qV7Elp
         7CBMNUPQ+XEvA==
Subject: [PATCH 4/6] xfs: fix memcpy fortify errors in RUI log format copying
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Mon, 24 Oct 2022 14:32:54 -0700
Message-ID: <166664717418.2688790.4324481950746749054.stgit@magnolia>
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

Starting in 6.1, CONFIG_FORTIFY_SOURCE checks the length parameter of
memcpy.  Since we're already fixing problems with BUI item copying, we
should fix it everything else.

Refactor the xfs_rui_copy_format function to handle the copying of the
head and the flex array members separately.  While we're at it, fix a
minor validation deficiency in the recovery function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ondisk.h    |    3 ++
 fs/xfs/xfs_rmap_item.c |   58 ++++++++++++++++++++++--------------------------
 2 files changed, 30 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index e20d2844b0c5..19c1df00b48e 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -138,11 +138,14 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bud_log_format,	16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_cui_log_format,	16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_cud_log_format,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rui_log_format,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rud_log_format,	16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_map_extent,		32);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_phys_extent,		16);
 
 	XFS_CHECK_OFFSET(struct xfs_bui_log_format, bui_extents,	16);
 	XFS_CHECK_OFFSET(struct xfs_cui_log_format, cui_extents,	16);
+	XFS_CHECK_OFFSET(struct xfs_rui_log_format, rui_extents,	16);
 
 	/*
 	 * The v5 superblock format extended several v4 header structures with
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index fef92e02f3bb..27047e73f582 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -155,31 +155,6 @@ xfs_rui_init(
 	return ruip;
 }
 
-/*
- * Copy an RUI format buffer from the given buf, and into the destination
- * RUI format structure.  The RUI/RUD items were designed not to need any
- * special alignment handling.
- */
-STATIC int
-xfs_rui_copy_format(
-	struct xfs_log_iovec		*buf,
-	struct xfs_rui_log_format	*dst_rui_fmt)
-{
-	struct xfs_rui_log_format	*src_rui_fmt;
-	uint				len;
-
-	src_rui_fmt = buf->i_addr;
-	len = xfs_rui_log_format_sizeof(src_rui_fmt->rui_nextents);
-
-	if (buf->i_len != len) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
-		return -EFSCORRUPTED;
-	}
-
-	memcpy(dst_rui_fmt, src_rui_fmt, len);
-	return 0;
-}
-
 static inline struct xfs_rud_log_item *RUD_ITEM(struct xfs_log_item *lip)
 {
 	return container_of(lip, struct xfs_rud_log_item, rud_item);
@@ -652,6 +627,20 @@ static const struct xfs_item_ops xfs_rui_item_ops = {
 	.iop_relog	= xfs_rui_item_relog,
 };
 
+static inline void
+xfs_rui_copy_format(
+	struct xfs_rui_log_format	*dst,
+	const struct xfs_rui_log_format	*src)
+{
+	unsigned int			i;
+
+	memcpy(dst, src, offsetof(struct xfs_rui_log_format, rui_extents));
+
+	for (i = 0; i < src->rui_nextents; i++)
+		memcpy(&dst->rui_extents[i], &src->rui_extents[i],
+				sizeof(struct xfs_map_extent));
+}
+
 /*
  * This routine is called to create an in-core extent rmap update
  * item from the rui format structure which was logged on disk.
@@ -666,19 +655,26 @@ xlog_recover_rui_commit_pass2(
 	struct xlog_recover_item	*item,
 	xfs_lsn_t			lsn)
 {
-	int				error;
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_rui_log_item		*ruip;
 	struct xfs_rui_log_format	*rui_formatp;
+	size_t				len;
 
 	rui_formatp = item->ri_buf[0].i_addr;
 
+	if (item->ri_buf[0].i_len < xfs_rui_log_format_sizeof(0)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+
+	len = xfs_rui_log_format_sizeof(rui_formatp->rui_nextents);
+	if (item->ri_buf[0].i_len != len) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+
 	ruip = xfs_rui_init(mp, rui_formatp->rui_nextents);
-	error = xfs_rui_copy_format(&item->ri_buf[0], &ruip->rui_format);
-	if (error) {
-		xfs_rui_item_free(ruip);
-		return error;
-	}
+	xfs_rui_copy_format(&ruip->rui_format, rui_formatp);
 	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
 	/*
 	 * Insert the intent into the AIL directly and drop one reference so

