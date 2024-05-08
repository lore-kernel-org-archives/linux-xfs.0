Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7296310953
	for <linux-xfs@vger.kernel.org>; Wed,  8 May 2024 17:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715187843; cv=none; b=iwUiD8JBfl6GjVBsx5sYuW2urKN4koJD5Fier0vj7/Fiipr7tnnmXWO+KrUriWJLbUFwFXAuQvmpyBC7K6/JAPMfKnPIrEiMU/PAhPQmzjOCxQiM5xHjAKSzzvGj5U8hTkdPh+zp+2skX/lkSz0TrBPnyKoZFqLcnOWj5pxadvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715187843; c=relaxed/simple;
	bh=syEvfyZpzQqUNqrQsD9Jrmefc1Zdtm11ff64fGPkm+A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Z8XtNmsSh7dfZODUEmmsobU1nezcb5ZZMgbqzk19k7XfjYd8ZG5PTvVnZd3cRoXtXvZNfh2WR/UgRQABI8Mp2VyWbGcyLyDYeTXb3lIzkWQbLpt462CQFh3FOGn8KJC0dq7Kf7/Lvg6rKFkFExfxJxHz3/QzkEhOKlQ0Cw74CGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=flzseHtd; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="flzseHtd"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 448CO2jZ001303;
	Wed, 8 May 2024 17:03:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=0B9ORRIRlqAjw/SRmZZpbrdHsmRpQU9SjBEKAPEwi6U=;
 b=flzseHtdOGaz+JrKGt972GdxH2TJK8mHWuZQ926Qbqi88of52lrarjEVkyZr6JEnMyAL
 6aovw/0yGi94BgO8CVz0SX973R7y3pPS4vNp1EalacyDIfFGC5LjTTLXD+aFZQMeWGbQ
 voqXBxHHSLzTgumUmYzNt3HyruJuXQi6Yd2OdjQMTKp8fzZHhJTER7m8OrEdRLG31GQP
 jKr4rL4eBP/cs11fzEAov6HoKqx3x2dDDJJs9m+fHA6f56hYpGHYhe8vrKQW+bTrCG2e
 GGoFMyJofwnhNLvIMR47Esuj02+Cd4s5Bs45k45A2eQLhbaRmATa9f0bTANVwpqyS97v hA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xysfq2c7v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 May 2024 17:03:46 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 448GtPeC031107;
	Wed, 8 May 2024 17:03:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xysfj2wrr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 May 2024 17:03:44 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 448H3ixH021038;
	Wed, 8 May 2024 17:03:44 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-65-135-240.vpn.oracle.com [10.65.135.240])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xysfj2wr5-1;
	Wed, 08 May 2024 17:03:44 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org, david@fromorbit.com
Cc: wen.gang.wang@oracle.com
Subject: [PATCH] xfs: allow changing extsize on file
Date: Wed,  8 May 2024 10:03:43 -0700
Message-Id: <20240508170343.2774-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-08_09,2024-05-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405080124
X-Proofpoint-GUID: xaxmhK3AZ--DJu2Pbf5lytJ-E4_6wfj8
X-Proofpoint-ORIG-GUID: xaxmhK3AZ--DJu2Pbf5lytJ-E4_6wfj8

Hi Dave, this is more a question than a patch.

We are current disallowing the change of extsize on files/dirs if the file/dir
have blocks allocated. That's not that friendly to users. Say somehow the
extsize was set very huge (1GiB), in the following cases, it's not that
convenient:
case 1: the file now extends very little. -- 1GiB extsize leads a waste of
        almost 1GiB.
case 2: when CoW happens, 1GiB is preallocated. 1GiB is now too big for the
        IO pattern, so the huge preallocting and then reclaiming is not necessary
        and that cost extra time especially when the system if fragmented.

In above cases, changing extsize smaller is needed.

In theory, the exthint is a hint for future allocation, I can't connect it
to the blocks which are already allocated to the file/dir.
So the only reason why we disallow that is that there might be some problems if
we allow it.  Well, can we fix the real problem(s) rather than disallowing
extsize changing?

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/xfs_ioctl.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d0e2cec6210d..b34992d9932f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1221,8 +1221,7 @@ xfs_ioctl_setattr_get_trans(
 }
 
 /*
- * Validate a proposed extent size hint.  For regular files, the hint can only
- * be changed if no extents are allocated.
+ * Validate a proposed extent size hint.
  */
 static int
 xfs_ioctl_setattr_check_extsize(
@@ -1236,10 +1235,6 @@ xfs_ioctl_setattr_check_extsize(
 	if (!fa->fsx_valid)
 		return 0;
 
-	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
-	    XFS_FSB_TO_B(mp, ip->i_extsize) != fa->fsx_extsize)
-		return -EINVAL;
-
 	if (fa->fsx_extsize & mp->m_blockmask)
 		return -EINVAL;
 
-- 
2.39.3 (Apple Git-146)

