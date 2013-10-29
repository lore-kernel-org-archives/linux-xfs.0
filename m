Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8E7847F3F
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 04:25:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2F831AC002
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 02:25:33 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id lZgcGcw54Ll4lCFN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 02:25:31 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r9T9PUjB020251
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 09:25:31 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9T9PTeD024139
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 09:25:30 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9T9PTbn009169 for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 09:25:29 GMT
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Subject: [PATCH V2] xfstests: added -P option to $DF_PROG
Date: Tue, 29 Oct 2013 13:25:24 +0400
Message-Id: <1383038724-4365-1-git-send-email-stanislav.kholmanskikh@oracle.com>
In-Reply-To: <20131028214444.GE2797@dastard>
References: <20131028214444.GE2797@dastard>
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

Added -P option to $DF_PROG and changed the invocation of
'df' command in generic/{251,260,273,275} testcases
with $DF_PROG.

Otherwise the testcases will fail if the scratch
device has a long name (for example, if it's an LVM volume).
Because df outputs its usage stats with two lines:

/dev/mapper/xfstests-disk1
                       3030800      4608   2868908   1% /tmp/mnt/disk1

Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
---
 common/config     |    2 +-
 tests/generic/251 |    2 +-
 tests/generic/260 |    2 +-
 tests/generic/273 |    2 +-
 tests/generic/275 |    6 +++---
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/common/config b/common/config
index db086fb..21ce833 100644
--- a/common/config
+++ b/common/config
@@ -150,7 +150,7 @@ export PS_ALL_FLAGS="-ef"
 
 export DF_PROG="`set_prog_path df`"
 [ "$DF_PROG" = "" ] && _fatal "df not found"
-[ "$HOSTOS" = "Linux" ] && export DF_PROG="$DF_PROG -T"
+[ "$HOSTOS" = "Linux" ] && export DF_PROG="$DF_PROG -T -P"
 
 export XFS_LOGPRINT_PROG="`set_prog_path xfs_logprint`"
 export XFS_REPAIR_PROG="`set_prog_path xfs_repair`"
diff --git a/tests/generic/251 b/tests/generic/251
index 4126f15..d88c48b 100755
--- a/tests/generic/251
+++ b/tests/generic/251
@@ -89,7 +89,7 @@ _guess_max_minlen()
 fstrim_loop()
 {
 	trap "_destroy_fstrim; exit \$status" 2 15
-	fsize=$(df | grep $SCRATCH_MNT | grep $SCRATCH_DEV  | awk '{print $2}')
+	fsize=$($DF_PROG | grep $SCRATCH_MNT | grep $SCRATCH_DEV  | awk '{print $3}')
 	mmlen=$(_guess_max_minlen)
 
 	while true ; do
diff --git a/tests/generic/260 b/tests/generic/260
index dc8b822..2150cb0 100755
--- a/tests/generic/260
+++ b/tests/generic/260
@@ -48,7 +48,7 @@ _scratch_mount
 
 _test_batched_discard $SCRATCH_MNT || _notrun "FITRIM not supported on $SCRATCH_DEV"
 
-fssize=$(df -k | grep "$SCRATCH_MNT" | grep "$SCRATCH_DEV"  | awk '{print $2}')
+fssize=$($DF_PROG -k | grep "$SCRATCH_MNT" | grep "$SCRATCH_DEV"  | awk '{print $3}')
 
 beyond_eofs=$(_math "$fssize*2048")
 max_64bit=$(_math "2^64 - 1")
diff --git a/tests/generic/273 b/tests/generic/273
index d149808..4caa109 100755
--- a/tests/generic/273
+++ b/tests/generic/273
@@ -68,7 +68,7 @@ _file_create()
 
 	cd $SCRATCH_MNT/origin
 
-	_disksize=`df --block-size=1 $SCRATCH_DEV | awk -v sd=$SCRATCH_DEV 'BEGIN{c=0}{for(i=1;i<=NF;++i){a[c]=$i;++c}}END{for(entry in a){if(a[entry] ~ sd){print a[entry + 3]; break}}}'`
+	_disksize=`$DF_PROG --block-size=1 $SCRATCH_DEV | awk -v sd=$SCRATCH_DEV 'BEGIN{c=0}{for(i=1;i<=NF;++i){a[c]=$i;++c}}END{for(entry in a){if(a[entry] ~ sd){print a[entry + 3]; break}}}'`
 	_disksize=$(($_disksize / 3))
 	_num=$(($_disksize / $count / $threads / 4096))
 	_count=$count
diff --git a/tests/generic/275 b/tests/generic/275
index f83a644..7382edb 100755
--- a/tests/generic/275
+++ b/tests/generic/275
@@ -69,14 +69,14 @@ sync
 dd if=/dev/zero of=$SCRATCH_MNT/tmp4 bs=4K oflag=sync >>$seqres.full 2>&1
 # Save space usage info to the full file
 echo "Pre rm space:" >> $seqres.full
-df $SCRATCH_MNT >>$seqres.full 2>&1
+$DF_PROG $SCRATCH_MNT >>$seqres.full 2>&1
 
 # Should leave approx 256k free
 rm -f $SCRATCH_MNT/tmp1
 sync
 echo "Post rm space:" >> $seqres.full
-df $SCRATCH_MNT >>$seqres.full 2>&1
-_freespace=`df -k $SCRATCH_MNT | tail -n 1 | awk '{print $4}'`
+$DF_PROG $SCRATCH_MNT >>$seqres.full 2>&1
+_freespace=`$DF_PROG -k $SCRATCH_MNT | tail -n 1 | awk '{print $5}'`
 [ $_freespace -gt 1024 ] && _fail "could not sufficiently fill filesystem"
 
 # Try a write larger than available space
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
