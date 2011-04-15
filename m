Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3F3SM6d034945 for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 22:28:22 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD6AD12204C9
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 20:31:43 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	iQ3SdU6BXSbmteiB for <xfs@oss.sgi.com>;
	Thu, 14 Apr 2011 20:31:43 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QAZky-0006lw-1h
	for xfs@oss.sgi.com; Fri, 15 Apr 2011 13:31:40 +1000
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1QAZl8-0007Jf-IR
	for xfs@oss.sgi.com; Fri, 15 Apr 2011 13:31:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfsqa: reduce error output on 229
Date: Fri, 15 Apr 2011 13:31:50 +1000
Message-Id: <1302838310-28095-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Once we get one short write, we know the test has failed. We don't
ened to keep writing and getting more short writes and spewing
thousands of errors to the console.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 src/t_holes.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/src/t_holes.c b/src/t_holes.c
index eba310a..b111baf 100644
--- a/src/t_holes.c
+++ b/src/t_holes.c
@@ -29,8 +29,10 @@ int main(int argc, char **argv)
 		for (j = 0; j < 1024; j++)
 			buf[j]  = i | i << 5;
 
-		if (write(fd,buf,253*4*sizeof(int))!= 253*4*sizeof(int))
+		if (write(fd,buf,253*4*sizeof(int))!= 253*4*sizeof(int)) {
 			printf("Write did not return correct amount\n");
+			exit(EXIT_FAILURE);
+		}
 
 		if ((i % 9) == 0 && i < 9001)
 			lseek(fd, 4096 * 110,SEEK_CUR);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
