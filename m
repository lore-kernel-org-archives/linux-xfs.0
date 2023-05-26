Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 827D2C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbjEZCUF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjEZCUE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:20:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B5AF7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:20:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECBA06157B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC2AC433D2;
        Fri, 26 May 2023 02:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067602;
        bh=qshdKuJeerNsC1eFKmPBPrqXEXpUsYuTJrHbcPK0lqA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=QLeHnFO8RwJFlak5BeIfGuuGpulVWdA4vLmHAkH3F7uMbBifkamnHUuND/CL39Wkq
         +3Fsl9N+amg3ebwh+zxCbjgTqnsSJUAsg7pu/JL6NTVI92m/eEupLSUYiV/S5ImGPf
         e6l6r8jnOYPDpmPKC1W5Ies/bSM0NC32uxMjzkY04GXir3Io2btCl6uGTZ64Y7AibH
         6yK4AKDLrFpIOoBi7xp2QcWR3SExJrS2yruPK79G3FWCecxXyfnUOJbWc45mSlY7L+
         DUNW8ayFiKJH1wBgRzzI3eYvJySby+78mCfrwKoyDcAEpjJPr8F8ZtPFQG3QOK0Ymq
         Y16EoD8APetYQ==
Date:   Thu, 25 May 2023 19:20:02 -0700
Subject: [PATCH 03/10] xfs: preserve NVLOOKUP in xfs_attr_set
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506077475.3749126.14868951985736989646.stgit@frogsfrogsfrogs>
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

Preserve the attr-value lookup flag when calling xfs_attr_set.  Normal
xattr users will never use this, but parent pointer fsck will.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index b131a8f2662..a4227f6379d 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -984,11 +984,11 @@ xfs_attr_set(
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

