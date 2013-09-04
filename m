Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 285D229E1D
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 17:21:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ECE93304048
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 15:21:30 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	A02zpVIg7OUJEBlB for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 15:21:29 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHLDB-0007dw-0I
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:05 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHLDA-0003vi-Hp
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 51/55] xfs: fix calculation of the number of node entries in a
	dir3 node
Date: Thu,  5 Sep 2013 08:05:55 +1000
Message-Id: <1378332359-14737-52-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-1-git-send-email-david@fromorbit.com>
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

The calculation doesn't take into account the size of the dir v3
header, so overestimates the hash entries in a node. This causes
directory buffer overruns when splitting and merging nodes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_da_btree.h | 11 +++++++++--
 libxfs/xfs_dir2.c      | 16 ++++++++++------
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/include/xfs_da_btree.h b/include/xfs_da_btree.h
index 8cdc77b..b1f2679 100644
--- a/include/xfs_da_btree.h
+++ b/include/xfs_da_btree.h
@@ -133,12 +133,19 @@ extern void xfs_da3_node_hdr_to_disk(struct xfs_da_intnode *to,
 				     struct xfs_da3_icnode_hdr *from);
 
 static inline int
-xfs_da3_node_hdr_size(struct xfs_da_intnode *dap)
+__xfs_da3_node_hdr_size(bool v3)
 {
-	if (dap->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC))
+	if (v3)
 		return sizeof(struct xfs_da3_node_hdr);
 	return sizeof(struct xfs_da_node_hdr);
 }
+static inline int
+xfs_da3_node_hdr_size(struct xfs_da_intnode *dap)
+{
+	bool	v3 = dap->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC);
+
+	return __xfs_da3_node_hdr_size(v3);
+}
 
 static inline struct xfs_da_node_entry *
 xfs_da3_node_tree_p(struct xfs_da_intnode *dap)
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 521042f..010c701 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -71,6 +71,9 @@ void
 xfs_dir_mount(
 	xfs_mount_t	*mp)
 {
+	int	nodehdr_size;
+
+
 	ASSERT(xfs_sb_version_hasdirv2(&mp->m_sb));
 	ASSERT((1 << (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog)) <=
 	       XFS_MAX_BLOCKSIZE);
@@ -79,12 +82,13 @@ xfs_dir_mount(
 	mp->m_dirdatablk = xfs_dir2_db_to_da(mp, XFS_DIR2_DATA_FIRSTDB(mp));
 	mp->m_dirleafblk = xfs_dir2_db_to_da(mp, XFS_DIR2_LEAF_FIRSTDB(mp));
 	mp->m_dirfreeblk = xfs_dir2_db_to_da(mp, XFS_DIR2_FREE_FIRSTDB(mp));
-	mp->m_attr_node_ents =
-		(mp->m_sb.sb_blocksize - (uint)sizeof(xfs_da_node_hdr_t)) /
-		(uint)sizeof(xfs_da_node_entry_t);
-	mp->m_dir_node_ents =
-		(mp->m_dirblksize - (uint)sizeof(xfs_da_node_hdr_t)) /
-		(uint)sizeof(xfs_da_node_entry_t);
+
+	nodehdr_size = __xfs_da3_node_hdr_size(xfs_sb_version_hascrc(&mp->m_sb));
+	mp->m_attr_node_ents = (mp->m_sb.sb_blocksize - nodehdr_size) /
+				(uint)sizeof(xfs_da_node_entry_t);
+	mp->m_dir_node_ents = (mp->m_dirblksize - nodehdr_size) /
+				(uint)sizeof(xfs_da_node_entry_t);
+
 	mp->m_dir_magicpct = (mp->m_dirblksize * 37) / 100;
 	if (xfs_sb_version_hasasciici(&mp->m_sb))
 		mp->m_dirnameops = &xfs_ascii_ci_nameops;
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
