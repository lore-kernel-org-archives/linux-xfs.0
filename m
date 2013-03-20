Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8244F7F4E
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 05:51:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6F5078F8049
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 03:50:59 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id FRAo2Y2cwhYa5HjD for <xfs@oss.sgi.com>;
	Wed, 20 Mar 2013 03:50:58 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH v2] Count journal size in test 289
Date: Wed, 20 Mar 2013 11:50:48 +0100
Message-Id: <1363776648-14061-1-git-send-email-jack@suse.cz>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, Jan Kara <jack@suse.cz>

Test 289 ignored the fact that historically journal is not accounted as
fs overhead in ext3. For larger filesystems it is hidden in 1% tolerance
but for filesystems smaller than 12G the test fails. So make the
counting precise to work everywhere.

CC: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 289           |   16 ++++++++++++----
 common.filter |   15 +++++++++++++++
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/289 b/289
index b057c20..eb5c63b 100755
--- a/289
+++ b/289
@@ -59,10 +59,18 @@ TOTAL_BLOCKS=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
 FREE_BLOCKS=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
 		| awk '/Free blocks:/{print $3}'`
 
-# nb: kernels today don't count journal blocks  as overhead, but should.
-# For most filesystems this will still be within tolerance.
-# Overhead is all the blocks (already) used by the fs itself:
-OVERHEAD=$(($TOTAL_BLOCKS-$FREE_BLOCKS))
+# ext3 doesn't count journal blocks as overhead, ext4 does.
+if [ $FSTYP = "ext3" ]; then
+	JOURNAL_SIZE=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
+		| awk '/Journal size:/{print $3}' | _filter_size_to_bytes`
+	BLOCK_SIZE=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
+		| awk '/Block size:/{print $3}'`
+	JOURNAL_BLOCKS=$(($JOURNAL_SIZE/$BLOCK_SIZE))
+else
+	JOURNAL_BLOCKS=0
+fi
+
+OVERHEAD=$(($TOTAL_BLOCKS-$FREE_BLOCKS-$JOURNAL_BLOCKS))
 
 #  bsddf|minixdf
 #         Set the behaviour  for  the  statfs  system  call.  The  minixdf
diff --git a/common.filter b/common.filter
index f0f6076..fcd7589 100644
--- a/common.filter
+++ b/common.filter
@@ -229,5 +229,20 @@ _filter_spaces()
        sed -e 's/ [ ]*/ /g'
 }
 
+# Convert string read from stdin like 128K to bytes and print it to stdout
+_filter_size_to_bytes()
+{
+	read size
+	suffix=${size:${#size}-1}
+	mul=1
+	case $suffix in
+		K) mul=1024 ;;
+		M) mul=$((1024*1024)) ;;
+		G) mul=$((1024*1024*1024)) ;;
+		T) mul=$((1024*1024*1024*1024)) ;;
+	esac
+	echo $((${size:0:${#size}-1}*$mul))
+}
+
 # make sure this script returns success
 /bin/true
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
