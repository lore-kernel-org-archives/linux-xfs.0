Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A743C433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 08:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30B382068F
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 08:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgFVIQU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 04:16:20 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:46182 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725938AbgFVIQR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 04:16:17 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C187A3A3721
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 18:16:12 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jnHcd-00046W-0f
        for linux-xfs@vger.kernel.org; Mon, 22 Jun 2020 18:16:07 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jnHcc-007d6h-Od
        for linux-xfs@vger.kernel.org; Mon, 22 Jun 2020 18:16:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 30/30] xfs: remove xfs_inobp_check()
Date:   Mon, 22 Jun 2020 18:16:05 +1000
Message-Id: <20200622081605.1818434-31-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200622081605.1818434-1-david@fromorbit.com>
References: <20200622081605.1818434-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=DPGN0NLpbuj1Jjrhi_sA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This debug code is called on every xfs_iflush() call, which then
checks every inode in the buffer for non-zero unlinked list field.
Hence it checks every inode in the cluster buffer every time a
single inode on that cluster it flushed. This is resulting in:

-   38.91%     5.33%  [kernel]  [k] xfs_iflush
   - 17.70% xfs_iflush
      - 9.93% xfs_inobp_check
           4.36% xfs_buf_offset

10% of the CPU time spent flushing inodes is repeatedly checking
unlinked fields in the buffer. We don't need to do this.

The other place we call xfs_inobp_check() is
xfs_iunlink_update_dinode(), and this is after we've done this
assert for the agino we are about to write into that inode:

	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));

which means we've already checked that the agino we are about to
write is not 0 on debug kernels. The inode buffer verifiers do
everything else we need, so let's just remove this debug code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 24 ------------------------
 fs/xfs/libxfs/xfs_inode_buf.h |  6 ------
 fs/xfs/xfs_inode.c            |  2 --
 3 files changed, 32 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 1af97235785c..6b6f67595bf4 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -20,30 +20,6 @@
 
 #include <linux/iversion.h>
 
-/*
- * Check that none of the inode's in the buffer have a next
- * unlinked field of 0.
- */
-#if defined(DEBUG)
-void
-xfs_inobp_check(
-	xfs_mount_t	*mp,
-	xfs_buf_t	*bp)
-{
-	int		i;
-	xfs_dinode_t	*dip;
-
-	for (i = 0; i < M_IGEO(mp)->inodes_per_cluster; i++) {
-		dip = xfs_buf_offset(bp, i * mp->m_sb.sb_inodesize);
-		if (!dip->di_next_unlinked)  {
-			xfs_alert(mp,
-	"Detected bogus zero next_unlinked field in inode %d buffer 0x%llx.",
-				i, (long long)bp->b_bn);
-		}
-	}
-}
-#endif
-
 /*
  * If we are doing readahead on an inode buffer, we might be in log recovery
  * reading an inode allocation buffer that hasn't yet been replayed, and hence
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 865ac493c72a..6b08b9d060c2 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -52,12 +52,6 @@ int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
 			       struct xfs_dinode *to);
 
-#if defined(DEBUG)
-void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
-#else
-#define	xfs_inobp_check(mp, bp)
-#endif /* DEBUG */
-
 xfs_failaddr_t xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
 			   struct xfs_dinode *dip);
 xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 05017475c766..bae84b3eeb9a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2165,7 +2165,6 @@ xfs_iunlink_update_dinode(
 	xfs_dinode_calc_crc(mp, dip);
 	xfs_trans_inode_buf(tp, ibp);
 	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
-	xfs_inobp_check(mp, ibp);
 }
 
 /* Set an in-core inode's unlinked pointer and return the old value. */
@@ -3558,7 +3557,6 @@ xfs_iflush(
 	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
 	if (XFS_IFORK_Q(ip))
 		xfs_iflush_fork(ip, dip, iip, XFS_ATTR_FORK);
-	xfs_inobp_check(mp, bp);
 
 	/*
 	 * We've recorded everything logged in the inode, so we'd like to clear
-- 
2.26.2.761.g0e0b3e54be

