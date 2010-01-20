Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0K3bMVZ235654 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 21:37:22 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A10D017746D
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 19:38:21 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	SiiffmozbV4HzHZ4 for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 19:38:21 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11651451-1927428
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 14:08:17 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NXROY-00053U-I4
	for xfs@oss.sgi.com; Wed, 20 Jan 2010 14:38:14 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NXROX-00008U-FE
	for xfs@oss.sgi.com; Wed, 20 Jan 2010 14:38:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/8] xfstests: fix printf format warnings in looptest.c
Date: Wed, 20 Jan 2010 14:38:06 +1100
Message-Id: <1263958688-435-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1263958688-435-1-git-send-email-david@fromorbit.com>
References: <1263958688-435-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 src/looptest.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/looptest.c b/src/looptest.c
index d951f2b..3d99f38 100755
--- a/src/looptest.c
+++ b/src/looptest.c
@@ -202,7 +202,7 @@ main(int argc, char *argv[])
         
         if ((flags & FLAG_OPENCLOSE) && (flags & FLAG_SEQUENTIAL)) {
             if (flags & FLAG_VERBOSE)
-                printf("seek %" LL "d\n", seek_to);
+                printf("seek %" LL "d\n", (long long)seek_to);
             if (SEEK(f, seek_to, FILE_BEGIN) < 0)
 	        PERROR("SEEK", GET_LAST_ERROR);
         }
@@ -212,7 +212,7 @@ main(int argc, char *argv[])
             
             if (!(flags & FLAG_SEQUENTIAL)) {
                 if (flags & FLAG_VERBOSE)
-                    printf("seek %" LL "d\n", seek_to);
+                    printf("seek %" LL "d\n", (long long)seek_to);
                 if (SEEK(f, seek_to, FILE_BEGIN) < 0)
 	            PERROR("SEEK", GET_LAST_ERROR);
             }
@@ -233,7 +233,7 @@ main(int argc, char *argv[])
             
             if (!(flags & FLAG_SEQUENTIAL) || (flags & FLAG_WRITE)) {
                 if (flags & FLAG_VERBOSE)
-                    printf("seek %" LL "d\n", seek_to);
+                    printf("seek %" LL "d\n", (long long)seek_to);
                 if (SEEK(f, seek_to, FILE_BEGIN) < 0)
 	            PERROR("SEEK", GET_LAST_ERROR);
             }
@@ -279,7 +279,7 @@ main(int argc, char *argv[])
 	    seek_to += bufsize;
 	    if (flags & FLAG_TRUNCATE) {
                 if (flags & FLAG_VERBOSE)
-                    printf("seek %" LL "d\n", seek_to);
+                    printf("seek %" LL "d\n", (long long)seek_to);
                 if (SEEK(f, seek_to, FILE_BEGIN) < 0)
 	            PERROR("SEEK", GET_LAST_ERROR);
 	    }
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
