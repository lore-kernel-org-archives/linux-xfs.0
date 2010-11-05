Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA5GZM7M209041 for <xfs@oss.sgi.com>; Fri, 5 Nov 2010 11:35:22 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 261ACAC015
	for <xfs@oss.sgi.com>; Fri,  5 Nov 2010 09:36:47 -0700 (PDT)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id E9F1F7006204
	for <xfs@oss.sgi.com>; Fri,  5 Nov 2010 11:36:44 -0500 (CDT)
Message-Id: <20101105163644.761748638@sgi.com>
Date: Fri, 05 Nov 2010 11:35:09 -0500
From: wkendall@sgi.com
Subject: [PATCH v2 9/9] xfsrestore: check for compatible xfsrestore
References: <20101105163500.747192954@sgi.com>
Content-Disposition: inline; filename=check_compatible_restore
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

When resuming a restore or doing a cumulative restore, xfsrestore
reads state information left around by the previous invocation.
This patch adds logic to determine whether or not restore is
able to make sense of the sense information.

The xfsrestore man page has also been updated to make the user
aware of the requirement to use a compatible restore and
system when resuming restores.

Signed-off-by: Bill Kendall <wkendall@sgi.com>

---
 man/man8/xfsrestore.8 |   26 +++++++++++---
 restore/content.c     |   92 +++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 108 insertions(+), 10 deletions(-)

Index: xfsdump-kernel.org/man/man8/xfsrestore.8
===================================================================
--- xfsdump-kernel.org.orig/man/man8/xfsrestore.8
+++ xfsdump-kernel.org/man/man8/xfsrestore.8
@@ -61,6 +61,18 @@ The deltas must be applied in the order 
 Each delta applied must have been produced with the previously applied
 delta as its base.
 .P
+.I xfsrestore
+keeps state information in the
+.IR xfsrestorehousekeepingdir ,
+to inform subsequent invocations when used in
+cumulative mode, or in the event a restore is interrupted.
+To ensure that the state information can be processed,
+a compatible version of
+.I xfsrestore
+must be used for each subsequent invocation. Additionally,
+each invocation must run on a system of the same endianness
+and page size.
+.P
 The options to
 .I xfsrestore
 are:
@@ -78,11 +90,11 @@ option allows the operator to specify an
 in which
 .I xfsrestore
 creates the
-.I xfsrestorehousekeeping
-directory.
-When performing a cumulative (\f3\-r\f1 option) restore,
-each successive invocation of \f2xfsrestore\f1 must specify the same alternate
+.I xfsrestorehousekeepingdir
 directory.
+When performing a cumulative (\f3\-r\f1 option) restore or
+resuming (\f3\-R\f1 option) a restore, each successive invocation
+must specify the same alternate directory.
 .TP 5
 \f3\-b\f1 \f2blocksize\f1
 Specifies the blocksize, in bytes, to be used for the restore. 
@@ -205,7 +217,11 @@ Source tape drive is a QIC tape.  QIC ta
 blocksize, for which \f2xfsrestore\f1 must make special allowances.
 .TP 5
 \f3\-r\f1
-Selects the cumulative mode of operation.
+Selects the cumulative mode of operation. The
+.B \-a
+and
+.I destination
+options must be the same for each invocation.
 .TP 5
 \f3\-s\f1 \f2subtree\f1
 Specifies a subtree to restore.
Index: xfsdump-kernel.org/restore/content.c
===================================================================
--- xfsdump-kernel.org.orig/restore/content.c
+++ xfsdump-kernel.org/restore/content.c
@@ -71,6 +71,13 @@
 
 /* structure definitions used locally ****************************************/
 
+#define HOUSEKEEPING_MAGIC	0x686b6d61
+	/* "hkma" - see the housekeeping_magic field of pers_t below.
+	 */
+#define HOUSEKEEPING_VERSION	1
+	/* see the housekeeping_version field of pers_t below.
+	 */
+
 #define WRITE_TRIES_MAX	3
 	/* retry loop tuning for write(2) workaround
 	 */
