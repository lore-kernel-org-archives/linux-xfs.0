Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C461238C16;
	Thu, 19 Feb 2026 06:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481125; cv=none; b=N+1A/5jerSS44Ydy9w+5ErX2Db76oCAjcy5djrzke0eL81UR1vcBrDx9CZs3eSWPC4yLu+bx/MHQCB/yhRuP93VpSlF7fkgEXNGmW2izUzWfNsxiqvVXHTiZ6SNH+R/f2M9XfXSQaHriKEn42fsCJGyAAmJ1zAxPlbdJgL0J80I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481125; c=relaxed/simple;
	bh=lB50Eqh15ez+aztP5vAGklG3vGcTMOuSBG5jDtF64SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udE8khgPWOnBu2oki94dw7rwvkyyROj4km6CN2hVEc5WcIrT14Ip1+rZAK+kZQWBnVWskTuTj8KOTJpfuZWNoo4hpaPwKg6+xgn6utZyPe1WruzYBle4jOhJEUb3DQOPY8YDqrrzP1Q1+Rbepc9Of2FI+bwsTVRACFcsGEsNlW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rnPgIiYX; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rnPgIiYX"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61IL4K6S3493025;
	Thu, 19 Feb 2026 06:05:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=tJENTSsEnn8dpi8fd
	TG0U10rZfB/sTfudu33PNdjJcA=; b=rnPgIiYXIXkDyjjBodkO7BL03Se5LlWr7
	K5UzNtzMR2AYyfZZNncPP+kIXbnK3dufE1LJbckYmUGaFEkubU8PdB+C2nIM7RK7
	BJn7Qo0BUkvHEozKirwcFxhntcjfI4aA3WUTAsTS/fNqH6ksaUfNFK+9AmOYXN/U
	uN0dqPE16EzOGwZdQPp23yeMnSY42KtqJzZz+48pvhly5ZY34LSThGFTUnOyX+lm
	czAYO002b72z+CgIycekbev6RD28B4hjhnbMJnIUzzxFUTCp09MYXi46rrIH3sKz
	0zkW30ssk+gYeiMKru5tTFHxTZJYtEhVblIXHhAJWv/QdrsetdLZg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj6s4p0t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:05:13 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J3PI4j030217;
	Thu, 19 Feb 2026 06:05:12 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ccb45aygu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:05:12 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J65Bn315860448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 06:05:11 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5087D58056;
	Thu, 19 Feb 2026 06:05:11 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3C99C58052;
	Thu, 19 Feb 2026 06:05:08 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.124.222.193])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 06:05:07 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org, david@fromorbit.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, nirjhar@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, hsiangkao@linux.alibaba.com
Subject: [RFC v1 0/4] xfs: Add support to shrink multiple empty rtgroups
Date: Thu, 19 Feb 2026 11:33:50 +0530
Message-ID: <cover.1771418537.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260219055737.769860-1-nirjhar@linux.ibm.com>
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=dvvWylg4 c=1 sm=1 tr=0 ts=6996a819 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8
 a=JfrnYn6hAAAA:8 a=oRyeP-uNSbtuw2HENgkA:9 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: RO_8T3X97MjIeQAZKO2RyCELKnc_cITN
X-Proofpoint-ORIG-GUID: tBHkeDeKRVQJC0n-_-aXhbWamVCYrSLF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA0OSBTYWx0ZWRfX2C5UGalYeMjG
 YIxecnfF7Ok4V9oTg6vUNNyLt8/0COJDoTaG8Or1FgiP2alJ+GS2Wa+dhgOKoQyjWn3p1rPJUkW
 iicxIh+RZwvFNRST8f2NOSFI5pM+BB/FoblmLLtpCP/G7vOjSOv2p980WRxmqk3t/T8NGyz/LUk
 AE+k+KPgg41UIHkCSv3YS+3NYdc77onulU82ARs+92lxIZog89ofn18nuC0zAh5LmZ5P3brsF5x
 9QPWNRbIMgHAmK5fdchydap27TSKNxMnYy9O68uQAzJyzR1jBrtoOf8GAIN3HnQE6LB9Hg9zQEH
 Ml7Vtub07kasFcMQC8Y6pVkYkV6sT9gaamJ0dFybmGr4sTYINmGgOWQK3xk4rePNFbfg+LY71E8
 P8eQb2hwPjPOA5t6eV5/lFtxpPQnlOYj0wiVEYIGt54AGzzCWLnCOVU+qKPHEPIMIRgjXbUOUM8
 dDQOsq2kD5cFfJu/bLw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_01,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602190049

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

