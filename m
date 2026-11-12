Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794473692;
	b=GJZBmahzpA1o2GqnceKVipRHe4Lgnr10etuPvLUk5ZYWi4uIJMOczTxzdCjgZqp+oxW3
	 SBOZDhseuWhdGeQypVBiYv8Bvvy7bPAjlTgus5SpT64RFY3Y8h3EaH4x9epbuhGwvFwwp
	 dCIjcZtpAx3nSshXw4p2y7oqBJdTUDYRdbV0KUis9XYrH3t571/RxmMMZ52e3davf6PR+
	 zcGwNXbBGtxQiQu1Qva9DjqerIgdribIFoC3yVy2olNJn3IZPWVRMA0VqwS72CFAGiE9N
	 /O9xrvJSseDimJw0e1zBYAGIeukeKD14RAZqUgVjtoJ6/zs/JdwonFbXX8tVPGCK6Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794473692;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-TM-AS-GCONF:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=gLkp9fR4J1Hx3FpReblhfzk5zJx+vl5VLp5NLQqRvPw=;
	b=qkSVHcAieKxqFQcW3kNPChPB/sKcMsqzs7jaCIq3evvyKsNW1mFh4QZbN50NdOzZcX0n
	 f7qWNqVrWtIS8tyqm3IWBCewHB7q4qmJdxQj73JfQohfivacTAx+jwNMEC+fU8Jgaqi7b
	 n3oZfF1T78siwpT2N0LQzUwJ+PM+kXtFsXD0BQalNabUol6wXQiZ2DvoNaRH2B30/xcjW
	 GqDE7Co3NS7DuFZCzhQWJqrEnY/lN6gaEs0M2qsgR58H5ZedWhdqpxU09ZAgEVXFVihGa
	 1TE7b6o8Hj8V7FWl6hL7z6cKJ39/3Kz2ZQP9sJF4p4vDKXh5mu83SM99G8dVFkglnKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b="M/741mKn";
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEC8606A323;
	Thu, 12 Nov 2026 08:54:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CEC8606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=M/741mKn
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC2iE3k2795601;
	Thu, 12 Nov 2026 08:54:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=gLkp9fR4J1Hx3FpRe
	blhfzk5zJx+vl5VLp5NLQqRvPw=; b=M/741mKn6T28uRLs/FZWIUwpDIfeDW4kN
	Ny+/Mr/yLnZ5iJJv2F8HVRNerrcOHWSrwWOKjnZJt9NcX39U9ES6WmELU22xm2oQ
	EFhklDDqysivlo77JSc+pK7bzwZ79qepmehDINNFmxLcGZ8F5l0W2KwtvbFSD9OU
	2n5EsFlu00ZmJNVkLuYzRme52FPwPwxUqgYhgaBodf4bvaL3wEO9EZXLqHc0k9kH
	F9lB8MOAnG7mr7mpAeA55l/uei+dit//gg/7Yap/hGCT/06ldgX0JYahrBUaaRjv
	01jYU+aM5Q/jF1C5N97bsdlpS/hqI144YG3pE9BggReWyjt9SFQvA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hssdkx6rm-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 08:54:48 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC8DJE1053937;
	Thu, 12 Nov 2026 08:54:48 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hv309r30k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 08:54:48 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AC8sibC42664344
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Nov 2026 08:54:44 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D27E2006E;
	Thu, 12 Nov 2026 08:54:44 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 868E120069;
	Thu, 12 Nov 2026 08:54:41 +0000 (GMT)
Received: from li-c2a6f0cc-327f-11b2-a85c-8351a23fe076.ibm.com.com (unknown [9.66.81.33])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Nov 2026 08:54:41 +0000 (GMT)
From: Barnali Guha Thakurata <barnali@linux.ibm.com>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, ojaswin@linux.ibm.com,
        Barnali Guha Thakurata <barnali@linux.ibm.com>
Subject: [PATCH 2/2] xfs/601: skip test if TEST_DEV has insufficient space
Date: Thu, 12 Nov 2026 14:23:13 +0530
Message-ID: <485259ed3afdf26dd68ecd5b567258e3d1f1d35f.1794470252.git.barnali@linux.ibm.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <7c72292aca3a279987feb6722aba2cedfb720159.1794470252.git.barnali@linux.ibm.com>
References: <7c72292aca3a279987feb6722aba2cedfb720159.1794470252.git.barnali@linux.ibm.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=POqaavqC c=1 sm=1 tr=0 ts=6af57ed8 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=at2klVYvxK389UH1VQQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzNCBTYWx0ZWRfX4PrrsVdFYuAm
 B0A79lqPRyn5onDwPJoiEowub3hpdfNm8zO7xm07W1Exk0Z2yI8l++AZjk3kbhW8wMo+1ndb3CP
 k6Em1xwQMflBlFI7gXSQlofBv88Uttymrcl6VhTvUZo+bCQgMcbKhyUr8rFezJ1KvuMj5NMk44h
 yL82M9F/fevi3lJtKE05zFLt8Y78dnGscN5F+fXOwth0Ik9jo1KBRHX9dn1HcoJH8/n0vOuUoWP
 AnpC6ED5zhoRPy+8+L6Wk9SAkOW8GwT9qKkgzCWpXiGXEJNVO2hcjTlXyoCcLztiPkXIdh+RALm
 t6sxljXuYvNe2IyGf3nbq26lLlIdMTEt1Fprd9jyw0po0zPjqdY0JfTTRZvKHsOCo+2g3XOJ515
 ANCm3DCXj7TJZsCsj3G7+ozxYO6ZppEAE4QKSd3HkWo8TPWnPrgmpr62zguNmnDNAtDghLSVpxx
 UMu4+qFTB3w+aKVEVwA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzNCBTYWx0ZWRfX1UpPN+pEf4e8
 elRgj87mmOregIE/cc+sGUH7AJp6YTzRB6JvzxHMc5+qCDjT+6O8ZH1iqLRIh8TfztIRxavpw2W
 F/DgcNjIUwPwQEw3s+n8Yc9tOeTs3Dk=
X-Proofpoint-ORIG-GUID: 0f-oNYxzN1SnP65joruI0R_3WEafYHQe
X-Proofpoint-GUID: 0f-oNYxzN1SnP65joruI0R_3WEafYHQe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 impostorscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120034

Currently, the test fails with no clear message when TEST_DEV does
not have enough free space to hold the copy img of the scratch device.

Check that TEST_DEV has enough free space before proceeding and skip
the test with a descriptive message if it does not.

Signed-off-by: Barnali Guha Thakurata <barnali@linux.ibm.com>
---
 tests/xfs/601 | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tests/xfs/601 b/tests/xfs/601
index 44911ea3..a30f6732 100755
--- a/tests/xfs/601
+++ b/tests/xfs/601
@@ -34,6 +34,18 @@ _xfs_skip_offline_rebuild
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+# Check if TEST_DEV has enough free space for SCRATCH_DEV copy img
+test_avail=$(_get_available_space $TEST_DIR)
+_scratch_mount
+scratch_total=$(_get_total_space $SCRATCH_MNT)
+scratch_avail=$(_get_available_space $SCRATCH_MNT)
+scratch_occupied=$((scratch_total-scratch_avail))
+_scratch_unmount
+
+if [ "$((test_avail * 100))" -le "$((scratch_occupied * 110))" ]; then
+        _notrun "$TEST_DEV too small"
+fi
+
 mkdir -p $testdir
 copy_file=$testdir/copy.img
 
-- 
2.56.0

