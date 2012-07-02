Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q62ApYA2209996 for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 05:51:34 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8Fkf2FC3BfIR4Wkw for
	<xfs@oss.sgi.com>; Mon, 02 Jul 2012 03:51:33 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q62ApXLC025198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 06:51:33 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfstests: common.attr: get block size of test fs not root fs
Date: Mon,  2 Jul 2012 18:50:15 +0800
Message-Id: <1341226215-16674-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>, Eric Sandeen <esandeen@redhat.com>

stat -f $TEST_DEV shows block size of the fs where $TEST_DEV
resides, usually it is the root fs. This will fail 020 on non-4096 block
size ext2/3/4, also 4096 block size ext2/3/4 on ppc64.

Instead, stat -f $TEST_DIR will show block size of the fs to be tested.

Tested and passed on ext2/3/4, xfs, btrfs with all supported block size.

Cc: Eric Sandeen <esandeen@redhat.com>
Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 common.attr |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/common.attr b/common.attr
index 0f1e789..6e2c004 100644
--- a/common.attr
+++ b/common.attr
@@ -187,7 +187,7 @@ _sort_getfattr_output()
 if [ "$FSTYP" == "xfs" -o "$FSTYP" == "udf" ]; then
 	MAX_ATTRS=1000
 else # Assume max ~1 block of attrs
-	BLOCK_SIZE=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
+	BLOCK_SIZE=`stat -f $TEST_DIR | grep "Block size" | cut -d " " -f3`
 	# user.attribute_XXX="value.XXX" is about 32 bytes; leave some overhead
 	let MAX_ATTRS=$BLOCK_SIZE/40
 fi
@@ -198,7 +198,7 @@ export MAX_ATTRS
 if [ "$FSTYP" == "xfs" -o "$FSTYP" == "udf" -o "$FSTYP" == "btrfs" ]; then
 	MAX_ATTRVAL_SIZE=64
 else # Assume max ~1 block of attrs
-	BLOCK_SIZE=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
+	BLOCK_SIZE=`stat -f $TEST_DIR | grep "Block size" | cut -d " " -f3`
 	# leave a little overhead
 	let MAX_ATTRVAL_SIZE=$BLOCK_SIZE-256
 fi
-- 
1.7.10.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
