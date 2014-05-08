Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3F78E7F5D
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 03:20:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1C991304059
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 01:20:00 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	A8FL65hkE3JGoFm5 for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 01:19:58 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WiJYV-0001j6-AV
	for xfs@oss.sgi.com; Thu, 08 May 2014 18:19:51 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WiJYV-0006wp-9X
	for xfs@oss.sgi.com; Thu, 08 May 2014 18:19:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/18] xfs: convert dir/attr btree threshold to xfs_da_geometry
Date: Thu,  8 May 2014 18:19:41 +1000
Message-Id: <1399537188-26509-12-git-send-email-david@fromorbit.com>
In-Reply-To: <1399537188-26509-1-git-send-email-david@fromorbit.com>
References: <1399537188-26509-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_leaf.c | 2 +-
 fs/xfs/xfs_dir2_node.c | 2 +-
 fs/xfs/xfs_mount.h     | 2 --
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index c662aaf..d1e800d 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -1948,7 +1948,7 @@ xfs_attr3_leaf_remove(
 	tmp = ichdr.usedbytes + xfs_attr3_leaf_hdr_size(leaf) +
 	      ichdr.count * sizeof(xfs_attr_leaf_entry_t);
 
-	return tmp < mp->m_attr_magicpct; /* leaf is < 37% full */
+	return tmp < args->geo->magicpct; /* leaf is < 37% full */
 }
 
 /*
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index ef34c19..de5b2996 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -1312,7 +1312,7 @@ xfs_dir2_leafn_remove(
 	 */
 	*rval = (dp->d_ops->leaf_hdr_size +
 		 (uint)sizeof(ents[0]) * (leafhdr.count - leafhdr.stale)) <
-		mp->m_dir_magicpct;
+		args->geo->magicpct;
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 4e3f6ce..78ae7e4 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -148,8 +148,6 @@ typedef struct xfs_mount {
 	int			m_dalign;	/* stripe unit */
 	int			m_swidth;	/* stripe width */
 	int			m_sinoalign;	/* stripe unit inode alignment */
-	int			m_attr_magicpct;/* 37% of the blocksize */
-	int			m_dir_magicpct;	/* 37% of the dir blocksize */
 	__uint8_t		m_sectbb_log;	/* sectlog - BBSHIFT */
 	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
 	const struct xfs_dir_ops *m_dir_inode_ops; /* vector of dir inode ops */
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
