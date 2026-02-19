Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001E726D4F9
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 14:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771512482; cv=none; b=lD6U4DD5CRtsmzkoHsHhfFJ/vJg3JnsdL2P45x3MYCY/rUCM2RmqISFWMmqMtgvxaxuOsrJlQZphIlzAOTLWjlmW//qt8XsmzhGW2xI3ayjVcvjKTubhaqGdOUg/Guqc/ovnxpgCIcZnypG6len8wnEVcO7hzT3HLn1jbcWh6uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771512482; c=relaxed/simple;
	bh=BA/bW8l3cEJWBZ7P9vHabN/9fXqLkPIdAngKs5N0zSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GTKzPAKRKy8OlM5ayxjrWYpnpgtsyXYBd+q8nTggPZV5VVqaI5hoYIcvB8t7+JxL9Y7lZmdbFhtPpkfF65BOnzdXFcqwF175Np4OXQAVGJCncKaQttKA9R4buyxbIzsqfZtK9B12r+Fn0lS9WZS8BsYlp3UPhldc7+HsvdcXg38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iq1FL6k+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iq1FL6k+"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61J99xTX1368485;
	Thu, 19 Feb 2026 14:47:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=uxBWVS4JzhmGIQSkP
	EULAu3ns20LbCTmsqIFVCShCJ8=; b=iq1FL6k+l1KMiSYuQZM0b4BPwesKakOL6
	J+f2Ag+hLUlZXgXxUywziFOGhu3ieR3dJVR7O3CDAlHk09ZxEn4mgmWQu+r4Hmqp
	4mnMbSqBtdRkxwUPgVAnGxF4M9w0gc5QsNjJxPPK5lI8zNhKHrATyteKz4/TjjC9
	/pBUpjyH60VOUl7k+gsrk/cWgDYKqKwXJQXUNJtHQLe/QKKu/bprgJRS/GIRfHJ7
	glwrZD7aj4nveLePDVwX38N0sq1IblD0eaHni4lewTvYzz8ogpQwpC0NMcFxA0DQ
	cZgaLYHCyKJRWFMp/ts+06CDyoBzkQRt8foGcpKG+feAaGyiiCRTA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cajcjnaeb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 14:47:52 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61JE2ehV015690;
	Thu, 19 Feb 2026 14:47:51 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb45chv1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 14:47:51 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61JEloLI53412148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 14:47:50 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B598E58043;
	Thu, 19 Feb 2026 14:47:50 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 498B058055;
	Thu, 19 Feb 2026 14:47:48 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.21.217])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 14:47:48 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, nirjhar@linux.ibm.com
Subject: [PATCH v3 3/4] xfs: Update lazy counters in xfs_growfs_rt_bmblock()
Date: Thu, 19 Feb 2026 20:16:49 +0530
Message-ID: <8b7290dbe12fccd57b317562de68cf77ec670d96.1771512159.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1771512159.git.nirjhar.roy.lists@gmail.com>
References: <cover.1771512159.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: lfQnMxeaRhzdtTvYabybjELuUGExuATF
X-Authority-Analysis: v=2.4 cv=Md9hep/f c=1 sm=1 tr=0 ts=69972298 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=HqRPCohBQm_1MbEnWikA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDEzNCBTYWx0ZWRfX/V+jbImEtb7e
 sH21IChPHUMmdUFvd/BE8gVQJUXPCBHKbwMbCpE67mi2xNtrVKYqAfQgPlCtnMja3nQxK/i8HXt
 UaS8qSLeja+xR11D2ToDszPSJHmolz67GQtGdSE4+OWIB+FzNfvavCXLVAF9iGNlfJMvDU70qnC
 DpIg59k5ZV6YT/x41WON9F/tjnMuxU6HMcjSgH99o0PK6B/76TbJkKOUC5ucfsUWvFjvRQvXQ65
 fMb1ls3KMoW/xw31KBz+4TrWpCk22/lbQd/pTYFeaVH1zHECpkGnXzzK6+OQbnEA/l4Toy0YY87
 Vl/IMNYjPmflbcKGVG8Eio8FaOnhw8DpqEdAKpRoOwdd+Qx+9j9K5FUeIz0tGgdlcLJyZlqfIsz
 xqtds6vAE6RLdIWfrdHrZQ6KGu8vH5zTIJmeipemxTVq6xwBtiauErCMe1l0S1M4+CsfmKLh7/z
 FAEFbcv4IyAwBdPdR7A==
X-Proofpoint-GUID: 9JWdL42WuvkEvPlV7CgrShq8eftQ1xfM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_04,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190134

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

Update lazy counters in xfs_growfs_rt_bmblock() similar to the way it
is done xfs_growfs_data_private(). This is because the lazy counters are
not always updated and synching the counters will avoid inconsistencies
between frexents and rtextents(total realtime extent count). This will
be more useful once realtime shrink is implemented as this will prevent
some transient state to occur where frexents might be greater than
total rtextents.

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

