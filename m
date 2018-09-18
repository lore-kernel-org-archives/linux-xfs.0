Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42164 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727660AbeISA3S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Sep 2018 20:29:18 -0400
Subject: [PATCH 4/4] libxfs: check libxfs_trans_commit return values
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Sep 2018 11:55:17 -0700
Message-ID: <153729691712.13178.5276885933561821406.stgit@magnolia>
In-Reply-To: <153729689066.13178.8524619838625486047.stgit@magnolia>
References: <153729689066.13178.8524619838625486047.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check the return value from libxfs_trans_commit since it can now return
error codes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/proto.c    |    9 +++++++--
 mkfs/xfs_mkfs.c |    4 +++-
 repair/phase6.c |   25 +++++++++++++++++++------
 repair/rmap.c   |    4 +++-
 4 files changed, 32 insertions(+), 10 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 141c27b8..d65170d7 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -212,7 +212,9 @@ rsvfile(
 	ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
 
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		fail(_("committing space for a file failed"), error);
 }
 
 static int
@@ -671,7 +673,10 @@ rtinit(
 	rsumip->i_d.di_size = mp->m_rsumsize;
 	libxfs_trans_log_inode(tp, rsumip, XFS_ILOG_CORE);
 	libxfs_log_sb(tp);
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		fail(_("Completion of the realtime summary inode failed"),
+				error);
 	mp->m_rsumip = rsumip;
 	/*
 	 * Next, give the bitmap file some zero-filled blocks.
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 9ef6e84a..b04a705f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3690,7 +3690,9 @@ initialise_ag_freespace(
 
 	libxfs_alloc_fix_freelist(&args, 0);
 	libxfs_perag_put(args.pag);
-	libxfs_trans_commit(tp);
+	c = -libxfs_trans_commit(tp);
+	if (c)
+		res_failed(c);
 }
 
 /*
diff --git a/repair/phase6.c b/repair/phase6.c
index 58b23aa3..ecf8975e 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -575,7 +575,9 @@ mk_rbmino(xfs_mount_t *mp)
 	 * commit changes
 	 */
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(_("%s: commit failed, error %d\n"), __func__, error);
 
 	/*
 	 * then allocate blocks for file and fill with zeroes (stolen
@@ -683,7 +685,9 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
 		bno++;
 	}
 
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(_("%s: commit failed, error %d\n"), __func__, error);
 	IRELE(ip);
 	return(0);
 }
@@ -755,7 +759,9 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 		bno++;
 	}
 
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(_("%s: commit failed, error %d\n"), __func__, error);
 	IRELE(ip);
 	return(0);
 }
@@ -822,7 +828,9 @@ mk_rsumino(xfs_mount_t *mp)
 	 * commit changes
 	 */
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(_("%s: commit failed, error %d\n"), __func__, error);
 
 	/*
 	 * then allocate blocks for file and fill with zeroes (stolen
@@ -931,7 +939,10 @@ mk_root_dir(xfs_mount_t *mp)
 	ip->d_ops = mp->m_dir_inode_ops;
 	libxfs_dir_init(tp, ip, ip);
 
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(_("%s: commit failed, error %d\n"), __func__, error);
+
 	IRELE(ip);
 
 	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
@@ -3005,7 +3016,9 @@ process_dir_inode(
 			if (dirty)  {
 				libxfs_trans_log_inode(tp, ip,
 					XFS_ILOG_CORE | XFS_ILOG_DDATA);
-				libxfs_trans_commit(tp);
+				error = -libxfs_trans_commit(tp);
+				if (error)
+					res_failed(error);
 			} else  {
 				libxfs_trans_cancel(tp);
 			}
diff --git a/repair/rmap.c b/repair/rmap.c
index 43eac288..c19513c2 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1411,7 +1411,9 @@ fix_freelist(
 		do_error(_("failed to fix AGFL on AG %d, error %d\n"),
 				agno, error);
 	}
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(_("%s: commit failed, error %d\n"), __func__, error);
 }
 
 /*
