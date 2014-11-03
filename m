Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 517957F4E
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 10:35:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E437BAC006
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 08:35:48 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LveS8scFpaKKrAjn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Nov 2014 08:35:48 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sA3GZkae014509
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 3 Nov 2014 11:35:47 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sA3GCRlp028166
	for <xfs@oss.sgi.com>; Mon, 3 Nov 2014 11:12:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 02/17] xfs: use sparse chunk alignment for min. inode
	allocation requirement
Date: Mon,  3 Nov 2014 11:12:11 -0500
Message-Id: <1415031146-9107-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1415031146-9107-1-git-send-email-bfoster@redhat.com>
References: <1415031146-9107-1-git-send-email-bfoster@redhat.com>
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
minimum sparse allocation is set in the superblock sb_spinoalignmt field
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
index 23dcb72..89949a3 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -635,7 +635,7 @@ xfs_ialloc_ag_select(
 		 * Is there enough free space for the file plus a block of
 		 * inodes? (if we need to allocate some)?
 		 */
-		ineed = mp->m_ialloc_blks;
+		ineed = mp->m_ialloc_min_blks;
 		longest = pag->pagf_longest;
 		if (!longest)
 			longest = pag->pagf_flcount > 0;
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 6677180..0416ae9 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -756,6 +756,11 @@ xfs_sb_mount_common(
 	mp->m_ialloc_inos = (int)MAX((__uint16_t)XFS_INODES_PER_CHUNK,
 					sbp->sb_inopblock);
 	mp->m_ialloc_blks = mp->m_ialloc_inos >> sbp->sb_inopblog;
+
+	if (sbp->sb_spinoalignmt)
+		mp->m_ialloc_min_blks = sbp->sb_spinoalignmt;
+	else
+		mp->m_ialloc_min_blks = mp->m_ialloc_blks;
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b0447c8..42023a6 100644
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
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
