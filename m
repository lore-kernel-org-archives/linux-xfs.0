Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F87C67871
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 23:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiJXXNB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 19:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiJXXMn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 19:12:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E42790830
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 14:33:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E1D0615C9
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 21:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC984C433D6;
        Mon, 24 Oct 2022 21:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666647157;
        bh=CrT2K+wvG0r4qTaM0mShq1QWsWSyPvVsq3nQ8VKS4qc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KmKMqZswZgnw2s7Lwupv1PtwJ2x5geWWqYdLxiN2X60bAGSb377xyJ7lFJZT2szW0
         22xJvh5x4n+/QZ4zHsRXTtkRkPFmM/6Fp3tglB4pJeBCTYnQQd+lbwmjnbv06msdQM
         6yWyLGJYRBleXA4rd9Den6SDsrkfdiRdNIVY7mAybxkobE2gay8JhSyYP8HpPy9qgD
         jwaKamkPB2kUKujOlJEGBYYiX+wNHQmNCPpWgWF4mLxo2bbP13hjZ7LC5J2z9ykq0p
         3l/0WlmQ428tV3L80QNth+cxRDs1iSDfZd2y6XvrSlRwZqPLb6oWcVnaflh17YC4lv
         uGMGRL8owgnkg==
Subject: [PATCH 1/6] xfs: fix validation in attr log item recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Mon, 24 Oct 2022 14:32:37 -0700
Message-ID: <166664715731.2688790.9836328662603103847.stgit@magnolia>
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

Before we start fixing all the complaints about memcpy'ing log items
around, let's fix some inadequate validation in the xattr log item
recovery code and get rid of the (now trivial) copy_format function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |   54 ++++++++++++++++++++----------------------------
 1 file changed, 23 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index cf5ce607dc05..ee8f678a10a1 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -245,28 +245,6 @@ xfs_attri_init(
 	return attrip;
 }
 
-/*
- * Copy an attr format buffer from the given buf, and into the destination attr
- * format structure.
- */
-STATIC int
-xfs_attri_copy_format(
-	struct xfs_log_iovec		*buf,
-	struct xfs_attri_log_format	*dst_attr_fmt)
-{
-	struct xfs_attri_log_format	*src_attr_fmt = buf->i_addr;
-	size_t				len;
-
-	len = sizeof(struct xfs_attri_log_format);
-	if (buf->i_len != len) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
-		return -EFSCORRUPTED;
-	}
-
-	memcpy((char *)dst_attr_fmt, (char *)src_attr_fmt, len);
-	return 0;
-}
-
 static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct xfs_log_item *lip)
 {
 	return container_of(lip, struct xfs_attrd_log_item, attrd_item);
@@ -731,24 +709,44 @@ xlog_recover_attri_commit_pass2(
 	struct xfs_attri_log_nameval	*nv;
 	const void			*attr_value = NULL;
 	const void			*attr_name;
-	int                             error;
+	size_t				len;
 
 	attri_formatp = item->ri_buf[0].i_addr;
 	attr_name = item->ri_buf[1].i_addr;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
+	len = sizeof(struct xfs_attri_log_format);
+	if (item->ri_buf[0].i_len != len) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		return -EFSCORRUPTED;
+	}
+
 	if (!xfs_attri_validate(mp, attri_formatp)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
 	}
 
+	/* Validate the attr name */
+	if (item->ri_buf[1].i_len !=
+			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		return -EFSCORRUPTED;
+	}
+
 	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
 	}
 
-	if (attri_formatp->alfi_value_len)
+	/* Validate the attr value, if present */
+	if (attri_formatp->alfi_value_len != 0) {
+		if (item->ri_buf[2].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+			return -EFSCORRUPTED;
+		}
+
 		attr_value = item->ri_buf[2].i_addr;
+	}
 
 	/*
 	 * Memory alloc failure will cause replay to abort.  We attach the
@@ -760,9 +758,7 @@ xlog_recover_attri_commit_pass2(
 			attri_formatp->alfi_value_len);
 
 	attrip = xfs_attri_init(mp, nv);
-	error = xfs_attri_copy_format(&item->ri_buf[0], &attrip->attri_format);
-	if (error)
-		goto out;
+	memcpy(&attrip->attri_format, attri_formatp, len);
 
 	/*
 	 * The ATTRI has two references. One for the ATTRD and one for ATTRI to
@@ -774,10 +770,6 @@ xlog_recover_attri_commit_pass2(
 	xfs_attri_release(attrip);
 	xfs_attri_log_nameval_put(nv);
 	return 0;
-out:
-	xfs_attri_item_free(attrip);
-	xfs_attri_log_nameval_put(nv);
-	return error;
 }
 
 /*

