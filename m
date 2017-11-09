Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21017 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755115AbdKIRfv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 12:35:51 -0500
Date: Thu, 9 Nov 2017 09:35:47 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 8/5] xfs: remove u_int* type usage
Message-ID: <20171109173547.GM26910@magnolia>
References: <151001660179.26786.15701876786383794673.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151001660179.26786.15701876786383794673.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the uint* types instead of the u_int* types.  This will (hopefully)
pair with an xfsprogs cleanup.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |    2 +-
 fs/xfs/xfs_attr_list.c     |    4 ++--
 fs/xfs/xfs_ioctl.c         |    4 ++--
 fs/xfs/xfs_ioctl.h         |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 2e047e7..1acb584 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1147,7 +1147,7 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  * Dquot and dquot block format definitions
  */
 #define XFS_DQUOT_MAGIC		0x4451		/* 'DQ' */
-#define XFS_DQUOT_VERSION	(u_int8_t)0x01	/* latest version number */
+#define XFS_DQUOT_VERSION	(uint8_t)0x01	/* latest version number */
 
 /*
  * This is the main portion of the on-disk representation of quota
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index a360310..3e59a34 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -546,8 +546,8 @@ xfs_attr_list_int(
 #define	ATTR_ENTBASESIZE		/* minimum bytes used by an attr */ \
 	(((struct attrlist_ent *) 0)->a_name - (char *) 0)
 #define	ATTR_ENTSIZE(namelen)		/* actual bytes used by an attr */ \
-	((ATTR_ENTBASESIZE + (namelen) + 1 + sizeof(u_int32_t)-1) \
-	 & ~(sizeof(u_int32_t)-1))
+	((ATTR_ENTBASESIZE + (namelen) + 1 + sizeof(uint32_t)-1) \
+	 & ~(sizeof(uint32_t)-1))
 
 /*
  * Format an attribute and copy it out to the user's buffer.
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 65a7951..20dc65f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -311,8 +311,8 @@ xfs_readlink_by_handle(
 int
 xfs_set_dmattrs(
 	xfs_inode_t     *ip,
-	u_int		evmask,
-	u_int16_t	state)
+	uint		evmask,
+	uint16_t	state)
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	xfs_trans_t	*tp;
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index e86c3ea..8de879f 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -86,7 +86,7 @@ xfs_file_compat_ioctl(
 extern int
 xfs_set_dmattrs(
 	struct xfs_inode	*ip,
-	u_int			evmask,
-	u_int16_t		state);
+	uint			evmask,
+	uint16_t		state);
 
 #endif
