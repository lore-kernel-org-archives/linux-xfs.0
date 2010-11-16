Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAGF5Vjm069864 for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 09:05:31 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B80018F80BA
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 07:07:04 -0800 (PST)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id 9FA3970017CB
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 09:07:04 -0600 (CST)
Message-Id: <20101116150704.454578811@sgi.com>
Date: Tue, 16 Nov 2010 09:05:06 -0600
From: wkendall@sgi.com
Subject: [PATCH v3 4/9] xfsrestore: mmap dirent names for faster lookups
References: <20101116150502.179825893@sgi.com>
Content-Disposition: inline; filename=namreg_map
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
 restore/content.c |    2 
 restore/namreg.c  |  124 ++++++++++++++++++++++++++++++++++++++++--------------
 restore/namreg.h  |    6 +-
 3 files changed, 98 insertions(+), 34 deletions(-)

Index: xfsdump-kernel.org/restore/content.c
===================================================================
--- xfsdump-kernel.org.orig/restore/content.c
+++ xfsdump-kernel.org/restore/content.c
@@ -3026,7 +3026,7 @@ applydirdump( drive_t *drivep,
 			return rv;
 		}
 
-		if ((rv = namreg_flush()) != RV_OK) {
+		if ((rv = namreg_flush(BOOL_TRUE)) != RV_OK) {
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
@@ -96,6 +97,9 @@ extern size_t pgsz;
 
 /* forward declarations of locally defined static functions ******************/
 
+static inline bool_t namreg_is_mapped();
+static void namreg_map();
+static void namreg_unmap();
 
 /* definition of locally defined global variables ****************************/
 
@@ -263,6 +267,10 @@ namreg_add( char *name, size_t namelen )
 	ASSERT( ntp );
 	ASSERT( npp );
 
+	if ( namreg_is_mapped() ) {
+		namreg_unmap();
+	}
+
 	/* make sure file pointer is positioned to append
 	 */
 	if ( ! ntp->nt_at_endpr ) {
@@ -280,7 +288,7 @@ namreg_add( char *name, size_t namelen )
 	}
 
 	if (ntp->nt_off + namelen + 1 > sizeof(ntp->nt_buf)) {
-		if (namreg_flush() != RV_OK) {
+		if (namreg_flush(BOOL_FALSE) != RV_OK) {
 			return NRH_NULL;
 		}
 	}
@@ -327,7 +335,7 @@ namreg_del( nrh_t nrh )
 }
 
 rv_t
-namreg_flush( void )
+namreg_flush( bool_t done_adding )
 {
 	ssize_t nwritten;
 
@@ -335,6 +343,10 @@ namreg_flush( void )
 	*/
 	assert( ntp );
 
+	if ( namreg_is_mapped() ) {
+		namreg_unmap();
+	}
+
 	if (ntp->nt_off) {
 
 		/* write the accumulated name strings.
@@ -356,6 +368,11 @@ namreg_flush( void )
 		}
 		ntp->nt_off = 0;
 	}
+
+	if (done_adding) {
+		namreg_map();
+	}
+
 	return RV_OK;
 }
 
@@ -367,6 +384,7 @@ namreg_get( nrh_t nrh,
 	off64_t newoff;
 	intgen_t nread;
 	size_t len;
+	char *in_bufp;
 	static char read_buf[256];
 	/* long enough for the longest allowed name (255), plus 1 for length */
 #ifdef NAMREGCHK
@@ -403,41 +421,51 @@ namreg_get( nrh_t nrh,
 
 	lock( );
 
-	if ( ntp->nt_at_endpr && ntp->nt_off ) {
-		if (namreg_flush() != RV_OK) {
+	if ( namreg_is_mapped() ) {
+
+		in_bufp = ntp->nt_map + newoff - NAMREG_PERS_SZ;
+
+	} else {
+
+		if ( ntp->nt_at_endpr && ntp->nt_off ) {
+			if (namreg_flush(BOOL_FALSE) != RV_OK) {
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
@@ -445,7 +473,7 @@ namreg_get( nrh_t nrh,
 
 	/* copy the name into the caller-supplied buffer.
 	 */
-	strncpy(bufp, read_buf+1, len);
+	strncpy(bufp, in_bufp+1, len);
 
 #ifdef NAMREGCHK
 
@@ -460,8 +488,6 @@ namreg_get( nrh_t nrh,
 	/* null-terminate the string if room
 	 */
 	bufp[ len ] = 0;
-
-	ntp->nt_at_endpr = BOOL_FALSE;
 	
 	unlock( );
 
@@ -470,3 +496,39 @@ namreg_get( nrh_t nrh,
 
 
 /* definition of locally defined static functions ****************************/
+
+static inline bool_t
+namreg_is_mapped()
+{
+	return ntp->nt_map ? BOOL_TRUE : BOOL_FALSE;
+}
+
+static void
+namreg_map()
+{
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
+}
+
+static void
+namreg_unmap()
+{
+	/* we really shouldn't be here, we were told that no more names would
+	 * be added to the namreg. rather than tip over, just fall back to
+	 * seek-and-read lookups.
+	 */
+	munmap( ( void * )ntp->nt_map, npp->np_appendoff - NAMREG_PERS_SZ );
+	ntp->nt_map = NULL;
+	mlog( MLOG_DEBUG, "namreg lookups resorting to seek-and-read\n" );
+}
Index: xfsdump-kernel.org/restore/namreg.h
===================================================================
--- xfsdump-kernel.org.orig/restore/namreg.h
+++ xfsdump-kernel.org/restore/namreg.h
@@ -49,9 +49,11 @@ extern nrh_t namreg_add( char *name, siz
  */
 extern void namreg_del( nrh_t nrh );
 
-/* namreg_flush - flush namreg I/O buffer.  Returns 0 if successful.
+/* namreg_flush - flush namreg I/O buffer. pass BOOL_TRUE
+ * if done adding names to the registry.
+ * Returns 0 if successful.
  */
-extern rv_t namreg_flush( void );
+extern rv_t namreg_flush( bool_t done_adding );
 
 /* namreg_get - retrieves the name identified by the index.
  * fills the buffer with the null-terminated name from the registry.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
