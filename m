Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Apr 2007 20:11:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3U3BifB006476
	for <xfs@oss.sgi.com>; Sun, 29 Apr 2007 20:11:47 -0700
Date: Mon, 30 Apr 2007 13:11:21 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] XFS ->fallocate() support
Message-ID: <20070430031121.GO32602149@melbourne.sgi.com>
References: <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070430004702.GM32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430004702.GM32602149@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

Add XFS support for ->fallocate() vector.

Signed-Off-By: Dave Chinner <dgc@sgi.com>

---
 fs/xfs/linux-2.6/xfs_iops.c |   48 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-02-07 13:24:32.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_iops.c	2007-04-30 11:02:16.225095992 +1000
@@ -812,6 +812,53 @@ xfs_vn_removexattr(
 	return namesp->attr_remove(vp, attr, xflags);
 }
 
+STATIC long
+xfs_vn_fallocate(
+	struct inode	*inode,
+	int		mode,
+	loff_t		offset,
+	loff_t		len)
+{
+	long		error = -EOPNOTSUPP;
+	bhv_vnode_t	*vp = vn_from_inode(inode);
+	bhv_desc_t	*bdp;
+	int		do_setattr = 0;
+	xfs_flock64_t	bf;
+
+	bf.l_whence = 0;
+	bf.l_start = offset;
+	bf.l_len = len;
+
+	bdp = bhv_lookup_range(VN_BHV_HEAD(vp), VNODE_POSITION_XFS,
+						VNODE_POSITION_XFS);
+
+	switch (mode) {
+	case FA_ALLOCATE: /* changes file size */
+		error = xfs_change_file_space(bdp, XFS_IOC_RESVSP,
+						&bf, 0, NULL, 0);
+		if (offset + len > i_size_read(inode))
+			do_setattr = offset + len;
+		break;
+	case FA_DEALLOCATE:
+		/* XXX: changes file size?  this just punches a hole */
+		error = xfs_change_file_space(bdp, XFS_IOC_UNRESVSP,
+						&bf, 0, NULL, 0);
+		break;
+	default:
+		break;
+	}
+
+	/* Change file size if needed */
+	if (!error && do_setattr) {
+		bhv_vattr_t	va;
+
+		va.va_mask = XFS_AT_SIZE;
+		va.va_size = do_setattr;
+		error = bhv_vop_setattr(vp, &va, 0, NULL);
+	}
+
+	return error;
+}
 
 struct inode_operations xfs_inode_operations = {
 	.permission		= xfs_vn_permission,
@@ -822,6 +869,7 @@ struct inode_operations xfs_inode_operat
 	.getxattr		= xfs_vn_getxattr,
 	.listxattr		= xfs_vn_listxattr,
 	.removexattr		= xfs_vn_removexattr,
+	.fallocate		= xfs_vn_fallocate,
 };
 
 struct inode_operations xfs_dir_inode_operations = {
