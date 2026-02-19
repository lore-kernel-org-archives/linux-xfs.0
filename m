Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B145D2E764D;
	Thu, 19 Feb 2026 06:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481529; cv=none; b=M0jEnJG8cMHNVZ3TsUbjEUEJtWtTI9SWZ2cmWeWfkpyanbQiNAmWUI+CN2F/zLRpUX5vpT3Wfe6mi+551khq1k1a6KncSZnGZe5BCCXjW42cJGcvXyr0/Iier5cPSUT7q8ldgtxym1XedDc1b+CcwYRaV8Nt/+NSjH4vnRnYhGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481529; c=relaxed/simple;
	bh=m/HHEG5a17NH/dLVzQx5dNci7wLGHtZuJd6m+cXWiHY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jWyMyj32Ne9LgL9QMsEvSW/YwOQsBZvUifrOuhxbOndbjYFDnBrlfAuYy+DvUtu/calBNSFF4MwMKYjNbocidUDZ6TyPc+Z57hby+GejOyyaa2e3h99qU+x5so+DI7a9vS/kXGyHJg3uDp5YRxped/jOtanZqkyXllgZK4+gddY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=n5jTGk1n; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="n5jTGk1n"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61IGqZOt4015987;
	Thu, 19 Feb 2026 06:12:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=2zNGEM0c6IXO3Gux2
	iwWiNzVhZTYhcd2BaZGDHJLD2c=; b=n5jTGk1nm8tN0qXy55fvF125MSfG6bN8K
	WJbmi5zuGsVDcHygJ8Fth8HPjPZysqm7DbXuDHjaGbWhU/x1CB7p+j6wqsD2iNY+
	f/60glNVEnOhB8CfRb9tJnFsYaxBgIoiZVlUiz/rtiTu7H8DVwg28WQeHkna9xU8
	h5qhlCDfQo6WUhVTX3bRcxuKH6bLjxpi3dvPcmGiv1mpfMx7rcuZoJHPtTzJOqhM
	Z2bCdaQwcXYU28vWE+kk8m1MWMmqTTz5bnF7MuW0iWxLspWPqIns+7qOynDDpnUn
	gVU3BdPQfM2NrBt+4dq+e4tLZHAYRW7JB5WNLBep8pHLbORmNa1dQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj64bgx9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:12:00 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J3Jn51001381;
	Thu, 19 Feb 2026 06:11:59 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ccb2bk06g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:11:59 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J6Bw3g27329238
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 06:11:58 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4C8F958059;
	Thu, 19 Feb 2026 06:11:58 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D522E5805B;
	Thu, 19 Feb 2026 06:11:54 +0000 (GMT)
Received: from citest-1.. (unknown [9.124.222.193])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 06:11:54 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org, david@fromorbit.com,
        zlang@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, nirjhar@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, hsiangkao@linux.alibaba.com
Subject: [PATCH v1 6/7] xfs: Add multi rt group shrink + shutdown + recovery tests
Date: Thu, 19 Feb 2026 06:10:54 +0000
Message-Id: <ebbbe5a262a146b969e42eb9fc752f52fef904b1.1771425357.git.nirjhar.roy.lists@gmail.com>
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
X-Proofpoint-ORIG-GUID: yj71zUKvEDspkA9Q_UWhpw4HTLbxN0MR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA1NCBTYWx0ZWRfXz8zsBqI80bLG
 9L1CSVGmwDGJgF+BGNywtdsxf8NieuXGSrNfj97LW3LpAR6qs1onPCJy5ZAkhRKKcMl0nGF70IA
 Vs2Zo9MV+m5HbOmr5llVSLTzcy5e7wQOuN0ZhYcZRXYpUicwn3gQA9rs0xDdIpQ79ldKcVxFGmB
 m2gEmDNBRYLE1PwKCsv8RBqryjgK4hf7JzGrYF1nr1kDmbxI5VJpq39UDoIOckT4kfkigRLbkVG
 lm0oxuOKhDLrqlkKb6AtglwWvrFWyjTW0YKiLZIUe5ON0+s/XKaV18PRwyuDoRDqWtOcOZlDejG
 zNb9gQq/lxXjmG259dyJ1rO1nL/SZCPHUiNGJMaoV7eyfPe8hlN5I6aiUp1zeaH0gJmNXmuAkDf
 Sh31tdgn7oHmp+RkGFiQrsTNpy+mY2ufx9rByEVvAs1piIEr4pMvt4mvpp/tdrjBzP+v8OPCvbm
 sSYN52uMPtxHrHftISQ==
X-Proofpoint-GUID: ybKJ0sp71zzEMAg4XwMsKk6pTWtnI8B-
X-Authority-Analysis: v=2.4 cv=U+mfzOru c=1 sm=1 tr=0 ts=6996a9b0 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=W2DzuNCQv_KoGguDLUIA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_01,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602190054

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

