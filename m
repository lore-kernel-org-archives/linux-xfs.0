Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CC7FC7EF3
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:28:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 65809AC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:28:21 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ZmGhYMn6FfPgzSU9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:28:20 -0700 (PDT)
Subject: [PATCH 096/119] xfs: support FS_XFLAG_REFLINK on reflink filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:28:10 -0700
Message-ID: <146612689065.12839.12038513561394516073.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

Add support for reporting the "reflink" inode flag in the XFS-specific
getxflags ioctl, and allow the user to clear the flag if file size is
zero.

v2: Move the reflink flag out of the way of the DAX flag, and add the
new cowextsize flag.

v3: do not report (or allow changes to) FL_NOCOW_FL, since we don't
support a flag to prevent CoWing and the reflink flag is a poor
proxy.  We'll try to design away the need for the NOCOW flag.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c   |    2 ++
 fs/xfs/xfs_ioctl.c   |    4 ++++
 fs/xfs/xfs_reflink.c |   26 ++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    4 ++++
 4 files changed, 36 insertions(+)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b8d3c4f..127bf54 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -652,6 +652,8 @@ _xfs_dic2xflags(
 	if (di_flags2 & XFS_DIFLAG2_ANY) {
 		if (di_flags2 & XFS_DIFLAG2_DAX)
 			flags |= FS_XFLAG_DAX;
+		if (di_flags2 & XFS_DIFLAG2_REFLINK)
+			flags |= FS_XFLAG_REFLINK;
 	}
 
 	if (has_attr)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0e06a82..b8eceee 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1258,6 +1258,10 @@ xfs_ioctl_setattr(
 
 	trace_xfs_ioctl_setattr(ip);
 
+	code = xfs_reflink_check_flag_adjust(ip, &fa->fsx_xflags);
+	if (code)
+		return code;
+
 	code = xfs_ioctl_setattr_check_projid(ip, fa);
 	if (code)
 		return code;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index b42ffb0..7c64104 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1782,3 +1782,29 @@ out_unlock:
 	trace_xfs_reflink_cow_eof_block_error(ip, error, _RET_IP_);
 	return error;
 }
+
+/*
+ * Ensure that the only change we allow to the inode reflink flag is to clear
+ * it when the fs supports reflink and the size is zero.
+ */
+int
+xfs_reflink_check_flag_adjust(
+	struct xfs_inode	*ip,
+	unsigned int		*xflags)
+{
+	unsigned int		chg;
+
+	chg = !!(*xflags & FS_XFLAG_REFLINK) ^ !!xfs_is_reflink_inode(ip);
+
+	if (!chg)
+		return 0;
+	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
+		return -EOPNOTSUPP;
+	if (i_size_read(VFS_I(ip)) != 0)
+		return -EINVAL;
+	if (*xflags & FS_XFLAG_REFLINK) {
+		*xflags &= ~FS_XFLAG_REFLINK;
+		return 0;
+	}
+	return 0;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 437087c5..97e8705 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -52,6 +52,10 @@ extern int xfs_reflink_unshare(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t len);
 extern int xfs_reflink_cow_eof_block(struct xfs_inode *ip, xfs_off_t newsize);
 
+extern void xfs_reflink_get_lxflags(struct xfs_inode *ip, unsigned int *flags);
+extern int xfs_reflink_check_flag_adjust(struct xfs_inode *ip,
+		unsigned int *xflags);
+
 /* xfs_aops.c */
 extern int xfs_map_cow_blocks(struct inode *inode, xfs_off_t offset,
 		struct xfs_bmbt_irec *imap);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
