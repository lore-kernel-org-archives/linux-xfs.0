Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9712E06ED
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 06:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771570548; cv=none; b=kk8Sgmdj8bLfJvInGc8ZUVT9pHSe7AiHRuMXLOFMdldivPmHjidrTn1P1U2488LpJzrXtaP2BxmoyJrarYKXA1IvBGWd+IazwQFHxwBnSOf+qGk7INBXPW2XC6gJak+21vJK6mtDIrFXZDZNUG6UTsT1tfOvrdWR+vIxtiKd0UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771570548; c=relaxed/simple;
	bh=J0Yz2BpCweszjTMesgkSBAonhbtiQOiLKRwjLhklLM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmHhWwMb+m+12fUkTUTj41qWCW/mptjLSNaXc9PLDXmXpYzJb4kAyEZcQB+0izCSwx8ktd78L6pocL9Vc9r+FoQpi/rukqfwWBzEwTDoFHo9pV103s1FrSngs5QstGbVCa6GDl2YWISG1g48R/3zjzzvf80W3Sku3J1bwkMc1cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LMKXPXBA; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LMKXPXBA"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61JLhhI41260060;
	Fri, 20 Feb 2026 06:55:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=7QzCgDmQiTUa3QkYH
	hEmN2RBwoWzAlE4TLgV2HEXKBg=; b=LMKXPXBA/Xqej4PIS1lbYGcUYmhNV92QM
	VasLcgFVfkoByDfRjqHhNWR6eTEUn/45ELLCtMeknuRkmyYjOxFeRFx9f2xGDzwW
	qkUlxTgiWF92yc12+VThZT2YnH4z+oYAo5pkHs0bOmD+BER4ocQreKDH/VU+nurV
	TOcLXBRjDQyXvicT1M2j6i0gw8A2UCHoKibnPscEvjyHWWkzV/SF6rTsd8oUDFAu
	1POk7eQZoZPdRKKbOMMGYzj+Q/cz80LXPmsVUT6XqKAGlS6qiY3y/Ua4lqNeYwmm
	VXZnyYU4CJ0O86DngA44hn5qZDlz3B/gFSx+mAazD2eYE9+0R2lkg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj6s9sn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Feb 2026 06:55:30 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61K4I7Ka015697;
	Fri, 20 Feb 2026 06:55:29 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb45fd6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Feb 2026 06:55:29 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61K6tSbA32768626
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 06:55:28 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2CD2D580D1;
	Fri, 20 Feb 2026 06:55:28 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 85B0A580CA;
	Fri, 20 Feb 2026 06:55:25 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.30.51])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Feb 2026 06:55:25 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, nirjhar@linux.ibm.com
Subject: [PATCH v4 3/4] xfs: Update lazy counters in xfs_growfs_rt_bmblock()
Date: Fri, 20 Feb 2026 12:24:00 +0530
Message-ID: <93141377d9946c803bccee1c95f21fa55da476c3.1771570164.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1771570164.git.nirjhar.roy.lists@gmail.com>
References: <cover.1771570164.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=dvvWylg4 c=1 sm=1 tr=0 ts=69980563 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=HqRPCohBQm_1MbEnWikA:9
X-Proofpoint-GUID: BybR1HhRcvwvyJzNzoGVS55ciIbv1qBO
X-Proofpoint-ORIG-GUID: tJHLOiytqwH4HlB9NQa-ZsSB_6TR4SbF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDA1NyBTYWx0ZWRfX9L6MBer9URxb
 dT99Ple9UpdgV4joxwjozECVA47iSrM8FVuxlAzGexbk6KESFIvIsJys1i9ukvuu9MxucNYQbiU
 S/dy/pvCR5N3UGaBzuYp6JlEU+DbBm4+Qh+0hWj3eUtKBIRfjjGP0S7rV0eXyJHxPcLOM39adPz
 PiShvfuIcahLGAz98M98p22lDdikQFWtHO1LFgT9YbLZx2lzDkdtP30Hfm0eMjnlk8AJK/BJkaP
 5s7+7Ap0OLzmko0bZZ5ShQBC6zZQ4VI0WVzJbRxnvBheLyDm7T5DlpR+Bd04kZ2c+75Ru09fKmU
 I0hA5e0yDKkmdzOOrE69ZnIZLXSrNo7SQIrpPFgDm8m2+W5pEBjrTmzpkF8ZxvwozWhI+X1GsVD
 vF1n0kS1sT83azCIdDGTmwtb577wFZ2u8AfK+oK8gbpRiKiTuwNC45rwPjDgVDdth26kJofLWGF
 KPrUSBW7kCxkWDvqc6Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_06,2026-02-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602200057

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

Update lazy counters in xfs_growfs_rt_bmblock() similar to the way it
is done xfs_growfs_data_private(). This is because the lazy counters are
not always updated and synching the counters will avoid inconsistencies
between frexents and rtextents(total realtime extent count). This will
be more useful once realtime shrink is implemented as this will prevent
some transient state to occur where frexents might be greater than
total rtextents.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/xfs_rtalloc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index decbd07b94fd..9d451474088c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1047,6 +1047,15 @@ xfs_growfs_rt_bmblock(
 	 */
 	xfs_trans_resv_calc(mp, &mp->m_resv);
 
+	/*
+	 * Sync sb counters now to reflect the updated values. Lazy counters are
+	 * not always updated and in order to avoid inconsistencies between
+	 * frextents and rtextents, it is better to sync the counters.
+	 */
+
+	if (xfs_has_lazysbcount(mp))
+		xfs_log_sb(args.tp);
+
 	error = xfs_trans_commit(args.tp);
 	if (error)
 		goto out_free;
-- 
2.43.5

