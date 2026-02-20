Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795A02D9EE2
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 06:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771570545; cv=none; b=mwJzqlmMlfR2Y0tViwiMWlw8VQzuEBgKVMtG1pmhm49PHIEvCsnopbMCbVLg8doPoiWpIt4fDZ5T/jOkFtPplD7sp3tFEh5Y5hKV2aYSySJ5UelD8GT5cQ+oOOyihB4yA++dpH7VI3ewPL+sIYv6U9c0XPcNWpHVwOZy2qyhha4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771570545; c=relaxed/simple;
	bh=D9sxnWPtv9YRd0AbgIpG8AfysJRpjSD3c3F4zcxoLwI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XkbJam95//5RtYP9h/kiESN/wo8naXnghx5xVnzVAoqM19pQQMEgvN+XfiakwI1j5EmlQIC9TuEUYhHD52/Z8go7g/lFG89/LzOiY5dPU5mrPj+4SNBPIb6k/fMjLJmhyX94aEm4FuVdCPgNwb+R/Nh7giQzatWwl8UwjpEqmeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SfOGuKDz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SfOGuKDz"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61JKYEPJ1368452;
	Fri, 20 Feb 2026 06:55:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=vt7VPQlgEQsgi9yyjpJ1kGRQrA2PLI4Y2LKFPku55
	C0=; b=SfOGuKDzXd2799g1qJvXIqb1ctAN/r581j0TTkgeXblC5fSYheTvfSVFx
	lBhEVAc9UScNd0XgkR3Rb2sakNXpdWn0J9V0Om3IYsh6Pb4FgQ3rnf8+lw0LNVLH
	MX8Sa6ZKl7L8uwYdmmTrDiodl3cDy6A4SXQGUHWJo+ub9CqGCO19oHTxdrTnRDt0
	Ia2nFhPVxXt55EHR/NxY98i2Mk0Hin356qYd2k9/1ZMDmBSFcDTH/8paJnfCLtZr
	qIUeQJa6neO33+JsPQXPZp/ObMIP8z3Ld9SlyWybHfiLRln5oEChTlg7cXR12/AX
	k3XiqGMqmj/KXZn2L4lhjYdsUWYDQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cajcjrduv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Feb 2026 06:55:08 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61K4JkQ4011961;
	Fri, 20 Feb 2026 06:55:08 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb277ffy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Feb 2026 06:55:08 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61K6sjC310355214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 06:54:46 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B5C28580C5;
	Fri, 20 Feb 2026 06:55:06 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 14403580C8;
	Fri, 20 Feb 2026 06:55:04 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.30.51])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Feb 2026 06:55:03 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, nirjhar@linux.ibm.com
Subject: [PATCH v4 0/4] xfs: Misc changes to XFS realtime
Date: Fri, 20 Feb 2026 12:23:57 +0530
Message-ID: <cover.1771570164.git.nirjhar.roy.lists@gmail.com>
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
X-Proofpoint-ORIG-GUID: cH2yT0m70MpxWXfUZ_eJKulNqAEag6PV
X-Authority-Analysis: v=2.4 cv=Md9hep/f c=1 sm=1 tr=0 ts=6998054d cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=gs4zxHliH2u7Qpiui64A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDA1NyBTYWx0ZWRfX4AARlZ0QzC6M
 oU98jgwExKNWX8KTFcvBAmsAfNIEsKXVcH+Lb6y6qe2gyHSmKU9DQkcaTYQL11kiE3ox+BDOYt6
 e0muPWoileCcbqWbEIs+2EeQHtW1S634yEy+aIx1V5NSq7C/o9mSoF/cgnanv8q29697YHPISby
 t9fRoaPKZXjJJkeMep8JsqSsDq1lh2wo6jHLlbBNvrQCe+dUdwND/vzZ1rncUac9tc58hVJn3DK
 r01TBSc4DMUf4Iwm3YLpZzpCaYhdXdt2wWy3L1klzhAVdiLVgniIDYYIjUsoCEzKUD25zwUG2Hk
 mYgrwYhKikNLq3f91LgoMGJUqoL3i44Urt9C6VTI+IhaehH5E4USLZB5jYRdKDPkfe/0449FoD4
 UmIRSfoyZ0k2D3cRvFydO4Gt+CIguEb8uaTwUg/UUBbq1Eap1brvh5AGtRRLw0nL4OrXAYF3iEV
 5JV/MdeMg3XIbQoAPyw==
X-Proofpoint-GUID: 9fharZoRtF4ZCZvEj3a9C7ctq9JAMkfG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_06,2026-02-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602200057

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

This series has a bug fix and adds some missing operations to
growfs code in the realtime code. Details are in the commit messages.

[v3]- v4
1. Added RBs from Darrick patch 1,2,3.
2. Updated the comments in patch 4.

[v2] -> v3
1. Rebased it on top of latest mainline master(2b7a25df823d) since
   xfs_linux was renamed to xfs_platform.h.
2. Add RB from Christoph in patch 2 and 3.

[v1] -> v2
1. Added RB from Christoph in patch 1 and 4.
2. Updated the commit message in patch 4 ("xfs: Add comments for usages of some macros.")
3. Updated the commit message and added some comments in the code explaining
   the change in patch 3("xfs: Update lazy counters in xfs_growfs_rt_bmblock()")
4. Removed patch 2 of [v1] - instead added a comment in xfs_log_sb()
   explaining why we are not checking the lazy counter enablement while
   updating the free rtextent count (sb_frextents).

[v3]- https://lore.kernel.org/all/cover.1771512159.git.nirjhar.roy.lists@gmail.com/
[v2]- https://lore.kernel.org/all/cover.1771486609.git.nirjhar.roy.lists@gmail.com/ 
[v1]- https://lore.kernel.org/all/cover.1770904484.git.nirjhar.roy.lists@gmail.com/

Nirjhar Roy (IBM) (4):
  xfs: Fix xfs_last_rt_bmblock()
  xfs: Add a comment in xfs_log_sb()
  xfs: Update lazy counters in xfs_growfs_rt_bmblock()
  xfs: Add comments for usages of some macros.

 fs/xfs/libxfs/xfs_sb.c |  3 +++
 fs/xfs/xfs_platform.h  |  9 +++++++++
 fs/xfs/xfs_rtalloc.c   | 39 +++++++++++++++++++++++++++++++++------
 3 files changed, 45 insertions(+), 6 deletions(-)

-- 
2.43.5

