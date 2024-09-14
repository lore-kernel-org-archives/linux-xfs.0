Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AD91487C1;
	Sat, 14 Sep 2024 09:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726304477; cv=none; b=dWapTfN8Uqt3M59M/egXSxbsI86X4c99l4HamISkwB8OcqSgQle5ZjPUtv3YIbkOBa4+quGHl76vpYAA1rtUaD9eVmy0KcVAc/wBd33+YgaP/07SEbOfYF++Fat0X3oNRM0tlvmxSlYEErkA6CMVBMan2J8gqKifb/JGzz8MBqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726304477; c=relaxed/simple;
	bh=icNKcmpquoKE/03kYN3EdCdWEne6Kb6LGJ0UkA8qL/M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Di9iznjrfIOwdS61uBKeHmIrcXdvY6rdrxFV/EwBE8YLQtksqef0ZKc5JuFDoUz2vxaC4q4dTVcQ0WvNyRHZ4Kr4/woZyubBuVfc8Yg4B7qELTGe6AeFUFSiKZNt5lDvO62zraTMqMsHpC8ZIb9T4dSqtpGQ3tJMG5aR6BpfV9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48E8sN0Y012592;
	Sat, 14 Sep 2024 02:00:55 -0700
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 41gpbk7sr6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sat, 14 Sep 2024 02:00:54 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sat, 14 Sep 2024 02:00:54 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Sat, 14 Sep 2024 02:00:52 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <syzbot+53d541c7b07d55a392ca@syzkaller.appspotmail.com>
CC: <chandan.babu@oracle.com>, <djwong@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_can_free_eofblocks (2)
Date: Sat, 14 Sep 2024 17:00:51 +0800
Message-ID: <20240914090051.636332-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <0000000000002b8b05061fb8147f@google.com>
References: <0000000000002b8b05061fb8147f@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: RgLr_YTnMDgahEVsPlEO5MeKi9noxxU7
X-Authority-Analysis: v=2.4 cv=Ye3v5BRf c=1 sm=1 tr=0 ts=66e550c6 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=EaEq8P2WXUwA:10 a=N7_jEAYsZG4nfPjY8GMA:9
X-Proofpoint-ORIG-GUID: RgLr_YTnMDgahEVsPlEO5MeKi9noxxU7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-14_07,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 spamscore=0 mlxlogscore=669 clxscore=1011 bulkscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 classifier=spam authscore=0 adjust=0 reason=mlx
 scancount=1 engine=8.21.0-2408220000 definitions=main-2409140062

we use GFP_NOFS for sbp

#syz test

diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 7db386304875..0dc4600010b8 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -114,7 +114,7 @@ xfs_attr_shortform_list(
 	 * It didn't all fit, so we have to sort everything on hashval.
 	 */
 	sbsize = sf->count * sizeof(*sbuf);
-	sbp = sbuf = kmalloc(sbsize, GFP_KERNEL | __GFP_NOFAIL);
+	sbp = sbuf = kmalloc(sbsize, GFP_NOFS | __GFP_NOFAIL);
 
 	/*
 	 * Scan the attribute list for the rest of the entries, storing
