Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EF831984E
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 12:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770726432; cv=none; b=KvFSpkYLu6wd6rrI4iOaw010+8U3bNcmG4G8tzj/qNIS3sPdbSFfh/Fj+RM/eEDf40BZcKGq1xaVcB5McqC8mTu139lXx8FzOgqH30z5uOGxw99dQRTvsX3pxB0yNtyUyBiZrwGmzytOzHXk2noQpETtNjzxpuHl3gOVLFNEWLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770726432; c=relaxed/simple;
	bh=2Wr9UcCUJIx3jLyUBhd9BwK3Vwa8BqRHAX8fLsXFBlA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kqQqNe3CX5fvyYq6/RX4NDIVsu16G2xZH81LHHlrARRgHiLCi04GhqTwWpyFbc+ER25lpexu7lTUtOOn9Ax59ZfLgGk7XxQB1HZFUIrw0SVJpq/c1jxVa4dxIToi+BpQWk/8aulJxb8HAIDtiOdmiiW94Wez3ymBBN7fi6xDpZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gjCKt2NQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gjCKt2NQ"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A3aBlF3408670;
	Tue, 10 Feb 2026 12:26:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=L1X1+4TbodTGaQpBSw6yXycUtOvJ7VeFyGFHnaurM
	TU=; b=gjCKt2NQJ5vvNACidayDv1RUks6rabpLYjZCFvUNNwQjRSr/xqRq2RmMV
	x9HH2u/9D/kIlX8DvQ4jcytv3hEsEU+Yfxc9cFbwNME2R2S8b2lapgZYGS8mBCBx
	Tc2pZwTEk6wivnDS9Oy8R1Z/Y/qbJlxzg5SpEIISdqstD8FpEVcMq3pwFsqE2XIw
	Mt9iUUATgC2IDC0rdFswJA3X8B13M51i+PKV7LAtDPxSiOLmvkX0EpTmDDjonO2p
	cNVdstdeloen+6CG33xKlCNPOgiQwET7k7fXJDcpxi+J0nPw52qchZAo3QL5CEPo
	5Zbc1eTFanpaG7QlnB+3bJ/RlzgIw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696ut19c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 12:26:54 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61ABGQHR019251;
	Tue, 10 Feb 2026 12:26:53 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6hxk1191-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 12:26:53 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61ACQq3r29360654
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 12:26:52 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 841875805D;
	Tue, 10 Feb 2026 12:26:52 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 09F585805A;
	Tue, 10 Feb 2026 12:26:50 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.28.3])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 12:26:49 +0000 (GMT)
From: nirjhar@linux.ibm.com
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com, ojaswin@linux.ibm.com, djwong@kernel.org,
        hch@infradead.org, cem@kernel.org, nirjhar.roy.lists@gmail.com
Subject: [patch v1 0/2] Misc refactorings in XFS
Date: Tue, 10 Feb 2026 17:56:33 +0530
Message-ID: <cover.1770725429.git.nirjhar.roy.lists@gmail.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEwMyBTYWx0ZWRfX/D4K8cJfB1hW
 rkHAcuAMfbRMyUDAyyDsUcEw4HKi2eWFR7A6jX7Sq+DqyvJscNKzuzfrB7FN2HBDnuH2TuwW05d
 9TDX2qc1v7xwTRHyarQ2LbQsMszPPwsM3M1DJCnz0KnvnxVa7VCCz4XB8feViiuSyIZ5VxJTR+V
 FDlTZWzuZ9ADOlfbeBWSmV/Yto7F5cM6eS+6CwNj7gGwk2A5OTmZ7ba6hx29h4EQH+8+5chpbes
 7q7cnQnoTAOitsRSE44hw/MO6JptHtO/ADoVyBcPytqdkZi4uHJqPaLnCohHeKALm/GOIHkO3jM
 bZ5ES94+m4nquhpOGEo2Orjjc/VQrh7MkjDyWMrXnIcTTmOEU9AdWL1N/VmIB/al0kglorfpUFC
 X8E0TJMOhq8RE5/jPp5l12HI0I9bSugC9LyJe5q5pF38smemixVcEi2vAdyVpUnjzLmmIaogBuh
 HxswtwD97GPXxaXQ1kg==
X-Proofpoint-ORIG-GUID: m90KfGyeZewZd_9IYdRRoFgIaR1Yg3Ja
X-Proofpoint-GUID: ftLqIA1IBuJ9G3Z6ASluEYfzjVL4RiMN
X-Authority-Analysis: v=2.4 cv=O+Y0fR9W c=1 sm=1 tr=0 ts=698b240e cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=UuhvDR6adZwKmHWAkR0A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 adultscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 clxscore=1011 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602100103

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

This patchset contains 2 refactorings. Details are in the patches.
Please note that the RB for patch 1 was given in [1]. There is a
thread in lore where this series was partially sent[2] - please ignore
that.

[1] https://lore.kernel.org/all/20250729202428.GE2672049@frogsfrogsfrogs/
[2] https://lore.kernel.org/all/cover.1770128479.git.nirjhar.roy.lists@gmail.com/

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

