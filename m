Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BBB2E92D2;
	Thu, 19 Feb 2026 06:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481521; cv=none; b=LJmTBXs7GQmF8dPu9CA5zbScLJ8TnZtxX3p5i8OhWa/X3rh2rxqGClkBueLEi3Dg4zA1Pe1TAkeCLNKQatspx/FVoCee+LXtEga/JBkM39M/JtvF44vgftNPsVE/8wL21H8Yi8/ALcKUirE3NX80R/nd+US3lcEaCfUkV6ZBr0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481521; c=relaxed/simple;
	bh=TWgxqmfywYTdVuFcPtMmOS1XXk7xMnQ368PFo9jgxZo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=liyUt4mfRiwN9l2VNlTmepL7psCInkkkelm94DI5MzCBl4nSPW4hiuzUvBDMveIJVR0FeXSGcT9oqGeKEhW5b+UAB82BB9NqcDfKYCJDuAS1JGmaoNUAkx4f1v/OhnhyZm9rppMgVHx20z++d2gquIAfH6DZmeLlAzTQzqoEurs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MRSL534A; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MRSL534A"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61IGOHT52414481;
	Thu, 19 Feb 2026 06:11:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=HCvoklGOtXqOwVNsy
	6VFa9EdqPv5dA7s2My8xVAhwaI=; b=MRSL534AkPTWapH8iJiHTdXwApgl+o0H8
	azYp109EoXsTWn/6VuUn+WitI1ncNMtCa9jTWyJH9XwZ0sHIPbbiJb/HXoSN7LtS
	yBDaKbeiUiAayDD2tpMaGHQ+jKEiYTWy8yIMWgIvTqypRMbaA9GcSZbLANlIirvY
	MJRVszaMH8JQ9SxF35CBjefXrhwKH4iZn1wJT3OZK3b9U2v9jRBnEcMAsHu+2wTj
	8kO1+dQr9rmNS1m3Y47OvP/V4xOTlu1t3Xq2iT66zT+klWPD95zcrNt0MllPJHvR
	FP3EnJ5a6973COA7YGAyok4+W85Frz+izneO8oRuhLCWcwFLhwOvQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj6uvpnr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:11:52 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J44X9Z001419;
	Thu, 19 Feb 2026 06:11:51 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ccb2bk06c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:11:51 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J6BodK24642194
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 06:11:50 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E0CC658059;
	Thu, 19 Feb 2026 06:11:49 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7682E5805D;
	Thu, 19 Feb 2026 06:11:46 +0000 (GMT)
Received: from citest-1.. (unknown [9.124.222.193])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 06:11:46 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org, david@fromorbit.com,
        zlang@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, nirjhar@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, hsiangkao@linux.alibaba.com
Subject: [PATCH v1 4/7] xfs: Add multi rt group grow + shutdown + recovery tests
Date: Thu, 19 Feb 2026 06:10:52 +0000
Message-Id: <45938faaf999fb56f465224c5283a663a7a09a97.1771425357.git.nirjhar.roy.lists@gmail.com>
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
X-Authority-Analysis: v=2.4 cv=E+/AZKdl c=1 sm=1 tr=0 ts=6996a9a8 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=AHTv-iMW4wYKIy1ubzsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA1NCBTYWx0ZWRfX91tVUJeh0Tdg
 hdt9RugwICJyfqnl2WFWSICAQNf/akAR7nhhoKZzdTo08z2WovLhhyR2/evtBnpt2OTocRdsTJq
 Po5TbVXCCL6mJ3hMAvbNjtrBPqoQ82jYwjohemgAOImXwYXgCOUS/RWyowdoZXoeOaInvBnYohq
 VXU6jgpqSqszlNPD9/olOGD0HlWML1St4h0Buu00x+8wJGzgQMeifYSlu2d6cVJGBXErfTBV0vx
 1nqXvgRqdvKvqfZWx/bdccAlDjAH4r4vd6FIr/X2fv3p9eR9a/4MJigy6s5B8Gkr9gTY9wR00M9
 vuWXFC4CsiFwzw0HWYwE8zmcPVjr19EZ9HhF8HCQdKhxR+hCMn7dSIntG9OH6GkuY1xfVXJr7sN
 SFG02I56ZcuoAx+1Lhe7NnKjeY5xGlE9oFrNOolnaPYYsOK+Jxqgxk39qxRNVaAl2a+wwW4rryU
 vaha4tBAo01UCzrHoKg==
