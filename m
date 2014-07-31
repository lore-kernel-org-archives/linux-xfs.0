Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4465E7FA2
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 02:33:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 31D27304051
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 00:33:26 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	McKsAovI4sijCtvr for <xfs@oss.sgi.com>;
	Thu, 31 Jul 2014 00:33:24 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XCkrW-0005gV-Ru
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 17:33:18 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XCkrW-0003y7-Qi
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 17:33:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] xfs: kill VN_DIRTY()
Date: Thu, 31 Jul 2014 17:33:12 +1000
Message-Id: <1406791995-14723-4-git-send-email-david@fromorbit.com>
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

Only one user, so get rid of it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_inode.c | 4 +++-
 fs/xfs/xfs_vnode.h | 2 --
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1a5e068..c929217 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1635,7 +1635,9 @@ xfs_release(
 		truncated = xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED);
 		if (truncated) {
 			xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
-			if (VN_DIRTY(VFS_I(ip)) && ip->i_delayed_blks > 0) {
+			if (mapping_tagged(VFS_I(ip)->i_mapping,
+					   PAGECACHE_TAG_DIRTY) &&
+			    ip->i_delayed_blks > 0) {
 				error = filemap_flush(VFS_I(ip)->i_mapping);
 				if (error)
 					return error;
diff --git a/fs/xfs/xfs_vnode.h b/fs/xfs/xfs_vnode.h
index e8a7738..07b475a 100644
--- a/fs/xfs/xfs_vnode.h
+++ b/fs/xfs/xfs_vnode.h
@@ -39,8 +39,6 @@ struct attrlist_cursor_kern;
  */
 #define VN_MAPPED(vp)	mapping_mapped(vp->i_mapping)
 #define VN_CACHED(vp)	(vp->i_mapping->nrpages)
-#define VN_DIRTY(vp)	mapping_tagged(vp->i_mapping, \
-					PAGECACHE_TAG_DIRTY)
 
 
 #endif	/* __XFS_VNODE_H__ */
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
