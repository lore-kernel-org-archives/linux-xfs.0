Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8AD2BDC16
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 07:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771486873; cv=none; b=bMT1Fl2sqD1Fqn5pGjkurVtw+aL1OKnTBl71Pb+IX55iW5SoznXnDIWRR3ZXFGua3Fc/39M/nIAacPPklStVXkmkpIH568mRqw78B7l1VWQKjFHGM8Kc1fOXjLW2HlkTRX2TRInTQ16zmvltpS+3okskw6Ln+Yq778QgFoiZ/eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771486873; c=relaxed/simple;
	bh=2Lj/9cZMPSRdyvXQ5aEt4ShnH1Bb78M/DHyJ+3hkv2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMAm8pVl9PlxvmomRadxqdhfu5O4YPK5KeDXoZIUozMyFRrBjOBIzi2lEs3RW3wfTZKh68YeSwOsTy+aXougWUwgTqaqExF6WL5YG2ZrIFjTL5ctkneqh9u+vNcPjyIL2ky+weSZrX848qc3dLQkwbI/jSRWtsjIcqOlY3JYgP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GrmqGRQb; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GrmqGRQb"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61ILB0Kw3696665;
	Thu, 19 Feb 2026 07:41:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=iKjcw+gPrumuiXdCY
	gphvISNotVDgtbXxtn9dpSAPY4=; b=GrmqGRQbD70UJdO4gMPpAi6RYNVXQVT4G
	6/E6uCFFom7keK7Ebg7CbcIGFGnCpduB7CjU27m8aQbDiWygJOaXe13cEWkE2MsX
	rRALADIUAA0YCGUx+CE0LnyU7y9168hfE4xolJ3vNMknjPaYNy/fnq16tE7wGJdl
	JDUg+Oa88THNRhtuAQhuPgcEm8dG+e8Ii77afx4tMIRXQAVzjaklTRzyscgEgeI4
	n5LksxhULxvaG1rlyjALoHrXZ9cNO0qOxXaAba8QmbJv5p4grRIXhNCE1ArcHsst
	QU0cKyRObsHBbn5YgPEUpmMOludQNE+dFyZN0et1Wmp4mlc1fjsTg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj4kkqq5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 07:41:04 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J3qYIr001424;
	Thu, 19 Feb 2026 07:41:03 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ccb2bk869-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 07:41:03 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J7f1r533489566
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 07:41:01 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B52C758060;
	Thu, 19 Feb 2026 07:41:01 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3BAD95803F;
	Thu, 19 Feb 2026 07:40:59 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.28.60])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 07:40:58 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, nirjhar@linux.ibm.com
Subject: [PATCH v2 4/4] xfs: Add comments for usages of some macros.
Date: Thu, 19 Feb 2026 13:08:52 +0530
Message-ID: <79327c930f7eacfd37d1d229de8f509f0b5bae6a.1771486609.git.nirjhar.roy.lists@gmail.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA2OSBTYWx0ZWRfX6sQOml1vVytR
 /eH45cw/fxA1f5x9mhOuRygO+oPYZnA/XDWhkN0D0gd8dzWzz5n/2DSn9bc2ri0LItCDP8Mcs7w
 Qm2jPYKBhqHaLsXd06OawQLH5bkVGo5tjhZOlIhyKe74SsCAy4loxaVdaND2bezsTtxQVgHtlsx
 ohDL5jbTUIkBxcslQGJsbzYwjFKx//eL5Lgg2Ool6u9jH1HoEZKoLxz61iShDJCC1BZdhYtDoOr
 jRS5E45lX+ttVXoA7FC9fb9hpN3B0iVZVVp7Q7LGNJ3e8KBXZWhg//7VQLX+JkIdVHA1a/meaxr
 UIzcF2/sAc940gWwQchPCI1aSIBQ+QGwX5Ms6cgSSaTel8qPdONJgaJCfHvZO99x2n3E4JljTzW
 6qKX0tjkKYynvEGSBIQ96gwmaHr7ZD8LdChBS7ECwn6pNYGbKym9DbXmfY/ePTxmQOimkrOfCD+
 XI2gXWt/AqaPnZS/4Cg==
X-Proofpoint-ORIG-GUID: rTppkf4KBbIcZ12_2I1EpORSQM713WMV
X-Proofpoint-GUID: zV27NF-wz1AMilKlzUVFS1eH9boA0hts
X-Authority-Analysis: v=2.4 cv=M7hA6iws c=1 sm=1 tr=0 ts=6996be90 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=GYC6hG8fiMhmU3THKwoA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_02,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190069

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

Add comments explaining when to use XFS_IS_CORRUPT() and ASSERT()

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/xfs_linux.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 4dd747bdbcca..3a69dff50bfd 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -225,6 +225,7 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 
 #ifdef XFS_WARN
 
+/* Please note that this ASSERT doesn't kill the kernel */
 #define ASSERT(expr)	\
 	(likely(expr) ? (void)0 : asswarn(NULL, #expr, __FILE__, __LINE__))
 
@@ -235,6 +236,11 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 #endif /* XFS_WARN */
 #endif /* DEBUG */
 
+/*
+ * Use this to catch metadata corruptions that are not caught by the regular
+ * verifiers. The reason is that the verifiers check corruptions only within
+ * the block.
+ */
 #define XFS_IS_CORRUPT(mp, expr)	\
 	(unlikely(expr) ? xfs_corruption_error(#expr, XFS_ERRLEVEL_LOW, (mp), \
 					       NULL, 0, __FILE__, __LINE__, \
-- 
2.43.5

