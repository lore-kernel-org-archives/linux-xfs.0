Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39074 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753958AbcKEAXW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:23:22 -0400
Subject: [PATCH 39/41] xfs: online repair of inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:23:17 -0700
Message-ID: <147830539728.2155.15604839816096522035.stgit@birch.djwong.org>
In-Reply-To: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
References: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Wire up the only online inode repair that we know how to do --
clearing the reflink flag when it's no longer needed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_scrub.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index d5f430e..6d3df68 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -5683,6 +5683,16 @@ xfs_scrub_inode(
 
 	return error;
 }
+
+/* Repair an inode's fields. */
+STATIC int
+xfs_repair_inode(
+	struct xfs_scrub_context	*sc)
+{
+	if (xfs_is_reflink_inode(sc->ip))
+		return xfs_reflink_clear_inode_flag(sc->ip, &sc->tp);
+	return 0;
+}
 #undef XFS_SCRUB_INODE_GOTO
 #undef XFS_SCRUB_INODE_CHECK
 
@@ -7106,7 +7116,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_ag_header, xfs_scrub_finobt, xfs_repair_iallocbt, xfs_sb_version_hasfinobt},
 	{xfs_scrub_setup_ag_header_freeze, xfs_scrub_rmapbt, xfs_repair_rmapbt, xfs_sb_version_hasrmapbt},
 	{xfs_scrub_setup_ag_header, xfs_scrub_refcountbt, xfs_repair_refcountbt, xfs_sb_version_hasreflink},
-	{xfs_scrub_setup_inode, xfs_scrub_inode, NULL, NULL},
+	{xfs_scrub_setup_inode, xfs_scrub_inode, xfs_repair_inode, NULL},
 	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_data, NULL, NULL},
 	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_attr, NULL, NULL},
 	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_cow, NULL, NULL},

