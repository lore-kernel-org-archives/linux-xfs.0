Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80D02F067E
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 14:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771512468; cv=none; b=EEpDTZ5RgZuaBWCG4gYKtHfMJvbaWprvoAnCZ4wO9IAyhqTqrY8Db8EIVNGKd1KI5dB8+S2UWrDeJnQcTAqd/1kPXNjWUXQ5xTmDzK6xoX9Y/6JQSQHFARUWNMh80P5s/xcK3p7vs7fHZdX6w+w37UmrUu0XJZ/eugoIGY3Ookg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771512468; c=relaxed/simple;
	bh=25p/SS9SjgCNHPyycIFGZA75Ti88amcv5ccjjsUqPu0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aGBRvWVcE+dejIpothNhUghaJ2leacjtzhoLg43O96fGR61O3YjsynVUS4EKLi/ikpGsJ9f+NaxttM05WUY6R35JsIMeJs0gfyE7T3wBjR+AByRnHoj0jolsfa1uwv6wbWwOABvSHlaJHygHi5KfP6c5xdQSo5ZJS6Vfza7aXVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CAe7KHFn; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CAe7KHFn"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61J9AO8K1296447;
	Thu, 19 Feb 2026 14:47:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=VVohaIPZEDpgWkIht8ckSUS066yA78o/oc5yaXOjW
	qg=; b=CAe7KHFnKe9s94UA1Kx4dxExWIXLih4FrcbX7D6s0A9+QTit2CQ28NVYz
	4xDN9spF4iB4roGxnQxki7Y/XQAQ3kw7S7t5OC3pXa8NfY+wpCR6SDNIh3e7DoRT
	vl6tfUdfdHDRw/+KMZWYMaMCEq9NZ0aftSlEDru9+fIc/o/nDk3HTskiLWGDxQQX
	Ddib0Enrp+Ion/yUEDt7SmJOW8ajVcJPx6qLp4EV2ds3ddsnv5YjzovVowBGkuHA
	EvsocHVb8BEAwIrAJoNTheadwDyxDHrTgELR2mwbziNtkuc5A5A5OIlocWsGw9dk
	tGkbmE7SscjKeGqJ5TRYMK/EVAGRw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj64d9x4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 14:47:38 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61JDDmCX023899;
	Thu, 19 Feb 2026 14:47:38 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ccb45cjp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 14:47:37 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61JElais15205078
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 14:47:36 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA83458055;
	Thu, 19 Feb 2026 14:47:35 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7878958043;
	Thu, 19 Feb 2026 14:47:33 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.21.217])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 14:47:33 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, nirjhar@linux.ibm.com
Subject: [PATCH v3 0/4] xfs: Misc changes to XFS realtime
Date: Thu, 19 Feb 2026 20:16:46 +0530
Message-ID: <cover.1771512159.git.nirjhar.roy.lists@gmail.com>
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
X-Proofpoint-ORIG-GUID: Cf-VCEOa_8UVhBbyRBMRvLkSSyPotvJa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDEzNCBTYWx0ZWRfX1W6UQrpci+5Y
 69EwIheMY+J/4TTFgE/07iuKlRZcv2FU7sihFPvxbkFrXWUT3Pdy7bJZxPugvczcxfutKaAOwZi
 ktpU7YPuAWpZZfR4zGfbUYxa882UVV8kz0+TWWtCuiaJ5J3dXeHeI6D++Ezm729vCxgJxJ/H/Ue
 6ikS2nImmIs/3Xfi9zDK3ofquF6UhGG9LGT+NoYiCy5ZrL/gCN2IXx2hnk1GCHX1ASsLQNKWk7c
 2fWopQGZyS623c13USHAySFT7I3Teno0TIkQ0vQzeyM56G5gYUCPCOZeWV9rswmUYVUijbRuAQI
 soLAneSuV4Bx516jb15hJPPshBo+xJTjQs/rYeuIAUrkZ95H2lR9QaPEV/kD7vyS9Cf+Lco9VQh
 vKJjL5VT/CIiFJDdh7T6Pj58SqFqIqo/f1ats0mQBgTzwD+rpew8WTljqMHr+XoQFmOwMDR8s0F
 aonmHnC09+7vq60yc1Q==
X-Proofpoint-GUID: -BJ3LI4T2UPFvFYJcn8zdTMwidVGvqjw
X-Authority-Analysis: v=2.4 cv=U+mfzOru c=1 sm=1 tr=0 ts=6997228b cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=GMJymKxJvLBD7Yxb25MA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_04,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602190134

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

This series has a bug fix and adds some missing operations to
growfs code in the realtime code. Details are in the commit messages.

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

[v2]- 
[v1]- https://lore.kernel.org/all/cover.1770904484.git.nirjhar.roy.lists@gmail.com/

Nirjhar Roy (IBM) (4):
  xfs: Fix xfs_last_rt_bmblock()
  xfs: Add a comment in xfs_log_sb()
  xfs: Update lazy counters in xfs_growfs_rt_bmblock()
  xfs: Add comments for usages of some macros.

 fs/xfs/libxfs/xfs_sb.c |  3 +++
 fs/xfs/xfs_platform.h  |  6 ++++++
 fs/xfs/xfs_rtalloc.c   | 39 +++++++++++++++++++++++++++++++++------
 3 files changed, 42 insertions(+), 6 deletions(-)

-- 
2.43.5

