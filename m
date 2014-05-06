Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 79E1A7FAA
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 01:54:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 535BB304059
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 23:54:12 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id RXh9g1v0f4AGQAP1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 23:54:11 -0700 (PDT)
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: [PATCH V2] xfsprogs: xfs_copy: use exit() to replace killall()
Date: Tue,  6 May 2014 14:54:44 +0800
Message-Id: <1399359284-20536-1-git-send-email-junxiao.bi@oracle.com>
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
Cc: hch@infradead.org, joe.jin@oracle.com, junxiao.bi@oracle.com

Sending a SIGKILL signal to child thread will terminate the whole process,
xfs_copy will return an error value 137. This cause confuse for script to
know whether the copy successes.

Calling exit() in main thread can terminate the whole process and return the
right value. Replace killall()+abort() with exit(1) to match the old way
exit in error case. Also remove killall()+pthread_exit(NULL) since return 0
will be followed by an exit(0) to terminate the process.

Bug story from Chrisoph Hellwig:
Btw, I think the reason for this cruft is that xfs_copy was originally
written using the IRIX sproc interface, and the port to pthreads didn't
remove this gem:

http://marc.info/?l=linux-xfs&m=99535721110020&w=2

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joe jin <joe.jin@oracle.com>
Cc: Chrisoph Hellwig <hch@infradead.org>
---
 copy/xfs_copy.c |   30 +-----------------------------
 1 files changed, 1 insertions(+), 29 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 39517da..39bb9d7 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -217,25 +217,6 @@ handle_error:
 }
 
 void
-killall(void)
-{
-	int i;
-
-	/* only the parent gets to kill things */
-
-	if (getpid() != parent_pid)
-		return;
-
-	for (i = 0; i < num_targets; i++)  {
-		if (target[i].state == ACTIVE)  {
-			/* kill up target threads */
-			pthread_kill(target[i].pid, SIGKILL);
-			pthread_mutex_unlock(&targ[i].wait);
-		}
-	}
-}
-
-void
 handler(int sig)
 {
 	pid_t	pid = getpid();
@@ -400,8 +381,7 @@ read_wbuf(int fd, wbuf *buf, xfs_mount_t *mp)
 	if (buf->length > buf->size)  {
 		do_warn(_("assert error:  buf->length = %d, buf->size = %d\n"),
 			buf->length, buf->size);
-		killall();
-		abort();
+		exit(1);
 	}
 
 	if ((res = read(fd, buf->data, buf->length)) < 0)  {
@@ -591,11 +571,6 @@ main(int argc, char **argv)
 
 	parent_pid = getpid();
 
-	if (atexit(killall))  {
-		do_log(_("%s: couldn't register atexit function.\n"), progname);
-		die_perror();
-	}
-
 	/* open up source -- is it a file? */
 
 	open_flags = O_RDONLY;
@@ -1154,9 +1129,6 @@ main(int argc, char **argv)
 	}
 
 	check_errors();
-	killall();
-	pthread_exit(NULL);
-	/*NOTREACHED*/
 	return 0;
 }
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