X-Proofpoint-ORIG-GUID: jO_udQoh1tgk33EMIgm51ypaIRejMhK0
X-Proofpoint-GUID: L-c6VgEGye9-0iKeluuG1tKG3VdAqkSO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_01,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190054

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

This test repeatedly grows the realtime, then shuts down the filesystem
and checks that recovery works fine - this is similar to what is
already being done in xfs/609 but this tests with realtime XFS.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 tests/xfs/654     | 90 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/654.out |  5 +++
 2 files changed, 95 insertions(+)
 create mode 100755 tests/xfs/654
 create mode 100644 tests/xfs/654.out

diff --git a/tests/xfs/654 b/tests/xfs/654
new file mode 100755
index 00000000..b5111e18
--- /dev/null
+++ b/tests/xfs/654
@@ -0,0 +1,90 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>.  All Rights Reserved.
+#
+# FS QA Test 654
+#
+# Test XFS online growfs log recover with growing the realtime filesystem
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
+FSSIZE=$(( 2 * 1024 * 1024 * 1024 )) # 2G
+_require_realtime_xfs_grow
+_require_scratch_size $((FSSIZE / 1024)) #KB
+_require_command "$XFS_GROWFS_PROG" xfs_growfs
+
+_fixed_by_kernel_commit	a65fd8120766 "xfs: Fix xfs_grow_last_rtg()"
+_fixed_by_kernel_commit xxxxxxxxxxxx "xfs: Fix in xfs_rtalloc_query_range()"
+
+_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
+. $tmp.mkfs
+
+endsize=`expr 1024 \* 1048576`	# stop after shrinking 512M size
+[ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
+
+nrgs=8
+nags="$nrgs"
+# We want to test with and without stress.
+for stress in 0 1
+do
+	for metadir in 0 1
+	do
+		size=`expr 512 \* 1048576` 	# 512 megabytes initially
+		sizeb=`expr $size / $dbsize`	# in data blocks
+		_scratch_mkfs_xfs -bsize=4k -dsize=${size} -dagcount=${nags} -rsize=${size} \
+			-mmetadir="$metadir" -rrgcount=${nrgs} >> $seqres.full 2>&1 || _fail "mkfs failed"
+		_scratch_mount
+
+		$XFS_INFO_PROG $SCRATCH_MNT 2>&1 | _filter_mkfs 2>$tmp.xfsinfo >/dev/null
+		. $tmp.xfsinfo
+
+		if [[ "$stress" -eq 1 ]]; then
+			echo -n "Testing with stress "
+		else
+			echo -n "Testing without stress "
+		fi
+
+		echo -n "with -m metadir=$metadir "
+		# Grow the filesystem in random sized chunks while performing shutdown and
+		# recovery. The randomization is intended to create a mix of sub-rtg and
+		# multi-rtg shrinks.
+
+		while [ $size -le $endsize ]; do
+			echo "*** growing a ${sizeb} block filesystem " >> \
+				$seqres.full
+			if [[ "$stress" -eq 1 ]]; then
+				_stress_scratch
+			fi
+
+			incsize=$((RANDOM % 40 * 1048576))
+			size=`expr $size + $incsize`
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
diff --git a/tests/xfs/654.out b/tests/xfs/654.out
new file mode 100644
index 00000000..9bb5cb21
--- /dev/null
+++ b/tests/xfs/654.out
@@ -0,0 +1,5 @@
+QA output created by 654
+Testing without stress with -m metadir=0 succeeded
+Testing without stress with -m metadir=1 succeeded
+Testing with stress with -m metadir=0 succeeded
+Testing with stress with -m metadir=1 succeeded
-- 
2.34.1

