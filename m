Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ED69B7F67
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:42:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 97A69AC007
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:42:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wWmnxlvehHLBBf0x (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:42:06 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 8C7E52D1578
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:42:05 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig5EV019908
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 25/28] repair: do not prefetch holes in sparse inode chunks
Date: Tue,  2 Jun 2015 14:41:58 -0400
Message-Id: <1433270521-62026-26-git-send-email-bfoster@redhat.com>
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

The repair prefetch mechanism reads all inode chunks in advance of
repair processing to improve performance. Inode buffer verification and
processing can occur within the prefetch mechanism such as when
directories are being processed. Prefetch currently assumes fully
populated inode chunks which leads to corruption errors attempting to
verify inode buffers that do not contain inodes.

Update prefetch to check the previously scanned sparse inode bits and
skip inode buffer reads of clusters that are sparse. We check sparse
state per-inode cluster because the cluster size is the min. allowable
inode chunk hole granularity.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/prefetch.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/repair/prefetch.c b/repair/prefetch.c
index d6246ce..1577971 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -679,6 +679,7 @@ pf_queuing_worker(
 	xfs_agblock_t		bno;
 	int			i;
 	int			err;
+	uint64_t		sparse;
 
 	blks_per_cluster = mp->m_inode_cluster_size >> mp->m_sb.sb_blocklog;
 	if (blks_per_cluster == 0)
@@ -736,17 +737,27 @@ pf_queuing_worker(
 
 		num_inos = 0;
 		bno = XFS_AGINO_TO_AGBNO(mp, cur_irec->ino_startnum);
+		sparse = cur_irec->ir_sparse;
 
 		do {
 			struct xfs_buf_map	map;
 
 			map.bm_bn = XFS_AGB_TO_DADDR(mp, args->agno, bno);
 			map.bm_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
-			pf_queue_io(args, &map, 1,
-				    (cur_irec->ino_isa_dir != 0) ?  B_DIR_INODE
-								 : B_INODE);
+
+			/*
+			 * Queue I/O for each non-sparse cluster. We can check
+			 * sparse state in cluster sized chunks as cluster size
+			 * is the min. granularity of sparse irec regions.
+			 */
+			if ((sparse & ((1 << inodes_per_cluster) - 1)) == 0)
+				pf_queue_io(args, &map, 1,
+					    (cur_irec->ino_isa_dir != 0) ?
+					     B_DIR_INODE : B_INODE);
+
 			bno += blks_per_cluster;
 			num_inos += inodes_per_cluster;
+			sparse >>= inodes_per_cluster;
 		} while (num_inos < mp->m_ialloc_inos);
 	}
 
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
