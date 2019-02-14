Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55804 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbfBNTFQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 14:05:16 -0500
Subject: [PATCH 2/2] xfs: reserve blocks for ifree transaction during log
 recovery
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Feb 2019 11:05:04 -0800
Message-ID: <155017110489.6016.15023654256490874855.stgit@magnolia>
In-Reply-To: <155017109378.6016.17031057745821704893.stgit@magnolia>
References: <155017109378.6016.17031057745821704893.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

From: Darrick J. Wong <darrick.wong@oracle.com>

Log recovery frees all the inodes stored in the unlinked list, which can
cause expansion of the free inode btree.  The ifree code skips block
reservations if it thinks there's a per-AG space reservation, but we
don't set up the reservation until after log recovery, which means that
a finobt expansion blows up in xfs_trans_mod_sb when we exceed the
transaction's block reservation.

To fix this, we set the "no finobt reservation" flag to true when we
create the xfs_mount and only set it to false if we confirm that every
AG had enough free space to put aside for the finobt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_fsops.c |    1 +
 fs/xfs/xfs_super.c |    7 +++++++
 2 files changed, 8 insertions(+)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index f3ef70c542e1..584648582ba7 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -533,6 +533,7 @@ xfs_fs_reserve_ag_blocks(
 	int			error = 0;
 	int			err2;
 
+	mp->m_finobt_nores = false;
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
 		pag = xfs_perag_get(mp, agno);
 		err2 = xfs_ag_resv_init(pag, NULL);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c9097cb0b955..08033ac040d6 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1594,6 +1594,13 @@ xfs_mount_alloc(
 	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
 	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
+	/*
+	 * We don't create the finobt per-ag space reservation until after log
+	 * recovery, so we must set this to true so that an ifree transaction
+	 * started during log recovery will not depend on space reservations
+	 * for finobt expansion.
+	 */
+	mp->m_finobt_nores = true;
 	return mp;
 }
 
