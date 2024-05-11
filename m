Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3A07F6
	for <linux-xfs@vger.kernel.org>; Sat, 11 May 2024 00:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715387672; cv=none; b=IjsUqBUPUZ0Gri21yhZydqOeT1vgOxqxzAyGnIJvYjrPJ84RCADDqnT32xH1HXNFZ3kJv4HS4SUCEYCxNOU9PrcaCzs5GW58fow99t7VxLqIUDJ1+PZ+gLtE/86ZAzCzHRCtQ8g3IpZy7Mgc0HIXlOpFhEA04ROyqUfnmPxhteQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715387672; c=relaxed/simple;
	bh=0y2jZRmKdnolQJyjH7DbzX4E2g5az3i0aL1JhseL38A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=r3aT7zYHx2g0hSoP3uhIizeKa3qcQ0I1uQML1R645hQQETdouC/PgXw0AqsVo/LTn3SkP9jDVaKzlIHEG/L8PrZgImdm+uh+KdmsDCd0pZkgTBNfVd4SVO/SD6YEAN10XQNQ3K2g2E3tobxxw0R4Bso8mM7RyjoMZyUx/SAZTAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LNtoHOQj; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LNtoHOQj"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44B03AZN024308
	for <linux-xfs@vger.kernel.org>; Sat, 11 May 2024 00:34:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=n4Ura1mO5E3OfVpRPwwyf8U5sbwN3eaDWGRBVYAz3HI=;
 b=LNtoHOQj6gHa65f5d3PKQJpcEU4pivfXVY9NKMeuUdy0WUi/ckXI4eOLTEqySZhtsfeS
 nOJ0x2DQw2U5tpvhsU4QA7iRmKrP/1Bme7M+AKHCqflnmnh0GKG2rwWN2vOlxp6DkK3U
 EHf9d7XNbsUYLSWHJJTMCzBosMFp9+MsAgnth96MZ7LHPeasQ/yHcEHlbEj38uINwPxM
 G1SeiIOtuY5DbfLWw4hLWkWsu0iQBiyh+jdpKmzYt/16uQ76zQpIuM+apVnE1SKre4vW
 nShZTfrlo+KjIB1lQgEsXuOYBsBSJvvJr22FGnqTBUTyFpD/hHimz8MKdbPtWoL3K5++ 7Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y1v17r4m1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Sat, 11 May 2024 00:34:28 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44AMNpTG028942
	for <linux-xfs@vger.kernel.org>; Sat, 11 May 2024 00:34:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xysfn6agh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Sat, 11 May 2024 00:34:27 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44B0YR4Y018854
	for <linux-xfs@vger.kernel.org>; Sat, 11 May 2024 00:34:27 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-129-215.vpn.oracle.com [10.159.129.215])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xysfn6agb-1;
	Sat, 11 May 2024 00:34:26 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH] xfs: make sure sb_fdblocks is non-negative
Date: Fri, 10 May 2024 17:34:26 -0700
Message-Id: <20240511003426.13858-1-wen.gang.wang@oracle.com>
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
 definitions=2024-05-10_17,2024-05-10_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=977
 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405110002
X-Proofpoint-ORIG-GUID: -haG3T9lE73mEKRqq0gVxhtmkHXPXY0m
X-Proofpoint-GUID: -haG3T9lE73mEKRqq0gVxhtmkHXPXY0m

when writting super block to disk (in xfs_log_sb), sb_fdblocks is fetched from
m_fdblocks without any lock. As m_fdblocks can experience a positive -> negativ
 -> positive changing when the FS reaches fullness (see xfs_mod_fdblocks)
So there is a chance that sb_fdblocks is negative, and because sb_fdblocks is
type of unsigned long long, it reads super big. And sb_fdblocks being bigger
than sb_dblocks is a problem during log recovery, xfs_validate_sb_write()
complains.

Fix:
As sb_fdblocks will be re-calculated during mount when lazysbcount is enabled,
We just need to make xfs_validate_sb_write() happy -- make sure sb_fdblocks is
not genative.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 73a4b895de67..199756970383 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1037,7 +1037,7 @@ xfs_log_sb(
 		mp->m_sb.sb_ifree = min_t(uint64_t,
 				percpu_counter_sum(&mp->m_ifree),
 				mp->m_sb.sb_icount);
-		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+		mp->m_sb.sb_fdblocks = percpu_counter_sum_positive(&mp->m_fdblocks);
 	}
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
-- 
2.39.3 (Apple Git-146)

