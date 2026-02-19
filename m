Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171942E612E;
	Thu, 19 Feb 2026 06:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481526; cv=none; b=BDubVcNv4h+K6TSkkomT80UFTv/Ky/iG1lKkMLcU718n4W6MrUYlvO6WgCKQNGrgj5A7nm2/SilAoNXV0UCc1FiYdw4r8eMagvndFczPaZiy+S1IcS913k8Ij4z8a3MJQUHONqykRIXJC2cq5N9sHCfeFhuM5HwVt+HTycFssv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481526; c=relaxed/simple;
	bh=npiRHy8EAKcew24K3BkAfsz6jAC+4DVeVIzHqays/SE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h52J3POYJc+t35fOfgWsdE8/E0McoqVWIfHHjWShIQC5EYo1lE/0foy0veTNj1JiUL+NvIVPcg6JVfiSgX8HUvaN2f/qq4n6ZPaNNcXi30IOsVdig6JY5Jcia0zfRR+jNE80P/3GUeyj1gFqAqqLjUmM072pFjlZELZj9rHZcGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XRUn7yUW; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XRUn7yUW"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61J0dcrG3203603;
	Thu, 19 Feb 2026 06:11:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=x62FNJjGiccH9PRlF
	PbGzveyeT8YcFYHywQp7sclRuw=; b=XRUn7yUWLadyhHtM6VnmMkQcnipD+eOKW
	YO1rETqOzJiqCU2bWZxDBmi5GsjWTkNT1knXvquiamX3lsvcHRSW6J0Nu8xdCOLs
	G1Ia1yJZd0m+7pjgiekzGYLWtfWcrcIZojiEGYi9pi0PKtIwYb7DP9yxtg1LCGII
	jim5PxBxmCLJCJT3Nyfb+mbNGLAPao6JIZWZgbrrPKoXmEFj8B5ExP5CYI5YnXOn
	u06DX1rViN0pEWUHwN2IfWvZrAXH1MAomT/djWGrMZd+FUFjGYhYK4KwTePcGMfe
	KGgGDb6CTjIa9lM1bSYgN2IdGQ4BwxscRUWzO5cpW8ZQO2oGhFhTA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj6uvpnx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:11:56 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J2FepX011906;
	Thu, 19 Feb 2026 06:11:55 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb2732sn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:11:55 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J6BsUQ43581860
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 06:11:54 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 540835805B;
	Thu, 19 Feb 2026 06:11:54 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F12B58059;
	Thu, 19 Feb 2026 06:11:50 +0000 (GMT)
Received: from citest-1.. (unknown [9.124.222.193])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 06:11:50 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org, david@fromorbit.com,
        zlang@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, nirjhar@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, hsiangkao@linux.alibaba.com
Subject: [PATCH v1 5/7] xfs: Add realtime group shrink tests
Date: Thu, 19 Feb 2026 06:10:53 +0000
Message-Id: <400c6e0aec8fecc1d2b6367a450bed259d73eeef.1771425357.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
References: <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=E+/AZKdl c=1 sm=1 tr=0 ts=6996a9ad cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=dm7GMulyBvYhc5QQnOwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA1NCBTYWx0ZWRfXzmuDOvF8RixL
 xYYO9KgMGsd1nB+HlaJaMsEiq6AhyQgu1g959YhuGYbtRF6lL0zFR8It+MTbxAyK2PmDBKHCqZ2
 kC1CxEbXh9kIN5CdOMMlVEiXZ8l5UbolcBzP9RKwX1afHScYv2PPRC66dpYCbSd8A6jE3+/vskA
 QKXy8phDBs3eqtD3//W+qtg12k82BOGJXOKgmjfl/DdNw544FbTqqixmNbYs3VQipdireLcm6h3
 nGZYz0+Bubk+t+WeZ4/xkmH6fnDRKytsmGA8QtYjdJVUKFcxF22ImeLOpZCuyb34JL49rgGMdIg
 6sAy7oJY4XVfuYyCaqVPAMKk/JN/NbI5bNVlUWJiRR7qbh+Qs2rCRwUotzNHolGQ1owZoUjSdVv
 HI1lk454ZwKOHEFoP0PBungNTaC+73aKIcXff1D6Gk8FDlN/npi6kXvJfJdDWDlifOIcjNeRfRJ
 XuhH+0JGgCuf+9Ex80A==
X-Proofpoint-ORIG-GUID: -HwJcYly1W2c-ON3h4q7lhpdTZSIsOdC
X-Proofpoint-GUID: i2vAAdjWC8wFV29RshaDBDNNRvzzwbYz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_01,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190054

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

Add unit tests to validate shrinking of realtime groups. This includes
last rtgroup's partial shrink case as well compelete rtgroup removals.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 tests/xfs/539     | 190 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/539.out |  19 +++++
 2 files changed, 209 insertions(+)
 create mode 100755 tests/xfs/539
 create mode 100644 tests/xfs/539.out

