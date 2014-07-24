Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 94DE37F47
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:04:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 41247AC006
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 08:04:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CkUvbBF72VNUAZs5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 08:04:21 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6OF4GrQ003624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 11:04:20 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s6OENAoC030181
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 06/18] xfs: pass inode count through ordered icreate log item
Date: Thu, 24 Jul 2014 10:22:56 -0400
Message-Id: <1406211788-63206-7-git-send-email-bfoster@redhat.com>
In-Reply-To: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
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

v5 superblocks use an ordered log item for logging the initialization of
inode chunks. The icreate log item is currently hardcoded to an inode
count of 64 inodes.

The agbno and extent length are used to initialize the inode chunk from
log recovery. While an incorrect inode count does not lead to bad inode
chunk initialization, we should pass the correct inode count such that log
recovery has enough data to perform meaningful validity checks on the
chunk.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 7 ++++---
 fs/xfs/libxfs/xfs_ialloc.h | 2 +-
 fs/xfs/xfs_log_recover.c   | 4 ++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 8286fda..27d3437 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -223,6 +223,7 @@ xfs_ialloc_inode_init(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	struct list_head	*buffer_list,
+	int			icount,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
 	xfs_agblock_t		length,
@@ -278,7 +279,7 @@ xfs_ialloc_inode_init(
 		 * they track in the AIL as if they were physically logged.
 		 */
 		if (tp)
-			xfs_icreate_log(tp, agno, agbno, mp->m_ialloc_inos,
+			xfs_icreate_log(tp, agno, agbno, icount,
 					mp->m_sb.sb_inodesize, length, gen);
 	} else
 		version = 2;
@@ -497,8 +498,8 @@ xfs_ialloc_ag_alloc(
 	 * rather than a linear progression to prevent the next generation
 	 * number from being easily guessable.
 	 */
-	error = xfs_ialloc_inode_init(args.mp, tp, NULL, agno, args.agbno,
-			args.len, prandom_u32());
+	error = xfs_ialloc_inode_init(args.mp, tp, NULL, newlen, agno,
+			args.agbno, args.len, prandom_u32());
 
 	if (error)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 95ad1c0..62c1381 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -156,7 +156,7 @@ int xfs_inobt_get_rec(struct xfs_btree_cur *cur,
  * Inode chunk initialisation routine
  */
 int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
-			  struct list_head *buffer_list,
+			  struct list_head *buffer_list, int icount,
 			  xfs_agnumber_t agno, xfs_agblock_t agbno,
 			  xfs_agblock_t length, unsigned int gen);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index fbc2362..cbe782a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3236,8 +3236,8 @@ xlog_recover_do_icreate_pass2(
 			XFS_AGB_TO_DADDR(mp, agno, agbno), length, 0))
 		return 0;
 
-	xfs_ialloc_inode_init(mp, NULL, buffer_list, agno, agbno, length,
-					be32_to_cpu(icl->icl_gen));
+	xfs_ialloc_inode_init(mp, NULL, buffer_list, count, agno, agbno, length,
+			      be32_to_cpu(icl->icl_gen));
 	return 0;
 }
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
