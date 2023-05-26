Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E78C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjEZCU6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjEZCU5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:20:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD67198
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:20:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADFAA64C49
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1939EC433EF;
        Fri, 26 May 2023 02:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067649;
        bh=cihNjOi+YigbFUkEiQi6gTb1iQlR+5v9NgZ8t8464Do=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=q+IopDDFykP9+luYDcBjAsxIHhq5JkNuHPja8AjYc7ZSFXZNQZh1J90PlsEBc19SB
         lMh3EesQP2c8cDuczMUyTJXgEwp0vtnjJbIa9xJ7FLgU7+iDhQIgOLeLhlHugjH2FI
         Og8Er3hn5QJjAmlPwIMNpmB6ivEbeJ+n8s8lJzI8iVXRUi2hEU0ECLZFKW0J6nGbu3
         NcEBk62kI7nSz+kzMs7XigUWWnBHq9zh3gFtDiC0LCKY/sSKjJpBf0+jOBFD8a3Znw
         k4eOQND6Hx1/oiKDZbq6Sjd98xtnvSfhDmkxRWkG0qItrd0nGlgMZY3X06I2zi+Itw
         iCwV656JkqdGQ==
Date:   Thu, 25 May 2023 19:20:48 -0700
Subject: [PATCH 06/10] xfs: log NVLOOKUP xattr removal operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506077516.3749126.14068005851620425458.stgit@frogsfrogsfrogs>
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

If high level code wants to do a deferred xattr remove operation with
the NVLOOKUP flag set, we need to push this through the log.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c       |    6 +++++-
 libxfs/xfs_log_format.h |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 4a2c48d050d..a3c65665d38 100644
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
index c7d02bb04f4..0eb8362e91d 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -1036,6 +1036,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_NVREMOVE	4	/* Remove attr w/ vlookup */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*

