Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 340A67CA2
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 21:27:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E7E51304039
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 19:27:58 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	qWeaGhvUPjZ5xAdp for <xfs@oss.sgi.com>;
	Thu, 01 Sep 2016 19:27:56 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] xfs: shadow agfl indexes in the per-ag structures
Date: Fri,  2 Sep 2016 12:27:33 +1000
Message-Id: <1472783257-15941-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1472783257-15941-1-git-send-email-david@fromorbit.com>
References: <1472783257-15941-1-git-send-email-david@fromorbit.com>
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
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

To verify that the AGFL contents is sane, we need to have access to
the indexes that tell us what part of the AGFL is active. We cannot
access the AGF buffer from the AGFL verifier, so we need to shadow
these values in the struct xfs_perag so we check them when required.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 4 ++++
 fs/xfs/xfs_mount.h        | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 23559b9..1aef556 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2255,6 +2255,7 @@ xfs_alloc_get_freelist(
 	be32_add_cpu(&agf->agf_flcount, -1);
 	xfs_trans_agflist_delta(tp, -1);
 	pag->pagf_flcount--;
+	pag->pagf_flfirst = be32_to_cpu(agf->agf_flfirst);
 	xfs_perag_put(pag);
 
 	logflags = XFS_AGF_FLFIRST | XFS_AGF_FLCOUNT;
@@ -2363,6 +2364,7 @@ xfs_alloc_put_freelist(
 	be32_add_cpu(&agf->agf_flcount, 1);
 	xfs_trans_agflist_delta(tp, 1);
 	pag->pagf_flcount++;
+	pag->pagf_fllast = be32_to_cpu(agf->agf_fllast);
 
 	logflags = XFS_AGF_FLLAST | XFS_AGF_FLCOUNT;
 	if (btreeblk) {
@@ -2547,6 +2549,8 @@ xfs_alloc_read_agf(
 		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
 		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
 		pag->pagf_flcount = be32_to_cpu(agf->agf_flcount);
+		pag->pagf_flfirst = be32_to_cpu(agf->agf_flfirst);
+		pag->pagf_fllast = be32_to_cpu(agf->agf_fllast);
 		pag->pagf_longest = be32_to_cpu(agf->agf_longest);
 		pag->pagf_levels[XFS_BTNUM_BNOi] =
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b36676c..3eb1b20 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -340,6 +340,8 @@ typedef struct xfs_perag {
 	__uint8_t	pagf_levels[XFS_BTNUM_AGF];
 					/* # of levels in bno & cnt btree */
 	__uint32_t	pagf_flcount;	/* count of blocks in freelist */
+	__uint32_t	pagf_flfirst;	/* first freelist block's index */
+	__uint32_t	pagf_fllast;	/* last freelist block's index */
 	xfs_extlen_t	pagf_freeblks;	/* total free blocks */
 	xfs_extlen_t	pagf_longest;	/* longest free space */
 	__uint32_t	pagf_btreeblks;	/* # of blocks held in AGF btrees */
-- 
2.8.0.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
