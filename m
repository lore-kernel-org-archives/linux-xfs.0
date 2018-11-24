Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:57191 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbeKXUe0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 24 Nov 2018 15:34:26 -0500
From: Pan Bian <bianpan2016@163.com>
Subject: [PATCH] xfs: libxfs: move xfs_perag_put late
Date: Sat, 24 Nov 2018 17:44:20 +0800
Message-Id: <1543052660-58625-1-git-send-email-bianpan2016@163.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>

The function xfs_alloc_get_freelist calls xfs_perag_put to drop the
reference. In this case, pag may be released. However,
pag->pagf_btreeblks is read and write after the put operation. This may
result in a use-after-free bug. This patch moves the put operation late.

Signed-off-by: Pan Bian <bianpan2016@163.com>
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
