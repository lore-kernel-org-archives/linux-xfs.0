Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EEC99849A
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 19:01:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 63EB5AC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:01:40 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 91h8drMgMOsOBST1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:01:38 -0700 (PDT)
Subject: [PATCH 27/29] xfs_repair: find and mark the rtrmapbt inode
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 17:01:33 -0700
Message-ID: <147216969308.7022.3154890098779808407.stgit@birch.djwong.org>
In-Reply-To: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
References: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Make sure that we find the realtime rmapbt inode and mark it
appropriately, just in case we find a rogue inode claiming to
be an rtrmap, or just plain garbage in the superblock field.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dino_chunks.c |   12 ++++++++++++
 repair/dinode.c      |   41 +++++++++++++++++++++++++++++++++++++++++
 repair/dir2.c        |    5 +++++
 repair/globals.h     |    1 +
 repair/incore.h      |    1 +
 repair/phase1.c      |    1 +
 repair/phase6.c      |   13 +++++++++++++
 repair/rmap.c        |    1 +
 repair/sb.c          |    3 +++
 9 files changed, 78 insertions(+)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 4db9512..d08e2ba 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -924,6 +924,18 @@ next_readbuf:
 	_("would clear realtime summary inode %" PRIu64 "\n"),
 						ino);
 				}
+			} else if (mp->m_sb.sb_rrmapino == ino) {
+				need_rrmapino = 1;
+
+				if (!no_modify)  {
+					do_warn(
+	_("cleared realtime rmap inode %" PRIu64 "\n"),
+						ino);
+				} else  {
+					do_warn(
+	_("would clear realtime rmap inode %" PRIu64 "\n"),
+						ino);
+				}
 			} else if (!no_modify)  {
 				do_warn(_("cleared inode %" PRIu64 "\n"),
 					ino);
diff --git a/repair/dinode.c b/repair/dinode.c
index 04759dc..25c2ba0 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -266,6 +266,12 @@ clear_dinode(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
 	dirty = clear_dinode_core(mp, dino, ino_num);
 	dirty += clear_dinode_unlinked(mp, dino);
 
+	if (ino_num == mp->m_sb.sb_rrmapino) {
+		mp->m_sb.sb_rrmapino = NULLFSINO;
+		need_rrmapino = 1;
+		rmap_avoid_check();
+	}
+
 	/* and clear the forks */
 
 	if (dirty && !no_modify)
@@ -1838,6 +1844,27 @@ _("bad # of extents (%u) for realtime bitmap inode %" PRIu64 "\n"),
 		}
 		return 0;
 	}
+	if (lino == mp->m_sb.sb_rrmapino) {
+		if (*type != XR_INO_RTRMAP) {
+			do_warn(
+_("realtime rmap inode %" PRIu64 " has bad type 0x%x, "),
+				lino, dinode_fmt(dinoc));
+			if (!no_modify)  {
+				do_warn(_("resetting to regular file\n"));
+				change_dinode_fmt(dinoc, S_IFREG);
+				*dirty = 1;
+			} else  {
+				do_warn(_("would reset to regular file\n"));
+			}
+		}
+		if (mp->m_sb.sb_rblocks == 0 && dinoc->di_nextents != 0)  {
+			do_warn(
+_("bad # of extents (%u) for realtime rmap inode %" PRIu64 "\n"),
+				be32_to_cpu(dinoc->di_nextents), lino);
+			return 1;
+		}
+		return 0;
+	}
 	return 0;
 }
 
@@ -1928,6 +1955,18 @@ _("realtime summary inode %" PRIu64 " has bad size %" PRId64 " (should be %d)\n"
 		}
 		break;
 
+	case XR_INO_RTRMAP:
+		/*
+		 * if we have no rmapbt, any inode claiming
+		 * to be a real-time file is bogus
+		 */
+		if (!xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+			do_warn(
+_("found inode %" PRIu64 " claiming to be a rtrmapbt file, but rmapbt is disabled\n"), lino);
+			return 1;
+		}
+		break;
+
 	default:
 		break;
 	}
@@ -2774,6 +2813,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			type = XR_INO_RTBITMAP;
 		else if (lino == mp->m_sb.sb_rsumino)
 			type = XR_INO_RTSUM;
+		else if (lino == mp->m_sb.sb_rrmapino)
+			type = XR_INO_RTRMAP;
 		else
 			type = XR_INO_DATA;
 		break;
