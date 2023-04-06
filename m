Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89716C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240529AbjDFTRv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239729AbjDFTRv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:17:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D2AF2
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:17:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14EA760F9D
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD17C4339B;
        Thu,  6 Apr 2023 19:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808669;
        bh=JtGh3u+mk/nNkJFlkU4XQ4L/Y9O+yDk2RryGk/214DU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jXzPK/VQY/CsAyX7LDaY5fDm2zqSPx2WE9KfQzNWUV3F3aJtFzgzcPxINFSkUWIRg
         0jIUuKIRxA9fFj2w8AO9cIns53PXhaODjUdci5eKPdxvHwJ+3I/ultyVu779EXToFy
         WOOc8q1Bd/RoryKFCXBQQzC/oVhKD6S5cafhReqh/qJNI8gbKQaoLFCikhtOluWCKb
         /iY3vZkHyJH+ivoWEUheJ64LSYt5g6pxTfdxpG+gps35Xx3pmKu3bJSMXPbDho69wp
         1vuXI4Il/epPGr+N2R52gwUCsVBjEswHIxr+7roNB1owJ9HIzn1zeTf6srRdCs0h8s
         d+dNKyt3hNsjQ==
Date:   Thu, 06 Apr 2023 12:17:48 -0700
Subject: [PATCH 05/12] xfs: restructure xfs_attr_complete_op a bit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080823876.613065.2848688652399549352.stgit@frogsfrogsfrogs>
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

Reduce the indentation in this function by flattening the nested if
statements.  We're going to add more code later to this function later,
hence the early cleanup.  No functional changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 2897fdc8372e..b0da2e862ef9 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -421,11 +421,11 @@ xfs_attr_complete_op(
 	bool			do_replace = args->op_flags & XFS_DA_OP_REPLACE;
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
-	if (do_replace) {
-		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
-		return replace_state;
-	}
-	return XFS_DAS_DONE;
+	if (!do_replace)
+		return XFS_DAS_DONE;
+
+	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	return replace_state;
 }
 
 static int

