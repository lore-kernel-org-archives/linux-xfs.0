Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:41774 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbeLZGFq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Dec 2018 01:05:46 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 277E091D
        for <linux-xfs@vger.kernel.org>; Wed, 26 Dec 2018 06:05:45 +0000 (UTC)
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HWyxzOCJH4fN for <linux-xfs@vger.kernel.org>;
        Wed, 26 Dec 2018 00:05:45 -0600 (CST)
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id EB2F6812
        for <linux-xfs@vger.kernel.org>; Wed, 26 Dec 2018 00:05:44 -0600 (CST)
Received: by mail-io1-f72.google.com with SMTP id d63so18545649iog.4
        for <linux-xfs@vger.kernel.org>; Tue, 25 Dec 2018 22:05:44 -0800 (PST)
From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH] xfs: add a check for xfs_trans_commit
Date: Wed, 26 Dec 2018 00:05:16 -0600
Message-Id: <20181226060516.75103-1-kjlu@umn.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: kjlu@umn.edu
Cc: pakki001@umn.edu, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

xfs_trans_commit could fails. The checks issues an error message upon
its failure.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 fs/xfs/xfs_super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d3e6cd063688..8ec2e3c8e946 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1010,6 +1010,7 @@ xfs_fs_dirty_inode(
 	struct xfs_inode		*ip = XFS_I(inode);
 	struct xfs_mount		*mp = ip->i_mount;
 	struct xfs_trans		*tp;
+	int error;
 
 	if (!(inode->i_sb->s_flags & SB_LAZYTIME))
 		return;
@@ -1021,7 +1022,10 @@ xfs_fs_dirty_inode(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_TIMESTAMP);
-	xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	if (error)
+		xfs_err(mp,
+				"Error in xfs_trans_commit: %d\n", error);
 }
 
 /*
-- 
2.17.2 (Apple Git-113)
