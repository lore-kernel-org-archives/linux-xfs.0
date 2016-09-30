Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30928 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755519AbcI3CXP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 22:23:15 -0400
Subject: [PATCH 1/9] xfs/122: decrease the log update done item sizes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 19:23:09 -0700
Message-ID: <147520218943.26891.3120182590574773598.stgit@birch.djwong.org>
In-Reply-To: <147520218309.26891.10856487889060965097.stgit@birch.djwong.org>
References: <147520218309.26891.10856487889060965097.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

Redundant fields were removed from the rmap/refcount/bmap update done
log items, so fix the size tests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 tests/xfs/122.out |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index ae84283..67f7698 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -64,10 +64,10 @@ sizeof(struct xfs_btree_block) = 72
 sizeof(struct xfs_btree_block_lhdr) = 64
 sizeof(struct xfs_btree_block_shdr) = 48
 sizeof(struct xfs_bud_log_format) = 16
-sizeof(struct xfs_bui_log_format) = 48
+sizeof(struct xfs_bui_log_format) = 16
 sizeof(struct xfs_clone_args) = 32
 sizeof(struct xfs_cud_log_format) = 16
-sizeof(struct xfs_cui_log_format) = 32
+sizeof(struct xfs_cui_log_format) = 16
 sizeof(struct xfs_da3_blkinfo) = 56
 sizeof(struct xfs_da3_intnode) = 64
 sizeof(struct xfs_da3_node_hdr) = 64
@@ -94,7 +94,7 @@ sizeof(struct xfs_rtrmap_key) = 24
 sizeof(struct xfs_rtrmap_rec) = 32
 sizeof(struct xfs_rtrmap_root) = 4
 sizeof(struct xfs_rud_log_format) = 16
-sizeof(struct xfs_rui_log_format) = 48
+sizeof(struct xfs_rui_log_format) = 16
 sizeof(struct xfs_scrub_metadata) = 64
 sizeof(xfs_agf_t) = 224
 sizeof(xfs_agfl_t) = 36

