Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8AFB37F51
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 00:10:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1D55DAC003
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 22:10:23 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	AVrF98SkvWJjGrbD for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2016 22:10:20 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aJb68-0002OX-Nm
	for xfs@oss.sgi.com; Thu, 14 Jan 2016 17:09:28 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aJb68-0001VG-N8
	for xfs@oss.sgi.com; Thu, 14 Jan 2016 17:09:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/8] xfs: move inode generation count to VFS inode
Date: Thu, 14 Jan 2016 17:09:23 +1100
Message-Id: <1452751765-4420-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1452751765-4420-1-git-send-email-david@fromorbit.com>
References: <1452751765-4420-1-git-send-email-david@fromorbit.com>
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

Pull another 4 bytes out of the xfs_icdinode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 8 ++++----
 fs/xfs/libxfs/xfs_inode_buf.h | 1 -
 fs/xfs/xfs_export.c           | 2 +-
 fs/xfs/xfs_inode.c            | 5 +----
 fs/xfs/xfs_inode_item.c       | 2 +-
 fs/xfs/xfs_ioctl.c            | 2 +-
 fs/xfs/xfs_iops.c             | 1 -
 fs/xfs/xfs_itable.c           | 2 +-
 8 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 0dcaa9a..0a3f10b 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -237,6 +237,7 @@ xfs_inode_from_disk(
 	inode->i_mtime.tv_nsec = (int)be32_to_cpu(from->di_mtime.t_nsec);
 	inode->i_ctime.tv_sec = (int)be32_to_cpu(from->di_ctime.t_sec);
 	inode->i_ctime.tv_nsec = (int)be32_to_cpu(from->di_ctime.t_nsec);
+	inode->i_generation = be32_to_cpu(from->di_gen);
 
 	to->di_size = be64_to_cpu(from->di_size);
 	to->di_nblocks = be64_to_cpu(from->di_nblocks);
@@ -248,7 +249,6 @@ xfs_inode_from_disk(
 	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
 	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
 	to->di_flags	= be16_to_cpu(from->di_flags);
-	to->di_gen	= be32_to_cpu(from->di_gen);
 
 	if (to->di_version == 3) {
 		to->di_changecount = be64_to_cpu(from->di_changecount);
@@ -286,6 +286,7 @@ xfs_inode_to_disk(
 	to->di_ctime.t_sec = cpu_to_be32(inode->i_ctime.tv_sec);
 	to->di_ctime.t_nsec = cpu_to_be32(inode->i_ctime.tv_nsec);
 	to->di_nlink = cpu_to_be32(inode->i_nlink);
+	to->di_gen = cpu_to_be32(inode->i_generation);
 
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
@@ -297,7 +298,6 @@ xfs_inode_to_disk(
 	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
 	to->di_dmstate = cpu_to_be16(from->di_dmstate);
 	to->di_flags = cpu_to_be16(from->di_flags);
-	to->di_gen = cpu_to_be32(from->di_gen);
 
 	if (from->di_version == 3) {
 		to->di_changecount = cpu_to_be64(from->di_changecount);
@@ -443,7 +443,7 @@ xfs_iread(
 	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
 		/* initialise the on-disk inode core */
 		memset(&ip->i_d, 0, sizeof(ip->i_d));
-		ip->i_d.di_gen = prandom_u32();
+		VFS_I(ip)->i_generation = prandom_u32();
 		if (xfs_sb_version_hascrc(&mp->m_sb))
 			ip->i_d.di_version = 3;
 		else
@@ -491,7 +491,7 @@ xfs_iread(
 		 * that xfs_ialloc won't overwrite or relies on being correct.
 		 */
 		ip->i_d.di_version = dip->di_version;
-		ip->i_d.di_gen = be32_to_cpu(dip->di_gen);
+		VFS_I(ip)->i_generation = be32_to_cpu(dip->di_gen);
 		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
 
 		/*
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 774d71f..68da576 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -46,7 +46,6 @@ struct xfs_icdinode {
 	__uint32_t	di_dmevmask;	/* DMIG event mask */
 	__uint16_t	di_dmstate;	/* DMIG state info */
 	__uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
-	__uint32_t	di_gen;		/* generation number */
 
 	__uint64_t	di_changecount;	/* number of attribute changes */
 	__uint64_t	di_flags2;	/* more random flags */
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 652cd3c..2816d42 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -152,7 +152,7 @@ xfs_nfs_get_inode(
 		return ERR_PTR(error);
 	}
 
-	if (ip->i_d.di_gen != generation) {
+	if (VFS_I(ip)->i_generation != generation) {
 		IRELE(ip);
 		return ERR_PTR(-ESTALE);
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9ee766b..391d676 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -826,9 +826,6 @@ xfs_ialloc(
 	inode->i_atime = tv;
 	inode->i_ctime = tv;
 
-	/*
-	 * di_gen will have been taken care of in xfs_iread.
-	 */
 	ip->i_d.di_extsize = 0;
 	ip->i_d.di_dmevmask = 0;
 	ip->i_d.di_dmstate = 0;
@@ -2414,7 +2411,7 @@ xfs_ifree(
 	 * Bump the generation count so no one will be confused
 	 * by reincarnations of this inode.
 	 */
-	ip->i_d.di_gen++;
+	VFS_I(ip)->i_generation++;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	if (xic.deleted)
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 4e3611d..5cdf5ef 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -350,6 +350,7 @@ xfs_inode_to_log_dinode(
 	to->di_ctime.t_sec = inode->i_ctime.tv_sec;
 	to->di_ctime.t_nsec = inode->i_ctime.tv_nsec;
 	to->di_nlink = inode->i_nlink;
+	to->di_gen = inode->i_generation;
 
 	to->di_size = from->di_size;
 	to->di_nblocks = from->di_nblocks;
@@ -361,7 +362,6 @@ xfs_inode_to_log_dinode(
 	to->di_dmevmask = from->di_dmevmask;
 	to->di_dmstate = from->di_dmstate;
 	to->di_flags = from->di_flags;
-	to->di_gen = from->di_gen;
 
 	if (from->di_version == 3) {
 		to->di_changecount = from->di_changecount;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d42738d..2c40c5f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -114,7 +114,7 @@ xfs_find_handle(
 		handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
 					sizeof(handle.ha_fid.fid_len);
 		handle.ha_fid.fid_pad = 0;
-		handle.ha_fid.fid_gen = ip->i_d.di_gen;
+		handle.ha_fid.fid_gen = inode->i_generation;
 		handle.ha_fid.fid_ino = ip->i_ino;
 
 		hsize = XFS_HSIZE(handle);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index c424d4b..397ce85 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1227,7 +1227,6 @@ xfs_setup_inode(
 		break;
 	}
 
-	inode->i_generation = ip->i_d.di_gen;
 	i_size_write(inode, ip->i_d.di_size);
 	xfs_diflags_to_iflags(inode, ip);
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index cfb6527..6162e65 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -100,11 +100,11 @@ xfs_bulkstat_one_int(
 	buf->bs_mtime.tv_nsec = inode->i_mtime.tv_nsec;
 	buf->bs_ctime.tv_sec = inode->i_ctime.tv_sec;
 	buf->bs_ctime.tv_nsec = inode->i_ctime.tv_nsec;
+	buf->bs_gen = inode->i_generation;
 
 	buf->bs_xflags = xfs_ip2xflags(ip);
 	buf->bs_extsize = dic->di_extsize << mp->m_sb.sb_blocklog;
 	buf->bs_extents = dic->di_nextents;
-	buf->bs_gen = dic->di_gen;
 	memset(buf->bs_pad, 0, sizeof(buf->bs_pad));
 	buf->bs_dmevmask = dic->di_dmevmask;
 	buf->bs_dmstate = dic->di_dmstate;
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
