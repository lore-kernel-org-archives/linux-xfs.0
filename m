Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE12CDB47E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 01:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbjJLBI4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 21:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233886AbjJLBIz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 21:08:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D19DB8
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 18:08:53 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39BKTZkx031190
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 01:08:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=TtQPw+11p2JFrFKbKmlELCP//4LUfCv9bhABs7CFCuc=;
 b=EAmPWUcNyuAiPUwD+pAZJahCDrNKGEDmVbjUmy3RMAJB5M3dmEautI+uhjGA0jvb3bgk
 cYu6Y/b+5bfIk6yM4WVIFBKPV27aNubTI0bBYJRHMK3XEqxFUFR5xRlM4+8BNlSiljMg
 iy9SpvDlu8JD+LIQVW5tAOL2+3MSOu8GOwb35/i0+fNJdR5LxqiYIooMRb8pVqq5CxgH
 ZzP82BvOp4FSsyZpYZtYqNs0SnmXAak2zO9FuD7uL7IjWsCLWqjEfQlF9xZwZfI1dsB0
 kNAOrhXQ8+e3M5HVYVNRWRNy9KrmajnTSlqPteJYwN50Lb161iSq5JJxoMm74Yi7f9WO lw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tmh90xywa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 01:08:52 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39BMLYjG019513
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 01:08:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tjws9jt3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 01:08:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7WMzajI1vgKEk1RYeVxNlGprXPSY1kPSt2ABuJDO1jArdjdlgqp2niblTB60Bh2SQKdyK+/1pZzph0iy1dpP2qZFLWzXMqomYDlMZT2uC4oG62KsL1cRcIKGf8jnLIcstOQnMBYGlIFkFLcO6slFmHQfk7zOioehIPTh3dlpzzqt2c9atnmwO7RpR+2XVOLG3h2s8Usq0WDylv3mreEGMFMNoWkIgH2035C+0rD2/whMZTA4HWjvsFFsh4/wj3i41/z5+AkKqCsJ2aTFfrwk8yWHUpfbHgSz8DUX9m5aTDg1FCqHJHUXQ/Fed51CPFCO5AoplVOzKvH9lzqmuCIGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TtQPw+11p2JFrFKbKmlELCP//4LUfCv9bhABs7CFCuc=;
 b=Si4xvfzkangLjXTKp6VnWqJxR/SnexcUPbVM7FyBMuf0oqDKVaVPFAQFoaRuSAp/y6p2/086Bkkgc5+0bhdxAshbMgyudPzKQUqeIJ9QHkT69scGJuqQyo5IdycXNn06hyN7o7wqxy67lTYhiKwejn7LGNDq5fxd1f/WFrnDUpUof2f/SB2AGIUblkoGEx/Q3dDhZ2pSoT6mNQjtANTZcKEDAyuFS9oTH/Y/s/dmdPIrMDTq5ULZ1ZhMBM9qPschv2Etn1WZZ1Z99pLe80BiQEQhrCmO5gpYHphxVO9o9BLuXVn0eV748Kli5vH4FDr2P8XFU4tLknYI92ckENebJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TtQPw+11p2JFrFKbKmlELCP//4LUfCv9bhABs7CFCuc=;
 b=kX9SGzIaPOHjhDa75aC0WP7DUZG7zeVMB6nr7g175L6zlukAmrGm4hliWL6nnfI1kpjD75YMIh1DJ8C+eptIFO22664umUJgZU1ogAwpros0ypghIoUyokP/2MrVYbGAN9Gr77TjLDRy4GV1DK3/AvH1NMiXK5oZ9fAzQUDocsM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB5730.namprd10.prod.outlook.com (2603:10b6:510:148::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Thu, 12 Oct
 2023 01:08:47 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::9ee1:c4ac:fd61:60fe]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::9ee1:c4ac:fd61:60fe%3]) with mapi id 15.20.6863.043; Thu, 12 Oct 2023
 01:08:47 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3] xfs: allow read IO and FICLONE to run concurrently
