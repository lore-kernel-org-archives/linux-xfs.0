Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55802 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752128AbeDJRqd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Apr 2018 13:46:33 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ADBAF7E9EE
        for <linux-xfs@vger.kernel.org>; Tue, 10 Apr 2018 17:46:33 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 838D37BE6E
        for <linux-xfs@vger.kernel.org>; Tue, 10 Apr 2018 17:46:33 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 6/7] xfs: defer frees from common inode allocation paths
Date: Tue, 10 Apr 2018 13:46:30 -0400
Message-Id: <20180410174631.4915-7-bfoster@redhat.com>
In-Reply-To: <20180410174631.4915-1-bfoster@redhat.com>
References: <20180410174631.4915-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Inode allocation can require block allocation for physical inode
chunk allocation, inode btree record insertion, and/or directory
block allocation for entry insertion. Any of these block allocation
requests can require AGFL fixups prior to the actual allocation.
Update the common file creation transacions to defer AGFL frees from
these contexts to avoid too much log reservation consumption
per-transaction.

Since these transactions are already passed down through the btree
cursors and da_args structure, this simply requires to attach dfops
to the transaction. Note that this covers tr_create, tr_mkdir and
tr_symlink. Other transactions such as tr_create_tmpfile do not
already make use of deferred operations and so are left alone for
the time being.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c   | 2 +-
 fs/xfs/xfs_symlink.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 117dced8bf66..fdf5d276b44c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1195,7 +1195,7 @@ xfs_create(
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
 
-	xfs_defer_init(NULL, &dfops, &first_block);
+	xfs_defer_init(tp, &dfops, &first_block);
 
 	/*
 	 * Reserve disk quota and the inode.
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index e4c4ea25af61..0f3564741fa9 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -258,7 +258,7 @@ xfs_symlink(
 	 * Initialize the bmap freelist prior to calling either
 	 * bmapi or the directory create code.
 	 */
-	xfs_defer_init(NULL, &dfops, &first_block);
+	xfs_defer_init(tp, &dfops, &first_block);
 
 	/*
 	 * Allocate an inode for the symlink.
-- 
2.13.6

