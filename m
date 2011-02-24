Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1OIftCF153863 for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 12:41:55 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E291D30408D
	for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 10:44:38 -0800 (PST)
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: fix bug restricting -f pathname length
Date: Thu, 24 Feb 2011 12:40:50 -0600
Message-Id: <1298572850-15408-1-git-send-email-wkendall@sgi.com>
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

A temporary buffer storing the dump filename (-f) is smaller than
the otherwise allowed pathname length. This buffer is used to
extract the pathname from additional parameters specified as part
of the -f argument. As these parameters are an undocumented and
unused extension of the -f argument, simply remove this code.
Note that drive_alloc() always dups the given pathname, so
'optarg' is passed directly.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 common/drive.c |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/common/drive.c b/common/drive.c
index f184afa..227fecd 100644
--- a/common/drive.c
+++ b/common/drive.c
@@ -137,10 +137,6 @@ drive_init1( int argc, char *argv[ ], bool_t singlethreaded )
 	opterr = 0;
 	driveix = 0;
 	while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
-		char optarray[100];
-		char *devname;
-		char *token;
-
 		switch ( c ) {
 		case GETOPT_DUMPDEST:
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
@@ -151,21 +147,9 @@ drive_init1( int argc, char *argv[ ], bool_t singlethreaded )
 				return BOOL_FALSE;
 			}
 
-			/* remove the device name from the rest of the
-			 * parameter string. note that strdup malloc()s
-			 * a string; important since optarray is an auto.
-			 */
-			ASSERT( strlen( optarg ) < sizeof( optarray ));
-			strncpy( optarray, optarg, sizeof( optarray ));
-			optarray[ sizeof( optarray ) - 1 ] = 0;
-			if ( ( token = strtok( optarray, "," )) == NULL ) {
-				token = optarray;
-			}
-			devname = strdup( token );
-
 			/* allocate a drive descriptor
 			 */
-			drivepp[ driveix ] = drive_alloc( devname, driveix );
+			drivepp[ driveix ] = drive_alloc( optarg, driveix );
 			driveix++;
 			break;
 		}
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
