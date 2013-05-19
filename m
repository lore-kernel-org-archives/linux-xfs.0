Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1CC3C29E11
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 18:51:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0BF158F8035
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 16:51:47 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	pQymhit1AhvXA9AB for <xfs@oss.sgi.com>;
	Sun, 19 May 2013 16:51:46 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UeDOC-0006AA-O9
	for xfs@oss.sgi.com; Mon, 20 May 2013 09:51:44 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UeDO2-0003yd-Kp
	for xfs@oss.sgi.com; Mon, 20 May 2013 09:51:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/14] xfs: fix missing KM_NOFS tags to keep lockdep happy
Date: Mon, 20 May 2013 09:51:12 +1000
Message-Id: <1369007481-15185-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1369007481-15185-1-git-send-email-david@fromorbit.com>
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
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

There are several places where we use KM_SLEEP allocation contexts
and use the fact that there are called from transaction context to
add KM_NOFS where appropriate. Unfortunately, there are several
places where the code makes this assumption but can be called from
outside transaction context but with filesystem locks held. These
places need explicit KM_NOFS annotations to avoid lockdep
complaining about reclaim contexts.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c       |    2 +-
 fs/xfs/xfs_da_btree.c  |    6 ++++--
 fs/xfs/xfs_dir2_leaf.c |    2 +-
 fs/xfs/xfs_log_cil.c   |    2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 82b70bd..0d25542 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1649,7 +1649,7 @@ xfs_alloc_buftarg(
 {
 	xfs_buftarg_t		*btp;
 
-	btp = kmem_zalloc(sizeof(*btp), KM_SLEEP);
+	btp = kmem_zalloc(sizeof(*btp), KM_SLEEP | KM_NOFS);
 
 	btp->bt_mount = mp;
 	btp->bt_dev =  bdev->bd_dev;
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 9b26a99..41ea7e1 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -2464,7 +2464,8 @@ xfs_buf_map_from_irec(
 	ASSERT(nirecs >= 1);
 
 	if (nirecs > 1) {
-		map = kmem_zalloc(nirecs * sizeof(struct xfs_buf_map), KM_SLEEP);
+		map = kmem_zalloc(nirecs * sizeof(struct xfs_buf_map),
+				  KM_SLEEP | KM_NOFS);
 		if (!map)
 			return ENOMEM;
 		*mapp = map;
@@ -2520,7 +2521,8 @@ xfs_dabuf_map(
 		 * Optimize the one-block case.
 		 */
 		if (nfsb != 1)
-			irecs = kmem_zalloc(sizeof(irec) * nfsb, KM_SLEEP);
+			irecs = kmem_zalloc(sizeof(irec) * nfsb,
+					    KM_SLEEP | KM_NOFS);
 
 		nirecs = nfsb;
 		error = xfs_bmapi_read(dp, (xfs_fileoff_t)bno, nfsb, irecs,
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 721ba2f..da71a18 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -1336,7 +1336,7 @@ xfs_dir2_leaf_getdents(
 				     mp->m_sb.sb_blocksize);
 	map_info = kmem_zalloc(offsetof(struct xfs_dir2_leaf_map_info, map) +
 				(length * sizeof(struct xfs_bmbt_irec)),
-			       KM_SLEEP);
+			       KM_SLEEP | KM_NOFS);
 	map_info->map_size = length;
 
 	/*
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index e3d0b85..d0833b5 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -139,7 +139,7 @@ xlog_cil_prepare_log_vecs(
 
 		new_lv = kmem_zalloc(sizeof(*new_lv) +
 				niovecs * sizeof(struct xfs_log_iovec),
-				KM_SLEEP);
+				KM_SLEEP|KM_NOFS);
 
 		/* The allocated iovec region lies beyond the log vector. */
 		new_lv->lv_iovecp = (struct xfs_log_iovec *)&new_lv[1];
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
