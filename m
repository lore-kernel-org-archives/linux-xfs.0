Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D8B7C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 03:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239679AbiEPDcx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 May 2022 23:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239670AbiEPDcp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 May 2022 23:32:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7431FCC1
        for <linux-xfs@vger.kernel.org>; Sun, 15 May 2022 20:32:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0DF6B80E7D
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 03:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A77BC385B8;
        Mon, 16 May 2022 03:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652671961;
        bh=XeHP+e1l9cfe4zJ7gfqjuczINtJvsxdvRLtV2YUUMv4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ktNj6ToXYaOurRxYuVv9I9wH8Jvt9onrd2QKKZbQKQx1szSOsRmBq4+00RQMX1H4b
         5bpjLflknsqQaW5jfiqGyNGaYrshV/ypKO80knXLpeTb7OSFv8EhgCOE9krgkn02xq
         9qOjz28mfuYvKxA1QCIIgDW+ct9DAjJaxk2/7rvGnvRDO9m3nlWeqSow2PB83+Vdk2
         D2QRr6/8Ewsd2kvjwbCcz1Z2f6IVgD7KslZGQ8q2WX7iTaQslwb96JIYwt/+/VeIT0
         2fn0djAVQAwNDXZzvvjjdlt8lij4Iw6Lr5cJtKSEf1znU779slmlsPjrqjNweuqm/H
         wJopyEe2notpA==
Subject: [PATCH 4/6] xfs: remove struct xfs_attr_item.xattri_flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 15 May 2022 20:32:40 -0700
Message-ID: <165267196090.626272.13190997050322531901.stgit@magnolia>
In-Reply-To: <165267193834.626272.10112290406449975166.stgit@magnolia>
References: <165267193834.626272.10112290406449975166.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Nobody uses this field, so get rid of it and the unused flag definition.
Rearrange the structure layout to reduce its size from 96 to 88 bytes.
This gets us from 42 to 46 objects per page.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.h |   32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index cb3b3d270569..f0b93515c1e8 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -501,15 +501,19 @@ enum xfs_delattr_state {
 	{ XFS_DAS_NODE_REMOVE_ATTR,	"XFS_DAS_NODE_REMOVE_ATTR" }, \
 	{ XFS_DAS_DONE,			"XFS_DAS_DONE" }
 
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
@@ -517,16 +521,7 @@ struct xfs_attr_item {
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
@@ -534,11 +529,10 @@ struct xfs_attr_item {
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
 
 

