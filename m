Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 218B229E1E
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 22:56:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 92083AC002
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 20:56:12 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	oaD3RWGROSOAXhSR for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 20:56:10 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WhWU5-0002Uv-HT
	for xfs@oss.sgi.com; Tue, 06 May 2014 13:56:01 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WhWU5-0005Il-Gj
	for xfs@oss.sgi.com; Tue, 06 May 2014 13:56:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/5] xfs: turn NLINK feature on by default
Date: Tue,  6 May 2014 13:55:57 +1000
Message-Id: <1399348559-19889-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1399348559-19889-1-git-send-email-david@fromorbit.com>
References: <1399348559-19889-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

mkfs has turned on the XFS_SB_VERSION_NLINKBIT feature bit by
default since November 2007. It's about time we simply made the
kernel code turn it on by default and so always convert v1 inodes to
v2 inodes. This removes needless version checks and modification
when bumping link counts on inodes, and will take code out of
a few common code paths.

   text    data     bss     dec     hex filename
 783595  100867     616  885078   d8156 fs/xfs/xfs.o.orig
 783171  100867     616  884654   d7fae fs/xfs/xfs.o.patched

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c      |  4 +--
 fs/xfs/xfs_ialloc.c     |  4 +--
 fs/xfs/xfs_inode.c      | 80 +++++++++++--------------------------------------
 fs/xfs/xfs_inode.h      |  2 +-
 fs/xfs/xfs_inode_item.c | 30 +------------------
 fs/xfs/xfs_ioctl.c      |  5 ++--
 fs/xfs/xfs_mount.c      |  6 ++++
 fs/xfs/xfs_sb.h         | 10 -------
 8 files changed, 31 insertions(+), 110 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 3445ead..2a03f2d 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -74,11 +74,9 @@ xfs_fs_geometry(
 	}
 	if (new_version >= 3) {
 		geo->version = XFS_FSOP_GEOM_VERSION;
-		geo->flags =
+		geo->flags = XFS_FSOP_GEOM_FLAGS_NLINK |
 			(xfs_sb_version_hasattr(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_ATTR : 0) |
-			(xfs_sb_version_hasnlink(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_NLINK : 0) |
 			(xfs_sb_version_hasquota(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_QUOTA : 0) |
 			(xfs_sb_version_hasalign(&mp->m_sb) ?
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 6ac0c29..c89a53a 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -280,10 +280,8 @@ xfs_ialloc_inode_init(
 		if (tp)
 			xfs_icreate_log(tp, agno, agbno, mp->m_ialloc_inos,
 					mp->m_sb.sb_inodesize, length, gen);
-	} else if (xfs_sb_version_hasnlink(&mp->m_sb))
+	} else
 		version = 2;
-	else
-		version = 1;
 
 	for (j = 0; j < nbufs; j++) {
 		/*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6d6b44a..0fcfdd4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -681,6 +681,14 @@ xfs_ialloc(
 		return error;
 	ASSERT(ip != NULL);
 
+	/*
+	 * We always convert v1 inodes to v2 now - we only support filesystems
+	 * with >= v2 inode capability, so there is no reason for ever leaving
+	 * an inode in v1 format.
+	 */
+	if (ip->i_d.di_version == 1)
+		ip->i_d.di_version = 2;
+
 	ip->i_d.di_mode = mode;
 	ip->i_d.di_onlink = 0;
 	ip->i_d.di_nlink = nlink;
@@ -690,27 +698,6 @@ xfs_ialloc(
 	xfs_set_projid(ip, prid);
 	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 
-	/*
-	 * If the superblock version is up to where we support new format
-	 * inodes and this is currently an old format inode, then change
-	 * the inode version number now.  This way we only do the conversion
-	 * here rather than here and in the flush/logging code.
-	 */
-	if (xfs_sb_version_hasnlink(&mp->m_sb) &&
-	    ip->i_d.di_version == 1) {
-		ip->i_d.di_version = 2;
-		/*
-		 * We've already zeroed the old link count, the projid field,
-		 * and the pad field.
-		 */
-	}
-
-	/*
-	 * Project ids won't be stored on disk if we are using a version 1 inode.
-	 */
-	if ((prid != 0) && (ip->i_d.di_version == 1))
-		xfs_bump_ino_vers2(tp, ip);
-
 	if (pip && XFS_INHERIT_GID(pip)) {
 		ip->i_d.di_gid = pip->i_d.di_gid;
 		if ((pip->i_d.di_mode & S_ISGID) && S_ISDIR(mode)) {
@@ -1064,28 +1051,14 @@ xfs_droplink(
  */
 void
 xfs_bump_ino_vers2(
-	xfs_trans_t	*tp,
 	xfs_inode_t	*ip)
 {
-	xfs_mount_t	*mp;
-
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(ip->i_d.di_version == 1);
 
 	ip->i_d.di_version = 2;
 	ip->i_d.di_onlink = 0;
 	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
-	mp = tp->t_mountp;
-	if (!xfs_sb_version_hasnlink(&mp->m_sb)) {
-		spin_lock(&mp->m_sb_lock);
-		if (!xfs_sb_version_hasnlink(&mp->m_sb)) {
-			xfs_sb_version_addnlink(&mp->m_sb);
-			spin_unlock(&mp->m_sb_lock);
-			xfs_mod_sb(tp, XFS_SB_VERSIONNUM);
-		} else {
-			spin_unlock(&mp->m_sb_lock);
-		}
-	}
 	/* Caller must log the inode */
 }
 
@@ -1112,7 +1085,7 @@ xfs_bumplink(
 		 * system to do this, then we need to bump the superblock
 		 * version number as well.
 		 */
-		xfs_bump_ino_vers2(tp, ip);
+		xfs_bump_ino_vers2(ip);
 	}
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
@@ -3333,34 +3306,17 @@ xfs_iflush_int(
 		ip->i_d.di_flushiter = 0;
 
 	/*
-	 * If this is really an old format inode and the superblock version
-	 * has not been updated to support only new format inodes, then
-	 * convert back to the old inode format.  If the superblock version
-	 * has been updated, then make the conversion permanent.
+	 * If this is really an old format inode, convert it to a v2 format
+	 * inode to make the conversion permanent.
 	 */
-	ASSERT(ip->i_d.di_version == 1 || xfs_sb_version_hasnlink(&mp->m_sb));
 	if (ip->i_d.di_version == 1) {
-		if (!xfs_sb_version_hasnlink(&mp->m_sb)) {
-			/*
-			 * Convert it back.
-			 */
-			ASSERT(ip->i_d.di_nlink <= XFS_MAXLINK_1);
-			dip->di_onlink = cpu_to_be16(ip->i_d.di_nlink);
-		} else {
-			/*
-			 * The superblock version has already been bumped,
-			 * so just make the conversion to the new inode
-			 * format permanent.
-			 */
-			ip->i_d.di_version = 2;
-			dip->di_version = 2;
-			ip->i_d.di_onlink = 0;
-			dip->di_onlink = 0;
-			memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
-			memset(&(dip->di_pad[0]), 0,
-			      sizeof(dip->di_pad));
-			ASSERT(xfs_get_projid(ip) == 0);
-		}
+		ip->i_d.di_version = 2;
+		dip->di_version = 2;
+		ip->i_d.di_onlink = 0;
+		dip->di_onlink = 0;
+		memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
+		memset(&(dip->di_pad[0]), 0, sizeof(dip->di_pad));
+		ASSERT(xfs_get_projid(ip) == 0);
 	}
 
 	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 13aea54..0ae6e0d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -377,7 +377,7 @@ int		xfs_dir_ialloc(struct xfs_trans **, struct xfs_inode *, umode_t,
 			       struct xfs_inode **, int *);
 int		xfs_droplink(struct xfs_trans *, struct xfs_inode *);
 int		xfs_bumplink(struct xfs_trans *, struct xfs_inode *);
-void		xfs_bump_ino_vers2(struct xfs_trans *, struct xfs_inode *);
+void		xfs_bump_ino_vers2(struct xfs_inode *);
 
 /* from xfs_file.c */
 int		xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 686889b..dacd6c1 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -145,34 +145,6 @@ xfs_inode_item_size(
 		xfs_inode_item_attr_fork_size(iip, nvecs, nbytes);
 }
 
-/*
- * If this is a v1 format inode, then we need to log it as such.  This means
- * that we have to copy the link count from the new field to the old.  We
- * don't have to worry about the new fields, because nothing trusts them as
- * long as the old inode version number is there.
- */
-STATIC void
-xfs_inode_item_format_v1_inode(
-	struct xfs_inode	*ip)
-{
-	if (!xfs_sb_version_hasnlink(&ip->i_mount->m_sb)) {
-		/*
-		 * Convert it back.
-		 */
-		ASSERT(ip->i_d.di_nlink <= XFS_MAXLINK_1);
-		ip->i_d.di_onlink = ip->i_d.di_nlink;
-	} else {
-		/*
-		 * The superblock version has already been bumped,
-		 * so just make the conversion to the new inode
-		 * format permanent.
-		 */
-		ip->i_d.di_version = 2;
-		ip->i_d.di_onlink = 0;
-		memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
-	}
-}
-
 STATIC void
 xfs_inode_item_format_data_fork(
 	struct xfs_inode_log_item *iip,
@@ -381,7 +353,7 @@ xfs_inode_item_format(
 	xlog_finish_iovec(lv, vecp, sizeof(struct xfs_inode_log_format));
 
 	if (ip->i_d.di_version == 1)
-		xfs_inode_item_format_v1_inode(ip);
+		xfs_bump_ino_vers2(ip);
 	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ICORE,
 			&ip->i_d,
 			xfs_icdinode_size(ip->i_d.di_version));
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2d8f4fd..3f55759 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1228,7 +1228,6 @@ xfs_ioctl_setattr(
 				olddquot = xfs_qm_vop_chown(tp, ip,
 							&ip->i_pdquot, pdqp);
 			}
-			xfs_set_projid(ip, fa->fsx_projid);
 
 			/*
 			 * We may have to rev the inode as well as
@@ -1236,7 +1235,9 @@ xfs_ioctl_setattr(
 			 * exist before DINODE_VERSION_2 and SB_VERSION_NLINK.
 			 */
 			if (ip->i_d.di_version == 1)
-				xfs_bump_ino_vers2(tp, ip);
+				xfs_bump_ino_vers2(ip);
+
+			xfs_set_projid(ip, fa->fsx_projid);
 		}
 
 	}
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 944f3d9..3f09782 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -697,6 +697,12 @@ xfs_mountfs(
 			mp->m_update_flags |= XFS_SB_VERSIONNUM;
 	}
 
+	/* always use v2 inodes by default now */
+	if (!(mp->m_sb.sb_versionnum & XFS_SB_VERSION_NLINKBIT)) {
+		mp->m_sb.sb_versionnum |= XFS_SB_VERSION_NLINKBIT;
+		mp->m_update_flags |= XFS_SB_VERSIONNUM;
+	}
+
 	/*
 	 * Check if sb_agblocks is aligned at stripe boundary
 	 * If sb_agblocks is NOT aligned turn off m_dalign since
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 7dfa8f1..b238a0e 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -376,16 +376,6 @@ static inline void xfs_sb_version_addattr(struct xfs_sb *sbp)
 	sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
 }
 
-static inline bool xfs_sb_version_hasnlink(struct xfs_sb *sbp)
-{
-	return (sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT);
-}
-
-static inline void xfs_sb_version_addnlink(struct xfs_sb *sbp)
-{
-	sbp->sb_versionnum |= XFS_SB_VERSION_NLINKBIT;
-}
-
 static inline bool xfs_sb_version_hasquota(struct xfs_sb *sbp)
 {
 	return (sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT);
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
