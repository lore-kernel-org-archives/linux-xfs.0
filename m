Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09117C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiJBSfq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiJBSfq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:35:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF0F2B625
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:35:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80123B80D88
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCABC433D6;
        Sun,  2 Oct 2022 18:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735742;
        bh=/1Ir53agzvSCtIdGn9gzJeDDQuthEAXwKkIqgM0lu5Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BovnOEyveTQSem8bw363V90KNVH8mE4GyWPBdgDUA7st8p9BkvFuWvpycO1Gbmk9I
         jqSkPsfEVJp86YlHW5jqbIxFoRF2i+caSp2ZjnqjJ9u+GXEOH+h8ajoZ0ZcijyGLuJ
         i14iQXn5eJgt+LjuvtCVyQ+K/6YPVwNDrMdrOq/79pu/VhVutWV0nUlNkGGEwQlBqx
         M8y6o2xO/oSuPemXAa7rCnevxdP3FHPF+WJGiUDdw9oe/SXr9G0KW181e8qfs2kCxT
         27plWCU61tDVkcEVcWYxwhh0tJe1dO6pms3i6bjXHj4utYm/3ZYJfeH5JL+GSrVSAU
         337MywT81rW9A==
Subject: [PATCH 2/6] xfs: alert the user about data/attr fork mappings that
 could be merged
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:36 -0700
Message-ID: <166473483633.1084923.15717918189479146706.stgit@magnolia>
In-Reply-To: <166473483595.1084923.1946295148534639238.stgit@magnolia>
References: <166473483595.1084923.1946295148534639238.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If the data or attr forks have mappings that could be merged, let the
user know that the structure could be optimized.  This isn't a
filesystem corruption since the regular filesystem does not try to be
smart about merging bmbt records.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index aaa73a2bdd17..0f5d7fb61ca1 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -390,6 +390,29 @@ xchk_bmap_dirattr_extent(
 		xchk_fblock_set_corrupt(info->sc, info->whichfork, off);
 }
 
+/* Are these two mappings mergeable? */
+static inline bool
+xchk_bmap_mergeable(
+	struct xchk_bmap_info		*info,
+	const struct xfs_bmbt_irec	*b2)
+{
+	const struct xfs_bmbt_irec	*b1 = &info->prev_rec;
+
+	/* Skip uninitialized prev_rec and COW fork extents */
+	if (b1->br_blockcount == 0)
+		return false;
+	if (info->whichfork == XFS_COW_FORK)
+		return false;
+
+	if (b1->br_startoff + b1->br_blockcount != b2->br_startoff)
+		return false;
+	if (b1->br_startblock + b1->br_blockcount != b2->br_startblock)
+		return false;
+	if (b1->br_blockcount + b2->br_blockcount > BMBT_BLOCKCOUNT_MASK)
+		return false;
+	return b1->br_state == b2->br_state;
+}
+
 /* Scrub a single extent record. */
 STATIC void
 xchk_bmap_iextent(
@@ -441,6 +464,10 @@ xchk_bmap_iextent(
 	if (info->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
+	/* Notify the user of mergeable records in the data/attr forks. */
+	if (xchk_bmap_mergeable(info, irec))
+		xchk_ino_set_preen(info->sc, info->sc->ip->i_ino);
+
 	if (info->is_rt)
 		xchk_bmap_rt_iextent_xref(ip, info, irec);
 	else

