Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9171A29DFC
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 07:38:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3A081AC005
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 05:38:58 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	smdo6mRNKIdg0lfY for <xfs@oss.sgi.com>;
	Thu, 16 Apr 2015 05:38:56 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Yij45-0006B3-Qt
	for xfs@oss.sgi.com; Thu, 16 Apr 2015 22:38:41 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Yij45-0003cr-Q3
	for xfs@oss.sgi.com; Thu, 16 Apr 2015 22:38:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: xfs_iozero can return positive errno
Date: Thu, 16 Apr 2015 22:38:41 +1000
Message-Id: <1429187921-13903-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

It was missed when we converted everything in XFs to use negative error
numbers, so fix it now. Bug introduced in 3.17 by commit 2451337 ("xfs: global
error sign conversion"), and should go back to stable kernels.

Thanks to Brian Foster for noticing it.

cc: <stable@vger.kernel.org> # 3.17, 3.18, 3.19, 4.0
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ec0c9c2..8383df0 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -125,7 +125,7 @@ xfs_iozero(
 		status = 0;
 	} while (count);
 
-	return (-status);
+	return status;
 }
 
 int
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
