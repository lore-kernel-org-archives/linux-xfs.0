Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA9MFsg0258926 for <xfs@oss.sgi.com>; Wed, 9 Nov 2011 16:15:54 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: handle Ctrl-D during prompts
Date: Wed,  9 Nov 2011 16:15:46 -0600
Message-Id: <1320876946-27643-1-git-send-email-wkendall@sgi.com>
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

This patch changes xfsdump to treat Ctrl-D as if the user hit
enter. User input (if any) will be passed back to the caller,
and a new line will be echoed to the terminal.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 common/dlog.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/common/dlog.c b/common/dlog.c
index 51666cf..ddd5524 100644
--- a/common/dlog.c
+++ b/common/dlog.c
@@ -489,17 +489,18 @@ promptinput( char *buf,
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
 		ASSERT( ( size_t )nread < bufsz );
-		ASSERT( buf[ nread - 1 ] == '\n' );
-		buf[ nread - 1 ] = 0;
+		/* Eat the newline if there is one. If there isn't one
+		 * (e.g., Ctrl-D) echo one to keep the output readable.
+		 */
+		if ( !nread || buf[ nread - 1 ] != '\n' ) {
+			buf[ nread ] = 0;
+			mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE, "\n" );
+		} else {
+			buf[ nread - 1 ] = 0;
+		}
 		*exceptionixp = 0;
 		return BOOL_TRUE;
 	}
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