diff --git a/tests/xfs/539 b/tests/xfs/539
new file mode 100755
index 00000000..57e56168
--- /dev/null
+++ b/tests/xfs/539
@@ -0,0 +1,190 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>.  All Rights Reserved.
+#
+# FS QA Test 539
+#
+# XFS realtime fs shrinkfs basic functionality test
+#
+# This test attempts to shrink the realtime filesystem by various sizes and
+# verifies if it works as expected.
+#
+. ./common/preamble
+_begin_fstest auto quick growfs shrinkfs
+
+# Import common functions.
+. ./common/filter
+_require_realtime_xfs_shrink
+
+AGCOUNT=16
+RGCOUNT="$AGCOUNT"
+FSSIZE=$((2 * 1024 * 1024 * 1024)) # 2G
+_require_scratch_size $((FSSIZE / 1024))
+
+_fixed_by_kernel_commit	a65fd8120766 "xfs: Fix xfs_grow_last_rtg()"
+_fixed_by_kernel_commit xxxxxxxxxxxx "xfs: Fix in xfs_rtalloc_query_range()"
+
+reset()
+{
+	_scratch_unmount >> $seqres.full 2>&1
+        _scratch_mkfs -bsize=4k -dsize="$FSSIZE" -dagcount="$AGCOUNT"  -rsize="$FSSIZE" \
+                -mmetadir=1 -rrgcount="$RGCOUNT" 2>&1 | \
+                tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs >/dev/null
+ 	. $tmp.mkfs
+	tot_rtextents=$rtextents
+	orgcount=$rgcount
+	_scratch_mount >> $seqres.full
+}
+
+# This functions converts a given number of rtextents to rg count.
+_rtextents_to_rg()
+{
+	local extents="$1"
+	local rgdiv=$((extents/rgextents))
+	local rgmod=$((extents%rgextents))
+	local rgc
+	if [[ "$rgmod" == 0 ]]; then
+		rgc="$rgdiv"
+	else
+		rgc=$(( rgdiv + 1 ))
+	fi
+	echo "$rgc"
+}
+
+test_shrink()
+{
+	$XFS_GROWFS_PROG -R"$1" $SCRATCH_MNT &> $tmp.growfs
+	ret=$?
+
+	_scratch_unmount
+	_check_scratch_fs
+	_scratch_mount
+
+	cat $tmp.growfs >> $seqres.full
+	$XFS_INFO_PROG $SCRATCH_MNT 2>&1 | \
+		_filter_mkfs 2>$tmp.xfsinfo >/dev/null
+	. $tmp.xfsinfo
+	[ $ret -eq 0 ]
+}
+
+# run_test <number of rtextents to remove> <test name> <optional: error message>
+# If the test is expected to succeed, then there is no need to provide an error
+# message.
+run_test_shrink()
+{
+	local delta_extents="$1"
+	local test_name="$2"
+	local error_message="$3"
+
+	echo "$test_name"
+	reset
+	local tsize=$((tot_rtextents-delta_extents))
+	local nrgcount=`_rtextents_to_rg "$tsize"`
+	echo "delta = $delta_extents new_rtextents = $tsize nrgcount = $nrgcount" \
+		>> $seqres.full
+	if [[ "$error_message" == "" ]]; then
+		# no error message means the test is expected to succeed
+		test_shrink "$tsize" || \
+			echo "Shrink $test_name failure"
+		# Verify the parameters
+		[[ "$rtextents" -ne "$tsize" ]] && \
+			echo "rtextents not changed properly after shrinking \"$test_name\"" \
+			&& 	echo "expected $tsize got $rtextents"
+		[[ "$rgcount" -ne "$nrgcount" ]] && \
+			echo "rgcount not changed properly after shrinking \"$test_name\"" \
+			&& 	echo "expected $nrgcount got $rgcount"
+		[[ "$(_scratch_xfs_get_rt_bitmap_count)" -ne "$nrgcount" ]] && \
+			echo "bitmap inode count not changed properly after shrinking \"$test_name\"" \
+			&& 	echo "expected $nrgcount got $(_scratch_xfs_get_rt_bitmap_count)"
+		[[ "$(_scratch_xfs_get_rt_summary_count)" -ne "$nrgcount" ]] && \
+			echo "summary inode count not changed properly after shrinking \"$test_name\"" \
+			&& 	echo "expected $nrgcount got $(_scratch_xfs_get_rt_summary_count)"
+	else
+		test_shrink "$tsize" && \
+			echo "Shrink \"$test_name\" succeeded unexpectedly"
+		grep -q "$error_message" $tmp.growfs || \
+			echo "Error message missing - shrinking \"$test_name\" (expected: $error_message)"
+		# Verify the parameters
+		[[ "$rtextents" -ne "$tot_rtextents" ]] && \
+			echo "rtextents changed after shrink failure \"$test_name\"" && \
+			echo "expected $tot_rtextents got $rtextents"
+		[[ "$rgcount" -ne "$orgcount" ]] && \
+			echo "rgcount changed after shrink failure \"$test_name\"" && \
+			echo "expected $orgcount got $rgcount"
+		[[ "$(_scratch_xfs_get_rt_bitmap_count)" -ne "$orgcount" ]] && \
+			echo "bitmap inode count changed after shrink failure \"$test_name\"" && \
+			echo "expected $orgcount got $(_scratch_xfs_get_rt_bitmap_count)"
+		[[ "$(_scratch_xfs_get_rt_summary_count)" -ne "$orgcount" ]] && \
+			echo "summary inode count changed after shrink failure \"$test_name\"" && \
+			echo "expected $orgcount got $(_scratch_xfs_get_rt_summary_count)"
+	fi
+}
+
+# This function, first shrinks the fs, then grows it. This is to make sure that
+# the fs is able to grow properly after a shrink has taken place.
+# Usage: run_test_shrink_grow <number of rtextents to remove> <test name>
+run_test_shrink_grow()
+{
+	local delta_extents="$1"
+	local test_name="$2"
+
+	echo "$test_name"
+	reset
+	local tsize=$((tot_rtextents-delta_extents))
+	test_shrink "$tsize" || \
+		echo "$test_name failure"
+	# Now grow the fs
+	test_shrink "$tot_rtextents" || \
+		echo "$test_name failure"
+	# Verify the parameters
+	[[ "$rtextents" -ne "$tot_rtextents" ]] && \
+		echo "rtextents not changed properly after \"$test_name\"" \
+		&& 	echo "expected $tot_rtextents got $rtextents"
+	[[ "$rgcount" -ne "$orgcount" ]] && \
+		echo "rgcount not changed properly after \"$test_name\"" \
+		&& 	echo "expected $orgcount got $rgcount"
+}
+
+reset
+
+# Tests expected to pass
+# run_test_shrink <number of rtextents to remove> <test name>
+echo "#Tests partial and multi-rg shrinking"
+run_test_shrink 1 "shrink by 1 rtextent"
+run_test_shrink $(( rgextents / 2 )) "shrink by 0.5 RG"
+run_test_shrink $(( rgextents)) "shrink by 1 RG"
+run_test_shrink $(( rgextents * 6 )) "shrink by 6 RG"
+run_test_shrink $(( rgextents * 3 + rgextents / 2)) "shrink by 3.5 RG"
+
+run_test_shrink $(( dbsize * 8 )) "shrink by 1 rmblocks"
+run_test_shrink $(( rgextents + dbsize * 8 )) "shrink by 1rtgroup + 1 rmblocks"
+
+echo
+
+reset
+# run_test_shrink_grow <number of rtextents to remove> <test name>
+echo "#Tests partial and multi-rg shink followed by growfs"
+run_test_shrink_grow $(( rgextents / 2 )) "shrink by 0.5 RG -> grow by 0.5 RG"
+run_test_shrink_grow $(( rgextents * 6 )) "shrink by 6 RG -> grow by 6 RG"
+run_test_shrink_grow $(( rgextents * 3 + rgextents / 2 )) \
+	"shrink by 3.5 RG -> grow by 3.5 RG"
+run_test_shrink_grow $(( dbsize * 8 )) "shrink by 1 rmblocks -> grow by 1 rmblocks"
+run_test_shrink_grow $(( rgextents + dbsize * 8 )) \
+	"shrink by 1rtgroup + 1 rmblocks -> grow by 1rtgroup + 1 rmblocks"
+
+echo
+
+reset
+echo "#Test out of bounds rg shrink: Below tests are expected to fail"
+# Tests expected to fail
+# run_test_shrink_grow <number of rtextents to remove> <test name> <error message>
+run_test_shrink "$(( 99999999 ))" "shrink to > dev size" \
+	"File too large"
+
+echo "printing seqres" >> $seqres.full
+cat $tmp.growfs >> $seqres.full
+
+$XFS_INFO_PROG $SCRATCH_MNT >> $seqres.full
+
+# success, all done
+_exit 0
diff --git a/tests/xfs/539.out b/tests/xfs/539.out
new file mode 100644
index 00000000..59d0557f
--- /dev/null
+++ b/tests/xfs/539.out
@@ -0,0 +1,19 @@
+QA output created by 539
+#Tests partial and multi-rg shrinking
+shrink by 1 rtextent
+shrink by 0.5 RG
+shrink by 1 RG
+shrink by 6 RG
+shrink by 3.5 RG
+shrink by 1 rmblocks
+shrink by 1rtgroup + 1 rmblocks
+
+#Tests partial and multi-rg shink followed by growfs
+shrink by 0.5 RG -> grow by 0.5 RG
+shrink by 6 RG -> grow by 6 RG
+shrink by 3.5 RG -> grow by 3.5 RG
+shrink by 1 rmblocks -> grow by 1 rmblocks
+shrink by 1rtgroup + 1 rmblocks -> grow by 1rtgroup + 1 rmblocks
+
+#Test out of bounds rg shrink: Below tests are expected to fail
+shrink to > dev size
-- 
2.34.1

