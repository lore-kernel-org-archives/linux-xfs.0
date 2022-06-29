Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E2CC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 06:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiF2GIl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 02:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbiF2GIV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 02:08:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30429F1F
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 23:08:04 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25T4i1gP010031;
        Wed, 29 Jun 2022 06:08:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Ec4wIUIglhT5hGoCMZ0YNkPwb/FePlrZZjGwwp89WgM=;
 b=Bhot/s0f83NvY9qI9yhHzNtrLW5xSZ+VDBEkMhanr94Yt2xcRCaL2QgZwbxXNhen70t+
 kZlQJPr8KTYKBNHS1Ha+eR0uFw+OynSP+0Qiw4QojK+nQfm/nnPoiOp74ZKF9D8+I2qG
 p2LSCOYYaWwqyOTaqc0U2I5FMefySSoDoJ6du6ThwD4zrY5WeF1XuriUNdSCOVInyxHr
 LYgVDXCdzT6C8DM04DmPpa5Gz/715j0ls0GlocjjoaOG6nZCGdLZS4Cyw/SkVlfHD4Lq
 4MFYrZVdq30C80bBZbBuiKRHkfcNgCbCK0PBrPrslsOketzrXUTkV3V7ySBuAD+DmD/M og== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwry0g795-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jun 2022 06:08:00 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25T5urWf015108;
        Wed, 29 Jun 2022 06:07:59 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gwrt30c93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jun 2022 06:07:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+sDerFirMxD5QtBO5KzBMgzQUGsBwdMUVtJtm6FMoHAETQxlG6iwc+KmwoyOk4aTfqzi1WOD3nugK1WCgbhs/7Uz+qfhu6jn5l9uW5bEOeCnL+PXerRq02Hcti1TXoQPF3K0KjZqwi//bFQmlmGPKHSpo4m/QCG7UTStTj1L8OW9ov0IXCPHfghNWWk9Jc4hNCiVsR5pnv4FInxRedckLa60SVMTAU0kAh8LhSOz8TKA0NqYljNv1zuZA0WTWGaAOY0GMt4tH51w5ZfNuGSqHuiGj6EpLuaC0+0JHYlvfSvqEFwik6Ceq7KfBePGaBINJUHZNMzq9TEfM6CwF2hpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ec4wIUIglhT5hGoCMZ0YNkPwb/FePlrZZjGwwp89WgM=;
 b=aRuGbzQ0yvqFxx5yeT/apxgeIRcsyJLf9flxhO6lIrUKw+s4FtsdYbm2Ott/OnongZJcBJgvcesK/5MoFzcnX+sV3UB+f36zijNcyfRAto+H6D4pFHfn7ACyVZ1ovbZQ2uB5xbp9BD8Swh4Cdr/VMFBNzpuqtZgeyJq6e3OHV1BRCOBtAXRnEt3yJTS0i1/MmcL3ReQoFSLhRYvCn8ZiS3vvtlg03/Ij0KWUwPzPGOb9vXSAgOHbS/2Q0iCcs9bBhgsrRGilHcDYlS5KJY1UtZZaor+ifUIOCuWPoTj+FXUPQNX9e6/MyUE+kPB8v2uIfkwY9DoSXSkxPUpO3oBGcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ec4wIUIglhT5hGoCMZ0YNkPwb/FePlrZZjGwwp89WgM=;
 b=UTj1ORavfRz4Xq+5LPjnfuBxr2npVH9rSXEv0sQZxYiurSFVsk8pPxMTtER3VWdMkKeDG2ULzZixTYm/dJnxIJj0Mt4Q5HhpK+T/G579u6djeh5Gp8EJv3ZX4iddZpSa/LoTIYynX2r8LYkn6f/v0Xsf5CMD3riLtpvr6uCb4GY=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by SJ1PR10MB5979.namprd10.prod.outlook.com (2603:10b6:a03:45e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Wed, 29 Jun
 2022 06:07:57 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::44a5:e947:8149:235f]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::44a5:e947:8149:235f%5]) with mapi id 15.20.5373.018; Wed, 29 Jun 2022
 06:07:57 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     linux-xfs@vger.kernel.org, djwong@kernel.org, david@fromorbit.com
