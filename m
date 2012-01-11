Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BL8C44190015 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 15:08:13 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: allow system() to obtain exit status
Date: Wed, 11 Jan 2012 15:07:53 -0600
Message-Id: <1326316073-15033-1-git-send-email-wkendall@sgi.com>
In-Reply-To: <CAGdb-8fyseE+ARMUWaQYcx1VCnmph=xL7XeTBUXg2wSSdF_7hw@mail.gmail.com>
References: <CAGdb-8fyseE+ARMUWaQYcx1VCnmph=xL7XeTBUXg2wSSdF_7hw@mail.gmail.com>
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

xfsdump explicitly ignores SIGCHLD in order to prevent librmt rsh
processes from becoming zombies. However, doing so interferes with the
ability for system() to determine a command's exit status.

Setting up a handler for SIGCHLD will not work either, since xfsdump is
now multi-threaded and the main thread (which handles signals) might
handle a child exit before the thread running system() can.

I also attempted to use waitpid() when tearing down a librmt session,
but this has the potential to block indefinitely if there is a problem
on the remote side. (And using WNOHANG tended to never catch the exit.)

In the end, I settled on just not touching SIGCHLD at all. There may be
a zombie rsh when librmt is used, but typically it will be alive until
the end of the backup and in any case will be cleaned up when
xfsdump/restore exits.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 common/main.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/common/main.c b/common/main.c
index 5880723..c9a311b 100644
--- a/common/main.c
+++ b/common/main.c
@@ -507,6 +507,13 @@ main( int argc, char *argv[] )
 	 * want to exit when a signal is received. otherwise, hold signals so
 	 * they don't interfere with sys calls; they will be released at
 	 * pre-emption points and upon pausing in the main loop.
+	 *
+	 * note that since we're multi-threaded, handling SIGCHLD causes
+	 * problems with system()'s ability to obtain a child's exit status
+	 * (because the main thread may process SIGCHLD before the thread
+	 * running system() calls waitpid()). likewise explicitly ignoring
+	 * SIGCHLD also prevents system() from getting an exit status.
+	 * therefore we don't do anything with SIGCHLD.
 	 */
 
 	sigfillset(&sa.sa_mask);
@@ -514,13 +521,9 @@ main( int argc, char *argv[] )
 
 	/* always ignore SIGPIPE, instead handle EPIPE as part
 	 * of normal sys call error handling.
-	 *
-	 * explicitly ignore SIGCHLD so that if librmt rsh sessions
-	 * exit early they do not become zombies.
 	 */
 	sa.sa_handler = SIG_IGN;
 	sigaction( SIGPIPE, &sa, NULL );
-	sigaction( SIGCHLD, &sa, NULL );
 
 	if ( ! pipeline ) {
 		sigset_t blocked_set;
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
