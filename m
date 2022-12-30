Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EFC4C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbiL3Wxm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiL3Wxm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:53:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5683C1AA0F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:53:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E756B61C16
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DE7C433EF;
        Fri, 30 Dec 2022 22:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440820;
        bh=AtWrZF+PqFBkN3IJr/f7kxl9CYcAZ/eP4kk0Uk+1aq4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hn4TJXyWB1oyXrE0lp2l164QGhsjRNveLJsvA7G3lhA9Tp0vF6Sh9gnqlc01fE2t0
         d5L+L6AvSEz5hgsA4AOQe93tWg/IqrKKjTfbU4HM9pz4dhKFhwUDkHWjgjRVhl+sXs
         vjN3aZBsZw71JdPjdEIN+Zu7tNEOr1YHYwFKXle0+Or+qKVaO/g2ExBOmTrFJqbLJK
         wzpImsZ7dWlGSw2pJLq9TdUw9PcPXJoeKSlo7di0tsScOdga3QKUaVpaqUQ6NTIElq
         fsGr1I5rbobEjWXbiCUZ3EPBQPG6dmtUDwpQCS4/Ki78OpItKd3wTlF8jsiW8Tuwen
         ZtR0xC0wy/MCQ==
Subject: [PATCH 2/4] xfs_repair: check low keys of rmap btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:27 -0800
Message-ID: <167243834765.692079.15547663887609909520.stgit@magnolia>
In-Reply-To: <167243834739.692079.8979395707061192623.stgit@magnolia>
References: <167243834739.692079.8979395707061192623.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For whatever reason, we only check the high keys in an rmapbt node
block.  We should be checking the low keys and the high keys, so fix
this gap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/scan.c |   32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)


diff --git a/repair/scan.c b/repair/scan.c
index 7b72013153d..d66ce60cbb3 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -992,6 +992,7 @@ scan_rmapbt(
 	uint64_t		lastowner = 0;
 	uint64_t		lastoffset = 0;
 	struct xfs_rmap_key	*kp;
+	struct xfs_rmap_irec	oldkey;
 	struct xfs_rmap_irec	key = {0};
 	struct xfs_perag	*pag;
 
@@ -1211,7 +1212,7 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 	}
 
 	/* check the node's high keys */
-	for (i = 0; !isroot && i < numrecs; i++) {
+	for (i = 0; i < numrecs; i++) {
 		kp = XFS_RMAP_HIGH_KEY_ADDR(block, i + 1);
 
 		key.rm_flags = 0;
@@ -1231,6 +1232,35 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 				i, agno, bno, name);
 	}
 
+	/* check for in-order keys */
+	for (i = 0; i < numrecs; i++)  {
+		kp = XFS_RMAP_KEY_ADDR(block, i + 1);
+
+		key.rm_flags = 0;
+		key.rm_startblock = be32_to_cpu(kp->rm_startblock);
+		key.rm_owner = be64_to_cpu(kp->rm_owner);
+		if (libxfs_rmap_irec_offset_unpack(be64_to_cpu(kp->rm_offset),
+				&key)) {
+			/* Look for impossible flags. */
+			do_warn(
+_("invalid flags in key %u of %s btree block %u/%u\n"),
+				i, name, agno, bno);
+			suspect++;
+			continue;
+		}
+		if (i == 0) {
+			oldkey = key;
+			continue;
+		}
+		if (rmap_diffkeys(&oldkey, &key) > 0) {
+			do_warn(
+_("out of order key %u in %s btree block (%u/%u)\n"),
+				i, name, agno, bno);
+			suspect++;
+		}
+		oldkey = key;
+	}
+
 	pag = libxfs_perag_get(mp, agno);
 	for (i = 0; i < numrecs; i++)  {
 		xfs_agblock_t		agbno = be32_to_cpu(pp[i]);

