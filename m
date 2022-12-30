Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 969FEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235756AbiLaADn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbiLaADm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:03:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778D114D14
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:03:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 255C5B81DB1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68F3C433D2;
        Sat, 31 Dec 2022 00:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445018;
        bh=5yeSnqfoV4SIsmQ7Jf2RXD3T3GB8I+uIzb243j0ORaM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vOpSfCbO/WWQT2u+AFibvxzH9HaPEOIwN0Dj+DC8nEtuakzatfyRn9NNldS+RVcD3
         /YVCwAJCIAHXPcPKwkcU2YQgFurtl5QeWegGapFzaBDYYevl6+LyseEt2fESPdYi5A
         RGTgrHaWBX7GJTYNyGUGMUhwuDNFFr9cKbfG+Es1A5AEZFIZ9/lxNc+LvZOlbN/A1e
         hoOihLz8x/OEELrj+DpO+C+owdHHh1qJMhfpM8nzmv0kMAaChoO2bVdR8hM7s7196A
         twZXAmwf+KgC3NCqhmkFg39iTT2Uof6PjXcutj5Cef+Ts+HlSCDB3k6OvLp3JDqGrp
         Tw8nCnkHopAMw==
Subject: [PATCH 2/4] xfs: check AGI unlinked inode buckets
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:29 -0800
Message-ID: <167243846938.701054.7601534530972038057.stgit@magnolia>
In-Reply-To: <167243846905.701054.601680294547998738.stgit@magnolia>
References: <167243846905.701054.601680294547998738.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Look for corruptions in the AGI unlinked bucket chains.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader.c |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c      |    2 +-
 fs/xfs/xfs_inode.h      |    1 +
 3 files changed, 42 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 75de0ba4fcef..fb2f32a2af5d 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -15,6 +15,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_inode.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 
@@ -865,6 +866,43 @@ xchk_agi_xref(
 	/* scrub teardown will take care of sc->sa for us */
 }
 
+/*
+ * Check the unlinked buckets for links to bad inodes.  We hold the AGI, so
+ * there cannot be any threads updating unlinked list pointers in this AG.
+ */
+STATIC void
+xchk_iunlink(
+	struct xfs_scrub	*sc,
+	struct xfs_agi		*agi)
+{
+	unsigned int		i;
+	struct xfs_inode	*ip;
+
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
+		xfs_agino_t	agino = be32_to_cpu(agi->agi_unlinked[i]);
+
+		while (agino != NULLAGINO) {
+			if (agino % XFS_AGI_UNLINKED_BUCKETS != i) {
+				xchk_block_set_corrupt(sc, sc->sa.agi_bp);
+				return;
+			}
+
+			ip = xfs_iunlink_lookup(sc->sa.pag, agino);
+			if (!ip) {
+				xchk_block_set_corrupt(sc, sc->sa.agi_bp);
+				return;
+			}
+
+			if (ip->i_prev_unlinked == 0) {
+				xchk_block_set_corrupt(sc, sc->sa.agi_bp);
+				return;
+			}
+
+			agino = ip->i_next_unlinked;
+		}
+	}
+}
+
 /* Scrub the AGI. */
 int
 xchk_agi(
@@ -949,6 +987,8 @@ xchk_agi(
 	if (pag->pagi_freecount != be32_to_cpu(agi->agi_freecount))
 		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
+	xchk_iunlink(sc, agi);
+
 	xchk_agi_xref(sc);
 out:
 	return error;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3788093fc81d..af4ac808a0e0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2010,7 +2010,7 @@ xfs_inactive(
  * only unlinked, referenced inodes can be on the unlinked inode list.  If we
  * don't find the inode in cache, then let the caller handle the situation.
  */
-static struct xfs_inode *
+struct xfs_inode *
 xfs_iunlink_lookup(
 	struct xfs_perag	*pag,
 	xfs_agino_t		agino)
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 177b027b8803..be704174fa4f 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -584,6 +584,7 @@ extern struct kmem_cache	*xfs_inode_cache;
 bool xfs_inode_needs_inactive(struct xfs_inode *ip);
 
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
+struct xfs_inode *xfs_iunlink_lookup(struct xfs_perag *pag, xfs_agino_t agino);
 
 void xfs_end_io(struct work_struct *work);
 

