Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 157B97F3F
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 12:57:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 045D9304066
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 10:57:22 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id VblXDP4HUcMsWetg for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 10:57:22 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 6/9] xfsdump: free suboptstrs if mlog_init1 fails
Date: Wed, 12 Nov 2014 12:57:15 -0600
Message-Id: <1415818638-32700-7-git-send-email-sandeen@redhat.com>
In-Reply-To: <1415818638-32700-1-git-send-email-sandeen@redhat.com>
References: <1415818638-32700-1-git-send-email-sandeen@redhat.com>
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

suboptstrs was never freed on error paths.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 common/mlog.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/common/mlog.c b/common/mlog.c
index b0135b9..f1fa12f 100644
--- a/common/mlog.c
+++ b/common/mlog.c
@@ -149,6 +149,7 @@ mlog_init1( intgen_t argc, char *argv[ ] )
 	ix_t soix;
 	size_t vsymcnt;
 	intgen_t c;
+	bool_t retval = BOOL_FALSE;	/* Until proven otherwise */
 
 	/* prepare an array of suboption token strings. this will be the
 	 * concatenation of the subsystem names with the verbosity symbols.
@@ -192,7 +193,7 @@ mlog_init1( intgen_t argc, char *argv[ ] )
 					 progname,
 					 c );
 				usage( );
-				return BOOL_FALSE;
+				goto out_free;
 			}
 			options = optarg;
 			while ( *options ) {
@@ -208,7 +209,7 @@ mlog_init1( intgen_t argc, char *argv[ ] )
 						 progname,
 						 c );
 					usage( );
-					return BOOL_FALSE;
+					goto out_free;
 				}
 				ASSERT( ( ix_t )suboptix
 					<
@@ -224,7 +225,7 @@ mlog_init1( intgen_t argc, char *argv[ ] )
 							 c,
 						mlog_ss_names[ suboptix ] );
 						usage( );
-						return BOOL_FALSE;
+						goto out_free;
 					}
 					ssix = ( ix_t )suboptix;
 					mlog_level_ss[ ssix ] =
@@ -238,7 +239,7 @@ mlog_init1( intgen_t argc, char *argv[ ] )
 							 progname,
 							 c );
 						usage( );
-						return BOOL_FALSE;
+						goto out_free;
 					}
 					ssix = MLOG_SS_GEN;
 					mlog_level_ss[ ssix ] =
@@ -251,7 +252,7 @@ mlog_init1( intgen_t argc, char *argv[ ] )
 						 progname,
 						 c );
 					usage( );
-					return BOOL_FALSE;
+					goto out_free;
 				}
 			}
 			break;
@@ -267,8 +268,6 @@ mlog_init1( intgen_t argc, char *argv[ ] )
 		}
 	}
 
-	free( ( void * )suboptstrs );
-
 	/* give subsystems not explicitly called out the "general" verbosity
 	 */
 	for ( ssix = 0 ; ssix < MLOG_SS_CNT ; ssix++ ) {
@@ -301,7 +300,11 @@ mlog_init1( intgen_t argc, char *argv[ ] )
 
 	mlog_qlockh = QLOCKH_NULL;
 
-	return BOOL_TRUE;
+	retval = BOOL_TRUE;
+
+out_free:
+	free( ( void * )suboptstrs );
+	return retval;
 }
 
 bool_t
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
