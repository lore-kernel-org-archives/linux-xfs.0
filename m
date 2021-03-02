Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9125C4360C
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0480601FF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343550AbhCCDQH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:16:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2360825AbhCBW35 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Mar 2021 17:29:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75EFB64F39;
        Tue,  2 Mar 2021 22:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614724156;
        bh=zIcU4r6u4b6L6Ldt0s8f+DVdv1Nw8eu9IRF/Ajcbe64=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FkR4W9YsGyLvsT3fJwWirs+yPU9B3ELGUXVj4+/ENq0klZXNGcbn1LvWDFiHf7q5e
         0OkFeVSXGdqKsM8CUCLHTqPPE6TUEoZicwC9pIeK7P9gJTifFbAQwZLt+jjc3zrCBE
         +R6Hrir6+rEWg6nnLsV6sT13BE8OjW4uDV+abLDU5+blS2HsQwpPrnZEiK4Ug9HuWc
         cq6KyQhg4AZVUV4+IU5HcFR14WBII3df8DAkA1lMhsRUCAtDQHrIbg6GyRpPUzOaLn
         /pBx1b0GTIYsXEghqgh3rIM2eKlWkKV5oL/UtJkAnwaG84vAKafsAjs2vnLDHE8EY3
         ni8N167iL0LFw==
Subject: [PATCH 7/7] xfs: validate ag btree levels using the precomputed
 values
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 02 Mar 2021 14:29:16 -0800
Message-ID: <161472415607.3421582.13410103932115410995.stgit@magnolia>
In-Reply-To: <161472411627.3421582.2040330025988154363.stgit@magnolia>
References: <161472411627.3421582.2040330025988154363.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use the AG btree height limits that we precomputed into the xfs_mount to
validate the AG headers instead of using XFS_BTREE_MAXLEVELS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c      |    8 ++++----
 fs/xfs/libxfs/xfs_ialloc.c     |    4 ++--
 fs/xfs/libxfs/xfs_inode_fork.c |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 0c623d3c1036..aaa19101bb2a 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2906,13 +2906,13 @@ xfs_agf_verify(
 
 	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) < 1 ||
-	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS ||
-	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) > XFS_BTREE_MAXLEVELS)
+	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > mp->m_ag_maxlevels ||
+	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) > mp->m_ag_maxlevels)
 		return __this_address;
 
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
 	    (be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) < 1 ||
-	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > XFS_BTREE_MAXLEVELS))
+	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > mp->m_rmap_maxlevels))
 		return __this_address;
 
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
@@ -2939,7 +2939,7 @@ xfs_agf_verify(
 
 	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
 	    (be32_to_cpu(agf->agf_refcount_level) < 1 ||
-	     be32_to_cpu(agf->agf_refcount_level) > XFS_BTREE_MAXLEVELS))
+	     be32_to_cpu(agf->agf_refcount_level) > mp->m_refc_maxlevels))
 		return __this_address;
 
 	return NULL;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 69b228fce81a..eefdb518fe64 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2535,12 +2535,12 @@ xfs_agi_verify(
 		return __this_address;
 
 	if (be32_to_cpu(agi->agi_level) < 1 ||
-	    be32_to_cpu(agi->agi_level) > XFS_BTREE_MAXLEVELS)
+	    be32_to_cpu(agi->agi_level) > M_IGEO(mp)->inobt_maxlevels)
 		return __this_address;
 
 	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
 	    (be32_to_cpu(agi->agi_free_level) < 1 ||
-	     be32_to_cpu(agi->agi_free_level) > XFS_BTREE_MAXLEVELS))
+	     be32_to_cpu(agi->agi_free_level) > M_IGEO(mp)->inobt_maxlevels))
 		return __this_address;
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index e080d7e07643..192bcf3e549d 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -195,7 +195,7 @@ xfs_iformat_btree(
 		     XFS_BMDR_SPACE_CALC(nrecs) >
 					XFS_DFORK_SIZE(dip, mp, whichfork) ||
 		     ifp->if_nextents > ip->i_d.di_nblocks) ||
-		     level == 0 || level > XFS_BTREE_MAXLEVELS) {
+		     level == 0 || level > XFS_BM_MAXLEVELS(mp, whichfork)) {
 		xfs_warn(mp, "corrupt inode %Lu (btree).",
 					(unsigned long long) ip->i_ino);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,

