Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B694C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240532AbjDFTSi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240531AbjDFTSh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:18:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3B8E78
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:18:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD617644B7
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F34C433D2;
        Thu,  6 Apr 2023 19:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808716;
        bh=NJ61IxOToZgaBFW3osjwF/Pn/UK5y2wHTMAd5X3Gmuo=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=A/WsqRTSdQ2TdHF+f6ss1/fH41u7+oMds7m8mYpzo3IbKytihQKlVg/SRy5dkaOXm
         IM6EF9LOUoRX1m+v/sZvNpwdXObarlqF05oTl6C9MQgDcbFR3gPBrROkM2NinZ/b3L
         zA5o+2iHjRezFcQE1CPlkUNQVVZnoQ65cbpMJgdpYXBcIx+jUtlqBvdsMQa7fMifoR
         wpmmrXK1WHrEBBF8frn3mZSHgd8prgbbPOE0kuMZr7D8MFZd0zbmDbCdtsp+ebstba
         qVHUTdbgSVEayfMtLQCptDfhhH33ER310jon2by7BiNa6d2pnkQ2n0iQv04xZ+RnBX
         SvFGJWBH7DZwg==
Date:   Thu, 06 Apr 2023 12:18:35 -0700
Subject: [PATCH 08/12] xfs: always set args->value in xfs_attri_item_recover
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080823918.613065.14566514432845489888.stgit@frogsfrogsfrogs>
In-Reply-To: <168080823794.613065.2971656278555515103.stgit@frogsfrogsfrogs>
References: <168080823794.613065.2971656278555515103.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Always set args->value to the recovered value buffer.  This reduces the
amount of code in the switch statement, and hence the amount of thinking
that I have to do.  We validated the recovered buffers, supposedly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 082d7790fc2c..07a6cec3dfb9 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -594,6 +594,8 @@ xfs_attri_item_recover(
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	args->value = nv->value.i_addr;
+	args->valuelen = nv->value.i_len;
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
@@ -603,8 +605,6 @@ xfs_attri_item_recover(
 	switch (xfs_attr_intent_op(attr)) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
-		args->value = nv->value.i_addr;
-		args->valuelen = nv->value.i_len;
 		args->total = xfs_attr_calc_size(args, &local);
 		if (xfs_inode_hasattr(args->dp))
 			attr->xattri_dela_state = xfs_attr_init_replace_state(args);

