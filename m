Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0E4F07FBF
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:27:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E0C1F8F8064
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:27:03 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ewbNXFYNdEH5RodL for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:27:02 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkW8-0003w1-JG
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:56 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkVt-0001La-4r
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 28/48] libxfs: determine inode size from version number,
	not struct xfs_dinode
Date: Fri,  7 Jun 2013 10:25:51 +1000
Message-Id: <1370564771-4929-29-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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

xfs_db does not use the same structure types as libxfs when checking
inodes, and so cannot determine the size of the inode core by
passing a struct xfs_dinode to a function. We do, however, know the
raw version number, so we can pass that instead. Convert the code to
passing the inode version rather than a structure.

Note that this should probably be converted in the kernel code as
well.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_inode.h      |    4 ++--
 logprint/log_misc.c      |    2 +-
 logprint/log_print_all.c |    4 ++--
 repair/phase6.c          |    9 +++------
 4 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index cc14743..fdca7f7 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -169,9 +169,9 @@ typedef struct xfs_icdinode {
 	/* structure must be padded to 64 bit alignment */
 } xfs_icdinode_t;
 
-static inline uint xfs_icdinode_size(struct xfs_icdinode *dicp)
+static inline uint xfs_icdinode_size(int version)
 {
-	if (dicp->di_version == 3)
+	if (version == 3)
 		return sizeof(struct xfs_icdinode);
 	return offsetof(struct xfs_icdinode, di_next_unlinked);
 }
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index f368e5a..7012208 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -655,7 +655,7 @@ xlog_print_trans_inode(xfs_caddr_t *ptr,
     mode = dino.di_mode & S_IFMT;
     size = (int)dino.di_size;
     xlog_print_trans_inode_core(&dino);
-    *ptr += xfs_icdinode_size(&dino);
+    *ptr += xfs_icdinode_size(dino.di_version);
 
     if (*i == num_ops-1 && f->ilf_size == 3)  {
 	return 1;
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 70b0905..4626186 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -295,8 +295,8 @@ xlog_recover_print_inode(
 	       f->ilf_dsize);
 
 	/* core inode comes 2nd */
-	ASSERT(item->ri_buf[1].i_len == xfs_icdinode_size((xfs_icdinode_t *)
-							item->ri_buf[1].i_addr));
+	ASSERT(item->ri_buf[1].i_len == xfs_icdinode_size(1) ||
+		item->ri_buf[1].i_len == xfs_icdinode_size(3));
 	xlog_recover_print_inode_core((xfs_icdinode_t *)
 				      item->ri_buf[1].i_addr);
 
diff --git a/repair/phase6.c b/repair/phase6.c
index dc8145b..09052cc 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -446,8 +446,7 @@ mk_rbmino(xfs_mount_t *mp)
 	}
 
 	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 1;
-	ip->i_d.di_version = vers;
-	memset(&ip->i_d, 0, xfs_icdinode_size(&ip->i_d));
+	memset(&ip->i_d, 0, xfs_icdinode_size(vers));
 
 	ip->i_d.di_magic = XFS_DINODE_MAGIC;
 	ip->i_d.di_mode = S_IFREG;
@@ -696,8 +695,7 @@ mk_rsumino(xfs_mount_t *mp)
 	}
 
 	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 1;
-	ip->i_d.di_version = vers;
-	memset(&ip->i_d, 0, xfs_icdinode_size(&ip->i_d));
+	memset(&ip->i_d, 0, xfs_icdinode_size(vers));
 
 	ip->i_d.di_magic = XFS_DINODE_MAGIC;
 	ip->i_d.di_mode = S_IFREG;
@@ -813,8 +811,7 @@ mk_root_dir(xfs_mount_t *mp)
 	 * take care of the core -- initialization from xfs_ialloc()
 	 */
 	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 1;
-	ip->i_d.di_version = vers;
-	memset(&ip->i_d, 0, xfs_icdinode_size(&ip->i_d));
+	memset(&ip->i_d, 0, xfs_icdinode_size(vers));
 
 	ip->i_d.di_magic = XFS_DINODE_MAGIC;
 	ip->i_d.di_mode = (__uint16_t) mode|S_IFDIR;
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
