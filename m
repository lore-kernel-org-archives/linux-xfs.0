Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B188C67871
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 23:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiJXXOR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 19:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiJXXNe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 19:13:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375C252FD2
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 14:34:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD18F615CE
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 21:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394C5C433C1;
        Mon, 24 Oct 2022 21:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666647212;
        bh=fRFx+bcOzWrLi9ZRxLnrgmZwNgKlXkSQ4ZuPsjt44Bo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ph/sYcBZ4TSyna83LauVMwWCO8MpQvXzgpDoWjoO+1RqiIZ5xBLvvEtvA35MGCzjw
         EcEuwWPW+0SUxd6OyL8f3jj0+n+0SRIaswbJU4WHa9nkVGt7YE7YOcEmGam2RRtGWJ
         HMRhSFzdpooph9O+oACcYV5/BOlHRbqLILGD+4r1B9pkwTDQPouvmrJb6/kI+UVFrh
         kN3nNHnk+E4SKXGW/jgrdoz095Vi+UmfEmH6qnxkqr2XT43gaCxIXNEjo5VG01TeYk
         Da8ZIMg0mIm07cokBedJ5nHDzdvaE9TnORJmPfbUtwLs2oESUECTSALglemRYVaw5P
         CITGvwq1jlXkA==
Subject: [PATCH 4/5] xfs: rename XFS_REFC_COW_START to _COWFLAG
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Oct 2022 14:33:31 -0700
Message-ID: <166664721160.2690245.14106535587593195050.stgit@magnolia>
In-Reply-To: <166664718897.2690245.5721183007309479393.stgit@magnolia>
References: <166664718897.2690245.5721183007309479393.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We've been (ab)using XFS_REFC_COW_START as both an integer quantity and
a bit flag, even though it's *only* a bit flag.  Rename the variable to
reflect its nature and update the cast target since we're not supposed
to be comparing it to xfs_agblock_t now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h         |    2 +-
 fs/xfs/libxfs/xfs_refcount.c       |   18 +++++++++---------
 fs/xfs/libxfs/xfs_refcount_btree.c |    4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 005dd65b71cd..2ce588f154e1 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1612,7 +1612,7 @@ unsigned int xfs_refc_block(struct xfs_mount *mp);
  * on the startblock.  This speeds up mount time deletion of stale
  * staging extents because they're all at the right side of the tree.
  */
-#define XFS_REFC_COW_START		((xfs_agblock_t)(1U << 31))
+#define XFS_REFC_COWFLAG		((uint32_t)(1U << 31))
 #define REFCNTBT_COWFLAG_BITLEN		1
 #define REFCNTBT_AGBLOCK_BITLEN		31
 
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index fa75e785652b..3e6cc1777ffb 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -51,7 +51,7 @@ xfs_refcount_lookup_le(
 	int			*stat)
 {
 	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			bno | (domain == XFS_RCDOM_COW ? XFS_REFC_COW_START : 0),
+			bno | (domain == XFS_RCDOM_COW ? XFS_REFC_COWFLAG : 0),
 			XFS_LOOKUP_LE);
 	cur->bc_rec.rc.rc_startblock = bno;
 	cur->bc_rec.rc.rc_blockcount = 0;
@@ -71,7 +71,7 @@ xfs_refcount_lookup_ge(
 	int			*stat)
 {
 	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			bno | (domain == XFS_RCDOM_COW ? XFS_REFC_COW_START : 0),
+			bno | (domain == XFS_RCDOM_COW ? XFS_REFC_COWFLAG : 0),
 			XFS_LOOKUP_GE);
 	cur->bc_rec.rc.rc_startblock = bno;
 	cur->bc_rec.rc.rc_blockcount = 0;
@@ -91,7 +91,7 @@ xfs_refcount_lookup_eq(
 	int			*stat)
 {
 	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			bno | (domain == XFS_RCDOM_COW ? XFS_REFC_COW_START : 0),
+			bno | (domain == XFS_RCDOM_COW ? XFS_REFC_COWFLAG : 0),
 			XFS_LOOKUP_LE);
 	cur->bc_rec.rc.rc_startblock = bno;
 	cur->bc_rec.rc.rc_blockcount = 0;
@@ -108,8 +108,8 @@ xfs_refcount_btrec_to_irec(
 	__u32				start;
 
 	start = be32_to_cpu(rec->refc.rc_startblock);
-	if (start & XFS_REFC_COW_START) {
-		start &= ~XFS_REFC_COW_START;
+	if (start & XFS_REFC_COWFLAG) {
+		start &= ~XFS_REFC_COWFLAG;
 		irec->rc_domain = XFS_RCDOM_COW;
 	} else {
 		irec->rc_domain = XFS_RCDOM_SHARED;
@@ -188,9 +188,9 @@ xfs_refcount_update(
 
 	trace_xfs_refcount_update(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
 
-	start = irec->rc_startblock & ~XFS_REFC_COW_START;
+	start = irec->rc_startblock & ~XFS_REFC_COWFLAG;
 	if (irec->rc_domain == XFS_RCDOM_COW)
-		start |= XFS_REFC_COW_START;
+		start |= XFS_REFC_COWFLAG;
 
 	rec.refc.rc_startblock = cpu_to_be32(start);
 	rec.refc.rc_blockcount = cpu_to_be32(irec->rc_blockcount);
@@ -1735,7 +1735,7 @@ xfs_refcount_recover_extent(
 		return -EFSCORRUPTED;
 
 	if (XFS_IS_CORRUPT(cur->bc_mp, !(rec->refc.rc_startblock &
-					 cpu_to_be32(XFS_REFC_COW_START))))
+					 cpu_to_be32(XFS_REFC_COWFLAG))))
 		return -EFSCORRUPTED;
 
 	rr = kmem_alloc(sizeof(struct xfs_refcount_recovery), 0);
@@ -1762,7 +1762,7 @@ xfs_refcount_recover_cow_leftovers(
 	int				error;
 
 	/* reflink filesystems mustn't have AGs larger than 2^31-1 blocks */
-	BUILD_BUG_ON(XFS_MAX_CRC_AG_BLOCKS >= XFS_REFC_COW_START);
+	BUILD_BUG_ON(XFS_MAX_CRC_AG_BLOCKS >= XFS_REFC_COWFLAG);
 	if (mp->m_sb.sb_agblocks > XFS_MAX_CRC_AG_BLOCKS)
 		return -EOPNOTSUPP;
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index b0818063aa20..fdbb2895d8c3 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -166,9 +166,9 @@ xfs_refcountbt_encode_startblock(
 	 * query functions (which set rc_domain == -1U), so we check that the
 	 * domain is /not/ shared.
 	 */
-	start = cur->bc_rec.rc.rc_startblock & ~XFS_REFC_COW_START;
+	start = cur->bc_rec.rc.rc_startblock & ~XFS_REFC_COWFLAG;
 	if (cur->bc_rec.rc.rc_domain != XFS_RCDOM_SHARED)
-		start |= XFS_REFC_COW_START;
+		start |= XFS_REFC_COWFLAG;
 	return start;
 }
 

