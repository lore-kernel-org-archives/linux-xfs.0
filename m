Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34038 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388727AbfBMUvD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Feb 2019 15:51:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1DKcrrG133643
        for <linux-xfs@vger.kernel.org>; Wed, 13 Feb 2019 20:51:01 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2qhrekmcse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Feb 2019 20:51:01 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1DKp1uF002979
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Feb 2019 20:51:01 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1DKp0MV009616
        for <linux-xfs@vger.kernel.org>; Wed, 13 Feb 2019 20:51:00 GMT
Subject: [PATCH 3/3] xfs: reserve blocks for ifree transaction during log
 recovery
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 13 Feb 2019 12:50:59 -0800
Message-ID: <155009105963.32028.10768016263671369410.stgit@magnolia>
In-Reply-To: <155009104740.32028.193157199378698979.stgit@magnolia>
References: <155009104740.32028.193157199378698979.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

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

While we're at it we change the flag name to be clearer about what it
actually does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ag_resv.c      |    2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c |    4 ++--
 fs/xfs/xfs_fsops.c               |    1 +
 fs/xfs/xfs_inode.c               |    2 +-
 fs/xfs/xfs_mount.h               |    2 +-
 fs/xfs/xfs_super.c               |    7 +++++++
 6 files changed, 13 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index e701ebc36c06..e2ba2a3b63b2 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -281,7 +281,7 @@ xfs_ag_resv_init(
 			 */
 			ask = used = 0;
 
-			mp->m_inotbt_nores = true;
+			mp->m_finobt_nores = true;
 
 			error = xfs_refcountbt_calc_reserves(mp, tp, agno, &ask,
 					&used);
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index c2df1f89eec8..1080381ff243 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -124,7 +124,7 @@ xfs_finobt_alloc_block(
 	union xfs_btree_ptr	*new,
 	int			*stat)
 {
-	if (cur->bc_mp->m_inotbt_nores)
+	if (cur->bc_mp->m_finobt_nores)
 		return xfs_inobt_alloc_block(cur, start, new, stat);
 	return __xfs_inobt_alloc_block(cur, start, new, stat,
 			XFS_AG_RESV_METADATA);
@@ -154,7 +154,7 @@ xfs_finobt_free_block(
 	struct xfs_btree_cur	*cur,
 	struct xfs_buf		*bp)
 {
-	if (cur->bc_mp->m_inotbt_nores)
+	if (cur->bc_mp->m_finobt_nores)
 		return xfs_inobt_free_block(cur, bp);
 	return __xfs_inobt_free_block(cur, bp, XFS_AG_RESV_METADATA);
 }
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
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9d683b455e01..f643a9295179 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1754,7 +1754,7 @@ xfs_inactive_ifree(
 	 * now remains allocated and sits on the unlinked list until the fs is
 	 * repaired.
 	 */
-	if (unlikely(mp->m_inotbt_nores)) {
+	if (unlikely(mp->m_finobt_nores)) {
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ifree,
 				XFS_IFREE_SPACE_RES(mp), 0, XFS_TRANS_RESERVE,
 				&tp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a33f45077867..864ecf27aa75 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -138,7 +138,7 @@ typedef struct xfs_mount {
 	struct mutex		m_growlock;	/* growfs mutex */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
 	uint64_t		m_flags;	/* global mount flags */
-	bool			m_inotbt_nores; /* no per-AG finobt resv. */
+	bool			m_finobt_nores; /* no per-AG finobt resv. */
 	int			m_ialloc_inos;	/* inodes in inode allocation */
 	int			m_ialloc_blks;	/* blocks in inode allocation */
 	int			m_ialloc_min_blks;/* min blocks in sparse inode
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
 
