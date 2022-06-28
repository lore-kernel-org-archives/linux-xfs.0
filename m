Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66F0C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiF1Uuy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiF1Uux (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:50:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40CE31912
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:50:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FF1661856
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D45C341C8;
        Tue, 28 Jun 2022 20:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449451;
        bh=ss/rI7le1p8mwTPLA1Hy5fvy6lEaMlKBSD/kzEWWznI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GwuN6BG10gqPCRePzjUM2n1iFnWnqr/ZDbAzoyfXH7yYl8Qw5bgntvh+sxe4Y7alF
         W2z+7yEefdjToNIVnhshTRmgVKIAf2M8oe4zWXfrjD/L81k/MNclfesZkYXRvtt3WY
         EBqqjfZjm9V9oIW3CzwD25Vb88vYQ8LatXOkKIj3WwNLx16OGxuXJU/Sy9kZ61udIr
         3hvDCuQAnKujO2pbVRyL5mk0k1pSjhswEbAKW5Nd1a4kcTReDjvpRJYC9gc8aMJEqz
         ilDssAD6SHAGis0XGzO72v830lnqERMT5l8lW8Xw+e1ABpx2lB7OS1qvmci0kyBtRJ
         YP4ljEz/lTGow==
Subject: [PATCH 3/3] xfs_repair: Search for conflicts in inode_tree_ptrs[]
 when processing uncertain inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:50:51 -0700
Message-ID: <165644945118.1091715.6447306343418424029.stgit@magnolia>
In-Reply-To: <165644943454.1091715.4250245702579572029.stgit@magnolia>
References: <165644943454.1091715.4250245702579572029.stgit@magnolia>
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

