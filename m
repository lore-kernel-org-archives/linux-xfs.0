Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n07FeN76010793 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 09:40:34 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C30B830408B
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 07:40:13 -0800 (PST)
Message-ID: <4964C5EF.3060308@sgi.com>
Date: Wed, 07 Jan 2009 09:10:39 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] xfsdump support for 64K page size
Content-Type: multipart/mixed; boundary="------------090108000304070701010801"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: xfs-dev <xfs-dev@sgi.com>

This is a multi-part message in MIME format.
--------------090108000304070701010801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Various fixes to allow xfsdump/xfsrestore to work with 64K
page size. This is essentially Chinner's patch from a while
back.

Signed-off-by: Bill Kendall <wkendall@sgi.com>

--------------090108000304070701010801
Content-Type: text/plain;
 name="64k_pagesize"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="64k_pagesize"

---
 xfsdump/dump/content.c      |    2 +-
 xfsdump/restore/inomap.c    |    6 ------
 xfsprogs/libhandle/handle.c |    5 ++++-
 xfsprogs/libhandle/jdm.c    |    4 ++++
 4 files changed, 9 insertions(+), 8 deletions(-)

Index: xfs-cmds/xfsdump/restore/inomap.c
===================================================================
--- xfs-cmds.orig/xfsdump/restore/inomap.c
+++ xfs-cmds/xfsdump/restore/inomap.c
@@ -197,8 +197,6 @@ inomap_restore_pers( drive_t *drivep,
 	 */
 	ASSERT( INOPERSEG == ( sizeof( (( seg_t * )0 )->lobits ) * NBBY ));
 	ASSERT( sizeof( hnk_t ) == HNKSZ );
-	ASSERT( HNKSZ >= pgsz );
-	ASSERT( ! ( HNKSZ % pgsz ));
 	ASSERT( sizeof( pers_t ) <= PERSSZ );
 
 	/* get inomap info from media hdr
@@ -224,8 +222,6 @@ inomap_restore_pers( drive_t *drivep,
 
 	/* mmap the persistent hdr and space for the map
 	 */
-	ASSERT( sizeof( hnk_t ) * ( size_t )hnkcnt >= pgsz );
-	ASSERT( ! ( sizeof( hnk_t ) * ( size_t )hnkcnt % pgsz ));
 	persp = ( pers_t * ) mmap_autogrow(
 				     PERSSZ
 				     +
@@ -355,8 +351,6 @@ inomap_sync_pers( char *hkdir )
 	/* sanity checks
 	 */
 	ASSERT( sizeof( hnk_t ) == HNKSZ );
-	ASSERT( HNKSZ >= pgsz );
-	ASSERT( ! ( HNKSZ % pgsz ));
 
 	/* only needed once per session
 	 */
Index: xfs-cmds/xfsdump/dump/content.c
===================================================================
--- xfs-cmds.orig/xfsdump/dump/content.c
+++ xfs-cmds/xfsdump/dump/content.c
@@ -210,7 +210,7 @@ typedef struct extent_group_context exte
 
 /* minimum sizes for extended attributes buffers
  */
-#define EXTATTR_LISTBUF_SZ	( 4 * pgsz )
+#define EXTATTR_LISTBUF_SZ	( XATTR_LIST_MAX )
 #define EXTATTR_RTRVARRAY_LEN	( 1 * pgsz )
 #define EXTATTR_DUMPBUF_SZ	( 4 * pgsz )
 
Index: xfs-cmds/xfsprogs/libhandle/handle.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libhandle/handle.c
+++ xfs-cmds/xfsprogs/libhandle/handle.c
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
--- xfs-cmds.orig/xfsprogs/libhandle/jdm.c
+++ xfs-cmds/xfsprogs/libhandle/jdm.c
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

--------------090108000304070701010801
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------090108000304070701010801--
