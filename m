Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8EB2Hil079022 for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 06:02:17 -0500
Received: from oproxy9.bluehost.com (oproxy9.bluehost.com [69.89.24.6]) by
	cuda.sgi.com with SMTP id GeErMrsDrzWNPVfn for
	<xfs@oss.sgi.com>; Fri, 14 Sep 2012 04:03:20 -0700 (PDT)
From: Tao Ma <tm@tao.ma>
Subject: [PATCH] xfstests: 275, Don't remove all the files in SCRATCH_MNT.
Date: Fri, 14 Sep 2012 19:03:12 +0800
Message-Id: <1347620592-3420-1-git-send-email-tm@tao.ma>
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
Cc: Eric Sandeen <sandeen@sandeen.net>

From: Tao Ma <boyu.mt@taobao.com>

After the volume is mkfsed, it should have no other files that
need to be rmed. And what's more, it makes ext4 complain since
lost+found is also removed.

So remove this useless "rm -rf $SCRATCH_MNT/*".

Cc: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 275 |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/275 b/275
index 69b2895..06db775 100755
--- a/275
+++ b/275
@@ -57,8 +57,6 @@ umount $SCRATCH_DEV 2>/dev/null
 _scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
 _scratch_mount
 
-rm -rf $SCRATCH_MNT/*
-
 dd if=/dev/zero of=$SCRATCH_MNT/tmp1 bs=256K count=1 >>$seq.full 2>&1
 [ $? -ne 0 ] && _fail "Error creating file"
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
