Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o736IZD9227980 for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 01:18:36 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B31441D6FCA6
	for <xfs@oss.sgi.com>; Mon,  2 Aug 2010 23:18:53 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	b3otcOfNeziUCa6V for <xfs@oss.sgi.com>;
	Mon, 02 Aug 2010 23:18:53 -0700 (PDT)
Received: from dastard (unverified [121.44.216.100])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	33894427-1927428
	for <xfs@oss.sgi.com>; Tue, 03 Aug 2010 15:48:52 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OgApu-000797-ND
	for xfs@oss.sgi.com; Tue, 03 Aug 2010 16:18:50 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OgApo-0007o4-Lh
	for xfs@oss.sgi.com; Tue, 03 Aug 2010 16:18:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfsprogs: Add support for XFS_IOC_ZERO_RANGE
Date: Tue,  3 Aug 2010 16:18:44 +1000
Message-Id: <1280816324-29984-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Add xfs_io support for XFS_IOC_ZERO_RANGE and document the ioctl
parameter in the xfsctl(3) man page.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_fs.h  |    1 +
 io/prealloc.c     |   29 +++++++++++++++++++++++++++++
 man/man3/xfsctl.3 |   18 ++++++++++++++++++
 3 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/include/xfs_fs.h b/include/xfs_fs.h
index 2376abb..74e7274 100644
--- a/include/xfs_fs.h
+++ b/include/xfs_fs.h
@@ -458,6 +458,7 @@ typedef struct xfs_handle {
 /*	XFS_IOC_SETBIOSIZE ---- deprecated 46	   */
 /*	XFS_IOC_GETBIOSIZE ---- deprecated 47	   */
 #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
+#define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/io/prealloc.c b/io/prealloc.c
index 5f6b029..c8b7df6 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -29,6 +29,7 @@ static cmdinfo_t allocsp_cmd;
 static cmdinfo_t freesp_cmd;
 static cmdinfo_t resvsp_cmd;
 static cmdinfo_t unresvsp_cmd;
+static cmdinfo_t zero_cmd;
 #if defined(HAVE_FALLOCATE)
 static cmdinfo_t falloc_cmd;
 #endif
@@ -125,6 +126,24 @@ unresvsp_f(
 	return 0;
 }
 
+static int
+zero_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_flock64_t	segment;
+
+	if (!offset_length(argv[1], argv[2], &segment))
+		return 0;
+
+	if (xfsctl(file->name, file->fd, XFS_IOC_ZERO_RANGE, &segment) < 0) {
+		perror("XFS_IOC_ZERO_RANGE");
+		return 0;
+	}
+	return 0;
+}
+
+
 #if defined (HAVE_FALLOCATE)
 static int
 fallocate_f(
@@ -196,10 +215,20 @@ prealloc_init(void)
 	unresvsp_cmd.oneline =
 		_("frees reserved space associated with part of a file");
 
+	zero_cmd.name = _("zero");
+	zero_cmd.cfunc = zero_f;
+	zero_cmd.argmin = 2;
+	zero_cmd.argmax = 2;
+	zero_cmd.flags = CMD_NOMAP_OK;
+	zero_cmd.args = _("off len");
+	zero_cmd.oneline =
+		_("Converts the given range of a file to allocated zeros");
+
 	add_command(&allocsp_cmd);
 	add_command(&freesp_cmd);
 	add_command(&resvsp_cmd);
 	add_command(&unresvsp_cmd);
+	add_command(&zero_cmd);
 
 #if defined (HAVE_FALLOCATE)
 	falloc_cmd.name = _("falloc");
diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 64e18df..784b3e0 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -338,6 +338,24 @@ in the final argument.
 Partial filesystem blocks are zeroed, and whole filesystem blocks are
 removed from the file.  The file size does not change.
 
+.TP
+.B XFS_IOC_ZERO_RANGE
+This command is used to convert a range of a file to zeros without issuing data
+IO.
+A range of bytes is specified using a pointer to a variable of type
+.B xfs_flock64_t
+in the final argument.
+Blocks are preallocated for regions that span holes in the file, and the entire
+range is converted to unwritten extents.
+This operation is a fast method of overwriting any from the range specified
+with zeros without removing any blocks or having to write zeros to disk.
+Any subsequent read in the given range will return zeros until new data is
+written.
+This functionality requires filesystems to support unwritten extents.
+If
+.BR xfs_info (8)
+reports unwritten=1, then the filesystem was made to flag unwritten extents.
+
 .\" .TP
 .\" .B XFS_IOC_GETBIOSIZE
 .\" This command gets information about the preferred buffered I/O
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
