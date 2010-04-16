Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3G7POWX231623 for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 02:25:24 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2FB5112A78A6
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 00:27:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lw40SkrEpbHwZoiO for
	<xfs@oss.sgi.com>; Fri, 16 Apr 2010 00:27:20 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o3G7RJ6h030740
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 03:27:20 -0400
Date: Fri, 16 Apr 2010 09:27:17 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] 125 run ftrunc with relative path
Message-ID: <alpine.LFD.2.00.1004160924090.2710@localhost>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Lukas Czerner <lczerner@redhat.com>, Eric Sandeen <esandeen@redhat.com>

>From 16588d733e681954386f1b92dd6e47cfef92a207 Mon Sep 17 00:00:00 2001
From: Lukas Czerner <lczerner@redhat.com>
Date: Tue, 13 Apr 2010 19:34:07 +0200
Subject: [PATCH] 125 run ftrunc with relative path

Since ftrunc is invoked with su $qa_user, it can fail when absolute path
is not accessible to everyone.
---
 125 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/125 b/125
index e84109a..9a29941 100755
--- a/125
+++ b/125
@@ -61,7 +61,7 @@ touch $TESTFILE
 chmod a+rw $TESTDIR
 chmod a+rw $TESTFILE
 
-su $qa_user -c "$here/src/ftrunc -f $TESTFILE"
+su $qa_user -c "./src/ftrunc -f $TESTFILE"
 
 if [ "$?" != "0" ];  then
     echo src/ftrunc returned non 0 status!
-- 
1.6.6.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
