Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52206 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbfCNVGV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:06:21 -0400
Subject: [PATCH 24/36] xfs_repair: bump the irec on-disk nlink when adding
 lost+found
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:06:17 -0700
Message-ID: <155259757750.31886.15831311797503004248.stgit@magnolia>
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We increment the nlink of the root directory inode when creating a
"lost+found" directory during phase 6, but we don't update the irec copy
of the root dir nlink.  This normally gets papered over by phase 7, but
this can fail badly if:

1) The root directory had an entry to a busted subdirectory, so
   that root directory will have nlink == 3, but in the ino_tree,
   counted_nlinks == 2 and disk_nlinks == 3.

2) Phase 6 creates lost+found to root the files that were in the busted
   directory, we'll set nlink = 4 and counted_nlinks = 3.  The correct
   nlink is 3 ('.', '..', 'lost+found'), not 4.

3) During phase 7, we see that counted_nlinks == disk_nlinks and so we
   totally fail to correct the on-disk inode.

4) A subsequent run of xfs_repair complains about the nlink being 4
   instead of 3.

To fix this, we have to adjust the irec's disk_nlinks in step 2 so that
phase 7 seeds that counted_nlinks < disk_nlinks and resets nlink to
counted_nlinks.  This can be reproduced somewhat frequently by xfs/117.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase6.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 8a50b350..194cfdbf 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1019,6 +1019,7 @@ mk_orphanage(xfs_mount_t *mp)
 	 */
 	set_inode_used(irec, ino_offset);
 	add_inode_ref(irec, ino_offset);
+	add_inode_reached(irec, ino_offset);
 
 	/*
 	 * now that we know the transaction will stay around,
@@ -1037,14 +1038,14 @@ mk_orphanage(xfs_mount_t *mp)
 
 	/*
 	 * bump up the link count in the root directory to account
-	 * for .. in the new directory
+	 * for .. in the new directory, and update the irec copy of the
+	 * on-disk nlink so we don't fail the link count check later.
 	 */
 	inc_nlink(VFS_I(pip));
-	add_inode_ref(find_inode_rec(mp,
-				XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
-				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino)), 0);
-
-
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
+				  XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
+	add_inode_ref(irec, 0);
+	set_inode_disk_nlinks(irec, 0, get_inode_disk_nlinks(irec, 0) + 1);
 
 	libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
 	libxfs_dir_init(tp, ip, pip);
@@ -1056,7 +1057,6 @@ mk_orphanage(xfs_mount_t *mp)
 	}
 	libxfs_irele(ip);
 	libxfs_irele(pip);
-	add_inode_reached(irec,ino_offset);
 
 	return(ino);
 }
