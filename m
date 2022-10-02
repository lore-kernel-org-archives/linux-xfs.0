Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A7FC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiJBSbN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiJBSbM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:31:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999A6286DB
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:31:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34CE6B80113
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CC0C433C1;
        Sun,  2 Oct 2022 18:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735467;
        bh=gDln7am66gxkMLYoNL9pdfTghLch92aOM4O7rM3GTxQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=p4eqNx+GibwHdDdRiIS8xwxhZz0YKcGYz/UabRx9Y/lgIU/4bPAbJjfEa25UfacOi
         FN+T/cyMo3I2xxQSRkOuTGI21910iqjog2Bd7Yrpw/yysWctAUAbQsTN5aIWKAdFzb
         zH6tw+ihGj80ObzIC/laxoiLDuxEyBPd6CPkkf2AdNBcJifLuYV4mCdP6dDFyRnPT4
         WXNTBnU5FW6M79X2DhgPf5xioHQZB2AFVzHuhj668qI4szAXcvOkJG5RX66lOmiDhW
         W8WkrRf045Zkhfs8O7NK8HGyfxb1y8MNdgLXOGFaDbudWrnsK/hj8Fwx/07Yih7B0w
         MvgvMQQ3vvmQQ==
Subject: [PATCH 2/6] xfs: teach scrub to check for adjacent bmaps when rmap
 larger than bmap
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:09 -0700
Message-ID: <166473480901.1083927.9138933758527320078.stgit@magnolia>
In-Reply-To: <166473480864.1083927.11062319917293302327.stgit@magnolia>
References: <166473480864.1083927.11062319917293302327.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When scrub is checking file fork mappings against rmap records and
the rmap record starts before or ends after the bmap record, check the
adjacent bmap records to make sure that they're adjacent to the one
we're checking.  This helps us to detect cases where the rmaps cover
territory that the bmaps do not.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c |   74 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 72 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 63e43fd8af5d..c78323c87bfe 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -93,6 +93,7 @@ xchk_setup_inode_bmap(
 
 struct xchk_bmap_info {
 	struct xfs_scrub	*sc;
+	struct xfs_iext_cursor	icur;
 	xfs_fileoff_t		lastoff;
 	bool			is_rt;
 	bool			is_shared;
@@ -149,6 +150,48 @@ xchk_bmap_get_rmap(
 	return has_rmap;
 }
 
+static inline bool
+xchk_bmap_has_prev(
+	struct xchk_bmap_info	*info,
+	struct xfs_bmbt_irec	*irec)
+{
+	struct xfs_bmbt_irec	got;
+	struct xfs_ifork	*ifp;
+
+	ifp = xfs_ifork_ptr(info->sc->ip, info->whichfork);
+
+	if (!xfs_iext_peek_prev_extent(ifp, &info->icur, &got))
+		return false;
+	if (got.br_startoff + got.br_blockcount != irec->br_startoff)
+		return false;
+	if (got.br_startblock + got.br_blockcount != irec->br_startblock)
+		return false;
+	if (got.br_state != irec->br_state)
+		return false;
+	return true;
+}
+
+static inline bool
+xchk_bmap_has_next(
+	struct xchk_bmap_info	*info,
+	struct xfs_bmbt_irec	*irec)
+{
+	struct xfs_bmbt_irec	got;
+	struct xfs_ifork	*ifp;
+
+	ifp = xfs_ifork_ptr(info->sc->ip, info->whichfork);
+
+	if (!xfs_iext_peek_next_extent(ifp, &info->icur, &got))
+		return false;
+	if (irec->br_startoff + irec->br_blockcount != got.br_startoff)
+		return false;
+	if (irec->br_startblock + irec->br_blockcount != got.br_startblock)
+		return false;
+	if (got.br_state != irec->br_state)
+		return false;
+	return true;
+}
+
 /* Make sure that we have rmapbt records for this extent. */
 STATIC void
 xchk_bmap_xref_rmap(
@@ -217,6 +260,34 @@ xchk_bmap_xref_rmap(
 	if (rmap.rm_flags & XFS_RMAP_BMBT_BLOCK)
 		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
+
+	/*
+	 * If the rmap starts before this bmbt record, make sure there's a bmbt
+	 * record for the previous offset that is contiguous with this mapping.
+	 * Skip this for CoW fork extents because the refcount btree (and not
+	 * the inode) is the ondisk owner for those extents.
+	 */
+	if (info->whichfork != XFS_COW_FORK && rmap.rm_startblock < agbno &&
+	    !xchk_bmap_has_prev(info, irec)) {
+		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
+				irec->br_startoff);
+		return;
+	}
+
+	/*
+	 * If the rmap ends after this bmbt record, make sure there's a bmbt
+	 * record for the next offset that is contiguous with this mapping.
+	 * Skip this for CoW fork extents because the refcount btree (and not
+	 * the inode) is the ondisk owner for those extents.
+	 */
+	rmap_end = (unsigned long long)rmap.rm_startblock + rmap.rm_blockcount;
+	if (info->whichfork != XFS_COW_FORK &&
+	    rmap_end > agbno + irec->br_blockcount &&
+	    !xchk_bmap_has_next(info, irec)) {
+		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
+				irec->br_startoff);
+		return;
+	}
 }
 
 /* Cross-reference a single rtdev extent record. */
@@ -629,7 +700,6 @@ xchk_bmap(
 	struct xfs_inode	*ip = sc->ip;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	xfs_fileoff_t		endoff;
-	struct xfs_iext_cursor	icur;
 	int			error = 0;
 
 	/* Non-existent forks can be ignored. */
@@ -693,7 +763,7 @@ xchk_bmap(
 	/* Scrub extent records. */
 	info.lastoff = 0;
 	ifp = xfs_ifork_ptr(ip, whichfork);
-	for_each_xfs_iext(ifp, &icur, &irec) {
+	for_each_xfs_iext(ifp, &info.icur, &irec) {
 		if (xchk_should_terminate(sc, &error) ||
 		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 			goto out;

