Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 659A0C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjEZCao (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjEZCan (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:30:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630DD9B
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:30:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA59064C57
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E16C433D2;
        Fri, 26 May 2023 02:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068241;
        bh=DCHwZRbjZXO4tip2JbC1nRyUu6GQhGBxVCsWrEr/DNU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=kfTcQhyJVQ3weERlmcESR2opl1/DgSULtX95bmzaet0aM+5k1NOSU1H35Z4Xe9+bu
         oC47nMI7NU3nzHlzKXJS7PG8M01vKtb+bVe7E5+SIucczZE8Q7E2KiHoAyxvIMQnWb
         P3avsPxu7+IKhqK5VoJGHssIXxwmY5IWMY2YgkG8AZRettndZA5KyQBSjQ6WSjnz6q
         Up1jEseO57WWs/XZsrjDXwXnOuboZNuGKzDYEjEXpIHXllht5onkn2jKD31MAYWRjE
         9vQQ9MX7Zj5C4VV6QG2LzyB3hBL/MXSAz4V9O6DxDy737EAF+muOuoU0tX0/X1qtNl
         ikeSAQ7wEJdIw==
Date:   Thu, 25 May 2023 19:30:40 -0700
Subject: [PATCH 04/14] xfs: set child file owner in xfs_da_args when changing
 parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078650.3750196.13862208448331054454.stgit@frogsfrogsfrogs>
In-Reply-To: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
References: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_parent.c |   13 ++++++++++---
 libxfs/xfs_parent.h |    4 ++--
 2 files changed, 12 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 0e07fb4c176..e5796d1581b 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -196,6 +196,7 @@ xfs_parent_add(
 
 	args->trans = tp;
 	args->dp = child;
+	args->owner = child->i_ino;
 
 	xfs_init_parent_davalue(&parent->args, parent_name);
 
@@ -228,6 +229,7 @@ xfs_parent_remove(
 
 	args->trans = tp;
 	args->dp = child;
+	args->owner = child->i_ino;
 
 	xfs_init_parent_davalue(&parent->args, parent_name);
 
@@ -266,6 +268,7 @@ xfs_parent_replace(
 
 	args->trans = tp;
 	args->dp = child;
+	args->owner = child->i_ino;
 
 	xfs_init_parent_davalue(&parent->args, old_name);
 	xfs_init_parent_danewvalue(&parent->args, new_name);
@@ -328,6 +331,7 @@ static inline void
 xfs_parent_scratch_init(
 	struct xfs_trans		*tp,
 	struct xfs_inode		*ip,
+	xfs_ino_t			owner,
 	const struct xfs_parent_name_irec *pptr,
 	struct xfs_parent_scratch	*scr)
 {
@@ -344,6 +348,7 @@ xfs_parent_scratch_init(
 	scr->args.whichfork	= XFS_ATTR_FORK;
 	scr->args.hashval	= xfs_da_hashname((const void *)&scr->rec,
 					sizeof(struct xfs_parent_name_rec));
+	scr->args.owner		= owner;
 }
 
 /*
@@ -360,7 +365,7 @@ xfs_parent_lookup(
 	struct xfs_parent_scratch	*scr)
 {
 	xfs_parent_irec_to_disk(&scr->rec, pptr);
-	xfs_parent_scratch_init(tp, ip, pptr, scr);
+	xfs_parent_scratch_init(tp, ip, ip->i_ino, pptr, scr);
 	scr->args.op_flags |= XFS_DA_OP_OKNOENT;
 
 	return xfs_attr_get_ilocked(&scr->args);
@@ -375,11 +380,12 @@ xfs_parent_lookup(
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
@@ -393,11 +399,12 @@ xfs_parent_set(
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
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index f1ec9cce859..5dbaceb9765 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
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
 

