Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212A02E612E;
	Thu, 19 Feb 2026 06:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481519; cv=none; b=Myh0+SA4Gf+9xLI1+KS8eTldpXNUSL8Yob3SAw9FdB8MF689n6K7V1ofP39jfd8z+oBmHpWPSbflT/7AwkQIHpCmPblJ7boeu3S5ggLfDb232R0bw6yktwZQ3CY2rdoiyZKWotrp6z3D2HEvM54WCpu1SYHFAbT91XIrj/R52GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481519; c=relaxed/simple;
	bh=FXi6/w5gBSj0SbkmUvk+E0+SVihts+uTyw8g+REWhMo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=caQ1om+78g4mpvsELfhs/8BN3buBUkmIXKRl3j7Ne11w4TL/+R2GGbjOUYEgXlmZHS+5gSBE6byuqrz4fXzQJ3V2afMpWAtpZTQnWlAuTxVJlNWTVqenf1/pko5nzTkPPZeurLOvWiPnwlm1nux4m8IIySfH3io+smJHLHb7E70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tPQdJXcx; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tPQdJXcx"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61J0oYEx3871580;
	Thu, 19 Feb 2026 06:11:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=4y9wQYMOP3hsuHQAo
	8V5hTVQrM6HbY+vCcuUwPt0tNA=; b=tPQdJXcx3LhZZFyCDmvCm1prk/OHe4q55
	dYFZJ30yecVmg2RqxZOFfNQ+CPjLczoX28/ASE9uwXP3OMKy+xvhTOlABeMZcvvl
	q95PjQa+TLGuHpL2F8XGLhaOSArs2J9XpXegruObDa3JRp/OJnSYHFawacTMcnan
	XwsOQZ4h0ckrkmu3ab935lPBuuqeu2DNea/yNwTcnXuvgkwy7kkd8qxuv8Q466IP
	ZooZEj+e9vlbpWajJmuGUu3C7e/kjLbswQBVmvKT3EyY/wafI6D4aysAOlJUQXRM
	cLRPXjmZY9Aocl54wOvpqAttXoTIa+wKS/SMnxLZn7OrCHvc3NjkQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cajcr4qt4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:11:48 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J3REIj017891;
	Thu, 19 Feb 2026 06:11:47 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb28k0r1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:11:47 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J6BkMd30868074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 06:11:46 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E994B5805E;
	Thu, 19 Feb 2026 06:11:45 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 186CE58059;
	Thu, 19 Feb 2026 06:11:42 +0000 (GMT)
Received: from citest-1.. (unknown [9.124.222.193])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 06:11:41 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org, david@fromorbit.com,
        zlang@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, nirjhar@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, hsiangkao@linux.alibaba.com
Subject: [PATCH v1 3/7] xfs: Add realtime group grow tests
Date: Thu, 19 Feb 2026 06:10:51 +0000
Message-Id: <f1230eca56f32e26b954be6684d1582dacf2aef6.1771425357.git.nirjhar.roy.lists@gmail.com>
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
X-Proofpoint-GUID: ICwYQDxZo0kgszEa-_a5dfP5GsTurRlg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA1NCBTYWx0ZWRfX2Jn744QS74pI
 Y+ssP2pc6XLWzhAO8uyM1XhJPc3LI5kTgXuG+8pEJ10m2FjteavAM8S5tWUWI17UMcS+IHgP+lf
 ZvQok0DjfjeMKWGerEuq/IRd8/5rKOR7V9URchJ7rz0XHfBx1yTO55PV9wx+wDcmaRe1U/f0rbB
 8ME0d6OR/RyzeU4itdPv2epzq6GSEeVbPiR2X7S50SObKvfTl01rKQOatj08yu6juNfy+5LD3VN
 E9B4HBOuUOIJEzObNX2D3ZJTxheCIOkmlSYkFA8CC13sOH2kp6pMQHLmpVhQrLs7uOBCOi+OdfS
 Ao8WaDyWZECKqUSvIoP8ksaN5pVqi0kF0tR7PPNXGsZMRh794nggfbmzHOT0ffJk9pVgPqdRWz7
 +GgM6o3BVDvlg4tomdVkO87Otb4A9zGcGAEAQkqVGGKo0FfuFPwoetk+OaYhtn2mSUffwNgVLGC
 3IdVrQDz30Xp06iEcBQ==
X-Authority-Analysis: v=2.4 cv=UPXQ3Sfy c=1 sm=1 tr=0 ts=6996a9a5 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=9MNXVIFB4xzYs2OeMmcA:9
X-Proofpoint-ORIG-GUID: 9tGAR5acz-0z7B9ylx90ciR0Hp8NLxPn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_01,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=0 adultscore=0
 bulkscore=0 clxscore=1011 lowpriorityscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190054

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

Add unit tests to validate growth of realtime groups. This includes
last rtgroup's partial growth case as well complete rtgroup addition.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 tests/xfs/655     | 151 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/655.out |  13 ++++
 2 files changed, 164 insertions(+)
 create mode 100755 tests/xfs/655
 create mode 100644 tests/xfs/655.out

