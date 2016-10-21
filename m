Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54264 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932673AbcJURWP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Oct 2016 13:22:15 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 52648340759
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2016 17:22:15 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u9LHMEC8009860
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2016 13:22:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/3] xfs: fix up inode cowblocks tracking tracepoints
Date: Fri, 21 Oct 2016 13:22:11 -0400
Message-Id: <1477070533-59327-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1477070533-59327-1-git-send-email-bfoster@redhat.com>
References: <1477070533-59327-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

These calls are still using the eofblocks tracepoints. The cowblocks
equivalents are already defined, we just aren't actually calling them.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_icache.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 14796b7..f295049 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1656,9 +1656,9 @@ void
 xfs_inode_set_cowblocks_tag(
 	xfs_inode_t	*ip)
 {
-	trace_xfs_inode_set_eofblocks_tag(ip);
+	trace_xfs_inode_set_cowblocks_tag(ip);
 	return __xfs_inode_set_eofblocks_tag(ip, xfs_queue_cowblocks,
-			trace_xfs_perag_set_eofblocks,
+			trace_xfs_perag_set_cowblocks,
 			XFS_ICI_COWBLOCKS_TAG);
 }
 
@@ -1666,7 +1666,7 @@ void
 xfs_inode_clear_cowblocks_tag(
 	xfs_inode_t	*ip)
 {
-	trace_xfs_inode_clear_eofblocks_tag(ip);
+	trace_xfs_inode_clear_cowblocks_tag(ip);
 	return __xfs_inode_clear_eofblocks_tag(ip,
-			trace_xfs_perag_clear_eofblocks, XFS_ICI_COWBLOCKS_TAG);
+			trace_xfs_perag_clear_cowblocks, XFS_ICI_COWBLOCKS_TAG);
 }
-- 
2.7.4

