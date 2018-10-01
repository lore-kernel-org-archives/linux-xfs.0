Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47044 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbeJAXnS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 19:43:18 -0400
Subject: [PATCH 2/8] libxfs: fix libxfs_trans_alloc callsite problems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Oct 2018 10:04:30 -0700
Message-ID: <153841347016.27952.3018422758811687409.stgit@magnolia>
In-Reply-To: <153841345236.27952.5050172703525712660.stgit@magnolia>
References: <153841345236.27952.5050172703525712660.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix some incorrect libxfs_trans_alloc callers to check return values
correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/proto.c    |    4 +++-
 mkfs/xfs_mkfs.c |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index c13e3644..07d019d6 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -192,7 +192,9 @@ rsvfile(
 	/*
 	 * update the inode timestamp, mode, and prealloc flag bits
 	 */
-	libxfs_trans_alloc(mp, &tres, 0, 0, 0, &tp);
+	error = -libxfs_trans_alloc(mp, &tres, 0, 0, 0, &tp);
+	if (error)
+		fail(_("allocating transaction for a file"), error);
 	libxfs_trans_ijoin(tp, ip, 0);
 
 	VFS_I(ip)->i_mode &= ~S_ISUID;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2e53c1e8..c6ef3a71 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3677,7 +3677,7 @@ initialise_ag_freespace(
 	struct xfs_trans_res tres = {0};
 	int			c;
 
-	c = libxfs_trans_alloc(mp, &tres, worst_freelist, 0, 0, &tp);
+	c = -libxfs_trans_alloc(mp, &tres, worst_freelist, 0, 0, &tp);
 	if (c)
 		res_failed(c);
 
