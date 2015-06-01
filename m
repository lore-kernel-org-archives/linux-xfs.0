Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E3CA17F5A
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 09:33:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C40288F8040
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 07:33:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mgZf4Lbo9bJt5TJz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Jun 2015 07:33:16 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 94A6BC9455
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 14:33:15 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t51EXFMw026741
	for <xfs@oss.sgi.com>; Mon, 1 Jun 2015 10:33:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/2] xfs: check min blks for random debug mode sparse
	allocations
Date: Mon,  1 Jun 2015 10:33:14 -0400
Message-Id: <1433169194-41808-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1433169194-41808-1-git-send-email-bfoster@redhat.com>
References: <1433169194-41808-1-git-send-email-bfoster@redhat.com>
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

The inode allocator enables random sparse inode chunk allocations in
DEBUG mode to facilitate testing. Sparse inode allocations are not
always possible, however, depending on the fs geometry. For example,
there is no possibility for a sparse inode allocation on filesystems
where the block size is large enough to fit one or more inode chunks
within a single block.

Fix up the DEBUG mode sparse inode allocation logic to trigger random
sparse allocations only when the geometry of the fs allows it.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index a18bc75..66efc70 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -606,20 +606,20 @@ xfs_ialloc_ag_alloc(
 	uint16_t	allocmask = (uint16_t) -1; /* init. to full chunk */
 	struct xfs_inobt_rec_incore rec;
 	struct xfs_perag *pag;
-
 	int		do_sparse = 0;
 
-#ifdef DEBUG
-	/* randomly do sparse inode allocations */
-	if (xfs_sb_version_hassparseinodes(&tp->t_mountp->m_sb))
-		do_sparse = prandom_u32() & 1;
-#endif
-
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = tp->t_mountp;
 	args.fsbno = NULLFSBLOCK;
 
+#ifdef DEBUG
+	/* randomly do sparse inode allocations */
+	if (xfs_sb_version_hassparseinodes(&tp->t_mountp->m_sb) &&
+	    args.mp->m_ialloc_min_blks < args.mp->m_ialloc_blks)
+		do_sparse = prandom_u32() & 1;
+#endif
+
 	/*
 	 * Locking will ensure that we don't have two callers in here
 	 * at one time.
@@ -768,6 +768,7 @@ sparse_alloc:
 			return error;
 
 		newlen = args.len << args.mp->m_sb.sb_inopblog;
+		ASSERT(newlen <= XFS_INODES_PER_CHUNK);
 		allocmask = (1 << (newlen / XFS_INODES_PER_HOLEMASK_BIT)) - 1;
 	}
 
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
