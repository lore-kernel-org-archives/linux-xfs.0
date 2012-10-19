Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9J3heEf230416 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 22:43:40 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xEgIh61yZIu91u73 for
	<xfs@oss.sgi.com>; Thu, 18 Oct 2012 20:45:19 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9J3jIvB007095
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 23:45:19 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfstests 250: remove unwanted new line in 250.out
Date: Fri, 19 Oct 2012 11:44:44 +0800
Message-Id: <1350618284-11708-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>

Additional new line at the end of 250.out will fail the test, remove it.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 250.out | 1 -
 1 file changed, 1 deletion(-)

diff --git a/250.out b/250.out
index 2225d6e..acb042a 100644
--- a/250.out
+++ b/250.out
@@ -12,4 +12,3 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 *** unmount loop filesystem
 *** check loop filesystem
 *** done
-
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
