Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 07EAC7F57
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 10:06:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 724D0AC003
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 08:06:45 -0700 (PDT)
Received: from mail-qa0-f53.google.com (mail-qa0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id jR5ecClf04URXCfV
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 12 May 2014 08:06:43 -0700 (PDT)
Received: by mail-qa0-f53.google.com with SMTP id ih12so7048289qab.26
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 08:06:43 -0700 (PDT)
Received: from tlielax.poochiereds.net ([2001:470:8:d63:3a60:77ff:fe93:a95d])
	by mx.google.com with ESMTPSA id
	r15sm10025356qgr.15.2014.05.12.08.06.42 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 12 May 2014 08:06:42 -0700 (PDT)
From: Jeff Layton <jlayton@poochiereds.net>
Subject: [xfstests PATCH 2/4] locktest: set f_fd to INVALID_HANDLE on close
Date: Mon, 12 May 2014 11:06:31 -0400
Message-Id: <1399907193-23857-3-git-send-email-jlayton@poochiereds.net>
In-Reply-To: <1399907193-23857-1-git-send-email-jlayton@poochiereds.net>
References: <1399907193-23857-1-git-send-email-jlayton@poochiereds.net>
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

Ensure that the fd is marked invalid after close. Also, the "closed"
and "reopen" variables are always set to 0. Remove them.

Signed-off-by: Jeff Layton <jlayton@poochiereds.net>
---
 src/locktest.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/src/locktest.c b/src/locktest.c
index b440a43e3947..0a674a7ff5c2 100644
--- a/src/locktest.c
+++ b/src/locktest.c
@@ -96,8 +96,6 @@ static int	debug = 0;
 static int	server = 1;
 static int	maxio = 8192;
 static int	port = 7890;
-static int	reopen=0;
-static int	closed=0;
 static int 	testnumber = -1;
 static int	saved_errno = 0;
 
@@ -615,13 +613,10 @@ int do_open(int flag)
 {
     if ((f_fd = OPEN(filename, flag)) == INVALID_HANDLE) {
 	perror("shared file create");
-	closed = 0;
 	return FAIL;
 	/*NOTREACHED*/
     }
 
-    closed = 0;
-
 #ifdef __sun
     if (D_flag) {
         directio(f_fd, DIRECTIO_ON);
@@ -701,12 +696,13 @@ int do_close(void)
 
     errno =0;
     CLOSE(f_fd);
+    f_fd = INVALID_HANDLE;
 
     saved_errno = errno;	    
 	
     if (errno)
 	return FAIL;
-    return(PASS);
+    return PASS;
 }
 
 void
@@ -778,7 +774,7 @@ void recv_ctl(void)
 void
 cleanup(void)
 {
-    if (f_fd>=0 && !reopen && !closed)
+    if (f_fd>=0)
         CLOSE(f_fd);
     
     if (c_fd>=0)
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
