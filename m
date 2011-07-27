Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6RGhDxR212451 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 11:43:13 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: allow multi-digit dialog prompts
Date: Wed, 27 Jul 2011 11:41:53 -0500
Message-Id: <1311784913-14191-1-git-send-email-wkendall@sgi.com>
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

xfsdump issues a multiple-choice dialog in various circumstances
(e.g., media change request). An assert incorrectly limits this to
at most 8 choices even though the code can handle up to 9.  Remove
the assert and change the code to handle multi-digit responses.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 common/dlog.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/common/dlog.c b/common/dlog.c
index 6a243ef..c81edc6 100644
--- a/common/dlog.c
+++ b/common/dlog.c
@@ -19,6 +19,7 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <stdlib.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <time.h>
@@ -186,7 +187,6 @@ dlog_multi_query( char *querystr[ ],
 	/* sanity
 	 */
 	ASSERT( dlog_allowed_flag );
-	ASSERT( choicecnt < 9 );
 
 	/* display query description strings
 	 */
@@ -245,24 +245,21 @@ dlog_multi_query( char *querystr[ ],
 				  prepromptstr,
 				  choicecnt );
 		if ( ok ) {
+			long int val;
+			char *end = buf;
+
 			if ( ! strlen( buf )) {
 				return defaultix;
 			}
-			if ( strlen( buf ) != 1 ) {
-				prepromptstr = _(
-				    "please enter a single "
-				    "digit response (1 to %d)");
-				continue;
-			}
-			if ( buf[ 0 ] < '1'
-			     ||
-			     buf[ 0 ] >= '1' + ( u_char_t )choicecnt ) {
+
+			val = strtol( buf, &end, 10 );
+			if ( *end != '\0' || val < 1 || val > choicecnt ) {
 				prepromptstr = _(
-				      "please enter a single digit "
+				      "please enter a value "
 				      "between 1 and %d inclusive ");
 				continue;
 			}
-			return ( size_t )( buf[ 0 ] - '1' );
+			return val - 1; // return value is a 0-based index
 		} else {
 			return exceptionix;
 		}
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
