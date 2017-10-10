Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932431AbdJJQr6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Oct 2017 12:47:58 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 80A081299
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2017 16:47:58 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F4BA17C2D
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2017 16:47:58 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/2] xfs: assert that xattr inactivation never reaches a hole
Date: Tue, 10 Oct 2017 12:47:55 -0400
Message-Id: <20171010164756.28390-2-bfoster@redhat.com>
In-Reply-To: <20171010164756.28390-1-bfoster@redhat.com>
References: <20171010164756.28390-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The child buffer read in xfs_attr3_node_inactive() should never
reach a hole in the attr fork. If this occurs, it is likely due to a
bug. Prior to commit cd87d867 ("xfs: don't crash on unexpected holes
in dir/attr btrees"), this would result in a crash. Now that the
crash has been fixed, this is a silent failure.

Add an assert in this codepath to detect this particular condition.
Note that the right fix here may be to pass -1 to
xfs_da3_node_read() such that a hole returns an error. This is a
cautious first step in that direction.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_attr_inactive.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index ebd66b1..6b4f5c6 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -255,6 +255,7 @@ xfs_attr3_node_inactive(
 						XFS_ATTR_FORK);
 		if (error)
 			return error;
+		ASSERT(child_bp);
 		if (child_bp) {
 						/* save for re-read later */
 			child_blkno = XFS_BUF_ADDR(child_bp);
-- 
2.9.5

