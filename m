Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6988B2E764D;
	Thu, 19 Feb 2026 06:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481534; cv=none; b=qnrrzFQkW2kGwT8g6xUpUszkJEFcOQExDOg7jLzR6F3TbXZjVHdn5IoEo0feyLWvOVT3P9us/4nkz95zF7WRwzJbt7feLm7QctiWvfSrTHkxBg6Ae+YdAKWykZqmeJG46yFojZgSapRJYiiWMpbkM7/Y9d25lceZf7NZIfzaDO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481534; c=relaxed/simple;
	bh=kJRiRJvZd56iGbih6Uy7hf2kXGmkDa+nxLm6vCMYeK0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qTQGDr1mVC8w8M9I4G6FhqPF20OTlqxrFNIzedFtKBxyPelA1U1mPf/pwyjA3z1lyJRAiqA9wD1KxwlUpo6/JFVq8XZxGrJSrcQh/wjQe4Niedz8tdiN0Io7yHau+B7LPgY/ZWr/eU7B0rE7aAXKy/W3pfaMW65jXpUKEEGUem0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZV5KLJN7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZV5KLJN7"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61J5ku5k3246617;
	Thu, 19 Feb 2026 06:12:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9Wz6EZg9ZxgzIWtA8
	7lSKKtdeOJuEOrdB/TbjicryBw=; b=ZV5KLJN7vwzRyFbwXO4xV9R1uBosEXQrc
	z4GbaovwNcX3zbbADpv3fSIDx/x+d1cLo5dUqam9xVSaKa55D9n3L8hmsIeAw7a2
	IKSfKEUFTnvlKd67iQGSWzxijDxzazOx9T3HBRyNJ5Q4dLvSN0giNUWSj8bokLRq
	KmlRVcntYaSWeJ3WhsUbQo7t4XC046id2E+JtylcSJ9C05XUVY7Fzz15h/a7j1tH
	RJvXeilJqLIYooyf4/b/Pr3COkofhSxVr5v3jiYcarQzbzZzhULZQSyMXlq6i1ZK
	21felGAbZvdMnWivGC2r75pame11kBm5VMv1qVRmpypqHVl03h82g==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cajcr4qtq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:12:05 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J2rAWf017804;
	Thu, 19 Feb 2026 06:12:03 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb28k0rc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:12:03 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J6C2nW31195782
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 06:12:02 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 47D085805D;
	Thu, 19 Feb 2026 06:12:02 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD25158059;
	Thu, 19 Feb 2026 06:11:58 +0000 (GMT)
Received: from citest-1.. (unknown [9.124.222.193])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 06:11:58 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org, david@fromorbit.com,
        zlang@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, nirjhar@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, hsiangkao@linux.alibaba.com
Subject: [PATCH v1 7/7] xfs: Add parallel back to back grow/shrink tests
Date: Thu, 19 Feb 2026 06:10:55 +0000
Message-Id: <2f398d9eb67a7653771ae3ab48710b5bf570f7e6.1771425357.git.nirjhar.roy.lists@gmail.com>
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
X-Proofpoint-GUID: 4F8sKQODU-kuzmpry2_wfdhv-rFTpKYR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA1NCBTYWx0ZWRfX95HMyFWs1Ev6
 +nE9alnGZohS54ZUPfGLfnlvNUvIOpQYW9KGNVYYuBhkKAxz6HWPWQl06bsEoLVBlDWUZSLm2nh
 9ND501ibUqItziA0FecnYQtviIcrjsS1NoL9LfCJfRfes0u9zy3njGUBpEFvktzLiRpcd7qb1wr
 FM/I3lsXQ0a1V6eSbqrlwYx61oQl4Q9doP27ga3CPLhNWhZH3yGgpy1ziwiCvb8ggr8NowEU2nE
 gmYsY824Fg6521gTdlK/bufHMecs2t1iUWX6BFhiIieE2E1xJw/P1PGakCEw3mcgEFkTasBNFiq
 Vw3MCxsZqLTDb18tRqvpCK4VXQgmut+2oK1WtpDzKF/d/Y8Y7uwpoHjc8YJctSVRRrzXvaBrN9s
 DLVYjHqrgRPuvj3JrtVTiXFkmDBQC5mMYgFAUXD9Mb9WZvijuE05gSGw5mgkyba/Hl2fCFbH2Mf
 yjRJHwYbDhUExbkRZfA==
X-Authority-Analysis: v=2.4 cv=UPXQ3Sfy c=1 sm=1 tr=0 ts=6996a9b5 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=m_HicBpoKuQeKNDMCMkA:9
X-Proofpoint-ORIG-GUID: WLfrkhM6uYYF1vFss_onIYHVBHwgzRvV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_01,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=0 adultscore=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190054

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

