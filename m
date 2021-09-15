Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E38BDC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8510600D4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbhIOXJW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:09:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbhIOXJV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:09:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5966D610A4;
        Wed, 15 Sep 2021 23:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747282;
        bh=7FY3VybeEg0GsLxKD3vC1JzL81cVZMRFjjPIWnf/k0g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FjOnPyNWZIzhlSYb0kbCAnwBlrrTNb20hL6XZ9XZKsQB/2UDWavQ1JanSJ24ytYfa
         QJFg3xelaz64SHxOnBg3BCgwzmpnZqrTXV2EqSIwGtz7bO07f1g7WcRRce8R9ydTZC
         wzDG3rxozaR8+y0J0Uab/xIt8cseCQJLoQtG63yKIchVg6t4gXDDPxMmcE7Jz9W6vk
         9U+AR5X98aezXHRU4gIuTK8ohQIMWQZJN+c6n7oWL9jk/pJ6wfkj++7/WyfoSiOcbp
         MSnNyJXocfnNWuBiIbRw9kr3dTHBmbmPj+Qp8ojAeamVbU8OxgI34Okuq1gRZvk/MI
         dxOMinkK4VIQg==
Subject: [PATCH 16/61] xfs: Hoist node transaction handling
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:08:02 -0700
Message-ID: <163174728207.350433.13984438810322865065.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 3f562d092bb1edd39bfc0e6808d7108d47f8aa3a

This patch basically hoists the node transaction handling around the
leaf code we just hoisted.  This will helps setup this area for the
state machine since the goto is easily replaced with a state since it
ends with a transaction roll.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c |   55 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 26 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 9dc518a3..118ec0b4 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -309,10 +309,36 @@ xfs_attr_set_args(
 
 	if (xfs_attr_is_leaf(dp)) {
 		error = xfs_attr_leaf_try_add(args, bp);
-		if (error == -ENOSPC)
+		if (error == -ENOSPC) {
+			/*
+			 * Promote the attribute list to the Btree format.
+			 */
+			error = xfs_attr3_leaf_to_node(args);
+			if (error)
+				return error;
+
+			/*
+			 * Finish any deferred work items and roll the transaction once
+			 * more.  The goal here is to call node_addname with the inode
+			 * and transaction in the same state (inode locked and joined,
+			 * transaction clean) no matter how we got to this step.
+			 */
+			error = xfs_defer_finish(&args->trans);
+			if (error)
+				return error;
+
+			/*
+			 * Commit the current trans (including the inode) and
+			 * start a new one.
+			 */
+			error = xfs_trans_roll_inode(&args->trans, dp);
+			if (error)
+				return error;
+
 			goto node;
-		else if (error)
+		} else if (error) {
 			return error;
+		}
 
 		/*
 		 * Commit the transaction that added the attr name so that
@@ -402,32 +428,9 @@ xfs_attr_set_args(
 			/* bp is gone due to xfs_da_shrink_inode */
 
 		return error;
+	}
 node:
-		/*
-		 * Promote the attribute list to the Btree format.
-		 */
-		error = xfs_attr3_leaf_to_node(args);
-		if (error)
-			return error;
 
-		/*
-		 * Finish any deferred work items and roll the transaction once
-		 * more.  The goal here is to call node_addname with the inode
-		 * and transaction in the same state (inode locked and joined,
-		 * transaction clean) no matter how we got to this step.
-		 */
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
-
-		/*
-		 * Commit the current trans (including the inode) and
-		 * start a new one.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
-	}
 
 	do {
 		error = xfs_attr_node_addname_find_attr(args, &state);

