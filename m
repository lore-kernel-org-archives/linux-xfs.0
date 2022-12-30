Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84AE4C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236049AbiLaBoo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236028AbiLaBon (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:44:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E481CFF2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:44:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3184FB81DD1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3B5C433EF;
        Sat, 31 Dec 2022 01:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451079;
        bh=KgOCZjx4k8w6cpCFCrN/y3vzEqvQg1ksBfxUcI+zoJY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cd9eYzJK/6zEKpUB5LtrOsEDAN9LlC+ULdvLmIeY8egZBJZYFXb4yaZ4BhQwrolCP
         mt+2Klc/JOXy33elpXj1/JgLZyq0slXea5VZqDxAAbHJfLH4AZQHOTZjY0br5+MFVN
         SUn3Rl0XUXNRT0l55PRG84KY3CKcNPowk5KjCPhwwfeshAMyJ2nxWSpB2Z/X2u0tJf
         FvLQ3wfUstuTwSx1G4zptxVC1L197bEVXClcn+sNdzfVQIgyf892HY0IJx8JaWKQXd
         26YRhhAR46jETDqtmCPRH/Lv83ZUNhkJbkeqxlw5cyVLsHLcLr8GZf4LsG7AoA+8RX
         iQ2sc27NS0GGw==
Subject: [PATCH 30/38] xfs: scan rt rmap when we're doing an intense rmap
 check of bmbt mappings
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:20 -0800
Message-ID: <167243870030.715303.10177350333030281769.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the bmbt scrubber how to perform a comprehensive check that the
rmapbt does not contain /any/ mappings that are not described by bmbt
records when it's dealing with a realtime file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c |   60 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 53 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 49fffe85dde6..8ce279ae9c95 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -20,6 +20,8 @@
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtalloc.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -673,12 +675,20 @@ xchk_bmap_check_rmap(
 	 */
 	check_rec = *rec;
 	while (have_map) {
+		xfs_fsblock_t	startblock;
+
 		if (irec.br_startoff != check_rec.rm_offset)
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					check_rec.rm_offset);
-		if (irec.br_startblock != XFS_AGB_TO_FSB(sc->mp,
-				cur->bc_ag.pag->pag_agno,
-				check_rec.rm_startblock))
+		if (cur->bc_btnum == XFS_BTNUM_RMAP)
+			startblock = XFS_AGB_TO_FSB(sc->mp,
+					cur->bc_ag.pag->pag_agno,
+					check_rec.rm_startblock);
+		else
+			startblock = xfs_rgbno_to_rtb(sc->mp,
+					cur->bc_ino.rtg->rtg_rgno,
+					check_rec.rm_startblock);
+		if (irec.br_startblock != startblock)
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					check_rec.rm_offset);
 		if (irec.br_blockcount > check_rec.rm_blockcount)
@@ -732,6 +742,30 @@ xchk_bmap_check_ag_rmaps(
 	return error;
 }
 
+/* Make sure each rt rmap has a corresponding bmbt entry. */
+STATIC int
+xchk_bmap_check_rt_rmaps(
+	struct xfs_scrub		*sc,
+	struct xfs_rtgroup		*rtg)
+{
+	struct xchk_bmap_check_rmap_info sbcri;
+	struct xfs_btree_cur		*cur;
+	int				error;
+
+	xfs_rtgroup_lock(NULL, rtg, XFS_RTGLOCK_RMAP);
+	cur = xfs_rtrmapbt_init_cursor(sc->mp, sc->tp, rtg, rtg->rtg_rmapip);
+
+	sbcri.sc = sc;
+	sbcri.whichfork = XFS_DATA_FORK;
+	error = xfs_rmap_query_all(cur, xchk_bmap_check_rmap, &sbcri);
+	if (error == -ECANCELED)
+		error = 0;
+
+	xfs_btree_del_cursor(cur, error);
+	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
+	return error;
+}
+
 /* Make sure each rmap has a corresponding bmbt entry. */
 STATIC int
 xchk_bmap_check_rmaps(
@@ -749,10 +783,6 @@ xchk_bmap_check_rmaps(
 	    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		return 0;
 
-	/* Don't support realtime rmap checks yet. */
-	if (xfs_ifork_is_realtime(sc->ip, whichfork))
-		return 0;
-
 	ASSERT(xfs_ifork_ptr(sc->ip, whichfork) != NULL);
 
 	/*
@@ -772,6 +802,22 @@ xchk_bmap_check_rmaps(
 	    (zero_size || ifp->if_nextents > 0))
 		return 0;
 
+	if (xfs_ifork_is_realtime(sc->ip, whichfork)) {
+		struct xfs_rtgroup	*rtg;
+		xfs_rgnumber_t		rgno;
+
+		for_each_rtgroup(sc->mp, rgno, rtg) {
+			error = xchk_bmap_check_rt_rmaps(sc, rtg);
+			if (error ||
+			    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)) {
+				xfs_rtgroup_put(rtg);
+				return error;
+			}
+		}
+
+		return 0;
+	}
+
 	for_each_perag(sc->mp, agno, pag) {
 		error = xchk_bmap_check_ag_rmaps(sc, whichfork, pag);
 		if (error ||

