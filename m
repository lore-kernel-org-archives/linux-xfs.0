Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18942 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757117AbcLCBgk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:36:40 -0500
Subject: [PATCH 07/55] xfs: don't cap maximum dedupe request length
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:35:59 -0800
Message-ID: <148072895926.12995.14538759438520324262.stgit@birch.djwong.org>
In-Reply-To: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

After various discussions on linux-fsdevel, it has been decided that it
is not necessary to cap the length of a dedupe request, and that
correctly-written userspace client programs will be able to absorb the
change.  Therefore, remove the length clamping behavior.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c |    9 ---------
 1 file changed, 9 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f5effa6..b837ad8 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -883,7 +883,6 @@ xfs_file_clone_range(
 				     len, false);
 }
 
-#define XFS_MAX_DEDUPE_LEN	(16 * 1024 * 1024)
 STATIC ssize_t
 xfs_file_dedupe_range(
 	struct file	*src_file,
@@ -894,14 +893,6 @@ xfs_file_dedupe_range(
 {
 	int		error;
 
-	/*
-	 * Limit the total length we will dedupe for each operation.
-	 * This is intended to bound the total time spent in this
-	 * ioctl to something sane.
-	 */
-	if (len > XFS_MAX_DEDUPE_LEN)
-		len = XFS_MAX_DEDUPE_LEN;
-
 	error = xfs_reflink_remap_range(src_file, loff, dst_file, dst_loff,
 				     len, true);
 	if (error)

