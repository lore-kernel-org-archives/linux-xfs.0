Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A5AC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiJBSdT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiJBSdS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:33:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F5B3C164
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:33:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB7F5B80D6F
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E68EC433C1;
        Sun,  2 Oct 2022 18:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735594;
        bh=3cd5W5KGCLep9vweM/Q76iCXdW+N13/MKNdn5DHFdP4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=r85DrXDixw7BkxdLZucgC8/T2cbXxV6ZJPM8Yc1i0Ag8OIQAAwo3I+70ojsYuIK/i
         NCmEZut2t2LpxaKAUIK4BrYa5WbreHk2BJEFP6ZuqNJASbykHtEksx3rbAs52LfvZ4
         xA/zddKfU0V6m+idt+Ewz1jAwXRdPRp4w0CTsFD6uWc6W/VOYFTSaVACCdvIJFIyoL
         Di3VNolgZuJfdbjibj2GLWA4VImDfURA/JfyZ0ZNtu7EDaLMQ2Q7B0wv03UYIPtocw
         EboPC5FYucG++oEvkRGDn4hLyBxjFygADBhzo+/LWdw1npyQB3vMvFlj8t27ZKUSIF
         3FGqihsXkXrsg==
Subject: [PATCH 1/3] xfs: clean up broken eearly-exit code in the inode btree
 scrubber
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:19 -0700
Message-ID: <166473481968.1084372.18253504968225202018.stgit@magnolia>
In-Reply-To: <166473481949.1084372.14443532201653453226.stgit@magnolia>
References: <166473481949.1084372.14443532201653453226.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Corrupt inode chunks should cause us to exit early after setting the
CORRUPT flag on the scrub state.  While we're at it, collapse trivial
helpers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/ialloc.c |   52 +++++++++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 30 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index efe346ddd1b7..89eaaa12b6ae 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -79,44 +79,33 @@ xchk_iallocbt_chunk_xref_other(
 		xchk_btree_xref_set_corrupt(sc, *pcur, 0);
 }
 
-/* Cross-reference with the other btrees. */
-STATIC void
-xchk_iallocbt_chunk_xref(
-	struct xfs_scrub		*sc,
+/* Is this chunk worth checking and cross-referencing? */
+STATIC bool
+xchk_iallocbt_chunk(
+	struct xchk_btree		*bs,
 	struct xfs_inobt_rec_incore	*irec,
 	xfs_agino_t			agino,
-	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
 {
-	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		return;
+	struct xfs_scrub		*sc = bs->sc;
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_perag		*pag = bs->cur->bc_ag.pag;
+	xfs_agblock_t			agbno;
+
+	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
+	if (agbno + len <= agbno ||
+	    !xfs_verify_agbno(pag, agbno) ||
+	    !xfs_verify_agbno(pag, agbno + len - 1))
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return false;
 
 	xchk_xref_is_used_space(sc, agbno, len);
 	xchk_iallocbt_chunk_xref_other(sc, irec, agino);
 	xchk_xref_is_owned_by(sc, agbno, len, &XFS_RMAP_OINFO_INODES);
 	xchk_xref_is_not_shared(sc, agbno, len);
-}
-
-/* Is this chunk worth checking? */
-STATIC bool
-xchk_iallocbt_chunk(
-	struct xchk_btree		*bs,
-	struct xfs_inobt_rec_incore	*irec,
-	xfs_agino_t			agino,
-	xfs_extlen_t			len)
-{
-	struct xfs_mount		*mp = bs->cur->bc_mp;
-	struct xfs_perag		*pag = bs->cur->bc_ag.pag;
-	xfs_agblock_t			bno;
-
-	bno = XFS_AGINO_TO_AGBNO(mp, agino);
-	if (bno + len <= bno ||
-	    !xfs_verify_agbno(pag, bno) ||
-	    !xfs_verify_agbno(pag, bno + len - 1))
-		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-
-	xchk_iallocbt_chunk_xref(bs->sc, irec, agino, bno, len);
-	xchk_xref_is_not_cow_staging(bs->sc, bno, len);
+	xchk_xref_is_not_cow_staging(sc, agbno, len);
 	return true;
 }
 
@@ -486,7 +475,7 @@ xchk_iallocbt_rec(
 		if (holemask & 1)
 			holecount += XFS_INODES_PER_HOLEMASK_BIT;
 		else if (!xchk_iallocbt_chunk(bs, &irec, agino, len))
-			break;
+			goto out;
 		holemask >>= 1;
 		agino += XFS_INODES_PER_HOLEMASK_BIT;
 	}
@@ -496,6 +485,9 @@ xchk_iallocbt_rec(
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 check_clusters:
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
 	error = xchk_iallocbt_check_clusters(bs, &irec);
 	if (error)
 		goto out;

