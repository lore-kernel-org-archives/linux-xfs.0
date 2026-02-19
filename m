Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4329C248F47
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 14:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771512486; cv=none; b=NApeHsPcOlJTHa8uG4mIL/B4eunOfVbjqrmEVHOgFj2H9mFN5YZw7kjyWmDQqCOABK2Kptbgv0lB8FK7cXE0gir7AzDtpewEqL/UEVw07vtX4v0gIH78QjXqvzLcBA7GZOTXhvhJypqjC8oJiB1yBStij6LZRkU/+tLydIO2Tcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771512486; c=relaxed/simple;
	bh=2JGinfGoFrkNWZCdbkoicKCoKLYeIZaZqAwTkQYHdOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFMFhi/nq1WVtSmRzwORnSQftizyqkALWzvRvfa91h3AFnNUkqZPHiXk/V8fVRlyTWuIoJfUS2KxRa+tQ/cquX6KbJLvMONn9Wv4YC2162wGVLAzImeYRfLlzRQlui6aN2TYv929OsXK0wQOIzevZbEjFI5zreXT9/47k+/zMMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RjDr7lvE; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RjDr7lvE"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61J99sDc1260044;
	Thu, 19 Feb 2026 14:47:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=pTXWyGOy8cH9Hf4F1
	sfmkwHao1hqvLop4Dn4H2p6GjI=; b=RjDr7lvE2Vt4FYu6Rx6O7NAr2dVAXXzzH
	oSsgoFahplibnwfe6NxAX4TPpapW5P5dp6ZRxIKwclXwBpIoZmKi9nnZHarLpkyR
	7iJTK9VCUT9OkyS6vjj2Y+knznU6u9mq1YEBsUhW/TNgo7KRsm93onK6P+Gr8Isn
	6E6vb5l7FRFKD8pPVfa2I4E2GoJ5ty8wYtx7diMuciAVje6PTOmXEKgSsDnrzX5Q
	R4WPwcERI/EmJN+wsEpYiC5xQPNbKSHgI7AAqLpdfrZ1Qwv/g3WLdEyW5SKq7NZI
	t9hvqfCA7rniL/DcUJEymTgQ5k3NKKg9CWrfVBbyqWEgoxP3yDg8g==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj6s6hga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 14:47:59 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61JDp0dg023972;
	Thu, 19 Feb 2026 14:47:58 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ccb45cjpq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 14:47:58 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61JElvWs22020674
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 14:47:57 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70AC858055;
	Thu, 19 Feb 2026 14:47:57 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0524F58043;
	Thu, 19 Feb 2026 14:47:55 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.21.217])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 14:47:54 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, nirjhar@linux.ibm.com
Subject: [PATCH v3 4/4] xfs: Add comments for usages of some macros.
Date: Thu, 19 Feb 2026 20:16:50 +0530
Message-ID: <ed78cfaa48058b00bc93cff93994cfbe0d4ef503.1771512159.git.nirjhar.roy.lists@gmail.com>
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
X-Authority-Analysis: v=2.4 cv=dvvWylg4 c=1 sm=1 tr=0 ts=6997229f cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=GYC6hG8fiMhmU3THKwoA:9
X-Proofpoint-GUID: ijnFd-9w_zTYy9uAYUb-MtDvZcomF7hu
X-Proofpoint-ORIG-GUID: 0BAi3LN9gn2aRQOsKWFVjWxNGaolxHoo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDEzNCBTYWx0ZWRfX6MH98GaeQv2U
 jW74wUCB4o6andKQL7o7hi3MvWVH5woV7W30ivETSDORDQAbxlSy0WiN1mf6DchanZuOaVtejSM
 HZ2yjX/3aQful+OoA9D4upESuf8uAuaY5czmKbeiu0nUXU1OBNZkP4NNGfIjyo+OH0qzwrGAtDo
 bgmboIpEDHFQ6wHPbLmg5+eNsFJbd/iMUOumREszxd6K8V4qFGotPf2N6PKbY4C3H+UaCvu+87a
 VllIyYaKKIY+YKA/Lr8YL88IjQSn2gUx2USCIFM/2QzzPZYzJ2ZDZMToleMkkcNofgq4+F3asjs
 SiqaKAtCM6GKgeBMUgUXyqjvDhWButwNcyI8irBapkToXSta2i65Ph7C0FsKVVUK5YNeEoeH+Yp
 qjb9omY8qUlxCk5GU0z2jt80b40oMZVF3t3pc1S/1l5FdKQn5Yrb3Of3ytkJTkRYp8vQQzMBDik
 0sszi3YgLooIHh9gWVA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_04,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602190134

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

Add comments explaining when to use XFS_IS_CORRUPT() and ASSERT()

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/xfs_platform.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_platform.h b/fs/xfs/xfs_platform.h
index 1e59bf94d1f2..c9ce0450cf7a 100644
--- a/fs/xfs/xfs_platform.h
+++ b/fs/xfs/xfs_platform.h
@@ -235,6 +235,7 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 
 #ifdef XFS_WARN
 
+/* Please note that this ASSERT doesn't kill the kernel */
 #define ASSERT(expr)	\
 	(likely(expr) ? (void)0 : asswarn(NULL, #expr, __FILE__, __LINE__))
 
@@ -245,6 +246,11 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
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

