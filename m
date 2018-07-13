Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728140AbeGMNYj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Jul 2018 09:24:39 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CD014818F71A
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jul 2018 13:10:03 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-121-59.rdu2.redhat.com [10.10.121.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC6FD2026D6B
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jul 2018 13:10:03 +0000 (UTC)
From: Bill O'Donnell <billodo@redhat.com>
Subject: [PATCH] libxfs: add more bounds checking to sb sanity checks
Date: Fri, 13 Jul 2018 08:10:03 -0500
Message-Id: <20180713131003.31121-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Current sb verifier doesn't check bounds on sb_fdblocks and sb_ifree.
Add sanity checks for these parameters.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 350119eeaecb..cdede769ab88 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -261,7 +261,9 @@ xfs_mount_validate_sb(
 	    sbp->sb_dblocks == 0					||
 	    sbp->sb_dblocks > XFS_MAX_DBLOCKS(sbp)			||
 	    sbp->sb_dblocks < XFS_MIN_DBLOCKS(sbp)			||
-	    sbp->sb_shared_vn != 0)) {
+	    sbp->sb_shared_vn != 0					||
+	    sbp->sb_fdblocks > sbp->sb_dblocks				||
+	    sbp->sb_ifree > sbp->sb_icount)) {
 		xfs_notice(mp, "SB sanity check failed");
 		return -EFSCORRUPTED;
 	}
-- 
2.17.1

