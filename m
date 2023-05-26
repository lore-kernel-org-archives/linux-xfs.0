Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29494C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbjEZCVL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233920AbjEZCVK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:21:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF699195
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:21:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C6AA64C49
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1922C433D2;
        Fri, 26 May 2023 02:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067664;
        bh=03/sAiBliwj9m0mylF0z7B/jDRBVuI8qV7AF6JKL+/g=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=UGzk/ctXfxDCnEGeJkjrUhSMql0lTTxE63vRAUWcIwybwLKTyf4YDwhsRVYKORL2B
         f3Dj5yQ0uSJ0tcOiY/4cKGWJXWuS1ndUPmLWlMhiW7i3zA2kxsLT7O0Gt/qO652SpS
         pht+DtziZQ6y3MiOVMaWtPnahT5FGLDnM7+/g4ProsDJ/Q8wfYo7YvpBNkcKpCZDSr
         hRZ0Wgac2Sf9x8nOXvqpz+t5fQGHWZ8gFNnk7kgV5rbWkfpF6p2as5swW42pDwAGKq
         q4fwZuTtHpwunKFbRA99sKHAFjXJAtLW0cBesJIP6Xg760t7aNm0EJeNHcuGmyZvSW
         wYQJKdsmQQQHA==
Date:   Thu, 25 May 2023 19:21:04 -0700
Subject: [PATCH 07/10] xfs: log NVLOOKUP xattr setting operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506077529.3749126.16323276787761035199.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077431.3749126.3177791326683307311.stgit@frogsfrogsfrogs>
References: <168506077431.3749126.3177791326683307311.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If high level code wants to do a deferred xattr set operation with the
NVLOOKUP flag set, we need to push this through the log.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c       |    6 +++++-
 libxfs/xfs_log_format.h |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index a3c65665d38..8fa5b4f2819 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -901,9 +901,13 @@ xfs_attr_defer_add(
 	struct xfs_da_args	*args)
 {
 	struct xfs_attr_intent	*new;
+	int			op_flag = XFS_ATTRI_OP_FLAGS_SET;
 	int			error = 0;
 
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_SET, &new);
+	if (args->op_flags & XFS_DA_OP_NVLOOKUP)
+		op_flag = XFS_ATTRI_OP_FLAGS_NVSET;
+
+	error = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 0eb8362e91d..7b848b1d8aa 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -1037,6 +1037,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
 #define XFS_ATTRI_OP_FLAGS_NVREMOVE	4	/* Remove attr w/ vlookup */
+#define XFS_ATTRI_OP_FLAGS_NVSET	5	/* Set attr with w/ vlookup */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*

