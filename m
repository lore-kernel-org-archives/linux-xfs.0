Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40320 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764510AbdDSTlI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Apr 2017 15:41:08 -0400
Subject: [PATCH V2] xfs: remove use of do_div with 32-bit dividend in quota
 debug code
References: <e6022a70-8f09-633d-e99a-30186ea8c3d2@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e54544bf-9662-fa91-40b6-69a284aa66e2@sandeen.net>
Date: Wed, 19 Apr 2017 14:41:07 -0500
MIME-Version: 1.0
In-Reply-To: <e6022a70-8f09-633d-e99a-30186ea8c3d2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

The kbuild test robot caught this; in debug code we have another
caller of do_div with a 32-bit dividend (j) which is caught now
that we are using the kernel-supplied do_div.

None of the values used here are 64-bit; just use simple division.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: now with less actual 64-bit division!

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b669b12..6b42db4 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -851,8 +851,8 @@ struct xfs_qm_isolate {
 	 * started afresh by xfs_qm_quotacheck.
 	 */
 #ifdef DEBUG
-	j = XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
-	do_div(j, sizeof(xfs_dqblk_t));
+	j = (int)XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) /
+		sizeof(xfs_dqblk_t);
 	ASSERT(mp->m_quotainfo->qi_dqperchunk == j);
 #endif
 	dqb = bp->b_addr;


