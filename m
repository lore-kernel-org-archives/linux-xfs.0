Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 85EC87F93
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 05:55:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3CCCF8F8074
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 03:55:08 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Q9tyDG5odxb7oopo (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Jun 2015 03:55:04 -0700 (PDT)
Received: from [88.128.80.44] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z5Azn-0002Cu-BF
	for xfs@oss.sgi.com; Wed, 17 Jun 2015 10:55:04 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] xfs: saner xfs_trans_commit interface
Date: Wed, 17 Jun 2015 12:53:01 +0200
Message-Id: <1434538381-4847-5-git-send-email-hch@lst.de>
In-Reply-To: <1434538381-4847-1-git-send-email-hch@lst.de>
References: <1434538381-4847-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Remove the unused xfs_trans_commit flags argument.  Unlike the kernel
libxfs alwasy ignored the flags argument anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_trans.h |  2 +-
 libxfs/trans.c      |  5 ++---
 libxfs/util.c       |  2 +-
 libxfs/xfs_attr.c   |  7 +++----
 libxfs/xfs_bmap.c   |  5 ++---
 libxfs/xfs_sb.c     |  2 +-
 libxfs/xfs_shared.h |  5 -----
 mkfs/proto.c        | 16 ++++++++--------
 mkfs/xfs_mkfs.c     |  2 +-
 repair/phase5.c     |  2 +-
 repair/phase6.c     | 43 ++++++++++++++++++-------------------------
 repair/phase7.c     |  3 +--
 12 files changed, 39 insertions(+), 55 deletions(-)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 9180575..5467c7f 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -89,7 +89,7 @@ int	xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
 xfs_trans_t	*libxfs_trans_alloc(struct xfs_mount *, int);
 int	libxfs_trans_reserve(struct xfs_trans *, struct xfs_trans_res *,
 				     uint, uint);
-int	libxfs_trans_commit(struct xfs_trans *, uint);
+int	libxfs_trans_commit(struct xfs_trans *);
 void	libxfs_trans_cancel(struct xfs_trans *);
 struct xfs_buf *libxfs_trans_getsb(struct xfs_trans *, struct xfs_mount *, int);
 
