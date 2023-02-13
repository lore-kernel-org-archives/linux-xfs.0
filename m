Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24040C636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjBMEG6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:06:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjBMEG5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:06:57 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75FCEC57
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:06:55 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1jPoS012953;
        Mon, 13 Feb 2023 04:06:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5C5Rq9D/7tTl+aWG8NM87agwDJKLIoHB/hXmF749SqM=;
 b=qHcOSalPsxDKrb6N2uSSHRH0HQF08mAVSyooNJaJECMVDz5W8qqcegAIp7ztnl6GOAA4
 SVCxHYcBdJctRwQagrE7mr7GR9fT0hUgOzUJHaCH2SkBvoswyzDyIIwMBOldn12dUczh
 B7ERD0NQWQAaCQPq42Urfe8/lsQ+bpfLyKF5O3hlpBgt/H9Xv9SG0uy5vyjWVl5eoMHR
 LUbQgpaVxqtNvIO5Ui2rPbuhZ4XGPH/4oBFbC8VDRB8N+p/9YBDa1zb3W02Wx2K2FL7I
 NmP1LSoMkyWHSqld+rlTPmJKDAkW7Gn2px8B2CnqeBKErGNj6rgY6kk3jpdnxDA+OSQt FQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1t39v43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:06:52 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D3q6xY028785;
        Mon, 13 Feb 2023 04:06:52 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3jy6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:06:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IgMBTxlcGuDQzParWDJnFo5HBb4yB2luEIsVAxdFc+jkk/9SHEMdcHdN9IH4K8A7CmqfVA4DjcaqyaBXPJqJSHzKTnPWZzY2Psa3X9p0EjoQ3hL3RV4P4TnMY/MLbOzac/MfglYiRdMcRWz/GwbtReGZiWs1SsXeKn+F+OYtoSC8P0MiRvYHZRU+Dm9EnvzijqkBD5Pu6aHwf4QlMtNdkOindUvVbUOCY+i0lEyYAziF1TO/bp+1pTifIoCPDCrZbXSx8gp5l29lwNiMcUgcFbd70nH66qg5wow3a8+nd7p/eNiuYSkPw8l5VdozxzLxLGx2mGycB0gV1UdIcc1avQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5C5Rq9D/7tTl+aWG8NM87agwDJKLIoHB/hXmF749SqM=;
 b=FtqcapXdN7MIvt7Xro2SI2TcarbIFmwBiS1Rjg+8XUDsL9fR1TxISIMohA1a3U6J16dHBJTa34rMW14eKPe8Kmap325tAwNSx08Z4B/lmuw2/tIXlte/OVQmlHmUSlyelEHQ1M5rhJno8vEMSzv5bAUqHTejIm3TXrMiVCB21W+7PJ3s7ioAoVnfHqDjBvMpSiqIZsPids9ln9u5vVtZezB0gGrBUe8a+Sra7/cQT8SblwZJYx1AYpnpsJz8ZyOQBbJuaSEUaXny3H6z9ktW6qDj9/BNH57JMD10jZ4q4jW08BUmd9ET98HSxEo/ATph0nXzRMbv3aN/S84xmxDFSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5C5Rq9D/7tTl+aWG8NM87agwDJKLIoHB/hXmF749SqM=;
 b=qIdt7xNP2S3QtWkki7y67iqGmrJedokTxBZV31YhiyMTDG++E8W0mnem67X/H7dRyQcI8ZkOvLfscZWBeiBQX4mrd0EITmwbjVi50XKf/vDKkNml6fmFcFJCEhakI9LQalzrHfy2vWB87a3DumJ1yAl82iWZRTMRonu541QxH1c=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB5225.namprd10.prod.outlook.com (2603:10b6:610:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Mon, 13 Feb
 2023 04:06:49 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:06:49 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 15/25] xfs: clean up xfs_bui_item_recover iget/trans_alloc/ilock ordering