Date:   Wed, 11 Oct 2023 18:08:45 -0700
Message-Id: <20231012010845.64286-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:a03:74::38) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB5730:EE_
X-MS-Office365-Filtering-Correlation-Id: 862178a4-8af4-47bb-20e2-08dbcabfc9b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WZ97LNrhljZ7co77spYuBDaowoJV/IuW+La+hObRJ2FYRby3/CwkdsrD7J1m114NVbg+DFCAO1FPxhegsJwoPD/rv+ohfZjB4LM7iB9+RzxBxDMThtss8VAE754kuGO92sUwOCGYqMaTawAKNA3R1JU17s+4oKgaFd9PhPY6KEyRsksUhnf4JBe0ujzuYy560NjqgphwLEAKQRfJEvW4jJDY2shYeveEgBWvHInRL1PTUW2xabVJ67/SsRP9tnBdhBAfbLo5KDL7k5/rd2e7KTKicDmVBUhvsc9op/xZAKZwLkD8XGOJpyvduSbjwCA5AaYWC55QW5nlOyOZPz+Heorjm7pxWiSZD5Keu2UTbTJ+GaMwZAvi+ri107fZlelrCw4xxrmLGkh2IAMZjXVr/oXsuHtW3CSi8HDq1BHheH6QpaHO15QX90tGBtcdMSfA+vlZMYPAPZZybg9AjIyymrLYcB4CeTaFFeM6VI4KBssfpWcYYfzkQeihw5lRC1AFtPIS3jLdAs9RZE2LUt2Nvj2t1fGU+uxcJ/+JaFrGtln5mzo9Nk5VPWc7p1gVm4aD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(136003)(376002)(396003)(366004)(230922051799003)(186009)(451199024)(64100799003)(1800799009)(5660300002)(8936002)(41300700001)(8676002)(44832011)(86362001)(2906002)(83380400001)(478600001)(36756003)(1076003)(6506007)(66476007)(6512007)(66556008)(38100700002)(66946007)(6916009)(2616005)(316002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TyyUQ6HRKERCwkl1UrQa/AwNSiTGFDHqJMRKEqqWD6BMQ7baOcoOin3TxkaJ?=
 =?us-ascii?Q?Zr5UFgDUsEj1Rm5Ba057yuSVNpfkWHaBMls1KWsdYWlyAy2TNRj0gVmsBm6V?=
 =?us-ascii?Q?A6zF9Ol+CEGFJ1zEUKZqjDYMXj1UAYzXWMg2pZ8ZUKY3ruKD2IomUzF1ZFsE?=
 =?us-ascii?Q?m7ybNF4gMKcx4uFp/4ZQ3LSD7SKJN/i+Nsp3F0CnwBjU9df50HW1fwtAbuiv?=
 =?us-ascii?Q?b3cDacmjT5U6uyNvb+yEn/D5j/hSlHZNLw7TOLml5bPI4rjyIIA19hKAs3lI?=
 =?us-ascii?Q?QB4HMUvMVBYvmt0Xqo79R/WRZopI69cPzBz7nklcOVUa6K7hviKUTsNf60NU?=
 =?us-ascii?Q?o/UmkowEsLQvf+S+/Ruoj8MfP5A90+uXf7QvbCV4zybDwd0fJqAwlfvXfENV?=
 =?us-ascii?Q?1hwi4kxUD4XQLlevqnkWZIMla4b3ISG/5s7UXEXmXBGkREX/cdR41Tv1Rm3s?=
 =?us-ascii?Q?QI5J5rEWSjNB8S6d9TNjnOdhhnNvAmnOnuPFgzp4j4zh2h7rDK+MPQ+p6keE?=
 =?us-ascii?Q?siKS15XwGs91s2uLSh31D2S0RjdvpyuYGR+7HkS+y+2YR3xHJXTAigOEEkUI?=
 =?us-ascii?Q?Gkvmh/gwus5EFjlZnPv+OMvTmlkb28q0FEZrBSqNd/ktRITSWD4wK+cPXMJA?=
 =?us-ascii?Q?MZHECQDw3ex+StW0Wpus3MyMt5WVUS9SZ4EcOTcWRGztcPlcpLrrYHlLTUno?=
 =?us-ascii?Q?y5ccF3ZbXACeVh5FmVaEI627EtCCNxC+lw15xnyNaqI16vLhNMIlOqj4H8CA?=
 =?us-ascii?Q?BDPa3ITeYWPxijoZQfLYlGWhYLjAD/8WmO6BnHnCyBJqA8Tt8Cgr2Nz8T8Jm?=
 =?us-ascii?Q?UVOEvgHyoAs8GMbYQuMlpYACk8y+YwTg6IDL5TshYRg+HyTkhK3DWQz72dLC?=
 =?us-ascii?Q?qLs11wxQxBfNMGjwo1HLhr1KGu6knlOwkab72v0gFrUR/rcnZ01J/HAq0Ho5?=
 =?us-ascii?Q?srudxhUpmQEn/xOvXCkqk2HKv4Nd73/BoziGM0wK35wyYW/PokskUEccut47?=
 =?us-ascii?Q?XQj7kXYT+/rbRqPf8rDkzch/xZg2K5P1maO4MEsgJR8pvUUzwGoEhpyh8mQk?=
 =?us-ascii?Q?ZOgIyalrdv93kndr8nu/wImpSn+M8t82MG7kIAcu3qqHHNMTvh/OXFQIfqZ0?=
 =?us-ascii?Q?Ggs6Lto4RWgpwGUeu/wHz97i3mtO7QsGE7UKBq/ogzNBmRoCAAjJpSbBNDbZ?=
 =?us-ascii?Q?CZJj7X4JMMQpKqzJqPKNKr7kaJZCcjk/os2XoV1fMJK5VER0w9pIsr49vHME?=
 =?us-ascii?Q?4e/rNzsj+agU7qxhFj63l6wgUrpLlL9+6nZ1bdJH3cMxY/TbVBO2Y3z851I9?=
 =?us-ascii?Q?rvZluCeancVVAOcngLLjQrrBWmifgOoygEi4UCKsTxuzJBeaI5Jt1cNKELTw?=
 =?us-ascii?Q?TE8OdpGtF3lZwkmN7JgKtJm4tnP0K8poD+50HVDGm0widhtrT3mn5uaqiIl3?=
 =?us-ascii?Q?qrwZ3bAhXDSrRjV1fv1qUDfta3wpGu/VKzNNiPRJXbmP3ARs9HYgrdIuIpZh?=
 =?us-ascii?Q?1BEFz7qI6lZ9I28e3TnsLt16hODNJUjrGxoEeIKSLCS6YvJ3vUZVbArwUcbn?=
 =?us-ascii?Q?TF2tWmOSuZP/LuAE6GHcX4MtFo2y7Y3aakr9f0Sboxba2aRROhy0mTOd084b?=
 =?us-ascii?Q?xeZrUBirixEPuiifsd9PJTwzYM46yxjzwI1hZ+IFVkfxI9Ly342NTzWHEsAl?=
 =?us-ascii?Q?u8r9sA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: j09KJhPE8xdOiyN7/rwAQhbM06YfWqQS4v5z4SbcU8a7yONfaCmzZ6aRC2KSEdUDeQTop8xjis1MFFbdRRI/BkLFrfu1CCE+UTX7BNU2QcGYxpuB7QpVjsyyix+xq6EYPcRhSKrr39k2BWyl4q490OzIqrXYpHVIX3x12a8wi6tvgLuNH9+WAPc3tb1YTo4dhKrgC2xqo/VcLDxw59Q6V/CZLQUV4Xtb+IvjBd/Mi3yZVJUFPoCFlPkk4bvL1v29lEisdF2Q0QC/V8I8uNhZfkePQhvw3jY5xrSMx8doeTX4IQrydhcf+Qb/XSdvfenGxC6RWP7DEl4pBdd+GjEbs6j/qnVgzBNFVW1Igvuh5aaxBiBWcZDEMYPDofmUTLxnmt3/4FrnrUhvz6ckfNvFkyKB8YrFA2U5cNlZ6Rg+YiY2enTxltLaDW63YGwYzqr5pIsen76PGsqIzCgPZkaw06GpwFlM1n/0RbseQlA+YbSt84wzBQXKIWodcEwGHHnlbNXAjzxjkk7fFJ7M5/1Y6ktYaM0GS2Imv713kacYdYVsE0S1FA55+8ucMWg2JCHXLmAlgJA1FP9U4RLfmJjmYcNOB6jfS7ksvyr7sPvb2zLs+eJpikESmxbIJQvQUpeC2AaT89i1xjCyi7dMiareNG5gALoCEhhueexIa+ZUcNdsdi1qIyqTO+H6So4G5sl3N+Rx81wRDDKwNLiZB1y8RurbzM1zvhKh3VyhzeKgDKuWhSt/fq4R6EItaojmiFnNuDjL03RQF5viZ+wlBOIJ0w==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 862178a4-8af4-47bb-20e2-08dbcabfc9b7
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2023 01:08:47.6404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9aXJZtmkruMjmsEVWXpKRAYx90sOEqYuL8/oPtiPF3mhntsfODgxK6+c93eusY0u5vmG5kpzqo31IHD0g5J05ANmDhQBAWKYDyuiUdXn7+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5730
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-11_19,2023-10-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310120009
X-Proofpoint-GUID: Ouj36Pl_2dUmW60Wt8fvfw8Re3EeKqRF
X-Proofpoint-ORIG-GUID: Ouj36Pl_2dUmW60Wt8fvfw8Re3EeKqRF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Clone operations and read IO do not change any data in the source file, so they
should be able to run concurrently. Demote the exclusive locks taken by FICLONE
to shared locks to allow reads while cloning. While a clone is in progress,
writes will take the IOLOCK_EXCL, so they block until the clone completes.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_file.c    | 68 +++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_inode.c   | 17 +++++++++++
 fs/xfs/xfs_inode.h   |  9 ++++++
 fs/xfs/xfs_reflink.c |  4 +++
 4 files changed, 85 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 203700278ddb..425507b0d1cb 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -214,6 +214,48 @@ xfs_ilock_iocb(
 	return 0;
 }
 
+static int
+xfs_ilock_iocb_for_write(
+	struct kiocb		*iocb,
+	unsigned int		*lock_mode)
+{
+	ssize_t			ret;
+	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
+
+	do {
+		ret = xfs_ilock_iocb(iocb, *lock_mode);
+		if (ret)
+			return ret;
+		if (*lock_mode == XFS_IOLOCK_EXCL)
+			return 0;
+		if (!xfs_iflags_test(ip, XFS_IREMAPPING))
+			return 0;
+		xfs_iunlock(ip, *lock_mode);
+		*lock_mode = XFS_IOLOCK_EXCL;
+	} while (1);
+	/* notreached */
+	return -EAGAIN;
+}
+
+static int
+xfs_ilock_for_write_fault(
+	struct xfs_inode	*ip)
+{
+	int			lock_mode = XFS_MMAPLOCK_SHARED;
+
+	do {
+		xfs_ilock(ip, lock_mode);
+		if (!xfs_iflags_test(ip, XFS_IREMAPPING))
+			return lock_mode;
+		if (lock_mode == XFS_MMAPLOCK_EXCL)
+			return lock_mode;
+		xfs_iunlock(ip, lock_mode);
+		lock_mode = XFS_MMAPLOCK_EXCL;
+	} while (1);
+	/* notreached */
+	return 0;
+}
+
 STATIC ssize_t
 xfs_file_dio_read(
 	struct kiocb		*iocb,
@@ -551,7 +593,7 @@ xfs_file_dio_write_aligned(
 	unsigned int		iolock = XFS_IOLOCK_SHARED;
 	ssize_t			ret;
 
-	ret = xfs_ilock_iocb(iocb, iolock);
+	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
 	if (ret)
 		return ret;
 	ret = xfs_file_write_checks(iocb, from, &iolock);
@@ -618,7 +660,7 @@ xfs_file_dio_write_unaligned(
 		flags = IOMAP_DIO_FORCE_WAIT;
 	}
 
-	ret = xfs_ilock_iocb(iocb, iolock);
+	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
 	if (ret)
 		return ret;
 
@@ -1180,7 +1222,7 @@ xfs_file_remap_range(
 	if (xfs_file_sync_writes(file_in) || xfs_file_sync_writes(file_out))
 		xfs_log_force_inode(dest);
 out_unlock:
-	xfs_iunlock2_io_mmap(src, dest);
+	xfs_iunlock2_remapping(src, dest);
 	if (ret)
 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
 	return remapped > 0 ? remapped : ret;
@@ -1328,6 +1370,7 @@ __xfs_filemap_fault(
 	struct inode		*inode = file_inode(vmf->vma->vm_file);
 	struct xfs_inode	*ip = XFS_I(inode);
 	vm_fault_t		ret;
+	int			lock_mode = 0;
 
 	trace_xfs_filemap_fault(ip, order, write_fault);
 
@@ -1336,25 +1379,24 @@ __xfs_filemap_fault(
 		file_update_time(vmf->vma->vm_file);
 	}
 
+	if (IS_DAX(inode) || write_fault)
+		lock_mode = xfs_ilock_for_write_fault(XFS_I(inode));
+
 	if (IS_DAX(inode)) {
 		pfn_t pfn;
 
-		xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 		ret = xfs_dax_fault(vmf, order, write_fault, &pfn);
 		if (ret & VM_FAULT_NEEDDSYNC)
 			ret = dax_finish_sync_fault(vmf, order, pfn);
-		xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+	} else if (write_fault) {
+		ret = iomap_page_mkwrite(vmf, &xfs_page_mkwrite_iomap_ops);
 	} else {
-		if (write_fault) {
-			xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-			ret = iomap_page_mkwrite(vmf,
-					&xfs_page_mkwrite_iomap_ops);
-			xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-		} else {
-			ret = filemap_fault(vmf);
-		}
+		ret = filemap_fault(vmf);
 	}
 
+	if (lock_mode)
+		xfs_iunlock(XFS_I(inode), lock_mode);
+
 	if (write_fault)
 		sb_end_pagefault(inode->i_sb);
 	return ret;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4d55f58d99b7..97b0078249fd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3621,6 +3621,23 @@ xfs_iunlock2_io_mmap(
 		inode_unlock(VFS_I(ip1));
 }
 
+/* Drop the MMAPLOCK and the IOLOCK after a remap completes. */
+void
+xfs_iunlock2_remapping(
+	struct xfs_inode	*ip1,
+	struct xfs_inode	*ip2)
+{
+	xfs_iflags_clear(ip1, XFS_IREMAPPING);
+
+	if (ip1 != ip2)
+		xfs_iunlock(ip1, XFS_MMAPLOCK_SHARED);
+	xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
+
+	if (ip1 != ip2)
+		inode_unlock_shared(VFS_I(ip1));
+	inode_unlock(VFS_I(ip2));
+}
+
 /*
  * Reload the incore inode list for this inode.  Caller should ensure that
  * the link count cannot change, either by taking ILOCK_SHARED or otherwise
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 0c5bdb91152e..3dc47937da5d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -347,6 +347,14 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 /* Quotacheck is running but inode has not been added to quota counts. */
 #define XFS_IQUOTAUNCHECKED	(1 << 14)
 
+/*
+ * Remap in progress. Callers that wish to update file data while
+ * holding a shared IOLOCK or MMAPLOCK must drop the lock and retake
+ * the lock in exclusive mode. Relocking the file will block until
+ * IREMAPPING is cleared.
+ */
+#define XFS_IREMAPPING		(1U << 15)
+
 /* All inode state flags related to inode reclaim. */
 #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
 				 XFS_IRECLAIM | \
@@ -595,6 +603,7 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_iunlock2_remapping(struct xfs_inode *ip1, struct xfs_inode *ip2);
 
 static inline bool
 xfs_inode_unlinked_incomplete(
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index eb9102453aff..658edee8381d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1540,6 +1540,10 @@ xfs_reflink_remap_prep(
 	if (ret)
 		goto out_unlock;
 
+	xfs_iflags_set(src, XFS_IREMAPPING);
+	if (inode_in != inode_out)
+		xfs_ilock_demote(src, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
+
 	return 0;
 out_unlock:
 	xfs_iunlock2_io_mmap(src, dest);
-- 
2.34.1

