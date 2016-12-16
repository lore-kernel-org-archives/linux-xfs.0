Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:40571 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756654AbcLPCjf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 21:39:35 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id uBG0sl0a019251
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2016 00:54:48 GMT
Date: Thu, 15 Dec 2016 16:52:51 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 4/3] xfs_io: fix some documentation problems
Message-ID: <20161216005251.GE5357@birch.djwong.org>
References: <148182550558.24784.5628335536185073955.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148182550558.24784.5628335536185073955.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
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
index 7b15e89..d4c745c 100644
--- a/io/reflink.c
+++ b/io/reflink.c
@@ -307,9 +307,9 @@ reflink_init(void)
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
index f5e89ab..5cea992 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -577,7 +577,7 @@ both data and holes are displayed together or performing a recusively display.
 .TP
 .BI "reflink  [ \-C ] [ \-q ] src_file [src_offset dst_offset length]"
 On filesystems that support the
-.B XFS_IOC_CLONE_RANGE
+.B FICLONERANGE
 or
 .B BTRFS_IOC_CLONE_RANGE
 ioctls, map
@@ -607,7 +607,7 @@ Do not print timing statistics at all.
 .TP
 .BI "dedupe  [ \-C ] [ \-q ] src_file src_offset dst_offset length"
 On filesystems that support the
-.B XFS_IOC_FILE_EXTENT_SAME
+.B FIDEDUPERANGE
 or
 .B BTRFS_IOC_FILE_EXTENT_SAME
 ioctls, map
