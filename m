Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4DD477CBE
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:21:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3FB83304043
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:21:23 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	5GaBFvKV4C5qdx1y for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 23:21:20 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVwPu-0004m3-RY
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVwPu-00014h-Qf
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/15] xfs: use vfs inode nlink field everywhere
Date: Wed, 17 Feb 2016 18:20:49 +1100
Message-Id: <1455693652-3899-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1455693652-3899-1-git-send-email-david@fromorbit.com>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
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

Source kernel commit 54d7b5c1d03e9711cce2d72237d5b3f5c87431f4

The VFS tracks the inode nlink just like the xfs_icdinode. We can
remove the variable from the icdinode and use the VFS inode variable
everywhere, reducing the size of the xfs_icdinode by a further 4
bytes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 include/xfs_inode.h      |  1 +
 libxfs/libxfs_api_defs.h |  4 ++++
 libxfs/util.c            |  5 ++---
 libxfs/xfs_inode_buf.c   |  6 +++---
 libxfs/xfs_inode_buf.h   |  1 -
 mkfs/proto.c             |  4 ++--
 repair/phase6.c          | 18 +++++++++---------
 repair/phase7.c          | 43 ++++++++++++++-----------------------------
 8 files changed, 35 insertions(+), 47 deletions(-)

diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 1efff0f..e7aa9e9 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -34,6 +34,7 @@ struct xfs_dir_ops;
  * metadata.
  */
 struct inode {
+	uint32_t	i_nlink;
 	struct timespec	i_atime;
 	struct timespec	i_mtime;
 	struct timespec	i_ctime;
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 685c7a7..1408be3 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -108,4 +108,8 @@
 
 #define xfs_verify_cksum		libxfs_verify_cksum
 
+/* inode link counts */
+#define set_nlink(inode, nlink)	({ (inode)->i_nlink = (nlink); })
+#define inc_nlink(inode)	(inode)->i_nlink++
+
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/libxfs/util.c b/libxfs/util.c
index bbaf790..9327a62 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -218,8 +218,7 @@ libxfs_ialloc(
 	ASSERT(ip != NULL);
 
 	ip->i_d.di_mode = (__uint16_t)mode;
-	ip->i_d.di_nlink = nlink;
-	ASSERT(ip->i_d.di_nlink == nlink);
+	set_nlink(VFS_I(ip), nlink);
 	ip->i_d.di_uid = cr->cr_uid;
 	ip->i_d.di_gid = cr->cr_gid;
 	xfs_set_projid(&ip->i_d, pip ? 0 : fsx->fsx_projid);
@@ -387,7 +386,7 @@ libxfs_iprint(
 		printf("    Other inode\n");
 		break;
 	}
-	printf("   di_nlink %x\n", dip->di_nlink);
+	printf("   di_nlink %x\n", VFS_I(ip)->i_nlink);
 	printf("   di_uid %d\n", dip->di_uid);
 	printf("   di_gid %d\n", dip->di_gid);
 	printf("   di_nextents %d\n", dip->di_nextents);
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 66a827a..dba8a4b 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -219,12 +219,12 @@ xfs_inode_from_disk(
 	 * minimum inode version format we support in the rest of the code.
 	 */
 	if (to->di_version == 1) {
-		to->di_nlink = be16_to_cpu(from->di_onlink);
+		set_nlink(inode, be16_to_cpu(from->di_onlink));
 		to->di_projid_lo = 0;
 		to->di_projid_hi = 0;
 		to->di_version = 2;
 	} else {
-		to->di_nlink = be32_to_cpu(from->di_nlink);
+		set_nlink(inode, be32_to_cpu(from->di_nlink));
 		to->di_projid_lo = be16_to_cpu(from->di_projid_lo);
 		to->di_projid_hi = be16_to_cpu(from->di_projid_hi);
 	}
@@ -284,7 +284,6 @@ xfs_inode_to_disk(
 	to->di_format = from->di_format;
 	to->di_uid = cpu_to_be32(from->di_uid);
 	to->di_gid = cpu_to_be32(from->di_gid);
-	to->di_nlink = cpu_to_be32(from->di_nlink);
 	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
 
@@ -295,6 +294,7 @@ xfs_inode_to_disk(
 	to->di_mtime.t_nsec = cpu_to_be32(inode->i_mtime.tv_nsec);
 	to->di_ctime.t_sec = cpu_to_be32(inode->i_ctime.tv_sec);
 	to->di_ctime.t_nsec = cpu_to_be32(inode->i_ctime.tv_nsec);
+	to->di_nlink = cpu_to_be32(inode->i_nlink);
 
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 489b96e..ccc4052 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -34,7 +34,6 @@ struct xfs_icdinode {
 	__uint16_t	di_flushiter;	/* incremented on flush */
 	__uint32_t	di_uid;		/* owner's user id */
 	__uint32_t	di_gid;		/* owner's group id */
-	__uint32_t	di_nlink;	/* number of links to file */
 	__uint16_t	di_projid_lo;	/* lower part of owner's project id */
 	__uint16_t	di_projid_hi;	/* higher part of owner's project id */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 72a1576..9550859 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -546,7 +546,7 @@ parseproto(
 				&creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
-		ip->i_d.di_nlink++;		/* account for . */
+		ip->i_vnode.i_nlink++;		/* account for . */
 		if (!pip) {
 			pip = ip;
 			mp->m_sb.sb_rootino = ip->i_ino;
@@ -557,7 +557,7 @@ parseproto(
 			xname.type = XFS_DIR3_FT_DIR;
 			newdirent(mp, tp, pip, &xname, ip->i_ino,
 				  &first, &flist);
-			pip->i_d.di_nlink++;
+			pip->i_vnode.i_nlink++;
 			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
 		}
 		newdirectory(mp, tp, ip, pip);
diff --git a/repair/phase6.c b/repair/phase6.c
index 00142e2..7e14346 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -515,7 +515,7 @@ mk_rbmino(xfs_mount_t *mp)
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
-	ip->i_d.di_nlink = 1;		/* account for sb ptr */
+	set_nlink(VFS_I(ip), 1);	/* account for sb ptr */
 
 	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
 	if (ip->i_d.di_version == 3) {
@@ -768,7 +768,7 @@ mk_rsumino(xfs_mount_t *mp)
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
-	ip->i_d.di_nlink = 1;		/* account for sb ptr */
+	set_nlink(VFS_I(ip), 1);	/* account for sb ptr */
 
 	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
 	if (ip->i_d.di_version == 3) {
@@ -877,7 +877,7 @@ mk_root_dir(xfs_mount_t *mp)
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
-	ip->i_d.di_nlink = 1;		/* account for . */
+	set_nlink(VFS_I(ip), 1);	/* account for . */
 
 	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
 	if (ip->i_d.di_version == 3) {
@@ -976,7 +976,7 @@ mk_orphanage(xfs_mount_t *mp)
 		do_error(_("%s inode allocation failed %d\n"),
 			ORPHANAGE, error);
 	}
-	ip->i_d.di_nlink++;		/* account for . */
+	inc_nlink(VFS_I(ip));		/* account for . */
 	ino = ip->i_ino;
 
 	irec = find_inode_rec(mp,
@@ -1027,7 +1027,7 @@ mk_orphanage(xfs_mount_t *mp)
 	 * bump up the link count in the root directory to account
 	 * for .. in the new directory
 	 */
-	pip->i_d.di_nlink++;
+	inc_nlink(VFS_I(pip));
 	add_inode_ref(find_inode_rec(mp,
 				XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
 				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino)), 0);
@@ -1133,7 +1133,7 @@ mv_orphanage(
 			if (irec)
 				add_inode_ref(irec, ino_offset);
 			else
-				orphanage_ip->i_d.di_nlink++;
+				inc_nlink(VFS_I(orphanage_ip));
 			libxfs_trans_log_inode(tp, orphanage_ip, XFS_ILOG_CORE);
 
 			err = -libxfs_dir_createname(tp, ino_p, &xfs_name_dotdot,
@@ -1143,7 +1143,7 @@ mv_orphanage(
 	_("creation of .. entry failed (%d), filesystem may be out of space\n"),
 					err);
 
-			ino_p->i_d.di_nlink++;
+			inc_nlink(VFS_I(ino_p));
 			libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
 
 			err = -libxfs_bmap_finish(&tp, &flist, ino_p);
@@ -1176,7 +1176,7 @@ mv_orphanage(
 			if (irec)
 				add_inode_ref(irec, ino_offset);
 			else
-				orphanage_ip->i_d.di_nlink++;
+				inc_nlink(VFS_I(orphanage_ip));
 			libxfs_trans_log_inode(tp, orphanage_ip, XFS_ILOG_CORE);
 
 			/*
@@ -1229,7 +1229,7 @@ mv_orphanage(
 				ORPHANAGE, err);
 		ASSERT(err == 0);
 
-		ino_p->i_d.di_nlink = 1;
+		set_nlink(VFS_I(ino_p), 1);
 		libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
 
 		err = -libxfs_bmap_finish(&tp, &flist, ino_p);
diff --git a/repair/phase7.c b/repair/phase7.c
index 72a8ade..3e234b9 100644
--- a/repair/phase7.c
+++ b/repair/phase7.c
@@ -28,31 +28,6 @@
 #include "progress.h"
 #include "threads.h"
 
-/* dinoc is a pointer to the IN-CORE dinode core */
-static void
-set_nlinks(
-	struct xfs_icdinode	*dinoc,
-	xfs_ino_t		ino,
-	__uint32_t		nrefs,
-	int			*dirty)
-{
-	if (dinoc->di_nlink == nrefs)
-		return;
-
-	if (!no_modify) {
-		*dirty = 1;
-		do_warn(_("resetting inode %" PRIu64 " nlinks from %u to %u\n"),
-			ino, dinoc->di_nlink, nrefs);
-
-		ASSERT(dinoc->di_version > 1);
-		dinoc->di_nlink = nrefs;
-	} else  {
-		do_warn(
-_("would have reset inode %" PRIu64 " nlinks from %u to %u\n"),
-			ino, dinoc->di_nlink, nrefs);
-	}
-}
-
 static void
 update_inode_nlinks(
 	xfs_mount_t 		*mp,
@@ -88,10 +63,20 @@ update_inode_nlinks(
 
 	dirty = 0;
 
-	/*
-	 * compare and set links for all inodes
-	 */
-	set_nlinks(&ip->i_d, ino, nlinks, &dirty);
+	/* compare and set links if they differ.  */
+	if (VFS_I(ip)->i_nlink != nlinks) {
+		if (!no_modify) {
+			do_warn(
+	_("resetting inode %" PRIu64 " nlinks from %u to %u\n"),
+				ino, VFS_I(ip)->i_nlink, nlinks);
+			set_nlink(VFS_I(ip), nlinks);
+			dirty = 1;
+		} else {
+			do_warn(
+	_("would have reset inode %" PRIu64 " nlinks from %u to %u\n"),
+				ino, VFS_I(ip)->i_nlink, nlinks);
+		}
+	}
 
 	if (!dirty)  {
 		libxfs_trans_cancel(tp);
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
