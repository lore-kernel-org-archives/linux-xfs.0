Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 29B5D81DE
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:51:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A135FAC001
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:51:03 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Al7r8FxDGrjlbUvH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:51:02 -0700 (PDT)
Subject: [PATCH 41/71] xfs: don't allow realtime and reflinked files to mix
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:50:57 -0700
Message-ID: <147216905751.4420.1257629723455686327.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
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

We don't support sharing blocks on the realtime device.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_inode_buf.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 8a804e2..2966d54 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -384,6 +384,9 @@ xfs_dinode_verify(
 	xfs_ino_t		ino,
 	struct xfs_dinode	*dip)
 {
+	uint16_t		flags;
+	uint64_t		flags2;
+
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return false;
 
@@ -400,6 +403,19 @@ xfs_dinode_verify(
 		return false;
 	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_meta_uuid))
 		return false;
+
+	flags = be16_to_cpu(dip->di_flags);
+	flags2 = be64_to_cpu(dip->di_flags2);
+
+	/* don't allow reflink/cowextsize if we don't have reflink */
+	if ((flags2 & (XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE)) &&
+            !xfs_sb_version_hasreflink(&mp->m_sb))
+		return false;
+
+	/* don't let reflink and realtime mix */
+	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
+		return false;
+
 	return true;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