This test makes several parallel back to back shrink/grow requests and
makes sure that at the end of all operations, the filesystem is in a
consistent state with no corruptions and crashes.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 tests/xfs/611     | 97 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/611.out |  5 +++
 2 files changed, 102 insertions(+)
 create mode 100755 tests/xfs/611
 create mode 100644 tests/xfs/611.out

diff --git a/tests/xfs/611 b/tests/xfs/611
new file mode 100755
index 00000000..67f1d92f
--- /dev/null
+++ b/tests/xfs/611
@@ -0,0 +1,97 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>.  All Rights Reserved.
+#
+# FS QA Test 611
+#
+# It creates NUM_PROCS number of processes. Some will  pass, some will fail
+# with:
+#    a) operation in progress
+#    b) no space available
+#    c) size unchanged.
+# All the back to back xfs_growfs requests are made without recreating the
+# filesystem in between 2 consecutive requests. This test ensures that even
+# after several grow/shrink requests, the filesystem is in a consistent state
+# and there are no crashes or metadata corruptions.
+
+. ./common/preamble
+_begin_fstest auto quick growfs shrinkfs
+
+. ./common/filter
+_require_realtime_xfs_shrink
+
+AGCOUNT=16
+RGCOUNT="$AGCOUNT"
+FSSIZE=$(( 2 * 1024 * 1024 * 1024 )) # 2G
+NUM_LOOP=500
+NUM_PROCS=$(( 4 * LOAD_FACTOR ))
+_require_scratch_size $(( FSSIZE / 1024 )) #KB
+
+_fixed_by_kernel_commit	a65fd8120766 "xfs: Fix xfs_grow_last_rtg()"
+_fixed_by_kernel_commit xxxxxxxxxxxx "xfs: Fix in xfs_rtalloc_query_range()"
+
+_stress_scratch()
+{
+	procs=4
+	nops=9999
+	# -w ensures that the only ops are ones which cause write I/O
+	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w -p $procs \
+	    -n $nops`
+	_run_fsstress_bg $FSSTRESS_ARGS >> $seqres.full 2>&1
+}
+
+setup()
+{
+	_scratch_unmount $SCRATCH_MNT >> $seqres.full 2>&1
+	_scratch_mkfs -bsize=4k -dsize="$FSSIZE" -dagcount="$AGCOUNT"  -rsize="$FSSIZE"\
+		-mmetadir="$1" -rrgcount="$RGCOUNT" 2>&1 | \
+		tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs >/dev/null
+	. $tmp.mkfs
+	_scratch_mount >> $seqres.full
+	RGSZ=$(( FSSIZE / (dbsize * RGCOUNT) ))
+}
+
+run_loop() {
+	for ((i=0; i<"$NUM_LOOP"; i++)); do
+		numag=$(( RANDOM % 17 ))
+		nblocksag=$(( numag * RGSZ ))
+		numblksoff=$(( RANDOM % RGSZ ))
+		nblkstot=$(( nblocksag + numblksoff ))
+		$XFS_GROWFS_PROG -R "$nblkstot" $SCRATCH_MNT >> $seqres.full 2>&1
+	done
+}
+
+start_test()
+{
+	for ((j=0; j<"$NUM_PROCS"; j++)); do
+		run_loop "$j" &
+	done
+	if [[ "$1" -eq 1 ]]; then
+		_stress_scratch
+	fi
+}
+
+# We want to test with and without stress. The reason is that, if stress
+# fills up the filesystem such that all the rtgs are non-empty, then all
+# the shrink commands will fail and we won't be able to test. So to cover all
+# the types of scenarios, we are testing with and without stress.
+for stress in 0 1
+do
+	for metadir in 1 0
+	do
+		setup "$metadir" "$stress"
+		if [[ "$stress" -eq 1 ]]; then
+			echo -n "Testing with stress"
+		else
+			echo -n "Testing without stress"
+		fi
+		echo -n " with -m metadir=$metadir "
+
+		start_test "$stress"
+		wait
+		_check_scratch_fs
+		echo "succeeded"
+	done
+done
+# success, all done
+_exit 0
diff --git a/tests/xfs/611.out b/tests/xfs/611.out
new file mode 100644
index 00000000..21f0c43b
--- /dev/null
+++ b/tests/xfs/611.out
@@ -0,0 +1,5 @@
+QA output created by 611
+Testing without stress with -m metadir=1 succeeded
+Testing without stress with -m metadir=0 succeeded
+Testing with stress with -m metadir=1 succeeded
+Testing with stress with -m metadir=0 succeeded
-- 
2.34.1

