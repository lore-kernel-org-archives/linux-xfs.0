Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51492 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfGXENk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 00:13:40 -0400
Subject: [PATCH 3/4] xfs/122: add the new v5 bulkstat/inumbers ioctl
 structures
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Jul 2019 21:13:32 -0700
Message-ID: <156394161274.1850833.4300015313269610610.stgit@magnolia>
In-Reply-To: <156394159426.1850833.16316913520596851191.stgit@magnolia>
References: <156394159426.1850833.16316913520596851191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The new v5 bulkstat and inumbers structures are correctly padded so that
no format changes are necessary across platforms, so add them to the
output.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122.out |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index cf9ac9e2..e2f346eb 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -66,6 +66,10 @@ sizeof(struct xfs_btree_block_lhdr) = 64
 sizeof(struct xfs_btree_block_shdr) = 48
 sizeof(struct xfs_bud_log_format) = 16
 sizeof(struct xfs_bui_log_format) = 16
+sizeof(struct xfs_bulk_ireq) = 64
+sizeof(struct xfs_bulkstat) = 192
+sizeof(struct xfs_bulkstat_req) = 64
+sizeof(struct xfs_bulkstat_single_req) = 224
 sizeof(struct xfs_clone_args) = 32
 sizeof(struct xfs_cud_log_format) = 16
 sizeof(struct xfs_cui_log_format) = 16
@@ -89,6 +93,9 @@ sizeof(struct xfs_fsop_geom_v4) = 112
 sizeof(struct xfs_icreate_log) = 28
 sizeof(struct xfs_inode_log_format) = 56
 sizeof(struct xfs_inode_log_format_32) = 52
+sizeof(struct xfs_inumbers) = 24
+sizeof(struct xfs_inumbers_req) = 64
+sizeof(struct xfs_ireq) = 32
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_map_extent) = 32
 sizeof(struct xfs_phys_extent) = 16
