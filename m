Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 182C47DDA
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:37:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B7D218F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:37:41 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id NkVcaAkDKKxpdKId (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:37:40 -0700 (PDT)
Subject: [PATCH 52/71] xfs: support FS_XFLAG_REFLINK on reflink filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:37:36 -0700
Message-ID: <147216825640.867.291198169154557243.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

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
 fs/xfs/xfs_ioctl.c   |    5 +++++
 fs/xfs/xfs_reflink.c |   26 ++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    4 ++++
 4 files changed, 37 insertions(+)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8c971fd..d6ec1ec 100644
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
index 96a70fd..97bb5b6 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -41,6 +41,7 @@
 #include "xfs_trans.h"
 #include "xfs_pnfs.h"
 #include "xfs_acl.h"
+#include "xfs_reflink.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
@@ -1261,6 +1262,10 @@ xfs_ioctl_setattr(
 
 	trace_xfs_ioctl_setattr(ip);
 
+	code = xfs_reflink_check_flag_adjust(ip, &fa->fsx_xflags);
+	if (code)
+		return code;
+
 	code = xfs_ioctl_setattr_check_projid(ip, fa);
 	if (code)
 		return code;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index c0034c1..368cc17 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1743,3 +1743,29 @@ out_unlock:
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
index 89fe0e3..89e1e62 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -53,4 +53,8 @@ extern int xfs_reflink_unshare(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t len);
 extern int xfs_reflink_cow_eof_block(struct xfs_inode *ip, xfs_off_t newsize);
 
+extern void xfs_reflink_get_lxflags(struct xfs_inode *ip, unsigned int *flags);
+extern int xfs_reflink_check_flag_adjust(struct xfs_inode *ip,
+		unsigned int *xflags);
+
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
