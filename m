Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A9C279355
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 07:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771486818; cv=none; b=ujzNB+zVIs4y5bVA8//L0KSRA0Anmg4I9kgjOFvdUGslhjasdXsItF7I6iYQ1IEVNJUc/7TSA+PZwN1fT8zryGQHNnM7JZ8VneCX2KkCvp+VwEnmEI4yAtCIgd+NcyheTfLdABuFMsac/Xx1dVJttgVei7V09M2FdWvmoIU4Pkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771486818; c=relaxed/simple;
	bh=XsBXRXTi4UQPEoM2nUy7zO/zVBheGssDxqBWAic1tsw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nMhYB7/JPSYU7HQidkoZK2xJ/DnkqvR8rXH8YJU5D/YOB9sANGEGKWyq+Gq/Z/htmGdGlN2GIZ8e1MpTfxV9asxqejM3BGbiks+WPVeQyyW9lgWVo/09XIcuq5PvdJaKt1LqmcivmX5Ia/DJlH6KKR475rV7bSEjqQXgMb8xsDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NtUpZQtH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NtUpZQtH"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61IGOHXv2414481;
	Thu, 19 Feb 2026 07:40:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=vbuFtckg+seTk7gIEBJ75DgpFoA/V4z50aYvp9ZNq
	sg=; b=NtUpZQtHpzkJa3RVgDWFqm8U8tt7pdpi8gW9OYc9qkSsidtunXN122IMx
	8UIEdvqFV/yGVJF4+ltCA+qLmTGxtlcVg4OnfXt5tuWCzudFONgJmrOrhWnvISbE
	cXIqfbA7Gf+oNBLCOW82Djv/L3yghozDVP5dRHcAIsUG8OJB/YX411NA/8ZYKwA5
	OXNa5pYaZQX2dV6FyklHIbO5aoihqNYVv8k5J2y8ivyQIHHq4SkjcQgJ3Z80WjxJ
	CyECAUY+vMuXFokbo9QjNGbfJ8ERaOpX+8OGAmxA/CHgIY7Rf10E0+RC9MvKsBS0
	uH7AztuGa35nU9vHhVWNNcA0br41Q==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj6uvyca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 07:40:09 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J44XQ8001419;
	Thu, 19 Feb 2026 07:40:09 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ccb2bk840-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 07:40:09 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J7dkI229229586
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 07:39:46 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E1B0F58060;
	Thu, 19 Feb 2026 07:40:06 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 68CB158056;
	Thu, 19 Feb 2026 07:40:04 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.28.60])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 07:40:04 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, nirjhar@linux.ibm.com
Subject: [PATCH v2 0/4] xfs: Misc changes to XFS realtime
Date: Thu, 19 Feb 2026 13:08:48 +0530
Message-ID: <cover.1771486609.git.nirjhar.roy.lists@gmail.com>
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
X-Authority-Analysis: v=2.4 cv=E+/AZKdl c=1 sm=1 tr=0 ts=6996be5a cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=vq7Qz97t6oqxbSrsJnwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA2OSBTYWx0ZWRfXyAdqWTNMibZx
 nd1o5K6fv2V+Hqa1EJZ/r++KVmw1JjWKoa/T0bcU9um626BkXrEA2qusVQd0h1SjZ2iH6bGbM5s
 dQFw2YZ9FTYZOS7wqBxevP8qpcPkRGCgCJayP0ZYMrKix5ts+gMSqorY042eWGo8dw7DSr+9Rir
 ST7kI5xRgCd/Ln49YzYxGS5CF4BaSxCvbRVy8Xuui9mYB2gYZYjM7z/qZj1G/3a5N4gF04JdODB
 52bNiWEGhlymKTRycnsRULOccs0J2NDu4uIqHQnQi/vp5DKla+p3ZsDUkPJNaviOOszt5rEWc2Q
 1fmsUY80mP031EqaIdAbc6iV3ReMrOte7v89nL7oGvv5euv7r3E6ZrSdhJ5mQQ7QhWTvjCGQRpR
 bvIhHsFcJAe/tDzKBw6CUdd3ubW8f5UGFw5elUdb+4AKtLoqatPssvwBlGB8V7/7+xj7zeiNDxA
 QKMNai3kq72sAEGfYKQ==
X-Proofpoint-ORIG-GUID: IBrcrzXDdjHiA0_FtkaCEr21LaErszBj
X-Proofpoint-GUID: BHq31Xr_XVBFqrwgH8BmQ6LxZltmPFSz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_02,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190069

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

This series has a bug fix and adds some missing operations to
growfs code in the realtime code. Details are in the commit messages.

[v1] -> v2
1. Added RB from Christoph in patch 1 and 4.
2. Updated the commit message in patch 4 ("xfs: Add comments for usages of some macros.")
3. Updated the commit message and added some comments in the code explaining
   the change in patch 3("xfs: Update lazy counters in xfs_growfs_rt_bmblock()")
4. Removed patch 2 of [v1] - instead added a comment in xfs_log_sb()
   explaining why we are not checking the lazy counter enablement while
   updating the free rtextent count (sb_frextents).

[v1]- https://lore.kernel.org/all/cover.1770904484.git.nirjhar.roy.lists@gmail.com/

Nirjhar Roy (IBM) (4):
  xfs: Fix xfs_last_rt_bmblock()
  xfs: Add a comment in xfs_log_sb()
  xfs: Update lazy counters in xfs_growfs_rt_bmblock()
  xfs: Add comments for usages of some macros.

 fs/xfs/libxfs/xfs_sb.c |  3 +++
 fs/xfs/xfs_linux.h     |  6 ++++++
 fs/xfs/xfs_rtalloc.c   | 39 +++++++++++++++++++++++++++++++++------
 3 files changed, 42 insertions(+), 6 deletions(-)

-- 
2.43.5