This test repeatedly shrinks, then shuts down the filesystem and checks
that recovery works fine - this is similar to what is already being done
in xfs/609 but this tests with filesystem shrink and in xfs/609 it is
tested with filesystem growth.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 tests/xfs/333     | 95 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/333.out |  5 +++
 2 files changed, 100 insertions(+)
 create mode 100755 tests/xfs/333
 create mode 100644 tests/xfs/333.out

diff --git a/tests/xfs/333 b/tests/xfs/333
new file mode 100755
index 00000000..6dba8c6a
--- /dev/null
+++ b/tests/xfs/333
@@ -0,0 +1,95 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>.  All Rights Reserved.
+#
+# FS QA Test 333
+#
+# Test XFS online growfs log recover with shrinking the realtime filesystem
+#
+. ./common/preamble
+_begin_fstest auto growfs stress shutdown log recoveryloop shrinkfs
+
+# Import common functions.
+. ./common/filter
+
+_stress_scratch()
+{
+	procs=4
+	nops=999
+	# -w ensures that the only ops are ones which cause write I/O
+	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w -p $procs \
+	    -n $nops`
+	_run_fsstress_bg $FSSTRESS_ARGS >> $seqres.full 2>&1
+}
+FSSIZE=$(( 1024 * 1024 * 1024 )) # 1G
+_require_realtime_xfs_shrink
+_require_scratch_size $((FSSIZE / 1024)) #KB
+_require_command "$XFS_GROWFS_PROG" xfs_growfs
+
+_fixed_by_kernel_commit	a65fd8120766 "xfs: Fix xfs_grow_last_rtg()"
+_fixed_by_kernel_commit xxxxxxxxxxxx "xfs: Fix in xfs_rtalloc_query_range()"
+
+_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
+. $tmp.mkfs
+
+endsize=`expr 128 \* 1048576`	# stop after shrinking to this size
+[ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
+
+nrgs=16
+nags="$nrgs"
+# We want to test with and without stress. The reason is that, if stress
+# fills up the filesystem such that all the RGs are non-empty, then all
+# the shrink commands will fail and we won't be able to test recovery
+# during shrink. So to cover all the types of scenarios, we are testing
+#  with and without stress.
+for stress in 0 1
+do
+	for metadir in 0 1
+	do
+		size=`expr 512 \* 1048576`	# 512 megabytes initially
+		sizeb=`expr $size / $dbsize`	# in data blocks
+		_scratch_mkfs_xfs -bsize=4k -dsize=${size} -dagcount=${nags} -rsize=${size} \
+			-mmetadir="$metadir" -rrgcount=${nrgs}   >> $seqres.full 2>&1 || _fail "mkfs failed"
+		_scratch_mount
+
+		$XFS_INFO_PROG $SCRATCH_MNT 2>&1 | _filter_mkfs 2>$tmp.xfsinfo >/dev/null
+		. $tmp.xfsinfo
+
+		if [[ "$stress" -eq 1 ]]; then
+			echo -n "Testing with Stress "
+		else
+			echo -n "Testing without Stress "
+		fi
+
+		echo -n "-m metadir = $metadir "
+		# Shrink the filesystem in random sized chunks while performing shutdown and
+		# recovery. The randomization is intended to create a mix of sub-rtg and
+		# multi-rtg shrinks.
+
+		while [ $size -ge $endsize ]; do
+			echo "*** shrinking a ${sizeb} block filesystem (shrink)" >> \
+				$seqres.full
+			if [[ "$stress" -eq 1 ]]; then
+				_stress_scratch
+			fi
+
+			decsize=$((RANDOM % 40 * 1048576))
+			size=`expr $size - $decsize`
+			sizeb=`expr $size / $dbsize`
+			$XFS_GROWFS_PROG -R ${sizeb} $SCRATCH_MNT >> $seqres.full 2>&1
+
+			sleep $((RANDOM % 3))
+			_scratch_shutdown
+			if [[ "$stress" -eq 1 ]]; then
+				_kill_fsstress
+			fi
+			_scratch_cycle_mount
+		done > /dev/null 2>&1
+		wait
+		_scratch_unmount
+		echo "succeeded"
+	done
+done
+
+_exit 0
+
diff --git a/tests/xfs/333.out b/tests/xfs/333.out
new file mode 100644
index 00000000..ae10574c
--- /dev/null
+++ b/tests/xfs/333.out
@@ -0,0 +1,5 @@
+QA output created by 333
+Testing without Stress -m metadir = 0 succeeded
+Testing without Stress -m metadir = 1 succeeded
+Testing with Stress -m metadir = 0 succeeded
+Testing with Stress -m metadir = 1 succeeded
-- 
2.34.1

