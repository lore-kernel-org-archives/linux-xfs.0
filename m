Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0C1617F3F
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 02:43:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EE3C3304059
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 00:43:17 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id YJjHZg7m9iYBoRTo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 04 May 2014 00:43:16 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s447hF4l023980
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sun, 4 May 2014 07:43:16 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id
	s447hEhB027507
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 4 May 2014 07:43:15 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id
	s447hDFb027498 for <xfs@oss.sgi.com>; Sun, 4 May 2014 07:43:14 GMT
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: [PATCH] xfsprogs: xfs_copy: use exit() to replace killall()
Date: Sun,  4 May 2014 15:44:15 +0800
Message-Id: <1399189455-29890-1-git-send-email-junxiao.bi@oracle.com>
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
Cc: joe.jin@oracle.com

Sending a SIGKILL signal to child thread will terminate the whole process,
xfs_copy will return an error value 137. This cause confuse for script to
know whether the copy successes.

Calling exit() in main thread can terminate the whole process and return the
right value.

Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 copy/xfs_copy.c |   33 +++------------------------------
 1 files changed, 3 insertions(+), 30 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 39517da..1419ce7 100644
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
@@ -1154,10 +1129,8 @@ main(int argc, char **argv)
 	}
 
 	check_errors();
-	killall();
-	pthread_exit(NULL);
-	/*NOTREACHED*/
-	return 0;
+
+	exit(0);
 }
 
 xfs_caddr_t
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
