Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5SM2p6X044268 for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 17:02:52 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201006282205.o5SM5Wps018169@stout.americas.sgi.com>
Date: Mon, 28 Jun 2010 17:05:32 -0500
Subject: [PATCH 07/15] xfs: rewrite XFS_SEND_MMAP() as a function
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

Re-implement XFS_SEND_MMAP() using a real (static inline) function.

The mount point passed in to XFS_SEND_MMAP() is always derived from
from the vma struct that is the subject of VM operation.  Get rid of
the mount point argument altogether, and compute what would have
been passed within the macro, making the first argument the vma
"target" of the event being signalled.

Finally, move the checks for whether an event is enabled into
the called function.


Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/xfs_dmapi.h |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

Index: b/fs/xfs/xfs_dmapi.h
===================================================================
--- a/fs/xfs/xfs_dmapi.h
+++ b/fs/xfs/xfs_dmapi.h
@@ -227,8 +227,24 @@ xfs_dmapi_send_data(
 	return send_data(event, ip, offset, length, flags, lock_flags);
 }
 
-#define XFS_SEND_MMAP(mp, vma,fl) \
-	(*(mp)->m_dm_ops->xfs_send_mmap)(vma,fl)
+static inline int
+xfs_dmapi_send_mmap(
+	struct vm_area_struct	*vma,
+	unsigned long		vm_flags)
+{
+	struct inode		*inode = vma->vm_file->f_path.dentry->d_inode;
+	struct xfs_mount	*mp = XFS_M(inode->i_sb);
+
+	if (mp->m_flags & XFS_MOUNT_DMAPI) {
+		xfs_send_mmap_t	send_mmap = mp->m_dm_ops->xfs_send_mmap;
+
+		return send_mmap(vma, vm_flags);
+	}
+	ASSERT_ALWAYS(vm_flags == VM_WRITE);
+
+	return 0;
+}
+
 #define XFS_SEND_DESTROY(mp, ip,right) \
 	(*(mp)->m_dm_ops->xfs_send_destroy)(ip,right)
 #define XFS_SEND_NAMESP(mp, ev,b1,r1,b2,r2,n1,n2,mode,rval,fl) \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