@@ -358,12 +365,43 @@ struct stream_context {
 
 typedef struct stream_context stream_context_t;
 
-/* persistent state file header - two parts: accumulation state
- * which spans several sessions, and session state. each has a valid
- * bit, and no fields are valid until the valid bit is set.
- * all elements defined such that a bzero results in a valid initial state.
+/* persistent state file header - on-disk format information plus
+ * accumulation state (which spans several sessions) and session state.
+ * the latter two have a valid bit, and their fields are not valid until
+ * the valid bit is set. all elements defined such that a bzero results
+ * in a valid initial state.
  */
 struct pers {
+	/* on-disk format information used to verify that xfsrestore
+	 * can make sense of the data in xfsrestorehousekeepingdir
+	 * when running in cumulative mode or when resuming a restore.
+	 *
+	 * for backwards/forwards compatibility, this struct must be
+	 * the first field! also any changes to the struct must address
+	 * compatibility with other xfsrestore versions.
+	 */
+	struct {
+		size32_t housekeeping_magic;
+			/* used to determine if this struct has been
+			 * initialized, and whether the machine's
+			 * endianness is the same as the previous
+			 * invocation. (data written to xfsrestore's
+			 * state directory is not converted to an
+			 * endian-neutral format since it only persists
+			 * for the life of one or more restore sessions.)
+			 */
+		size32_t housekeeping_version;
+			/* version of the data structures used in the
+			 * state files in housekeepingdir. this must be
+			 * bumped whenever the on-disk format changes.
+			 */
+		size64_t pagesize;
+			/* headers in the persistent state files
+			 * are aligned on page size boundaries, so
+			 * this cannot change betweeen invocations.
+			 */
+	} v;
+
 	/* command line arguments from first session, and session
 	 * history.
 	 */
@@ -1301,6 +1339,49 @@ content_init( intgen_t argc, char *argv[
 		      strerror( errno ));
 		return BOOL_FALSE;
 	}
+
+	/* but first setup or verify the on-disk format information
+	 */
+	if ( ! persp->a.valpr ) {
+		/* this is the first restore session
+		 */
+		persp->v.housekeeping_magic = HOUSEKEEPING_MAGIC;
+		persp->v.housekeeping_version = HOUSEKEEPING_VERSION;
+		persp->v.pagesize = pgsz;
+
+	} else {
+		/* cumulative or resuming a restore, verify the header
+		 */
+		if ( persp->v.housekeeping_magic != HOUSEKEEPING_MAGIC ) {
+			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			      "%s format corrupt or wrong endianness "
+			      "(0x%x, expected 0x%x)\n"),
+			      hkdirname,
+			      persp->v.housekeeping_magic,
+			      HOUSEKEEPING_MAGIC );
+			return BOOL_FALSE;
+		}
+		if ( persp->v.housekeeping_version != HOUSEKEEPING_VERSION ) {
+			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			      "%s format version differs from previous "
+			      "restore (%u, expected %u)\n"),
+			      hkdirname,
+			      persp->v.housekeeping_version,
+			      HOUSEKEEPING_VERSION );
+			return BOOL_FALSE;
+		}
+		if ( persp->v.pagesize != pgsz ) {
+			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			      "%s format differs from previous "
+			      "restore due to page size change "
+			      "(was %lu, now %lu)\n"),
+			      hkdirname,
+			      persp->v.pagesize,
+			      pgsz );
+			return BOOL_FALSE;
+		}
+	}
+
 	if ( ! persp->a.valpr ) {
 		if ( ! dstdir ) {
 			mlog( MLOG_NORMAL | MLOG_ERROR, _(
@@ -1565,7 +1646,8 @@ content_init( intgen_t argc, char *argv[
 		stpgcnt = 0;
 		newstpgcnt = ( stsz + pgmask ) / pgsz;
 		descpgcnt = 0;
-		memset( ( void * )persp, 0, sizeof( pers_t ));
+		memset( ( void * )&persp->a, 0,
+			sizeof( pers_t ) - offsetofmember( pers_t, a ));
 	} else if ( ! persp->s.valpr ) {
 		stpgcnt = persp->a.stpgcnt;
 		newstpgcnt = stpgcnt;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
