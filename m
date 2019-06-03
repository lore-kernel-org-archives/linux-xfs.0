Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48256 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfFCWvg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 18:51:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x53MmuJO162055
        for <linux-xfs@vger.kernel.org>; Mon, 3 Jun 2019 22:51:34 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2sugst9sf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 03 Jun 2019 22:51:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x53Moikh032476
        for <linux-xfs@vger.kernel.org>; Mon, 3 Jun 2019 22:51:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2sv36sfgsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 03 Jun 2019 22:51:33 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x53MpXD6023166
        for <linux-xfs@vger.kernel.org>; Mon, 3 Jun 2019 22:51:33 GMT
Subject: [PATCH 5/5] xfs: finish converting to inodes_per_cluster
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 03 Jun 2019 15:51:32 -0700
Message-ID: <155960229217.1194435.2177246831746410691.stgit@magnolia>
In-Reply-To: <155960225918.1194435.11314723160642989835.stgit@magnolia>
References: <155960225918.1194435.11314723160642989835.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Finish converting all the old inode_cluster_size >> inopblog users to
inodes_per_cluster.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    5 +----
 fs/xfs/xfs_inode.c            |    8 +++-----
 2 files changed, 4 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index c1293d170d98..fd7c02ee744b 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -33,12 +33,9 @@ xfs_inobp_check(
 	xfs_buf_t	*bp)
 {
 	int		i;
-	int		j;
 	xfs_dinode_t	*dip;
 
-	j = M_IGEO(mp)->inode_cluster_size >> mp->m_sb.sb_inodelog;
-
-	for (i = 0; i < j; i++) {
+	for (i = 0; i < M_IGEO(mp)->inodes_per_cluster; i++) {
 		dip = xfs_buf_offset(bp, i * mp->m_sb.sb_inodesize);
 		if (!dip->di_next_unlinked)  {
 			xfs_alert(mp,
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 65eace4b8723..48756e0219fa 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3473,7 +3473,6 @@ xfs_iflush_cluster(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
 	unsigned long		first_index, mask;
-	unsigned long		inodes_per_cluster;
 	int			cilist_size;
 	struct xfs_inode	**cilist;
 	struct xfs_inode	*cip;
@@ -3484,18 +3483,17 @@ xfs_iflush_cluster(
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 
-	inodes_per_cluster = igeo->inode_cluster_size >> mp->m_sb.sb_inodelog;
-	cilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);
+	cilist_size = igeo->inodes_per_cluster * sizeof(struct xfs_inode *);
 	cilist = kmem_alloc(cilist_size, KM_MAYFAIL|KM_NOFS);
 	if (!cilist)
 		goto out_put;
 
-	mask = ~(((igeo->inode_cluster_size >> mp->m_sb.sb_inodelog)) - 1);
+	mask = ~(igeo->inodes_per_cluster - 1);
 	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
 	rcu_read_lock();
 	/* really need a gang lookup range call here */
 	nr_found = radix_tree_gang_lookup(&pag->pag_ici_root, (void**)cilist,
-					first_index, inodes_per_cluster);
+					first_index, igeo->inodes_per_cluster);
 	if (nr_found == 0)
 		goto out_free;
 
