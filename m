Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E01867F6D
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:42:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 754ECAC001
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:42:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id at3eXCd1GyhwlObW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:42:04 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 8AF5BB7CC7
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:42:04 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig4YZ019881
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 05/28] xfs: use sparse chunk alignment for min. inode
	allocation requirement
Date: Tue,  2 Jun 2015 14:41:38 -0400
Message-Id: <1433270521-62026-6-git-send-email-bfoster@redhat.com>
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
 include/xfs_mount.h | 2 ++
 libxfs/xfs_ialloc.c | 2 +-
 libxfs/xfs_sb.c     | 5 +++++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 70bdea0..998439e 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -73,6 +73,8 @@ typedef struct xfs_mount {
 	uint			m_attroffset;	/* inode attribute offset */
 	int			m_ialloc_inos;	/* inodes in inode allocation */
 	int			m_ialloc_blks;	/* blocks in inode allocation */
+	int			m_ialloc_min_blks;/* min blocks in sparse inode
+						   * allocation */
 	int			m_litino;	/* size of inode union area */
 	int			m_inoalign_mask;/* mask sb_inoalignmt if used */
 	struct xfs_trans_resv	m_resv;		/* precomputed res values */
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 673c0a7..1be6d27 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -640,7 +640,7 @@ xfs_ialloc_ag_select(
 		 * if we fail allocation due to alignment issues then it is most
 		 * likely a real ENOSPC condition.
 		 */
-		ineed = mp->m_ialloc_blks;
+		ineed = mp->m_ialloc_min_blks;
 		if (flags && ineed > 1)
 			ineed += xfs_ialloc_cluster_alignment(mp);
 		longest = pag->pagf_longest;
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index f34c676..fe16e8f 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -672,6 +672,11 @@ xfs_sb_mount_common(
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
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
