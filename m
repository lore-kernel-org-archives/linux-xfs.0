Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 911387F5E
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2014 22:20:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7FE69304048
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2014 20:20:24 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	dIwKTPnzHuuZ4zEZ for <xfs@oss.sgi.com>;
	Sun, 03 Aug 2014 20:20:19 -0700 (PDT)
Date: Mon, 4 Aug 2014 13:20:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6 V2] xfs: kill VN_DIRTY()
Message-ID: <20140804032016.GW20518@dastard>
References: <1406791995-14723-1-git-send-email-david@fromorbit.com>
	<1406791995-14723-4-git-send-email-david@fromorbit.com>
	<20140731171302.GA22173@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140731171302.GA22173@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Only one user and the use of a dirty page cache check is redundant,
so just get rid of it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_inode.c | 2 +-
 fs/xfs/xfs_vnode.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1a5e068..fea3c92 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1635,7 +1635,7 @@ xfs_release(
 		truncated = xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED);
 		if (truncated) {
 			xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
-			if (VN_DIRTY(VFS_I(ip)) && ip->i_delayed_blks > 0) {
+			if (ip->i_delayed_blks > 0) {
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
