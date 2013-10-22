Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0224B7F3F
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 07:14:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9F80DAC001
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 05:14:06 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id aLiHqNdNQ2or0KpZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 22 Oct 2013 05:14:02 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r9MCE07R010418
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 12:14:01 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9MCE0bQ000261
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 12:14:00 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9MCE0gH000255 for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 12:14:00 GMT
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Subject: [PATCH] xfstests: tests/generic: added -P option to df
Date: Tue, 22 Oct 2013 16:13:55 +0400
Message-Id: <1382444035-9502-1-git-send-email-stanislav.kholmanskikh@oracle.com>
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
Cc: vasily.isaenko@oracle.com

Otherwise the testcases will fail if the scratch
device has a long name (for example, if it's an LVM volume).
Because df outputs its usage stats with two lines:

/dev/mapper/xfstests-disk1
                       3030800      4608   2868908   1% /tmp/mnt/disk1

Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
---
 tests/generic/251 |    2 +-
 tests/generic/260 |    2 +-
 tests/generic/273 |    2 +-
 tests/generic/275 |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/generic/251 b/tests/generic/251
index 4126f15..eca3b0d 100755
--- a/tests/generic/251
+++ b/tests/generic/251
@@ -89,7 +89,7 @@ _guess_max_minlen()
 fstrim_loop()
 {
 	trap "_destroy_fstrim; exit \$status" 2 15
-	fsize=$(df | grep $SCRATCH_MNT | grep $SCRATCH_DEV  | awk '{print $2}')
+	fsize=$(df -P | grep $SCRATCH_MNT | grep $SCRATCH_DEV  | awk '{print $2}')
 	mmlen=$(_guess_max_minlen)
 
 	while true ; do
diff --git a/tests/generic/260 b/tests/generic/260
index dc8b822..ad11d4f 100755
--- a/tests/generic/260
+++ b/tests/generic/260
@@ -48,7 +48,7 @@ _scratch_mount
 
 _test_batched_discard $SCRATCH_MNT || _notrun "FITRIM not supported on $SCRATCH_DEV"
 
-fssize=$(df -k | grep "$SCRATCH_MNT" | grep "$SCRATCH_DEV"  | awk '{print $2}')
+fssize=$(df -k -P | grep "$SCRATCH_MNT" | grep "$SCRATCH_DEV"  | awk '{print $2}')
 
 beyond_eofs=$(_math "$fssize*2048")
 max_64bit=$(_math "2^64 - 1")
diff --git a/tests/generic/273 b/tests/generic/273
index d149808..3f46320 100755
--- a/tests/generic/273
+++ b/tests/generic/273
@@ -68,7 +68,7 @@ _file_create()
 
 	cd $SCRATCH_MNT/origin
 
-	_disksize=`df --block-size=1 $SCRATCH_DEV | awk -v sd=$SCRATCH_DEV 'BEGIN{c=0}{for(i=1;i<=NF;++i){a[c]=$i;++c}}END{for(entry in a){if(a[entry] ~ sd){print a[entry + 3]; break}}}'`
+	_disksize=`df --block-size=1 -P $SCRATCH_DEV | awk -v sd=$SCRATCH_DEV 'BEGIN{c=0}{for(i=1;i<=NF;++i){a[c]=$i;++c}}END{for(entry in a){if(a[entry] ~ sd){print a[entry + 3]; break}}}'`
 	_disksize=$(($_disksize / 3))
 	_num=$(($_disksize / $count / $threads / 4096))
 	_count=$count
diff --git a/tests/generic/275 b/tests/generic/275
index f83a644..5758878 100755
--- a/tests/generic/275
+++ b/tests/generic/275
@@ -76,7 +76,7 @@ rm -f $SCRATCH_MNT/tmp1
 sync
 echo "Post rm space:" >> $seqres.full
 df $SCRATCH_MNT >>$seqres.full 2>&1
-_freespace=`df -k $SCRATCH_MNT | tail -n 1 | awk '{print $4}'`
+_freespace=`df -k -P $SCRATCH_MNT | tail -n 1 | awk '{print $4}'`
 [ $_freespace -gt 1024 ] && _fail "could not sufficiently fill filesystem"
 
 # Try a write larger than available space
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
