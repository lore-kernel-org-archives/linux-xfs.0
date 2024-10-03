Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2159613B780;
	Thu,  3 Oct 2024 10:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727950346; cv=none; b=ZEYIdt/Ed+jOd35MjbPp4gCYeMmHm5GkGmRtRjttzEo4+gnmLF5m4CIQpU25xj7fi71+FL4VfMjhDlx6lVIvd4pRvJgfZQuSvQuyxD0XvfehrRW7/6E1JNx+SxFw5i37j1CDcaqytCKQoqACSrT4YBE2n+gh3MY7RGvJRJeRXlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727950346; c=relaxed/simple;
	bh=KzG8zL4AzG1hFYloYuqzq+fGW6PcU8QWSrNexnu3abE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oAOXPV9NXgkdwUAJV/V3MPGPVZB1n401LOeUatHibCkczmXzNf4SLtt9qwGiHEkTchJoIrNTDmf+8tfzKMjlTnaOqRYUpAclbqns8Zq3FNc6sNMo9+hHzy/Y8pNPOkZjRFD9jRABRd9ck4YnuQbGIp+RZ7QRdP/P0FN6ei0EJWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=f+UPzySf; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="f+UPzySf"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4939tOFn021499;
	Thu, 3 Oct 2024 10:12:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=/JQEd6iw662ZfguHaBbkaGClwE
	ytKH5/pcNOoNSB/s4=; b=f+UPzySf0lV0cbfE/4H2NRAwEe2doG0sLcNJeZi1n0
	3mpLYoM2jrI+F3ndmZ4Z1Egvv4JLlSi76DcL87mkC4C5DC5Q+BqVXCcTcIJbOjSK
	RML9zkzam3oOjndgU/qOLGkIxeDJXG3YWapTgyC0aX1sQSLU0pcYS3ZaH6buMPxK
	2fXA0TAoFg/kdqRuISPUT3IJ83HdSQX7cz1FxwfCmEl23OQsV7lsktxWhSOWheUn
	mQNJxBicbmR9dRp8hXHy8PQVMWSIipCzDEZDXxBxq89ni7RJs6bUA0nCQWdbXgrz
	lkOrn4giVqyeiFPfMeoQF5SGe1/0Ukr+7ASuhfY9g3bA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 421s2cr2ea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Oct 2024 10:12:14 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 493ACDex030614;
	Thu, 3 Oct 2024 10:12:13 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 421s2cr2e5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Oct 2024 10:12:13 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4938AMPg017866;
	Thu, 3 Oct 2024 10:12:12 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41xw4n76wq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Oct 2024 10:12:12 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 493ACAw857999672
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 3 Oct 2024 10:12:10 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D49C2004B;
	Thu,  3 Oct 2024 10:12:10 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 50D282004E;
	Thu,  3 Oct 2024 10:12:09 +0000 (GMT)
Received: from li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.in.ibm.com (unknown [9.109.253.82])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  3 Oct 2024 10:12:09 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: linux-xfs@vger.kernel.org
Cc: Ritesh Harjani <ritesh.list@gmail.com>, linux-kernel@vger.kernel.org,
        "Darrick J . Wong" <djwong@kernel.org>, dchinner@redhat.com,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH] xfs: Check for deallayed allocations before setting extsize
Date: Thu,  3 Oct 2024 15:42:07 +0530
Message-ID: <20241003101207.205083-1-ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nux7zMiW8P7ENlx94t1xnhuJK9F4SMeA
X-Proofpoint-ORIG-GUID: 0kZIqqGFzDMT8mS0f47tBTu1BpvJ3cGJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-03_06,2024-10-03_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=572
 adultscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1011
 priorityscore=1501 bulkscore=0 impostorscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2410030065

Extsize is allowed to be set on files with no data in it. For this,
we were checking if the files have extents but missed to check if
delayed extents were present. This patch adds that check.

**Without the patch (SUCCEEDS)**

$ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'

wrote 1024/1024 bytes at offset 0
1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)

**With the patch (FAILS as expected)**

$ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'

wrote 1024/1024 bytes at offset 0
1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
xfs_io: FS_IOC_FSSETXATTR testfile: Invalid argument

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/xfs/xfs_ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 7226d27e8afc..55b574b43617 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -602,7 +602,8 @@ xfs_ioctl_setattr_check_extsize(
 	if (!fa->fsx_valid)
 		return 0;
 
-	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
+	if (S_ISREG(VFS_I(ip)->i_mode) &&
+	    (ip->i_df.if_nextents || ip->i_delayed_blks) &&
 	    XFS_FSB_TO_B(mp, ip->i_extsize) != fa->fsx_extsize)
 		return -EINVAL;
 
-- 
2.43.5