diff --git a/tests/xfs/655 b/tests/xfs/655
new file mode 100755
index 00000000..12094ae8
--- /dev/null
+++ b/tests/xfs/655
@@ -0,0 +1,151 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>.  All Rights Reserved.
+#
+# FS QA Test 655
+#
+# XFS realtime fs growfs basic functionality test
+#
+# This test attempts to grow the realtime filesystem by various sizes and
+# verifies if it works as expected.
+#
+. ./common/preamble
+_begin_fstest auto quick growfs shrinkfs
+
+# Import common functions.
+. ./common/filter
+_require_realtime_xfs_grow
+
+AGCOUNT=16
+RGCOUNT="$AGCOUNT"
+DEVSIZE=$((2 * 1024 * 1024 * 1024)) # 2G
+FSSIZE=$(( DEVSIZE / 2 ))
+_require_scratch_size $((DEVSIZE / 1024))
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
+test_grow()
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
+# run_test <number of rtextents to add> <test name> <optional: error message>
+# If the test is expected to succeed, then there is no need to provide an error
+# message.
+run_test_grow()
+{
+	local delta_extents="$1"
+	local test_name="$2"
+	local error_message="$3"
+
+	echo "$test_name"
+	reset
+	local tsize=$((tot_rtextents+delta_extents))
+	local nrgcount=`_rtextents_to_rg "$tsize"`
+	echo "delta = $delta_extents new_rtextents = $tsize nrgcount = $nrgcount" \
+		>> $seqres.full
+	if [[ "$error_message" == "" ]]; then
+		# no error message means the test is expected to succeed
+		test_grow "$tsize" || \
+			echo "Grow $test_name failure"
+		# Verify the parameters
+		[[ "$rtextents" -ne "$tsize" ]] && \
+			echo "rtextents not changed properly after growing \"$test_name\"" \
+			&& 	echo "expected $tsize got $rtextents"
+		[[ "$rgcount" -ne "$nrgcount" ]] && \
+			echo "rgcount not changed properly after growing \"$test_name\"" \
+			&& 	echo "expected $nrgcount got $rgcount"
+		[[ "$(_scratch_xfs_get_rt_bitmap_count)" -ne "$nrgcount" ]] && \
+			echo "bitmap inode count not changed properly after growing \"$test_name\"" \
+			&& 	echo "expected $nrgcount got $(_scratch_xfs_get_rt_bitmap_count)"
+		[[ "$(_scratch_xfs_get_rt_summary_count)" -ne "$nrgcount" ]] && \
+			echo "summary inode count not changed properly after growing \"$test_name\"" \
+			&& 	echo "expected $nrgcount got $(_scratch_xfs_get_rt_summary_count)"
+	else
+		test_grow "$tsize" && \
+			echo "Grow \"$test_name\" succeeded unexpectedly"
+		grep -q "$error_message" $tmp.growfs || \
+			echo "Error message missing - growing \"$test_name\" (expected: $error_message)"
+		# Verify the parameters
+		[[ "$rtextents" -ne "$tot_rtextents" ]] && \
+			echo "rtextents changed after grow failure \"$test_name\"" && \
+			echo "expected $tot_rtextents got $rtextents"
+		[[ "$rgcount" -ne "$orgcount" ]] && \
+			echo "rgcount changed after grow failure \"$test_name\"" && \
+			echo "expected $orgcount got $rgcount"
+		[[ "$(_scratch_xfs_get_rt_bitmap_count)" -ne "$orgcount" ]] && \
+			echo "bitmap inode count changed after grow failure \"$test_name\"" && \
+			echo "expected $orgcount got $(_scratch_xfs_get_rt_bitmap_count)"
+		[[ "$(_scratch_xfs_get_rt_summary_count)" -ne "$orgcount" ]] && \
+			echo "summary inode count changed after grow failure \"$test_name\"" && \
+			echo "expected $orgcount got $(_scratch_xfs_get_rt_summary_count)"
+	fi
+}
+
+reset
+
+# Tests expected to pass
+# run_test_grow <number of rtextents to add> <test name>
+echo "#Tests partial and multi-rg grow"
+run_test_grow 1 "grow by 1 rtextent"
+run_test_grow $(( rgextents / 2 )) "grow by 0.5 RG"
+run_test_grow $(( rgextents)) "grow by 1 RG"
+run_test_grow $(( rgextents * 6 )) "grow by 6 RG"
+run_test_grow $(( rgextents * 3 + rgextents / 2)) "grow by 3.5 RG"
+
+run_test_grow $(( dbsize * 8 )) "grow by 1 rmblocks"
+run_test_grow $(( dbsize * 8 + 1 )) "grow by 1 + 1 rmblocks"
+run_test_grow $(( rgextents + dbsize * 8 )) "grow by 1rtgroup + 1 rmblocks"
+
+echo
+reset
+
+echo "#Test out of bounds rg grow: Below tests are expected to fail"
+run_test_grow "$(( 9999999999 + 1 ))" "grow to > dev_size" \
+	"too large"
+
+echo "printing seqres" >> $seqres.full
+
+$XFS_INFO_PROG $SCRATCH_MNT >> $seqres.full
+
+# success, all done
+_exit 0
diff --git a/tests/xfs/655.out b/tests/xfs/655.out
new file mode 100644
index 00000000..dc291b5c
--- /dev/null
+++ b/tests/xfs/655.out
@@ -0,0 +1,13 @@
+QA output created by 655
+#Tests partial and multi-rg grow
+grow by 1 rtextent
+grow by 0.5 RG
+grow by 1 RG
+grow by 6 RG
+grow by 3.5 RG
+grow by 1 rmblocks
+grow by 1 + 1 rmblocks
+grow by 1rtgroup + 1 rmblocks
+
+#Test out of bounds rg grow: Below tests are expected to fail
+grow to > dev_size
-- 
2.34.1

