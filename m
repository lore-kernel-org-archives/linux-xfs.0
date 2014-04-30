Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1BB9929DF9
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 09:03:07 -0500 (CDT)
Received: from eagdhcp-232-128.americas.sgi.com
	(eagdhcp-232-128.americas.sgi.com [128.162.232.128])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EE1F1304064
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 07:03:03 -0700 (PDT)
Received: from eagdhcp-232-128.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-128.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s3UE32WI007724
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 09:03:02 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-128.americas.sgi.com)
Message-Id: <20140430135319.660238697@sgi.com>
Date: Wed, 30 Apr 2014 08:48:45 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 1/2] xfsprogs: remove unused argument in trans_iput
References: <20140430134844.924376330@sgi.com>
Content-Disposition: inline; filename=xfsprogs-remove-extra-var-xfs_iput.patch
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

Remove the unused second argument to xfs_iput() and
xfs_trans_iput().

Introduce the define "IRELE()" and use in place of xfs_iput().
 
Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 db/attrset.c     |    4 ++--
 include/libxfs.h |    6 ++++--
 libxfs/init.c    |    4 ++--
 libxfs/rdwr.c    |    2 +-
 libxfs/trans.c   |   11 +++++------
 mkfs/proto.c     |    2 +-
 repair/phase6.c  |    2 +-
 repair/phase7.c  |    2 +-
 8 files changed, 17 insertions(+), 16 deletions(-)

Index: b/db/attrset.c
===================================================================
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -170,7 +170,7 @@ attr_set_f(
 out:
 	mp->m_flags &= ~LIBXFS_MOUNT_COMPAT_ATTR;
 	if (ip)
-		libxfs_iput(ip, 0);
+		IRELE(ip);
 	if (value)
 		free(value);
 	return 0;
@@ -244,6 +244,6 @@ attr_remove_f(
 out:
 	mp->m_flags &= ~LIBXFS_MOUNT_COMPAT_ATTR;
 	if (ip)
-		libxfs_iput(ip, 0);
+		IRELE(ip);
 	return 0;
 }
Index: b/include/libxfs.h
===================================================================
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -532,7 +532,7 @@ extern xfs_buf_t	*libxfs_trans_getsb (xf
 
 extern int	libxfs_trans_iget (xfs_mount_t *, xfs_trans_t *, xfs_ino_t,
 				uint, uint, struct xfs_inode **);
-extern void	libxfs_trans_iput(xfs_trans_t *, struct xfs_inode *, uint);
+extern void	libxfs_trans_iput(xfs_trans_t *, struct xfs_inode *);
 extern void	libxfs_trans_ijoin (xfs_trans_t *, struct xfs_inode *, uint);
 extern void	libxfs_trans_ihold (xfs_trans_t *, struct xfs_inode *);
 extern void	libxfs_trans_ijoin_ref(xfs_trans_t *, struct xfs_inode *, int);
@@ -653,7 +653,9 @@ extern int	libxfs_iflush_int (xfs_inode_
 /* Inode Cache Interfaces */
 extern int	libxfs_iget (xfs_mount_t *, xfs_trans_t *, xfs_ino_t,
 				uint, xfs_inode_t **, xfs_daddr_t);
-extern void	libxfs_iput (xfs_inode_t *, uint);
+extern void	libxfs_iput (xfs_inode_t *);
+
+#define IRELE(ip) libxfs_iput(ip)
 
 /* Shared utility routines */
 extern unsigned int	libxfs_log2_roundup(unsigned int i);
Index: b/libxfs/init.c
===================================================================
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -778,9 +778,9 @@ void
 libxfs_rtmount_destroy(xfs_mount_t *mp)
 {
 	if (mp->m_rsumip)
-		libxfs_iput(mp->m_rsumip, 0);
+		IRELE(mp->m_rsumip);
 	if (mp->m_rbmip)
-		libxfs_iput(mp->m_rbmip, 0);
+		IRELE(mp->m_rbmip);
 	mp->m_rsumip = mp->m_rbmip = NULL;
 }
 
Index: b/libxfs/rdwr.c
===================================================================
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1076,7 +1076,7 @@ libxfs_idestroy(xfs_inode_t *ip)
 }
 
 void
-libxfs_iput(xfs_inode_t *ip, uint lock_flags)
+libxfs_iput(xfs_inode_t *ip)
 {
 	if (ip->i_itemp)
 		kmem_zone_free(xfs_ili_zone, ip->i_itemp);
Index: b/libxfs/trans.c
===================================================================
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -250,13 +250,12 @@ libxfs_trans_iget(
 void
 libxfs_trans_iput(
 	xfs_trans_t		*tp,
-	xfs_inode_t		*ip,
-	uint			lock_flags)
+	xfs_inode_t		*ip)
 {
 	xfs_inode_log_item_t	*iip;
 
 	if (tp == NULL) {
-		libxfs_iput(ip, lock_flags);
+		IRELE(ip);
 		return;
 	}
 
@@ -265,7 +264,7 @@ libxfs_trans_iput(
 	ASSERT(iip != NULL);
 	xfs_trans_del_item(&iip->ili_item);
 
-	libxfs_iput(ip, lock_flags);
+	IRELE(ip);
 }
 
 void
@@ -737,7 +736,7 @@ ili_done:
 		return;
 	}
 	/* free the inode */
-	libxfs_iput(ip, 0);
+	IRELE(ip);
 }
 
 static void
@@ -819,7 +818,7 @@ inode_item_unlock(
 
 	iip->ili_flags = 0;
 	if (!iip->ili_lock_flags)
-		libxfs_iput(ip, 0);
+		IRELE(ip);
 	else
 		iip->ili_lock_flags = 0;
 }
Index: b/mkfs/proto.c
===================================================================
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -589,7 +589,7 @@ parseproto(
 				break;
 			parseproto(mp, ip, fsxp, pp, name);
 		}
-		libxfs_iput(ip, 0);
+		IRELE(ip);
 		return;
 	default:
 		ASSERT(0);
Index: b/repair/phase6.c
===================================================================
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2873,7 +2873,7 @@ process_dir_inode(
 					|XFS_TRANS_SYNC);
 		}
 	}
-	libxfs_iput(ip, 0);
+	IRELE(ip);
 }
 
 /*
Index: b/repair/phase7.c
===================================================================
--- a/repair/phase7.c
+++ b/repair/phase7.c
@@ -99,7 +99,7 @@ update_inode_nlinks(
 	set_nlinks(&ip->i_d, ino, nlinks, &dirty);
 
 	if (!dirty)  {
-		libxfs_trans_iput(tp, ip, 0);
+		libxfs_trans_iput(tp, ip);
 		libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
 	} else  {
 		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
