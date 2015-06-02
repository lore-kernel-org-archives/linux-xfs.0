Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 760717F6A
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:42:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 576FC304051
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:42:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VZNLlGSeT1yz93QJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:42:05 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id A321B2B9DF2
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:42:04 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig46X019605
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 09/28] xfs: pass inode count through ordered icreate log item
Date: Tue,  2 Jun 2015 14:41:42 -0400
Message-Id: <1433270521-62026-10-git-send-email-bfoster@redhat.com>
In-Reply-To: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
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
 libxfs/xfs_ialloc.c | 7 ++++---
 libxfs/xfs_ialloc.h | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 00de739..34f0290 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -245,6 +245,7 @@ xfs_ialloc_inode_init(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	struct list_head	*buffer_list,
+	int			icount,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
 	xfs_agblock_t		length,
@@ -300,7 +301,7 @@ xfs_ialloc_inode_init(
 		 * they track in the AIL as if they were physically logged.
 		 */
 		if (tp)
-			xfs_icreate_log(tp, agno, agbno, mp->m_ialloc_inos,
+			xfs_icreate_log(tp, agno, agbno, icount,
 					mp->m_sb.sb_inodesize, length, gen);
 	} else
 		version = 2;
@@ -520,8 +521,8 @@ xfs_ialloc_ag_alloc(
 	 * rather than a linear progression to prevent the next generation
 	 * number from being easily guessable.
 	 */
-	error = xfs_ialloc_inode_init(args.mp, tp, NULL, agno, args.agbno,
-			args.len, prandom_u32());
+	error = xfs_ialloc_inode_init(args.mp, tp, NULL, newlen, agno,
+			args.agbno, args.len, prandom_u32());
 
 	if (error)
 		return error;
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index 100007d..4d4b702 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
@@ -156,7 +156,7 @@ int xfs_inobt_get_rec(struct xfs_btree_cur *cur,
  * Inode chunk initialisation routine
  */
 int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
-			  struct list_head *buffer_list,
+			  struct list_head *buffer_list, int icount,
 			  xfs_agnumber_t agno, xfs_agblock_t agbno,
 			  xfs_agblock_t length, unsigned int gen);
 
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
