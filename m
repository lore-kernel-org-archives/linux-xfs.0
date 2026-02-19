Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7438D2E6CA0;
	Thu, 19 Feb 2026 06:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481519; cv=none; b=CE3zmH+gbEOoMV5J8mZLp+zbG/zmDCKaMBBr4hLZQ9Jtd+0MQYICVnsarAR/x1D3BnMgcDUv7o8tTgcNFkojlUJFmeQRdduFGRhJ83oZl+Vn2kuVQInk5rYX9QLqLjl/JvPfRoSo7da33isgGSmXeOfpug1m1RyKKjWct6S/yMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481519; c=relaxed/simple;
	bh=bNH837YSHsJwAQCW+wu/A/raXqdaWPy7N3fylJbjOrQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j1RfDMj+3NJ1XEeKfPlRoo+/5MJqzaQMxTqs/+/1DTkacNRPl75bkdVhGJ2y4lDYQgIkuN4GalGPxh21Ld3PmCe9BRL775cCZuUi8VF2u4JRZYGR0GvzM+odxLxHL0pTw1nJZkX4ssc7oAVYhzxjwd1dXwu9fG07vslrROpkKTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=a42dErcT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="a42dErcT"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61IJ7PDd2549181;
	Thu, 19 Feb 2026 06:11:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=mg/TvYvd63H22xMBc
	aNDHp2b374JwaYOpTWCkqooVjU=; b=a42dErcTFKqVYt+JNfGV1SJUlajdMybt7
	0hbtDSRzyCFtW8G0vIHm3219sKRDBNv4gvQC69X+O31nC/p5s+YdrFl9AVzs8jiB
	gMVVIO/9BTGRFvnllEcp0auiSyv2tFH0KgtB6KFNn0ujOPofsTjQrNmr9Yauazn9
	jtniqA7j6rl7JO3f7WJTGJxek8zPsN786mW35Se2CT+PHRWjxGXX0yAHCbCwVuRT
	5PEDOT5LvG/Pt7Fh+R2zHdE2Uvl45jIDqRHqxU/99mrD7UOkGxLsNf2zXVlDDYDv
	alji1qIqp3jMDzzGpKiIJYk8F/Ibr3mFgsCW/afxJjnrfIDR8RTag==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cajcjkh6f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:11:39 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J3a77p015660;
	Thu, 19 Feb 2026 06:11:38 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb45b0jg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:11:38 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J6BbMr57737600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 06:11:37 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 92F425805E;
	Thu, 19 Feb 2026 06:11:37 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D62C45805C;
	Thu, 19 Feb 2026 06:11:33 +0000 (GMT)
Received: from citest-1.. (unknown [9.124.222.193])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 06:11:33 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org, david@fromorbit.com,
        zlang@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, nirjhar@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, hsiangkao@linux.alibaba.com
Subject: [PATCH v1 1/7] xfs: Introduce _require_realtime_xfs_{shrink,grow} pre-condition
Date: Thu, 19 Feb 2026 06:10:49 +0000
Message-Id: <8cc94248860f3f2516e23d06ba4f04e2d1a65421.1771425357.git.nirjhar.roy.lists@gmail.com>
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
X-Proofpoint-ORIG-GUID: 52gZpvjW6B5sz2HoUmw3H6Xuooyforkx
X-Authority-Analysis: v=2.4 cv=Md9hep/f c=1 sm=1 tr=0 ts=6996a99c cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=3D54dzztI_dHdAlfKekA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA1NCBTYWx0ZWRfX15ck61z5r7Xx
 qZMLxMJqdJltjCCUtGvfNZj6zxuTm0UFwjK0Dwy7q/WCMEYWnFdRzODUi1MxuTrQhS/sYP951yo
 jlHhmnSQMQK7Wt536qql1q+m5HDmSkIuSQP7cs2xutSBLMzmUFdahpetDxcXKbVh/vKx4cEsTqD
 jG+h153OThYR71mtaJrA2WTr6FWEp/LAzB+7BBO9RYiT8SzOr0cFJfttKJSIodcyN/el1KVOC5t
 DKYWOWKNkWWhcfYm18dA47KoCjsrjc+QbWqFqMJFnXTKvP18mfg2Ea1GbvYEGqRCVy5h/qkg5Ru
 +nNOEGzK2ELDvUQ6issaNYKSxt65TfKNdpNRckUcgqClHrkRwMzj8pHbCBlrKHCbzYjOkcvilEB
 kU9l3M1NoXREvLj7ssb+uNy3UB+Lo0B65Ru/tuvp8iqu3eC9I4ZDi8hs7xEFp/q6+cI6FUTIXhj
 uAeAcNv24ZM16Dvux1w==
