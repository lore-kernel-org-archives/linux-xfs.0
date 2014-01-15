Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 711AA29E1D
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:53 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E8C5DAC006
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:30:52 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s0G0UsIE003636
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:54 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20140116000852.025916405@sgi.com>
Date: Wed, 15 Jan 2014 16:00:22 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [RFC 10/17] xfs: (parent ptr) add parent pointer support to xfs_remove
References: <20140115220012.624438534@sgi.com>
Content-Disposition: inline; filename=10-pptr-add-to_xfs_remove.patch
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

Remove the parent inode / offset entry when removing the
link. The entry could be in the inode core or an extended
attribute.

---
 fs/xfs/xfs_attr.c  |   16 ++++++++++------
 fs/xfs/xfs_inode.c |   36 ++++++++++++++++++++++++++++++++----
 2 files changed, 42 insertions(+), 10 deletions(-)

Index: b/fs/xfs/xfs_attr.c
===================================================================
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -466,7 +466,7 @@ xfs_attr_set(
  * Generic handler routine to remove a name from an attribute list.
  * Transitions attribute list from Btree to shortform as necessary.
  */
-STATIC int
+int
 xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 {
 	xfs_da_args_t	args;
@@ -594,16 +594,20 @@ xfs_attr_remove(
 	int		flags)
 {
 	int		error;
-	struct xfs_name	xname;
+	struct xfs_name	xname, *xnamep;
 
 	XFS_STATS_INC(xs_attr_remove);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return (EIO);
 
-	error = xfs_attr_name_to_xname(&xname, name);
-	if (error)
-		return error;
+	if ((flags & ATTR_PARENT) == 0) {
+		xnamep = &xname;
+		error = xfs_attr_name_to_xname(xnamep, name);
+		if (error)
+			return error;
+	} else
+		xnamep = (struct xfs_name *) name;
 
 	xfs_ilock(dp, XFS_ILOCK_SHARED);
 	if (!xfs_inode_hasattr(dp)) {
@@ -612,7 +616,7 @@ xfs_attr_remove(
 	}
 	xfs_iunlock(dp, XFS_ILOCK_SHARED);
 
-	return xfs_attr_remove_int(dp, &xname, flags);
+	return xfs_attr_remove_int(dp, xnamep, flags);
 }
 
 
Index: b/fs/xfs/xfs_inode.c
===================================================================
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2493,6 +2493,7 @@ xfs_remove(
 	int			link_zero;
 	uint			resblks;
 	uint			log_count;
+	uint			offset;
 
 	trace_xfs_remove(dp, name);
 
@@ -2585,13 +2586,24 @@ xfs_remove(
 	link_zero = (ip->i_d.di_nlink == 0);
 
 	xfs_bmap_init(&free_list, &first_block);
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
-				     &first_block, &free_list, resblks, NULL);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, &first_block,
+				   &free_list, resblks, &offset);
 	if (error) {
 		ASSERT(error != ENOENT);
 		goto out_bmap_cancel;
 	}
 
+	if (xfs_sb_version_hasparent(&mp->m_sb) &&
+	    atomic_read(&VFS_I(ip)->i_count) > 1 && !link_zero &&
+	    ip->i_d.di_parent == cpu_to_be64(dp->i_ino) &&
+	    ip->i_d.di_poffset == cpu_to_be32(offset)) {
+		/* Remove the incore parent information */
+		ip->i_d.di_parent = NULLFSINO;
+		ip->i_d.di_poffset = 0;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+		offset = 0;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
@@ -2608,6 +2620,22 @@ xfs_remove(
 	if (error)
 		goto std_return;
 
+	if (xfs_sb_version_hasparent(&mp->m_sb) &&
+	    atomic_read(&VFS_I(ip)->i_count) > 1 && !link_zero && offset) {
+		struct xfs_pattr	p_entry;
+		struct xfs_name		p_name;
+
+		xfs_parent_pname(dp->i_ino, offset, &p_entry, &p_name);
+		error = xfs_attr_remove(ip, (char *) &p_name, ATTR_PARENT);
+		if (error) {
+			xfs_notice(mp,
+				"%s: attr %llx/%x failed inode %llx %d\n",
+				__func__, dp->i_ino, offset,
+				 ip->i_ino, error);
+			if (error == ENOATTR)
+				error = 0;
+		}
+	}
 	/*
 	 * If we are using filestreams, kill the stream association.
 	 * If the file is still open it may get a new one but that
@@ -2617,7 +2645,7 @@ xfs_remove(
 	if (!is_dir && link_zero && xfs_inode_is_filestream(ip))
 		xfs_filestream_deassociate(ip);
 
-	return 0;
+	return error;
 
  out_bmap_cancel:
 	xfs_bmap_cancel(&free_list);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
