Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB562AD3D
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 06:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771570547; cv=none; b=rGYuq4lDPuvAFifTFMh/fYiazk9OBII/W+hhnAQzf/fcd3tdXSHZ3JzWXfn/qsllppAfqcugPSB+KX7c6jxy07t4zVa7jWStUnng8O2QTfLkJovmHqj80Hrx8sv+JDRyAMwit52lXRp8z5NWLNn95sfeqrC7gaDFssDvWG3scHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771570547; c=relaxed/simple;
	bh=avDlI0jy6tr7QmblUYV1t5IjIROlZdArxHuQ6ZOkGvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiE2oN/3+vXcko1rUJWgFFE116OEtPEZuI3HDXPDKTPmISh0RUDP8liCbit6ZaxLZAvx0DUQLtzGY/Rzmkoq0UuNWq/OkCzG2j2K1WCQRzZUbsm+V2LiS+sO9gjt4Gw7H5ORbZoSjIlsnCe9bDEjN4QNILAugY0JyxitmhpQVgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lJQgeSkK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lJQgeSkK"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61JLEfSX1272615;
	Fri, 20 Feb 2026 06:55:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=jkSx58Gz8zy2j17tn
	STWy0EI0FhaIC6dhjoOG+DBtNo=; b=lJQgeSkKa5MKuj3CR169MtkMMDSxTol3G
	d3wmgafgh9Au4fPpKYPHQtgMwMPx1Q6+/26k0ENYYQHix7rje8nJpeerjArbXA68
	0OqURf47COZ98KoeTyErfx/YUopg4Pdw3+ly3VS3ih3g/kOUzOqLRC5oDJKAnV6B
	49poKbhes9a2ZygSFqbOxZ1q5YmcCfL5Uj1TePGcVtuwSFZmRhkv9T4t5K1P39b0
	jWf0ya1qd7c8HcOFEMQRWduw/5x9544lN48GACAOQSMtRXwq+x2jyF0s4dqszd7z
	iW4K/E5mul6MzzkxF9cNJaUkL0TfcpadO8DqN65nCjkv8wWRnVD0w==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj6v1ssh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Feb 2026 06:55:33 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61K3xCrj030184;
	Fri, 20 Feb 2026 06:55:33 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ccb45fdaj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Feb 2026 06:55:33 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61K6tVw932309820
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 06:55:31 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 57506580D0;
	Fri, 20 Feb 2026 06:55:31 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ABFA4580CA;
	Fri, 20 Feb 2026 06:55:28 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.30.51])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Feb 2026 06:55:28 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, nirjhar@linux.ibm.com
Subject: [PATCH v4 4/4] xfs: Add comments for usages of some macros.
Date: Fri, 20 Feb 2026 12:24:01 +0530
Message-ID: <e343687a35ca15dbbc378b32ef89de58c74f0615.1771570164.git.nirjhar.roy.lists@gmail.com>
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
X-Authority-Analysis: v=2.4 cv=E+/AZKdl c=1 sm=1 tr=0 ts=69980566 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=GYC6hG8fiMhmU3THKwoA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDA1NyBTYWx0ZWRfX/naLVcFmpTRH
 6c1nM1OqKiL1oqBLhTda+IDF1pjDk3Ap1KTBBLfVJGSH634b6yYRN8t/L3PsSomUDzUcjIfa58V
 vJiKimNNcPXmLyyQz3YjStext5TEBhwS+bDNGyPwZWqIcX0TP0kjEM68UzQzbRDmaBNuytdFIdi
 eMXG7MQ9bdApeolqoWpPI1AR3cnTiIuJhoINvDqDZFxe0qiH/p29LytVFrNfL4Yklrf11OCILIW
 JQHzG03bCILdA83Bsd5bwaODLyyDU5cSro87VUqD8yg/YDJKJUMTIyY4pkMCs78y1Kw/BTfTvPe
 aV+hM34t0JXPYcWg1bb9zA9jtOFJ7IF4M/jtkRApE4YUsfB6a4tkoIuLJJ9JpK+96PHMtnZgOeO
 JIL/fmwAJh/Fs0HM5Hg1jO/0rBE0TIEI+osnDrP2oxuuKjLZXto/ST4L+nnBzPgYcj//44ntnFd
 E5YUEF3sFsgt5i7p7tw==
X-Proofpoint-ORIG-GUID: HaOBLFpgdN03h2vzggsoT0zcZeAWaFPe
X-Proofpoint-GUID: oprks5ucibNxqp_GHVm4UgkA9OY-0QqR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_06,2026-02-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602200057

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

Add comments explaining when to use XFS_IS_CORRUPT() and ASSERT()

Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/xfs_platform.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_platform.h b/fs/xfs/xfs_platform.h
index 1e59bf94d1f2..59a33c60e0ca 100644
--- a/fs/xfs/xfs_platform.h
+++ b/fs/xfs/xfs_platform.h
@@ -235,6 +235,10 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 
 #ifdef XFS_WARN
 
+/*
+ * Please note that this ASSERT doesn't kill the kernel. It will if the kernel
+ * has panic_on_warn set.
+ */
 #define ASSERT(expr)	\
 	(likely(expr) ? (void)0 : asswarn(NULL, #expr, __FILE__, __LINE__))
 
@@ -245,6 +249,11 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 #endif /* XFS_WARN */
 #endif /* DEBUG */
 
+/*
+ * Use this to catch metadata corruptions that are not caught by block or
+ * structure verifiers. The reason is that the verifiers check corruptions only
+ * within the scope of the object being verified.
+ */
 #define XFS_IS_CORRUPT(mp, expr)	\
 	(unlikely(expr) ? xfs_corruption_error(#expr, XFS_ERRLEVEL_LOW, (mp), \
 					       NULL, 0, __FILE__, __LINE__, \
-- 
2.43.5

