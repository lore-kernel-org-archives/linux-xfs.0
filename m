Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819C6C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiLaAMQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235655AbiLaAMP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:12:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400AECE00
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:12:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9341361CE5
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE572C433EF;
        Sat, 31 Dec 2022 00:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445532;
        bh=7fp1bwsJ5DMIExHg+2ao4tL1B+EBVFR+AQUbYRcF5RU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EQp2Jyu/gE1M6Xo35zpOi1eD1lDA+n1ZqTFppYcnQasXvdeKSEe0Jdj5HdRqqXrhp
         iJGA7jjqnE1EblFa0p0FBmwgvAXC3KYP7N/h4i0RqkJBsP/sIDlEITEw3mBNsZdamD
         LOSjYZCzsfR6Zh8RiKeWCBYMoClQG3bNMLoIb2h4l8LGIsvG6+ZA2LegQQp2+roVRC
         BTwMBkiNmckfNbH5XJVHJnU5p5gznGodbSij9y89whLiztpgvt+2RWc6V2y7yMQGIl
         whh22dgUOYlhoGnMI9FavRy6k7NZt1jGqOa2d1SCLe8+MnojHTGDvwZrjFIh0izjZt
         JD6lU5hikeB7Q==
Subject: [PATCH 4/9] libxfs: support in-memory buffer cache targets
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:42 -0800
Message-ID: <167243866211.711834.5799622851053030124.stgit@magnolia>
In-Reply-To: <167243866153.711834.17585439086893346840.stgit@magnolia>
References: <167243866153.711834.17585439086893346840.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Allow the buffer cache to target in-memory files by connecting it to
xfiles.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_io.h |   14 +++++++++++++-
 libxfs/rdwr.c      |   47 +++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 56 insertions(+), 5 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 3fa9e75dcaa..c002ef058ec 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -24,7 +24,10 @@ struct xfs_buftarg {
 	struct xfs_mount	*bt_mount;
 	pthread_mutex_t		lock;
 	unsigned long		writes_left;
-	dev_t			bt_bdev;
+	union {
+		struct xfile	*bt_xfile;
+		dev_t		bt_bdev;
+	};
 	unsigned int		flags;
 	struct cache		*bcache;	/* global buffer cache */
 };
@@ -37,6 +40,15 @@ struct xfs_buftarg {
 #define XFS_BUFTARG_INJECT_WRITE_FAIL	(1 << 2)
 /* purge buffers when lookups find a size mismatch */
 #define XFS_BUFTARG_MISCOMPARE_PURGE	(1 << 3)
+/* use xfile for */
+#define XFS_BUFTARG_IN_MEMORY		(1 << 4)
+
+static inline bool
+xfs_buftarg_in_memory(
+	struct xfs_buftarg	*btp)
+{
+	return btp->flags & XFS_BUFTARG_IN_MEMORY;
+}
 
 /* Simulate the system crashing after a certain number of writes. */
 static inline void
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 5d63ec4f6de..9d36698bb5c 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -18,7 +18,7 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "libfrog/platform.h"
-
+#include "libxfs/xfile.h"
 #include "libxfs.h"
 
 static void libxfs_brelse(struct cache_node *node);
@@ -68,6 +68,9 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 	char		*z;
 	int		error, fd;
 
+	if (btp->flags & XFS_BUFTARG_IN_MEMORY)
+		return -EOPNOTSUPP;
+
 	fd = libxfs_device_to_fd(btp->bt_bdev);
 	start_offset = LIBXFS_BBTOOFF64(start);
 
@@ -578,6 +581,31 @@ libxfs_balloc(
 	return &bp->b_node;
 }
 
+static inline int
+libxfs_buf_ioapply_in_memory(
+	struct xfs_buf		*bp,
+	bool			is_write)
+{
+	struct xfile		*xfile = bp->b_target->bt_xfile;
+	loff_t			pos = BBTOB(xfs_buf_daddr(bp));
+	size_t			size = BBTOB(bp->b_length);
+	int			error;
+
+	if (bp->b_nmaps > 1) {
+		/* We don't need or support multi-map buffers. */
+		ASSERT(0);
+		error = -EIO;
+	} else if (is_write) {
+		error = xfile_obj_store(xfile, bp->b_addr, size, pos);
+	} else {
+		error = xfile_obj_load(xfile, bp->b_addr, size, pos);
+	}
+	if (error)
+		bp->b_error = error;
+	else if (!is_write)
+		bp->b_flags |= LIBXFS_B_UPTODATE;
+	return error;
+}
 
 static int
 __read_buf(int fd, void *buf, int len, off64_t offset, int flags)
@@ -602,12 +630,16 @@ int
 libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, struct xfs_buf *bp,
 		int len, int flags)
 {
-	int	fd = libxfs_device_to_fd(btp->bt_bdev);
+	int	fd;
 	int	bytes = BBTOB(len);
 	int	error;
 
 	ASSERT(len <= bp->b_length);
 
+	if (bp->b_target->flags & XFS_BUFTARG_IN_MEMORY)
+		return libxfs_buf_ioapply_in_memory(bp, false);
+
+	fd = libxfs_device_to_fd(btp->bt_bdev);
 	error = __read_buf(fd, bp->b_addr, bytes, LIBXFS_BBTOOFF64(blkno), flags);
 	if (!error &&
 	    bp->b_target->bt_bdev == btp->bt_bdev &&
@@ -640,6 +672,9 @@ libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
 	void	*buf;
 	int	i;
 
+	if (bp->b_target->flags & XFS_BUFTARG_IN_MEMORY)
+		return libxfs_buf_ioapply_in_memory(bp, false);
+
 	fd = libxfs_device_to_fd(btp->bt_bdev);
 	buf = bp->b_addr;
 	for (i = 0; i < bp->b_nmaps; i++) {
@@ -824,7 +859,7 @@ int
 libxfs_bwrite(
 	struct xfs_buf	*bp)
 {
-	int		fd = libxfs_device_to_fd(bp->b_target->bt_bdev);
+	int		fd;
 
 	/*
 	 * we never write buffers that are marked stale. This indicates they
@@ -859,7 +894,10 @@ libxfs_bwrite(
 		}
 	}
 
-	if (!(bp->b_flags & LIBXFS_B_DISCONTIG)) {
+	if (bp->b_target->flags & XFS_BUFTARG_IN_MEMORY) {
+		libxfs_buf_ioapply_in_memory(bp, true);
+	} else if (!(bp->b_flags & LIBXFS_B_DISCONTIG)) {
+		fd = libxfs_device_to_fd(bp->b_target->bt_bdev);
 		bp->b_error = __write_buf(fd, bp->b_addr, BBTOB(bp->b_length),
 				    LIBXFS_BBTOOFF64(xfs_buf_daddr(bp)),
 				    bp->b_flags);
@@ -867,6 +905,7 @@ libxfs_bwrite(
 		int	i;
 		void	*buf = bp->b_addr;
 
+		fd = libxfs_device_to_fd(bp->b_target->bt_bdev);
 		for (i = 0; i < bp->b_nmaps; i++) {
 			off64_t	offset = LIBXFS_BBTOOFF64(bp->b_maps[i].bm_bn);
 			int len = BBTOB(bp->b_maps[i].bm_len);

