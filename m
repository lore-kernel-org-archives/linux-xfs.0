Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8FEC433C1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69F7B61A42
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhCZAVl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230166AbhCZAVT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:21:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC733619D3;
        Fri, 26 Mar 2021 00:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718079;
        bh=SJP/YVcaIepGnVJ0PH+9yfWSD4b7hNQQ8/ziU0VnUxE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jOf32yO7wdtPXGYal/jXmn109IehGg9dhvBZSNEGKPrXFMpUYwlZJn6tk0U9VQJWZ
         +Yucjk3pk7LXbePFnj9I7T/QNvrYatjX6seuc57tuUGWFbUkEg9+VJSwktEDjynGM6
         zH2rs0BvSfmuzhP7PAxDhAJWY9xG9BT60XI0sAennz5pn9aAYr0EOdsP6NRDBcUkT+
         op5mAldwUjvHv9aFbtlaQCEXDmd6SQPYo+4aUm3wM8pz7SIB0lD0/03GK7yaZii7Ai
         W2JsKlfKRbQ7SQ5Z7841VI0l8/gRAqePZX/KQIRMnMvwLpmioYQhDSbDXUBXN+UT9N
         cboBM95C/A9wA==
Subject: [PATCH 1/6] xfs: use s_inodes in xfs_qm_dqrele_all_inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Date:   Thu, 25 Mar 2021 17:21:18 -0700
Message-ID: <161671807853.621936.16639622639548774275.stgit@magnolia>
In-Reply-To: <161671807287.621936.13471099564526590235.stgit@magnolia>
References: <161671807287.621936.13471099564526590235.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Using xfs_inode_walk in xfs_qm_dqrele_all_inodes is complete overkill,
given that function simplify wants to iterate all live inodes known
to the VFS.  Just iterate over the s_inodes list.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c      |    2 +-
 fs/xfs/xfs_icache.h      |    2 ++
 fs/xfs/xfs_qm_syscalls.c |   56 +++++++++++++++++++++++++++++-----------------
 3 files changed, 38 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 3c81daca0e9a..9a307bb738bd 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -235,7 +235,7 @@ xfs_inode_clear_reclaim_tag(
 	xfs_perag_clear_reclaim_tag(pag);
 }
 
-static void
+void
 xfs_inew_wait(
 	struct xfs_inode	*ip)
 {
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d1fddb152420..d70d93c2bb10 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -78,4 +78,6 @@ int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 void xfs_blockgc_stop(struct xfs_mount *mp);
 void xfs_blockgc_start(struct xfs_mount *mp);
 
+void xfs_inew_wait(struct xfs_inode *ip);
+
 #endif
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 11f1e2fbf22f..76efae956fa8 100644
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

