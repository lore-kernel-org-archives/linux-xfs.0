Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E398F29DF5
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2015 13:54:48 -0500 (CDT)
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C78B5304062
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2015 11:54:45 -0700 (PDT)
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by estes.americas.sgi.com (Postfix) with ESMTP id 9594970030FB
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2015 13:54:45 -0500 (CDT)
Subject: xfsrestore: fix 2GB directory dump limitation for multi-stream
From: Rich Johnston <rjohnston@sgi.com>
Content-Disposition: inline;
	filename=fix-2GB-directory-dump-limitation-for-multi-stream.patch
Message-Id: <20150827185445.6E13960EDE2F0@gulag1.americas.sgi.com>
Date: Thu, 27 Aug 2015 13:54:45 -0500 (CDT)
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


The drive_simple restore path has a 2GB directory limit. Instead of
ASSERTing if nreadneeded64 is greater than INTGENMAX (2GB), add a loop
to handle it.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>
---
 common/drive_simple.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

Index: b/common/drive_simple.c
===================================================================
--- a/common/drive_simple.c
+++ b/common/drive_simple.c
@@ -765,18 +765,20 @@ do_seek_mark( drive_t *drivep, drive_mar
 	/* use read_buf util func to eat up difference
 	 */
 	nreadneeded64 = mark - strmoff;
-	ASSERT( nreadneeded64 <= INTGENMAX );
-	nreadneeded = ( intgen_t )nreadneeded64;
-	nread = read_buf( 0,
-			  ( size_t )nreadneeded,
-			  ( void * )drivep,
-			  ( rfp_t )drivep->d_opsp->do_read,
-			  ( rrbfp_t )drivep->d_opsp->do_return_read_buf,
-			  &rval );
-	if  ( rval ) {
-		return rval;
+	while ( nreadneeded64 > 0 ) {
+		if ( nreadneeded64 > INTGENMAX )
+			nreadneeded = INTGENMAX;
+		else
+			nreadneeded = ( intgen_t )nreadneeded64;
+		nread = read_buf( 0, nreadneeded, drivep,
+				  ( rfp_t )drivep->d_opsp->do_read,
+				( rrbfp_t )drivep->d_opsp->do_return_read_buf,
+				  &rval );
+		if  ( rval ) {
+			return rval;
+		}
+		nreadneeded64 -= nread;
 	}
-	ASSERT( nread == nreadneeded );
 
 	/* verify we are on the mark
 	 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
