Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58576 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfFDVRD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:17:03 -0400
Subject: [PATCH 2/3] xfs/122: add new ioctl structures
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 04 Jun 2019 14:16:55 -0700
Message-ID: <155968301540.1646947.7830716613133171656.stgit@magnolia>
In-Reply-To: <155968300283.1646947.2586545304045786757.stgit@magnolia>
References: <155968300283.1646947.2586545304045786757.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add some new ioctls that are being introduced in 5.2.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122.out |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 92fb46ae..cf9ac9e2 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -57,6 +57,7 @@ offsetof(xfs_sb_t, sb_versionnum) = 100
 offsetof(xfs_sb_t, sb_width) = 188
 sizeof(struct xfs_acl) = 4
 sizeof(struct xfs_acl_entry) = 12
+sizeof(struct xfs_ag_geometry) = 128
 sizeof(struct xfs_attr3_leaf_hdr) = 80
 sizeof(struct xfs_attr3_leafblock) = 88
 sizeof(struct xfs_attr3_rmt_hdr) = 56
@@ -82,6 +83,9 @@ sizeof(struct xfs_extent_data) = 24
 sizeof(struct xfs_extent_data_info) = 32
 sizeof(struct xfs_fs_eofblocks) = 128
 sizeof(struct xfs_fsop_ag_resblks) = 64
+sizeof(struct xfs_fsop_geom) = 256
+sizeof(struct xfs_fsop_geom_v1) = 112
+sizeof(struct xfs_fsop_geom_v4) = 112
 sizeof(struct xfs_icreate_log) = 28
 sizeof(struct xfs_inode_log_format) = 56
 sizeof(struct xfs_inode_log_format_32) = 52
