Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1ECF729E1B
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:53 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 96D32AC004
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:30:52 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s0G0UrNr003628
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:53 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20140116000851.855051242@sgi.com>
Date: Wed, 15 Jan 2014 16:00:20 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [RFC 08/17] xfs: (parent ptr) add parent pointer support to
	xfs_symlink
References: <20140115220012.624438534@sgi.com>
Content-Disposition: inline; filename=08-pptr-add-to-xfs_symlink.patch
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

Add the parent inode / entry offset into the parent inode entries
when creating a new symbolic link. The first entry will always
go into the inode.

---
 fs/xfs/xfs_symlink.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: b/fs/xfs/xfs_symlink.c
===================================================================
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -36,6 +36,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
+#include "xfs_attr.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_symlink.h"
@@ -192,6 +193,7 @@ xfs_symlink(
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
 	uint			resblks;
+	uint			offset;
 
 	*ipp = NULL;
 
@@ -375,9 +377,15 @@ xfs_symlink(
 	 * Create the directory entry for the symlink.
 	 */
 	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino,
-				   &first_block, &free_list, resblks, NULL);
+				   &first_block, &free_list, resblks, &offset);
 	if (error)
 		goto error2;
+
+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
+		/* set the parent pointer and offset to the inode core fields */
+		ip->i_d.di_parent = cpu_to_be64(dp->i_ino);
+		ip->i_d.di_poffset = cpu_to_be32(offset);
+	}
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
