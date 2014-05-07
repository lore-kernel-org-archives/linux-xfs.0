Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D65D97F53
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 07:22:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B57D68F8039
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 05:22:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ICtAJHbtuzD1C6sO for
	<xfs@oss.sgi.com>; Wed, 07 May 2014 05:22:02 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s47CM1V8005279
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Wed, 7 May 2014 08:22:01 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s47CM02g028667
	for <xfs@oss.sgi.com>; Wed, 7 May 2014 08:22:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 20/20] xfsprogs/db: add finobt support to metadump
Date: Wed,  7 May 2014 08:21:59 -0400
Message-Id: <1399465319-65066-21-git-send-email-bfoster@redhat.com>
In-Reply-To: <1399465319-65066-1-git-send-email-bfoster@redhat.com>
References: <1399465319-65066-1-git-send-email-bfoster@redhat.com>
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

Include the free inode btree in metadump images. If the source fs
is finobt-enabled, run an additional scan_btree() of the finobt.
Since the private 'agi' scanfunc_ino() parameter is unused, change
the private parameter to a flag that indicates whether the current
scan is for the inobt or finobt. If the latter, we skip copying the
actual inode chunks as this work is already performed by the inobt
scan.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 db/metadump.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/db/metadump.c b/db/metadump.c
index 09bb85a..38cd441 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1917,6 +1917,7 @@ scanfunc_ino(
 	xfs_inobt_ptr_t		*pp;
 	int			i;
 	int			numrecs;
+	int			finobt = *(int *) arg;
 
 	numrecs = be16_to_cpu(block->bb_numrecs);
 
@@ -1928,6 +1929,14 @@ scanfunc_ino(
 					typtab[btype].name, agno, agbno);
 			numrecs = mp->m_inobt_mxr[0];
 		}
+
+		/*
+		 * Only copy the btree blocks for the finobt. The inobt scan
+		 * copies the inode chunks.
+		 */
+		if (finobt)
+			return 1;
+
 		rp = XFS_INOBT_REC_ADDR(mp, block, 1);
 		for (i = 0; i < numrecs; i++, rp++) {
 			if (!copy_inode_chunk(agno, rp))
@@ -1967,6 +1976,7 @@ copy_inodes(
 {
 	xfs_agblock_t		root;
 	int			levels;
+	int			finobt = 0;
 
 	root = be32_to_cpu(agi->agi_root);
 	levels = be32_to_cpu(agi->agi_level);
@@ -1985,7 +1995,20 @@ copy_inodes(
 		return 1;
 	}
 
-	return scan_btree(agno, root, levels, TYP_INOBT, agi, scanfunc_ino);
+	if (!scan_btree(agno, root, levels, TYP_INOBT, &finobt, scanfunc_ino))
+		return 0;
+
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		root = be32_to_cpu(agi->agi_free_root);
+		levels = be32_to_cpu(agi->agi_free_level);
+
+		finobt = 1;
+		if (!scan_btree(agno, root, levels, TYP_INOBT, &finobt,
+				scanfunc_ino))
+			return 0;
+	}
+
+	return 1;
 }
 
 static int
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
