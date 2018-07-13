Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727071AbeGMJcc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Jul 2018 05:32:32 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E66BA402382F
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jul 2018 09:18:45 +0000 (UTC)
Received: from odin.usersys.redhat.com (ovpn-204-224.brq.redhat.com [10.40.204.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C28721565E1
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jul 2018 09:18:45 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] libxfs: Fix a couple of sparse complaints
Date: Fri, 13 Jul 2018 11:18:31 +0200
Message-Id: <20180713091831.30250-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

No significant changes, just silence a couple of sparse errors.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/libxfs/xfs_ag_resv.h | 2 +-
 fs/xfs/libxfs/xfs_ialloc.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
index 4619b554ee90..dc953fc84b2f 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.h
+++ b/fs/xfs/libxfs/xfs_ag_resv.h
@@ -28,7 +28,7 @@ xfs_ag_resv_rmapbt_alloc(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
-	struct xfs_alloc_arg	args = {0};
+	struct xfs_alloc_arg	args = { NULL };
 	struct xfs_perag	*pag;
 
 	args.len = 1;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 0d968e8143aa..0680fea1d47d 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2539,7 +2539,7 @@ xfs_agi_verify(
 		return __this_address;
 
 	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
-		if (agi->agi_unlinked[i] == NULLAGINO)
+		if (be32_to_cpu(agi->agi_unlinked[i]) == NULLAGINO)
 			continue;
 		if (!xfs_verify_ino(mp, be32_to_cpu(agi->agi_unlinked[i])))
 			return __this_address;
-- 
2.14.3

