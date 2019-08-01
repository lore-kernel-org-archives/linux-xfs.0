Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43372 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfHABnN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 21:43:13 -0400
Subject: [PATCH 3/5] xfs/122: add the new v5 bulkstat/inumbers ioctl
 structures
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 31 Jul 2019 18:42:57 -0700
Message-ID: <156462377790.2945299.5915136628365061851.stgit@magnolia>
In-Reply-To: <156462375516.2945299.16564635037236083118.stgit@magnolia>
References: <156462375516.2945299.16564635037236083118.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The new v5 bulkstat and inumbers structures are correctly padded so that
no format changes are necessary across platforms, so add them to the
output.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122.out |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index cf9ac9e2..d2d5a184 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -66,6 +66,9 @@ sizeof(struct xfs_btree_block_lhdr) = 64
 sizeof(struct xfs_btree_block_shdr) = 48
 sizeof(struct xfs_bud_log_format) = 16
 sizeof(struct xfs_bui_log_format) = 16
+sizeof(struct xfs_bulk_ireq) = 64
+sizeof(struct xfs_bulkstat) = 192
+sizeof(struct xfs_bulkstat_req) = 64
 sizeof(struct xfs_clone_args) = 32
 sizeof(struct xfs_cud_log_format) = 16
 sizeof(struct xfs_cui_log_format) = 16
@@ -89,6 +92,8 @@ sizeof(struct xfs_fsop_geom_v4) = 112
 sizeof(struct xfs_icreate_log) = 28
 sizeof(struct xfs_inode_log_format) = 56
 sizeof(struct xfs_inode_log_format_32) = 52
+sizeof(struct xfs_inumbers) = 24
+sizeof(struct xfs_inumbers_req) = 64
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_map_extent) = 32
 sizeof(struct xfs_phys_extent) = 16
