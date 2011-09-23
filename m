Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8NCjCse095492 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 07:45:12 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: handle dump files with checksum bug
Date: Fri, 23 Sep 2011 07:45:02 -0500
Message-Id: <1316781902-19803-1-git-send-email-wkendall@sgi.com>
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

xfsdump previously contained a bug in the code which generated
a checksum on the header for extended attributes. This bug
was recently fixed, but a new xfsrestore will fail if it
encounters an old dump file which had checksums enabled. (This
is unlikely since checksums have just recently been enabled in
the build, and the above-mentioned bug was fixed at the same time.)

This patch uses a new flag in an extattrhdr_t to indicate a
checksum is present. If this is set, the checksum is validated.
If instead the old checksum flag is set, a warning is issued saying
the header could not be validated, and xfsrestore will assume the
header is valid.

Note that with this change a new dump cannot be restored with an
old restore which has checksums enabled. But as I mentioned, old
restores do not have checksums enabled.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 common/content_inode.h |   10 +++++++---
 restore/content.c      |   25 +++++++++++++++++++------
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/common/content_inode.h b/common/content_inode.h
index 0f21840..85e60df 100644
--- a/common/content_inode.h
+++ b/common/content_inode.h
@@ -339,13 +339,17 @@ typedef struct extattrhdr extattrhdr_t;
 #define EXTATTRHDR_FLAGS_NULL		( 1 << 1 )
 	/* marks the end of the attributes associated with the leading filehdr_t
 	 */
-#define EXTATTRHDR_FLAGS_CHECKSUM	( 1 << 2 )
-	/* checksum is present
+#define EXTATTRHDR_FLAGS_OLD_CHECKSUM	( 1 << 2 )
+	/* old xfsdumps used this flag to indicate a checksum is present,
+	 * but the checksum was not calculated properly. the presence of
+	 * this flag now indicates a checksum that cannot be verified.
 	 */
-
 #define EXTATTRHDR_FLAGS_SECURE		( 1 << 3 )
 	/* a linux "secure" mode attribute
 	 */
+#define EXTATTRHDR_FLAGS_CHECKSUM	( 1 << 4 )
+	/* checksum is present.
+	 */
 
 /* Routines for calculating and validating checksums on xfsdump headers.
  * The header length must be an integral number of u_int32_t's.
diff --git a/restore/content.c b/restore/content.c
index a98a9c7..b90feae 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -8156,6 +8156,7 @@ read_dirent( drive_t *drivep,
 static rv_t
 read_extattrhdr( drive_t *drivep, extattrhdr_t *ahdrp, bool_t ahcs )
 {
+	static bool_t warned = BOOL_FALSE;
 	drive_ops_t *dop = drivep->d_opsp;
 	/* REFERENCED */
 	intgen_t nread;
@@ -8197,16 +8198,28 @@ read_extattrhdr( drive_t *drivep, extattrhdr_t *ahdrp, bool_t ahcs )
 	      ahdrp->ah_checksum );
 
 	if ( ahcs ) {
-		if ( ! ( ahdrp->ah_flags & EXTATTRHDR_FLAGS_CHECKSUM )) {
+		if ( ahdrp->ah_flags & EXTATTRHDR_FLAGS_CHECKSUM ) {
+			if ( !is_checksum_valid( ahdrp, EXTATTRHDR_SZ )) {
+				mlog( MLOG_NORMAL | MLOG_WARNING, _(
+					"bad extattr header checksum\n") );
+				return RV_CORRUPT;
+			}
+		} else if ( ahdrp->ah_flags & EXTATTRHDR_FLAGS_OLD_CHECKSUM ) {
+			/* possibly a corrupt header, but most likely an old
+			 * header, which cannot be verified due to a bug in how
+			 * its checksum was calculated.
+			 */
+			if ( !warned ) {
+				mlog( MLOG_NORMAL | MLOG_WARNING, _(
+					"extattr header checksum "
+					"could not be verified\n") );
+				warned = BOOL_TRUE;
+			}
+		} else {
 			mlog( MLOG_NORMAL | MLOG_WARNING, _(
 			      "corrupt extattr header\n") );
 			return RV_CORRUPT;
 		}
-		if ( !is_checksum_valid( ahdrp, EXTATTRHDR_SZ )) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
-			      "bad extattr header checksum\n") );
-			return RV_CORRUPT;
-		}
 	}
 
 	return RV_OK;
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
