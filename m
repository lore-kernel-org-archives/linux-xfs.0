Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 75BB07F50
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 00:10:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 416688F8054
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 22:10:27 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	VjDMG9E28HAketNn for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2016 22:10:24 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aJb68-0002OY-OS
	for xfs@oss.sgi.com; Thu, 14 Jan 2016 17:09:28 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aJb68-0001VL-NX
	for xfs@oss.sgi.com; Thu, 14 Jan 2016 17:09:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/8] xfs: move di_changecount to VFS inode
Date: Thu, 14 Jan 2016 17:09:24 +1100
Message-Id: <1452751765-4420-8-git-send-email-david@fromorbit.com>
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

We can store the di_changecount in the i_version field of the VFS
inode and remove another 8 bytes from the xfs_icdinode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 4 ++--
 fs/xfs/libxfs/xfs_inode_buf.h | 1 -
 fs/xfs/xfs_inode.c            | 2 +-
 fs/xfs/xfs_inode_item.c       | 2 +-
 fs/xfs/xfs_trans_inode.c      | 2 +-
 5 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 0a3f10b..9807c21 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -251,7 +251,7 @@ xfs_inode_from_disk(
 	to->di_flags	= be16_to_cpu(from->di_flags);
 
 	if (to->di_version == 3) {
-		to->di_changecount = be64_to_cpu(from->di_changecount);
+		inode->i_version = be64_to_cpu(from->di_changecount);
 		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = be32_to_cpu(from->di_crtime.t_nsec);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
@@ -300,7 +300,7 @@ xfs_inode_to_disk(
 	to->di_flags = cpu_to_be16(from->di_flags);
 
 	if (from->di_version == 3) {
-		to->di_changecount = cpu_to_be64(from->di_changecount);
+		to->di_changecount = cpu_to_be64(inode->i_version);
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 68da576..e49c229 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -47,7 +47,6 @@ struct xfs_icdinode {
 	__uint16_t	di_dmstate;	/* DMIG state info */
 	__uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
 
-	__uint64_t	di_changecount;	/* number of attribute changes */
 	__uint64_t	di_flags2;	/* more random flags */
 
 	xfs_ictimestamp_t di_crtime;	/* time created */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 391d676..96aee23 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -832,7 +832,7 @@ xfs_ialloc(
 	ip->i_d.di_flags = 0;
 
 	if (ip->i_d.di_version == 3) {
-		ip->i_d.di_changecount = 1;
+		inode->i_version = 1;
 		ip->i_d.di_flags2 = 0;
 		ip->i_d.di_crtime.t_sec = (__int32_t)tv.tv_sec;
 		ip->i_d.di_crtime.t_nsec = (__int32_t)tv.tv_nsec;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 5cdf5ef..334d657 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -364,7 +364,7 @@ xfs_inode_to_log_dinode(
 	to->di_flags = from->di_flags;
 
 	if (from->di_version == 3) {
-		to->di_changecount = from->di_changecount;
+		to->di_changecount = inode->i_version;
 		to->di_crtime.t_sec = from->di_crtime.t_sec;
 		to->di_crtime.t_nsec = from->di_crtime.t_nsec;
 		to->di_flags2 = from->di_flags2;
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index 3f0d466..11a3af0 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -117,7 +117,7 @@ xfs_trans_log_inode(
 	 */
 	if (!(ip->i_itemp->ili_item.li_desc->lid_flags & XFS_LID_DIRTY) &&
 	    IS_I_VERSION(VFS_I(ip))) {
-		ip->i_d.di_changecount = ++VFS_I(ip)->i_version;
+		VFS_I(ip)->i_version++;
 		flags |= XFS_ILOG_CORE;
 	}
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
