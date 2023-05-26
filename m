Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7002EC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjEZCQL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjEZCQK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:16:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C3E195
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:16:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2805B6157B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882C8C433D2;
        Fri, 26 May 2023 02:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067368;
        bh=PgyuZhG8o3dNS1nBirEv76fsv/MvrMYXRvCV8ZutY0o=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=tKJEcU82cPmgPIBHE3ksOb2MZdiPYCBw5V7nQXRhmjiAD3W6mRb4KQUnSE2c9BiUW
         fOOl2LfwX/iD9eviDNeYKQAPhMRmHDiYkJYROYQn15we/ZhkOEg6iLPWjsoMBYNt49
         1EvjqvG09XoNuAjs4iaU+R3u+exsK1l8UU5dnIWmjHU08sgDnVmLVyI6vqejqZl8js
         FcbV2FjwR0Jeb0w8nANnLH+vw/siMvF1bn4qH5amfcmrPemsH+HogMuv5evoEcqlkx
         EfubSsFyn0DvJeeTWoE//esz3sVAO55cswU1aDmxmpLv9138hwQ8VGizhyW76rgoym
         5Im/7EYL4jUtw==
Date:   Thu, 25 May 2023 19:16:08 -0700
Subject: [PATCH 06/17] xfs: set child file owner in xfs_da_args when changing
 parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506073382.3745075.7085494043402000854.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
References: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that struct xfs_da_args has an explicit file owner field, we must
set it when modifying parent pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_parent.c |   13 ++++++++++---
 fs/xfs/libxfs/xfs_parent.h |    4 ++--
 2 files changed, 12 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 27685ce65a16..cc05d1de9eb0 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -195,6 +195,7 @@ xfs_parent_add(
 
 	args->trans = tp;
 	args->dp = child;
+	args->owner = child->i_ino;
 
 	xfs_init_parent_davalue(&parent->args, parent_name);
 
@@ -227,6 +228,7 @@ xfs_parent_remove(
 
 	args->trans = tp;
 	args->dp = child;
+	args->owner = child->i_ino;
 
 	xfs_init_parent_davalue(&parent->args, parent_name);
 
@@ -265,6 +267,7 @@ xfs_parent_replace(
 
 	args->trans = tp;
 	args->dp = child;
+	args->owner = child->i_ino;
 
 	xfs_init_parent_davalue(&parent->args, old_name);
 	xfs_init_parent_danewvalue(&parent->args, new_name);
@@ -327,6 +330,7 @@ static inline void
 xfs_parent_scratch_init(
 	struct xfs_trans		*tp,
 	struct xfs_inode		*ip,
+	xfs_ino_t			owner,
 	const struct xfs_parent_name_irec *pptr,
 	struct xfs_parent_scratch	*scr)
 {
@@ -343,6 +347,7 @@ xfs_parent_scratch_init(
 	scr->args.whichfork	= XFS_ATTR_FORK;
 	scr->args.hashval	= xfs_da_hashname((const void *)&scr->rec,
 					sizeof(struct xfs_parent_name_rec));
+	scr->args.owner		= owner;
 }
 
 /*
@@ -359,7 +364,7 @@ xfs_parent_lookup(
 	struct xfs_parent_scratch	*scr)
 {
 	xfs_parent_irec_to_disk(&scr->rec, pptr);
-	xfs_parent_scratch_init(tp, ip, pptr, scr);
+	xfs_parent_scratch_init(tp, ip, ip->i_ino, pptr, scr);
 	scr->args.op_flags |= XFS_DA_OP_OKNOENT;
 
 	return xfs_attr_get_ilocked(&scr->args);
@@ -374,11 +379,12 @@ xfs_parent_lookup(
 int
 xfs_parent_set(
 	struct xfs_inode		*ip,
+	xfs_ino_t			owner,
 	const struct xfs_parent_name_irec *pptr,
 	struct xfs_parent_scratch	*scr)
 {
 	xfs_parent_irec_to_disk(&scr->rec, pptr);
-	xfs_parent_scratch_init(NULL, ip, pptr, scr);
+	xfs_parent_scratch_init(NULL, ip, owner, pptr, scr);
 
 	return xfs_attr_set(&scr->args);
 }
@@ -392,11 +398,12 @@ xfs_parent_set(
 int
 xfs_parent_unset(
 	struct xfs_inode		*ip,
+	xfs_ino_t			owner,
 	const struct xfs_parent_name_irec *pptr,
 	struct xfs_parent_scratch	*scr)
 {
 	xfs_parent_irec_to_disk(&scr->rec, pptr);
-	xfs_parent_scratch_init(NULL, ip, pptr, scr);
+	xfs_parent_scratch_init(NULL, ip, owner, pptr, scr);
 	scr->args.op_flags |= XFS_DA_OP_REMOVE;
 
 	return xfs_attr_set(&scr->args);
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index f1ec9cce859e..5dbaceb97653 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -108,11 +108,11 @@ int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
 		const struct xfs_parent_name_irec *pptr,
 		struct xfs_parent_scratch *scratch);
 
-int xfs_parent_set(struct xfs_inode *ip,
+int xfs_parent_set(struct xfs_inode *ip, xfs_ino_t owner,
 		const struct xfs_parent_name_irec *pptr,
 		struct xfs_parent_scratch *scratch);
 
-int xfs_parent_unset(struct xfs_inode *ip,
+int xfs_parent_unset(struct xfs_inode *ip, xfs_ino_t owner,
 		const struct xfs_parent_name_irec *rec,
 		struct xfs_parent_scratch *scratch);
 

