Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42888 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbeJAXnm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 19:43:42 -0400
Subject: [PATCH 5/8] libxfs: check libxfs_trans_commit return values
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Oct 2018 10:04:49 -0700
Message-ID: <153841348914.27952.2885387753557549495.stgit@magnolia>
In-Reply-To: <153841345236.27952.5050172703525712660.stgit@magnolia>
References: <153841345236.27952.5050172703525712660.stgit@magnolia>
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
index 50a1bc54..dc82f093 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -211,7 +211,9 @@ rsvfile(
 	ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
 
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		fail(_("committing space for a file failed"), error);
 }
 
 static int
@@ -473,7 +475,9 @@ parseproto(
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
@@ -551,7 +555,9 @@ parseproto(
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
@@ -574,7 +580,11 @@ parseproto(
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
 
@@ -644,7 +654,10 @@ rtinit(
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
@@ -674,7 +687,10 @@ rtinit(
 		}
 	}
 
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		fail(_("Block allocation of the realtime bitmap inode failed"),
+				error);
 
 	/*
 	 * Give the summary file some zero-filled blocks.
@@ -702,7 +718,10 @@ rtinit(
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
@@ -721,7 +740,10 @@ rtinit(
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
index 982d3871..7c05c6f6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3689,7 +3689,9 @@ initialise_ag_freespace(
 
 	libxfs_alloc_fix_freelist(&args, 0);
 	libxfs_perag_put(args.pag);
-	libxfs_trans_commit(tp);
+	c = -libxfs_trans_commit(tp);
+	if (c)
+		res_failed(c);
 }
 
 /*
diff --git a/repair/phase6.c b/repair/phase6.c
index d6cb0a5a..8c0165ca 100644
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
 
@@ -668,7 +675,9 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
 		bno++;
 	}
 
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(_("%s: commit failed, error %d\n"), __func__, error);
 	IRELE(ip);
 	return(0);
 }
@@ -736,7 +745,9 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 		bno++;
 	}
 
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(_("%s: commit failed, error %d\n"), __func__, error);
 	IRELE(ip);
 	return(0);
 }
@@ -802,7 +813,9 @@ mk_rsumino(xfs_mount_t *mp)
 	 * commit changes
 	 */
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(_("%s: commit failed, error %d\n"), __func__, error);
 
 	/*
 	 * then allocate blocks for file and fill with zeroes (stolen
@@ -833,7 +846,12 @@ mk_rsumino(xfs_mount_t *mp)
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
 
@@ -898,7 +916,10 @@ mk_root_dir(xfs_mount_t *mp)
 	ip->d_ops = mp->m_dir_inode_ops;
 	libxfs_dir_init(tp, ip, ip);
 
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(_("%s: commit failed, error %d\n"), __func__, error);
+
 	IRELE(ip);
 
 	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
@@ -1028,7 +1049,11 @@ mk_orphanage(xfs_mount_t *mp)
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
@@ -1126,7 +1151,10 @@ mv_orphanage(
 
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
@@ -1166,7 +1194,10 @@ mv_orphanage(
 						err);
 			}
 
-			libxfs_trans_commit(tp);
+			err = -libxfs_trans_commit(tp);
+			if (err)
+				do_error(
+	_("orphanage name replace op failed (%d)\n"), err);
 		}
 
 	} else  {
@@ -1197,7 +1228,10 @@ mv_orphanage(
 
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
@@ -1333,7 +1367,10 @@ longform_dir2_rebuild(
 		goto out_bmap_cancel;
 	}
 
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(
+	_("dir init failed (%d)\n"), error);
 
 	if (ino == mp->m_sb.sb_rootino)
 		need_root_dotdot = 0;
@@ -1364,7 +1401,10 @@ _("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"
 			goto out_bmap_cancel;
 		}
 
-		libxfs_trans_commit(tp);
+		error = -libxfs_trans_commit(tp);
+		if (error)
+			do_error(
+_("name create failed (%d) during rebuild\n"), error);
 	}
 
 	return;
@@ -1410,7 +1450,10 @@ dir2_kill_block(
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
@@ -1883,7 +1926,10 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
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
@@ -2899,7 +2945,9 @@ process_dir_inode(
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
@@ -2940,7 +2988,10 @@ process_dir_inode(
 	_("can't make \"..\" entry in root inode %" PRIu64 ", createname error %d\n"), ino, error);
 
 		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		libxfs_trans_commit(tp);
+		error = -libxfs_trans_commit(tp);
+		if (error)
+			do_error(
+	_("root inode \"..\" entry recreation failed (%d)\n"), error);
 
 		need_root_dotdot = 0;
 	} else if (need_root_dotdot && ino == mp->m_sb.sb_rootino)  {
@@ -2993,7 +3044,10 @@ process_dir_inode(
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
index d596d0ff..6de4a105 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1410,7 +1410,9 @@ fix_freelist(
 		do_error(_("failed to fix AGFL on AG %d, error %d\n"),
 				agno, error);
 	}
-	libxfs_trans_commit(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(_("%s: commit failed, error %d\n"), __func__, error);
 }
 
 /*
