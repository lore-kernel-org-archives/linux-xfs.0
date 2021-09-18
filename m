Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F23C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAF7D6112E
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbhIRBbA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 21:31:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234491AbhIRBbA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 21:31:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B4BF6112E;
        Sat, 18 Sep 2021 01:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631928577;
        bh=U/9Qu3oukMyZK286hOUMfC8/pnJuPu4at7I3d6qFlSU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nNSoZ7o0AZS9HNti3ZPuIe/FzBvob83H0CRXANwyWzq6cBmb8J+bZc1oThuLyuwIF
         EoH68dPPx4d72G7fH8NOBXxSflUUswdobTd0MFxgOKa8r+dSE9Kg+dNZ2XHNPc5kCT
         f8SPgMOOSSBZ2zPRQ6JRVN59u+1v1wqFkyH0iEA3FcttVlREoQtIrt/zdiWrwKRYFO
         QA4Sar4HyudtpI+CXPmdKwo8wkDui7dDV65s7Q74AEK7E7m5Fx1An/lOdnVZS7vkOm
         QmVIRKSHn8ngtR7tIZPjoFyPABcZBFOXkubFkTLb+dgnezwxVp6Kyk4cHSnu7nkBpa
         tcrJfLwP2VFpg==
Subject: [PATCH 05/14] xfs: stricter btree height checking when scanning for
 btree roots
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Sep 2021 18:29:37 -0700
Message-ID: <163192857728.416199.11679791890386351921.stgit@magnolia>
In-Reply-To: <163192854958.416199.3396890438240296942.stgit@magnolia>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're scanning for btree roots to rebuild the AG headers, make sure
that the proposed tree does not exceed the maximum height for that btree
type (and not just XFS_BTREE_MAXLEVELS).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |    8 +++++++-
 fs/xfs/scrub/repair.h          |    3 +++
 2 files changed, 10 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 0f8deee66f15..05c27149b65d 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -122,7 +122,7 @@ xrep_check_btree_root(
 	xfs_agnumber_t			agno = sc->sm->sm_agno;
 
 	return xfs_verify_agbno(mp, agno, fab->root) &&
-	       fab->height <= XFS_BTREE_MAXLEVELS;
+	       fab->height <= fab->maxlevels;
 }
 
 /*
@@ -339,18 +339,22 @@ xrep_agf(
 		[XREP_AGF_BNOBT] = {
 			.rmap_owner = XFS_RMAP_OWN_AG,
 			.buf_ops = &xfs_bnobt_buf_ops,
+			.maxlevels = sc->mp->m_ag_maxlevels,
 		},
 		[XREP_AGF_CNTBT] = {
 			.rmap_owner = XFS_RMAP_OWN_AG,
 			.buf_ops = &xfs_cntbt_buf_ops,
+			.maxlevels = sc->mp->m_ag_maxlevels,
 		},
 		[XREP_AGF_RMAPBT] = {
 			.rmap_owner = XFS_RMAP_OWN_AG,
 			.buf_ops = &xfs_rmapbt_buf_ops,
+			.maxlevels = sc->mp->m_rmap_maxlevels,
 		},
 		[XREP_AGF_REFCOUNTBT] = {
 			.rmap_owner = XFS_RMAP_OWN_REFC,
 			.buf_ops = &xfs_refcountbt_buf_ops,
+			.maxlevels = sc->mp->m_refc_maxlevels,
 		},
 		[XREP_AGF_END] = {
 			.buf_ops = NULL,
@@ -881,10 +885,12 @@ xrep_agi(
 		[XREP_AGI_INOBT] = {
 			.rmap_owner = XFS_RMAP_OWN_INOBT,
 			.buf_ops = &xfs_inobt_buf_ops,
+			.maxlevels = M_IGEO(sc->mp)->inobt_maxlevels,
 		},
 		[XREP_AGI_FINOBT] = {
 			.rmap_owner = XFS_RMAP_OWN_INOBT,
 			.buf_ops = &xfs_finobt_buf_ops,
+			.maxlevels = M_IGEO(sc->mp)->inobt_maxlevels,
 		},
 		[XREP_AGI_END] = {
 			.buf_ops = NULL
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 3bb152d52a07..840f74ec431c 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -44,6 +44,9 @@ struct xrep_find_ag_btree {
 	/* in: buffer ops */
 	const struct xfs_buf_ops	*buf_ops;
 
+	/* in: maximum btree height */
+	unsigned int			maxlevels;
+
 	/* out: the highest btree block found and the tree height */
 	xfs_agblock_t			root;
 	unsigned int			height;

