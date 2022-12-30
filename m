Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E32BC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235649AbiL3WoZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235643AbiL3WoY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:44:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F4C12D26
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:44:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDD6FB81D94
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE78C433D2;
        Fri, 30 Dec 2022 22:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440260;
        bh=fScK2VfNJ66OyK1OR4XnXOv5cQ1UTM1uWtzoTyZ5KTM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kiosTzqG+IgInV6gWC1Mn+AYVCniuCNvzKZIHhsRSF+E7tE7Caz8G+0c8JTLAEXh4
         1GjFsHdOaPqiSMoY3wKgIaEeAH5kU0Vf4LKXJNDTOoCKPOHkJJ/2y5HHViARtlXxot
         krAq5QS5YMV/svmEYacsZYwPDQsPSW9SAztgGQTrn533B12ypRvvr1p1jbbUiO+MHi
         /7tXPd5+NU4l11Xmv6+5tYKGXCrPCq+bOtX2TLvon0U4NXcrBO8wsbIgiL/633Ogjd
         sYNiGiAiPNb/Ue6gJp/3QvtmxVZphLa3d1MVbso2i76tsv3CCt/IoYjo/wUgoKlpKb
         8Xj33DvMxLh7A==
Subject: [PATCH 4/4] xfs: convert xfs_ialloc_has_inodes_at_extent to return
 keyfill scan results
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:29 -0800
Message-ID: <167243828948.684591.5986132332833558826.stgit@magnolia>
In-Reply-To: <167243828888.684591.12405031427937736396.stgit@magnolia>
References: <167243828888.684591.12405031427937736396.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert the xfs_ialloc_has_inodes_at_extent function to return keyfill
scan results because for a given range of inode numbers, we might have
no indexed inodes at all; the entire region might be allocated ondisk
inodes; or there might be a mix of the two.

Unfortunately, sparse inodes adds to the complexity, because each inode
record can have holes, which means that we cannot use the generic btree
_scan_keyfill function because we must look for holes in individual
records to decide the result.  On the plus side, online fsck can now
detect sub-chunk discrepancies in the inobt.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c |   82 +++++++++++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_ialloc.h |    5 +--
 fs/xfs/scrub/ialloc.c      |   17 +++++----
 3 files changed, 62 insertions(+), 42 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index aab83f17d1a5..d5de1eed97e2 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2656,44 +2656,50 @@ xfs_ialloc_read_agi(
 	return 0;
 }
 
