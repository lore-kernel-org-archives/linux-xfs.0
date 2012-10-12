Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9CLXUQf232021 for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 16:33:30 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id P3OzvtTLJmLFxJeD for <xfs@oss.sgi.com>;
	Fri, 12 Oct 2012 14:35:03 -0700 (PDT)
Message-ID: <50788D06.2030309@sandeen.net>
Date: Fri, 12 Oct 2012 16:35:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/3] xfsdump: extend fs_info to gather fs feature flags
References: <50788C50.40600@redhat.com>
In-Reply-To: <50788C50.40600@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

extend fs_info and fs_getid to return fs flags (features)
from GEOM call as well.  Not used yet in this patch.
Will be used in subsequent patch to detect 32-bit project
ID filesystems.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common/fs.c b/common/fs.c
index 6f4cb6c..bf2f164 100644
--- a/common/fs.c
+++ b/common/fs.c
@@ -111,6 +111,7 @@ fs_info( char *typb,		/* out */
 	 char *mntb,		/* out */
 	 intgen_t mntbz,
 	 uuid_t *idb,		/* out */
+	 __u32 *flgb,		/* out */
 	 char *usrs )		/* in */
 {
 	struct stat64 statb;
@@ -164,10 +165,10 @@ fs_info( char *typb,		/* out */
 	ASSERT( ok != BOOL_UNKNOWN );
 
 	if ( ok == BOOL_TRUE ) {
-		intgen_t rval = fs_getid( mntb, idb );
+		intgen_t rval = fs_getinfo( mntb, idb, flgb );
 		if ( rval ) {
 			mlog( MLOG_NORMAL,
-			      _("unable to determine uuid of fs mounted at %s: "
+			      _("unable to determine info for fs mounted at %s: "
 			      "%s\n"),
 			      mntb,
 			      strerror( errno ));
@@ -176,9 +177,9 @@ fs_info( char *typb,		/* out */
 			char string_uuid[37];
 			uuid_unparse( *idb, string_uuid );
 			mlog( MLOG_DEBUG,
-			      "fs %s uuid [%s]\n",
+			      "fs %s uuid [%s] flags [0x%x]\n",
 			      mntb,
-			      string_uuid );
+			      string_uuid, *flgb );
 		}
 	}
 
@@ -197,23 +198,25 @@ fs_mounted( char *typs, char *chrs, char *mnts, uuid_t *idp )
 }
 
 intgen_t
-fs_getid( char *mnts, uuid_t *idb )
+fs_getinfo( char *mnts, uuid_t *idb, __u32 *flgb )
 {
 	xfs_fsop_geom_v1_t geo;
 	int fd;
 
+	uuid_clear( *idb );
+	*flgb = 0;
+
 	fd = open( mnts, O_RDONLY );
-	if ( fd < 0 ) {
-		uuid_clear( *idb );
+	if ( fd < 0 )
 		return -1;
-	}
+
 	if ( ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geo ) ) {
-		uuid_clear( *idb );
 		close(fd);
 		return -1;
 	}
 	close(fd);
 	uuid_copy( *idb, geo.uuid );
+	*flgb = geo.flags;
 
 	return 0;
 }
diff --git a/common/fs.h b/common/fs.h
index 9ad1636..878385b 100644
--- a/common/fs.h
+++ b/common/fs.h
@@ -39,6 +39,7 @@ extern bool_t fs_info( char *fstype,		/* out: fs type (fsid.h) */
 		       char *mntpt,		/* out: where fs mounted */
 		       intgen_t mntptsz,	/* in: buffer size */
 		       uuid_t *fsid,		/* out: fs uuid */
+		       __u32 *fsflags,		/* out: fs flags */
 		       char *srcname );		/* in: how user named the fs */
 
 /* fs_mounted - checks if a file system is mounted at its mount point
@@ -48,10 +49,10 @@ extern bool_t fs_mounted( char *fstype,
 		          char *mntpt,
 		          uuid_t *fsid );
 
-/* fs_getid - retrieves the uuid of the file system containing the named
- * file. returns -1 with errno set on error.
+/* fs_getinfo - retrieves the uuid & flags of the file system containing the
+ * named file. returns -1 with errno set on error.
  */
-extern intgen_t fs_getid( char *fullpathname, uuid_t *fsidp );
+extern intgen_t fs_getinfo( char *fullpathname, uuid_t *fsidp, __u32 *fsflgp );
 
 /* tells how many inos in use
  */
diff --git a/dump/content.c b/dump/content.c
index ec5e954..9ed8459 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -526,6 +526,7 @@ content_init( intgen_t argc,
 	char fstype[ CONTENT_HDR_FSTYPE_SZ ];
 	bool_t skip_unchanged_dirs = BOOL_FALSE;
 	uuid_t fsid;
+	__u32 fsflags;
 	bool_t underfoundpr;
 	ix_t underlevel = ( ix_t )( -1 );
 	time32_t undertime = 0;
@@ -770,6 +771,7 @@ content_init( intgen_t argc,
 			mntpnt,
 			sizeof( mntpnt ),
 			&fsid,
+			&fsflags,
 			srcname )) {
 
 		mlog( MLOG_NORMAL | MLOG_ERROR, _(
@@ -789,7 +791,6 @@ content_init( intgen_t argc,
 		      srcname );
 		return BOOL_FALSE;
 	}
-
 	/* place the fs info in the write hdr template
 	 */
 	( void )strncpyterm( cwhdrtemplatep->ch_mntpnt,
diff --git a/dump/var.c b/dump/var.c
index 8370fa4..7adcc7d 100644
--- a/dump/var.c
+++ b/dump/var.c
@@ -79,11 +79,12 @@ void
 var_skip( uuid_t *dumped_fsidp, void ( *cb )( xfs_ino_t ino ))
 {
 	uuid_t fsid;
+	__u32 fsflags;
 	intgen_t rval;
 
 	/* see if the fs uuid's match
 	 */
-	rval = fs_getid( XFSDUMP_DIRPATH, &fsid );
+	rval = fs_getinfo( XFSDUMP_DIRPATH, &fsid, &fsflags);
 	if ( rval ) {
 #ifdef HIDDEN
                 /* NOTE: this will happen for non-XFS file systems */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
