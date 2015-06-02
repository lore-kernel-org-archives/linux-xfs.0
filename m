Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E0F187F72
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:42:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D077B8F8049
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:42:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id A43yXmf3gS81Q73v (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:42:06 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 930A3B6E63
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:42:05 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig5f2010524
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 27/28] metadump: reorder inode record sanity checks and inode
	buffer read
Date: Tue,  2 Jun 2015 14:42:00 -0400
Message-Id: <1433270521-62026-28-git-send-email-bfoster@redhat.com>
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

In preparation to support sparse inode records, refactor
copy_inode_chunk() to perform all record sanity checks before the cursor
is set to the inode chunk and the inode buffer is read.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 db/metadump.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 94f92bc..e101501 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1846,21 +1846,10 @@ copy_inode_chunk(
 		return 1;
 	}
 
-	push_cur();
-	set_cur(&typtab[TYP_INODE], XFS_AGB_TO_DADDR(mp, agno, agbno),
-			XFS_FSB_TO_BB(mp, mp->m_ialloc_blks),
-			DB_RING_IGN, NULL);
-	if (iocur_top->data == NULL) {
-		print_warning("cannot read inode block %u/%u", agno, agbno);
-		rval = !stop_on_read_error;
-		goto pop_out;
-	}
-
 	/*
 	 * check for basic assumptions about inode chunks, and if any
 	 * assumptions fail, don't process the inode chunk.
 	 */
-
 	if ((mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK && off != 0) ||
 			(mp->m_sb.sb_inopblock > XFS_INODES_PER_CHUNK &&
 					off % XFS_INODES_PER_CHUNK != 0) ||
@@ -1870,7 +1859,17 @@ copy_inode_chunk(
 		if (show_warnings)
 			print_warning("badly aligned inode (start = %llu)",
 					XFS_AGINO_TO_INO(mp, agno, agino));
-		goto skip_processing;
+		return 1;
+	}
+
+	push_cur();
+	set_cur(&typtab[TYP_INODE], XFS_AGB_TO_DADDR(mp, agno, agbno),
+			XFS_FSB_TO_BB(mp, mp->m_ialloc_blks),
+			DB_RING_IGN, NULL);
+	if (iocur_top->data == NULL) {
+		print_warning("cannot read inode block %u/%u", agno, agbno);
+		rval = !stop_on_read_error;
+		goto pop_out;
 	}
 
 	/*
@@ -1889,7 +1888,7 @@ copy_inode_chunk(
 		if (!process_inode(agno, agino + i, dip))
 			goto pop_out;
 	}
-skip_processing:
+
 	if (write_buf(iocur_top))
 		goto pop_out;
 
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
