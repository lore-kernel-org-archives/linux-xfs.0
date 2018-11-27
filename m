Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:56401 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727456AbeK0LbV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Nov 2018 06:31:21 -0500
From: Pan Bian <bianpan2016@163.com>
Subject: [PATCH V2] xfs: libxfs: move xfs_perag_put late
Date: Tue, 27 Nov 2018 08:33:38 +0800
Message-Id: <1543278818-117362-1-git-send-email-bianpan2016@163.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>

The function xfs_alloc_get_freelist calls xfs_perag_put to drop the
reference. However, pag->pagf_btreeblks is read and write after the 
put operation. This patch moves the put operation late.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
V2: correct the commit log
---
 fs/xfs/libxfs/xfs_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index e1c0c0d..4be387d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2435,7 +2435,6 @@ xfs_alloc_get_freelist(
 	be32_add_cpu(&agf->agf_flcount, -1);
 	xfs_trans_agflist_delta(tp, -1);
 	pag->pagf_flcount--;
-	xfs_perag_put(pag);
 
 	logflags = XFS_AGF_FLFIRST | XFS_AGF_FLCOUNT;
 	if (btreeblk) {
@@ -2443,6 +2442,7 @@ xfs_alloc_get_freelist(
 		pag->pagf_btreeblks++;
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
+	xfs_perag_put(pag);
 
 	xfs_alloc_log_agf(tp, agbp, logflags);
 	*bnop = bno;
-- 
2.7.4
