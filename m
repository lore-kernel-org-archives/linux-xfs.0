Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A63E67F58
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 01:38:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5DF278F8049
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 23:38:05 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id U6By6GHDiEdR2FSl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 23:38:01 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rBC7bxCD025852
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:38:00 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBC7bxMV018209
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:37:59 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBC7bxCc023620 for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:37:59 GMT
Message-ID: <52A967D4.4080903@oracle.com>
Date: Thu, 12 Dec 2013 15:37:56 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 1/8] xfs: get rid of XFS_IALLOC_INODES macros
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

Get rid of XFS_IALLOC_INODES() marcos, use mp->m_ialloc_inos directly.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_ialloc.c      | 12 ++++++------
 fs/xfs/xfs_ialloc.h      |  1 -
 fs/xfs/xfs_log_recover.c |  4 ++--
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index e87719c..99e8b2c 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -225,7 +225,7 @@ xfs_ialloc_inode_init(
 		 * they track in the AIL as if they were physically logged.
 		 */
 		if (tp)
-			xfs_icreate_log(tp, agno, agbno, XFS_IALLOC_INODES(mp),
+			xfs_icreate_log(tp, agno, agbno, mp->m_ialloc_inos,
 					mp->m_sb.sb_inodesize, length, gen);
 	} else if (xfs_sb_version_hasnlink(&mp->m_sb))
 		version = 2;
@@ -329,7 +329,7 @@ xfs_ialloc_ag_alloc(
 	 * Locking will ensure that we don't have two callers in here
 	 * at one time.
 	 */
-	newlen = XFS_IALLOC_INODES(args.mp);
+	newlen = args.mp->m_ialloc_inos;
 	if (args.mp->m_maxicount &&
 	    args.mp->m_sb.sb_icount + newlen > args.mp->m_maxicount)
 		return XFS_ERROR(ENOSPC);
@@ -999,7 +999,7 @@ xfs_dialloc(
 	 * inode.
 	 */
 	if (mp->m_maxicount &&
-	    mp->m_sb.sb_icount + XFS_IALLOC_INODES(mp) > mp->m_maxicount) {
+	    mp->m_sb.sb_icount + mp->m_ialloc_inos > mp->m_maxicount) {
 		noroom = 1;
 		okalloc = 0;
 	}
@@ -1202,7 +1202,7 @@ xfs_difree(
 	 * When an inode cluster is free, it becomes eligible for removal
 	 */
 	if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
-	    (rec.ir_freecount == XFS_IALLOC_INODES(mp))) {
+	    (rec.ir_freecount == mp->m_ialloc_inos)) {
 
 		*delete = 1;
 		*first_ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino);
@@ -1212,7 +1212,7 @@ xfs_difree(
 		 * AGI and Superblock inode counts, and mark the disk space
 		 * to be freed when the transaction is committed.
 		 */
-		ilen = XFS_IALLOC_INODES(mp);
+		ilen = mp->m_ialloc_inos;
 		be32_add_cpu(&agi->agi_count, -ilen);
 		be32_add_cpu(&agi->agi_freecount, -(ilen - 1));
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
@@ -1311,7 +1311,7 @@ xfs_imap_lookup(
 
 	/* check that the returned record contains the required inode */
 	if (rec.ir_startino > agino ||
-	    rec.ir_startino + XFS_IALLOC_INODES(mp) <= agino)
+	    rec.ir_startino + mp->m_ialloc_inos <= agino)
 		return EINVAL;
 
 	/* for untrusted inodes check it is allocated first */
diff --git a/fs/xfs/xfs_ialloc.h b/fs/xfs/xfs_ialloc.h
index a8f76a5..4689b02 100644
--- a/fs/xfs/xfs_ialloc.h
+++ b/fs/xfs/xfs_ialloc.h
@@ -28,7 +28,6 @@ struct xfs_btree_cur;
 /*
  * Allocation parameters for inode allocation.
  */
-#define	XFS_IALLOC_INODES(mp)	(mp)->m_ialloc_inos
 #define	XFS_IALLOC_BLOCKS(mp)	(mp)->m_ialloc_blks
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 07ab52c..f76de2e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3208,9 +3208,9 @@ xlog_recover_do_icreate_pass2(
 	}
 
 	/* existing allocation is fixed value */
-	ASSERT(count == XFS_IALLOC_INODES(mp));
+	ASSERT(count == mp->m_ialloc_inos);
 	ASSERT(length == XFS_IALLOC_BLOCKS(mp));
-	if (count != XFS_IALLOC_INODES(mp) ||
+	if (count != mp->m_ialloc_inos ||
 	     length != XFS_IALLOC_BLOCKS(mp)) {
 		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad count 2");
 		return EINVAL;
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
