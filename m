Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 12AC77F54
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:21:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 03F81304032
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:21:24 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	r5OyTccQohMNBHsV for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 23:21:22 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVwPu-0004m6-So
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVwPu-00014r-Rs
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/15] xfs: move di_changecount to VFS inode
Date: Wed, 17 Feb 2016 18:20:51 +1100
Message-Id: <1455693652-3899-15-git-send-email-david@fromorbit.com>
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

Source kernel commit 83e06f21b439b7b308eda06332a4feef35739e94

We can store the di_changecount in the i_version field of the VFS
inode and remove another 8 bytes from the xfs_icdinode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 include/xfs_inode.h    | 1 +
 libxfs/util.c          | 4 ++--
 libxfs/xfs_inode_buf.c | 4 ++--
 libxfs/xfs_inode_buf.h | 1 -
 repair/phase6.c        | 6 +++---
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index f7ad924..0290f97 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -36,6 +36,7 @@ struct xfs_dir_ops;
 struct inode {
 	uint32_t	i_nlink;
 	uint32_t	i_generation;
+	uint64_t	i_version;
 	struct timespec	i_atime;
 	struct timespec	i_mtime;
 	struct timespec	i_ctime;
diff --git a/libxfs/util.c b/libxfs/util.c
index 3263ae7..9c2f1d2 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -255,7 +255,7 @@ libxfs_ialloc(
 	if (ip->i_d.di_version == 3) {
 		ASSERT(ip->i_d.di_ino == ino);
 		ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid));
-		ip->i_d.di_changecount = 1;
+		VFS_I(ip)->i_version = 1;
 		ip->i_d.di_flags2 = 0;
 		ip->i_d.di_crtime.t_sec = (__int32_t)VFS_I(ip)->i_mtime.tv_sec;
 		ip->i_d.di_crtime.t_nsec = (__int32_t)VFS_I(ip)->i_mtime.tv_nsec;
@@ -431,7 +431,7 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
 
 	/* bump the change count on v3 inodes */
 	if (ip->i_d.di_version == 3)
-		ip->i_d.di_changecount++;
+		VFS_I(ip)->i_version++;
 
 	/*
 	 * Copy the dirty parts of the inode into the on-disk
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 224edd3..da9edcd 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -260,7 +260,7 @@ xfs_inode_from_disk(
 	to->di_flags	= be16_to_cpu(from->di_flags);
 
 	if (to->di_version == 3) {
-		to->di_changecount = be64_to_cpu(from->di_changecount);
+		inode->i_version = be64_to_cpu(from->di_changecount);
 		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = be32_to_cpu(from->di_crtime.t_nsec);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
@@ -309,7 +309,7 @@ xfs_inode_to_disk(
 	to->di_flags = cpu_to_be16(from->di_flags);
 
 	if (from->di_version == 3) {
-		to->di_changecount = cpu_to_be64(from->di_changecount);
+		to->di_changecount = cpu_to_be64(inode->i_version);
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 83ae8ed..ad98fdd 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -47,7 +47,6 @@ struct xfs_icdinode {
 	__uint16_t	di_dmstate;	/* DMIG state info */
 	__uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
 
-	__uint64_t	di_changecount;	/* number of attribute changes */
 	__uint64_t	di_flags2;	/* more random flags */
 
 	xfs_ictimestamp_t di_crtime;	/* time created */
diff --git a/repair/phase6.c b/repair/phase6.c
index 7e14346..7415199 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -519,7 +519,7 @@ mk_rbmino(xfs_mount_t *mp)
 
 	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
 	if (ip->i_d.di_version == 3) {
-		ip->i_d.di_changecount = 1;
+		VFS_I(ip)->i_version = 1;
 		ip->i_d.di_flags2 = 0;
 		times |= XFS_ICHGTIME_CREATE;
 	}
@@ -772,7 +772,7 @@ mk_rsumino(xfs_mount_t *mp)
 
 	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
 	if (ip->i_d.di_version == 3) {
-		ip->i_d.di_changecount = 1;
+		VFS_I(ip)->i_version = 1;
 		ip->i_d.di_flags2 = 0;
 		times |= XFS_ICHGTIME_CREATE;
 	}
@@ -881,7 +881,7 @@ mk_root_dir(xfs_mount_t *mp)
 
 	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
 	if (ip->i_d.di_version == 3) {
-		ip->i_d.di_changecount = 1;
+		VFS_I(ip)->i_version = 1;
 		ip->i_d.di_flags2 = 0;
 		times |= XFS_ICHGTIME_CREATE;
 	}
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
