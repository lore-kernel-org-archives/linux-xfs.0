Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAJIb5TR146926 for <xfs@oss.sgi.com>; Fri, 19 Nov 2010 12:37:05 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 388F930406B
	for <xfs@oss.sgi.com>; Fri, 19 Nov 2010 10:38:38 -0800 (PST)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id 1CA2F7001C7F
	for <xfs@oss.sgi.com>; Fri, 19 Nov 2010 12:38:38 -0600 (CST)
Date: Fri, 19 Nov 2010 12:38:37 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v4 4/9] xfsrestore: mmap dirent names for faster lookups
Message-ID: <20101119183837.GA9505@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Pathname resolution in xfsrestore is about 4x faster if the file
containing dirent names ("namreg") is memory mapped.  If xfsrestore is
unable to map the file (e.g., due to virtual memory constraints)
fallback to the existing seek-and-read approach.

The file is mapped after all directory entries have been written to
the "namreg" file. If the caller tries to add additional entries after
the file has been mapped, it will be unmapped and restore will resort
back to seek-and-read lookups.

Signed-off-by: Bill Kendall <wkendall@sgi.com>

Reviewed-by: Alex Elder <aelder@sgi.com>

---
 restore/content.c |    2 -
 restore/namreg.c  |   98 +++++++++++++++++++++++++++++++++++++-----------------
 restore/namreg.h  |    6 ++-
 3 files changed, 73 insertions(+), 33 deletions(-)

Index: xfsdump-kernel.org/restore/content.c
===================================================================
--- xfsdump-kernel.org.orig/restore/content.c
+++ xfsdump-kernel.org/restore/content.c
@@ -3026,7 +3026,7 @@ applydirdump( drive_t *drivep,
 			return rv;
 		}
 