This work is based on a previous RFC[1] by Gao Xiang and various ideas
proposed by Dave Chinner in the RFC[1].

The patch begins with the re-introduction of some of the data
structures that were removed, some code refactoring and
finally the patch that implements the multi rtgroup shrink design.
We can remove only those rtgroups which are empty.
For non-empty rtgroups the rtextents can migrated to other rtgroups
(assuming the required amount of space is available).
I am working on the patch series [2](by Darrick and
Dave) for completion of the data block migration from the end of the
filesystem for emptying an realtime group. That will be a future work
after this.
The final patch has all the details including the definition of the
terminologies and the overall design.

The design is quite similar to the design of data AG removal implemented
in the patch series[3] that I have posted earlier.
The reason for keeping [3] on hold and posting this patch series is
that (based on the discussion in [5], [6]), realtime devices won't have any
metadata/inodes and migrating data from the end of realtime devices will
be simpler. On the other hand there are challenges in moving metadata
from regular AGs especially inodes.

Please note that I have added RBs from Darrick in patch 1 which was
given in [4].

Instructions to test this patch:
$ Apply the patch for xfsprogs sent with this series and install it.
$ mkfs.xfs -f -m metadir=1  -r rtdev=/dev/loop2,extsize=4096,rgcount=4,size=1G \
	-d size=1G /dev/loop1
$ mount -o rtdev=/dev/loop2 /dev/loop1 /mnt/scratch
$ # shrink by 1.5 rtgroups
$ xfs_growfs -R $(( 65536 * 2 + 32768 ))  /mnt1/scratch

I have also sent the tests.

[1] https://lore.kernel.org/all/20210414195240.1802221-1-hsiangkao@redhat.com/
[2] https://lore.kernel.org/linux-xfs/173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs/
[3] https://lore.kernel.org/linux-xfs/cover.1760640936.git.nirjhar.roy.lists@gmail.com/
[4] https://lore.kernel.org/all/20250729202632.GF2672049@frogsfrogsfrogs/
[5] https://lore.kernel.org/linux-xfs/aPnMk_2YNHLJU5wm@infradead.org/
[6] https://lore.kernel.org/linux-xfs/aPiFBxhc34RNgu5h@infradead.org/

Nirjhar Roy (IBM) (4):
  xfs: Re-introduce xg_active_wq field in struct xfs_group
  xfs: Introduce xfs_rtginodes_ensure_all()
  xfs: Add a new state for shrinking
  xfs: Add support to shrink multiple empty realtime groups

 fs/xfs/libxfs/xfs_group.c     |  18 +-
 fs/xfs/libxfs/xfs_group.h     |   4 +
 fs/xfs/libxfs/xfs_rtgroup.c   | 105 ++++-
 fs/xfs/libxfs/xfs_rtgroup.h   |  31 ++
 fs/xfs/xfs_buf_item_recover.c |  25 +-
 fs/xfs/xfs_extent_busy.c      |  30 ++
 fs/xfs/xfs_extent_busy.h      |   2 +
 fs/xfs/xfs_inode.c            |   8 +-
 fs/xfs/xfs_mount.h            |   3 +
 fs/xfs/xfs_rtalloc.c          | 824 +++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans.c            |   1 -
 11 files changed, 1023 insertions(+), 28 deletions(-)

--
2.43.5

