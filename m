Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA3B2AD3D
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 06:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771570544; cv=none; b=MwpBH/r65jlKvDXE8zH71QaygdNGg+uYeV15askEQ+3TnfKnD4gQ4RKscpX3JDiGw3F61QJLzkSgp3DRUt/r/QVMucizbALsVnKNoDWSpBuXyhjIfImBva0k6SadYrZbnKU5FmV5xQ3/MQxbcHiLmbxdksO6WGrYgDHuctvCWjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771570544; c=relaxed/simple;
	bh=v7DMj2+qvtm1583GTJLmc4MDXnJpTwP0Pp4oQadZjLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1XieNHxlLcnYj2M+34sq44808pwMP7fHzjnOnYKJYNn2eLxchQuis7ClkEXxdvQWz/ePN/WCjo1baqluXgkZVwnuTMd+R7Rl2XlYNaBeW/j5iwIyML0KPAS4uTqod+fTpWWhYSvPjtzfULfecqbD/YkUa6Fu8kbXPtz8t1d5PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QdH5LTbZ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QdH5LTbZ"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61JMYfPu1294927;
	Fri, 20 Feb 2026 06:55:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=4dbJcgWVJrHLtyx7H
	rzv/wS3rDKo2w98yhslU3W8Z+w=; b=QdH5LTbZHYwzCR6JXCACN+XZB0j5rGpJt
	CdqGprP7AU82UNtDbssoF3YHL6JfLf0+iBXRU3+kyXJQPsoVi2UpOfHvpe3DHoXV
	oYGCdPYBhxFQ4P9uUOA8k1DDj6gIZ9dp0kzpls0Wu53WaJfFEoAD53lamBC655U7
	9TaseKpVhcDDv0qez3nW9CFZQ8nchhKg2cE+BXBLL2xP3V47nyptJdwm6Bky1nE9
	SwjqO60O5kGwAlNyQrKqF0PTRRg67i5ZYxyCc6Q6rjH4TAnTwER36rTN6z0ss8wd
	0bECFj3mF16JOUni9IOnks+4sQ4B6AdScvNChhWSSajIu638088mA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj64gd4x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Feb 2026 06:55:27 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61K4Cigv001432;
	Fri, 20 Feb 2026 06:55:26 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ccb2bqdhq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Feb 2026 06:55:26 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61K6tPdk28639908
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 06:55:25 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0676C580CA;
	Fri, 20 Feb 2026 06:55:25 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 51E81580C7;
	Fri, 20 Feb 2026 06:55:22 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.30.51])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Feb 2026 06:55:22 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, nirjhar@linux.ibm.com
Subject: [PATCH v4 2/4] xfs: Add a comment in xfs_log_sb()
Date: Fri, 20 Feb 2026 12:23:59 +0530
Message-ID: <11e9c7baa04f88d2a56568ad8fb434b248f53ba9.1771570164.git.nirjhar.roy.lists@gmail.com>
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
X-Proofpoint-ORIG-GUID: K-QlSOVEJOLp4meVqDgaLcNdKkgy8-jx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDA1NyBTYWx0ZWRfX68ID5qVPn/L3
 9Jza6G1mLmUwgEtzJuCk4WfLkgI0urAw7GQrtuFS1xwaKwYdtmggET8ezqNQJsRLw7CSUsALupq
 cUgfZpKO/0jgk8cirgJkx9643Y24kSztEgu83C/rnMAIRBI4e7mRxQ9EUzAibAjSuzkWY2qWX0I
 2FHKyTt7eKWasKT3SWG4T3f+u5NhLDMdvRAvoGZ23YNnX2jLFHMm6rpXaA+xdTG+z6J3obdr7YB
 pJP4zFJe6Qm1bW9EiqK0TVsO1L+9bSe866SvSY4DiF8dE/vgfjnvW4p7Z7Gw5dK8n01YUr+cVOY
 HWfKLlz81i3sDsjMGJtRQZHuPNzgyH7ZJtCroSy9O/KRbImQ63KbxTFpNQ8m3bFciOZNvFeVW0o
 FD2RPD8jcIOs3K8Noy9swZSLQJkllRerph2jhqF24Lcw1yZpodlU5KjKZ0kEmD31sVvW0tk1LtF
 7H+MgAA8BARknCOopYw==
X-Proofpoint-GUID: 6y4OC_8T1LJl5znlKJd-AYD7Dgcp2MrI
X-Authority-Analysis: v=2.4 cv=U+mfzOru c=1 sm=1 tr=0 ts=6998055f cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=McGMf-V2i_Dg8NkQ6AYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_06,2026-02-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602200057

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

Add a comment explaining why the sb_frextents are updated outside the
if (xfs_has_lazycount(mp) check even though it is a lazycounter.
RT groups are supported only in v5 filesystems which always have
lazycounter enabled - so putting it inside the if(xfs_has_lazycount(mp)
check is redundant.

Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/libxfs/xfs_sb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 38d16fe1f6d8..47322adb7690 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1347,6 +1347,9 @@ xfs_log_sb(
 	 * feature was introduced.  This counter can go negative due to the way
 	 * we handle nearly-lockless reservations, so we must use the _positive
 	 * variant here to avoid writing out nonsense frextents.
+	 *
+	 * RT groups are only supported on v5 file systems, which always
+	 * have lazy SB counters.
 	 */
 	if (xfs_has_rtgroups(mp) && !xfs_has_zoned(mp)) {
 		mp->m_sb.sb_frextents =
-- 
2.43.5

