Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42370C4332B
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E11464F57
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbhCRWd5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 18:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231916AbhCRWdp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 18:33:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A3CB64E02;
        Thu, 18 Mar 2021 22:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616106825;
        bh=0jMn6I3jOnka5z+SbgEocuNH+1lVNYTfRRCqbrqcy+U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=URLvmxuiDi23Auhjo0IeEac5lFBwzQ5v/wBrtpdHi95nAE9zuw6f4UEnId9G2Vm43
         7VImqaiX6g/LfpuUja4adiGq98ZwhGqRSdMhblOI99dBs8atiu71iG2AkPmQPCEjFk
         qJy98+EcsxekXA+7Gys8Bhjl/Ji4AVnonuHBIXMInzbwPJ91M4nEjR/oIqiH2fZ2Cl
         hwUsByf40XwXaHvQ/Mfn03ub2Wi9WW8azjg0XqfOVf8TK4HiOYghv7RCanfGGdg3zu
         OHR6jtF1HC+jDGVu4WHpLkgm3AMJGXAXiAYmfaXowUaLtUihifnqXyau2bIf8CoJF+
         pkS0LcmgLuBvQ==
Subject: [PATCH 1/3] xfs: remove tag parameter from xfs_inode_walk{,_ag}
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 18 Mar 2021 15:33:45 -0700
Message-ID: <161610682523.1887634.9689710010549931486.stgit@magnolia>
In-Reply-To: <161610681966.1887634.12780057277967410395.stgit@magnolia>
References: <161610681966.1887634.12780057277967410395.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

It turns out that there is a 1:1 mapping between the execute and tag
parameters that are passed to xfs_inode_walk_ag:

	xfs_dqrele_inode => XFS_ICI_NO_TAG
	xfs_blockgc_scan_inode => XFS_ICI_BLOCKGC_TAG

The radix tree tags are an implementation detail of the inode cache,
which means that callers outside of xfs_icache.c have no business
passing in radix tree tags.  Since we're about to get rid of the
indirect calls in the BLOCKGC case, eliminate the extra argument in
favor of computing the ICI tag from the execute argument passed into the
function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c      |   27 ++++++++++++++++++---------
 fs/xfs/xfs_icache.h      |    2 +-
 fs/xfs/xfs_qm_syscalls.c |    3 +--
 3 files changed, 20 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7353c9fe05db..6924125a3c53 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -26,6 +26,9 @@
 
 #include <linux/iversion.h>
 
+/* Forward declarations to reduce indirect calls in xfs_inode_walk_ag */
+static int xfs_blockgc_scan_inode(struct xfs_inode *ip, void *args);
+
 /*
  * Allocate and initialise an xfs_inode.
  */
@@ -763,6 +766,14 @@ xfs_inode_walk_ag_grab(
 	return false;
 }
 
+static inline int
+inode_walk_fn_to_tag(int (*execute)(struct xfs_inode *ip, void *args))
+{
+	if (execute == xfs_blockgc_scan_inode)
+		return XFS_ICI_BLOCKGC_TAG;
+	return XFS_ICI_NO_TAG;
+}
+
 /*
  * For a given per-AG structure @pag, grab, @execute, and rele all incore
  * inodes with the given radix tree @tag.
@@ -772,14 +783,14 @@ xfs_inode_walk_ag(
 	struct xfs_perag	*pag,
 	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
-	void			*args,
-	int			tag)
+	void			*args)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 	uint32_t		first_index;
 	int			last_error = 0;
 	int			skipped;
 	bool			done;
+	int			tag = inode_walk_fn_to_tag(execute);
 	int			nr_found;
 
 restart:
@@ -893,18 +904,18 @@ xfs_inode_walk(
 	struct xfs_mount	*mp,
 	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
-	void			*args,
-	int			tag)
+	void			*args)
 {
 	struct xfs_perag	*pag;
 	int			error = 0;
 	int			last_error = 0;
+	int			tag = inode_walk_fn_to_tag(execute);
 	xfs_agnumber_t		ag;
 
 	ag = 0;
 	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_inode_walk_ag(pag, iter_flags, execute, args, tag);
+		error = xfs_inode_walk_ag(pag, iter_flags, execute, args);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
@@ -1613,8 +1624,7 @@ xfs_blockgc_worker(
 
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
-	error = xfs_inode_walk_ag(pag, 0, xfs_blockgc_scan_inode, NULL,
-			XFS_ICI_BLOCKGC_TAG);
+	error = xfs_inode_walk_ag(pag, 0, xfs_blockgc_scan_inode, NULL);
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
 				pag->pag_agno, error);
@@ -1632,8 +1642,7 @@ xfs_blockgc_free_space(
 {
 	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
 
-	return xfs_inode_walk(mp, 0, xfs_blockgc_scan_inode, eofb,
-			XFS_ICI_BLOCKGC_TAG);
+	return xfs_inode_walk(mp, 0, xfs_blockgc_scan_inode, eofb);
 }
 
 /*
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d1fddb152420..a20bb89e3a38 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -70,7 +70,7 @@ void xfs_blockgc_worker(struct work_struct *work);
 
 int xfs_inode_walk(struct xfs_mount *mp, int iter_flags,
 	int (*execute)(struct xfs_inode *ip, void *args),
-	void *args, int tag);
+	void *args);
 
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 				  xfs_ino_t ino, bool *inuse);
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index ca1b57d291dc..2f42ea8a09ab 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -795,6 +795,5 @@ xfs_qm_dqrele_all_inodes(
 	uint			flags)
 {
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
-			&flags, XFS_ICI_NO_TAG);
+	xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode, &flags);
 }

