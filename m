Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9A29E7F3F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 09:23:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88842304051
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 07:23:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id THbXxrIt918NPBs3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 07:23:11 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6OENATf027537
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:10 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s6OENAxD017009
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 11/18] xfs: reduce min. inode allocation space requirement for
	sparse inode chunks
Date: Thu, 24 Jul 2014 10:23:01 -0400
Message-Id: <1406211788-63206-12-git-send-email-bfoster@redhat.com>
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

xfs_ialloc_ag_select() iterates through the allocation groups looking
for free inodes or free space to determine whether to allow an inode
allocation to proceed. If no free inodes are available, it assumes that
an AG must have an extent longer than mp->m_ialloc_blks.

Sparse inode chunk support currently allows for allocations as small as
the cluster size. If sparse inodes are supported, use the cluster
alignment as a minimum extent size limit to determine whether an inode
chunk allocation attempt can proceed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 4dd45c2..4e98a21 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -770,9 +770,15 @@ xfs_ialloc_ag_select(
 
 		/*
 		 * Is there enough free space for the file plus a block of
-		 * inodes? (if we need to allocate some)?
+		 * inodes? (if we need to allocate some)? If sparse inode chunks
+		 * are supported, we only require an extent of length equal to
+		 * the cluster size.
 		 */
-		ineed = mp->m_ialloc_blks;
+		if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+			ineed = xfs_ialloc_cluster_alignment(mp);
+		else
+			ineed = mp->m_ialloc_blks;
+
 		longest = pag->pagf_longest;
 		if (!longest)
 			longest = pag->pagf_flcount > 0;
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
