Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4AB727F59
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:21:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0502B304032
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:21:26 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	tkTXrCmfidf6pq0D for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 23:21:24 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVwPu-0004m4-SN
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVwPu-00014m-R8
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/15] xfs: move inode generation count to VFS inode
Date: Wed, 17 Feb 2016 18:20:50 +1100
Message-Id: <1455693652-3899-14-git-send-email-david@fromorbit.com>
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

Source kernel commit 9e9a2674e43353f650ecd19a54eba028eafff82e

Pull another 4 bytes out of the xfs_icdinode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 include/xfs_inode.h    | 1 +
 libxfs/util.c          | 5 +----
 libxfs/xfs_inode_buf.c | 8 ++++----
 libxfs/xfs_inode_buf.h | 1 -
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index e7aa9e9..f7ad924 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -35,6 +35,7 @@ struct xfs_dir_ops;
  */
 struct inode {
 	uint32_t	i_nlink;
+	uint32_t	i_generation;
 	struct timespec	i_atime;
 	struct timespec	i_mtime;
 	struct timespec	i_ctime;
diff --git a/libxfs/util.c b/libxfs/util.c
index 9327a62..3263ae7 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -247,9 +247,6 @@ libxfs_ialloc(
 	ip->i_d.di_size = 0;
 	ip->i_d.di_nextents = 0;
 	ASSERT(ip->i_d.di_nblocks == 0);
-	/*
-	 * di_gen will have been taken care of in xfs_iread.
-	 */
 	ip->i_d.di_extsize = pip ? 0 : fsx->fsx_extsize;
 	ip->i_d.di_dmevmask = 0;
 	ip->i_d.di_dmstate = 0;
@@ -391,7 +388,7 @@ libxfs_iprint(
 	printf("   di_gid %d\n", dip->di_gid);
 	printf("   di_nextents %d\n", dip->di_nextents);
 	printf("   di_size %llu\n", (unsigned long long)dip->di_size);
-	printf("   di_gen %x\n", dip->di_gen);
+	printf("   di_gen %x\n", VFS_I(ip)->i_generation);
 	printf("   di_extsize %d\n", dip->di_extsize);
 	printf("   di_flags %x\n", dip->di_flags);
 	printf("   di_nblocks %llu\n", (unsigned long long)dip->di_nblocks);
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index dba8a4b..224edd3 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -246,6 +246,7 @@ xfs_inode_from_disk(
 	inode->i_mtime.tv_nsec = (int)be32_to_cpu(from->di_mtime.t_nsec);
 	inode->i_ctime.tv_sec = (int)be32_to_cpu(from->di_ctime.t_sec);
 	inode->i_ctime.tv_nsec = (int)be32_to_cpu(from->di_ctime.t_nsec);
+	inode->i_generation = be32_to_cpu(from->di_gen);
 
 	to->di_size = be64_to_cpu(from->di_size);
 	to->di_nblocks = be64_to_cpu(from->di_nblocks);
@@ -257,7 +258,6 @@ xfs_inode_from_disk(
 	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
 	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
 	to->di_flags	= be16_to_cpu(from->di_flags);
-	to->di_gen	= be32_to_cpu(from->di_gen);
 
 	if (to->di_version == 3) {
 		to->di_changecount = be64_to_cpu(from->di_changecount);
@@ -295,6 +295,7 @@ xfs_inode_to_disk(
 	to->di_ctime.t_sec = cpu_to_be32(inode->i_ctime.tv_sec);
 	to->di_ctime.t_nsec = cpu_to_be32(inode->i_ctime.tv_nsec);
 	to->di_nlink = cpu_to_be32(inode->i_nlink);
+	to->di_gen = cpu_to_be32(inode->i_generation);
 
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
@@ -306,7 +307,6 @@ xfs_inode_to_disk(
 	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
 	to->di_dmstate = cpu_to_be16(from->di_dmstate);
 	to->di_flags = cpu_to_be16(from->di_flags);
-	to->di_gen = cpu_to_be32(from->di_gen);
 
 	if (from->di_version == 3) {
 		to->di_changecount = cpu_to_be64(from->di_changecount);
@@ -452,7 +452,7 @@ xfs_iread(
 	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
 		/* initialise the on-disk inode core */
 		memset(&ip->i_d, 0, sizeof(ip->i_d));
-		ip->i_d.di_gen = prandom_u32();
+		VFS_I(ip)->i_generation = prandom_u32();
 		if (xfs_sb_version_hascrc(&mp->m_sb))
 			ip->i_d.di_version = 3;
 		else
@@ -500,7 +500,7 @@ xfs_iread(
 		 * that xfs_ialloc won't overwrite or relies on being correct.
 		 */
 		ip->i_d.di_version = dip->di_version;
-		ip->i_d.di_gen = be32_to_cpu(dip->di_gen);
+		VFS_I(ip)->i_generation = be32_to_cpu(dip->di_gen);
 		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
 
 		/*
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index ccc4052..83ae8ed 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -46,7 +46,6 @@ struct xfs_icdinode {
 	__uint32_t	di_dmevmask;	/* DMIG event mask */
 	__uint16_t	di_dmstate;	/* DMIG state info */
 	__uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
-	__uint32_t	di_gen;		/* generation number */
 
 	__uint64_t	di_changecount;	/* number of attribute changes */
 	__uint64_t	di_flags2;	/* more random flags */
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
