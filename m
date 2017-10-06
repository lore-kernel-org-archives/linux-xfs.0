Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31732 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752358AbdJFWIs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2017 18:08:48 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 15/17] xfs_bmap_add_attrfork(): re-add error handling from set_attrforkoff() call
Date: Fri,  6 Oct 2017 15:05:46 -0700
Message-Id: <1507327548-3221-16-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1507327548-3221-1-git-send-email-allison.henderson@oracle.com>
References: <1507327548-3221-1-git-send-email-allison.henderson@oracle.com>
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
:100644 100644 8866242... 63a979c... M	fs/xfs/libxfs/xfs_bmap.c
 fs/xfs/libxfs/xfs_bmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8866242..63a979c 100644
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

