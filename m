Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 May 2008 23:13:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4M6DHG7019490
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 23:13:18 -0700
Date: Thu, 22 May 2008 16:14:02 +1000
From: David Chinner <dgc@sgi.com>
Subject: [patch] remove xattr buffer size dependency on page size in xfsdump
Message-ID: <20080522061402.GS173056135@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


The extended attr buffer size used by xfsdump is based on page size.
The maximum buffer size the kernel will accept is 64k. On a 64k page
machine, the default buffer size will be rejected by the kernel, thereby
breaking dump and restore.

Limit the buffer size to XATTR_LIST_MAX in dump, restore and libhandle
so the kernel won't reject otherwise valid requests.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 xfsdump/dump/content.c      |    2 +-
 xfsprogs/libhandle/handle.c |    5 ++++-
 xfsprogs/libhandle/jdm.c    |    4 ++++
 3 files changed, 9 insertions(+), 2 deletions(-)

Index: xfs-cmds/xfsdump/dump/content.c
===================================================================
--- xfs-cmds.orig/xfsdump/dump/content.c	2007-02-03 01:26:21.000000000 +1100
+++ xfs-cmds/xfsdump/dump/content.c	2008-05-13 08:46:04.673298673 +1000
@@ -210,7 +210,7 @@ typedef struct extent_group_context exte
 
 /* minimum sizes for extended attributes buffers
  */
-#define EXTATTR_LISTBUF_SZ	( 4 * pgsz )
+#define EXTATTR_LISTBUF_SZ	( XATTR_LIST_MAX )
 #define EXTATTR_RTRVARRAY_LEN	( 1 * pgsz )
 #define EXTATTR_DUMPBUF_SZ	( 4 * pgsz )
 
Index: xfs-cmds/xfsprogs/libhandle/handle.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libhandle/handle.c	2006-11-15 19:00:31.000000000 +1100
+++ xfs-cmds/xfsprogs/libhandle/handle.c	2008-05-13 08:52:07.150983837 +1000
@@ -360,8 +360,11 @@ attr_list_by_handle(
 
 	memcpy(&alhreq.pos, cursor, sizeof(alhreq.pos));
 	alhreq.flags = flags;
-	alhreq.buflen = bufsize;
 	alhreq.buffer = buf;
+	alhreq.buflen = bufsize;
+	/* prevent needless EINVAL from the kernel */
+	if (alhreq.buflen > XATTR_LIST_MAX)
+		alhreq.buflen = XATTR_LIST_MAX;
 
 	error = xfsctl(path, fd, XFS_IOC_ATTRLIST_BY_HANDLE, &alhreq);
 
Index: xfs-cmds/xfsprogs/libhandle/jdm.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libhandle/jdm.c	2008-04-16 13:04:05.000000000 +1000
+++ xfs-cmds/xfsprogs/libhandle/jdm.c	2008-05-13 08:51:23.344565394 +1000
@@ -166,6 +166,10 @@ jdm_attr_list(	jdm_fshandle_t *fshp,
 	filehandle_t filehandle;
 	int rval;
 
+	/* prevent needless EINVAL from the kernel */
+	if (bufsz > XATTR_LIST_MAX)
+		bufsz = XATTR_LIST_MAX;
+
 	jdm_fill_filehandle( &filehandle, fshandlep, statp );
 	rval = attr_list_by_handle (( void * )&filehandle,
 			sizeof( filehandle ),
