Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6F51A7F7B
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 05:33:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 51E6D304043
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 03:33:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iKIcu7vat1gOkFLZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 03:33:20 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 02b/11] xfsprogs: avoid dependency on Linux XATTR_SIZE_MAX
Date: Thu,  3 Sep 2015 12:33:10 +0200
Message-Id: <1441276391-23587-2-git-send-email-jtulak@redhat.com>
In-Reply-To: <1441276391-23587-1-git-send-email-jtulak@redhat.com>
References: <1440655340-27550-1-git-send-email-jtulak@redhat.com>
	<1441276391-23587-1-git-send-email-jtulak@redhat.com>
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
Cc: hch@infradead.org, Jan Tulak <jtulak@redhat.com>

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
index 5feaf55..98893e2 100644
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
index bb7cc04..046b20f 100644
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
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
