Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3329C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbiL3WrQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbiL3WrP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:47:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0DB1740A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:47:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB11AB81D94
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795C2C433D2;
        Fri, 30 Dec 2022 22:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440431;
        bh=eIpijF9MIiZ/nrXTv2YrdPAIXSfhwhDhZyMbeNwWNwc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=s59OpNle60WE/J25CFhNyATF1m8ls8DZdExo3jVG46m/oP8dpU53npmZ66cDZlbPg
         0a0DDdK0LPRy3odk9I+RzKM89R9C5idkUWjT0ozPnAdCln7SoRADUiA4LXE6KsrASN
         i0JN0n8mKwAULSH+IS5577QW992aHUdm7TCrWeC1t38cJ+OEXs3CalnfebKRoteSmd
         KbwUTrkCh5kH2ETA02x+nkOQs06Wu7X3dx/D9U0/mJShTjY8ze8rpHn0OGwLuOAIWj
         /ddNSgIVgf+Gx77kgVeIDS3TPdtOi6u1kUA9vr/sUBC/XoddA0L7oOHWUM0szql/tw
         uyc51xqpxuPkg==
Subject: [PATCH 2/6] xfs: alert the user about data/attr fork mappings that
 could be merged
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:42 -0800
Message-ID: <167243830252.686829.2793777246600677425.stgit@magnolia>
In-Reply-To: <167243830218.686829.12866790282629472160.stgit@magnolia>
References: <167243830218.686829.12866790282629472160.stgit@magnolia>
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
index 14fe461cac4c..499e82110f2f 100644
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

