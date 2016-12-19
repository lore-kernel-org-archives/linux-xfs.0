Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44608 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753160AbcLSWMy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2016 17:12:54 -0500
Date: Mon, 19 Dec 2016 14:12:47 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] docs: enumerate possible directory ftype values
Message-ID: <20161219221247.GB5487@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>

We don't actually list the ftype constants, so do that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../XFS_Filesystem_Structure/directories.asciidoc  |   29 ++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/design/XFS_Filesystem_Structure/directories.asciidoc b/design/XFS_Filesystem_Structure/directories.asciidoc
index 1758c4e..9bb50bd 100644
--- a/design/XFS_Filesystem_Structure/directories.asciidoc
+++ b/design/XFS_Filesystem_Structure/directories.asciidoc
@@ -26,6 +26,35 @@ directories.
 
 * An +offset+ or +tag+ used for iterative readdir calls.
 
+* If the +XFS_SB_FEAT_INCOMPAT_FTYPE+ feature flag is set, each
+directory entry contains an +ftype+ field that caches the inode's type
+to avoid having to perform an inode lookup.
+
+.ftype values
+[options="header"]
+|=====
+| Flag				| Description
+| +XFS_DIR3_FT_UNKNOWN+ |
+Entry points to an unknown inode type.  This should never appear on disk.
+| +XFS_DIR3_FT_REG_FILE+ |
+Entry points to a file.
+| +XFS_DIR3_FT_DIR+ |
+Entry points to another directory.
+| +XFS_DIR3_FT_CHRDEV+ |
+Entry points to a character device.
+| +XFS_DIR3_FT_BLKDEV+ |
+Entry points to a block device.
+| +XFS_DIR3_FT_FIFO+ |
+Entry points to a FIFO.
+| +XFS_DIR3_FT_SOCK+ |
+Entry points to a socket.
+| +XFS_DIR3_FT_SYMLINK+ |
+Entry points to a symbolic link.
+| +XFS_DIR3_FT_WHT+ |
+Entry points to an overlayfs whiteout file.  This (as far as the author
+knows) has never appeared on disk.
+|=====
+
 All non-shortform directories also contain two additional structures: ``leaves''
 and ``freespace indexes''.
 
