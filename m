Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01749ECAAA1
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 23:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJ3Xmi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 19:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ3Xmh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 19:42:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65E89FEA
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 16:42:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83DAE60F84
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 23:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E129CC433D7;
        Sun, 30 Oct 2022 23:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667173355;
        bh=2wlEmAAcV+w4f/LnlJjmyuEHNlqyPg9WaKZOA3RIyxg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EclSefjlPFqamVeOG0kxagPLfaXKAbTg7li9MgfB5oHf5fGW1IAIWZjpHVaGSqNeI
         MjhBjpEKbVNnV1hIJ8hYLMmCOixm+1i4HKEHwWgwPAVuDehgCfo6xJYcJ0YHtal6DK
         by7H5hbSi9uPS9Fb4pFW66Lti7TCApjPDsKMrmsRvlDfiEcCFdXqlv3aywcru/vzk6
         ASuB0/JOha4qLF+uNCr9q5SNBCItmzcf2Fubx39Ntukz8fX8BDxbfUvr/IwaUSrg9W
         i8ciwSxKJxfoDmrSeCuchAjowUPj0vWhstCxIBPyR378qObR65s8lUxtJbblrsaxLe
         c44QCqYp06VTQ==
Subject: [PATCH 13/13] xfs: rename XFS_REFC_COW_START to _COWFLAG
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Sun, 30 Oct 2022 16:42:35 -0700
Message-ID: <166717335551.417886.6742910936640805015.stgit@magnolia>
In-Reply-To: <166717328145.417886.10627661186183843873.stgit@magnolia>
References: <166717328145.417886.10627661186183843873.stgit@magnolia>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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
index 44d4667d4301..3f34bafe18dd 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -108,8 +108,8 @@ xfs_refcount_btrec_to_irec(
 	uint32_t			start;
 
 	start = be32_to_cpu(rec->refc.rc_startblock);
-	if (start & XFS_REFC_COW_START) {
-		start &= ~XFS_REFC_COW_START;
+	if (start & XFS_REFC_COWFLAG) {
+		start &= ~XFS_REFC_COWFLAG;
 		irec->rc_domain = XFS_REFC_DOMAIN_COW;
 	} else {
 		irec->rc_domain = XFS_REFC_DOMAIN_SHARED;
@@ -1799,7 +1799,7 @@ xfs_refcount_recover_cow_leftovers(
 	int				error;
 
 	/* reflink filesystems mustn't have AGs larger than 2^31-1 blocks */
-	BUILD_BUG_ON(XFS_MAX_CRC_AG_BLOCKS >= XFS_REFC_COW_START);
+	BUILD_BUG_ON(XFS_MAX_CRC_AG_BLOCKS >= XFS_REFC_COWFLAG);
 	if (mp->m_sb.sb_agblocks > XFS_MAX_CRC_AG_BLOCKS)
 		return -EOPNOTSUPP;
 
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index ee32e8eb5a99..452f30556f5a 100644
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

