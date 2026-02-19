Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93AE279355
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 07:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771486838; cv=none; b=KOborFKbO9JTy5MJCmmKm1TPTRU/NVHUSTIUfOVzR0zHZyxel2t3w7Tht/T+D0UxzT7DGUphvQTvxnyLq6DvdtMo4SkwV6pAoLoQKy7DM3lOhjEHHX9OJ2q94/gORNt2mWIHFMTF+QoHot+8yWp/0JYjSiAeZ6q7kAADZBiK23s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771486838; c=relaxed/simple;
	bh=xDZ1t0GAFEmyNFHClLCNC0uXJ0RRM8kbgnXvJOZN/Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqlvdL9fSVeMrkozeJBp21qT0sk6c4ESYSH2RDRjOyyigfPkrv1JfEdkrc3SmHKql3/NYJap02tihhqs07y+hcWFtEXc1OG32T+wACbbOfMxxkJo6iQoauhXpRLoqCwIzo++oKldKOIBOXtlCRgzDupdlPFeKrCjit7e2c9WuSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=c2ra/2fw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="c2ra/2fw"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61J0oq1q633088;
	Thu, 19 Feb 2026 07:40:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=AJ0u0AK8UELqL0741
	5FpR8KaP5Y/SUvMLSYP0P8A6Ts=; b=c2ra/2fw3dDAYW4V4d4Sth05idqLQYf6b
	x1Xd1OMP5AyzDd3oYnnXJ0jSvwsQ7/xwnAYmBxmDpEyVmT9buje8YDPYnWDyhVDT
	oYWvSt7YNtrF8x4MykcOKgyxs9QksJuW+/uQCjqjWALgk8zyj9xVhQR34nYXDXeg
	mmVnKz0feEQlWo24P5TLUAu7beQQAekxvlxyYbwVTX41AWAENXA3yxQPQT7NlpwR
	ORWcE69CGuu6l3o6o1a4TRi/55Xk3D2mWG/anX7dKmbx9/4SPJCxoqESHDiGf6Ma
	LD0bhTtfL/qOLyAWWpIomlGoOCGbxrZslb67WPxBeNJ8KG4BYh47w==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cajcr50gv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 07:40:31 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J3ZMP9024344;
	Thu, 19 Feb 2026 07:40:30 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ccb45b918-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 07:40:30 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J7eSmx20382252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 07:40:28 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E0F6058064;
	Thu, 19 Feb 2026 07:40:27 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 658BC5803F;
	Thu, 19 Feb 2026 07:40:25 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.28.60])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 07:40:25 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, nirjhar@linux.ibm.com
Subject: [PATCH v2 2/4] xfs: Add a comment in xfs_log_sb()
Date: Thu, 19 Feb 2026 13:08:50 +0530
Message-ID: <c01b69dba660fb31a3cd1bceeb534bc0e3d813e1.1771486609.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1771486609.git.nirjhar.roy.lists@gmail.com>
References: <cover.1771486609.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: z7gV4JzwUXCwm7AFBHGth3Ud817nGS3k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA2OSBTYWx0ZWRfX2jxXTPKRt/W+
 E6NnvbHIb8gonjon66JFYCgJH8TsHB5jhIkV0kgKk+CUlmP7uid/E1fN1HnQyAvPRb9RknNO82+
 fjnMOVDyIoQ+2HGa3ybW7H1fZwn08QP7+Kgl6ezzph+ASPbD3AZcZL8EE+SZoKJ2GrM4qmq1Yag
 rKGrkVkMb89u2Pymk8SJvw9jO5qW1z8f5Or9ivC9nL+cnZzcZ6fNHfWbRctf4sjWs0t7PFp2g/o
 Sm+TLMpLg+QTN0b6u94RXQ4xfhTsTJeK2rwKUgC2A1GW6lvvA7ZG6PFgJQd30tnlblwuUFcr4rE
 Ei/8WZsVvcrNpNGpsmZL4MnkMDsX31IE84W4M71OHxQKzVyYqIGh8gOrA5aY3pCBkyraldoY/mD
 Lnv/Yxw5jHrSWwBFKjaW+bDYq/Lgd6D0BPnL6HC2Jwe1adBJ2dcdMoG1EwwYLH+a5OXLFISD6XV
 2d3VtXr02IXx68pTkKQ==
X-Authority-Analysis: v=2.4 cv=UPXQ3Sfy c=1 sm=1 tr=0 ts=6996be6f cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=McGMf-V2i_Dg8NkQ6AYA:9
X-Proofpoint-ORIG-GUID: 1S2WL4vJO2WlbL1wOL0lCZ2GNg4WlBiL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_02,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=0 adultscore=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190069

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

Add a comment explaining why the sb_frextents are updated outside the
if (xfs_has_lazycount(mp) check even though it is a lazycounter.
RT groups are supported only in v5 filesystems which always have
lazycounter enabled - so putting it inside the if(xfs_has_lazycount(mp)
check is redundant.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/libxfs/xfs_sb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 94c272a2ae26..7708984d3752 100644
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

