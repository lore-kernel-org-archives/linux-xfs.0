Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70082C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jul 2022 01:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiGMBJz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 21:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbiGMBJv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 21:09:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C486D0397
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jul 2022 18:09:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B1B8618CC
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 01:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03D9C341C0;
        Wed, 13 Jul 2022 01:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657674588;
        bh=ss/rI7le1p8mwTPLA1Hy5fvy6lEaMlKBSD/kzEWWznI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iDIY4Ht6oSBXhX+RtUwCPUkAFl+kUCfGoirdySsdQaFt6A/l+BujC2IOfoG/l15se
         D4iuzCV0QtKzu+2KjZMaydIL/a5EVF5Co23ENFdx1TFKOUaamJ0uwJSKMWqA6CV15h
         idjK/fz/HtkxhejfLtNqoej7vOJvw38sETpGzjiUWqWn0Xz5Sk0DtJahzdDIDJivRJ
         NQah/W6vusYSSpGXJ/qW8rGmTbltpt9rqzbtW6KCB9JoY3k2ZShkvpvWk6+H6RiaWX
         F6B5eGUNK7WuGBQMpEPTDimQOKdwejLz0G1C9OJSLtCnNLBUUNr37DCxxO+g+hLSQa
         DUOGCTkA0lRyA==
Subject: [PATCH 2/4] xfs_repair: Search for conflicts in inode_tree_ptrs[]
 when processing uncertain inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Date:   Tue, 12 Jul 2022 18:09:48 -0700
Message-ID: <165767458835.891854.9721217597094009246.stgit@magnolia>
In-Reply-To: <165767457703.891854.2108521135190969641.stgit@magnolia>
References: <165767457703.891854.2108521135190969641.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandan.babu@oracle.com>

When processing an uncertain inode chunk record, if we lose 2 blocks worth of
inodes or 25% of the chunk, xfs_repair decides to ignore the chunk. Otherwise,
xfs_repair adds a new chunk record to inode_tree_ptrs[agno], marking each
inode as either free or used. However, before adding the new chunk record,
xfs_repair has to check for the existance of a conflicting record.

The existing code incorrectly checks for the conflicting record in
inode_uncertain_tree_ptrs[agno]. This check will succeed since the inode chunk
record being processed was originally obtained from
inode_uncertain_tree_ptrs[agno].

This commit fixes the bug by changing xfs_repair to search
inode_tree_ptrs[agno] for conflicts.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dino_chunks.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 11b0eb5f..80c52a43 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -229,8 +229,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		/*
 		 * ok, put the record into the tree, if no conflict.
 		 */
-		if (find_uncertain_inode_rec(agno,
-				XFS_AGB_TO_AGINO(mp, start_agbno)))
+		if (find_inode_rec(mp, agno, XFS_AGB_TO_AGINO(mp, start_agbno)))
 			return(0);
 
 		start_agino = XFS_AGB_TO_AGINO(mp, start_agbno);