Date:   Mon, 13 Feb 2023 09:34:35 +0530
Message-Id: <20230213040445.192946-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0053.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::7) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: d8ea5014-b632-4586-3631-08db0d77bb05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BPqx3lcpKcxf58EB4BH6wzxD41XqRa1WVHVO5WjOTS5rZZPi6DLbup51vCCQzGifkkZ1HwzDmrxWHwx8O7agNlorZOm9if4iyK9ZzHgtYMixKPoOfrPmJWpGUyfcDLg53yC4MtDl6sVhmTB46f0FH1CiDyJlMZyWp2y+HgvUuD3xCHFD4D6zdr8j+TYN32XAD0cuIQMubBEQDC3SuN6LhN6CN2+4jXelUfOqx+ImsUDwW+zW5zWikKPhwIZ4kGop6D6fPqV4HCPZYS1tXxvs/vJJrU1GTlenC1O0j+sFGUHiFruJ4CQ5wvn16CDikLmiJm0Ilv0fFvQbNMd8IwTgAcMo8stD6GTSREJUPX/9sFRg0xlpvIeZV6nbssuH5ekBL8p4nVl4sZ+8YUAh2tQKJbHR2vOOhyKdZ1DG/VO7CkzbbcKmd2PKC/lwjYnoqBm38bXR/8AXpfMXFj3GXRZQEgmMMAXB3uHhrNNmydWZsqppf4srPX5LlLD4RtsQx/7FgTZsnwqlAULTR3jrxzQiZRdSVeoFxmWG81emZFmM7Demad3suRcA7gM2aJpzTc/skWPRGEc90q4BvbR67CnGj4Vo6c9xySBUybBLsnPf2AyDhbiiBWdQhDk6pPmXhHJUcq0gwPi7fLb56PDS0CCtXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(2906002)(8936002)(36756003)(5660300002)(86362001)(2616005)(83380400001)(6916009)(4326008)(316002)(38100700002)(66556008)(66946007)(66476007)(41300700001)(8676002)(6486002)(478600001)(6666004)(6512007)(1076003)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F8K9v/qzHXsO4dGZiU9HvMnJUGrKpX2B9te8LTlvXJg75H49wE4iorPjXIgW?=
 =?us-ascii?Q?zEiSbpTNSsPQ0FCl0uISgzhmuLmfnz2FWbj5k4tLVConns0X8oITPcQmT976?=
 =?us-ascii?Q?5+pGFmrS9B/5fXWjtiMlAffyHFeYx7yYRnXH5RFbfIzUPkZktHT365oXZgKv?=
 =?us-ascii?Q?NYIUzfnRcIR2svUGMYq/qt81P11Z441HbiHOb4uQl08KMU33tAJJVhnq+kRY?=
 =?us-ascii?Q?mTLdiJKc5g3+cs1iQOi1WsT+k/bXK/JGw/3GCVnUMoLKXtiu99SQ1pkY5ezL?=
 =?us-ascii?Q?kzFqRxDOko0yvdRx6OERHjPrJEL+zJ1CL+J6hnXl6SaLs0r9o3pvO+I3S/hA?=
 =?us-ascii?Q?s9uACjjRtRNDRyBLGevlTvQfu8AOFvrlHmXyapKBe/micMTC/ZU8MeVokmFP?=
 =?us-ascii?Q?JvTpd8OXUYG5sd3QtA0aZlvaNYVpxRpPCc7wqKNxSuCz1ydPf5MYAAkAIjFD?=
 =?us-ascii?Q?RyIn3zzbk4ldzIvTACog3QTLUKkHhx7CH546vML36iBWooWofV7jXavuIyAY?=
 =?us-ascii?Q?yNZNnu4xw3JTf6r/4L7eIEVXENx08r8jmWZvnZW268X29b6T+cwRUmgvpIxC?=
 =?us-ascii?Q?BDm4Vrt+wz1a+M0Z4RPns3H0ULPxnke1Y7F8g9mCU8Loctr/aGP7EZvTXrMK?=
 =?us-ascii?Q?a4rVU6IbaIf2kBhPPEdbD7vCsrxQ13eK5wZqjsltwVREtpafhbuUgBVmMIjc?=
 =?us-ascii?Q?DRgxVt242QDLhBHNLN+kaORcIOIz7+foqF4QgPdlCWXeb9bP2aMNJv/zv+Ap?=
 =?us-ascii?Q?2zzqdjPsCh2H2yzG0l8EXm+YLeCogmfvoUxmyY0xmXTePAzoBpxbJdL+r2AQ?=
 =?us-ascii?Q?uCj1YH74qtQnsfv4lI4oXTXCsGtOzs07HzYI41TDy8g5vSz1yxv1PKnG0xei?=
 =?us-ascii?Q?1SWxmuUHJAykvqJUBqcCRgtNwggvlknzAqfXQ/VsBeZFSqCuvE3kp7A++wHB?=
 =?us-ascii?Q?XXwdBscEQDjceLfa595W3ScrLE9V5+RrgCHG9D/cB6Xi3qwocQIWf70JPq4q?=
 =?us-ascii?Q?LmhFtHTC4fL5qd2FLoMRdbfp0G9zZ/2KJ/7R8b+dDLwdttLxDG32SWyUCKmR?=
 =?us-ascii?Q?nMsOS6vMntEiGdJaVewuLyXmROX89HCRBkqvv0bo4r463X9tHxu8wUgBkSJx?=
 =?us-ascii?Q?J6Tt5bB48vs/O1BTS7FhyakHzjRGsDqoSgX+3KPFnb/xOAHk3bh4MdaPisUJ?=
 =?us-ascii?Q?vbqwzoGVtmJ9z6WCki7Yl9RNNhNriF9NYTqdFbgmqGfH9fc0Bu205UqF/4S4?=
 =?us-ascii?Q?9xtIuWyYo9Ho3EcSmWYVQvWQ0VTWvETRAAWSE5qhrLNh/ML9s9Pca4WhtpKF?=
 =?us-ascii?Q?Jk0rm11S82hnkXM7vRWqP7kPj8Kq7i/9ICtXH0WXf0MTma9AjLugeHwT84Tk?=
 =?us-ascii?Q?jxhQ12yWQdFkPlySqIB15x95IEuv2Ilct5UsVvfb9+vS4sfl8Y43YjKTYys5?=
 =?us-ascii?Q?16Y8vSqBtO6HBGCPBy5sidJelqX9XbuoXQnl1mXBdCuoJv5eY7tQcz+1GDfh?=
 =?us-ascii?Q?xjkvUeaD/z2osPgBpoLZHUXwQ6XEaDLqgzyc/9berJfLxh0DD03b3nVFUyga?=
 =?us-ascii?Q?UpfEeQSFsfZ0pKXiJbcntb4/zuzztWyIsi3e/5dDFpldubN57Q8FY4ewnrok?=
 =?us-ascii?Q?FQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: E+FKuj3IFfuEKTYnOGzhnCWVd//+2oxE96kE2WsCyqHuaUqmqtTl1/gBeZBcSbVn0th/aNlta8IKGUSYFtfJ9ocpw2y0iwLILqBwq8Sg4ukT8fQLXnZDiI8L2+nzY45i5WxIhthZXf7EifiKD5iukkKHfdy7MHsykHLK0pLHx8ErUBplghbLL4AgbK4jHM5r0gCGQqpZrE/Jc8HCofBMHi5JDtk7AtIDsMmmmopIgs1jMNvgEGzM9SD1oXgJIdg+Fz02g6a344u5MQbbrKkxqi9f93Y02tsn3P1BzDzuzI0nXkU2vL7VPSdB7u0O3qtVnjMkOID0Z4iZ/mco3f8xdcOnybTcthhpSz5O5+sNxQYRHPplO5ipgPBXbY3AlFn6TAlGHAZ7cyrNHPnuVYLPBGHKPqV4PoMXa+RYFNiV/lRwsnOnigsr0gb/n1GiAE8V9EMJj3Q0HWIkaoYTbbE773zZZPvECz+2KL2KbKBVqeJ2ZTb5gSGC69hzDL3Goor2t21cKeA5CetfvDRRDBBJN9iwSTcvBF774fK1vFJXUjwZc1sNEglpz2DEB765030XdjGISt0hTzhHTyr5xr+cJDpFWELjU58TCibO1ICBy1qyuEQr+NZYbBikxCvkkm0jPcAoEwqRIlz5CJDelbCrLRZkawTAMRt0iwJI23mz7xksXIPPuj6DFgGE/8wuhbpjUnv1fbBLpJNb/S1zoACc5L3rpuIRDgq8AajM9vI9QQqC89XJpBxAqOGKMnntyoudte5dxNMXNrS1L+fcTILKByIQ/4D+9YOpXGYIXezn70YH6M6dojeeoWksCsFhQQHE
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8ea5014-b632-4586-3631-08db0d77bb05
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:06:49.5975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xLLjeK/q1x9vTq7nyefcCCa07fvrd9qKuntXJV9+c6VA3JLQRF9avqU987pckOViGhtjVeSDgbFWGqGRwlNl6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_12,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302130036
X-Proofpoint-GUID: CJy2I0aKmcSawWyTYUr4CegnGcHR7HB1
X-Proofpoint-ORIG-GUID: CJy2I0aKmcSawWyTYUr4CegnGcHR7HB1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 64a3f3315bc60f710a0a25c1798ac0ea58c6fa1f upstream.

