Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794473683;
	b=MHN2UXRU0Tg7E8itWn2n8T9b6NUCd5YP+/V5lQX63pjWpPORoNg6nFIjjnj4n1pIB0xk
	 kjaQBlg296FFjXw9Ca2DE3fNrAaGTPkaReksN0f4jt0OSPXFqJ46/36zVdUBSTcMvLD5M
	 9RM7LBj5Pp0sT8FA5eZKuXQiAW5Dizy4EF6if5TtKmVnlyoh0OyWQc1mMbOGgj2ZsTyOw
	 9tWMuGOrhg4vxnZ/Ot0+y7+8XSD34YDMKxUEMkolo+BCbjgkKXa92O6mvq/r0MypKJEP8
	 8iWoPbsy3nXJZgheU0ExS6Mk3Vr0NZq5OtlLxO8b/16sJebNv3SauF/zGzJxmRh0V5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794473683;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=AQ6QX/9/Ngi6GpEyy1p+sSu6EZpzw1YUjuWKB8vrDw0=;
	b=fwbHbtCVnA3TU1GOWY6lIa/s9yvWpQoCMV70p868rTlDP/hcJ2UhP7W6Mordu2wof+vZ
	 qGok0Mp/vczKvEyx9biETi5cDq8emJhnSBx2ebrMoQ1CoLjta025Q58sDXT0Hmk0LuN2Q
	 ShhjjyuQMOG1SjicQq3qUVKSTOcSuMruSLHgB0eS+nSVHGx2eUsm3p2pyVW9sLIZCxDYx
	 eDc54LfheCaTyfnNlg8tvHNEig8Y7HYoVS7YmpZz86hDByzeAUo30r7GX8hJDVM+Z7AsH
	 9Cvmsjl4ECn1VmdJycO/bMvHGY8eiBp7kExFM65S/7Wrgw5TApY9rWNc/G3lgXjZw8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=NMPrXhmQ;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58182606A323;
	Thu, 12 Nov 2026 08:54:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58182606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=NMPrXhmQ
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC2iGM61214707;
	Thu, 12 Nov 2026 08:54:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=AQ6QX/9/Ngi6GpEyy1p+sSu6EZpzw1YUjuWKB8vrD
	w0=; b=NMPrXhmQikrj0XpH1Jh10RPj7bDIl6O0S1DH7JVH70aMm1mWlb8WTuTZv
	UMGuytjeAW/OYRGkNqBvFfZTvDhMBej4MjL0CVl/HV0Hx7UGRZnQRF7uEKHWk7Zm
	Pa++T8KB7rMNEGFPPPCwFYdZNoTwVhFctyqh+nkh0Kv2R5R9RYULlBJLhD/9Ltq6
	hvxai0AsVpdcN8WXHY9Y32N7wU9o7oHzl7JzlTBCEu2ud7BdALDyOlYiavWqsCE+
	DJ1EEha6BXXgBBCbgXCtpp1sMd8rTYCMdDOQS7NI6M7J3l4SBQsJ+aYp2FaSo6Uw
	pARxtO0ouXEI6KgoOWa/SLbCTXpEg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hsunten6g-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 08:54:41 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC8CmwR053934;
	Thu, 12 Nov 2026 08:54:40 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hv309r30a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 08:54:40 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AC8sass56164796
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Nov 2026 08:54:36 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BF3A72006E;
	Thu, 12 Nov 2026 08:54:36 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC0F420067;
	Thu, 12 Nov 2026 08:54:33 +0000 (GMT)
Received: from li-c2a6f0cc-327f-11b2-a85c-8351a23fe076.ibm.com.com (unknown [9.66.81.33])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Nov 2026 08:54:33 +0000 (GMT)
From: Barnali Guha Thakurata <barnali@linux.ibm.com>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, ojaswin@linux.ibm.com,
        Barnali Guha Thakurata <barnali@linux.ibm.com>
