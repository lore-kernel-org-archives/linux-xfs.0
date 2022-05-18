Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 642D7C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 18:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241735AbiERS4Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 14:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241770AbiERS4I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:56:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AC08E199
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:56:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C523761631
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317F9C385A9;
        Wed, 18 May 2022 18:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900167;
        bh=uXzVkEVu9hxp8lRVrukutojSJJlWz+VCaHf54Txvh+Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=M/NEggiL8eA48/piUCjDGo0WYqC7vyKA3GoN5qK4xJbT5Bp2XFpqJd6oeAKAMXj56
         mAb2+nnAq2kzHJ2nfp0Vyjm+hNyQk5L+Y++Z4/vl1sL8SNLsHrwKwRu8l+w7hgd9Md
         LxedqRu/Vbd19C+8GdtNqpptNVL66YCq6S19Mt99PC4L/AQnoxtvKIm4iV/+NSsR2l
         OLEvscycqpM2yxo02lFvE52vUY22IWzloUY8A5h8Sp93RpepqWHZsO6vpCv5LjL4O1
         oyHDE0l5mVDI+abGI2uzg3mAF8iHACRjCNj2OSDlth7nO3WSqasAJb3WT/s5HOkpcQ
         STiqBjRxw+RGg==
Subject: [PATCH 4/7] xfs: remove struct xfs_attr_item.xattri_flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Wed, 18 May 2022 11:56:06 -0700
Message-ID: <165290016673.1647637.1425622907766044312.stgit@magnolia>
In-Reply-To: <165290014409.1647637.4876706578208264219.stgit@magnolia>
References: <165290014409.1647637.4876706578208264219.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Nobody uses this field, so get rid of it and the unused flag definition.
Rearrange the structure layout to reduce its size from 104 to 96 bytes.
This gets us from 39 to 42 objects per page.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.h |   32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 0a3b010eb797..8053415666fa 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -503,15 +503,19 @@ enum xfs_delattr_state {
 
 struct xfs_attri_log_nameval;
 
-/*
- * Defines for xfs_attr_item.xattri_flags
- */
-#define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
-
 /*
  * Context used for keeping track of delayed attribute operations
  */
 struct xfs_attr_item {
+	/*
+	 * used to log this item to an intent containing a list of attrs to
+	 * commit later
+	 */
+	struct list_head		xattri_list;
+
+	/* Used in xfs_attr_node_removename to roll through removing blocks */
+	struct xfs_da_state		*xattri_da_state;
+
 	struct xfs_da_args		*xattri_da_args;
 
 	/*
@@ -525,16 +529,7 @@ struct xfs_attr_item {
 	 */
 	struct xfs_buf			*xattri_leaf_bp;
 
-	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
-	struct xfs_bmbt_irec		xattri_map;
-	xfs_dablk_t			xattri_lblkno;
-	int				xattri_blkcnt;
-
-	/* Used in xfs_attr_node_removename to roll through removing blocks */
-	struct xfs_da_state		*xattri_da_state;
-
 	/* Used to keep track of current state of delayed operation */
-	unsigned int			xattri_flags;
 	enum xfs_delattr_state		xattri_dela_state;
 
 	/*
@@ -542,11 +537,10 @@ struct xfs_attr_item {
 	 */
 	unsigned int			xattri_op_flags;
 
-	/*
-	 * used to log this item to an intent containing a list of attrs to
-	 * commit later
-	 */
-	struct list_head		xattri_list;
+	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
+	xfs_dablk_t			xattri_lblkno;
+	int				xattri_blkcnt;
+	struct xfs_bmbt_irec		xattri_map;
 };
 
 