Cc:     wen.gang.wang@oracle.com
Subject: [PATCH V2] xfs: make src file readable during reflink
Date:   Tue, 28 Jun 2022 23:07:55 -0700
Message-Id: <20220629060755.25537-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0034.namprd11.prod.outlook.com
 (2603:10b6:5:190::47) To SN6PR10MB2701.namprd10.prod.outlook.com
 (2603:10b6:805:45::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 354257db-ab1a-4b17-06d4-08da5995b659
X-MS-TrafficTypeDiagnostic: SJ1PR10MB5979:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O4S+XP0OKdN7Yv94oeuACo7GdPwcbIzR/Ipeo2lauZGg6z4sr8hDGAc5MnJ3l3cU6+Ke3u+4oIHkjmNpnjz5gucWlEoyi/y/ceoBcMFYS+s1bOXjxGM91+gbfP5+jQji2r6uGWnvl9L+kKwET/7jdOO10RPyHYln7jnywCuyFahN4YNBhrA+n1RFeGdraIdb+HQRRW6qIHJW/QzYGGoDF6hmZpuKRN1tJhNoBZ97rOsiEJTuB8D96ac7KqgQmD7GAeiThWsW7ULQ6I0xuEziGwaQc0ygn20abiSNWgohDU/drFwkjk/6Xae4dQoAFkyQCeFIVbDuitMIrAMMOpRERt9u+jn9BxtgataOS0yPv9XGTqIBSZLD3/MBFRqCVEfWuqFUnpPGKXfvlvswbTOV6NZWAdSvO1GFDRKTUPbR5I3zPSuw624GcaCoHRvocffXbZq1w7iE/h1byNgRNprXj0Zu0QPIHZ90kAGu+30pWG+Y3JMq8MsTs+lwdAIwST23TuFEqyUFiiVBzWSPbhDsWptBAOADXf62Gd8ygFruCEhZfYgS6zomtr/F7nH1rHkoq07j9u432n6rFEd0A8NDagh1nPUR2Z3zNgButvNA+erGK9T0wcgO1gzWmfFrkFh3NDgfxo7mZF8zpNOH3Cs+eWZu4GR7uG302RBzlVP7sKxDHLcrARVmXI7MXtIzuLd/ZMWUcwyti3gZOXNnQqB4XdL07CmV9r16PFFCQQ1nUJ6PZX7k7D3copy1o9kDp9fS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(376002)(346002)(396003)(366004)(6486002)(36756003)(2616005)(41300700001)(103116003)(6506007)(2906002)(478600001)(86362001)(66556008)(6512007)(66946007)(186003)(4326008)(83380400001)(66476007)(107886003)(5660300002)(1076003)(8676002)(8936002)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N3hf/OhSKBl1VLo72VanMznQy1UK+w0hkVE8RkV+j7sNCvpNPDH/giExZRZe?=
 =?us-ascii?Q?6O/IbiIRDBLeJuOxwwjr7D5NIdGZH4ICqN68FDRV9KfzbU30pEHOsIo2sDDi?=
 =?us-ascii?Q?pJKFMEXLqyPW36Hy5PEekwbDXPQPibw16OejVEyVRZEDUiBzRwWxwLq9qJop?=
 =?us-ascii?Q?zKvbwjWulkUic2ZOTDuuRaV7FQzN12UHGLz58HOKJK0OrZYVwD4Xnx8L5nbq?=
 =?us-ascii?Q?X3plqOYkZXwbRbHJ+PkTbPjwol90ipLd0Bj/NJP5R7Xo6HEOx+qIvEmMz1qJ?=
 =?us-ascii?Q?9bwuLIgEE8YFkg2kjB5xZDX1FwGhRgrO5KgvMNk3guKIlTm4mB0FQE3jpM/b?=
 =?us-ascii?Q?Je/Kwe5LO8hA9aRHx7hPeP2Rb9MwT07AbMITayCt9pPX7N+qfch7y2PQIIgk?=
 =?us-ascii?Q?aLQVrjiSAcc8dvVq2wtOCb4Mh7ZomQHDUP3IzNCfZ9QOYsGRLuEWD3BAeSmE?=
 =?us-ascii?Q?OP8SAKo5z4dYN7AKyRij33MleTDmDysp8xR6uHFCnZgti1NY5PBcy04FU35w?=
 =?us-ascii?Q?IcgtPBfytr5TtTxupDUcsVu1qQ6NmoMr1qngBZG0trzJYBvFpo/IaoO6GwmU?=
 =?us-ascii?Q?vwtUkuoercmjUlz8jTVSh6fwIeDuCI3ZFyTr0jneMeoUbZPUA1KLmbFAHf1e?=
 =?us-ascii?Q?IHibvy+m24NwuDGPtA1NlEzeSBHWYXQfUaCRPFQtX+FXeZe9v4ZkKAeZ9r7b?=
 =?us-ascii?Q?B1giZmt2ixcExJpI/5sxJ9ChJ8jACN/MF3+7F2MfKGkZrUniorjI6pQo04kw?=
 =?us-ascii?Q?0cACgMrCaK9LsC6/6BJVT7+oXIE6Vk8QFJ9DgOAQi88+2FfXXKpi1FbxVeB6?=
 =?us-ascii?Q?2UnITSVPEfBKSvxx4TBp4NzBs/G0j85uCt5UmughhLrvF3r2YwjmB1rKC6K1?=
 =?us-ascii?Q?J2tavvpQ9edU6xlwXQZoTq9+zRJDPcUXUcKtOOAG6W16lK+bZCP/7Fm95u5R?=
 =?us-ascii?Q?4C/X1gqN8sx0W3+U8/OwFoe+I4o+yX4OK6cbQ0FXhtZdZTsJfrpP/djRZFrR?=
 =?us-ascii?Q?E0HSnjRydGXjB15yokST8pnJZ7ovXgQSPEcsUDCjOeLWfNW5BPW5DLP47BFF?=
 =?us-ascii?Q?uHI42w3f9Snhhj8JHPgk21B5Iy1xUBp0CVXtbmjeyE8gTd24DEtqfc1eUiAz?=
 =?us-ascii?Q?NkowrxVteUkbuKB2iboo9VbFZeW8H9kK/FOXwP9iKfSDMbWAKnui3ucAMusN?=
 =?us-ascii?Q?k5WC35vcb1QTTLCX3F2ANeIEWaiVX32H4YenjW6QZ7omIUFAGPacv7sHwnFa?=
 =?us-ascii?Q?6OD59SfQx49PGFFKHMtOucqRkmNUCVsmtck1W+HgeVeoLzRZqJfzYIVDndmW?=
 =?us-ascii?Q?6aQkcazE5nQBcEjPkX2RbmlCNTITy4SXNkgym7cEF7Gtcm1jRZKMvDJ7q0TO?=
 =?us-ascii?Q?5gENzaJyz5IA77x0NMZK4Qk5lR0QxZJx5DL7ZmtWfOGaXNI1o+3sSsdYsm5p?=
 =?us-ascii?Q?3Zp8qM48CvNWb0xL4/moYorWPiHQywYh5T7y8szZKHgIpAbH5bHTFF312Han?=
 =?us-ascii?Q?azTi4D0+5SL4J0A79q7A9hQdmSSQ7C5zm79mwV+cr4PvIJglr1dzVr1FSnC3?=
 =?us-ascii?Q?u/RMHKMcb1XJif58Q4WBB9TRjg2oBHmbLgXnGkOc7LHRV1Py4WhM6LXfEq4d?=
 =?us-ascii?Q?0Z1BT14L2Z6aQFLTJT85X1o=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 354257db-ab1a-4b17-06d4-08da5995b659
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 06:07:57.3758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XFcwhAHTC8Bd6ecx2eMnrjnj+uz1Wn61u+fADENwdvVRrjwm4y5VCQH0NUXDjvLw8U+wLHM4ZyvszjAHMvlJDfT/N31eNHGxtRJ5/vKqxx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5979
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-28_11:2022-06-28,2022-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206290021
X-Proofpoint-GUID: AZrASBxgPB8tq6vs7Be-rAwhymVRifjp
X-Proofpoint-ORIG-GUID: AZrASBxgPB8tq6vs7Be-rAwhymVRifjp
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

During a reflink operation, the IOLOCK and MMAPLOCK of the source file
are held in exclusive mode for the duration. This prevents reads on the
source file, which could be a very long time if the source file has
millions of extents.

As the source of copy, besides some necessary modification (say dirty page
flushing), it plays readonly role. Locking source file exclusively through
out the full reflink copy is unreasonable.

This patch downgrades exclusive locks on source file to shared modes after
page cache flushing and before cloning the extents. To avoid source file
change after lock downgradation, direct write paths take IOLOCK_EXCL on
seeing reflink copy happening to the files.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
V2 changes:
 Commit message
 Make direct write paths take IOLOCK_EXCL when reflink copy is happening
 Tiny changes
---
 fs/xfs/xfs_file.c  | 33 ++++++++++++++++++++++++++++++---
 fs/xfs/xfs_inode.c | 31 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h | 11 +++++++++++
 3 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5a171c0b244b..6ca7118ee274 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -514,8 +514,10 @@ xfs_file_dio_write_aligned(
 	struct iov_iter		*from)
 {
 	unsigned int		iolock = XFS_IOLOCK_SHARED;
+	int			remapping;
 	ssize_t			ret;
 
+relock:
 	ret = xfs_ilock_iocb(iocb, iolock);
 	if (ret)
 		return ret;
@@ -523,14 +525,25 @@ xfs_file_dio_write_aligned(
 	if (ret)
 		goto out_unlock;
 
+	remapping = xfs_iflags_test(ip, XFS_IREMAPPING);
+
 	/*
 	 * We don't need to hold the IOLOCK exclusively across the IO, so demote
 	 * the iolock back to shared if we had to take the exclusive lock in
 	 * xfs_file_write_checks() for other reasons.
+	 * But take IOLOCK_EXCL when reflink copy is going on
 	 */
 	if (iolock == XFS_IOLOCK_EXCL) {
-		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
-		iolock = XFS_IOLOCK_SHARED;
+		if (!remapping) {
+			xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
+			iolock = XFS_IOLOCK_SHARED;
+		}
+	} else { /* iolock == XFS_ILOCK_SHARED */
+		if (remapping) {
+			xfs_iunlock(ip, iolock);
+			iolock = XFS_IOLOCK_EXCL;
+			goto relock;
+		}
 	}
 	trace_xfs_file_direct_write(iocb, from);
 	ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
@@ -1125,6 +1138,19 @@ xfs_file_remap_range(
 	if (ret || len == 0)
 		return ret;
 
+	/*
+	 * Set XFS_IREMAPPING flag to source file before we downgrade
+	 * the locks, so that all direct writes know they have to take
+	 * IOLOCK_EXCL.
+	 */
+	xfs_iflags_set(src, XFS_IREMAPPING);
+
+	/*
+	 * From now on, we read only from src, so downgrade locks to allow
+	 * read operations go.
+	 */
+	xfs_ilock_io_mmap_downgrade_src(src, dest);
+
 	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
 
 	ret = xfs_reflink_remap_blocks(src, pos_in, dest, pos_out, len,
@@ -1152,7 +1178,8 @@ xfs_file_remap_range(
 	if (xfs_file_sync_writes(file_in) || xfs_file_sync_writes(file_out))
 		xfs_log_force_inode(dest);
 out_unlock:
-	xfs_iunlock2_io_mmap(src, dest);
+	xfs_iflags_clear(src, XFS_IREMAPPING);
+	xfs_iunlock2_io_mmap_src_shared(src, dest);
 	if (ret)
 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
 	return remapped > 0 ? remapped : ret;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 52d6f2c7d58b..1cbd4a594f28 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3786,6 +3786,16 @@ xfs_ilock2_io_mmap(
 	return 0;
 }
 
+/* Downgrade the locks on src file if src and dest are not the same one. */
+void
+xfs_ilock_io_mmap_downgrade_src(
+	struct xfs_inode	*src,
+	struct xfs_inode	*dest)
+{
+	if (src != dest)
+		xfs_ilock_demote(src, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
+}
+
 /* Unlock both inodes to allow IO and mmap activity. */
 void
 xfs_iunlock2_io_mmap(
@@ -3798,3 +3808,24 @@ xfs_iunlock2_io_mmap(
 	if (ip1 != ip2)
 		inode_unlock(VFS_I(ip1));
 }
+
+/*
+ * Unlock the exclusive locks on dest file.
+ * Also unlock the shared locks on src if src and dest are not the same one
+ */
+void
+xfs_iunlock2_io_mmap_src_shared(
+	struct xfs_inode	*src,
+	struct xfs_inode	*dest)
+{
+	struct inode	*src_inode = VFS_I(src);
+	struct inode	*dest_inode = VFS_I(dest);
+
+	inode_unlock(dest_inode);
+	filemap_invalidate_unlock(dest_inode->i_mapping);
+	if (src == dest)
+		return;
+
+	inode_unlock_shared(src_inode);
+	filemap_invalidate_unlock_shared(src_inode->i_mapping);
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 7be6f8e705ab..c07d4b42cf9d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -262,6 +262,13 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
  */
 #define XFS_INACTIVATING	(1 << 13)
 
+/*
+ * A flag indicating reflink copy / remapping is happening to the file as
+ * source. When set, all direct IOs should take IOLOCK_EXCL to avoid
+ * interphering the remapping.
+ */
+#define XFS_IREMAPPING		(1 << 14)
+
 /* All inode state flags related to inode reclaim. */
 #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
 				 XFS_IRECLAIM | \
@@ -512,5 +519,9 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_ilock_io_mmap_downgrade_src(struct xfs_inode *src,
+					struct xfs_inode *dest);
+void xfs_iunlock2_io_mmap_src_shared(struct xfs_inode *src,
+					struct xfs_inode *dest);
 
 #endif	/* __XFS_INODE_H__ */
-- 
2.21.0 (Apple Git-122.2)

