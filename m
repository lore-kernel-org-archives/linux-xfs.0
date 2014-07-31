Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 36B037FAB
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 02:33:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 24548304051
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 00:33:24 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	IPd4a6wi0PRwchAJ for <xfs@oss.sgi.com>;
	Thu, 31 Jul 2014 00:33:23 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XCkrW-0005gX-Sz
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 17:33:18 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XCkrW-0003yH-Rx
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 17:33:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] xfs: kill VN_MAPPED
Date: Thu, 31 Jul 2014 17:33:14 +1000
Message-Id: <1406791995-14723-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1406791995-14723-1-git-send-email-david@fromorbit.com>
References: <1406791995-14723-1-git-send-email-david@fromorbit.com>
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

Only one user, no longer needed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_bmap_util.c | 2 +-
 fs/xfs/xfs_vnode.h     | 6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8da2a6a..bbc748a 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1713,7 +1713,7 @@ xfs_swap_extents(
 	 * vop_read (or write in the case of autogrow) they block on the iolock
 	 * until we have switched the extents.
 	 */
-	if (VN_MAPPED(VFS_I(ip))) {
+	if (mapping_mapped(VFS_I(ip)->i_mapping)) {
 		error = -EBUSY;
 		goto out_unlock;
 	}
diff --git a/fs/xfs/xfs_vnode.h b/fs/xfs/xfs_vnode.h
index bcf0c74..300725d 100644
--- a/fs/xfs/xfs_vnode.h
+++ b/fs/xfs/xfs_vnode.h
@@ -34,10 +34,4 @@ struct attrlist_cursor_kern;
 	{ IO_ISDIRECT,	"DIRECT" }, \
 	{ IO_INVIS,	"INVIS"}
 
-/*
- * Some useful predicates.
- */
-#define VN_MAPPED(vp)	mapping_mapped(vp->i_mapping)
-
-
 #endif	/* __XFS_VNODE_H__ */
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
