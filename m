Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52002 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750926AbdBBH5F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 02:57:05 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/19] xfs: fix xfs_mode_to_ftype() prototype
Date: Thu,  2 Feb 2017 08:56:05 +0100
Message-Id: <1486022171-8076-14-git-send-email-hch@lst.de>
In-Reply-To: <1486022171-8076-1-git-send-email-hch@lst.de>
References: <1486022171-8076-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>

From: Arnd Bergmann <arnd@arndb.de>

commit fd29f7af75b7adf250beccffa63746c6a88e2b74 upstream.

A harmless warning just got introduced:

fs/xfs/libxfs/xfs_dir2.h:40:8: error: type qualifiers ignored on function return type [-Werror=ignored-qualifiers]

Removing the 'const' modifier avoids the warning and has no
other effect.

Fixes: 1fc4d33fed12 ("xfs: replace xfs_mode_to_ftype table with switch statement")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c | 2 +-
 fs/xfs/libxfs/xfs_dir2.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 1a978bd..7825d78 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -38,7 +38,7 @@ struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
 /*
  * Convert inode mode to directory entry filetype
  */
-const unsigned char xfs_mode_to_ftype(int mode)
+unsigned char xfs_mode_to_ftype(int mode)
 {
 	switch (mode & S_IFMT) {
 	case S_IFREG:
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 0051a34..ae0d55b 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -37,7 +37,7 @@ extern struct xfs_name	xfs_name_dotdot;
 /*
  * Convert inode mode to directory entry filetype
  */
-extern const unsigned char xfs_mode_to_ftype(int mode);
+extern unsigned char xfs_mode_to_ftype(int mode);
 
 /*
  * directory operations vector for encode/decode routines
-- 
2.1.4

