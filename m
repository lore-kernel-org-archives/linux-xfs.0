Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BBDD97F50
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 12:13:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 74EA58F8040
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 10:13:48 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8QieEaJg4rwfaCdh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 10:13:47 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1JIDkPr017836
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 13:13:47 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1JIDj8u029970
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 13:13:46 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 05/18] xfs: use sparse chunk alignment for min. inode
	allocation requirement
Date: Thu, 19 Feb 2015 13:13:30 -0500
Message-Id: <1424369623-5656-6-git-send-email-bfoster@redhat.com>
In-Reply-To: <1424369623-5656-1-git-send-email-bfoster@redhat.com>
References: <1424369623-5656-1-git-send-email-bfoster@redhat.com>
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

xfs_ialloc_ag_select() iterates through the allocation groups looking
for free inodes or free space to determine whether to allow an inode
allocation to proceed. If no free inodes are available, it assumes that
an AG must have an extent longer than mp->m_ialloc_blks.

Sparse inode chunk support currently allows for allocations smaller than
the traditional inode chunk size specified in m_ialloc_blks. The current
minimum sparse allocation is set in the superblock sb_spino_align field
at mkfs time. Create a new m_ialloc_min_blks field in xfs_mount and use
this to represent the minimum supported allocation size for inode
chunks. Initialize m_ialloc_min_blks at mount time based on whether
sparse inodes are supported.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 2 +-
 fs/xfs/libxfs/xfs_sb.c     | 5 +++++
 fs/xfs/xfs_mount.h         | 2 ++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index ffac044..07cce35 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -644,7 +644,7 @@ xfs_ialloc_ag_select(
 		 * if we fail allocation due to alignment issues then it is most
 		 * likely a real ENOSPC condition.
 		 */
-		ineed = mp->m_ialloc_blks;
+		ineed = mp->m_ialloc_min_blks;
 		if (flags && ineed > 1)
 			ineed += xfs_ialloc_cluster_alignment(mp);
 		longest = pag->pagf_longest;
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a461c2e..2b5b4fe 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -697,6 +697,11 @@ xfs_sb_mount_common(
 	mp->m_ialloc_inos = (int)MAX((__uint16_t)XFS_INODES_PER_CHUNK,
 					sbp->sb_inopblock);
 	mp->m_ialloc_blks = mp->m_ialloc_inos >> sbp->sb_inopblog;
+
+	if (sbp->sb_spino_align)
+		mp->m_ialloc_min_blks = sbp->sb_spino_align;
+	else
+		mp->m_ialloc_min_blks = mp->m_ialloc_blks;
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 0d8abd6..cba7afb 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -136,6 +136,8 @@ typedef struct xfs_mount {
 	__uint64_t		m_flags;	/* global mount flags */
 	int			m_ialloc_inos;	/* inodes in inode allocation */
 	int			m_ialloc_blks;	/* blocks in inode allocation */
+	int			m_ialloc_min_blks;/* min blocks in sparse inode
+						   * allocation */
 	int			m_inoalign_mask;/* mask sb_inoalignmt if used */
 	uint			m_qflags;	/* quota status flags */
 	struct xfs_trans_resv	m_resv;		/* precomputed res values */
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
