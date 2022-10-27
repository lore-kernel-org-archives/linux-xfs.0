Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F17EECAAA1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 17:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234719AbiJ0RPS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 13:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235028AbiJ0RPR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 13:15:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D78353A57
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 10:15:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5164DB82722
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 17:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107C8C433D6;
        Thu, 27 Oct 2022 17:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666890911;
        bh=FUUpmaOL0K38r/UPwXaa48ww64eDCkti864VL95a3uA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lwcgHQW8lE9xIeKhvVdm2N3gYnpg7o/cAZAU7Aa4LvF8qNJdGa8PT8NV953vbHYIq
         Pavo5ph63LXwJUfpdlPyVo1uCbEgk9AQk/CQCyxRkJuk/h1jYvqzcN7tsy4oJff+2s
         4NPM2us14bUY+VWjluY9InGvKSjpX1Jwl49ZAHK7jn9bRsR3XWVf4659kvPWdGlCRe
         yKioo1lfLnpToTrN0cEs6IdyCkx3E+SrO5XnuO4VnZ7Z6Dv4zv024usaG9Tc/zWhlM
         78s/FC3DKP08AnTPWaGHu/ixdDDUr6VpOZwrkmbVt2snwVfoZo7ll8zrH4vrN6vqLS
         ailw4A9H47g5A==
Subject: [PATCH 12/12] xfs: rename XFS_REFC_COW_START to _COWFLAG
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Oct 2022 10:15:10 -0700
Message-ID: <166689091062.3788582.5745982343341644557.stgit@magnolia>
In-Reply-To: <166689084304.3788582.15155501738043912776.stgit@magnolia>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_format.h   |    2 +-
 fs/xfs/libxfs/xfs_refcount.c |    6 +++---
 fs/xfs/libxfs/xfs_refcount.h |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 005dd65b71cd..371dc07233e0 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1612,7 +1612,7 @@ unsigned int xfs_refc_block(struct xfs_mount *mp);
  * on the startblock.  This speeds up mount time deletion of stale
  * staging extents because they're all at the right side of the tree.
  */
-#define XFS_REFC_COW_START		((xfs_agblock_t)(1U << 31))
+#define XFS_REFC_COWFLAG		(1U << 31)
 #define REFCNTBT_COWFLAG_BITLEN		1
 #define REFCNTBT_AGBLOCK_BITLEN		31
 
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 05fa18b9e0ed..740959445170 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -108,8 +108,8 @@ xfs_refcount_btrec_to_irec(
 	__u32				start;
 
 	start = be32_to_cpu(rec->refc.rc_startblock);
-	if (start & XFS_REFC_COW_START) {
-		start &= ~XFS_REFC_COW_START;
+	if (start & XFS_REFC_COWFLAG) {
+		start &= ~XFS_REFC_COWFLAG;
 		irec->rc_domain = XFS_REFC_DOMAIN_COW;
 	} else {
 		irec->rc_domain = XFS_REFC_DOMAIN_SHARED;
@@ -1814,7 +1814,7 @@ xfs_refcount_recover_cow_leftovers(
 	int				error;
 
 	/* reflink filesystems mustn't have AGs larger than 2^31-1 blocks */
-	BUILD_BUG_ON(XFS_MAX_CRC_AG_BLOCKS >= XFS_REFC_COW_START);
+	BUILD_BUG_ON(XFS_MAX_CRC_AG_BLOCKS >= XFS_REFC_COWFLAG);
 	if (mp->m_sb.sb_agblocks > XFS_MAX_CRC_AG_BLOCKS)
 		return -EOPNOTSUPP;
 
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index d666a0e32659..cb42365596b2 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
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

