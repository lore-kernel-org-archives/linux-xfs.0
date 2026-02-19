Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73A91862A;
	Thu, 19 Feb 2026 05:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771480712; cv=none; b=m15l9bGKxVzFuHlXNoNZr5psARs5lG7yLM0mOS61ucEY6agga4ha/aIThoUGCqM4c4ZXehcfBUzXYUoAuQvyLjhEg66bUBa0arsO+lks98eDkoGZwnFgiZOklKdZV4m3xkwQDauIvpGwWNcU2dafXxdoBfw6P44JaYxcFiqtM7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771480712; c=relaxed/simple;
	bh=D5RqrBmHt8nvzcYl/fPfb6bdkFwDviwjUNmgfNWW/GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hK5Cd2gNCV7t9m3f+jPJRF+u9R3Oqy7zjYvd/MygH/TazZPRcqTSZSvIPJMbeupeuB1sRMxg/+87JxsuUDpMAdz2rhnit+mATaVmn/nJIruRfBwR9TCaooCGSj/+A/zw/i+aF25arc1oqEivL3NKnZpbaGr6Qeh1N9vyJ+H3dXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NI+DOAXC; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NI+DOAXC"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61IKu1Jr2385573;
	Thu, 19 Feb 2026 05:58:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=lo42pwDlmqBkfJBu7+rMurnWtOamp6zpP0WfgtCMG
	mQ=; b=NI+DOAXCohvIGi0IyfQTym9WzHodppNHcu0+CuodCLqWUvdw2HK4cROR8
	ptduyEk56pIhAunNb3y1eMoZRKXfNW8tj6eytTfBUefp2vktbrA5lpSfzcVBxe6K
	1XfL4nJgWdCyEnFzdpqQhXqpi8MeHHXCIixxZ6FVHMqLUHTE2cbOPu5k19NGf/kI
	iTi7U6OdiZvJyKmaen2MS1yC6UtTno6UO4iEUxDLrEQ6M/RV/vS1oKic02OeKZFM
	8kHpmFSaDhF1VqcZSEgexhiaFIzHMaixdyn3fJ1iknPQNLH9TizEcIoF4Io1c2dg
	4nd4ANuIUcI/LgC6kjEJdRzqLTpuQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj6s4nax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 05:58:06 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J3j1e9023889;
	Thu, 19 Feb 2026 05:58:05 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ccb45ayjn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 05:58:05 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J5w4sC6685288
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 05:58:04 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 12DA65805A;
	Thu, 19 Feb 2026 05:58:04 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D06EA58064;
	Thu, 19 Feb 2026 05:58:00 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.124.222.193])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 05:58:00 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org, david@fromorbit.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, nirjhar@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, hsiangkao@linux.alibaba.com
Subject: xfs: Add support for multi rtgroup shrink+removal
Date: Thu, 19 Feb 2026 11:27:37 +0530
Message-ID: <20260219055737.769860-1-nirjhar@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=dvvWylg4 c=1 sm=1 tr=0 ts=6996a66e cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=RENAhGd6LJAaAP7iAGoA:9
X-Proofpoint-GUID: zNfnR-NIzgVHBpY4gqgGkge0whh2RLSv
X-Proofpoint-ORIG-GUID: yqg-A-cfrZwwtnDyfeP84YarITPngUDY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA0OSBTYWx0ZWRfXxaVWsQo55Bnf
 MxQ+eY7PmZizp5KbiiWHT3swLgmvrcHhVoReBRgWSfT6Qyanp7qlNfqADqPmfKaQWdErdXVzC/o
 eq3lbfaNHBQfWHSa+keim+QvVWJVWjJa6VFua/xsEFok108mSNxTWZBXdXXFDILXLK76zRbt3Rl
 fLN6LccM2v5oPcVKsgcqVCJJr0/5QTDljMJ8ey8/1kxn2y84dAb0IXpj9taxyD/s/ja9aKBlYFy
 G7d5/VYgxh7lyRYPqkrgF8bJqs4KBfjlIfdLW70OjRlNkc7RL+6rQoR5D5znWYDmgQhgItn22i3
 uhf0jHS3zsB1L/BdnyoegVqV1uQlJTNVL8qvl7gxFt/EkOtr0VpxG8f4M10YE405zEcDTUv4lmS
 VEh3QPb4DmCMw/aRiTPFg5ecUQB+jUfq6fZwdf5uVMcWl1+swmrLCN0u41bmNMqnU69hviP6T4p
 nA8Z0Hggt7hsv0Qvy3Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_01,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 clxscore=1011 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602190049

Hi all,

This series adds online support for shrinking and removing multiple
realtime groups in XFS.

Currently, realtime group shrink/removal operations are not available. 
This series extends the infrastructure to allow online shrinking/removal of 
multiple rtgroups in a single operation.

The work is organized into three sub-patchsets:

  1. Kernel changes
     - Core filesystem changes enabling multi-rtgroup shrink/removal.

  2. xfsprogs updates
     - Changes to xfs_growfs allow the shrink requests to be passed to the kernel.

  3. fstests additions
     - Test coverage validating grow, shrink and removal of multiple rtgroups.

Each patch includes details describing the implementation and design considerations.

Comments and reviews are greatly appreciated.
