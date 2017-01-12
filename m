Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39743 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbdALDGp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 22:06:45 -0500
Subject: [PATCH 2/5] xfs_io: fix some documentation problems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Jan 2017 19:06:41 -0800
Message-ID: <148419040105.32674.7685382394930891385.stgit@birch.djwong.org>
In-Reply-To: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
References: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Describe the numberless (i.e. "reflink the whole file") behavior
in the xfs_io help system and since the clone/dedupe ioctls were
promoted to the VFS before XFS reflink landed, mention those in
the manpage.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/reflink.c      |    4 ++--
 man/man8/xfs_io.8 |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/io/reflink.c b/io/reflink.c
index d26cbdd..41cb884 100644
--- a/io/reflink.c
+++ b/io/reflink.c
@@ -306,9 +306,9 @@ reflink_init(void)
 	reflink_cmd.argmax = -1;
 	reflink_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	reflink_cmd.args =
-_("infile src_off dst_off len");
+_("infile [src_off dst_off len]");
 	reflink_cmd.oneline =
-		_("reflinks a number of bytes at a specified offset");
+		_("reflinks an entire file, or a number of bytes at a specified offset");
 	reflink_cmd.help = reflink_help;
 
 	add_command(&reflink_cmd);
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 885df7f..f1da472 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -530,7 +530,7 @@ both data and holes are displayed together or performing a recusively display.
 .TP
 .BI "reflink  [ \-C ] [ \-q ] src_file [src_offset dst_offset length]"
 On filesystems that support the
-.B XFS_IOC_CLONE_RANGE
+.B FICLONERANGE
 or
 .B BTRFS_IOC_CLONE_RANGE
 ioctls, map
@@ -560,7 +560,7 @@ Do not print timing statistics at all.
 .TP
 .BI "dedupe  [ \-C ] [ \-q ] src_file src_offset dst_offset length"
 On filesystems that support the
-.B XFS_IOC_FILE_EXTENT_SAME
+.B FIDEDUPERANGE
 or
 .B BTRFS_IOC_FILE_EXTENT_SAME
 ioctls, map

