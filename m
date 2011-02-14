Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1EGfoE1143344 for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 10:41:50 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E50B1EAF827
	for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 08:44:27 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zp0P0Y51vCy7HBj3 for
	<xfs@oss.sgi.com>; Mon, 14 Feb 2011 08:44:27 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1EGiRNf008844
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 11:44:27 -0500
Received: from segfault.boston.devel.redhat.com
	(segfault.boston.devel.redhat.com [10.16.60.26])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p1EGiQIw017242
	for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 11:44:26 -0500
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch][xfstests-dev] 091: fix up output when pagesize == sectorsize
Date: Mon, 14 Feb 2011 11:44:25 -0500
Message-ID: <x49ipwmlg5y.fsf@segfault.boston.devel.redhat.com>
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

Hi,

It looks like test 091 is supposed to work on 2.4 kernels, but there's
no way it will.  Checking the actual blocksize and pagesize in the
run_fsx routine, and substituting them for BSIZE and PSIZE is error
prone when the two hold the same value.  This is also a problem for 4k
sector devices.  It's better to pass in what we want (PSIZE or BSIZE)
and then convert that to the command line options that fsx wants in the
run_fsx routine.  This gets rid of the bogus test failure in my
environment.  Also, the setting of bsize for linux-2.6 was redundant, so
I got rid of it.  Comments are appreciated.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/091 b/091
index 6c4566f..a13d979 100755
--- a/091
+++ b/091
@@ -46,9 +46,10 @@ rm -f $seq.full
 
 run_fsx()
 {
-	echo fsx $@ | tee -a $seq.full | sed -e "s/ $bsize / BSIZE /g" -e "s/ $psize / PSIZE /g"
+	echo fsx $@ | tee -a $seq.full
+	args=`echo $@ | sed -e "s/ BSIZE / $bsize /g" -e "s/ PSIZE / $psize /g"`
 	rm -f $TEST_DIR/junk
-	$here/ltp/fsx $@ $TEST_DIR/junk >>$seq.full 2>&1
+	$here/ltp/fsx $args $TEST_DIR/junk >>$seq.full 2>&1
 	if [ $? -ne 0 ]; then
 		cat $seq.full
 		exit 1
@@ -56,21 +57,12 @@ run_fsx()
 }
 
 psize=`$here/src/feature -s`
-bsize=512
+bsize=`blockdev --getss $TEST_DEV`
 kernel=`uname -r  | sed -e 's/\(2\..\).*/\1/'`
 
 # 2.4 Linux kernels support bsize aligned direct I/O only
 [ "$HOSTOS" = "Linux" -a "$kernel" = "2.4" ] && bsize=$psize
 
-# 2.6 Linux kernels support sector aligned direct I/O only
-if [ "$HOSTOS" = "Linux" -a "$kernel" = "2.6" ]; then
-	xfs_info $TEST_DIR | _filter_mkfs 2> $tmp.info > /dev/null
-	if [ $? -eq 0 ]; then
-		source $tmp.info
-		bsize=$sectsz
-	fi
-fi
-
 # fsx usage:
 # 
 # -N numops: total # operations to do 
@@ -85,16 +77,16 @@ fi
 # -W: mapped write operations DISabled
 
 #run_fsx -N 10000            -l 500000 -r $psize -t $psize -w $psize -Z -R -W
- run_fsx -N 10000            -l 500000 -r $psize -t $bsize -w $bsize -Z -R -W
- run_fsx -N 10000  -o 8192   -l 500000 -r $psize -t $bsize -w $bsize -Z -R -W
-#run_fsx -N 10000  -o 16384  -l 500000 -r $psize -t $psize -w $psize -Z -R -W
- run_fsx -N 10000  -o 32768  -l 500000 -r $psize -t $bsize -w $bsize -Z -R -W
-#run_fsx -N 10000  -o 128000 -l 500000 -r $psize -t $psize -w $psize -Z -R -W
- run_fsx -N 10000  -o 8192   -l 500000 -r $psize -t $bsize -w $bsize -Z -R -W
-#run_fsx -N 10000  -o 16384  -l 500000 -r $psize -t $psize -w $psize -Z -R -W
- run_fsx -N 10000  -o 32768  -l 500000 -r $psize -t $bsize -w $bsize -Z -R -W
-#run_fsx -N 10000  -o 128000 -l 500000 -r $psize -t $psize -w $psize -Z -W
- run_fsx -N 10000  -o 128000 -l 500000 -r $psize -t $bsize -w $bsize -Z -W
+ run_fsx -N 10000            -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
+ run_fsx -N 10000  -o 8192   -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
+#run_fsx -N 10000  -o 16384  -l 500000 -r PSIZE -t PSIZE -w PSIZE -Z -R -W
+ run_fsx -N 10000  -o 32768  -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
+#run_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t PSIZE -w PSIZE -Z -R -W
+ run_fsx -N 10000  -o 8192   -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
+#run_fsx -N 10000  -o 16384  -l 500000 -r PSIZE -t PSIZE -w PSIZE -Z -R -W
+ run_fsx -N 10000  -o 32768  -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
+#run_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t PSIZE -w PSIZE -Z -W
+ run_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
 
 # Commented out calls above are less likely to pick up issues, so
 # save time by commenting them out (leave 'em for manual testing).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
