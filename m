Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 521F3C433C1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 07:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04D57619EC
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 07:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhCXHDO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 03:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235664AbhCXHDN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 03:03:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42747C061763
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 00:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=1JyEl+PEy/BuPUoFIeR7kpf5tkJ5SPHe6Hgql1il+PU=; b=R/xP0QyfF2N932xBPsFhRrKXzs
        vE6yab3ZR9Y7egdaRjkTmvyEcGDZuBQGmTdtHBkRyNrF+hAniDKNawFKxgnwW6hTCzLh7hM/EdMsZ
        LDetFyaqfNTiruRwplp1nj0biyGPxXRt7NSS0cpqAxCcZb0ggz7KwNebSCsQaAE2a90ojd8Pahmxs
        ub7MCqay/1sjL+L9OxAn0Xw8xetHNs+Z9Fx1/kLqF76x+ozhd4nWmr9Tb7MVj4VirDrM412Rmfn1d
        7UxNiw7tqLMMFuRsago6HdJx6mNatopVZVIyPWMjTk7FZ9OCgwoTlU78xmMzxzi468hgqPWuAxnsE
        /TCU5MgQ==;
Received: from [2001:4bb8:191:f692:b499:58dc:411a:54d1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOxXs-003uil-5K
        for linux-xfs@vger.kernel.org; Wed, 24 Mar 2021 07:03:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: use s_inodes in xfs_qm_dqrele_all_inodes
Date:   Wed, 24 Mar 2021 08:03:05 +0100
Message-Id: <20210324070307.908462-2-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210324070307.908462-1-hch@lst.de>
References: <20210324070307.908462-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Using xfs_inode_walk in xfs_qm_dqrele_all_inodes is complete overkill,
given that function simplify wants to iterate all live inodes known
to the VFS.  Just iterate over the s_inodes list.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c      |  2 +-
 fs/xfs/xfs_icache.h      |  2 ++
 fs/xfs/xfs_qm_syscalls.c | 56 +++++++++++++++++++++++++---------------
 3 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 1d7720a0c068b7..c0d084e3526a9c 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -233,7 +233,7 @@ xfs_inode_clear_reclaim_tag(
 	xfs_perag_clear_reclaim_tag(pag);
 }
 
-static void
+void
 xfs_inew_wait(
 	struct xfs_inode	*ip)
 {
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d1fddb1524200b..d70d93c2bb1084 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -78,4 +78,6 @@ int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 void xfs_blockgc_stop(struct xfs_mount *mp);
 void xfs_blockgc_start(struct xfs_mount *mp);
 
+void xfs_inew_wait(struct xfs_inode *ip);
+
 #endif
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index ca1b57d291dc90..88dfd520ae91de 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -748,41 +748,27 @@ xfs_qm_scall_getquota_next(
 	return error;
 }
 
-STATIC int
+static void
 xfs_dqrele_inode(
 	struct xfs_inode	*ip,
-	void			*args)
+	uint			flags)
 {
-	uint			*flags = args;
-
-	/* skip quota inodes */
-	if (ip == ip->i_mount->m_quotainfo->qi_uquotaip ||
-	    ip == ip->i_mount->m_quotainfo->qi_gquotaip ||
-	    ip == ip->i_mount->m_quotainfo->qi_pquotaip) {
-		ASSERT(ip->i_udquot == NULL);
-		ASSERT(ip->i_gdquot == NULL);
-		ASSERT(ip->i_pdquot == NULL);
-		return 0;
-	}
-
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if ((*flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
+	if ((flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
 		xfs_qm_dqrele(ip->i_udquot);
 		ip->i_udquot = NULL;
 	}
-	if ((*flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
+	if ((flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
 		xfs_qm_dqrele(ip->i_gdquot);
 		ip->i_gdquot = NULL;
 	}
-	if ((*flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
+	if ((flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
 		xfs_qm_dqrele(ip->i_pdquot);
 		ip->i_pdquot = NULL;
 	}
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return 0;
 }
 
-
 /*
  * Go thru all the inodes in the file system, releasing their dquots.
  *
@@ -794,7 +780,35 @@ xfs_qm_dqrele_all_inodes(
 	struct xfs_mount	*mp,
 	uint			flags)
 {
+	struct super_block	*sb = mp->m_super;
+	struct inode		*inode, *old_inode = NULL;
+
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
-			&flags, XFS_ICI_NO_TAG);
+
+	spin_lock(&sb->s_inode_list_lock);
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		struct xfs_inode	*ip = XFS_I(inode);
+
+		if (XFS_FORCED_SHUTDOWN(mp))
+			break;
+		if (xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
+			continue;
+		if (xfs_iflags_test(ip, XFS_IRECLAIMABLE | XFS_IRECLAIM))
+			continue;
+		if (!igrab(inode))
+			continue;
+		spin_unlock(&sb->s_inode_list_lock);
+
+		iput(old_inode);
+		old_inode = inode;
+
+		if (xfs_iflags_test(ip, XFS_INEW))
+			xfs_inew_wait(ip);
+		xfs_dqrele_inode(ip, flags);
+
+		spin_lock(&sb->s_inode_list_lock);
+	}
+	spin_unlock(&sb->s_inode_list_lock);
+
+	iput(old_inode);
 }
-- 
2.30.1