In most places in XFS, we have a specific order in which we gather
resources: grab the inode, allocate a transaction, then lock the inode.
xfs_bui_item_recover doesn't do it in that order, so fix it to be more
consistent.  This also makes the error bailout code a bit less weird.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_bmap_item.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 381dd4f078b0..f7015eabfdc9 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -22,6 +22,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_error.h"
+#include "xfs_quota.h"
 
 kmem_zone_t	*xfs_bui_zone;
 kmem_zone_t	*xfs_bud_zone;
@@ -488,21 +489,26 @@ xfs_bui_recover(
 		return -EFSCORRUPTED;
 	}
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
-			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
+	/* Grab the inode. */
+	error = xfs_iget(mp, NULL, bmap->me_owner, 0, 0, &ip);
 	if (error)
 		return error;
 
-	budp = xfs_trans_get_bud(tp, buip);
-
-	/* Grab the inode. */
-	error = xfs_iget(mp, tp, bmap->me_owner, 0, XFS_ILOCK_EXCL, &ip);
+	error = xfs_qm_dqattach(ip);
 	if (error)
-		goto err_inode;
+		goto err_rele;
 
 	if (VFS_I(ip)->i_nlink == 0)
 		xfs_iflags_set(ip, XFS_IRECOVERY);
 
+	/* Allocate transaction and do the work. */
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
+	if (error)
+		goto err_rele;
+
+	budp = xfs_trans_get_bud(tp, buip);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
 	count = bmap->me_len;
@@ -510,7 +516,7 @@ xfs_bui_recover(
 			whichfork, bmap->me_startoff, bmap->me_startblock,
 			&count, state);
 	if (error)
-		goto err_inode;
+		goto err_cancel;
 
 	if (count > 0) {
 		ASSERT(bui_type == XFS_BMAP_UNMAP);
@@ -522,16 +528,20 @@ xfs_bui_recover(
 	}
 
 	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
+	/* Commit transaction, which frees the transaction. */
 	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
+	if (error)
+		goto err_unlock;
+
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
-	return error;
+	return 0;
 
-err_inode:
+err_cancel:
 	xfs_trans_cancel(tp);
-	if (ip) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		xfs_irele(ip);
-	}
+err_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+err_rele:
+	xfs_irele(ip);
 	return error;
 }
-- 
2.35.1

