Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46682 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751790AbcJYXFr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:05:47 -0400
Subject: [PATCH 20/39] xfs_io: provide long-format help for falloc
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:05:43 -0700
Message-ID: <147743674377.11035.8133878879225366578.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Provide long-format help for falloc so that xfstests can use
_require_xfs_io_command to check for falloc command line args.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/prealloc.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)


diff --git a/io/prealloc.c b/io/prealloc.c
index 713ea7b..7f5c200 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -164,6 +164,26 @@ zero_f(
 
 
 #if defined (HAVE_FALLOCATE)
+static void
+falloc_help(void)
+{
+	printf(_(
+"\n"
+" modifies space associated with part of a file via fallocate"
+"\n"
+" Example:\n"
+" 'falloc 0 1m' - fills all holes within the first megabyte\n"
+"\n"
+" falloc uses the fallocate system call to alter space allocations in the\n"
+" open file.  The following operations are supported:\n"
+" All the file offsets are in units of bytes.\n"
+" -c -- collapses the given range.\n"
+" -i -- inserts a hole into the given range of the file.\n"
+" -k -- do not change file size.\n"
+" -p -- unmap the given range from the file.\n"
+"\n"));
+}
+
 static int
 fallocate_f(
 	int		argc,
@@ -349,6 +369,7 @@ prealloc_init(void)
 	falloc_cmd.args = _("[-c] [-k] [-p] off len");
 	falloc_cmd.oneline =
 	_("allocates space associated with part of a file via fallocate");
+	falloc_cmd.help = falloc_help;
 	add_command(&falloc_cmd);
 
 	fpunch_cmd.name = "fpunch";

