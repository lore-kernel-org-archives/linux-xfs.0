Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 712527F4E
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 01:04:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4E3908F8074
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 23:04:53 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	OQPEzFM0CqMID0BD for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 23:04:51 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WpWyk-0005op-4u
	for xfs@oss.sgi.com; Wed, 28 May 2014 16:04:46 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WpWyk-0003lo-3u
	for xfs@oss.sgi.com; Wed, 28 May 2014 16:04:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/16] xfs: convert dir/attr btree threshold to xfs_da_geometry
Date: Wed, 28 May 2014 16:04:37 +1000
Message-Id: <1401257083-13433-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1401257083-13433-1-git-send-email-david@fromorbit.com>
References: <1401257083-13433-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_attr_leaf.c | 2 +-
 fs/xfs/xfs_dir2.c      | 2 --
 fs/xfs/xfs_dir2_node.c | 2 +-
 fs/xfs/xfs_mount.h     | 2 --
 4 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 2c0fdc8..5be77b3 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -1949,7 +1949,7 @@ xfs_attr3_leaf_remove(
 	tmp = ichdr.usedbytes + xfs_attr3_leaf_hdr_size(leaf) +
 	      ichdr.count * sizeof(xfs_attr_leaf_entry_t);
 
-	return tmp < mp->m_attr_magicpct; /* leaf is < 37% full */
+	return tmp < args->geo->magicpct; /* leaf is < 37% full */
 }
 
 /*
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index 99df2a2..4eabe51 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -146,9 +146,7 @@ xfs_da_mount(
 
 	/* XXX: these are to be removed as code is converted to use geo */
 	mp->m_dir_node_ents = mp->m_dir_geo->node_ents;
-	mp->m_dir_magicpct = mp->m_dir_geo->magicpct;
 	mp->m_attr_node_ents = mp->m_attr_geo->node_ents;
-	mp->m_attr_magicpct = mp->m_attr_geo->magicpct;
 	return 0;
 }
 
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
