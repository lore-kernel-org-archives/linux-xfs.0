Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E945DC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D177B610CB
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243752AbhIXB2X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:28:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243745AbhIXB2X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Sep 2021 21:28:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5369604E9;
        Fri, 24 Sep 2021 01:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632446810;
        bh=zZNNqDnk059e51dML5eQ54aTywK5tD+ZUvNN5NGi+YA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FuZlKM1QPu+0StYNk05OGUdbzrO6vVg3MFqrYbeMkMlC24Bpbx76bTv4tZ4HF7ZzY
         uZcnwOGI8DMNoAjKgSDRRUT9+ZBk6Pd94hqQJ5LrG/ZjEck41OTVvqXuTtNVaqel0E
         +pSFOmYQmHZwzEHNkmjhpEAdl/M8fPT+6fLgk0nGKQc4IWWpt8qTYSTz4K4vnYcOQS
         Hi3tdXC/5CKjTKSSGuSoS3oBZNL2Hi1alJLDi9+Y9WgWnrCQvRIxUyjnffp9PkweVj
         +cnqAvP+aTTlKa0Kf8uNeC78Oqwxe52jWV7YB+rxxJfrZ3E8jMNBdj3h0CHxMeMX7k
         Jo6aIdynploAw==
Subject: [PATCH 07/15] xfs: stricter btree height checking when scanning for
 btree roots
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 23 Sep 2021 18:26:50 -0700
Message-ID: <163244681046.2701302.16309740082564344334.stgit@magnolia>
In-Reply-To: <163244677169.2701302.12882919857957905332.stgit@magnolia>
References: <163244677169.2701302.12882919857957905332.stgit@magnolia>
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
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
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

