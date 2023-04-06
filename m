Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD0BEC7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239619AbjDFTRi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240532AbjDFTRg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:17:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81E8E52
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:17:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60C7962CE1
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B5CC433D2;
        Thu,  6 Apr 2023 19:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808653;
        bh=iFuqVb0dzu3JQjlamiXHtDl1yG2BCXjQrXAlDkZrLkw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ZfH/210bq0+3OpwVEyLxlMRvkIiK7JMQ80E8Eb92Sx+i6O3USWfQ1JSZfg9JYbxKB
         8+ZUz4uFTfXW6V0+YeB7bChr50BmHbZc8GLCkqrcRALzmDNTge91mpSIZNtPrBfgCn
         VYZtgWyPZ7VJxoJcs5I+vqRN4nHRaWXclwOuTYu3qtvKELwKu/DVkE4ySHFCuwW22w
         oDRdqLPivrfANF13PudTmJ4yJYIyG37vGumEQNQew9NrkQR6PuKwRUA/A/sVajOPQB
         cP54e01t/RkMOjk7XenLwUK+MVvI40kW3aeX8jv2QI3BYGm6MNNcgOX3kQlp4vJkYD
         90me0sgP0DY+A==
Date:   Thu, 06 Apr 2023 12:17:33 -0700
Subject: [PATCH 04/12] xfs: preserve NVLOOKUP in xfs_attr_set
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080823862.613065.11992563311398110892.stgit@frogsfrogsfrogs>
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

Preserve the attr-value lookup flag when calling xfs_attr_set.  Normal
xattr users will never use this, but parent pointer fsck will.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1518b786cdaa..2897fdc8372e 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -986,11 +986,11 @@ xfs_attr_set(
 	/*
 	 * We have no control over the attribute names that userspace passes us
 	 * to remove, so we have to allow the name lookup prior to attribute
-	 * removal to fail as well.  Preserve the logged flag, since we need
-	 * to pass that through to the logging code.
+	 * removal to fail as well.  Preserve the logged and vlookup flags,
+	 * since we need to pass them through to the lower levels.
 	 */
-	args->op_flags = XFS_DA_OP_OKNOENT |
-					(args->op_flags & XFS_DA_OP_LOGGED);
+	args->op_flags &= (XFS_DA_OP_LOGGED | XFS_DA_OP_NVLOOKUP);
+	args->op_flags |= XFS_DA_OP_OKNOENT;
 
 	if (!is_remove) {
 		XFS_STATS_INC(mp, xs_attr_set);

