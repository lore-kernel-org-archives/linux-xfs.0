Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7107BC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 09:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C0E1615E1
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 09:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbhKOJ7v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Nov 2021 04:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237427AbhKOJ7q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Nov 2021 04:59:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C14C061746
        for <linux-xfs@vger.kernel.org>; Mon, 15 Nov 2021 01:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=GDRvYgIEtaUp6ZCwiLYXbcOpqC+C7+JI555fsH9imXQ=; b=qh5r1FCk8Ftyb1zF3XLZW8xlYC
        OegidZs7AvaKglVZkRoDI7cVnZfdwvUTuWM4mUg/7uMwBQAwkqsJWYsVzB5IfiRT2P6Pj7vfOXglh
        SpGbsuFgsIv2J0L7ppV/OjVBRlJuhikGT2/fp4kjjgHlHl0LzBMUwaoAaS7qOeoW5U2NspXYS6XBi
        J8gMv6UetrqtTX/ofT0gWA1EJnmRlRvIb8b0a69nnji+G0YUX9XyM0iqH1B91ksXTtlKeeNYMbaA3
        4KJ4n12R0Pix8E6r/l3mzLZKLRdps5p2KQEAyhelCEtrtkwCQFC5d5U67J6UgeR7FCoZoKiWbzBZR
        2VKLCwqQ==;
Received: from [2001:4bb8:192:3ffe:2cb6:6339:4f3e:fe11] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmYjF-005anz-7X; Mon, 15 Nov 2021 09:56:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>
Subject: [PATCH] xfs: remove xfs_inew_wait
Date:   Mon, 15 Nov 2021 10:56:43 +0100
Message-Id: <20211115095643.91254-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

With the remove of xfs_dqrele_all_inodes, xfs_inew_wait and all the
infrastructure used to wake the XFS_INEW bit waitqueue is unused.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 777eb1fa857e ("xfs: remove xfs_dqrele_all_inodes")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 21 ---------------------
 fs/xfs/xfs_inode.h  |  4 +---
 2 files changed, 1 insertion(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e1472004170e8..da4af2142a2b4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -289,22 +289,6 @@ xfs_perag_clear_inode_tag(
 	trace_xfs_perag_clear_inode_tag(mp, pag->pag_agno, tag, _RET_IP_);
 }
 
-static inline void
-xfs_inew_wait(
-	struct xfs_inode	*ip)
-{
-	wait_queue_head_t *wq = bit_waitqueue(&ip->i_flags, __XFS_INEW_BIT);
-	DEFINE_WAIT_BIT(wait, &ip->i_flags, __XFS_INEW_BIT);
-
-	do {
-		prepare_to_wait(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
-		if (!xfs_iflags_test(ip, XFS_INEW))
-			break;
-		schedule();
-	} while (true);
-	finish_wait(wq, &wait.wq_entry);
-}
-
 /*
  * When we recycle a reclaimable inode, we need to re-initialise the VFS inode
  * part of the structure. This is made more complex by the fact we store
@@ -368,18 +352,13 @@ xfs_iget_recycle(
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 	error = xfs_reinit_inode(mp, inode);
 	if (error) {
-		bool	wake;
-
 		/*
 		 * Re-initializing the inode failed, and we are in deep
 		 * trouble.  Try to re-add it to the reclaim list.
 		 */
 		rcu_read_lock();
 		spin_lock(&ip->i_flags_lock);
-		wake = !!__xfs_iflags_test(ip, XFS_INEW);
 		ip->i_flags &= ~(XFS_INEW | XFS_IRECLAIM);
-		if (wake)
-			wake_up_bit(&ip->i_flags, __XFS_INEW_BIT);
 		ASSERT(ip->i_flags & XFS_IRECLAIMABLE);
 		spin_unlock(&ip->i_flags_lock);
 		rcu_read_unlock();
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index e635a3d64cba2..c447bf04205a8 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -231,8 +231,7 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
 #define XFS_IRECLAIM		(1 << 0) /* started reclaiming this inode */
 #define XFS_ISTALE		(1 << 1) /* inode has been staled */
 #define XFS_IRECLAIMABLE	(1 << 2) /* inode can be reclaimed */
-#define __XFS_INEW_BIT		3	 /* inode has just been allocated */
-#define XFS_INEW		(1 << __XFS_INEW_BIT)
+#define XFS_INEW		(1 << 3) /* inode has just been allocated */
 #define XFS_IPRESERVE_DM_FIELDS	(1 << 4) /* has legacy DMAPI fields set */
 #define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
 #define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
@@ -492,7 +491,6 @@ static inline void xfs_finish_inode_setup(struct xfs_inode *ip)
 	xfs_iflags_clear(ip, XFS_INEW);
 	barrier();
 	unlock_new_inode(VFS_I(ip));
-	wake_up_bit(&ip->i_flags, __XFS_INEW_BIT);
 }
 
 static inline void xfs_setup_existing_inode(struct xfs_inode *ip)
-- 
2.30.2

