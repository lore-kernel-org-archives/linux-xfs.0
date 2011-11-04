Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA42eOXO064882 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 21:40:25 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 501C521EBD1
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 19:40:23 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id yuXv7XiL1vYDutrb
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 19:40:23 -0700 (PDT)
Received: by vws19 with SMTP id 19so559611vws.26
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 19:40:23 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 1/2] xfstests: 083 make variable filesize as size in bytes
Date: Fri,  4 Nov 2011 10:38:03 +0800
Message-Id: <1320374284-1534-1-git-send-email-guaneryu@gmail.com>
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
Cc: Eryu Guan <guaneryu@gmail.com>

The first argument of _scratch_mkfs_sized() should be file system size
in bytes, so '100m' is not a valid number, and the 'expr' expression in
_scratch_mkfs_sized() complains 'non-numeric argument' about it.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 083 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/083 b/083
index 441284e..e0670b9 100755
--- a/083
+++ b/083
@@ -91,7 +91,7 @@ workout()
 
 echo "*** test out-of-space handling for random write operations"
 
-filesize=100m
+filesize=`expr 100 \* 1024 \* 1024`
 agcount=6
 numprocs=15
 numops=1500
-- 
1.7.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