-/* Is there an inode record covering a given range of inode numbers? */
-int
-xfs_ialloc_has_inode_record(
-	struct xfs_btree_cur	*cur,
-	xfs_agino_t		low,
-	xfs_agino_t		high,
-	bool			*exists)
+/* How many inodes are backed by inode clusters ondisk? */
+STATIC int
+xfs_ialloc_count_ondisk(
+	struct xfs_btree_cur		*cur,
+	xfs_agino_t			low,
+	xfs_agino_t			high,
+	unsigned int			*allocated)
 {
 	struct xfs_inobt_rec_incore	irec;
-	xfs_agino_t		agino;
-	uint16_t		holemask;
-	int			has_record;
-	int			i;
-	int			error;
+	unsigned int			ret = 0;
+	int				has_record;
+	int				error;
 
-	*exists = false;
 	error = xfs_inobt_lookup(cur, low, XFS_LOOKUP_LE, &has_record);
-	while (error == 0 && has_record) {
+	if (error)
+		return error;
+
+	while (has_record) {
+		unsigned int		i, hole_idx;
+
 		error = xfs_inobt_get_rec(cur, &irec, &has_record);
-		if (error || irec.ir_startino > high)
+		if (error)
+			return error;
+		if (irec.ir_startino > high)
 			break;
 
-		agino = irec.ir_startino;
-		holemask = irec.ir_holemask;
-		for (i = 0; i < XFS_INOBT_HOLEMASK_BITS; holemask >>= 1,
-				i++, agino += XFS_INODES_PER_HOLEMASK_BIT) {
-			if (holemask & 1)
+		for (i = 0; i < XFS_INODES_PER_CHUNK; i++) {
+			if (irec.ir_startino + i < low)
 				continue;
-			if (agino + XFS_INODES_PER_HOLEMASK_BIT > low &&
-					agino <= high) {
-				*exists = true;
-				return 0;
-			}
+			if (irec.ir_startino + i > high)
+				break;
+
+			hole_idx = i / XFS_INODES_PER_HOLEMASK_BIT;
+			if (!(irec.ir_holemask & (1U << hole_idx)))
+				ret++;
 		}
 
 		error = xfs_btree_increment(cur, 0, &has_record);
+		if (error)
+			return error;
 	}
-	return error;
+
+	*allocated = ret;
+	return 0;
 }
 
 /* Is there an inode record covering a given extent? */
@@ -2702,15 +2708,27 @@ xfs_ialloc_has_inodes_at_extent(
 	struct xfs_btree_cur	*cur,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
-	bool			*exists)
+	enum xbtree_recpacking	*outcome)
 {
-	xfs_agino_t		low;
-	xfs_agino_t		high;
+	xfs_agino_t		agino;
+	xfs_agino_t		last_agino;
+	unsigned int		allocated;
+	int			error;
 
-	low = XFS_AGB_TO_AGINO(cur->bc_mp, bno);
-	high = XFS_AGB_TO_AGINO(cur->bc_mp, bno + len) - 1;
+	agino = XFS_AGB_TO_AGINO(cur->bc_mp, bno);
+	last_agino = XFS_AGB_TO_AGINO(cur->bc_mp, bno + len) - 1;
 
-	return xfs_ialloc_has_inode_record(cur, low, high, exists);
+	error = xfs_ialloc_count_ondisk(cur, agino, last_agino, &allocated);
+	if (error)
+		return error;
+
+	if (allocated == 0)
+		*outcome = XBTREE_RECPACKING_EMPTY;
+	else if (allocated == last_agino - agino + 1)
+		*outcome = XBTREE_RECPACKING_FULL;
+	else
+		*outcome = XBTREE_RECPACKING_SPARSE;
+	return 0;
 }
 
 struct xfs_ialloc_count_inodes {
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index fa67bb090c01..fa4d506086b9 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -95,9 +95,8 @@ void xfs_inobt_btrec_to_irec(struct xfs_mount *mp,
 xfs_failaddr_t xfs_inobt_check_irec(struct xfs_btree_cur *cur,
 		const struct xfs_inobt_rec_incore *irec);
 int xfs_ialloc_has_inodes_at_extent(struct xfs_btree_cur *cur,
-		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
-int xfs_ialloc_has_inode_record(struct xfs_btree_cur *cur, xfs_agino_t low,
-		xfs_agino_t high, bool *exists);
+		xfs_agblock_t bno, xfs_extlen_t len,
+		enum xbtree_recpacking *outcome);
 int xfs_ialloc_count_inodes(struct xfs_btree_cur *cur, xfs_agino_t *count,
 		xfs_agino_t *freecount);
 int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 65a6c01df235..598112471d07 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -765,18 +765,18 @@ xchk_xref_inode_check(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		len,
 	struct xfs_btree_cur	**icur,
-	bool			should_have_inodes)
+	enum xbtree_recpacking	expected)
 {
-	bool			has_inodes;
+	enum xbtree_recpacking	outcome;
 	int			error;
 
 	if (!(*icur) || xchk_skip_xref(sc->sm))
 		return;
 
-	error = xfs_ialloc_has_inodes_at_extent(*icur, agbno, len, &has_inodes);
+	error = xfs_ialloc_has_inodes_at_extent(*icur, agbno, len, &outcome);
 	if (!xchk_should_check_xref(sc, &error, icur))
 		return;
-	if (has_inodes != should_have_inodes)
+	if (outcome != expected)
 		xchk_btree_xref_set_corrupt(sc, *icur, 0);
 }
 
@@ -787,8 +787,10 @@ xchk_xref_is_not_inode_chunk(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		len)
 {
-	xchk_xref_inode_check(sc, agbno, len, &sc->sa.ino_cur, false);
-	xchk_xref_inode_check(sc, agbno, len, &sc->sa.fino_cur, false);
+	xchk_xref_inode_check(sc, agbno, len, &sc->sa.ino_cur,
+			XBTREE_RECPACKING_EMPTY);
+	xchk_xref_inode_check(sc, agbno, len, &sc->sa.fino_cur,
+			XBTREE_RECPACKING_EMPTY);
 }
 
 /* xref check that the extent is covered by inodes */
@@ -798,5 +800,6 @@ xchk_xref_is_inode_chunk(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		len)
 {
-	xchk_xref_inode_check(sc, agbno, len, &sc->sa.ino_cur, true);
+	xchk_xref_inode_check(sc, agbno, len, &sc->sa.ino_cur,
+			XBTREE_RECPACKING_FULL);
 }