-		if ((rv = namreg_flush()) != RV_OK) {
+		if ((rv = namreg_map()) != RV_OK) {
 			return rv;
 		}
 
Index: xfsdump-kernel.org/restore/namreg.c
===================================================================
--- xfsdump-kernel.org.orig/restore/namreg.c
+++ xfsdump-kernel.org/restore/namreg.c
@@ -57,6 +57,7 @@ typedef struct namreg_pers namreg_pers_t
 struct namreg_tran {
 	char *nt_pathname;
 	int nt_fd;
+	char *nt_map;
 	bool_t nt_at_endpr;
 	size_t nt_off;
 	char nt_buf[NAMREG_BUFSIZE];
@@ -96,6 +97,7 @@ extern size_t pgsz;
 
 /* forward declarations of locally defined static functions ******************/
 
+static rv_t namreg_flush( void );
 
 /* definition of locally defined global variables ****************************/
 
@@ -262,6 +264,7 @@ namreg_add( char *name, size_t namelen )
 	 */
 	ASSERT( ntp );
 	ASSERT( npp );
+	ASSERT( !ntp->nt_map );
 
 	/* make sure file pointer is positioned to append
 	 */
@@ -326,7 +329,7 @@ namreg_del( nrh_t nrh )
 	 */
 }
 
-rv_t
+static rv_t
 namreg_flush( void )
 {
 	ssize_t nwritten;
@@ -367,6 +370,7 @@ namreg_get( nrh_t nrh,
 	off64_t newoff;
 	intgen_t nread;
 	size_t len;
+	char *in_bufp;
 	static char read_buf[256];
 	/* long enough for the longest allowed name (255), plus 1 for length */
 #ifdef NAMREGCHK
@@ -403,41 +407,51 @@ namreg_get( nrh_t nrh,
 
 	lock( );
 
-	if ( ntp->nt_at_endpr && ntp->nt_off ) {
-		if (namreg_flush() != RV_OK) {
+	if ( ntp->nt_map ) {
+
+		in_bufp = ntp->nt_map + newoff - NAMREG_PERS_SZ;
+
+	} else {
+
+		if ( ntp->nt_at_endpr && ntp->nt_off ) {
+			if (namreg_flush() != RV_OK) {
+				unlock( );
+				return -3;
+			}
+		}
+
+		/* seek to the name
+		*/
+		newoff = lseek64( ntp->nt_fd, newoff, SEEK_SET );
+		if ( newoff == ( off64_t )-1 ) {
 			unlock( );
+			mlog( MLOG_NORMAL, _(
+				"lseek of namreg failed: %s\n"),
+				strerror( errno ));
 			return -3;
 		}
-	}
+		ntp->nt_at_endpr = BOOL_FALSE;
 
-	/* seek to the name
-	 */
-	newoff = lseek64( ntp->nt_fd, newoff, SEEK_SET );
-	if ( newoff == ( off64_t )-1 ) {
-		unlock( );
-		mlog( MLOG_NORMAL, _(
-		      "lseek of namreg failed: %s\n"),
-		      strerror( errno ));
-		return -3;
-	}
+		/* read the name length and the name itself in one call
+		 * NOTE: assumes read_buf is big enough for the longest
+		 * allowed name (255 chars) plus one byte for length.
+		 */
+		nread = read( ntp->nt_fd, ( void * )read_buf, sizeof(read_buf) );
+		if ( nread <= 0 ) {
+			unlock( );
+			mlog( MLOG_NORMAL, _(
+				"read of namreg failed: %s (nread = %d)\n"),
+				strerror( errno ),
+				nread );
+			return -3;
+		}
 
-	/* read the name length and the name itself in one call
-	 * NOTE: assumes read_buf is big enough for the longest
-	 * allowed name (255 chars) plus one byte for length.
-	 */
-	nread = read( ntp->nt_fd, ( void * )read_buf, sizeof(read_buf) );
-	if ( nread <= 0 ) {
-		unlock( );
-		mlog( MLOG_NORMAL, _(
-		      "read of namreg failed: %s (nread = %d)\n"),
-		      strerror( errno ),
-		      nread );
-		return -3;
+		in_bufp = read_buf;
 	}
 
 	/* deal with a short caller-supplied buffer
 	 */
-	len = ( size_t )read_buf[0];
+	len = ( size_t )in_bufp[0];
 	if ( bufsz < len + 1 ) {
 		unlock( );
 		return -1;
@@ -445,7 +459,7 @@ namreg_get( nrh_t nrh,
 
 	/* copy the name into the caller-supplied buffer.
 	 */
-	strncpy(bufp, read_buf+1, len);
+	strncpy(bufp, in_bufp+1, len);
 
 #ifdef NAMREGCHK
 
@@ -460,13 +474,37 @@ namreg_get( nrh_t nrh,
 	/* null-terminate the string if room
 	 */
 	bufp[ len ] = 0;
-
-	ntp->nt_at_endpr = BOOL_FALSE;
 	
 	unlock( );
 
 	return ( intgen_t )len;
 }
 
+rv_t
+namreg_map( void )
+{
+	rv_t rv;
+
+	/* ensure all entries have been written */
+	if ( (rv = namreg_flush()) != RV_OK ) {
+		return rv;
+	}
+
+	ntp->nt_map = ( char * ) mmap_autogrow(
+					npp->np_appendoff - NAMREG_PERS_SZ,
+					ntp->nt_fd,
+					NAMREG_PERS_SZ );
+
+	/* it's okay if this fails, just fall back to (the much slower)
+	 * seek-and-read lookups.
+	 */
+	if ( ntp->nt_map == ( char * )-1 ) {
+		mlog( MLOG_DEBUG, "failed to map namreg: %s\n",
+			strerror( errno ) );
+		ntp->nt_map = NULL;
+	}
+
+	return RV_OK;
+}
 
 /* definition of locally defined static functions ****************************/
Index: xfsdump-kernel.org/restore/namreg.h
===================================================================
--- xfsdump-kernel.org.orig/restore/namreg.h
+++ xfsdump-kernel.org/restore/namreg.h
@@ -49,9 +49,11 @@ extern nrh_t namreg_add( char *name, siz
  */
 extern void namreg_del( nrh_t nrh );
 
-/* namreg_flush - flush namreg I/O buffer.  Returns 0 if successful.
+/* namreg_map - mmap the name registry, allowing for much
+ * faster namreg_get() lookups. once called, additional
+ * entries cannot be added.
  */
-extern rv_t namreg_flush( void );
+extern rv_t namreg_map( void );
 
 /* namreg_get - retrieves the name identified by the index.
  * fills the buffer with the null-terminated name from the registry.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
