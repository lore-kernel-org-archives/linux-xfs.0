Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44908 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbeI1H0M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Sep 2018 03:26:12 -0400
Subject: [PATCH 4/6] libxfs: check libxfs_trans_commit return values
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 27 Sep 2018 18:05:01 -0700
Message-ID: <153809670104.32548.8235841795111248441.stgit@magnolia>
In-Reply-To: <153809666117.32548.6836488790026631787.stgit@magnolia>
References: <153809666117.32548.6836488790026631787.stgit@magnolia>
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
 mkfs/proto.c    |   38 ++++++++++++++++++-----
 mkfs/xfs_mkfs.c |    4 ++
 repair/phase6.c |   90 ++++++++++++++++++++++++++++++++++++++++++++-----------
 repair/rmap.c   |    4 ++
 4 files changed, 108 insertions(+), 28 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 9da0587e..5999fd2e 100644
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
@@ -474,7 +476,9 @@ parseproto(
 		xname.type = XFS_DIR3_FT_REG_FILE;
 		newdirent(mp, tp, pip, &xname, ip->i_ino);
 		libxfs_trans_log_inode(tp, ip, flags);
-		libxfs_trans_commit(tp);
+		error = -libxfs_trans_commit(tp);
+		if (error)
+			fail(_("Space preallocation failed."), error);
 		rsvfile(mp, ip, llen);
 		IRELE(ip);
 		return;
@@ -552,7 +556,9 @@ parseproto(
 		}
 		newdirectory(mp, tp, ip, pip);
 		libxfs_trans_log_inode(tp, ip, flags);
-		libxfs_trans_commit(tp);
+		error = -libxfs_trans_commit(tp);
+		if (error)
+			fail(_("Directory inode allocation failed."), error);
 		/*
 		 * RT initialization.  Do this here to ensure that
 		 * the RT inodes get placed after the root inode.
@@ -575,7 +581,11 @@ parseproto(
 		fail(_("Unknown format"), EINVAL);
 	}
 	libxfs_trans_log_inode(tp, ip, flags);
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error) {
+		fail(_("Error encountered creating file from prototype file"),
+			error);
+	}
 	IRELE(ip);
 }
 
@@ -645,7 +655,10 @@ rtinit(
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
@@ -675,7 +688,10 @@ rtinit(
 		}
 	}
 
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		fail(_("Block allocation of the realtime bitmap inode failed"),
+				error);
 
 	/*
 	 * Give the summary file some zero-filled blocks.
@@ -704,7 +720,10 @@ rtinit(
 			bno += ep->br_blockcount;
 		}
 	}
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		fail(_("Block allocation of the realtime summary inode failed"),
+				error);
 
 	/*
 	 * Free the whole area using transactions.
@@ -723,7 +742,10 @@ rtinit(
 			fail(_("Error initializing the realtime space"),
 				error);
 		}
-		libxfs_trans_commit(tp);
+		error = -libxfs_trans_commit(tp);
+		if (error)
+			fail(_("Initialization of the realtime space failed"),
+					error);
 	}
 }
 
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
index ab125d6c..0a52cf96 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -573,7 +573,9 @@ mk_rbmino(xfs_mount_t *mp)
 	 * commit changes
 	 */
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(_("%s: commit failed, error %d\n"), __func__, error);
 
 	/*
 	 * then allocate blocks for file and fill with zeroes (stolen
@@ -604,7 +606,12 @@ mk_rbmino(xfs_mount_t *mp)
 			bno += ep->br_blockcount;
 		}
 	}
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error) {
+		do_error(
+		_("allocation of the realtime bitmap failed, error = %d\n"),
+			error);
+	}
 	IRELE(ip);
 }
 
@@ -669,7 +676,9 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
 		bno++;
 	}
 
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(_("%s: commit failed, error %d\n"), __func__, error);
 	IRELE(ip);
 	return(0);
 }
@@ -738,7 +747,9 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 		bno++;
 	}
 
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(_("%s: commit failed, error %d\n"), __func__, error);
 	IRELE(ip);
 	return(0);
 }
@@ -803,7 +814,9 @@ mk_rsumino(xfs_mount_t *mp)
 	 * commit changes
 	 */
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(_("%s: commit failed, error %d\n"), __func__, error);
 
 	/*
 	 * then allocate blocks for file and fill with zeroes (stolen
@@ -835,7 +848,12 @@ mk_rsumino(xfs_mount_t *mp)
 			bno += ep->br_blockcount;
 		}
 	}
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error) {
+		do_error(
+	_("allocation of the realtime summary ino failed, error = %d\n"),
+			error);
+	}
 	IRELE(ip);
 }
 
@@ -900,7 +918,10 @@ mk_root_dir(xfs_mount_t *mp)
 	ip->d_ops = mp->m_dir_inode_ops;
 	libxfs_dir_init(tp, ip, ip);
 
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(_("%s: commit failed, error %d\n"), __func__, error);
+
 	IRELE(ip);
 
 	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
@@ -1030,7 +1051,11 @@ mk_orphanage(xfs_mount_t *mp)
 	libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
 	libxfs_dir_init(tp, ip, pip);
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error) {
+		do_error(_("%s directory creation failed -- bmapf error %d\n"),
+			ORPHANAGE, error);
+	}
 	IRELE(ip);
 	IRELE(pip);
 	add_inode_reached(irec,ino_offset);
@@ -1128,7 +1153,10 @@ mv_orphanage(
 
 			inc_nlink(VFS_I(ino_p));
 			libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
-			libxfs_trans_commit(tp);
+			err = -libxfs_trans_commit(tp);
+			if (err)
+				do_error(
+	_("creation of .. entry failed (%d)\n"), err);
 		} else  {
 			err = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_rename,
 						  nres, 0, 0, &tp);
@@ -1168,7 +1196,10 @@ mv_orphanage(
 						err);
 			}
 
-			libxfs_trans_commit(tp);
+			err = -libxfs_trans_commit(tp);
+			if (err)
+				do_error(
+	_("orphanage name replace op failed (%d)\n"), err);
 		}
 
 	} else  {
@@ -1199,7 +1230,10 @@ mv_orphanage(
 
 		set_nlink(VFS_I(ino_p), 1);
 		libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
-		libxfs_trans_commit(tp);
+		err = -libxfs_trans_commit(tp);
+		if (err)
+			do_error(
+	_("orphanage name create failed (%d)\n"), err);
 	}
 	IRELE(ino_p);
 	IRELE(orphanage_ip);
@@ -1335,7 +1369,10 @@ longform_dir2_rebuild(
 		goto out_bmap_cancel;
 	}
 
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(
+	_("dir init failed (%d)\n"), error);
 
 	if (ino == mp->m_sb.sb_rootino)
 		need_root_dotdot = 0;
@@ -1366,7 +1403,10 @@ _("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"
 			goto out_bmap_cancel;
 		}
 
-		libxfs_trans_commit(tp);
+		error = -libxfs_trans_commit(tp);
+		if (error)
+			do_error(
+_("name create failed (%d) during rebuild\n"), error);
 	}
 
 	return;
@@ -1412,7 +1452,10 @@ dir2_kill_block(
 	if (error)
 		do_error(_("shrink_inode failed inode %" PRIu64 " block %u\n"),
 			ip->i_ino, da_bno);
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(
+_("directory shrink failed (%d)\n"), error);
 }
 
 /*
@@ -1885,7 +1928,10 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
 				d, &i);
 	if (needlog)
 		libxfs_dir2_data_log_header(&da, bp);
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(
+_("directory block fixing failed (%d)\n"), error);
 
 	/* record the largest free space in the freetab for later checking */
 	bf = M_DIROPS(mp)->data_bestfree_p(d);
@@ -2901,7 +2947,9 @@ process_dir_inode(
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
@@ -2942,7 +2990,10 @@ process_dir_inode(
 	_("can't make \"..\" entry in root inode %" PRIu64 ", createname error %d\n"), ino, error);
 
 		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		libxfs_trans_commit(tp);
+		error = -libxfs_trans_commit(tp);
+		if (error)
+			do_error(
+	_("root inode \"..\" entry recreation failed (%d)\n"), error);
 
 		need_root_dotdot = 0;
 	} else if (need_root_dotdot && ino == mp->m_sb.sb_rootino)  {
@@ -2995,7 +3046,10 @@ process_dir_inode(
 					ino, error);
 
 			libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-			libxfs_trans_commit(tp);
+			error = -libxfs_trans_commit(tp);
+			if (error)
+				do_error(
+	_("root inode \".\" entry recreation failed (%d)\n"), error);
 		}
 	}
 	IRELE(ip);
diff --git a/repair/rmap.c b/repair/rmap.c
index dbe5b2c8..bd24b527 100644
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
