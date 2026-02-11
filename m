Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D043254AC
	for <linux-xfs@vger.kernel.org>; Wed, 11 Feb 2026 13:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770818148; cv=none; b=Ut9V09xQKZphbqPGS9fRinbPKjYUAEmGHjoz6RkvQJcoDMFys2qqrpF7fbY338nlGPX3yUz24qI3nAmHIlT+osBnd3+21SiJC4wsAwrmfwTwpiDtkYHhPDJe5TCxqIZorqyeEA4Uo0nvATdf7bfIk7NgG4ca4E/CT3BszBmsNmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770818148; c=relaxed/simple;
	bh=jb5qSVwk36D6cYhgm0Kn4Zbk/9jAckkT4xDN7D2ULBg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sQwul70JyERVyqv0vyhf8e8mxeRYw+4h5ZTY2YWbdXO2vbIkS+4ls6C9DujSN9jYe1YLSESXGjm3gOAHjkcV3OgRk3/7z3KHWEwNKBA8ek/zo+Xt+Ho9wE/4SQvjPIKltDOxZvAOQIV5VVToU1h4wwDcqo8UPn/PG5TPD3YuRvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BYz7p0IV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BYz7p0IV"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61B0OVYb237435;
	Wed, 11 Feb 2026 13:55:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=KxRAUZ4qn5RJjF4UNMJA/9lw2JlMcO8Z3qK5X1W8e
	0g=; b=BYz7p0IVFT7XGTGlhRWUiwk8Uuc/krDEV2lj8JZ3WeXVoLE012XHomaeY
	WQJrcV2R+pos7bMZl0KomeSirpWiIQO14SW8291QU0SQ+K1YA2AVWeFfe46htQCm
	H5mQ6CR0bRc1dsAbf9g/mnvvVIQX0Nd2GLJlKkXeavFvXfdmi8vhyRZBlyZOHxlh
	6NO5J741ZOWtD2J8wdJRxNQLizZYTJnuWWL9JdkazRhRU9f6fo7uDmmqUM2PFIpo
	xDwt1fgOLQwqAMVSwVcNemEnPcg6EEsck6kyxctVHAotUG9y7yMboftLkYqR2Qld
	U5UOsgQYf0jB/nENqgxDprsibBAXA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696uxx04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 13:55:34 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61BA5km2019251;
	Wed, 11 Feb 2026 13:55:33 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6hxk5tx5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 13:55:33 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61BDtWeT29229792
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 13:55:33 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C71B258054;
	Wed, 11 Feb 2026 13:55:32 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C3A35803F;
	Wed, 11 Feb 2026 13:55:30 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.20.201])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Feb 2026 13:55:30 +0000 (GMT)
From: nirjhar@linux.ibm.com
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        nirjhar.roy.lists@gmail.com
Subject: [PATCH v2 0/2] Misc refactorings in XFS
Date: Wed, 11 Feb 2026 19:25:12 +0530
Message-ID: <cover.1770817711.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDEwNyBTYWx0ZWRfXyW1WHvdAEFqo
 C66s+1MAQ8iU56Uqn4hTAZS2SryqGuhacuZXVOTON+kNjWLS7v26Qy2nzGFiKzyuwJPXbplrmmK
 zdQIqKZFkYDaUiQ1xBA8qIJmJEUHQ0qgY5dKThOLi7epK6wyd8kwtNbD7XIdgRoLQVvPfNRgxD1
 PpnBnTHkZ8ezt2j+QSN2RwziCLqqr6LsPciTugjv2fSYdhY3jPfGIKPu8yWVH7J1octNZqT1VBZ
 10Oh8k+BUuzIDs/HKtAd97CZQ5I7F51QCZH5aBfJg+n8eSCeGpCcFOeNdt4p3emZiTG7HdV0ypj
 4WhqfXgDFxODtHehjwIFkUF6rF9G6cGAnO1Qpm6sgz+cYYZnj6cOP7ElNO0TOntLdNOzx2n5rxJ
 SlBNO/J7Kx0PczvYZTnU73IdUkBlQ3MmUIDshyw/3mtWGz/uv2m0fmsHVfZV6EDmBaie/yzDGlG
 YRGHFDthzeztWQn2SAg==
X-Proofpoint-ORIG-GUID: stA_w-3ey-rAxOucd3VCBNuRTgnZ0Byz
X-Proofpoint-GUID: MJlAo6HPbUPEOZlG0a3DEYzkVplVWnXI
X-Authority-Analysis: v=2.4 cv=O+Y0fR9W c=1 sm=1 tr=0 ts=698c8a56 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=FJDXxtYTpYROnDOXG1EA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 adultscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602110107

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

This patchset contains 2 refactorings. Details are in the patches.
Please note that Darrick's RB in patch 1 was given in [1]. There is a
thread in lore where this series was partially sent[2] - please ignore
that.

[v1] -> v2
1. Added RB from Christoph.
2. Fixed some styling/formatting issues in patch 1 and commit message of
   patch 2.

[1] https://lore.kernel.org/all/20250729202428.GE2672049@frogsfrogsfrogs/
[2] https://lore.kernel.org/all/cover.1770128479.git.nirjhar.roy.lists@gmail.com/
[v1] https://lore.kernel.org/all/cover.1770725429.git.nirjhar.roy.lists@gmail.com/

Nirjhar Roy (IBM) (2):
  xfs: Refactoring the nagcount and delta calculation
  xfs: Replace &rtg->rtg_group with rtg_group()

 fs/xfs/libxfs/xfs_ag.c  | 28 ++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h  |  3 +++
 fs/xfs/xfs_fsops.c      | 17 ++---------------
 fs/xfs/xfs_zone_alloc.c |  6 +++---
 fs/xfs/xfs_zone_gc.c    | 10 +++++-----
 5 files changed, 41 insertions(+), 23 deletions(-)

-- 
2.43.5

