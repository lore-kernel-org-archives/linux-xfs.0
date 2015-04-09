Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 183387CBE
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 08:35:37 -0500 (CDT)
Received: from eagdhcp-232-149.americas.sgi.com
	(eagdhcp-232-149.americas.sgi.com [128.162.232.149])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DD0898F804C
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 06:35:36 -0700 (PDT)
Received: from eagdhcp-232-149.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-149.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	t39DZbsv002492
	for <xfs@oss.sgi.com>; Thu, 9 Apr 2015 08:35:37 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-149.americas.sgi.com)
Message-Id: <20150409133213.214186014@sgi.com>
Date: Thu, 09 Apr 2015 08:31:04 -0500
From: tinguely@sgi.com
Subject: [PATCH] libhandle: document the need for path_to_handle
References: <1504091316590.18609@sys953.ldn.framestore.com>
Content-Disposition: inline;
	filename=libhandle-doc-need-for-path_to_handle.patch
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The handle ioctls require an open file descriptor to
the XFS mount directory. This file descriptor is found
and supplied in the libhandle code by matching the
entry added with a path_to_handle() call. Document
the requirement and supply a simple example.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>

---
 man/man3/handle.3 |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 69 insertions(+), 1 deletion(-)

Index: b/man/man3/handle.3
===================================================================
--- a/man/man3/handle.3
+++ b/man/man3/handle.3
@@ -74,6 +74,12 @@ The
 function returns the handle for the filesystem in which the object given by the
 .I path
 argument resides.
+.I path
+must be the path to the mount point or
+.BR open_by_handle ()
+will return the
+.B ENOTDIR
+error.
 .PP
 The
 .BR fd_to_handle ()
@@ -95,7 +101,16 @@ The
 function opens a file descriptor for the object referenced by a handle.
 It is analogous and identical to
 .BR open (2)
-with the exception of accepting handles instead of path names.
+with the exception of accepting handles instead of path names. The returned
+file descriptor is opened to do invisible IO. Internally,
+.BR open_by_handle ()
+uses the mount point file descriptor that was saved by
+.BR path_to_fshandle ().
+Therefore,
+.BR path_to_fshandle ().
+must be called before calling
+.BR open_by_handle ().
+See below for an example.
 .PP
 The
 .BR readlink_by_handle ()
@@ -192,6 +207,59 @@ does not exist.
 .TP
 .B EPERM
 The caller does not have sufficient privileges.
+.SH EXAMPLE
+Example of
+.BR open_by_handle ().
+.PP
+.Vb 1
+\& main()
+.br
+\& {
+.br
+\&	int fd;
+.br
+\&	size_t hlen;
+.br
+\&	void *han;
+.br
+\&	size_t sz_int_used;
+.br
+\&	void *hdl_int_used;
+.br
+\&	char *mount_path = "/mnt/";
+.br
+\&	char *file = "file_to_open";
+.br
+\&	if (path_to_handle(file, &han, &hlen) < 0) {
+.br
+\&		perror("path-to-handle");
+.br
+\&		exit(1);
+.br
+\&	}
+.br
+\&	/*
+.br
+\&	 * path_to_fshandle saves an internal copy of the mount point's
+.br
+\&	 * (/mnt in this example) file descriptor. The open_by_handle call
+.br
+\&	 * looks up this internal file descriptor and uses it in the
+.br
+\&	 * xfsctl call to the kernel. Once path_to_fshandle is called,
+.br
+\&	 * this internal file descriptor remains open for the remaining
+.br
+\&	 * life of the application.
+.br
+\&	 */
+.br
+\&	path_to_fshandle(mount_path, &hdl_int_used, &sz_int_used);
+.br
+\&	fd = open_by_handle(han, hlen, O_RDWR);
+.br
+\&}
+.Ve
 .SH SEE ALSO
 .BR open (2),
 .BR readlink (2),


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
