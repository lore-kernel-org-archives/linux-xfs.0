Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 985B27F54
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 04:59:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 244FFAC002
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 02:59:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xEDfYqBP8rMAyrQd (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Sep 2015 02:59:41 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 74EBB40C4D
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 09:59:41 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 03/14] xfsprogs: avoid dependency on Linux XATTR_SIZE_MAX
Date: Tue, 15 Sep 2015 11:59:13 +0200
Message-Id: <1442311164-12921-4-git-send-email-jtulak@redhat.com>
In-Reply-To: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
References: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
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
Cc: Jan Tulak <jtulak@redhat.com>

Currently, we depends on Linux XATTR value for on disk
definitions. Which causes trouble on other platforms and
maybe also if this value was to change.

Fix it by creating a custom definition independent from
those in Linux (although with the same values), so it is OK
with the be16 fields used for holding these attributes.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 libxfs/xfs_attr_remote.c |  2 +-
 libxfs/xfs_format.h      | 10 +++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 3b3c24b..39ab350 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -102,7 +102,7 @@ xfs_attr3_rmt_verify(
 	if (be32_to_cpu(rmt->rm_bytes) > fsbsize - sizeof(*rmt))
 		return false;
 	if (be32_to_cpu(rmt->rm_offset) +
-				be32_to_cpu(rmt->rm_bytes) > XATTR_SIZE_MAX)
+				be32_to_cpu(rmt->rm_bytes) > XFS_XATTR_SIZE_MAX)
 		return false;
 	if (rmt->rm_owner == 0)
 		return false;
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 3c98635..946bcd1 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -60,6 +60,14 @@ struct xfs_ifork;
 #define	XFS_SB_VERSION_MOREBITSBIT	0x8000
 
 /*
+ * The size of a single extended attribute on disk is limited by
+ * the size of index values within the attribute entries themselves.
+ * These are be16 fields, so we can only support attribute data
+ * sizes up to 2^16 bytes in length.
+ */
+#define XFS_XATTR_SIZE_MAX (1 << 16)
+
+/*
  * Supported feature bit list is just all bits in the versionnum field because
  * we've used them all up and understand them all. Except, of course, for the
  * shared superblock bit, which nobody knows what it does and so is unsupported.
@@ -1483,7 +1491,7 @@ struct xfs_acl {
  */
 #define XFS_ACL_MAX_ENTRIES(mp)	\
 	(xfs_sb_version_hascrc(&mp->m_sb) \
-		?  (XATTR_SIZE_MAX - sizeof(struct xfs_acl)) / \
+		?  (XFS_XATTR_SIZE_MAX - sizeof(struct xfs_acl)) / \
 						sizeof(struct xfs_acl_entry) \
 		: 25)
 
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
