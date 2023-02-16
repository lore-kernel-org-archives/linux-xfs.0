Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AADBAC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjBPUxs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjBPUxs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:53:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02384CCBA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:53:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C74360B71
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC2CC433EF;
        Thu, 16 Feb 2023 20:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580826;
        bh=00HFnC++bGgVrFyVSGe8zk6pbRyRQWN+fVdBPOXQ2cs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=u0Lv6n9xSEswGfwEaNymx1Uci5pMRro1j+CiawDul2t4vLQVRy+QxaTSn2zIzrvmr
         q+UjcKeXys/IS1FxTl7dMY4NOjAUHmwuzC8prvoYfJ2QzIDEDIa6zf5RQm4ejYw0o/
         ugRi1f9IxyFn95hHBFfFbPeNvsxWm3WT9y+XJtT0p16ZBzoNJVdw4Qnl+OeE2fIo+v
         8HvCZ73SCHrUcTfqFFKM7GiELCmdpnVCsAGe7FZwb6EFA5bwhWfyqnDazRBY79hmXp
         ky6kIDEcjiyon01gcN1WjEI6p4qaV4oAHV9LF724dN2VZFoLnazfdeo3CiBc2RT0vU
         uWY7dTJD+Y+oA==
Date:   Thu, 16 Feb 2023 12:53:46 -0800
Subject: [PATCH 01/25] xfsprogs: Fix default superblock attr bits
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657878908.3476112.7469636876565461550.stgit@magnolia>
In-Reply-To: <167657878885.3476112.11949206434283274332.stgit@magnolia>
References: <167657878885.3476112.11949206434283274332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Recent parent pointer testing discovered that the default attr
configuration has XFS_SB_VERSION2_ATTR2BIT enabled but
XFS_SB_VERSION_ATTRBIT disabled.  This is incorrect since
XFS_SB_VERSION2_ATTR2BIT describes the format of the attr where
as XFS_SB_VERSION_ATTRBIT enables or disables attrs.  Fix this
by enableing XFS_SB_VERSION_ATTRBIT for either attr version 1 or 2

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 mkfs/xfs_mkfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e219ec16..d95394a5 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3205,7 +3205,7 @@ sb_set_features(
 		sbp->sb_versionnum |= XFS_SB_VERSION_DALIGNBIT;
 	if (fp->log_version == 2)
 		sbp->sb_versionnum |= XFS_SB_VERSION_LOGV2BIT;
-	if (fp->attr_version == 1)
+	if (fp->attr_version >= 1)
 		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
 	if (fp->nci)
 		sbp->sb_versionnum |= XFS_SB_VERSION_BORGBIT;

