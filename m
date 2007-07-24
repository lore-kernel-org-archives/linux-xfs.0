Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Aug 2007 07:54:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l76EsIbm014916
	for <xfs@oss.sgi.com>; Mon, 6 Aug 2007 07:54:19 -0700
Message-Id: <200708061318.l76DIVoF001787@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Date: Tue, 24 Jul 2007 13:22:34 -0400
Subject: [PATCH 23/25] XFS: call attr_kill_to_mode from xfs_vn_setattr
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com

..and only save off ia_valid after it returns

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 0b5fa12..67fba53 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -651,12 +651,15 @@ xfs_vn_setattr(
 	struct iattr	*attr)
 {
 	struct inode	*inode = dentry->d_inode;
-	unsigned int	ia_valid = attr->ia_valid;
+	unsigned int	ia_valid;
 	bhv_vnode_t	*vp = vn_from_inode(inode);
 	bhv_vattr_t	vattr = { 0 };
 	int		flags = 0;
 	int		error;
 
+	attr_kill_to_mode(inode, attr);
+	ia_valid = attr->ia_valid;
+
 	if (ia_valid & ATTR_UID) {
 		vattr.va_mask |= XFS_AT_UID;
 		vattr.va_uid = attr->ia_uid;
-- 
1.5.2.2
