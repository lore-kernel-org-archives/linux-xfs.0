Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36743 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750935AbcKEAJX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:09:23 -0400
Subject: [PATCH 13/16] libxfs: synchronize dinode_verify with userspace
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:09:20 -0700
Message-ID: <147830456011.26713.11759326361226626805.stgit@birch.djwong.org>
In-Reply-To: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

The userspace version of _dinode_verify takes a raw inode number
instead of an inode itself.  Since neither version actually needs
the inode, port the changes to the kernel.  This will also reduce
the libxfs diff noise.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_inode_buf.c |    2 +-
 libxfs/xfs_inode_buf.h |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 8732359..3f2049b 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -378,7 +378,7 @@ xfs_log_dinode_to_disk(
 	}
 }
 
-bool
+static bool
 xfs_dinode_verify(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 99f1821..6848a0a 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -73,8 +73,6 @@ void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
 void	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
 			       struct xfs_dinode *to);
-bool	xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
-			  struct xfs_dinode *dip);
 
 bool	xfs_dinode_good_version(struct xfs_mount *mp, __u8 version);
 

