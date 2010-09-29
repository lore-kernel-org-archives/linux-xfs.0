Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8TEYvDs056276 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 09:34:57 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3EFA4C6712
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 07:35:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0hknglGdP2OeacYv for
	<xfs@oss.sgi.com>; Wed, 29 Sep 2010 07:35:55 -0700 (PDT)
Received: from int-mx08.intmail.prod.int.phx2.redhat.com
	(int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o8TEZtEI010892
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 10:35:55 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] xfstests 224: Use $SCRATCH_MNT variable
Date: Wed, 29 Sep 2010 16:35:50 +0200
Message-Id: <1285770951-27000-1-git-send-email-lczerner@redhat.com>
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
Cc: lczerner@redhat.com, esandeen@redhat.com

Use $SCRATCH_MNT variable instead of hard-coded path (/mnt/scratch) in
test 224.
---
 224 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/224 b/224
index 21be9af..00ebd2e 100644
--- a/224
+++ b/224
@@ -60,7 +60,7 @@ _scratch_mount >> $seq.full 2>&1
 
 # set the reserved block pool to almost empty for XFS
 if [ "$FSTYP" = "xfs" ]; then
-	xfs_io -x -c "resblks 4" /mnt/scratch/ >> $seq.full 2>&1
+	xfs_io -x -c "resblks 4" $SCRATCH_MNT >> $seq.full 2>&1
 fi
 
 FILES=1000
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
