Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D56C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiJBSdu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiJBSdi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:33:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95A53C164
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:33:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3447B60F04
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7A5C433D7;
        Sun,  2 Oct 2022 18:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735615;
        bh=tuioNSSBNdk+NnlePDe71F3LQpHGg+qPDwnsg+gZKoI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MiIi8BDznSIugtRp7xxbjlQ9DhFeLKtRfe1w/DQBIWDTkDsbzCGlQqvsD4kKGlPtA
         ZAGss0K3gb2tC6MP8y4L5lx5HpybPC+M8Ir/KBTWdpFanQTL4vudSeYfr6Hh83Rg0Q
         uFhqVG4MbySsAXlVR47mJXZDQSm6JN+3VSEb1x+3q35QS+4ww5kaLlg/vi4yuI+5Cl
         3yqBbIWqB41ebX9ULBAzO3KQuF+fQ7PRKOHcIqdRkqg/Yv9d/TI+yTBpKu//yb7cph
         nkvri/NocmXP/9XoBcD1bqrYbLdXIRB/DwMNML3Tyfdi1KpHwUkXHlb5NRYyV77wBm
         kj6/vajnRgn8g==
Subject: [PATCH 3/3] xfs: convert xfs_ialloc_has_inodes_at_extent to return
 keyfill scan results
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:19 -0700
Message-ID: <166473481996.1084372.10548582075487302075.stgit@magnolia>
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
index 6cdfd64bc56b..63f5d637c83b 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2632,44 +2632,50 @@ xfs_ialloc_read_agi(
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
@@ -2678,15 +2684,27 @@ xfs_ialloc_has_inodes_at_extent(
 	struct xfs_btree_cur	*cur,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
-	bool			*exists)
+	enum xfs_btree_keyfill	*outcome)
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
+		*outcome = XFS_BTREE_KEYFILL_EMPTY;
+	else if (allocated == last_agino - agino + 1)
+		*outcome = XFS_BTREE_KEYFILL_FULL;
+	else
+		*outcome = XFS_BTREE_KEYFILL_SPARSE;
+	return 0;
 }
 
 struct xfs_ialloc_count_inodes {
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 9bbbca6ac4ed..96b99e6fbe11 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -93,9 +93,8 @@ void xfs_inobt_btrec_to_irec(struct xfs_mount *mp,
 		const union xfs_btree_rec *rec,
 		struct xfs_inobt_rec_incore *irec);
 int xfs_ialloc_has_inodes_at_extent(struct xfs_btree_cur *cur,
-		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
-int xfs_ialloc_has_inode_record(struct xfs_btree_cur *cur, xfs_agino_t low,
-		xfs_agino_t high, bool *exists);
+		xfs_agblock_t bno, xfs_extlen_t len,
+		enum xfs_btree_keyfill *outcome);
 int xfs_ialloc_count_inodes(struct xfs_btree_cur *cur, xfs_agino_t *count,
 		xfs_agino_t *freecount);
 int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index b889142ccebe..43228f44d18f 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -788,18 +788,18 @@ xchk_xref_inode_check(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		len,
 	struct xfs_btree_cur	**icur,
-	bool			should_have_inodes)
+	enum xfs_btree_keyfill	expected)
 {
-	bool			has_inodes;
+	enum xfs_btree_keyfill	keyfill;
 	int			error;
 
 	if (!(*icur) || xchk_skip_xref(sc->sm))
 		return;
 
-	error = xfs_ialloc_has_inodes_at_extent(*icur, agbno, len, &has_inodes);
+	error = xfs_ialloc_has_inodes_at_extent(*icur, agbno, len, &keyfill);
 	if (!xchk_should_check_xref(sc, &error, icur))
 		return;
-	if (has_inodes != should_have_inodes)
+	if (keyfill != expected)
 		xchk_btree_xref_set_corrupt(sc, *icur, 0);
 }
 
@@ -810,8 +810,10 @@ xchk_xref_is_not_inode_chunk(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		len)
 {
-	xchk_xref_inode_check(sc, agbno, len, &sc->sa.ino_cur, false);
-	xchk_xref_inode_check(sc, agbno, len, &sc->sa.fino_cur, false);
+	xchk_xref_inode_check(sc, agbno, len, &sc->sa.ino_cur,
+			XFS_BTREE_KEYFILL_EMPTY);
+	xchk_xref_inode_check(sc, agbno, len, &sc->sa.fino_cur,
+			XFS_BTREE_KEYFILL_EMPTY);
 }
 
 /* xref check that the extent is covered by inodes */
@@ -821,5 +823,6 @@ xchk_xref_is_inode_chunk(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		len)
 {
-	xchk_xref_inode_check(sc, agbno, len, &sc->sa.ino_cur, true);
+	xchk_xref_inode_check(sc, agbno, len, &sc->sa.ino_cur,
+			XFS_BTREE_KEYFILL_FULL);
 }