X-Proofpoint-GUID: 1ULF6gJKMkuAmbhvFYFQnzbZWYA9a9ny
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_01,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190054

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

These is required for the set of XFS realtime grow/shrink tests in the
upcoming patches.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 common/xfs | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/common/xfs b/common/xfs
index 7fa0db2e..8e4425b4 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1233,7 +1233,11 @@ _require_xfs_mkfs_validation()
 
 _require_scratch_xfs_shrink()
 {
+	local is_realtime="$1"
 	_require_scratch
+	if [ "$is_realtime"  == "1" ]; then
+		_require_realtime
+	fi
 	_require_command "$XFS_GROWFS_PROG" xfs_growfs
 
 	_try_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
@@ -1241,7 +1245,12 @@ _require_scratch_xfs_shrink()
 	_scratch_mount
 	# here just to check if kernel supports, no need do more extra work
 	local errmsg
-	errmsg=$($XFS_GROWFS_PROG -D$((dblocks-1)) "$SCRATCH_MNT" 2>&1)
+	if [ "$is_realtime"  == "1" ]; then
+		errmsg=$($XFS_GROWFS_PROG -R$((rtblocks-1)) "$SCRATCH_MNT" 2>&1)
+	else
+		errmsg=$($XFS_GROWFS_PROG -D$((dblocks-1)) "$SCRATCH_MNT" 2>&1)
+	fi
+
 	if [ "$?" -ne 0 ]; then
 		echo "$errmsg" | grep 'XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument' > /dev/null && \
 			_notrun "kernel does not support shrinking"
@@ -1251,6 +1260,48 @@ _require_scratch_xfs_shrink()
 	fi
 	_scratch_unmount
 }
+_require_realtime_xfs_shrink()
+{
+	_require_scratch_xfs_shrink "1"
+}
+
+_require_scratch_xfs_grow()
+{
+	local is_realtime="$1"
+	_require_scratch
+	if [ "$is_realtime"  == "1" ]; then
+		_require_realtime
+	fi
+	_require_command "$XFS_GROWFS_PROG" xfs_growfs
+
+	_try_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
+	. $tmp.mkfs
+	_scratch_mount
+	# here just to check if kernel supports, no need do more extra work
+	local errmsg
+	if [ "$is_realtime"  == "1" ]; then
+		errmsg=$($XFS_GROWFS_PROG -R$((rtblocks+1)) "$SCRATCH_MNT" 2>&1)
+	else
+		errmsg=$($XFS_GROWFS_PROG -D$((dblocks+1)) "$SCRATCH_MNT" 2>&1)
+	fi
+
+	if [ "$?" -ne 0 ]; then
+		echo "$errmsg" | grep 'XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument' > /dev/null && \
+			_notrun "kernel does not support shrinking"
+		# if the fssize is already = backing device size, in that case,
+		# the above xfs_growfs will fail - but I don't want to the
+		# pre-condition to fail. This test case i.e, the new fs size
+		# greater than the backing device size is a test case that is
+		# covered in the test, so I will let the mount to take place so that the
+		# new fssize > device size can be actually be validated in a test case.
+	fi
+	_scratch_unmount
+}
+
+_require_realtime_xfs_grow()
+{
+	_require_scratch_xfs_shrink "1"
+}
 
 # this test requires mkfs.xfs have case-insensitive naming support
 _require_xfs_mkfs_ciname()
-- 
2.34.1

