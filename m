Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50047 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbeACSkg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 13:40:36 -0500
Subject: [PATCH 4/5] xfs_repair: fix libxfs namespace problems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 03 Jan 2018 10:40:32 -0800
Message-ID: <151500483196.7713.13575201997749465948.stgit@magnolia>
In-Reply-To: <151500479880.7713.6538509149156363572.stgit@magnolia>
References: <151500479880.7713.6538509149156363572.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Call libxfs_ functions, not xfs_ functions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    2 +-
 repair/dino_chunks.c     |    2 +-
 repair/phase6.c          |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 84a4fc2..0a5c84d 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -115,7 +115,7 @@
 #define xfs_rmap_irec_offset_unpack	libxfs_rmap_irec_offset_unpack
 #define xfs_rmapbt_init_cursor		libxfs_rmapbt_init_cursor
 #define xfs_btree_del_cursor		libxfs_btree_del_cursor
-
+#define xfs_mode_to_ftype		libxfs_mode_to_ftype
 
 #define xfs_log_sb			libxfs_log_sb
 #define xfs_sb_from_disk		libxfs_sb_from_disk
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index a3909ac..17de95f 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -845,7 +845,7 @@ process_inode_chunk(
 			 * phase 6.
 			 */
 			set_inode_ftype(ino_rec, irec_offset,
-				xfs_mode_to_ftype(be16_to_cpu(dino->di_mode)));
+				libxfs_mode_to_ftype(be16_to_cpu(dino->di_mode)));
 
 			/*
 			 * store on-disk nlink count for comparing in phase 7
diff --git a/repair/phase6.c b/repair/phase6.c
index b326929..1a398aa 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1081,7 +1081,7 @@ mv_orphanage(
 	if ((err = -libxfs_iget(mp, NULL, ino, 0, &ino_p)))
 		do_error(_("%d - couldn't iget disconnected inode\n"), err);
 
-	xname.type = xfs_mode_to_ftype(VFS_I(ino_p)->i_mode);
+	xname.type = libxfs_mode_to_ftype(VFS_I(ino_p)->i_mode);
 
 	if (isa_dir)  {
 		irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, orphanage_ino),

