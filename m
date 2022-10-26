Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C86BFA3743
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 20:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbiJZUIB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Oct 2022 16:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234485AbiJZUHy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 16:07:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6099136437
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 13:07:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90FC9B82443
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 20:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C6EC433D7;
        Wed, 26 Oct 2022 20:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666814870;
        bh=YhDJUBCWUA9OxHqtrtqO6voiv/EfEu+N4JjCUvZGIvY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=paN+/8JrQfbkMGN36jDddx7+q8oZCCHM5w5BOoyUahH9EgbHBtja/O5UHjc3pGekd
         8OLV+P54kOjE7QjbXIShssDDEE1pM4rSEX7k3cIKwmxcifWW2Y6TlTh2hChjz1myYg
         mW5Qju+FSDWn8n3C5Yig6+w4pasg9mIAqRDMvjSderCZKxkhkHnCYMvMEGvRgXVbEZ
         Mt81uttvtBGFseaYe2h0T6Q8u0CXmyeir9BLtWa3/pGgqLtXH2XTBgXDRVpC6DT/+b
         EAM0kZsEx9gifjIwsGx+xSByp25jV5r5kp+wYkniV1JO1qN/5iyKw3dFmnR6V/uM7W
         eKcqgRCSe9mKA==
Subject: [PATCH 3/8] xfs: fix memcpy fortify errors in CUI log format copying
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, allison.henderson@oracle.com
Date:   Wed, 26 Oct 2022 13:07:49 -0700
Message-ID: <166681486979.3447519.2776536799071796388.stgit@magnolia>
In-Reply-To: <166681485271.3447519.6520343630713202644.stgit@magnolia>
References: <166681485271.3447519.6520343630713202644.stgit@magnolia>
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
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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

