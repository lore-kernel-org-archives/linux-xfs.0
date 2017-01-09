Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58452 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938513AbdAIPkB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:40:01 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 19/32] xfs: handle cow fork in xfs_bmap_trace_exlist
Date: Mon,  9 Jan 2017 16:38:50 +0100
Message-Id: <1483976343-661-20-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>

From: Eric Sandeen <sandeen@sandeen.net>

commit c44a1f22626c153976289e1cd67bdcdfefc16e1f upstream.

By inspection, xfs_bmap_trace_exlist isn't handling cow forks,
and will trace the data fork instead.

Fix this by setting state appropriately if whichfork
== XFS_COW_FORK.

()___()
< @ @ >
 |   |
 {o_o}
  (|)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index cfd1fdd..d4481d4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -518,7 +518,7 @@ void
 xfs_bmap_trace_exlist(
 	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_extnum_t	cnt,		/* count of entries in the list */
-	int		whichfork,	/* data or attr fork */
+	int		whichfork,	/* data or attr or cow fork */
 	unsigned long	caller_ip)
 {
 	xfs_extnum_t	idx;		/* extent record index */
@@ -527,6 +527,8 @@ xfs_bmap_trace_exlist(
 
 	if (whichfork == XFS_ATTR_FORK)
 		state |= BMAP_ATTRFORK;
+	else if (whichfork == XFS_COW_FORK)
+		state |= BMAP_COWFORK;
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(cnt == xfs_iext_count(ifp));
-- 
2.1.4

