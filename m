Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q63Ffdjt103064 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 10:41:39 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id 6RaIG3koqXnjP28x (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jul 2012 08:41:38 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q63FfbVR003316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 15:41:38 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q63FfaBq018025
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 15:41:37 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q63FfaT4021937 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 10:41:36 -0500
Message-ID: <4FF31296.8050406@oracle.com>
Date: Tue, 03 Jul 2012 23:41:10 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2] xfstests: improve test 286 for repeated unwritten/hole
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
To: xfs@oss.sgi.com

v2->v1.
* Drop the diff of seq.full.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 286 |   87
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 86 insertions(+), 1 deletions(-)

diff --git a/286 b/286
index 03c343f..75b2151 100644
--- a/286
+++ b/286
@@ -105,10 +105,95 @@ test02()
 	cmp $src $dest || _fail "TEST02: file bytes check failed"
 }

-rm -f $seq.full
+# seek_copy_test_03 - tests file with unwritten with data, repeated
unwritten
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
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
