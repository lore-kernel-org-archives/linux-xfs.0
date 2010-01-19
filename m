Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J92Ueo178247 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:02:31 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A526711F97FD
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:03:29 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	dlM2iYLFKygoHKlp for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 01:03:29 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11648323-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 19:33:28 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX9zZ-0003gG-Gk
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 20:03:17 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX9zY-00083w-Nk
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 20:03:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfsqa: Fix signal usage in aio-dio test code
Date: Tue, 19 Jan 2010 20:03:11 +1100
Message-Id: <1263891792-30952-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1263891792-30952-1-git-send-email-david@fromorbit.com>
References: <1263891792-30952-1-git-send-email-david@fromorbit.com>
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

Using signal() to set up signal handlers doesn't always do what you
want. A recent upgrade made test 208 fail because wait() was not
getting interrupted by a SIGALRM. Tracing showed that signal() was
being converted to a sigaction(SA_RESTART) handler, which allows
syscalls that return ERESTARTSYS to immediately restart without
returning EINTR to the calling process. The kernel code returns
ERESTARTSYS to signal interruptions while in wait().

Replace the use of signal with sigaction() to ensure that the
SA_RESTART flag is not set and the EINTR is delivered to the process
sitting in wait().  This makes test 208 terminate at 200s again.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 src/aio-dio-regress/aio-dio-invalidate-failure.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/src/aio-dio-regress/aio-dio-invalidate-failure.c b/src/aio-dio-regress/aio-dio-invalidate-failure.c
index be01a3a..24f3e3c 100644
--- a/src/aio-dio-regress/aio-dio-invalidate-failure.c
+++ b/src/aio-dio-regress/aio-dio-invalidate-failure.c
@@ -21,6 +21,7 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <signal.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
@@ -117,6 +118,7 @@ int main(int argc, char **argv)
 	int fd;
 	int fd2;
 	int status;
+	struct sigaction sa;
 
 	if (argc != 2)
 		fail("only arg should be file name");
@@ -150,7 +152,12 @@ int main(int argc, char **argv)
 		exit(0);
 	}
 
-	signal(SIGALRM, alarm_handler);
+	memset(&sa, 0, sizeof(sa));
+	sa.sa_handler = alarm_handler;
+	sigemptyset(&sa.sa_mask);
+	if (sigaction(SIGALRM, &sa, NULL) == -1)
+		fail("sigaction: %d\n", errno);
+
 	alarm(SECONDS);
 
 	pid = wait(&status);
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
