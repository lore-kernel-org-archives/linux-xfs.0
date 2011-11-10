Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAItmb5119173 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 12:55:48 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v2] xfsdump: handle Ctrl-D during prompts
Date: Thu, 10 Nov 2011 12:55:42 -0600
Message-Id: <1320951342-15477-1-git-send-email-wkendall@sgi.com>
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

xfsdump does not currently handle Ctrl-D well during a dialog
prompt. If some text is entered followed by Ctrl-D, an assert
will trip because xfsdump expects a new-line character at the
end of the user's input (or if asserts are disabled, the last
character the user entered will be dropped).

If Ctrl-D is entered without entering any response, some dialog
callers (e.g., tree_subtree_inter()) will abort because they
receive an unexpected response code.

This patch changes xfsdump to behave like other interactive
commands (xfs_db, bash, parted, ...) with respect to Ctrl-D.
If Ctrl-D precedes any input, an empty string is returned.
If Ctrl-D follows some input, it is ignored and xfsdump will
continue to wait for more input.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
Changed in v2:
   - Handle Ctrl-D like other commands do, rather than
     treating it as if the user typed 'enter'.

 common/dlog.c |   33 ++++++++++++++++++++++-----------
 1 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/common/dlog.c b/common/dlog.c
index 51666cf..ac0cafc 100644
--- a/common/dlog.c
+++ b/common/dlog.c
@@ -382,6 +382,7 @@ promptinput( char *buf,
 	time32_t now = time( NULL );
 	intgen_t nread = -1;
 	sigset_t orig_set;
+	char *bufp = buf;
 
 	/* display the pre-prompt
 	 */
@@ -447,8 +448,27 @@ promptinput( char *buf,
 
 		rc = select( dlog_ttyfd + 1, &rfds, NULL, NULL, &tv );
 		if ( rc > 0 && FD_ISSET( dlog_ttyfd, &rfds ) ) {
-			nread = read( dlog_ttyfd, buf, bufsz - 1 );
-			break;
+			nread = read( dlog_ttyfd, bufp, bufsz );
+			if ( nread < 0 ) {
+				break; // error handled below
+			} else if ( nread == 0 && buf == bufp ) {
+				mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE, "\n" );
+				*bufp = 0;
+				break; // no input, return an empty string
+			} else if ( nread > 0 && bufp[nread-1] == '\n' ) {
+				// received a full line, chomp the newline
+				bufp[nread-1] = 0;
+				break;
+			} else if ( nread == bufsz ) {
+				// no more room, truncate and return
+				bufp[nread-1] = 0;
+				break;
+			}
+
+			// keep waiting for a full line of input
+			bufp += nread;
+			bufsz -= nread;
+			nread = -1;
 		}
 		now = time( NULL );
 	}
@@ -489,17 +509,8 @@ promptinput( char *buf,
 			*exceptionixp = sigquitix;
 		}
 		return BOOL_FALSE;
-	} else if ( nread == 0 ) {
-		*exceptionixp = timeoutix;
-		if ( bufsz > 0 ) {
-			buf[ 0 ] = 0;
-		}
-		return BOOL_FALSE;
 	} else {
 		ASSERT( dlog_signo_received == -1 );
-		ASSERT( ( size_t )nread < bufsz );
-		ASSERT( buf[ nread - 1 ] == '\n' );
-		buf[ nread - 1 ] = 0;
 		*exceptionixp = 0;
 		return BOOL_TRUE;
 	}
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
