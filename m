Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0969617D896
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 18:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717180162; cv=none; b=OTKWx5V4UtW/0lX1lirTjsBr9M7u+4M0MwXdB3tDACYsVumNczevGdmZa89YH/QED1scAbxk+NJ1fXuI4av2rxm/yP8FVREDWYJT5ADwQ7/qbTVo1D61nqYRq4WC1p+7sZ/0i13u/sBRxsX+aiwZk6Lx/7RCfjV5nhCr9L6FR8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717180162; c=relaxed/simple;
	bh=OD7x1a1pClPBlb9JthEZCBKUmrx8B6ca1zcqBEUaY8w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fNHShPjnilgZsPitAl07C328WSpaQH18+0GGAx2UAXHJ4rXFiHwKrGdkEiOMegvUbRTGQnwBNEtUROU8nCNOxL2u/7q4d8nqiglF1zBeQCfrtWudJozfz04uVHPdpBapc3yLc/gDD7HDt29DbvfvtuSYqBew/mYBkPCGm0VmgR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44VIKpNj030154
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 18:29:20 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:date:from:message-id:mime-versi?=
 =?UTF-8?Q?on:subject:to;_s=3Dcorp-2023-11-20;_bh=3Do+ozMfSH4AIqVv6jVsg0x1?=
 =?UTF-8?Q?7JWcvYG1ETt9hom1aOwaA=3D;_b=3DnGy3Vg1x2Jl6xwpP4SUN4nutJHsJS/SVh?=
 =?UTF-8?Q?oa2fmPTvl3kngoWgv959fVn/12b1S8ZWp+R_JJuwxeR+YaN6cLKIIJnzy3oxxrO?=
 =?UTF-8?Q?rPkIRkdljILDr7vdoULn1Ci90KzfUWrxxkaLuY7Fc_kJl+qkE3KYR9oPK8geMql?=
 =?UTF-8?Q?NHERpu6mCqC+W5cCuuqjzfS8Q6gzefD8k++cSQgXUaW+fq8_lIYfnDMKKgYQUvL?=
 =?UTF-8?Q?mzVP1tSgX/IMgOC9Ye4TeKGTO7o7TOB9KpVllcZBjU2B0idbhDBeB_nCu22m1QN?=
 =?UTF-8?Q?vMZlyWYx95HVl1kGj6ibl1GQJBQArRAynDiQ+/M1CkXO3U8MfSiZnY+S6sv_aw?=
 =?UTF-8?Q?=3D=3D_?=
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8hgbsvr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 18:29:20 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44VI1Ghw016201
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 18:29:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yc50u6y08-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 18:29:19 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44VIRICW037949
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 18:29:19 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-254-32.vpn.oracle.com [10.159.254.32])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3yc50u6xyx-1;
	Fri, 31 May 2024 18:29:18 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH V2] xfs: make sure sb_fdblocks is non-negative
Date: Fri, 31 May 2024 11:29:18 -0700
Message-Id: <20240531182918.5933-1-wen.gang.wang@oracle.com>
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
 definitions=2024-05-31_12,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405310141
X-Proofpoint-GUID: YlZZXgdcmCt_F7l5AKQFw-2QTIWVkLN5
X-Proofpoint-ORIG-GUID: YlZZXgdcmCt_F7l5AKQFw-2QTIWVkLN5

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
---
V1 -> V2: add problem symptoms in patch description.
---
 fs/xfs/libxfs/xfs_sb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 09e4bf949bf8..6dc0731e82e8 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1042,7 +1042,7 @@ xfs_log_sb(
 		mp->m_sb.sb_ifree = min_t(uint64_t,
 				percpu_counter_sum(&mp->m_ifree),
 				mp->m_sb.sb_icount);
-		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+		mp->m_sb.sb_fdblocks = percpu_counter_sum_positive(&mp->m_fdblocks);
 	}
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
-- 
2.39.3 (Apple Git-146)

