Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35400 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbeBUDhh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Feb 2018 22:37:37 -0500
Date: Tue, 20 Feb 2018 19:37:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_db: don't crash in ablock if there's no inode
Message-ID: <20180221033732.GJ27629@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we actually have an inode selected before trying to unwrap its
attribute fork.  Found via a crash in xfs/288 with project quotas
enabled.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/block.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/db/block.c b/db/block.c
index 5ecd687..174e29a 100644
--- a/db/block.c
+++ b/db/block.c
@@ -84,6 +84,11 @@ ablock_f(
 	}
 	push_cur();
 	set_cur_inode(iocur_top->ino);
+	if (!iocur_top->data) {
+		pop_cur();
+		dbprintf(_("no current inode\n"));
+		return 0;
+	}
 	haveattr = XFS_DFORK_Q((xfs_dinode_t *)iocur_top->data);
 	pop_cur();
 	if (!haveattr) {