diff --git a/repair/dir2.c b/repair/dir2.c
index a2fe5c6..a120868 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -236,6 +236,9 @@ process_sf_dir2(
 		} else if (lino == mp->m_sb.sb_rsumino)  {
 			junkit = 1;
 			junkreason = _("realtime summary");
+		} else if (lino == mp->m_sb.sb_rrmapino)  {
+			junkit = 1;
+			junkreason = _("realtime rmap");
 		} else if (lino == mp->m_sb.sb_uquotino)  {
 			junkit = 1;
 			junkreason = _("user quota");
@@ -695,6 +698,8 @@ process_dir2_data(
 			clearreason = _("realtime bitmap");
 		} else if (ent_ino == mp->m_sb.sb_rsumino) {
 			clearreason = _("realtime summary");
+		} else if (ent_ino == mp->m_sb.sb_rrmapino) {
+			clearreason = _("realtime rmap");
 		} else if (ent_ino == mp->m_sb.sb_uquotino) {
 			clearreason = _("user quota");
 		} else if (ent_ino == mp->m_sb.sb_gquotino) {
diff --git a/repair/globals.h b/repair/globals.h
index efd1d03..0ea9a7d 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -118,6 +118,7 @@ EXTERN int		need_root_dotdot;
 
 EXTERN int		need_rbmino;
 EXTERN int		need_rsumino;
+EXTERN int		need_rrmapino;
 
 EXTERN int		lost_quotas;
 EXTERN int		have_uquotino;
diff --git a/repair/incore.h b/repair/incore.h
index c23a3a3..0858fd1 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -229,6 +229,7 @@ int		count_bcnt_extents(xfs_agnumber_t);
 #define XR_INO_SOCK	9		/* socket */
 #define XR_INO_FIFO	10		/* fifo */
 #define XR_INO_MOUNTPOINT 11		/* mountpoint */
+#define XR_INO_RTRMAP	12		/* realtime rmap */
 
 /* inode allocation tree */
 
diff --git a/repair/phase1.c b/repair/phase1.c
index 126d0b3..3404b0b 100644
--- a/repair/phase1.c
+++ b/repair/phase1.c
@@ -62,6 +62,7 @@ phase1(xfs_mount_t *mp)
 	need_root_dotdot = 0;
 	need_rbmino = 0;
 	need_rsumino = 0;
+	need_rrmapino = 0;
 	lost_quotas = 0;
 
 	/*
diff --git a/repair/phase6.c b/repair/phase6.c
index 560f9bb..6981b35 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3074,6 +3074,19 @@ mark_standalone_inodes(xfs_mount_t *mp)
 			add_inode_reached(irec, offset);
 		}
 	}
+
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb) && mp->m_sb.sb_rblocks > 0) {
+		irec = find_inode_rec(mp,
+				XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rrmapino),
+				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rrmapino));
+
+		offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rrmapino) -
+				irec->ino_startnum;
+
+		ASSERT(irec != NULL);
+
+		add_inode_reached(irec, offset);
+	}
 }
 
 static void
diff --git a/repair/rmap.c b/repair/rmap.c
index d6a75d7..9f9a47c 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1035,6 +1035,7 @@ rmaps_verify_btree(
 		    mp->m_sb.sb_rrmapino == NULLFSINO) {
 			do_warn(
 _("garbage in sb_rrmapino, not checking realtime rmaps\n"));
+			need_rrmapino = 1;
 			goto err;
 		}
 
diff --git a/repair/sb.c b/repair/sb.c
index ac13a66..5a2bb60 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -37,6 +37,7 @@ copy_sb(xfs_sb_t *source, xfs_sb_t *dest)
 	xfs_ino_t	rootino;
 	xfs_ino_t	rbmino;
 	xfs_ino_t	rsumino;
+	xfs_ino_t	rrmapino;
 	xfs_ino_t	uquotino;
 	xfs_ino_t	gquotino;
 	xfs_ino_t	pquotino;
@@ -45,6 +46,7 @@ copy_sb(xfs_sb_t *source, xfs_sb_t *dest)
 	rootino = dest->sb_rootino;
 	rbmino = dest->sb_rbmino;
 	rsumino = dest->sb_rsumino;
+	rrmapino = dest->sb_rrmapino;
 	uquotino = dest->sb_uquotino;
 	gquotino = dest->sb_gquotino;
 	pquotino = dest->sb_pquotino;
@@ -56,6 +58,7 @@ copy_sb(xfs_sb_t *source, xfs_sb_t *dest)
 	dest->sb_rootino = rootino;
 	dest->sb_rbmino = rbmino;
 	dest->sb_rsumino = rsumino;
+	dest->sb_rrmapino = rrmapino;
 	dest->sb_uquotino = uquotino;
 	dest->sb_gquotino = gquotino;
 	dest->sb_pquotino = pquotino;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
