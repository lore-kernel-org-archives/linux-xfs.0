Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28260 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751224AbdJRXAQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2017 19:00:16 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 15/17] xfs_bmap_add_attrfork(): re-add error handling from set_attrforkoff() call
Date: Wed, 18 Oct 2017 15:55:31 -0700
Message-Id: <1508367333-3237-16-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>, Allison Henderson <allison.henderson@oracle.com>

From: Brian Foster <bfoster@redhat.com>

- fix for "xfs: parent pointer attribute creation"

[achender: rebased]

Signed-off-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7ee98be..a631fe1 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1149,7 +1149,9 @@ xfs_bmap_add_attrfork(
 	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	xfs_bmap_set_attrforkoff(ip, size, &version);
+	error = xfs_bmap_set_attrforkoff(ip, size, &version);
+	if (error)
+		goto trans_cancel;
 
 	ASSERT(ip->i_afp == NULL);
 	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
-- 
2.7.4

