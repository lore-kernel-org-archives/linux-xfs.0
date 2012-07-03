Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q637V4oK068120 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 02:31:04 -0500
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id S9Q61Cb9UN4gpoor (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jul 2012 00:31:03 -0700 (PDT)
Message-ID: <4FF29F94.6030702@oracle.com>
Date: Tue, 03 Jul 2012 15:30:28 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: improve test 286 for repeated unwritten/hole
	extents.
Reply-To: jeff.liu@oracle.com
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Hello,

I'd like to enlarge the test coverage of 286 to includes file mapping with repeated hole/unwritten/unwritten_without_data/data intersections.

Those two new sub-tests could help verifying the current seek_data/seek_hole improvements.

Besides, I observed a weird thing at the diff of 286.full, look at the the sparse file creation output,  there seems to be a significant
I/O degradation compare to the old test01/test02 IOPS results:

-1 MiB, 256 ops; 0.0000 sec (1.242 GiB/sec and 325699.7455 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (70.161 MiB/sec and 17961.1310 ops/sec)

I run the test on same machine and same partition, I recalled the old result is generated against around 3.4-rc2(not very sure), now is updated
to 3.5-rc4, does anyone hit that?


Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 286      |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 286.full |   82 +++++++++++++++++++++++++++++++++++----------------------
 2 files changed, 136 insertions(+), 33 deletions(-)
 mode change 100644 => 100755 286

diff --git a/286 b/286
old mode 100644
new mode 100755
index 03c343f..75b2151
--- a/286
+++ b/286
@@ -105,10 +105,95 @@ test02()
 	cmp $src $dest || _fail "TEST02: file bytes check failed"
 }
 
-rm -f $seq.full
+# seek_copy_test_03 - tests file with unwritten with data, repeated unwritten
+# without data, as well as data extents mapping.
+# verify results:
+# 1. file size is identical.
+# 2. perform cmp(1) to compare SRC and DEST file byte by byte.
+test03()
+{
+	rm -rf $src $dest
+
+	write_cmd="-c \"truncate 200m\""
+
+	#
+	# Firstly, make the file with allocated && reserved extents
+	# mapping without real data wrote.
+	#
+	for i in $(seq 0 10 180); do
+		offset=$(($((10 << 20)) + $i * $((1 << 20))))
+		write_cmd="$write_cmd -c \"falloc $offset 10m\""
+	done
+
+	# 
+	# Secondly, write data to some unwritten extents, hence we
+	# have a test file will extents mapping as:
+	# |data|multiple unwritten_without_data|data| repeat...
+	for i in $(seq 0 60 180); do
+		offset=$(($((20 << 20)) + $i * $((1 << 20))))
+		write_cmd="$write_cmd -c \"pwrite $offset 10m\""
+	done
+
+	echo "*** test03() create sparse file ***" >>$seq.full
+	eval ${XFS_IO_PROG} -F -f "${write_cmd}" $src >>$seq.full 2>&1 ||
+		_fail "create sparse file failed!"
+	echo "*** test03() create sparse file done ***" >>$seq.full
+	echo >>$seq.full
+	$here/src/seek_copy_test $src $dest
 
+	test $(stat --printf "%s" $src) = $(stat --printf "%s" $dest) ||
+		_fail "TEST03: file size check failed"
+
+	cmp $src $dest || _fail "TEST03: file bytes check failed"
+}
+
+# seek_copy_test_04 - tests file with hole, repeated unwritten
+# without data, as well as data extents mapping.
+# verify results:
+# 1. file size is identical.
+# 2. perform cmp(1) to compare SRC and DEST file byte by byte.
+test04()
+{
+	rm -rf $src $dest
+
+	write_cmd="-c \"truncate 200m\""
+
+	#
+	# Firstly, make the file with allocated && reserved extents
+	# mapping without real data wrote.
+	#
+	for i in $(seq 30 30 180); do
+		offset=$(($((30 << 20)) + $i * $((1 << 20))))
+		write_cmd="$write_cmd -c \"falloc $offset 5m\""
+	done
+
+	# 
+	# Secondly, write data to some unwritten extents, hence we
+	# have a test file will extents mapping as:
+	# |hole|multiple unwritten_without_data|hole|data| repeat...
+	for i in $(seq 30 90 180); do
+		offset=$(($((30 << 20)) + $i * $((1 << 20))))
+		write_cmd="$write_cmd -c \"pwrite $offset 2m\""
+	done
+
+	echo "*** test04() create sparse file ***" >>$seq.full
+	eval ${XFS_IO_PROG} -F -f "${write_cmd}" $src >>$seq.full 2>&1 ||
+		_fail "create sparse file failed!"
+	echo "*** test04() create sparse file done ***" >>$seq.full
+	echo >>$seq.full
+	$here/src/seek_copy_test $src $dest
+
+	test $(stat --printf "%s" $src) = $(stat --printf "%s" $dest) ||
+		_fail "TEST04: file size check failed"
+
+	cmp $src $dest || _fail "TEST04: file bytes check failed"
+}
+
+rm -f $seq.full
 test01
 test02
+test03
+test04
 
 status=0
 exit
diff --git a/286.full b/286.full
index b4e4f08..923425c 100644
--- a/286.full
+++ b/286.full
@@ -1,70 +1,88 @@
 *** test01() create sparse file ***
 wrote 1048576/1048576 bytes at offset 0
-1 MiB, 256 ops; 0.0000 sec (1.242 GiB/sec and 325699.7455 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (70.161 MiB/sec and 17961.1310 ops/sec)
 wrote 1048576/1048576 bytes at offset 5242880
-1 MiB, 256 ops; 0.0000 sec (1.160 GiB/sec and 304038.0048 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (63.536 MiB/sec and 16265.3282 ops/sec)
 wrote 1048576/1048576 bytes at offset 10485760
-1 MiB, 256 ops; 0.0000 sec (1.112 GiB/sec and 291571.7540 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (75.827 MiB/sec and 19411.5863 ops/sec)
 wrote 1048576/1048576 bytes at offset 15728640
-1 MiB, 256 ops; 0.0000 sec (1.095 GiB/sec and 286995.5157 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (75.580 MiB/sec and 19348.4997 ops/sec)
 wrote 1048576/1048576 bytes at offset 20971520
-1 MiB, 256 ops; 0.0000 sec (1.094 GiB/sec and 286674.1321 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (71.515 MiB/sec and 18307.9454 ops/sec)
 wrote 1048576/1048576 bytes at offset 26214400
-1 MiB, 256 ops; 0.0000 sec (1.085 GiB/sec and 284444.4444 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (72.674 MiB/sec and 18604.6512 ops/sec)
 wrote 1048576/1048576 bytes at offset 31457280
-1 MiB, 256 ops; 0.0000 sec (1.065 GiB/sec and 279171.2105 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (65.015 MiB/sec and 16643.9113 ops/sec)
 wrote 1048576/1048576 bytes at offset 36700160
-1 MiB, 256 ops; 0.0000 sec (1.064 GiB/sec and 278867.1024 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (67.981 MiB/sec and 17403.1271 ops/sec)
 wrote 1048576/1048576 bytes at offset 41943040
-1 MiB, 256 ops; 0.0000 sec (1.068 GiB/sec and 280087.5274 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (71.731 MiB/sec and 18363.1016 ops/sec)
 wrote 1048576/1048576 bytes at offset 47185920
-1 MiB, 256 ops; 0.0000 sec (1.058 GiB/sec and 277356.4464 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (71.240 MiB/sec and 18237.5151 ops/sec)
 wrote 1048576/1048576 bytes at offset 52428800
-1 MiB, 256 ops; 0.0000 sec (1.067 GiB/sec and 279781.4208 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (68.890 MiB/sec and 17635.7123 ops/sec)
 wrote 1048576/1048576 bytes at offset 57671680
-1 MiB, 256 ops; 0.0000 sec (1.071 GiB/sec and 280701.7544 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (64.566 MiB/sec and 16528.9256 ops/sec)
 wrote 1048576/1048576 bytes at offset 62914560
-1 MiB, 256 ops; 0.0000 sec (1.071 GiB/sec and 280701.7544 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (72.307 MiB/sec and 18510.4845 ops/sec)
 wrote 1048576/1048576 bytes at offset 68157440
-1 MiB, 256 ops; 0.0000 sec (1.074 GiB/sec and 281628.1628 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (66.760 MiB/sec and 17090.5935 ops/sec)
 wrote 1048576/1048576 bytes at offset 73400320
-1 MiB, 256 ops; 0.0000 sec (1.071 GiB/sec and 280701.7544 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (68.306 MiB/sec and 17486.3388 ops/sec)
 wrote 1048576/1048576 bytes at offset 78643200
-1 MiB, 256 ops; 0.0000 sec (1.068 GiB/sec and 280087.5274 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (68.087 MiB/sec and 17430.3806 ops/sec)
 wrote 1048576/1048576 bytes at offset 83886080
-1 MiB, 256 ops; 0.0000 sec (1.073 GiB/sec and 281318.6813 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (67.659 MiB/sec and 17320.7037 ops/sec)
 wrote 1048576/1048576 bytes at offset 89128960
-1 MiB, 256 ops; 0.0000 sec (1.068 GiB/sec and 280087.5274 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (72.072 MiB/sec and 18450.4505 ops/sec)
 wrote 1048576/1048576 bytes at offset 94371840
-1 MiB, 256 ops; 0.0000 sec (1.085 GiB/sec and 284444.4444 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (66.238 MiB/sec and 16957.0113 ops/sec)
 wrote 1048576/1048576 bytes at offset 99614720
-1 MiB, 256 ops; 0.0000 sec (1.055 GiB/sec and 276457.8834 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (74.521 MiB/sec and 19077.4275 ops/sec)
 wrote 1048576/1048576 bytes at offset 104857600
-1 MiB, 256 ops; 0.0000 sec (1.140 GiB/sec and 298716.4527 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (73.105 MiB/sec and 18714.8183 ops/sec)
 *** test01() create sparse file done ***
 
 *** test02() create sparse file ***
 wrote 1048576/1048576 bytes at offset 6291456
-1 MiB, 256 ops; 0.0000 sec (1.360 GiB/sec and 356545.9610 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (48.852 MiB/sec and 12506.1065 ops/sec)
 wrote 1048576/1048576 bytes at offset 16777216
-1 MiB, 256 ops; 0.0000 sec (1.385 GiB/sec and 363120.5674 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (49.417 MiB/sec and 12650.7215 ops/sec)
 wrote 1048576/1048576 bytes at offset 27262976
-1 MiB, 256 ops; 0.0000 sec (1.340 GiB/sec and 351165.9808 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (29.498 MiB/sec and 7551.3997 ops/sec)
 wrote 1048576/1048576 bytes at offset 37748736
-1 MiB, 256 ops; 0.0000 sec (1.309 GiB/sec and 343163.5389 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (43.750 MiB/sec and 11200.0700 ops/sec)
 wrote 1048576/1048576 bytes at offset 48234496
-1 MiB, 256 ops; 0.0000 sec (1.267 GiB/sec and 332036.3165 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (45.092 MiB/sec and 11543.4910 ops/sec)
 wrote 1048576/1048576 bytes at offset 58720256
-1 MiB, 256 ops; 0.0000 sec (1.285 GiB/sec and 336842.1053 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (52.571 MiB/sec and 13458.1011 ops/sec)
 wrote 1048576/1048576 bytes at offset 69206016
-1 MiB, 256 ops; 0.0000 sec (1.288 GiB/sec and 337730.8707 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (48.382 MiB/sec and 12385.6984 ops/sec)
 wrote 1048576/1048576 bytes at offset 79691776
-1 MiB, 256 ops; 0.0000 sec (1.278 GiB/sec and 335078.5340 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (49.225 MiB/sec and 12601.5260 ops/sec)
 wrote 1048576/1048576 bytes at offset 90177536
-1 MiB, 256 ops; 0.0000 sec (1.293 GiB/sec and 339072.8477 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (50.865 MiB/sec and 13021.3632 ops/sec)
 wrote 1048576/1048576 bytes at offset 100663296
-1 MiB, 256 ops; 0.0000 sec (1.280 GiB/sec and 335517.6933 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (47.703 MiB/sec and 12211.9926 ops/sec)
 wrote 1048576/1048576 bytes at offset 111149056
-1 MiB, 256 ops; 0.0000 sec (1.285 GiB/sec and 336842.1053 ops/sec)
+1 MiB, 256 ops; 0.0000 sec (52.094 MiB/sec and 13336.1117 ops/sec)
 *** test02() create sparse file done ***
 
+*** test03() create sparse file ***
+wrote 10485760/10485760 bytes at offset 20971520
+10 MiB, 2560 ops; 0.0000 sec (49.703 MiB/sec and 12723.9110 ops/sec)
+wrote 10485760/10485760 bytes at offset 83886080
+10 MiB, 2560 ops; 0.0000 sec (44.930 MiB/sec and 11502.1027 ops/sec)
+wrote 10485760/10485760 bytes at offset 146800640
+10 MiB, 2560 ops; 0.0000 sec (43.934 MiB/sec and 11247.2102 ops/sec)
+wrote 10485760/10485760 bytes at offset 209715200
+10 MiB, 2560 ops; 0.0000 sec (39.936 MiB/sec and 10223.7238 ops/sec)
+*** test03() create sparse file done ***
+
+*** test04() create sparse file ***
+wrote 2097152/2097152 bytes at offset 62914560
+2 MiB, 512 ops; 0.0000 sec (49.724 MiB/sec and 12729.3521 ops/sec)
+wrote 2097152/2097152 bytes at offset 157286400
+2 MiB, 512 ops; 0.0000 sec (48.720 MiB/sec and 12472.2906 ops/sec)
+*** test04() create sparse file done ***
+
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
