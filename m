Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A9F567FB2
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 03:20:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2AAA6AC007
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 01:20:05 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1HC0B4SMMz3Zt0WC for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 01:20:03 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WiJYV-0001jG-C6
	for xfs@oss.sgi.com; Thu, 08 May 2014 18:19:51 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WiJYV-0006x4-BI
	for xfs@oss.sgi.com; Thu, 08 May 2014 18:19:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/18] xfs: move node entry counts to xfs_da_geometry
Date: Thu,  8 May 2014 18:19:44 +1000
Message-Id: <1399537188-26509-15-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_attr.c      |  8 ++++----
 fs/xfs/xfs_da_btree.c  |  4 ++--
 fs/xfs/xfs_dir2_node.c | 10 +++++-----
 fs/xfs/xfs_mount.h     |  2 --
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 50159d3..28b6bb3 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -995,7 +995,7 @@ restart:
 	state->args = args;
 	state->mp = mp;
 	state->blocksize = state->mp->m_sb.sb_blocksize;
-	state->node_ents = state->mp->m_attr_node_ents;
+	state->node_ents = args->geo->node_ents;
 
 	/*
 	 * Search to see if name already exists, and get back a pointer
@@ -1174,7 +1174,7 @@ restart:
 		state->args = args;
 		state->mp = mp;
 		state->blocksize = state->mp->m_sb.sb_blocksize;
-		state->node_ents = state->mp->m_attr_node_ents;
+		state->node_ents = args->geo->node_ents;
 		state->inleaf = 0;
 		error = xfs_da3_node_lookup_int(state, &retval);
 		if (error)
@@ -1266,7 +1266,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	state->args = args;
 	state->mp = dp->i_mount;
 	state->blocksize = state->mp->m_sb.sb_blocksize;
-	state->node_ents = state->mp->m_attr_node_ents;
+	state->node_ents = args->geo->node_ents;
 
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
@@ -1529,7 +1529,7 @@ xfs_attr_node_get(xfs_da_args_t *args)
 	state->args = args;
 	state->mp = args->dp->i_mount;
 	state->blocksize = state->mp->m_sb.sb_blocksize;
-	state->node_ents = state->mp->m_attr_node_ents;
+	state->node_ents = args->geo->node_ents;
 
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index b9b007d..f935370 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -167,8 +167,8 @@ xfs_da3_node_verify(
 	 * we don't know if the node is for and attribute or directory tree,
 	 * so only fail if the count is outside both bounds
 	 */
-	if (ichdr.count > mp->m_dir_node_ents &&
-	    ichdr.count > mp->m_attr_node_ents)
+	if (ichdr.count > mp->m_dir_geo->node_ents &&
+	    ichdr.count > mp->m_attr_geo->node_ents)
 		return false;
 
 	/* XXX: hash order check? */
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index cd0bb58..65df8cb 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -1591,8 +1591,8 @@ xfs_dir2_node_addname(
 	state = xfs_da_state_alloc();
 	state->args = args;
 	state->mp = args->dp->i_mount;
-	state->blocksize = state->args->geo->blksize;
-	state->node_ents = state->mp->m_dir_node_ents;
+	state->blocksize = args->geo->blksize;
+	state->node_ents = args->geo->node_ents;
 	/*
 	 * Look up the name.  We're not supposed to find it, but
 	 * this gives us the insertion point.
@@ -2038,7 +2038,7 @@ xfs_dir2_node_lookup(
 	state->args = args;
 	state->mp = args->dp->i_mount;
 	state->blocksize = args->geo->blksize;
-	state->node_ents = state->mp->m_dir_node_ents;
+	state->node_ents = args->geo->node_ents;
 	/*
 	 * Fill in the path to the entry in the cursor.
 	 */
@@ -2093,7 +2093,7 @@ xfs_dir2_node_removename(
 	state->args = args;
 	state->mp = args->dp->i_mount;
 	state->blocksize = args->geo->blksize;
-	state->node_ents = state->mp->m_dir_node_ents;
+	state->node_ents = args->geo->node_ents;
 
 	/* Look up the entry we're deleting, set up the cursor. */
 	error = xfs_da3_node_lookup_int(state, &rval);
@@ -2163,7 +2163,7 @@ xfs_dir2_node_replace(
 	state->args = args;
 	state->mp = args->dp->i_mount;
 	state->blocksize = args->geo->blksize;
-	state->node_ents = state->mp->m_dir_node_ents;
+	state->node_ents = args->geo->node_ents;
 	inum = args->inumber;
 	/*
 	 * Lookup the entry to change in the btree.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 78ae7e4..7295a0b 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -134,8 +134,6 @@ typedef struct xfs_mount {
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
 	uint			m_dmevmask;	/* DMI events for this FS */
 	__uint64_t		m_flags;	/* global mount flags */
-	uint			m_dir_node_ents; /* #entries in a dir danode */
-	uint			m_attr_node_ents; /* #entries in attr danode */
 	int			m_ialloc_inos;	/* inodes in inode allocation */
 	int			m_ialloc_blks;	/* blocks in inode allocation */
 	int			m_inoalign_mask;/* mask sb_inoalignmt if used */
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
