Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18874 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757117AbcLCBf5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:35:57 -0500
Subject: [PATCH 06/55] xfs: don't allow di_size with high bit set
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:35:53 -0800
Message-ID: <148072895296.12995.4492298446043081028.stgit@birch.djwong.org>
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

The on-disk field di_size is used to set i_size, which is a signed
integer of loff_t.  If the high bit of di_size is set, we'll end up with
a negative i_size, which will cause all sorts of problems.  Since the
VFS won't let us create a file with such length, we should catch them
here in the verifier too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 54817f8..60e3e6f 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -392,6 +392,14 @@ xfs_dinode_verify(
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return false;
 
+	/* don't allow invalid i_size */
+	if (be64_to_cpu(dip->di_size) & (1ULL << 63))
+		return false;
+
+	/* No zero-length symlinks. */
+	if (S_ISLNK(be16_to_cpu(dip->di_mode)) && dip->di_size == 0)
+		return false;
+
 	/* only version 3 or greater inodes are extensively verified here */
 	if (dip->di_version < 3)
 		return true;

