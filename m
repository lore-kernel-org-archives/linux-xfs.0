Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51012 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753819AbeDRNbV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Apr 2018 09:31:21 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 67FC931327E5
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 13:31:21 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4792C7059E
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 13:31:21 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 6/6] xfs: defer agfl frees from directory op transactions
Date: Wed, 18 Apr 2018 09:31:19 -0400
Message-Id: <20180418133119.21775-7-bfoster@redhat.com>
In-Reply-To: <20180418133119.21775-1-bfoster@redhat.com>
References: <20180418133119.21775-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Directory operations can perform block allocations as entries are
added/removed from directories. Defer AGFL block frees from the
remaining directory operation transactions. This covers the hard
link, remove and rename operations.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 484ebef36fe4..47aa124e4744 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1452,6 +1452,7 @@ xfs_link(
 	}
 
 	xfs_defer_init(&dfops, &first_block);
+	tp->t_agfl_dfops = &dfops;
 
 	/*
 	 * Handle initial link state of O_TMPFILE inode
@@ -2649,6 +2650,7 @@ xfs_remove(
 		goto out_trans_cancel;
 
 	xfs_defer_init(&dfops, &first_block);
+	tp->t_agfl_dfops = &dfops;
 	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
 					&first_block, &dfops, resblks);
 	if (error) {
@@ -3016,6 +3018,7 @@ xfs_rename(
 	}
 
 	xfs_defer_init(&dfops, &first_block);
+	tp->t_agfl_dfops = &dfops;
 
 	/* RENAME_EXCHANGE is unique from here on. */
 	if (flags & RENAME_EXCHANGE)
-- 
2.13.6

