Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAC528F948;
	Sat,  2 May 2026 18:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777744942; cv=none; b=iOgleeERgpPv6IN6nco8VfEcFXG5CO80TJtOF0QePba0CJeBfFYcXs2INnu+Vzh7+YDWJAxttxR2bC2dxF/YN3i+NNKkBelakadEIhKtJt26eXV5Cpt+gFnf1QlT7+ElLSd3EJW7YV2ofNyS92tYy529mShC4KxyfUdr9fLXL6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777744942; c=relaxed/simple;
	bh=mZ8CoE8feByV8DBXrv9ydzf3a/mGAszSc9XXgbACUDM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SpwD9P2WAHwJVk7dXKJV1LdNSQbJ3OwJXil34xeBaBb9pbYiizSw5CbQ2t3FM8miteWpOTZxmvWNqkZUJUNVCGnQyXCcVtf4Ga/yovuQfyLYvoYQ4h9VESvle3V0OLDLFgA2mpzuiuxDRI7+Z6ge1hKOy8pMpLDRrOigDGydeo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=W3mtM5bc; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W3mtM5bc"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 642FnLpm1593476;
	Sat, 2 May 2026 18:02:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=TgpZzWgWzTWDBOttd8ZB1n1ggbZ3m
	WYQsrxIIIBvuu0=; b=W3mtM5bcyOM8djN2omFTYcSIyVS9yrr7chc5+MrZhO74g
	an95m6fwgwLAIEhbc+GIfxm1IeTkIMesCkzlITce/VqGRb78gwbMDafTaL2ArumK
	IAEnbqMbZk/XrbGXe5ABsoDFoVyW7o1QofD2Jbvp3RpqQeb90i0YujvdvejnZUCd
	sj7zlxW45dVyNhIuxyWADLU1HhO+aNc/PZ/zq5jNunYEP7Zp2qRt0SriNEinZTEP
	ITZt49i/tJToTgxFHtUJOUxMT6Jp7jKxE+8hykna/D4AIIEtZ2GQcxznzZuHRM65
	/XqPPHf0n3zYpEfdP9aMKHKUTcxpN9CVCYOJBLBVw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dw9eprfck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 02 May 2026 18:02:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 642HuJ0Z012825;
	Sat, 2 May 2026 18:02:17 GMT
Received: from labops-common-sca-01.us.oracle.com (labops-common-sca-01.us.oracle.com [10.132.26.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4dw7qd0rcp-1;
	Sat, 02 May 2026 18:02:16 +0000 (GMT)
From: Dai Ngo <dai.ngo@oracle.com>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH 1/1] Subject: xfs: fix use of uninitialized imap in xfs_fs_map_blocks error path
Date: Sat,  2 May 2026 11:01:50 -0700
Message-ID: <20260502180201.27546-1-dai.ngo@oracle.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-02_04,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2605020179
X-Proofpoint-ORIG-GUID: OOPB3I96qqsY3ODTGbiIXy7Kkt6OIyfh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTAyMDE4MCBTYWx0ZWRfX29dNVzWBVoe7
 j1RuoLOLSJmkJoRIoD7piwUuRZHTKvOgUvmEhnHeNRJmGq7zWad62beRRionhzQZyzSlMfSg1d+
 IQMuoWtdU7bxxQOrENQgMkKK43FLxUa0jTHhCJSsyipNyztF24fQlIWyuIt/qmTNwoNknI1u1ge
 xGP4o7GjeQTtuEPHUY+qOBVc8kaLTdnfvXagBDuAsMZgmLngV0jfU1Ij0Pn7MOfwJSstzJVyzUb
 m8MSQsh8iXSTxxIJcVCqedI7bS2PXtmir4hs2BGjrpybxR75SlTgFrzQUMpZ/ggxik/JzQkoL0e
 V8t2iFtjLeOiw7Uk9sNR3+NgPQjNX6TDBcbUBKHbY6olFIFdaHhy/i+/w8e4Y/DaAJ6vS6ZTBss
 dQeeByIuWsAIZDwY+k5oXT3owBifxuXauO/K4fEwEYNt3emE9/EmTzn+dtljYW5a3H1ChU6q39b
 RTxL1EEi5BB4dOWMH3NQ7OCa9RV8LSS2pIRaAszc=
X-Authority-Analysis: v=2.4 cv=YKKvDxGx c=1 sm=1 tr=0 ts=69f63c2a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=NnFJWWH6Egn-NMX9bF4A:9 cc=ntf
 awl=host:12306
X-Proofpoint-GUID: OOPB3I96qqsY3ODTGbiIXy7Kkt6OIyfh

xfs_fs_map_blocks() acquires the data map lock and then calls
xfs_bmapi_read(). If xfs_bmapi_read() fails, the function currently
still falls through to xfs_bmbt_to_iomap(), which consumes an
uninitialized imap record and may return invalid data to the caller.

Fix this by releasing the data map lock and returning immediately when
xfs_bmapi_read() reports an error. This prevents xfs_bmbt_to_iomap()
from being called with an uninitialized xfs_bmbt_irec.

Fixes: 527851124d10f ("xfs: implement pNFS export operations")
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
---
 fs/xfs/xfs_pnfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 221e55887a2a..f7c6dba3d21e 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -174,6 +174,10 @@ xfs_fs_map_blocks(
 	lock_flags = xfs_ilock_data_map_shared(ip);
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
 				&imap, &nimaps, bmapi_flags);
+	if (error) {
+		xfs_iunlock(ip, lock_flags);
+		goto out_unlock;
+	}
 	seq = xfs_iomap_inode_sequence(ip, 0);
 
 	ASSERT(!nimaps || imap.br_startblock != DELAYSTARTBLOCK);
-- 
2.47.3

