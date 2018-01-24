Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53792 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965097AbeAXSoU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Jan 2018 13:44:20 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7E0F7300AA7
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 18:44:20 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61E445D6A8
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 18:44:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFCv2 6/9] xfs: defer frees from common inode allocation paths
Date: Wed, 24 Jan 2018 13:44:15 -0500
Message-Id: <20180124184418.40403-7-bfoster@redhat.com>
In-Reply-To: <20180124184418.40403-1-bfoster@redhat.com>
References: <20180124184418.40403-1-bfoster@redhat.com>
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
 fs/xfs/xfs_inode.c   | 1 +
 fs/xfs/xfs_symlink.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4c4a2fa3ad11..924dbd5a1b40 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1187,6 +1187,7 @@ xfs_create(
 	unlock_dp_on_error = true;
 
 	xfs_defer_init(&dfops, &first_block);
+	tp->t_dfops = &dfops;
 
 	/*
 	 * Reserve disk quota and the inode.
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 2e9e793a8f9d..8be021228266 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -259,6 +259,7 @@ xfs_symlink(
 	 * bmapi or the directory create code.
 	 */
 	xfs_defer_init(&dfops, &first_block);
+	tp->t_dfops = &dfops;
 
 	/*
 	 * Allocate an inode for the symlink.
-- 
2.13.6

