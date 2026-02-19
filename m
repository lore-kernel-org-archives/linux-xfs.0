Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67059279355
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 07:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771486863; cv=none; b=ptEIE+IGKW78MT15fduQkbblsh0Lbgon5UV9pR5I1IE3uKmGAVx2mN//oRsDTVMIPHHKEasEoY1UR9Au71lx/KnziFawMFiwHr1PTsXzMWOXgMgotOdgFu5L08fj81r/++idmQTuAeHIi1hyZuoed3VEgUwylF0m/CiapwOCcmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771486863; c=relaxed/simple;
	bh=4W34A+3c3hSZ57xtOO//eRAaxIGZ1lmvL+4oAPSifQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOOVtJv3wyU1SDDCl5jTYB9YoqIwAIG5u3zeCy1NydcdkJRXtfRndDetXl3Fr1EXKFT5Utfmkcr9Hs/M1uY7Z8faSIOIGaCmMEsJCeby7gAtHo2zGfUJn8MGP+2cBT9YnNyh3g5qprmbO5v2Msgp1VYeJBx7p9fsu/P+1NYeCQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=C8c8KuDi; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="C8c8KuDi"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61INmrhv3393511;
	Thu, 19 Feb 2026 07:40:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=zfi6x+A7hz8QcOcR2
	YNoBFRqrdhO1SOYe0jEA8Y5uz8=; b=C8c8KuDicGssGGdx5hIf+yza3ABXkkJ7Q
	eC6e0MzwehuRSUAWaFFZj6AswwMhBVnt5xRv+2l87PpcKhMJJ6FpcEAzfTxK52hv
	Ogtpre19CDURk4HjHSZaDVMAVYnHq9VGuzRmPzeE+FSbD4z0/HUKGARiA8svFT62
	dFKCl8zCqDPvY0b3+QA8/NEUWfN+q2US81rKDExNgG9hjLh9E0QVRvFTYPLnbiva
	bDEFlJZlBNARtF9q6N33DOjOzJI2XaxwRwmsquLpyQ8rGBdQ+medHHg05NsHshua
	TdQoyzJn1lxrpeOoBpDD+EywPryqW5VQncH5mP71xCsAtwiGVVs/A==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj6s4yew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 07:40:55 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J35VGt011912;
	Thu, 19 Feb 2026 07:40:54 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb273av1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 07:40:54 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J7eqD331523328
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 07:40:52 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8597558056;
	Thu, 19 Feb 2026 07:40:52 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0AC45803F;
	Thu, 19 Feb 2026 07:40:49 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.28.60])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 07:40:49 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, nirjhar@linux.ibm.com
Subject: [PATCH v2 3/4] xfs: Update lazy counters in xfs_growfs_rt_bmblock()
Date: Thu, 19 Feb 2026 13:08:51 +0530
Message-ID: <9533af5443570edfd63d876baa5d84b7aaad4dc1.1771486609.git.nirjhar.roy.lists@gmail.com>
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
X-Authority-Analysis: v=2.4 cv=dvvWylg4 c=1 sm=1 tr=0 ts=6996be88 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=HqRPCohBQm_1MbEnWikA:9
X-Proofpoint-GUID: oQMus4ULE4gJFp6pt1LNm4FQ49ocz2mC
X-Proofpoint-ORIG-GUID: 5exbAlZPtQ3q0r51LbWmRvNRN8e7dKXy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA2OSBTYWx0ZWRfX0VXy6yx3T0tf
 vvbCjn7+FJ16g9AQOL1fgtEUB6ZeUVdW7IhJ8/I/+n1D2zSEnifoZp+oahrpRetYf50F/HHR4mr
 Xp9ykTKuyIrAvcl5h6P3F2ctVl3mJh1IS9bNFtM84P8Y7m0sr/rOoswKweh/jdsURTlk7IZ0yjN
 29rjB38ucvm8nqBZqVnTf7cFAHswthGOpW8Aqufm5QQbhb1ZJZB+vN/gpS1TAbnMYnvTN8fKv0j
 e1YKebxuKGBbV8iARr3eMsmczgug3+zxXQibFkLzkpGdh4Rd5tgUw96BqGc2CKuufxxVPftzlEr
 RspDe4ZtjQHca2wVZhmLlMlsB1aydOhRnPlApFrOwILWCdwcXykE0UvQ/18Vd00OiGDsjYD3HQ4
 uczhxE5NDfE2tfqEiNJxTc0LwWRpCor1z5AKAx/p30kJ7MpONVp7n5rZmVdO5RdNjbVHcgSgFnj
 Y77xU/QHUQlyi/dMfhA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_02,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602190069

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

Update lazy counters in xfs_growfs_rt_bmblock() similar to the way it
is done xfs_growfs_data_private(). This is because the lazy counters are
not always updated and synching the counters will avoid inconsistencies
between frexents and rtextents(total realtime extent count). This will
be more useful once realtime shrink is implemented as this will prevent
some transient state to occur where frexents might be greater than
total rtextents.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/xfs_rtalloc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index a7a0859ed47f..caf638b35603 100644
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

