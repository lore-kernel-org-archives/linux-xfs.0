Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30980C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357781AbiATA13 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:27:29 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48824 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357790AbiATA12 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:27:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 616D5B81A85
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C555C340ED;
        Thu, 20 Jan 2022 00:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638446;
        bh=OUqDkAvdCzmaPUJc8Kg6qJKz2fkcWfq2TrBq9wMl/0c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KVj7uWUWieABNerDDAKRXO8Dv3Rv0Eau7F3qsYxxDvp9elQamHmdWjlzkqGkShOMi
         +Se0OuWn74bCCm6zWRCMUJKvdLo0+bDJ/ta880U3B46zyFCRvaAFXo7f01/VxUdVsH
         Hf/7ZziTZd5B/LQ9GyAPvxKR016Npqs/RfA7G1hm6ZaDaqA67vNuUKvWLjChaqOE48
         IUYH4UI8l/KJzs3+Q/IeHumsVZTwPI8+Hoe6IvIg/tSbMlW38elryygEnagAg5WKmx
         EsheuozIP7yM13YN0bfwG1gR7SYT5bcqjiM4hn8kH45KlQlNA7P/2eC7unTLsy4F7f
         mPIB4szR5RenA==
Subject: [PATCH 46/48] xfs: use swap() to make dabtree code cleaner
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Zeal Robot <zealci@zte.com.cn>,
        Yang Guang <yang.guang5@zte.com.cn>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:27:25 -0800
Message-ID: <164263844581.865554.18015260649075833934.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Yang Guang <yang.guang5@zte.com.cn>

Source kernel commit: d3d48fb93ba48bd3cb5c564235bfbc96fe4d0d7f

Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
opencoding it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_da_btree.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)


diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 50f3ec66..1f39c108 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -861,7 +861,6 @@ xfs_da3_node_rebalance(
 {
 	struct xfs_da_intnode	*node1;
 	struct xfs_da_intnode	*node2;
-	struct xfs_da_intnode	*tmpnode;
 	struct xfs_da_node_entry *btree1;
 	struct xfs_da_node_entry *btree2;
 	struct xfs_da_node_entry *btree_s;
@@ -891,9 +890,7 @@ xfs_da3_node_rebalance(
 	    ((be32_to_cpu(btree2[0].hashval) < be32_to_cpu(btree1[0].hashval)) ||
 	     (be32_to_cpu(btree2[nodehdr2.count - 1].hashval) <
 			be32_to_cpu(btree1[nodehdr1.count - 1].hashval)))) {
-		tmpnode = node1;
-		node1 = node2;
-		node2 = tmpnode;
+		swap(node1, node2);
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr1, node1);
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr2, node2);
 		btree1 = nodehdr1.btree;

