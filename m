Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3CC238C16;
	Thu, 19 Feb 2026 06:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481159; cv=none; b=iVWjkGepcJBRIhHjKDAwtFN3NkcmOxZ+Wu5sJmSggfr2f0dBzPpfmqhWTKVJjb5OMUE5RfPEKVvshteyN/dVogEyYGmFbacu7mgha2k07/SX29CzbiQjWbUNVQpSpwgcRekA3urtgingSPfzOXBn0JZnHG+bTkcAqHKpnPFMs2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481159; c=relaxed/simple;
	bh=TFJPL0ftYyw3/ki6Yk2Y8Q1pUKm/mzjb1ciDTbQCaDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erspfFSoADh8iQz3+BxkP8XUU3+i6UWwVYOKRiv9Egi+zjuqVsffH27a5IW085X7mWQ4Gt2w3DEMcbeNYHmrmQQAvTZAGGcJAkQb/yBZWXtePWZ7sDfjhKJ9Alz7p/fbaT3bgxj9rzuhzW5SOM3qMSSF7cEkbk6y3MzioRdGESQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rIrNQDjw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rIrNQDjw"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61J4fk012330173;
	Thu, 19 Feb 2026 06:05:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=vvhoLrcWJONT0hJcB
	2mQfMZ/THqHXGcH0Pi7yuDDiRw=; b=rIrNQDjw5gKQRAptVWR3n1Z4kMv/gQmGc
	ag7fyqgzCHzI07pPBoMYQxeRZrdMfFg8BrHzDuISsxmMmeU4k2+hyUQnV4F6QT3T
	LNhaqQd/W6XIXYfwz2Pe+kF9OKVBYwy0SHxGV+9aitBxJtgKgKjtsIFkeXG9d3zP
	2k80XS8jArmXn47a2DvFv1p5+gVtwBrwaMTMF3Qu/bG2l/AIJV8j54qVbDcXPcfs
	13GVFChmrGu+9g4njr1NHLw3zAwIAVSXtCVyGszrh8U3o8q+eIzn2BAWp/4cSALN
	MFpjOLnbGoiGa5Bvyxnm6W68IdNR1WdP6RxXFBMeIXRfeM8sjJfqw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj64bgbp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:05:45 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J2FeoI011906;
	Thu, 19 Feb 2026 06:05:44 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb27326n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:05:44 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J65huL65339836
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 06:05:43 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1AD5358065;
	Thu, 19 Feb 2026 06:05:43 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 017385805D;
	Thu, 19 Feb 2026 06:05:40 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.124.222.193])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 06:05:39 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org, david@fromorbit.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, nirjhar@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, hsiangkao@linux.alibaba.com
Subject: [RFC v1 3/4] xfs: Add a new state for shrinking
Date: Thu, 19 Feb 2026 11:33:53 +0530
Message-ID: <376b2b28346bd90bd411396aac6246eac54b6562.1771418537.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1771418537.git.nirjhar.roy.lists@gmail.com>
References: <cover.1771418537.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: h66a0s6plc2KCh11ltzFmRCXa7f7fTgb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA0OSBTYWx0ZWRfX4nyY7DxbpLk0
 H4XhLhkXpBVk6+PU8oDREej8pvT5oUl0Nl5XxfA9R/HiOKwuaaIMi3aDZoMgVWjf4yg6kaZSspN
 ZzgNHwOC1E75iGtKgtsfT23oPm3pfDRBOxBEiOZFGq8GVeTI3jnbVXlKTU2c4+WmLOoJDbooOSI
 dBqQ7ctAwEoG6FoN31w+D5QauO97mBWXApurWWXahFgcH0zwMJTvqXdLMIZ4eTfufdKlJv64m5s
 23wUVXmQ6IsK7oyHJ6iGygha7clLoEfa/w/Icf6VE9dRfrgR43l1rsqv6pMK8wbSSG2glyQhdoz
 cREYMW/FE3Ea4Ww5+5q7cRVrDVkcojaQb2YaqwdWy1n4HxbQQToDTdVANgsPxPZtok0bozuDcd2
 LA7W0bDZ0uEr9FwKZYJMDLROK3OegJ8kYp8+oSqDQCzps2apcjaJX4I3/sldrzpfVh4rCMTuqtC
 BScb++4ek2i6bL3G/Hg==
X-Proofpoint-GUID: _ILwXoEr1_iTZvakBAMjLmiQGFwpAQc5
X-Authority-Analysis: v=2.4 cv=U+mfzOru c=1 sm=1 tr=0 ts=6996a839 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=fIxVGnL98txb16WsJwkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_01,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602190049

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

Introduce a new state for shrinking. This will be used in the upcoming
patch that implements online shrinking of realtime XFS.

Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/xfs_mount.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b871dfde372b..206a4738eab3 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -577,6 +577,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_WARNED_ZONED	19
 /* (Zoned) GC is in progress */
 #define XFS_OPSTATE_ZONEGC_RUNNING	20
+/* filesystem is shrinking */
+#define XFS_OPSTATE_SHRINKING		21
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -599,6 +601,7 @@ __XFS_IS_OPSTATE(inode32, INODE32)
 __XFS_IS_OPSTATE(readonly, READONLY)
 __XFS_IS_OPSTATE(inodegc_enabled, INODEGC_ENABLED)
 __XFS_IS_OPSTATE(blockgc_enabled, BLOCKGC_ENABLED)
+__XFS_IS_OPSTATE(shrinking, SHRINKING)
 #ifdef CONFIG_XFS_QUOTA
 __XFS_IS_OPSTATE(quotacheck_running, QUOTACHECK_RUNNING)
 __XFS_IS_OPSTATE(resuming_quotaon, RESUMING_QUOTAON)
-- 
2.43.5

