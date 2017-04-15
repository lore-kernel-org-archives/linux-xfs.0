Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47840 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752990AbdDOOqL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 15 Apr 2017 10:46:11 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8FA16A2021
        for <linux-xfs@vger.kernel.org>; Sat, 15 Apr 2017 14:46:10 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6697C60461
        for <linux-xfs@vger.kernel.org>; Sat, 15 Apr 2017 14:46:10 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: remove use of do_div with 32-bit dividend in quota debug
 code
Message-ID: <e6022a70-8f09-633d-e99a-30186ea8c3d2@redhat.com>
Date: Sat, 15 Apr 2017 09:46:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

The kbuild test robot caught this; in debug code we have another
caller of do_div with a 32-bit dividend (j) which is caught now
that we are using the kernel-supplied do_div.

None of the values used here are 64-bit; just use simple division.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b669b12..dedeb7f 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -851,8 +851,7 @@ struct xfs_qm_isolate {
 	 * started afresh by xfs_qm_quotacheck.
 	 */
 #ifdef DEBUG
-	j = XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
-	do_div(j, sizeof(xfs_dqblk_t));
+	j = XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) / sizeof(xfs_dqblk_t);
 	ASSERT(mp->m_quotainfo->qi_dqperchunk == j);
 #endif
 	dqb = bp->b_addr;