Subject: [PATCH 1/2] common/populate: avoid test directory space exhaustion from metadump caching
Date: Thu, 12 Nov 2026 14:23:12 +0530
Message-ID: <7c72292aca3a279987feb6722aba2cedfb720159.1794470252.git.barnali@linux.ibm.com>
X-Mailer: git-send-email 2.56.0
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzNCBTYWx0ZWRfX7SA0RmPVqhrY
 XNy1ufSQZw5m7M7qnsVr4bYGdiaBXILZYwYaBd7j4Us0ML1e3lmgnJtkBSkrobvV6z31JVTYGBr
 /XAbVtjDkkLxKeTLtL7kLoxyqNAOonbcDujdTA+xv4jY1o8qj7o7brrizYRH/8fmOhGuTz15ll/
 BbopjMK+VsIEoWP6QKnJk+tB1b2r5mFMkNurs1wb0VoXYMky0Xis7cpILuViCtS8ez5+1wrhqq5
 KL7gEoUV2W2AWF+R885+n7RkvbVS1grfrHUEh0cyOvKxuppf1SCh88D55j6CEHDPD4kY5IqOXbS
 aZVOOJQrKkcWSr1bqF2wuGXLfG72fZfjQdY5y8ZLlH/ou9+roca5SaWSdhY+4bOZJnZnJf+yszq
 W3ovDO7l5s1djpnA4ZsDJtVo7tke4z8/Dm4nv0u5xgGBqs42YBWSY9ABJodj+MO+XTugC88aVtH
 3Kbbc5jYiPKoI7Jh2MA==
X-Proofpoint-ORIG-GUID: YKn8JpZhr8RrIcG8ar13vMMdPyAv3OXW
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzNCBTYWx0ZWRfX7inXM1ekTB32
 GiaIjIKsMP6XTV9grDS1tMMpY7HWRLn9dZcNSOwXe6LRBGCVm8KdBVOJwCt+VWqSEnTW1qV3H8U
 67FGOco9sUEVh8GCMboo0L6SOF8JY7E=
X-Authority-Analysis: v=2.4 cv=euZKXYpX c=1 sm=1 tr=0 ts=6af57ed1 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=8wZH3mX2JmYfVqS-50EA:9
X-Proofpoint-GUID: YKn8JpZhr8RrIcG8ar13vMMdPyAv3OXW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1011 suspectscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120034

Previously, caching the populated scratch device metadump was done
unconditionally. Saving these large metadumps can exhaust the test
directory's available space, leading to subsequent test failures due
to lack of space.

Introduce a space check in the caching path. By default, only save the
populated metadump if the space occupied on the scratch device is less
than 40% of the space available on the test device.

Also introduce the "FORCECACHE" environment variable. When the user sets
FORCECACHE=1, bypass this space check and force caching the metadump.

Without patch:
	./check -g auto
	...
	Failed 46 of 1282 tests

With patch:
	./check -g auto
	...
	Failed 36 of 1282 tests

	FORCECACHE=1 ./check -g auto
	...
	Failed 46 of 1282 tests

Suggested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Signed-off-by: Barnali Guha Thakurata <barnali@linux.ibm.com>
---
 check           |  6 ++++++
 common/populate | 20 +++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/check b/check
index afe855bc..2846a52e 100755
--- a/check
+++ b/check
@@ -44,6 +44,12 @@ export QA_CHECK_FS=${QA_CHECK_FS:=true}
 # number of diff lines from a failed test, 0 for whole output
 export DIFF_LENGTH=${DIFF_LENGTH:=10}
 
+# Some tests use _scratch_populate_cached() style helpers to populate
+# SCRATCH device once and cache the metadump in TEST device so subsequent
+# calls can be faster. The caching is optional based on how much space
+# TEST device has, however we can force the caching using FORCECACHE=1
+export FORCECACHE="${FORCECACHE:-}"
+
 # by default don't output timestamps
 timestamp=${TIMESTAMP:=false}
 . common/exit
diff --git a/common/populate b/common/populate
index f3672c1a..8dafe45f 100644
--- a/common/populate
+++ b/common/populate
@@ -1177,6 +1177,24 @@ _scratch_populate_cached() {
 		;;
 	esac
 
-	_scratch_populate_save_metadump "${POPULATE_METADUMP}" && \
+	if [ "$FORCECACHE" = 1 ]; then
+		# FORCECACHE is explicitly 1 - always save the metadump
+		_scratch_populate_save_metadump "${POPULATE_METADUMP}" && \
 			echo "${meta_descr}" > "${populate_metadump_descr}"
+	else
+		# FORCECACHE is not 1 (or not provided) - only save if
+		# scratch device occupied data is less than 40% of the
+		# space available in the test device
+		test_avail=$(_get_available_space $TEST_DIR)
+		scratch_total=$(_get_total_space $SCRATCH_MNT)
+		scratch_avail=$(_get_available_space $SCRATCH_MNT)
+		scratch_occupied=$((scratch_total-scratch_avail))
+		if [ "$scratch_occupied" -lt \
+			"$((test_avail * 40 / 100))" ]; then
+			_scratch_populate_save_metadump \
+				"${POPULATE_METADUMP}" && \
+				echo "${meta_descr}" > \
+					"${populate_metadump_descr}"
+		fi
+	fi
 }
-- 
2.56.0

