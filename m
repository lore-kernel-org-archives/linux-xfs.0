Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD6FC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 18:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241676AbiERSzN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 14:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241694AbiERSzN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:55:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77818230203
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:55:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02AFEB821AE
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA510C385A5;
        Wed, 18 May 2022 18:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900108;
        bh=7eupvoj6nl881BfnzWGEnTUmAjDf+xeua0GlA5V6+JE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XrZt6dTZkgLyydldBRha5lvoOogHGw6t6GQa5JBGd5+/mrAvQdDx4OwX88F9+npU8
         cb4cwhxaTQ01KkSoUIIQiwr5Ngko2c/kcaF6y4qKviIIEdjg3wOkyDpujQLn8fvcxz
         sBLMXlDyvt68hYs98uEO/AKV9kw2TlBRTeDhU5Q1VOhYoYiIaW6G+XiOOze0gPVUy1
         YSzxaTU5oEBZYFKdiBVNekhfaTL+RyriC6fim9cVzjXDpi7mn3DHdfJv3pbsU3N0V4
         mYbWA9159ByzjmT+GbmBuMGU2ThWHatQOKNGgDP2aYxn/rS7t+ZQTvD9hY6zeFrFSq
         qKw2jz450TWjw==
Subject: [PATCH 1/3] xfs: validate xattr name earlier in recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Wed, 18 May 2022 11:55:08 -0700
Message-ID: <165290010814.1646163.10353057311329638248.stgit@magnolia>
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

When we're validating a recovered xattr log item during log recovery, we
should check the name before starting to allocate resources.  This isn't
strictly necessary on its own, but it means that we won't bother with
huge memory allocations during recovery if the attr name is garbage,
which will simplify the changes in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index fd0a74f3ef45..4976b1ddc09f 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -688,16 +688,23 @@ xlog_recover_attri_commit_pass2(
 	struct xfs_mount                *mp = log->l_mp;
 	struct xfs_attri_log_item       *attrip;
 	struct xfs_attri_log_format     *attri_formatp;
+	const void			*attr_name;
 	int				region = 0;
 
 	attri_formatp = item->ri_buf[region].i_addr;
+	attr_name = item->ri_buf[1].i_addr;
 
-	/* Validate xfs_attri_log_format */
+	/* Validate xfs_attri_log_format before the large memory allocation */
 	if (!xfs_attri_validate(mp, attri_formatp)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
 	}
 
+	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		return -EFSCORRUPTED;
+	}
+
 	/* memory alloc failure will cause replay to abort */
 	attrip = xfs_attri_init(mp, attri_formatp->alfi_name_len,
 				attri_formatp->alfi_value_len);
@@ -713,12 +720,6 @@ xlog_recover_attri_commit_pass2(
 	memcpy(attrip->attri_name, item->ri_buf[region].i_addr,
 	       attrip->attri_name_len);
 
-	if (!xfs_attr_namecheck(attrip->attri_name, attrip->attri_name_len)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
-		error = -EFSCORRUPTED;
-		goto out;
-	}
-
 	if (attrip->attri_value_len > 0) {
 		region++;
 		memcpy(attrip->attri_value, item->ri_buf[region].i_addr,

