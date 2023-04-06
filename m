Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3644BC76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjDFTaf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDFTae (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:30:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B387DC3
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:30:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B28764AD2
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD73EC433EF;
        Thu,  6 Apr 2023 19:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809432;
        bh=zWRQaspgWo9mrQ+lbs63wC++IaFaQYEjCAhuKqDkYOU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=J3CIA6M/Zs3Bu+sMYNyr+2NDHwD4J8aZzvLX+v1fJsoXerYyqudAAL1nnCeiSQcru
         ai9aYcr1qcbQybonWe8Ked4y3SqiEpHVVSIGAqF1k9rZZQguYCYr/eW7rE79qOYe+x
         6MAJ5pZ/qau0iUGZ5N9U34UyYuA/ay557cQqroWSr/yMX8vIWAlLFTM1gBbb57Rhci
         riywuYL46azdqHz0fXfKX5Tf4ci6nWcrzxr93waOXHivpOnsPtd0SPuM2hAFoGHrkZ
         idalXsiSbOvsIdfXT65NJn9X1XhmA52pxaPQXQpzj1z1PhL/Oa0GYBrhBKXShN4eB7
         b5s3XN+illM9A==
Date:   Thu, 06 Apr 2023 12:30:32 -0700
Subject: [PATCH 06/10] xfs: log NVLOOKUP xattr removal operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827194.616519.17565216322382066888.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827114.616519.13224581752144055912.stgit@frogsfrogsfrogs>
References: <168080827114.616519.13224581752144055912.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If high level code wants to do a deferred xattr remove operation with
the NVLOOKUP flag set, we need to push this through the log.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c       |    6 +++++-
 libxfs/xfs_log_format.h |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 137ba5e50..9621f8715 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -940,9 +940,13 @@ xfs_attr_defer_remove(
 {
 
 	struct xfs_attr_intent	*new;
+	int			op_flag = XFS_ATTRI_OP_FLAGS_REMOVE;
 	int			error;
 
-	error  = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REMOVE, &new);
+	if (args->op_flags & XFS_DA_OP_NVLOOKUP)
+		op_flag = XFS_ATTRI_OP_FLAGS_NVREMOVE;
+
+	error  = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index f13e0809d..ecf0ac32d 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -957,6 +957,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_NVREMOVE	4	/* Remove attr w/ vlookup */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*

