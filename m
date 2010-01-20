Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0K3bQ2f235688 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 21:37:26 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 543A7177470
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 19:38:26 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	jicuDAECfFHk2knC for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 19:38:26 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11651454-1927428
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 14:08:25 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NXROY-00053G-9f
	for xfs@oss.sgi.com; Wed, 20 Jan 2010 14:38:14 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NXROX-00008R-6y
	for xfs@oss.sgi.com; Wed, 20 Jan 2010 14:38:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/8] xfstests: fix compile warnings in iopat.c
Date: Wed, 20 Jan 2010 14:38:05 +1100
Message-Id: <1263958688-435-6-git-send-email-david@fromorbit.com>
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

Printf format warnings and return value warnings need fixing.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 src/iopat.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/src/iopat.c b/src/iopat.c
index c06071f..f34de19 100644
--- a/src/iopat.c
+++ b/src/iopat.c
@@ -47,12 +47,13 @@ int main(int argc, char **argv)
    read(fd, &x, 1048576);
    for (i = 0; i < 131072; i++) {
       if (x[i] != i) {
-         printf("error: %d %d %d\n",i,8*i,x[i]);
+         printf("error: %d %d %lld\n", i ,8 * i, (long long)x[i]);
 	 exit(1);
       }
    }
 #endif
 
    close(fd);
+   exit(0);
 }
 
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
