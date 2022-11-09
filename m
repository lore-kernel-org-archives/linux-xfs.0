Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E08C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiKICHv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiKICHt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:07:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99000686AB
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:07:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51B9EB81CF2
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA84EC433D6;
        Wed,  9 Nov 2022 02:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959666;
        bh=RDD1tainKMkY9uZXkakn22BG9G0VSx9/vhQ2vxSac+w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GdYRoLVSFijtp4ZpkpWggwCjJT0Z2NXzqHXSMZ2M2ucPzX8lNWaTAI3ixtHEhnRqb
         TQ3Bs/HCZ2OgJ8LnAx+QOa4SnY+RThhGqTEn2N1lTQdnYReqBNPbDFRwoTaCEVHZie
         rIDRT/7V/9sj9+QhCQAvRhHJo9I7UN6inTp9FVgn5SP/TAZErJqd2sQd8nUb+E5EPt
         NF4I5JiAZMRbvg+yqHYNDJrA4rjS9XdC5RuFLULmv8dDItYGZ4iabUgZ7/0KgPrp0E
         Q/pS58QvJeBHOzF9DuIbzNm5TAqJimWVFI161H2pPp++v/28wxMHubPTIawhKr6Lyn
         iZ3nrQpGp6NLA==
Subject: [PATCH 22/24] xfs: rename XFS_REFC_COW_START to _COWFLAG
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:07:45 -0800
Message-ID: <166795966550.3761583.6200011571727727812.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 345bfca998c4ac57daabb7618769a3f0a75331d1

We've been (ab)using XFS_REFC_COW_START as both an integer quantity and
a bit flag, even though it's *only* a bit flag.  Rename the variable to
reflect its nature and update the cast target since we're not supposed
to be comparing it to xfs_agblock_t now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 db/check.c            |    4 ++--
 libxfs/xfs_format.h   |    2 +-
 libxfs/xfs_refcount.c |    6 +++---
 libxfs/xfs_refcount.h |    4 ++--
 repair/scan.c         |    6 +++---
 5 files changed, 11 insertions(+), 11 deletions(-)


diff --git a/db/check.c b/db/check.c
index c9149daadf..680edf1f9e 100644
--- a/db/check.c
+++ b/db/check.c
@@ -4848,8 +4848,8 @@ scanfunc_refcnt(
 				char		*msg;
 
 				agbno = be32_to_cpu(rp[i].rc_startblock);
-				if (agbno >= XFS_REFC_COW_START) {
-					agbno -= XFS_REFC_COW_START;
+				if (agbno >= XFS_REFC_COWFLAG) {
+					agbno -= XFS_REFC_COWFLAG;
 					msg = _(
 		"leftover CoW extent (%u/%u) len %u\n");
 				} else {
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 005dd65b71..371dc07233 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1612,7 +1612,7 @@ unsigned int xfs_refc_block(struct xfs_mount *mp);
  * on the startblock.  This speeds up mount time deletion of stale
  * staging extents because they're all at the right side of the tree.
  */
-#define XFS_REFC_COW_START		((xfs_agblock_t)(1U << 31))
+#define XFS_REFC_COWFLAG		(1U << 31)
 #define REFCNTBT_COWFLAG_BITLEN		1
 #define REFCNTBT_AGBLOCK_BITLEN		31
 
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 0a934aecc6..64e66861b8 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -107,8 +107,8 @@ xfs_refcount_btrec_to_irec(
 	uint32_t			start;
 
 	start = be32_to_cpu(rec->refc.rc_startblock);
-	if (start & XFS_REFC_COW_START) {
-		start &= ~XFS_REFC_COW_START;
+	if (start & XFS_REFC_COWFLAG) {
+		start &= ~XFS_REFC_COWFLAG;
 		irec->rc_domain = XFS_REFC_DOMAIN_COW;
 	} else {
 		irec->rc_domain = XFS_REFC_DOMAIN_SHARED;
@@ -1798,7 +1798,7 @@ xfs_refcount_recover_cow_leftovers(
 	int				error;
 
 	/* reflink filesystems mustn't have AGs larger than 2^31-1 blocks */
-	BUILD_BUG_ON(XFS_MAX_CRC_AG_BLOCKS >= XFS_REFC_COW_START);
+	BUILD_BUG_ON(XFS_MAX_CRC_AG_BLOCKS >= XFS_REFC_COWFLAG);
 	if (mp->m_sb.sb_agblocks > XFS_MAX_CRC_AG_BLOCKS)
 		return -EOPNOTSUPP;
 
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index ee32e8eb5a..452f30556f 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -34,9 +34,9 @@ xfs_refcount_encode_startblock(
 	 * query functions (which set rc_domain == -1U), so we check that the
 	 * domain is /not/ shared.
 	 */
-	start = startblock & ~XFS_REFC_COW_START;
+	start = startblock & ~XFS_REFC_COWFLAG;
 	if (domain != XFS_REFC_DOMAIN_SHARED)
-		start |= XFS_REFC_COW_START;
+		start |= XFS_REFC_COWFLAG;
 
 	return start;
 }
diff --git a/repair/scan.c b/repair/scan.c
index 7e4d4d8b8e..859a6e6937 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1374,16 +1374,16 @@ _("%s btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 			b = agb = be32_to_cpu(rp[i].rc_startblock);
 			len = be32_to_cpu(rp[i].rc_blockcount);
 			nr = be32_to_cpu(rp[i].rc_refcount);
-			if (b >= XFS_REFC_COW_START && nr != 1)
+			if (b >= XFS_REFC_COWFLAG && nr != 1)
 				do_warn(
 _("leftover CoW extent has incorrect refcount in record %u of %s btree block %u/%u\n"),
 					i, name, agno, bno);
 			if (nr == 1) {
-				if (agb < XFS_REFC_COW_START)
+				if (agb < XFS_REFC_COWFLAG)
 					do_warn(
 _("leftover CoW extent has invalid startblock in record %u of %s btree block %u/%u\n"),
 						i, name, agno, bno);
-				agb -= XFS_REFC_COW_START;
+				agb -= XFS_REFC_COWFLAG;
 			}
 			end = agb + len;
 

