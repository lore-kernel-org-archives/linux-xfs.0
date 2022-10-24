Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D5CC38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 23:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiJXXNR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 19:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiJXXMx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 19:12:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF5F11A95D
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 14:33:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AE4C615C0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 21:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0A2C433C1;
        Mon, 24 Oct 2022 21:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666647169;
        bh=ynChhIDBTd3Lfj6v55rhfJGSbhTRYKmVYG6cwRP+678=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EgvB7+hrgs9jaL+w4jPPCkqELYNF8fR41CBre3GXU6/d1bCNF2Jeko6jCkPb4jpjk
         Hgm5VHm2J8XoEwVPqrQ0tKthrFGvEL5UQ+Ps02qPRj9N/FjxGOsR7yv0iJe5swvVaR
         gfc4pcp5VFO7Li1cWs+eGeTp0eOWzCDNid450a1JNFRLPdAg7/bEOK6wPLsurz5DR9
         p5I2245KvL9W2ioQGR/hrF+4tRs40w4QmFZt/FJDWgL0Qntx+9FSoM4D6O8iw3XlVM
         xHy0GqWSzaDOEsnmBLMDKIK+wMN5zXZxa4I0N9CCWgPloI0s2oLM4LH/9rIVjZIsXB
         ctXdhLktTxLsg==
Subject: [PATCH 3/6] xfs: fix memcpy fortify errors in CUI log format copying
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Mon, 24 Oct 2022 14:32:48 -0700
Message-ID: <166664716856.2688790.1609211323933786255.stgit@magnolia>
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

Refactor the xfs_cui_copy_format function to handle the copying of the
head and the flex array members separately.  While we're at it, fix a
minor validation deficiency in the recovery function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ondisk.h        |    4 ++++
 fs/xfs/xfs_refcount_item.c |   45 +++++++++++++++++++++-----------------------
 2 files changed, 25 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 56917e236370..e20d2844b0c5 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -136,9 +136,13 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bui_log_format,	16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bud_log_format,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_cui_log_format,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_cud_log_format,	16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_map_extent,		32);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_phys_extent,		16);
 
 	XFS_CHECK_OFFSET(struct xfs_bui_log_format, bui_extents,	16);
+	XFS_CHECK_OFFSET(struct xfs_cui_log_format, cui_extents,	16);
 
 	/*
 	 * The v5 superblock format extended several v4 header structures with
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 7e97bf19793d..24cf4c64ebaa 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -622,28 +622,18 @@ static const struct xfs_item_ops xfs_cui_item_ops = {
 	.iop_relog	= xfs_cui_item_relog,
 };
 
-/*
- * Copy an CUI format buffer from the given buf, and into the destination
- * CUI format structure.  The CUI/CUD items were designed not to need any
- * special alignment handling.
- */
-static int
+static inline void
 xfs_cui_copy_format(
-	struct xfs_log_iovec		*buf,
-	struct xfs_cui_log_format	*dst_cui_fmt)
+	struct xfs_cui_log_format	*dst,
+	const struct xfs_cui_log_format	*src)
 {
-	struct xfs_cui_log_format	*src_cui_fmt;
-	uint				len;
+	unsigned int			i;
 
-	src_cui_fmt = buf->i_addr;
-	len = xfs_cui_log_format_sizeof(src_cui_fmt->cui_nextents);
+	memcpy(dst, src, offsetof(struct xfs_cui_log_format, cui_extents));
 
-	if (buf->i_len == len) {
-		memcpy(dst_cui_fmt, src_cui_fmt, len);
-		return 0;
-	}
-	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
-	return -EFSCORRUPTED;
+	for (i = 0; i < src->cui_nextents; i++)
+		memcpy(&dst->cui_extents[i], &src->cui_extents[i],
+				sizeof(struct xfs_phys_extent));
 }
 
 /*
@@ -660,19 +650,26 @@ xlog_recover_cui_commit_pass2(
 	struct xlog_recover_item	*item,
 	xfs_lsn_t			lsn)
 {
-	int				error;
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_cui_log_item		*cuip;
 	struct xfs_cui_log_format	*cui_formatp;
+	size_t				len;
 
 	cui_formatp = item->ri_buf[0].i_addr;
 
+	if (item->ri_buf[0].i_len < xfs_cui_log_format_sizeof(0)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+
+	len = xfs_cui_log_format_sizeof(cui_formatp->cui_nextents);
+	if (item->ri_buf[0].i_len != len) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+
 	cuip = xfs_cui_init(mp, cui_formatp->cui_nextents);
-	error = xfs_cui_copy_format(&item->ri_buf[0], &cuip->cui_format);
-	if (error) {
-		xfs_cui_item_free(cuip);
-		return error;
-	}
+	xfs_cui_copy_format(&cuip->cui_format, cui_formatp);
 	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
 	/*
 	 * Insert the intent into the AIL directly and drop one reference so

