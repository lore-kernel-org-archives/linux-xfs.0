Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DBE137914
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717439423; cv=none; b=RsDMUXzr48jYIF/cUckVjxrAU5xOQbv/iYyjblPZi6NcIgrTJZVXwlwX+1WshjrkAknR/3kd4H7Hh/xuoAzOd6Uu7R43J4J3wNBcggeA+kj+zSDGfm5XX10LMjUEJYdtxJVcZQJu52eWvo7lAtGgyrUIFplu5rHD/uulS7TFA14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717439423; c=relaxed/simple;
	bh=r6+KWqB8eu2Z6c1TRnngRt8A7uT8LDu0V8Eo7hTPas0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tg7WW4AaSVcNYpfuCN5z0gtH2Yrb2KukoH019tmmlb3B4FWXs7i3pCst4VjaRnHow/ILdElUSLFfJEYgehKw0oi5tMY8w13E0t7m6bFds7zQIcGT3eZROlWjiRATPprwqUBnOSd7C2LyPljjOsUusi9Dj1mqOHLCteeCIblC1T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 453CLmJc015068;
	Mon, 3 Jun 2024 18:30:14 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:date:from:message-id:mime-versi?=
 =?UTF-8?Q?on:subject:to;_s=3Dcorp-2023-11-20;_bh=3D/YqXd6HlO8/ezivAurh4vu?=
 =?UTF-8?Q?qaFdsvMqiyyI4tPkSlkY8=3D;_b=3DeRLz0wBjk5oqKTqzwlM7whINZs19QE/nk?=
 =?UTF-8?Q?5mzq9+q32cAKSjcQjg3AzryqENvcRG3aoOV_EVFn56zAiKp5zHRdO/KaYYTplTK?=
 =?UTF-8?Q?9xqCEa8CrCkeCVh8MiR9kxzSu6SDV1bxediL5du9N_/lA7TK4HIzl84tFDZC3XU?=
 =?UTF-8?Q?eB7NqIF97tLwnemXfisb5JCATSAqsuFlxAuZsauuWmV7HdO_2TsnWNtSBfmoJhG?=
 =?UTF-8?Q?ey8FTRcBlNj1Nb37gzoJJdBhHL68zcS6cj1SJFYE1fP2jZqTFMZz7_0jJKGx0qh?=
 =?UTF-8?Q?i4H11bp5Ed7/glMsF/xO4BDEC2jyop2llBxNacgCATz60mB1fR0j59A0ujv_5w?=
 =?UTF-8?Q?=3D=3D_?=
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yfv05bg37-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Jun 2024 18:30:13 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 453Gvh7n005560;
	Mon, 3 Jun 2024 18:30:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrmcj950-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Jun 2024 18:30:12 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 453IUBPa003087;
	Mon, 3 Jun 2024 18:30:12 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-65-131-74.vpn.oracle.com [10.65.131.74])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3ygrmcj93v-1;
	Mon, 03 Jun 2024 18:30:11 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com, djwong@kernel.org, hch@lst.de
Subject: [PATCH V3] xfs: make sure sb_fdblocks is non-negative
Date: Mon,  3 Jun 2024 11:30:11 -0700
Message-Id: <20240603183011.2690-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-03_15,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406030151
X-Proofpoint-GUID: ld4fr4BGdRoabyYSJ_Ws0UVzP0N-UpY3
X-Proofpoint-ORIG-GUID: ld4fr4BGdRoabyYSJ_Ws0UVzP0N-UpY3

A user with a completely full filesystem experienced an unexpected
shutdown when the filesystem tried to write the superblock during
runtime.
kernel shows the following dmesg:

[    8.176281] XFS (dm-4): Metadata corruption detected at xfs_sb_write_verify+0x60/0x120 [xfs], xfs_sb block 0x0
[    8.177417] XFS (dm-4): Unmount and run xfs_repair
[    8.178016] XFS (dm-4): First 128 bytes of corrupted metadata buffer:
[    8.178703] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 01 90 00 00  XFSB............
[    8.179487] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    8.180312] 00000020: cf 12 dc 89 ca 26 45 29 92 e6 e3 8d 3b b8 a2 c3  .....&E)....;...
[    8.181150] 00000030: 00 00 00 00 01 00 00 06 00 00 00 00 00 00 00 80  ................
[    8.182003] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[    8.182004] 00000050: 00 00 00 01 00 64 00 00 00 00 00 04 00 00 00 00  .....d..........
[    8.182004] 00000060: 00 00 64 00 b4 a5 02 00 02 00 00 08 00 00 00 00  ..d.............
[    8.182005] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 17 00 00 19  ................
[    8.182008] XFS (dm-4): Corruption of in-memory data detected.  Shutting down filesystem
[    8.182010] XFS (dm-4): Please unmount the filesystem and rectify the problem(s)

When xfs_log_sb writes super block to disk, b_fdblocks is fetched from
m_fdblocks without any lock. As m_fdblocks can experience a positive -> negative
 -> positive changing when the FS reaches fullness (see xfs_mod_fdblocks)
So there is a chance that sb_fdblocks is negative, and because sb_fdblocks is
type of unsigned long long, it reads super big. And sb_fdblocks being bigger
than sb_dblocks is a problem during log recovery, xfs_validate_sb_write()
complains.

Fix:
As sb_fdblocks will be re-calculated during mount when lazysbcount is enabled,
We just need to make xfs_validate_sb_write() happy -- make sure sb_fdblocks is
not nenative.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
V2 -> V3: break the line to ensure it isn't overly long
V1 -> V2: add problem symptoms in patch description.
---
 fs/xfs/libxfs/xfs_sb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 09e4bf949bf8..252bfa9a9fdb 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1042,7 +1042,8 @@ xfs_log_sb(
 		mp->m_sb.sb_ifree = min_t(uint64_t,
 				percpu_counter_sum(&mp->m_ifree),
 				mp->m_sb.sb_icount);
-		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+		mp->m_sb.sb_fdblocks =
+				percpu_counter_sum_positive(&mp->m_fdblocks);
 	}
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
-- 
2.39.3 (Apple Git-146)

