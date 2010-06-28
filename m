Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5SM2vYh044289 for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 17:02:57 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201006282205.o5SM5g24018177@stout.americas.sgi.com>
Date: Mon, 28 Jun 2010 17:05:42 -0500
Subject: [PATCH 08/15] xfs: rewrite XFS_SEND_DESTROY() as a function
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Re-implement XFS_SEND_DESTROY() using a real (static inline)
function.

The mount point passed in to XFS_SEND_DESTROY() is always taken from
the i_mount field of the xfs_inode which is also provided.  Get rid
of the mount point argument altogether, and compute what would have
been passed within the macro.

Finally, move the test for whether the event is enabled into the
called function.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/xfs_dmapi.h    |   16 ++++++++++++++--
 fs/xfs/xfs_vnodeops.c |    5 ++---
 2 files changed, 16 insertions(+), 5 deletions(-)

Index: b/fs/xfs/xfs_dmapi.h
===================================================================
--- a/fs/xfs/xfs_dmapi.h
+++ b/fs/xfs/xfs_dmapi.h
@@ -245,8 +245,20 @@ xfs_dmapi_send_mmap(
 	return 0;
 }
 
-#define XFS_SEND_DESTROY(mp, ip,right) \
-	(*(mp)->m_dm_ops->xfs_send_destroy)(ip,right)
+static inline int
+xfs_dmapi_send_destroy(
+	struct xfs_inode	*ip,
+	dm_right_t		right)
+{
+	xfs_send_destroy_t	send_destroy;
+
+	if (!xfs_dmapi_event_enabled(ip, DM_EVENT_DESTROY))
+	    	return 0;
+	send_destroy = ip->i_mount->m_dm_ops->xfs_send_destroy;
+
+	return send_destroy(ip, right);
+}
+
 #define XFS_SEND_NAMESP(mp, ev,b1,r1,b2,r2,n1,n2,mode,rval,fl) \
 	(*(mp)->m_dm_ops->xfs_send_namesp)(ev,NULL,b1,r1,b2,r2,n1,n2,mode,rval,fl)
 
Index: b/fs/xfs/xfs_vnodeops.c
===================================================================
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1061,9 +1061,8 @@ xfs_inactive(
 
 	mp = ip->i_mount;
 
-	if (ip->i_d.di_nlink == 0 &&
-		    xfs_dmapi_event_enabled(ip, DM_EVENT_DESTROY))
-		XFS_SEND_DESTROY(mp, ip, DM_RIGHT_NULL);
+	if (ip->i_d.di_nlink == 0)
+		(void) xfs_dmapi_send_destroy(ip, DM_RIGHT_NULL);
 
 	error = 0;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
