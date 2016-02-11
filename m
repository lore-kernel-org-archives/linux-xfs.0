Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0F37D7CA3
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:39:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F23048F8052
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:39:57 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id To1ZcK6X4GqvyG6d (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:39:52 -0800 (PST)
Subject: [PATCH 05/32] reflink: remove unnecessary umounts from test code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:39:49 -0800
Message-ID: <20160211233949.2202.99446.stgit@birch.djwong.org>
In-Reply-To: <20160211233916.2202.40961.stgit@birch.djwong.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

The test harness already takes care of this, so get rid of it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/157     |    3 ---
 tests/generic/157.out |    1 -
 tests/generic/158     |    3 ---
 tests/generic/158.out |    1 -
 tests/generic/161     |    4 ----
 tests/generic/161.out |    2 --
 tests/generic/162     |    4 ----
 tests/generic/162.out |    2 --
 tests/generic/163     |    4 ----
 tests/generic/163.out |    2 --
 tests/generic/164     |    4 ----
 tests/generic/164.out |    2 --
 tests/generic/165     |    4 ----
 tests/generic/165.out |    2 --
 tests/generic/166     |    5 -----
 tests/generic/166.out |    2 --
 tests/generic/167     |    5 -----
 tests/generic/167.out |    2 --
 tests/generic/168     |    5 -----
 tests/generic/168.out |    2 --
 tests/generic/170     |    5 -----
 tests/generic/170.out |    2 --
 tests/generic/171     |    6 ------
 tests/generic/171.out |    1 -
 tests/generic/172     |    6 ------
 tests/generic/172.out |    1 -
 tests/generic/173     |    6 ------
 tests/generic/173.out |    1 -
 tests/generic/174     |    6 ------
 tests/generic/174.out |    1 -
 tests/generic/183     |    3 ---
 tests/generic/183.out |    1 -
 tests/generic/185     |    3 ---
 tests/generic/185.out |    1 -
 tests/generic/186     |    3 ---
 tests/generic/186.out |    1 -
 tests/generic/187     |    3 ---
 tests/generic/187.out |    1 -
 tests/generic/188     |    3 ---
 tests/generic/188.out |    1 -
 tests/generic/189     |    3 ---
 tests/generic/189.out |    1 -
 tests/generic/190     |    3 ---
 tests/generic/190.out |    1 -
 tests/generic/191     |    3 ---
 tests/generic/191.out |    1 -
 tests/generic/194     |    3 ---
 tests/generic/194.out |    1 -
 tests/generic/195     |    3 ---
 tests/generic/195.out |    1 -
 tests/generic/196     |    3 ---
 tests/generic/196.out |    1 -
 tests/generic/197     |    3 ---
 tests/generic/197.out |    1 -
 tests/generic/199     |    3 ---
 tests/generic/199.out |    1 -
 tests/generic/200     |    3 ---
 tests/generic/200.out |    1 -
 tests/generic/201     |    3 ---
 tests/generic/201.out |    1 -
 tests/generic/202     |    3 ---
 tests/generic/202.out |    1 -
 tests/generic/203     |    3 ---
 tests/generic/203.out |    1 -
 tests/generic/205     |    3 ---
 tests/generic/205.out |    1 -
 tests/generic/206     |    3 ---
 tests/generic/206.out |    1 -
 tests/generic/216     |    3 ---
 tests/generic/216.out |    1 -
 tests/generic/217     |    3 ---
 tests/generic/217.out |    1 -
 tests/generic/218     |    3 ---
 tests/generic/218.out |    1 -
 tests/generic/220     |    3 ---
 tests/generic/220.out |    1 -
 tests/generic/222     |    3 ---
 tests/generic/222.out |    1 -
 tests/generic/227     |    3 ---
 tests/generic/227.out |    1 -
 tests/generic/229     |    3 ---
 tests/generic/229.out |    1 -
 tests/generic/238     |    3 ---
 tests/generic/238.out |    1 -
 tests/generic/242     |    3 ---
 tests/generic/242.out |    1 -
 tests/generic/243     |    3 ---
 tests/generic/243.out |    1 -
 tests/xfs/127         |    3 ---
 tests/xfs/127.out     |    1 -
 tests/xfs/128         |    3 ---
 tests/xfs/128.out     |    1 -
 tests/xfs/131         |    3 ---
 tests/xfs/131.out     |    1 -
 tests/xfs/139         |    3 ---
 tests/xfs/139.out     |    1 -
 tests/xfs/140         |    3 ---
 tests/xfs/140.out     |    1 -
 98 files changed, 230 deletions(-)


diff --git a/tests/generic/157 b/tests/generic/157
index 74314d8..19a9a18 100755
--- a/tests/generic/157
+++ b/tests/generic/157
@@ -121,9 +121,6 @@ echo "Reflink two files"
 _reflink_range "$testdir1/file1" 0 "$testdir1/file2" 0 $blksz >> "$seqres.full"
 _reflink_range "$testdir2/file1" 0 "$testdir2/file2" 0 $blksz >> "$seqres.full"
 
-echo "Check scratch fs"
-_scratch_unmount
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/157.out b/tests/generic/157.out
index ac3c440..d4f64b4 100644
--- a/tests/generic/157.out
+++ b/tests/generic/157.out
@@ -22,4 +22,3 @@ XFS_IOC_CLONE_RANGE: Invalid argument
 Try to reflink an append-only file
 XFS_IOC_CLONE_RANGE: Bad file descriptor
 Reflink two files
-Check scratch fs
diff --git a/tests/generic/158 b/tests/generic/158
index 779d55e..4b51973 100755
--- a/tests/generic/158
+++ b/tests/generic/158
@@ -122,9 +122,6 @@ echo "Dedupe two files"
 _dedupe_range "$testdir1/file1" 0 "$testdir1/file2" 0 $blksz >> "$seqres.full"
 _dedupe_range "$testdir2/file1" 0 "$testdir2/file2" 0 $blksz >> "$seqres.full"
 
-echo "Check scratch fs"
-_scratch_unmount
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/158.out b/tests/generic/158.out
index dff3692..7f88403 100644
--- a/tests/generic/158.out
+++ b/tests/generic/158.out
@@ -21,4 +21,3 @@ Try to dedupe to a fifo
 dedupe: Invalid argument
 Try to dedupe an append-only file
 Dedupe two files
-Check scratch fs
diff --git a/tests/generic/161 b/tests/generic/161
index b271936..1d5364e 100755
--- a/tests/generic/161
+++ b/tests/generic/161
@@ -69,10 +69,6 @@ rm -rf "$testdir/file1" &
 _pwrite_byte 0x62 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
 wait
 
-echo "Check fs"
-umount "$SCRATCH_MNT"
-
-echo "Done"
 # success, all done
 status=0
 exit
diff --git a/tests/generic/161.out b/tests/generic/161.out
index 1db11c3..34cb6f2 100644
--- a/tests/generic/161.out
+++ b/tests/generic/161.out
@@ -2,5 +2,3 @@ QA output created by 161
 Format and mount
 Initialize files
 Delete while rewriting
-Check fs
-Done
diff --git a/tests/generic/162 b/tests/generic/162
index 30c761b..9044545 100755
--- a/tests/generic/162
+++ b/tests/generic/162
@@ -85,10 +85,6 @@ echo "Finished dedupeing"
 touch "$testdir/finished"
 wait
 
-echo "Check fs"
-umount "$SCRATCH_MNT"
-
-echo "Done"
 # success, all done
 status=0
 exit
diff --git a/tests/generic/162.out b/tests/generic/162.out
index 4481f8c..e57db12 100644
--- a/tests/generic/162.out
+++ b/tests/generic/162.out
@@ -3,5 +3,3 @@ Format and mount
 Initialize files
 Dedupe and rewrite the file!
 Finished dedupeing
-Check fs
-Done
diff --git a/tests/generic/163 b/tests/generic/163
index f2ea334..651d445 100755
--- a/tests/generic/163
+++ b/tests/generic/163
@@ -85,10 +85,6 @@ echo "Finished dedupeing"
 touch "$testdir/finished"
 wait
 
-echo "Check fs"
-umount "$SCRATCH_MNT"
-
-echo "Done"
 # success, all done
 status=0
 exit
diff --git a/tests/generic/163.out b/tests/generic/163.out
index 2d27d1b..604e53b 100644
--- a/tests/generic/163.out
+++ b/tests/generic/163.out
@@ -3,5 +3,3 @@ Format and mount
 Initialize files
 Dedupe and rewrite the file!
 Finished dedupeing
-Check fs
-Done
diff --git a/tests/generic/164 b/tests/generic/164
index e97ac13..6c19c7d 100755
--- a/tests/generic/164
+++ b/tests/generic/164
@@ -95,10 +95,6 @@ echo "Finished reflinking"
 touch "$testdir/finished"
 wait
 
-echo "Check fs"
-umount "$SCRATCH_MNT"
-
-echo "Done"
 # success, all done
 status=0
 exit
diff --git a/tests/generic/164.out b/tests/generic/164.out
index 0b4ed70..f4ff869 100644
--- a/tests/generic/164.out
+++ b/tests/generic/164.out
@@ -3,5 +3,3 @@ Format and mount
 Initialize files
 Reflink and reread the files!
 Finished reflinking
-Check fs
-Done
diff --git a/tests/generic/165 b/tests/generic/165
index b305079..2e380a9 100755
--- a/tests/generic/165
+++ b/tests/generic/165
@@ -95,10 +95,6 @@ echo "Finished reflinking"
 touch "$testdir/finished"
 wait
 
-echo "Check fs"
-umount "$SCRATCH_MNT"
-
-echo "Done"
 # success, all done
 status=0
 exit
diff --git a/tests/generic/165.out b/tests/generic/165.out
index a89071d..31e9bef 100644
--- a/tests/generic/165.out
+++ b/tests/generic/165.out
@@ -3,5 +3,3 @@ Format and mount
 Initialize files
 Reflink and dio reread the files!
 Finished reflinking
-Check fs
-Done
diff --git a/tests/generic/166 b/tests/generic/166
index 2c2ff4e..028ee11 100755
--- a/tests/generic/166
+++ b/tests/generic/166
@@ -82,11 +82,6 @@ done
 touch $testdir/finished
 wait
 
-echo "Check for damage"
-_scratch_unmount
-
-echo "Done"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/166.out b/tests/generic/166.out
index a2ba34e..8cb81a0 100644
--- a/tests/generic/166.out
+++ b/tests/generic/166.out
@@ -2,5 +2,3 @@ QA output created by 166
 Format and mount
 Initialize file
 Snapshot a file undergoing directio rewrite
-Check for damage
-Done
diff --git a/tests/generic/167 b/tests/generic/167
index b80b481..a4bf4f4 100755
--- a/tests/generic/167
+++ b/tests/generic/167
@@ -82,11 +82,6 @@ done
 touch $testdir/finished
 wait
 
-echo "Check for damage"
-_scratch_unmount
-
-echo "Done"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/167.out b/tests/generic/167.out
index 7cfb14e..a0e90b1 100644
--- a/tests/generic/167.out
+++ b/tests/generic/167.out
@@ -2,5 +2,3 @@ QA output created by 167
 Format and mount
 Initialize file
 Snapshot a file undergoing buffered rewrite
-Check for damage
-Done
diff --git a/tests/generic/168 b/tests/generic/168
index 0d620da..2ffc5b6 100755
--- a/tests/generic/168
+++ b/tests/generic/168
@@ -86,11 +86,6 @@ done
 touch "$testdir/finished"
 wait
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
-echo "Done"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/168.out b/tests/generic/168.out
index d0dd08e..2687e7c 100644
--- a/tests/generic/168.out
+++ b/tests/generic/168.out
@@ -2,5 +2,3 @@ QA output created by 168
 Format and mount
 Initialize files
 Reflink and write the target
-Check for damage
-Done
diff --git a/tests/generic/170 b/tests/generic/170
index 78ed63d..2a81cad 100755
--- a/tests/generic/170
+++ b/tests/generic/170
@@ -86,11 +86,6 @@ done
 touch "$testdir/finished"
 wait
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
-echo "Done"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/170.out b/tests/generic/170.out
index 103aaa5..debd6ca 100644
--- a/tests/generic/170.out
+++ b/tests/generic/170.out
@@ -2,5 +2,3 @@ QA output created by 170
 Format and mount
 Initialize files
 Reflink and dio write the target
-Check for damage
-Done
diff --git a/tests/generic/171 b/tests/generic/171
index 4b4f141..d865f64 100755
--- a/tests/generic/171
+++ b/tests/generic/171
@@ -95,12 +95,6 @@ echo "${out}" | grep -q "No space left on device" || echo "CoW should have faile
 echo "${out}" >> "$seqres.full" 2>&1
 echo "${out}"
 
-#filefrag -v $testdir/bigfile
-#filefrag -v $testdir/clonefile
-
-echo "Check scratch fs"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/171.out b/tests/generic/171.out
index c2b0ddd..a999eb0 100644
--- a/tests/generic/171.out
+++ b/tests/generic/171.out
@@ -7,4 +7,3 @@ CoW the big file
 pwrite64: No space left on device
 Remount and try CoW again
 pwrite64: No space left on device
-Check scratch fs
diff --git a/tests/generic/172 b/tests/generic/172
index 98eb97f..e6020f1 100755
--- a/tests/generic/172
+++ b/tests/generic/172
@@ -95,12 +95,6 @@ echo "${out}" | grep -q "No space left on device" || echo "CoW should have faile
 echo "${out}" >> "$seqres.full" 2>&1
 echo "${out}"
 
-#filefrag -v $testdir/bigfile
-#filefrag -v $testdir/clonefile
-
-echo "Check scratch fs"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/172.out b/tests/generic/172.out
index 3913dd7..4d3f710 100644
--- a/tests/generic/172.out
+++ b/tests/generic/172.out
@@ -7,4 +7,3 @@ CoW the big file
 pwrite64: No space left on device
 Remount and try CoW again
 pwrite64: No space left on device
-Check scratch fs
diff --git a/tests/generic/173 b/tests/generic/173
index e26f5a9..61c6b32 100755
--- a/tests/generic/173
+++ b/tests/generic/173
@@ -97,12 +97,6 @@ if [ "$err" -lt 128 ]; then
 	echo "mmap CoW should have failed with SIGBUS, got SIG$(kill -l $err)"
 fi
 
-#filefrag -v $testdir/bigfile
-#filefrag -v $testdir/clonefile
-
-echo "Check scratch fs"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/173.out b/tests/generic/173.out
index 49abb17..5235548 100644
--- a/tests/generic/173.out
+++ b/tests/generic/173.out
@@ -5,4 +5,3 @@ Create a big file and reflink it
 Allocate the rest of the space
 mmap CoW the big file
 Remount and try CoW again
-Check scratch fs
diff --git a/tests/generic/174 b/tests/generic/174
index 1749a1c..dd6fe5a 100755
--- a/tests/generic/174
+++ b/tests/generic/174
@@ -95,12 +95,6 @@ echo "${out}" | grep -q "No space left on device" || echo "CoW should have faile
 echo "${out}" >> "$seqres.full" 2>&1
 echo "${out}"
 
-#filefrag -v $testdir/bigfile
-#filefrag -v $testdir/clonefile
-
-echo "Check scratch fs"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/174.out b/tests/generic/174.out
index 702d067..1490ca4 100644
--- a/tests/generic/174.out
+++ b/tests/generic/174.out
@@ -7,4 +7,3 @@ CoW the big file
 pwrite64: No space left on device
 Remount and try CoW again
 pwrite64: No space left on device
-Check scratch fs
diff --git a/tests/generic/183 b/tests/generic/183
index 27179fd..c928acd 100755
--- a/tests/generic/183
+++ b/tests/generic/183
@@ -92,9 +92,6 @@ md5sum "$testdir/file2" | _filter_scratch
 md5sum "$testdir/file3" | _filter_scratch
 md5sum "$testdir/file3.chk" | _filter_scratch
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/183.out b/tests/generic/183.out
index e5d0322..b777908 100644
--- a/tests/generic/183.out
+++ b/tests/generic/183.out
@@ -12,4 +12,3 @@ bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-183/file1
 b83f9394092e15bdcda585cd8e776dc6  SCRATCH_MNT/test-183/file2
 55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-183/file3
 55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-183/file3.chk
-Check for damage
diff --git a/tests/generic/185 b/tests/generic/185
index 368260d..fb05e6d 100755
--- a/tests/generic/185
+++ b/tests/generic/185
@@ -92,9 +92,6 @@ md5sum "$testdir/file2" | _filter_scratch
 md5sum "$testdir/file3" | _filter_scratch
 md5sum "$testdir/file3.chk" | _filter_scratch
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/185.out b/tests/generic/185.out
index e505c90..4d1839a 100644
--- a/tests/generic/185.out
+++ b/tests/generic/185.out
@@ -12,4 +12,3 @@ bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-185/file1
 b83f9394092e15bdcda585cd8e776dc6  SCRATCH_MNT/test-185/file2
 55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-185/file3
 55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-185/file3.chk
-Check for damage
diff --git a/tests/generic/186 b/tests/generic/186
index 67e52b5..e495cbc 100755
--- a/tests/generic/186
+++ b/tests/generic/186
@@ -137,9 +137,6 @@ md5sum "$testdir/file2" | _filter_scratch
 md5sum "$testdir/file3" | _filter_scratch
 md5sum "$testdir/file3.chk" | _filter_scratch
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/186.out b/tests/generic/186.out
index adfae9c..961673a 100644
--- a/tests/generic/186.out
+++ b/tests/generic/186.out
@@ -12,4 +12,3 @@ Compare files
 35219c511215d00a857243965ea5ed9c  SCRATCH_MNT/test-186/file2
 1801718b8daeb8d3ad4900bd9137b3e8  SCRATCH_MNT/test-186/file3
 1801718b8daeb8d3ad4900bd9137b3e8  SCRATCH_MNT/test-186/file3.chk
-Check for damage
diff --git a/tests/generic/187 b/tests/generic/187
index c993394..e3461ab 100755
--- a/tests/generic/187
+++ b/tests/generic/187
@@ -137,9 +137,6 @@ md5sum "$testdir/file2" | _filter_scratch
 md5sum "$testdir/file3" | _filter_scratch
 md5sum "$testdir/file3.chk" | _filter_scratch
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/187.out b/tests/generic/187.out
index a3c05a5..8ad56f8 100644
--- a/tests/generic/187.out
+++ b/tests/generic/187.out
@@ -12,4 +12,3 @@ Compare files
 35219c511215d00a857243965ea5ed9c  SCRATCH_MNT/test-187/file2
 1801718b8daeb8d3ad4900bd9137b3e8  SCRATCH_MNT/test-187/file3
 1801718b8daeb8d3ad4900bd9137b3e8  SCRATCH_MNT/test-187/file3.chk
-Check for damage
diff --git a/tests/generic/188 b/tests/generic/188
index 9e63388..7596c4b 100755
--- a/tests/generic/188
+++ b/tests/generic/188
@@ -87,9 +87,6 @@ md5sum "$testdir/file1" | _filter_scratch
 md5sum "$testdir/file3" | _filter_scratch
 md5sum "$testdir/file3.chk" | _filter_scratch
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/188.out b/tests/generic/188.out
index 135e69c..904f383 100644
--- a/tests/generic/188.out
+++ b/tests/generic/188.out
@@ -10,4 +10,3 @@ Compare files
 bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-188/file1
 09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-188/file3
 09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-188/file3.chk
-Check for damage
diff --git a/tests/generic/189 b/tests/generic/189
index 661129c..130dc58 100755
--- a/tests/generic/189
+++ b/tests/generic/189
@@ -87,9 +87,6 @@ md5sum "$testdir/file1" | _filter_scratch
 md5sum "$testdir/file3" | _filter_scratch
 md5sum "$testdir/file3.chk" | _filter_scratch
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/189.out b/tests/generic/189.out
index ce868bd..feff605 100644
--- a/tests/generic/189.out
+++ b/tests/generic/189.out
@@ -10,4 +10,3 @@ Compare files
 bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-189/file1
 09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-189/file3
 09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-189/file3.chk
-Check for damage
diff --git a/tests/generic/190 b/tests/generic/190
index 4e272c2..0171475 100755
--- a/tests/generic/190
+++ b/tests/generic/190
@@ -87,9 +87,6 @@ md5sum "$testdir/file1" | _filter_scratch
 md5sum "$testdir/file3" | _filter_scratch
 md5sum "$testdir/file3.chk" | _filter_scratch
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/190.out b/tests/generic/190.out
index abe5d89..ad8ecb0 100644
--- a/tests/generic/190.out
+++ b/tests/generic/190.out
@@ -10,4 +10,3 @@ Compare files
 bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-190/file1
 09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-190/file3
 09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-190/file3.chk
-Check for damage
diff --git a/tests/generic/191 b/tests/generic/191
index 5aadded..34d96f9 100755
--- a/tests/generic/191
+++ b/tests/generic/191
@@ -87,9 +87,6 @@ md5sum "$testdir/file1" | _filter_scratch
 md5sum "$testdir/file3" | _filter_scratch
 md5sum "$testdir/file3.chk" | _filter_scratch
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/191.out b/tests/generic/191.out
index 8116eab..1b5e175 100644
--- a/tests/generic/191.out
+++ b/tests/generic/191.out
@@ -10,4 +10,3 @@ Compare files
 bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-191/file1
 09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-191/file3
 09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-191/file3.chk
-Check for damage
diff --git a/tests/generic/194 b/tests/generic/194
index a17debc..e9feaad 100755
--- a/tests/generic/194
+++ b/tests/generic/194
@@ -92,9 +92,6 @@ md5sum "$testdir/file1" | _filter_scratch
 md5sum "$testdir/file3" | _filter_scratch
 md5sum "$testdir/file3.chk" | _filter_scratch
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/194.out b/tests/generic/194.out
index fdfda23..d370b4c 100644
--- a/tests/generic/194.out
+++ b/tests/generic/194.out
@@ -10,4 +10,3 @@ Compare files
 bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-194/file1
 55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-194/file3
 55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-194/file3.chk
-Check for damage
diff --git a/tests/generic/195 b/tests/generic/195
index f49d0c2..32548ba 100755
--- a/tests/generic/195
+++ b/tests/generic/195
@@ -92,9 +92,6 @@ md5sum "$testdir/file1" | _filter_scratch
 md5sum "$testdir/file3" | _filter_scratch
 md5sum "$testdir/file3.chk" | _filter_scratch
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/195.out b/tests/generic/195.out
index 9495058..8a6d760 100644
--- a/tests/generic/195.out
+++ b/tests/generic/195.out
@@ -10,4 +10,3 @@ Compare files
 bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-195/file1
 55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-195/file3
 55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-195/file3.chk
-Check for damage
diff --git a/tests/generic/196 b/tests/generic/196
index 4da9c76..4ec2cff 100755
--- a/tests/generic/196
+++ b/tests/generic/196
@@ -87,9 +87,6 @@ md5sum "$testdir/file1" | _filter_scratch
 md5sum "$testdir/file3" | _filter_scratch
 md5sum "$testdir/file3.chk" | _filter_scratch
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/196.out b/tests/generic/196.out
index 6ee052b..545b72b 100644
--- a/tests/generic/196.out
+++ b/tests/generic/196.out
@@ -10,4 +10,3 @@ Compare files
 bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-196/file1
 55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-196/file3
 55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-196/file3.chk
-Check for damage
diff --git a/tests/generic/197 b/tests/generic/197
index 54ee5ab..356a587 100755
--- a/tests/generic/197
+++ b/tests/generic/197
@@ -87,9 +87,6 @@ md5sum "$testdir/file1" | _filter_scratch
 md5sum "$testdir/file3" | _filter_scratch
 md5sum "$testdir/file3.chk" | _filter_scratch
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/197.out b/tests/generic/197.out
index bec294b..05edad9 100644
--- a/tests/generic/197.out
+++ b/tests/generic/197.out
@@ -10,4 +10,3 @@ Compare files
 bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-197/file1
 55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-197/file3
 55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-197/file3.chk
-Check for damage
diff --git a/tests/generic/199 b/tests/generic/199
index 5e4bca8..03b8fda 100755
--- a/tests/generic/199
+++ b/tests/generic/199
@@ -116,9 +116,6 @@ md5sum "$testdir/file1" | _filter_scratch
 md5sum "$testdir/file3" | _filter_scratch
 md5sum "$testdir/file3.chk" | _filter_scratch
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/199.out b/tests/generic/199.out
index 752742d..b35c135 100644
--- a/tests/generic/199.out
+++ b/tests/generic/199.out
@@ -10,4 +10,3 @@ Compare files
 bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-199/file1
 36f6b5317a9a921fc91175390ccf7f69  SCRATCH_MNT/test-199/file3
 36f6b5317a9a921fc91175390ccf7f69  SCRATCH_MNT/test-199/file3.chk
-Check for damage
diff --git a/tests/generic/200 b/tests/generic/200
index f0521ae..e71eedc 100755
--- a/tests/generic/200
+++ b/tests/generic/200
@@ -116,9 +116,6 @@ md5sum "$testdir/file1" | _filter_scratch
 md5sum "$testdir/file3" | _filter_scratch
 md5sum "$testdir/file3.chk" | _filter_scratch
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/200.out b/tests/generic/200.out
index e4ab7e0..140eff9 100644
--- a/tests/generic/200.out
+++ b/tests/generic/200.out
@@ -10,4 +10,3 @@ Compare files
 bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-200/file1
 36f6b5317a9a921fc91175390ccf7f69  SCRATCH_MNT/test-200/file3
 36f6b5317a9a921fc91175390ccf7f69  SCRATCH_MNT/test-200/file3.chk
-Check for damage
diff --git a/tests/generic/201 b/tests/generic/201
index db77a5e..90087ef 100755
--- a/tests/generic/201
+++ b/tests/generic/201
@@ -77,9 +77,6 @@ echo "CoW and unmount"
 "$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
 rm "$testdir/file3"
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/201.out b/tests/generic/201.out
index 80629b6..52669d2 100644
--- a/tests/generic/201.out
+++ b/tests/generic/201.out
@@ -6,4 +6,3 @@ bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-201/file1
 d3959a68638c50af07f0258e032cb554  SCRATCH_MNT/test-201/file3
 d3959a68638c50af07f0258e032cb554  SCRATCH_MNT/test-201/file3.chk
 CoW and unmount
-Check for damage
diff --git a/tests/generic/202 b/tests/generic/202
index 91f2d9b..e034e4e 100755
--- a/tests/generic/202
+++ b/tests/generic/202
@@ -77,9 +77,6 @@ md5sum "$testdir/file1" | _filter_scratch
 md5sum "$testdir/file2" | _filter_scratch
 md5sum "$testdir/file2.chk" | _filter_scratch
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/202.out b/tests/generic/202.out
index 8973abe..2dbd4b0 100644
--- a/tests/generic/202.out
+++ b/tests/generic/202.out
@@ -10,4 +10,3 @@ Compare files
 75f550706b7d54e6ae59a8220b532285  SCRATCH_MNT/test-202/file1
 7cd112044b63b2c979f45e7c1e7cc85f  SCRATCH_MNT/test-202/file2
 7cd112044b63b2c979f45e7c1e7cc85f  SCRATCH_MNT/test-202/file2.chk
-Check for damage
diff --git a/tests/generic/203 b/tests/generic/203
index 86a672b..2b6db7e 100755
--- a/tests/generic/203
+++ b/tests/generic/203
@@ -77,9 +77,6 @@ md5sum "$testdir/file1" | _filter_scratch
 md5sum "$testdir/file2" | _filter_scratch
 md5sum "$testdir/file2.chk" | _filter_scratch
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/203.out b/tests/generic/203.out
index 84ac0e8..ddde511 100644
--- a/tests/generic/203.out
+++ b/tests/generic/203.out
@@ -10,4 +10,3 @@ Compare files
 75f550706b7d54e6ae59a8220b532285  SCRATCH_MNT/test-203/file1
 227f44bb2dcf251ebf0217edaeb1e365  SCRATCH_MNT/test-203/file2
 227f44bb2dcf251ebf0217edaeb1e365  SCRATCH_MNT/test-203/file2.chk
-Check for damage
diff --git a/tests/generic/205 b/tests/generic/205
index 8fed955..8955e67 100755
--- a/tests/generic/205
+++ b/tests/generic/205
@@ -93,9 +93,6 @@ echo "Compare files"
 ! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
 cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/205.out b/tests/generic/205.out
index 1a22515..c65d1bd 100644
--- a/tests/generic/205.out
+++ b/tests/generic/205.out
@@ -4,4 +4,3 @@ Create the original files
 Compare files
 CoW and unmount
 Compare files
-Check for damage
diff --git a/tests/generic/206 b/tests/generic/206
index 10b5285..12ad745 100755
--- a/tests/generic/206
+++ b/tests/generic/206
@@ -93,9 +93,6 @@ echo "Compare files"
 ! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
 cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/206.out b/tests/generic/206.out
index 0b1ec60..38c7b09 100644
--- a/tests/generic/206.out
+++ b/tests/generic/206.out
@@ -4,4 +4,3 @@ Create the original files
 Compare files
 CoW and unmount
 Compare files
-Check for damage
diff --git a/tests/generic/216 b/tests/generic/216
index 671f0c1..3e0084e 100755
--- a/tests/generic/216
+++ b/tests/generic/216
@@ -94,9 +94,6 @@ echo "Compare files"
 ! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
 cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/216.out b/tests/generic/216.out
index 2d43c3a..85db001 100644
--- a/tests/generic/216.out
+++ b/tests/generic/216.out
@@ -4,4 +4,3 @@ Create the original files
 Compare files
 CoW and unmount
 Compare files
-Check for damage
diff --git a/tests/generic/217 b/tests/generic/217
index e4d40c7..3470d25 100755
--- a/tests/generic/217
+++ b/tests/generic/217
@@ -94,9 +94,6 @@ echo "Compare files"
 ! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
 cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/217.out b/tests/generic/217.out
index d8eb1be..bf8bb4f 100644
--- a/tests/generic/217.out
+++ b/tests/generic/217.out
@@ -4,4 +4,3 @@ Create the original files
 Compare files
 CoW and unmount
 Compare files
-Check for damage
diff --git a/tests/generic/218 b/tests/generic/218
index eb52fea..220cda3 100755
--- a/tests/generic/218
+++ b/tests/generic/218
@@ -88,9 +88,6 @@ echo "Compare files"
 ! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
 cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/218.out b/tests/generic/218.out
index 0173be0..0142747 100644
--- a/tests/generic/218.out
+++ b/tests/generic/218.out
@@ -4,4 +4,3 @@ Create the original files
 Compare files
 CoW and unmount
 Compare files
-Check for damage
diff --git a/tests/generic/220 b/tests/generic/220
index fb5ecda..151bf76 100755
--- a/tests/generic/220
+++ b/tests/generic/220
@@ -88,9 +88,6 @@ echo "Compare files"
 ! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
 cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/220.out b/tests/generic/220.out
index 9dcb9d6..a7123e1 100644
--- a/tests/generic/220.out
+++ b/tests/generic/220.out
@@ -4,4 +4,3 @@ Create the original files
 Compare files
 CoW and unmount
 Compare files
-Check for damage
diff --git a/tests/generic/222 b/tests/generic/222
index ab3f65f..c95a1d6 100755
--- a/tests/generic/222
+++ b/tests/generic/222
@@ -94,9 +94,6 @@ echo "Compare files"
 ! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
 cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/222.out b/tests/generic/222.out
index 47bad10..895b3a1 100644
--- a/tests/generic/222.out
+++ b/tests/generic/222.out
@@ -4,4 +4,3 @@ Create the original files
 Compare files
 CoW and unmount
 Compare files
-Check for damage
diff --git a/tests/generic/227 b/tests/generic/227
index 387c714..d62ab52 100755
--- a/tests/generic/227
+++ b/tests/generic/227
@@ -94,9 +94,6 @@ echo "Compare files"
 ! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
 cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/227.out b/tests/generic/227.out
index 69cb88f..bed3e48 100644
--- a/tests/generic/227.out
+++ b/tests/generic/227.out
@@ -4,4 +4,3 @@ Create the original files
 Compare files
 CoW and unmount
 Compare files
-Check for damage
diff --git a/tests/generic/229 b/tests/generic/229
index eb105a3..cc86b4e 100755
--- a/tests/generic/229
+++ b/tests/generic/229
@@ -154,9 +154,6 @@ runtest delalloc unwritten "$testdir/d-u"
 runtest delalloc hole "$testdir/d-h"
 runtest delalloc regular "$testdir/d-r"
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/229.out b/tests/generic/229.out
index 07750ac..4955ecd 100644
--- a/tests/generic/229.out
+++ b/tests/generic/229.out
@@ -80,4 +80,3 @@ Create the original files
 Compare files
 CoW and unmount
 Compare files
-Check for damage
diff --git a/tests/generic/238 b/tests/generic/238
index 02057ad..c726770 100755
--- a/tests/generic/238
+++ b/tests/generic/238
@@ -154,9 +154,6 @@ runtest delalloc unwritten "$testdir/d-u"
 runtest delalloc hole "$testdir/d-h"
 runtest delalloc regular "$testdir/d-r"
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/238.out b/tests/generic/238.out
index dcfcc8e..5f97fb1 100644
--- a/tests/generic/238.out
+++ b/tests/generic/238.out
@@ -80,4 +80,3 @@ Create the original files
 Compare files
 CoW and unmount
 Compare files
-Check for damage
diff --git a/tests/generic/242 b/tests/generic/242
index 3023ac7..1141aa4 100755
--- a/tests/generic/242
+++ b/tests/generic/242
@@ -90,9 +90,6 @@ md5sum "$testdir/file1" | _filter_scratch
 md5sum "$testdir/file2" | _filter_scratch
 md5sum "$testdir/file2.chk" | _filter_scratch
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/242.out b/tests/generic/242.out
index ef9a574..34dac8b 100644
--- a/tests/generic/242.out
+++ b/tests/generic/242.out
@@ -10,4 +10,3 @@ Compare files
 01768a16d33c9bd21dc67a7fac006ee1  SCRATCH_MNT/test-242/file1
 c835fd53fa27b72511b250d51595c053  SCRATCH_MNT/test-242/file2
 c835fd53fa27b72511b250d51595c053  SCRATCH_MNT/test-242/file2.chk
-Check for damage
diff --git a/tests/generic/243 b/tests/generic/243
index e65347f..a514591 100755
--- a/tests/generic/243
+++ b/tests/generic/243
@@ -90,9 +90,6 @@ md5sum "$testdir/file1" | _filter_scratch
 md5sum "$testdir/file2" | _filter_scratch
 md5sum "$testdir/file2.chk" | _filter_scratch
 
-echo "Check for damage"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/243.out b/tests/generic/243.out
index 8e13fab..d76ce6f 100644
--- a/tests/generic/243.out
+++ b/tests/generic/243.out
@@ -10,4 +10,3 @@ Compare files
 01768a16d33c9bd21dc67a7fac006ee1  SCRATCH_MNT/test-243/file1
 c835fd53fa27b72511b250d51595c053  SCRATCH_MNT/test-243/file2
 c835fd53fa27b72511b250d51595c053  SCRATCH_MNT/test-243/file2.chk
-Check for damage
diff --git a/tests/xfs/127 b/tests/xfs/127
index 63d5890..392e63c 100755
--- a/tests/xfs/127
+++ b/tests/xfs/127
@@ -70,9 +70,6 @@ _cp_reflink "$testdir/original" "$testdir/copy3"
 
 xfs_info "$SCRATCH_MNT" >> "$seqres.full"
 
-echo "Check scratch fs"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/xfs/127.out b/tests/xfs/127.out
index e4e76e2..317fbdc 100644
--- a/tests/xfs/127.out
+++ b/tests/xfs/127.out
@@ -3,4 +3,3 @@ Format and mount
 Create the original file and reflink to copy1, copy2
 Grow fs
 Create more reflink copies
-Check scratch fs
diff --git a/tests/xfs/128 b/tests/xfs/128
index 2e1da3f..f230adf 100755
--- a/tests/xfs/128
+++ b/tests/xfs/128
@@ -140,9 +140,6 @@ _within_tolerance "free blocks after CoW some reflink copies" $free_blocks2 $((f
 _within_tolerance "free blocks after defragging all reflink copies" $free_blocks3 $((free_blocks2 - (blks * 2 * blksz_factor))) $margin -v
 _within_tolerance "free blocks after all tests" $free_blocks3 $((free_blocks0 - (blks * 3 * blksz_factor))) $margin -v
 
-echo "Check scratch fs"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/xfs/128.out b/tests/xfs/128.out
index 0ac06db..9c80746 100644
--- a/tests/xfs/128.out
+++ b/tests/xfs/128.out
@@ -24,4 +24,3 @@ free blocks after creating some reflink copies is in range
 free blocks after CoW some reflink copies is in range
 free blocks after defragging all reflink copies is in range
 free blocks after all tests is in range
-Check scratch fs
diff --git a/tests/xfs/131 b/tests/xfs/131
index adab31f..f553a44 100755
--- a/tests/xfs/131
+++ b/tests/xfs/131
@@ -67,9 +67,6 @@ _cp_reflink "$testdir/file1" "$testdir/file2" 2>&1 | _filter_scratch
 
 test -s "$testdir/file2" && _fail "Should not be able to reflink a realtime file."
 
-echo "Check restored fs"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/xfs/131.out b/tests/xfs/131.out
index 7b700c9..3c0186f 100644
--- a/tests/xfs/131.out
+++ b/tests/xfs/131.out
@@ -3,4 +3,3 @@ Format and mount scratch device
 Create the original file blocks
 Reflink every block
 cp: failed to clone 'SCRATCH_MNT/test-131/file2' from 'SCRATCH_MNT/test-131/file1': Invalid argument
-Check restored fs
diff --git a/tests/xfs/139 b/tests/xfs/139
index feb55bd..55dd7d0 100755
--- a/tests/xfs/139
+++ b/tests/xfs/139
@@ -73,9 +73,6 @@ md5sum "$testdir/file1" | _filter_scratch
 md5sum "$testdir/file2" | _filter_scratch
 #filefrag -v "$testdir/file1" "$testdir/file2"
 
-echo "Check scratch fs"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/xfs/139.out b/tests/xfs/139.out
index 090e3af..dc6a31e 100644
--- a/tests/xfs/139.out
+++ b/tests/xfs/139.out
@@ -5,4 +5,3 @@ CoW every other block
 Compare files
 673c759fb131ccf3336c4f8c549a497e  SCRATCH_MNT/test-139/file1
 dc802351f6717547cbf4c951b294f952  SCRATCH_MNT/test-139/file2
-Check scratch fs
diff --git a/tests/xfs/140 b/tests/xfs/140
index 309b284..a379ca7 100644
--- a/tests/xfs/140
+++ b/tests/xfs/140
@@ -80,9 +80,6 @@ echo "Compare files"
 ! cmp -s "$testdir/file1" "$testdir/file2" || echo "file1 and file2 must not match"
 cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
 
-echo "Check scratch fs"
-umount "$SCRATCH_MNT"
-
 # success, all done
 status=0
 exit
diff --git a/tests/xfs/140.out b/tests/xfs/140.out
index 5d00ea2..4d9e6a1 100644
--- a/tests/xfs/140.out
+++ b/tests/xfs/140.out
@@ -4,4 +4,3 @@ Create the original files
 Compare files
 CoW every other block
 Compare files
-Check scratch fs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
