Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D4F687F4C
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 11:40:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B1821304043
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 09:40:12 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id HJmKStIpjDseXBWF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Apr 2013 09:40:08 -0700 (PDT)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 17 Apr 2013 12:40:04 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 39B9038C809E
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 12:39:42 -0400 (EDT)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r3HGdcnV249270 for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 12:39:42 -0400
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r3HGf5Lp021815
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 10:41:05 -0600
Received: from [9.41.106.170] (chandra-dt.austin.ibm.com [9.41.106.170])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	r3HGf5dj021790 for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 10:41:05 -0600
Subject: [PATCH] xfstests: replace xfs_check with xfs_repair -n
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Wed, 17 Apr 2013 11:38:15 -0500
Message-ID: <1366216695.3762.32325.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

Replace the usage of "xfs_check" with "xfs_repair -n" as xfs_check
is planned to be depracated.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---

diff --git a/common/config b/common/config
index bf62996..dfbb5c2 100644
--- a/common/config
+++ b/common/config
@@ -154,7 +154,6 @@ export DF_PROG="`set_prog_path df`"
 
 export XFS_LOGPRINT_PROG="`set_prog_path xfs_logprint`"
 export XFS_REPAIR_PROG="`set_prog_path xfs_repair`"
-export XFS_CHECK_PROG="`set_prog_path xfs_check`"
 export XFS_DB_PROG="`set_prog_path xfs_db`"
 export XFS_GROWFS_PROG=`set_prog_path xfs_growfs`
 export XFS_IO_PROG="`set_prog_path xfs_io`"
diff --git a/common/rc b/common/rc
index 09fb83f..32a852f 100644
--- a/common/rc
+++ b/common/rc
@@ -166,7 +166,6 @@ case "$FSTYP" in
     xfs)
 	 [ "$XFS_LOGPRINT_PROG" = "" ] && _fatal "xfs_logprint not found"
 	 [ "$XFS_REPAIR_PROG" = "" ] && _fatal "xfs_repair not found"
-	 [ "$XFS_CHECK_PROG" = "" ] && _fatal "xfs_check not found"
 	 [ "$XFS_DB_PROG" = "" ] && _fatal "xfs_db not found"
 	 [ "$MKFS_XFS_PROG" = "" ] && _fatal "mkfs_xfs not found"
 	 ;;
@@ -589,7 +588,7 @@ _scratch_xfs_check()
         SCRATCH_OPTIONS="-l $SCRATCH_LOGDEV"
     [ "$LARGE_SCRATCH_DEV" = yes ] && \
         SCRATCH_OPTIONS=$SCRATCH_OPTIONS" -t"
-    $XFS_CHECK_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV
+    $XFS_REPAIR_PROG -n $SCRATCH_OPTIONS $* $SCRATCH_DEV &>/dev/null
 }
 
 _scratch_xfs_repair()
@@ -1422,25 +1421,6 @@ _check_xfs_filesystem()
         ok=0
     fi
 
-    # xfs_check runs out of memory on large files, so even providing the test
-    # option (-t) to avoid indexing the free space trees doesn't make it pass on
-    # large filesystems. Avoid it.
-    if [ "$LARGE_SCRATCH_DEV" != yes ]; then
-	    $XFS_CHECK_PROG $extra_log_options $device 2>&1 |\
-		 _fix_malloc >$tmp.fs_check
-    fi
-    if [ -s $tmp.fs_check ]
-    then
-        echo "_check_xfs_filesystem: filesystem on $device is inconsistent (c) (see $seqres.full)"
-
-        echo "_check_xfs_filesystem: filesystem on $device is inconsistent" >>$seqres.full
-        echo "*** xfs_check output ***"		>>$seqres.full
-        cat $tmp.fs_check			>>$seqres.full
-        echo "*** end xfs_check output"		>>$seqres.full
-
-        ok=0
-    fi
-
     $XFS_REPAIR_PROG -n $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
     if [ $? -ne 0 ]
     then
diff --git a/crash/xfscrash b/crash/xfscrash
index 7831d7e..6437d54 100755
--- a/crash/xfscrash
+++ b/crash/xfscrash
@@ -119,12 +119,11 @@ _check()
     
     if [ $expect -eq 0 ]
     then
-        _echo "      *** xfs_check ($LOG/check_clean.out)"   
-        xfs_check $TEST_DEV &> $LOG/check_clean.out || fail=1
-        [ -s /tmp/xfs_check_clean.out ] && fail=1
+        _echo "      *** Running xfs_repair -n ($LOG/check_clean.out)"   
+        xfs_repair -n $TEST_DEV &> $LOG/check_clean.out && fail=1
     else
-        _echo "      *** xfs_check ($LOG/check_dirty.out)"   
-        xfs_check $TEST_DEV &> $LOG/check_dirty.out || fail=1
+        _echo "      *** Running xfs_repair -n ($LOG/check_dirty.out)"   
+        xfs_repair -n $TEST_DEV &> $LOG/check_dirty.out || fail=1
     fi
     
     if [ $fail -eq 0 -a $expect -eq 0 ]
diff --git a/tests/xfs/017 b/tests/xfs/017
index 9fc16c2..03f907e 100755
--- a/tests/xfs/017
+++ b/tests/xfs/017
@@ -83,7 +83,7 @@ do
         echo "*** XFS_CHECK ***"            >>$seqres.full
         echo ""                             >>$seqres.full
         _scratch_xfs_check                  >>$seqres.full 2>&1 \
-            || _fail "xfs_check failed"
+            || _fail "xfs check failed"
         _scratch_mount -o remount,rw \
             || _fail "remount rw failed"
 done
diff --git a/tests/xfs/085 b/tests/xfs/085
index 27f29a3..02c6703 100755
--- a/tests/xfs/085
+++ b/tests/xfs/085
@@ -70,7 +70,7 @@ _print_logstate
 
 # curious if FS consistent at start
 if false; then
-    if $XFS_CHECK_PROG $SCRATCH_DEV; then
+    if $XFS_REPAIR_PROG -n $SCRATCH_DEV &>/dev/null; then
        echo "*** checked ok ***"
     fi
 fi
diff --git a/tests/xfs/291 b/tests/xfs/291
old mode 100644
new mode 100755
index f842679..dc3c342
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -111,9 +111,9 @@ for I in `seq 1 2 5000`; do
 done
 
 _scratch_unmount
-# Can xfs_repair and xfs_check cope with this monster?
+# Can xfs_repair and check cope with this monster?
 _scratch_xfs_repair >> $seqres.full 2>&1 || _fail "xfs_repair failed"
-xfs_check $SCRATCH_DEV >> $seqres.full 2>&1 || _fail "xfs_check failed"
+xfs_repair -n $SCRATCH_DEV >> $seqres.full 2>&1 || _fail "xfs_repair -n failed"
 
 # Yes they can!  Now...
 # Can xfs_metadump cope with this monster?


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
