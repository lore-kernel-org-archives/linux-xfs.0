Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49430 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725740AbeJAXnt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 19:43:49 -0400
Subject: [PATCH 6/8] libxfs: clean up IRELE/iput callsites
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Oct 2018 10:04:58 -0700
Message-ID: <153841349888.27952.10960138712287407315.stgit@magnolia>
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

Replace the IRELE macro with a proper function so that we can do proper
typechecking.  This is the userspace cleanup in the same vein as the
kernel patch with the same subject.
---
 db/attrset.c        |    4 ++--
 include/xfs_inode.h |    4 +---
 libxfs/init.c       |    4 ++--
 libxfs/rdwr.c       |    5 +++--
 mkfs/proto.c        |    6 +++---
 repair/phase6.c     |   22 +++++++++++-----------
 repair/phase7.c     |    2 +-
 7 files changed, 23 insertions(+), 24 deletions(-)


diff --git a/db/attrset.c b/db/attrset.c
index dc82a6c6..56972506 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -159,7 +159,7 @@ attr_set_f(
 out:
 	mp->m_flags &= ~LIBXFS_MOUNT_COMPAT_ATTR;
 	if (ip)
-		IRELE(ip);
+		libxfs_irele(ip);
 	if (value)
 		free(value);
 	return 0;
@@ -234,6 +234,6 @@ attr_remove_f(
 out:
 	mp->m_flags &= ~LIBXFS_MOUNT_COMPAT_ATTR;
 	if (ip)
-		IRELE(ip);
+		libxfs_irele(ip);
 	return 0;
 }
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index f573f23b..79ec3a2d 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -155,8 +155,6 @@ extern bool	libxfs_inode_verify_forks(struct xfs_inode *ip,
 extern int	libxfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 				uint, struct xfs_inode **,
 				struct xfs_ifork_ops *);
-extern void	libxfs_iput(struct xfs_inode *);
-
-#define IRELE(ip) libxfs_iput(ip)
+extern void	libxfs_irele(struct xfs_inode *ip);
 
 #endif /* __XFS_INODE_H__ */
diff --git a/libxfs/init.c b/libxfs/init.c
index 36d637c5..d7543d4a 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -838,9 +838,9 @@ void
 libxfs_rtmount_destroy(xfs_mount_t *mp)
 {
 	if (mp->m_rsumip)
-		IRELE(mp->m_rsumip);
+		libxfs_irele(mp->m_rsumip);
 	if (mp->m_rbmip)
-		IRELE(mp->m_rbmip);
+		libxfs_irele(mp->m_rbmip);
 	mp->m_rsumip = mp->m_rbmip = NULL;
 }
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 14a4633e..0ee3ba86 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1402,7 +1402,7 @@ libxfs_iget(
 	}
 
 	if (!libxfs_inode_verify_forks(ip, ifork_ops)) {
-		libxfs_iput(ip);
+		libxfs_irele(ip);
 		return -EFSCORRUPTED;
 	}
 
@@ -1435,7 +1435,8 @@ libxfs_idestroy(xfs_inode_t *ip)
 }
 
 void
-libxfs_iput(xfs_inode_t *ip)
+libxfs_irele(
+	struct xfs_inode	*ip)
 {
 	if (ip->i_itemp)
 		kmem_zone_free(xfs_ili_zone, ip->i_itemp);
diff --git a/mkfs/proto.c b/mkfs/proto.c
index dc82f093..687c53ab 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -479,7 +479,7 @@ parseproto(
 		if (error)
 			fail(_("Space preallocation failed."), error);
 		rsvfile(mp, ip, llen);
-		IRELE(ip);
+		libxfs_irele(ip);
 		return;
 
 	case IF_BLOCK:
@@ -573,7 +573,7 @@ parseproto(
 				break;
 			parseproto(mp, ip, fsxp, pp, name);
 		}
-		IRELE(ip);
+		libxfs_irele(ip);
 		return;
 	default:
 		ASSERT(0);
@@ -585,7 +585,7 @@ parseproto(
 		fail(_("Error encountered creating file from prototype file"),
 			error);
 	}
-	IRELE(ip);
+	libxfs_irele(ip);
 }
 
 void
diff --git a/repair/phase6.c b/repair/phase6.c
index 8c0165ca..e2e4446a 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -612,7 +612,7 @@ mk_rbmino(xfs_mount_t *mp)
 		_("allocation of the realtime bitmap failed, error = %d\n"),
 			error);
 	}
-	IRELE(ip);
+	libxfs_irele(ip);
 }
 
 static int
@@ -678,7 +678,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
 	error = -libxfs_trans_commit(tp);
 	if (error)
 		do_error(_("%s: commit failed, error %d\n"), __func__, error);
-	IRELE(ip);
+	libxfs_irele(ip);
 	return(0);
 }
 
@@ -733,7 +733,7 @@ fill_rsumino(xfs_mount_t *mp)
 			do_warn(
 _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode %" PRIu64 "\n"),
 				bno, map.br_startblock, mp->m_sb.sb_rsumino);
-			IRELE(ip);
+			libxfs_irele(ip);
 			return(1);
 		}
 
@@ -748,7 +748,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 	error = -libxfs_trans_commit(tp);
 	if (error)
 		do_error(_("%s: commit failed, error %d\n"), __func__, error);
-	IRELE(ip);
+	libxfs_irele(ip);
 	return(0);
 }
 
@@ -852,7 +852,7 @@ mk_rsumino(xfs_mount_t *mp)
 	_("allocation of the realtime summary ino failed, error = %d\n"),
 			error);
 	}
-	IRELE(ip);
+	libxfs_irele(ip);
 }
 
 /*
@@ -920,7 +920,7 @@ mk_root_dir(xfs_mount_t *mp)
 	if (error)
 		do_error(_("%s: commit failed, error %d\n"), __func__, error);
 
-	IRELE(ip);
+	libxfs_irele(ip);
 
 	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
 				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
@@ -1054,8 +1054,8 @@ mk_orphanage(xfs_mount_t *mp)
 		do_error(_("%s directory creation failed -- bmapf error %d\n"),
 			ORPHANAGE, error);
 	}
-	IRELE(ip);
-	IRELE(pip);
+	libxfs_irele(ip);
+	libxfs_irele(pip);
 	add_inode_reached(irec,ino_offset);
 
 	return(ino);
@@ -1233,8 +1233,8 @@ mv_orphanage(
 			do_error(
 	_("orphanage name create failed (%d)\n"), err);
 	}
-	IRELE(ino_p);
-	IRELE(orphanage_ip);
+	libxfs_irele(ino_p);
+	libxfs_irele(orphanage_ip);
 }
 
 static int
@@ -3050,7 +3050,7 @@ process_dir_inode(
 	_("root inode \".\" entry recreation failed (%d)\n"), error);
 		}
 	}
-	IRELE(ip);
+	libxfs_irele(ip);
 }
 
 /*
diff --git a/repair/phase7.c b/repair/phase7.c
index 09d11fcd..c2a60a93 100644
--- a/repair/phase7.c
+++ b/repair/phase7.c
@@ -77,7 +77,7 @@ update_inode_nlinks(
 
 		ASSERT(error == 0);
 	}
-	IRELE(ip);
+	libxfs_irele(ip);
 }
 
 /*