diff --git a/libxfs/trans.c b/libxfs/trans.c
index ef9c510..0388950 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -128,7 +128,7 @@ libxfs_trans_roll(
 	 * is in progress. The caller takes the responsibility to cancel
 	 * the duplicate transaction that gets returned.
 	 */
-	error = xfs_trans_commit(trans, 0);
+	error = xfs_trans_commit(trans);
 	if (error)
 		return error;
 
@@ -806,8 +806,7 @@ xfs_trans_free_items(
  */
 int
 libxfs_trans_commit(
-	xfs_trans_t	*tp,
-	uint		flags)
+	xfs_trans_t	*tp)
 {
 	xfs_sb_t	*sbp;
 
diff --git a/libxfs/util.c b/libxfs/util.c
index 491c358..e250765 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -590,7 +590,7 @@ libxfs_alloc_file_space(
 		if (error)
 			goto error0;
 
-		error = xfs_trans_commit(tp, 0);
+		error = xfs_trans_commit(tp);
 		if (error)
 			break;
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index b4c1e92..bdde0f6 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -315,8 +315,7 @@ xfs_attr_set(
 				xfs_trans_ichgtime(args.trans, dp,
 							XFS_ICHGTIME_CHG);
 			}
-			err2 = xfs_trans_commit(args.trans,
-						 XFS_TRANS_RELEASE_LOG_RES);
+			err2 = xfs_trans_commit(args.trans);
 			xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
 			return error ? error : err2;
@@ -378,7 +377,7 @@ xfs_attr_set(
 	 * Commit the last in the sequence of transactions.
 	 */
 	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
-	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(args.trans);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
 	return error;
@@ -494,7 +493,7 @@ xfs_attr_remove(
 	 * Commit the last in the sequence of transactions.
 	 */
 	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
-	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(args.trans);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
 	return error;
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index a2e7764..2fd0b44 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1207,7 +1207,7 @@ xfs_bmap_add_attrfork(
 	error = xfs_bmap_finish(&tp, &flist, &committed);
 	if (error)
 		goto bmap_cancel;
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 
@@ -5918,8 +5918,7 @@ xfs_bmap_split_extent(
 	if (error)
 		goto out;
 
-	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-
+	return xfs_trans_commit(tp);
 
 out:
 	xfs_trans_cancel(tp);
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 07dc2a6..bfa4a02 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -805,5 +805,5 @@ xfs_sync_sb(
 	xfs_log_sb(tp);
 	if (wait)
 		xfs_trans_set_sync(tp);
-	return xfs_trans_commit(tp, 0);
+	return xfs_trans_commit(tp);
 }
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 930cc7d..5be5297 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -182,11 +182,6 @@ int	xfs_log_calc_minimum_size(struct xfs_mount *);
 #define XFS_TRANS_FREEZE_PROT	0x40	/* Transaction has elevated writer
 					   count in superblock */
 /*
- * Values for call flags parameter.
- */
-#define	XFS_TRANS_RELEASE_LOG_RES	0x4
-
-/*
  * Field values for xfs_trans_mod_sb.
  */
 #define	XFS_TRANS_SB_ICOUNT		0x00000001
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 45565b7..816e9a7 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -215,7 +215,7 @@ rsvfile(
 	ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
 
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	libxfs_trans_commit(tp, 0);
+	libxfs_trans_commit(tp);
 }
 
 static int
@@ -484,7 +484,7 @@ parseproto(
 		error = -libxfs_bmap_finish(&tp, &flist, &committed);
 		if (error)
 			fail(_("Pre-allocated file creation failed"), error);
-		libxfs_trans_commit(tp, 0);
+		libxfs_trans_commit(tp);
 		rsvfile(mp, ip, llen);
 		IRELE(ip);
 		return;
@@ -566,7 +566,7 @@ parseproto(
 		error = -libxfs_bmap_finish(&tp, &flist, &committed);
 		if (error)
 			fail(_("Directory creation failed"), error);
-		libxfs_trans_commit(tp, 0);
+		libxfs_trans_commit(tp);
 		/*
 		 * RT initialization.  Do this here to ensure that
 		 * the RT inodes get placed after the root inode.
@@ -594,7 +594,7 @@ parseproto(
 		fail(_("Error encountered creating file from prototype file"),
 			error);
 	}
-	libxfs_trans_commit(tp, 0);
+	libxfs_trans_commit(tp);
 	IRELE(ip);
 }
 
@@ -668,7 +668,7 @@ rtinit(
 	rsumip->i_d.di_size = mp->m_rsumsize;
 	libxfs_trans_log_inode(tp, rsumip, XFS_ILOG_CORE);
 	libxfs_log_sb(tp);
-	libxfs_trans_commit(tp, 0);
+	libxfs_trans_commit(tp);
 	mp->m_rsumip = rsumip;
 	/*
 	 * Next, give the bitmap file some zero-filled blocks.
@@ -704,7 +704,7 @@ rtinit(
 	if (error) {
 		fail(_("Completion of the realtime bitmap failed"), error);
 	}
-	libxfs_trans_commit(tp, 0);
+	libxfs_trans_commit(tp);
 
 	/*
 	 * Give the summary file some zero-filled blocks.
@@ -739,7 +739,7 @@ rtinit(
 	if (error) {
 		fail(_("Completion of the realtime summary failed"), error);
 	}
-	libxfs_trans_commit(tp, 0);
+	libxfs_trans_commit(tp);
 
 	/*
 	 * Free the whole area using transactions.
@@ -763,7 +763,7 @@ rtinit(
 		if (error) {
 			fail(_("Error completing the realtime space"), error);
 		}
-		libxfs_trans_commit(tp, 0);
+		libxfs_trans_commit(tp);
 	}
 }
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 83f7749..15234ce 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3035,7 +3035,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 
 		libxfs_alloc_fix_freelist(&args, 0);
 		xfs_perag_put(args.pag);
-		libxfs_trans_commit(tp, 0);
+		libxfs_trans_commit(tp);
 	}
 
 	/*
diff --git a/repair/phase5.c b/repair/phase5.c
index 0601810..ab37b34 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1515,7 +1515,7 @@ build_agf_agfl(xfs_mount_t	*mp,
 			do_error(_("failed to fix AGFL on AG %d, error %d\n"),
 					agno, error);
 		}
-		libxfs_trans_commit(tp, 0);
+		libxfs_trans_commit(tp);
 	}
 
 #ifdef XR_BLD_FREE_TRACE
diff --git a/repair/phase6.c b/repair/phase6.c
index bbd005e..8d39f47 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -545,7 +545,7 @@ mk_rbmino(xfs_mount_t *mp)
 	 * commit changes
 	 */
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
+	libxfs_trans_commit(tp);
 
 	/*
 	 * then allocate blocks for file and fill with zeroes (stolen
@@ -584,7 +584,7 @@ mk_rbmino(xfs_mount_t *mp)
 		_("allocation of the realtime bitmap failed, error = %d\n"),
 			error);
 	}
-	libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
+	libxfs_trans_commit(tp);
 }
 
 static int
@@ -653,7 +653,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
 		bno++;
 	}
 
-	libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
+	libxfs_trans_commit(tp);
 	return(0);
 }
 
@@ -725,7 +725,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 		bno++;
 	}
 
-	libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
+	libxfs_trans_commit(tp);
 	return(0);
 }
 
@@ -801,7 +801,7 @@ mk_rsumino(xfs_mount_t *mp)
 	 * commit changes
 	 */
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
+	libxfs_trans_commit(tp);
 
 	/*
 	 * then allocate blocks for file and fill with zeroes (stolen
@@ -845,7 +845,7 @@ mk_rsumino(xfs_mount_t *mp)
 	_("allocation of the realtime summary ino failed, error = %d\n"),
 			error);
 	}
-	libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
+	libxfs_trans_commit(tp);
 }
 
 /*
@@ -919,7 +919,7 @@ mk_root_dir(xfs_mount_t *mp)
 	ip->d_ops = mp->m_dir_inode_ops;
 	libxfs_dir_init(tp, ip, ip);
 
-	libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
+	libxfs_trans_commit(tp);
 
 	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
 				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
@@ -1060,7 +1060,7 @@ mk_orphanage(xfs_mount_t *mp)
 	}
 
 
-	libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
+	libxfs_trans_commit(tp);
 	IRELE(ip);
 	IRELE(pip);
 	add_inode_reached(irec,ino_offset);
@@ -1168,8 +1168,7 @@ mv_orphanage(
 	_("bmap finish failed (err - %d), filesystem may be out of space\n"),
 					err);
 
-			libxfs_trans_commit(tp,
-				XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
+			libxfs_trans_commit(tp);
 		} else  {
 			err = -libxfs_trans_reserve(tp, &M_RES(mp)->tr_rename,
 						   nres, 0);
@@ -1216,8 +1215,7 @@ mv_orphanage(
 	_("bmap finish failed (%d), filesystem may be out of space\n"),
 					err);
 
-			libxfs_trans_commit(tp,
-				XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
+			libxfs_trans_commit(tp);
 		}
 
 	} else  {
@@ -1256,7 +1254,7 @@ mv_orphanage(
 	_("bmap finish failed (%d), filesystem may be out of space\n"),
 				err);
 
-		libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
+		libxfs_trans_commit(tp);
 	}
 	IRELE(ino_p);
 	IRELE(orphanage_ip);
@@ -1354,7 +1352,7 @@ longform_dir2_rebuild(
 
 	error = -libxfs_bmap_finish(&tp, &flist, &committed);
 
-	libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
+	libxfs_trans_commit(tp);
 
 	if (ino == mp->m_sb.sb_rootino)
 		need_root_dotdot = 0;
@@ -1395,8 +1393,7 @@ _("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"
 			goto out_bmap_cancel;
 		}
 
-		libxfs_trans_commit(tp,
-				XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
+		libxfs_trans_commit(tp);
 	}
 
 	return;
@@ -1450,7 +1447,7 @@ dir2_kill_block(
 		do_error(_("shrink_inode failed inode %" PRIu64 " block %u\n"),
 			ip->i_ino, da_bno);
 	libxfs_bmap_finish(&tp, &flist, &committed);
-	libxfs_trans_commit(tp, 0);
+	libxfs_trans_commit(tp);
 }
 
 /*
@@ -1926,7 +1923,7 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
 	if (needlog)
 		libxfs_dir2_data_log_header(&da, bp);
 	libxfs_bmap_finish(&tp, &flist, &committed);
-	libxfs_trans_commit(tp, 0);
+	libxfs_trans_commit(tp);
 
 	/* record the largest free space in the freetab for later checking */
 	bf = M_DIROPS(mp)->data_bestfree_p(d);
@@ -2945,9 +2942,7 @@ process_dir_inode(
 			if (dirty)  {
 				libxfs_trans_log_inode(tp, ip,
 					XFS_ILOG_CORE | XFS_ILOG_DDATA);
-				libxfs_trans_commit(tp,
-					XFS_TRANS_RELEASE_LOG_RES |
-					XFS_TRANS_SYNC);
+				libxfs_trans_commit(tp);
 			} else  {
 				libxfs_trans_cancel(tp);
 			}
@@ -2995,8 +2990,7 @@ process_dir_inode(
 
 		error = -libxfs_bmap_finish(&tp, &flist, &committed);
 		ASSERT(error == 0);
-		libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES |
-							XFS_TRANS_SYNC);
+		libxfs_trans_commit(tp);
 
 		need_root_dotdot = 0;
 	} else if (need_root_dotdot && ino == mp->m_sb.sb_rootino)  {
@@ -3057,8 +3051,7 @@ process_dir_inode(
 
 			error = -libxfs_bmap_finish(&tp, &flist, &committed);
 			ASSERT(error == 0);
-			libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES
-					|XFS_TRANS_SYNC);
+			libxfs_trans_commit(tp);
 		}
 	}
 	IRELE(ip);
diff --git a/repair/phase7.c b/repair/phase7.c
index 926dda0..8d0109b 100644
--- a/repair/phase7.c
+++ b/repair/phase7.c
@@ -101,8 +101,7 @@ update_inode_nlinks(
 		 * we're not allocating anything
 		 */
 		ASSERT(error == 0);
-		error = -libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES |
-				XFS_TRANS_SYNC);
+		error = -libxfs_trans_commit(tp);
 
 		ASSERT(error == 0);
 	}
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
