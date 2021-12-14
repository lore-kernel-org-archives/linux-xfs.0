Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 602D4C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbhLNIrf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:47:35 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:16882 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231474AbhLNIrc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:47:32 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7snME004121;
        Tue, 14 Dec 2021 08:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=io43jYQbL0dxDK9ypfUfWHh0theCOs35MwoOTL/NBXI=;
 b=f9gpZ8dLrpaP23ETtCwjZBGJKkbWf2jLHNnw4N9JTCQlrzXphgPBiWy0xZopQSW3XRCU
 ZxwaEXak63Ml4NuKro3T8Nkmw+IiGXaz+iDFPDVRT2sJJm+EarS1hSx+jQk41f8XrnHO
 AvSVRaD4G4i2K4T87kO3ieVO53PIkGlOs0+Nqm214b/dal5Fa51MmDmaJdBovGymf/2b
 dSnFvv6qziqQf+xWUW/qXx+I8h2AsKBGaVmy/68utNszcxW2yAoEJ75lGu+Q7BiGIKd6
 Emp/L6wFSZzH/p/WC8/2hQKcwRYmy8zkbJIBmMIUcPCQQQ6REAqKQijI/x/eKe8LkqHZ fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3py338g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8foAU104439;
        Tue, 14 Dec 2021 08:47:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3030.oracle.com with ESMTP id 3cvj1djqps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QX/0Bz4HY9YwIsDYq01R/+4tEZ81Pq8JRkDz3p8qyEvLAhO+vT7pRR0dwY0hAQcI288QeK5f/gSj3Gd6BPBBq+eGeoIy6c2PKcMKy4Ea4oMGC9+04uddX3doEYTIwbTTIr6qoFQwax9TT3zs4sytjUZTeBKCt3oRTxjML+yUgauBKYD4VOXxWaYSXXOyRHz1dVFogJdmQ+RvefgEescsS0KjJxsuwh6nkVa7/t37J9kBx2Rzxkm1Q41lCzwfOLj4vVGjBVyghMX4LLg5S4FcSnD6C3IqXJh1GLMKxYDvJqXGA96IQDDHBSmowNTtBpCg9/1SICCIzLk8SdIkVZ1T/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=io43jYQbL0dxDK9ypfUfWHh0theCOs35MwoOTL/NBXI=;
 b=JE5B7EmupyljvXEThXOqRJ7Nf/fWFehp1cf/ZOZpPFU4h8Ftb+CtmOgP0dVNuJlCe47b9k85Npk24bE22avZeKhh+SRELB4WGrN2cA277bf7OjbtOZfcEY5scjRydaSzgxDsUdZCf3Nk4vwM30g9JpoBz+NQH8IRjrOPCmUmVK/yMJl1PLJBHWIQRxp+j4oV21v8l71CSwf0i4CuB7lmPd0RkO3Glwb4HGQe98Z3RacGzcI8sAzgd+ADlU9jeLk6SL4hVg2I+qV1F08EXrJ/0VW09yLbg1UPIeaHzPbHfsUYW8ZuO7BZVaq4bDthJhAb6Ib+Dn/HNtm30N+SJQolzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=io43jYQbL0dxDK9ypfUfWHh0theCOs35MwoOTL/NBXI=;
 b=v8Wcn9XXGxdR3LnzCtELM/Pa9HE7VPwoB7Qu2ROcpxXm7rwuQvBcNQ6aZSJZfo54sgo4Fd8JOfKis6nSAwPpuF8NaAUmnt72HWQRArO//hG3cGLB9OIo72c4vksYmzcKNc8QOeMBaGu8aWJbxdTNwzN9nMKiIvcDaZXj55TIySE=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3054.namprd10.prod.outlook.com (2603:10b6:805:d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 08:47:25 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:47:25 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 13/16] xfs: Conditionally upgrade existing inodes to use 64-bit extent counters
Date:   Tue, 14 Dec 2021 14:15:16 +0530
Message-Id: <20211214084519.759272-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084519.759272-1-chandan.babu@oracle.com>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0052.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::14) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f24b2d19-c3d5-41e2-e36c-08d9bede5a29
X-MS-TrafficTypeDiagnostic: SN6PR10MB3054:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB30540F7DFE83BE43B8AFC11BF6759@SN6PR10MB3054.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:47;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jiiMV8uGGLn3XKlGohP1TXDWuXB7XDug8En4R1ZpXs6xZZEj+l48X1rlwtnd+A1EtJ3OC/tt2Hs0DsUgJphzjIP4xdHaF76PVPCZn+CcmE4rtcvu9sxkujZEC1KpcQuqk8XJeuo9C/X9+E4cMNmM70QHZuHAf1h3/jNR0RT/8Yru0FSsJGxtj3Qkm7Laml6oovExJwZWj3RmApkPj5Lemh3tRvZrKAFhLFNlgBeJD0SrPJ7PI/UCXGm/Gp78peDtSyvFtbehJNjdXtnWluJDGwBWjUIs9qD5Z0zZPfx0JB9EPezuqHk15GaUNL5b9WNfhpUjIlxtTb++EqbjDH5srJU9ig2SaEeYryyFQzjon3jDIfn4XVD96ke36Re0l4uVoWTQu0sKwN6Kr6Kel8f4sLsjBxSb1eQWhzhJNGcZ0mhQQ+el9ldtV/Ky//EKdbTDk5DNtD2w9ABNHcSJpP5hfY3vngKCXA8PlKmwzhRPlv7yXq24T93k32mL7m5T5gxn0m1u8I+xTFxaqa12MgHcTDAo53i1p1V1Wl5GyttuItk7EbcC0VZVn/65kaDJWuD4tR/2l5Fh1q0kgyex2X/Hw1fQC+IEbFC9A6TsK2RGYh0N1RLXGlTuNu1sieM9EU51V40MDRvUjf57yrxEfHw0/072QsZcwoIcLgnRo/p3BSNWRr8Gw4lwvWrE+IEAtkMTpkPviyi7UkPHMHkD7YoHGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(66556008)(66476007)(6486002)(316002)(4744005)(6916009)(6512007)(186003)(5660300002)(2906002)(36756003)(83380400001)(26005)(66946007)(2616005)(6666004)(1076003)(4326008)(6506007)(508600001)(52116002)(38350700002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uPvGWX2Yt4FC8KOtPjGh7fgAtsiki6bh1rhaFV1iLDXmmviXgpZsEYp7H22I?=
 =?us-ascii?Q?PodvPrDM7J6XdmVQuHTzmJMv/I66b+IMIejaFIoFLhIu6y8BsS9k/oxiW1A5?=
 =?us-ascii?Q?r/0loFMmrNKM82BPkfRdWeDVtTLkfbiGWJBwBlLtXNglN8Pe8Rc84rXvnl2+?=
 =?us-ascii?Q?Y8rJl3e8gAgRV5CJZr81/SR0UWHC5uCVMPKjYrqLY881J53vAmS3MfDXrTSz?=
 =?us-ascii?Q?9S1zWHFIQbGCAaLXLTOc+6ZlE2kVuvct4PawqpF9p/WmBfQpi45atF32KtDP?=
 =?us-ascii?Q?OfG3lun64FbIopXHgV2NKqM2wokNBbvTqZ6V/onDcESyNCwwe9MTGkzNr8Kz?=
 =?us-ascii?Q?EBWbgQDUxJe0YrVM10HuEx6mBkjAetrKjJ14cVFm7nAZF8Yauas0x10poV/A?=
 =?us-ascii?Q?x0Rf4TPGfxIS8HibmAdr1E9Y4eG5LRqRBWhwZziNYBBERC64BuZpG1hnk8i2?=
 =?us-ascii?Q?jpeV+27KVRMTIaHRT3GKwABmcz+AujW4nbYnCo/u4SihkOShGGaSZSd1lyHa?=
 =?us-ascii?Q?NL1QE6MO7mDKbvKAqCJ6AbvhEJOmVldXiuh9uEhJRDZOoeYy2zih0CUnELDn?=
 =?us-ascii?Q?UZE95bO0NDlqnRbo1ug9qfQsvjR9bcZwnzFoavhKnIqUykdwqJ5iNYTO5MLy?=
 =?us-ascii?Q?fe8eYJ6ie2fLhCHFYUe3B3F11wqHwHq13c2bLq3yO2ItOfMWvR1bscHn+hPb?=
 =?us-ascii?Q?pEm5bYsGkPTAg1a2oBHFH4MldcuuOr65YTkMt5+7NLsYNd8jboYhJpPk7XjP?=
 =?us-ascii?Q?YkCoTbzSgTAzpu0pIlpX0MfytWfVBReD3lxIlWSVrGMRj/g6PNnjlzywHYph?=
 =?us-ascii?Q?1B/IzpgmbSyipI8woe4Bad0CiDm/d0LxyF5vTUW8viV5TSpicB+HCJUI0Ygx?=
 =?us-ascii?Q?jYhn/26Y7gdd/tQ9FYiaGP1MnJgrLsQWjXyfs7SoPQnXBy5yX8Z+9YdrtruA?=
 =?us-ascii?Q?mbsRq2DODtooHr+Aua1CInKnFS7Te0O6VBulX8AZuPDsmcB3RuEJ+iYzyygU?=
 =?us-ascii?Q?7EUqTHyQgGXNwUt7Epd1wqxkIHdYsg6FDDev7DTkQn93pIeM5aJ4T1dZkZRU?=
 =?us-ascii?Q?MtFEyyrNTWGjuCdEo+TBdheIfpTiVaamlb3z8jjtVF/hZ5N5XcivSRa+EuCE?=
 =?us-ascii?Q?EjC1wcWqvfVpdBVj7IByhc7NvVs01f6TdylmQ1jSsaHnp24uohEH9gPEZe9H?=
 =?us-ascii?Q?MkJ8kB9s/MdH5TGc9AKRDU/rjayUymptfr7AArgbKtS7SDzo23WI1NoEuaa4?=
 =?us-ascii?Q?yLIV23xxkqSTDrfTrFmfi3YkPQjUT3WDuWXdKRQ8QvIgbku6njLp1fVZ5Gjq?=
 =?us-ascii?Q?RyTVmsOhap01ES7UqXOSFfUBAyQmsWZcZsb0vc3Rf1wseqcBustjcAXH5Ji0?=
 =?us-ascii?Q?Mz2iSs1w27Yj+wWJO5p5ptXJF43wXFWbm1CRTdX69/WRIhwM00b70BI4qNK2?=
 =?us-ascii?Q?8/RX2VQC/JsGMSl+HnOSZtN8Oc56hEG9kDwz2da4g9cyQtPydraN6umPcjrk?=
 =?us-ascii?Q?eQVyMeizWrS3BLfNQ+t/2wKjx6K6lW2zKgq2FyyBROQi8zqE2fPZc93LEW4S?=
 =?us-ascii?Q?l/m3gZTfsxYNZS5NzJliDsCa/7wAzK/q/XksA3yEhEk2D+zfQ7zFYCdOOV87?=
 =?us-ascii?Q?2X5sOiI8WKFkvSw3ytgDKdk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f24b2d19-c3d5-41e2-e36c-08d9bede5a29
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:47:25.7931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZKPa5EjfDgi/4smh0NPBNlS5vL5bmuHpt2o+mgzcT7fh8ClhIYzgY+wQzcW+uOIpcXaxb0dc/cYDWVzZxVbhbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3054
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: JYCNyicpsIeMHnnld5CQaBTvCw-VDv2T
X-Proofpoint-GUID: JYCNyicpsIeMHnnld5CQaBTvCw-VDv2T
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit upgrades inodes to use 64-bit extent counters when they are read
from disk. Inodes are upgraded only when the filesystem instance has
XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag set.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index fe21e9808f80..b8e4e1f69989 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -253,6 +253,12 @@ xfs_inode_from_disk(
 	}
 	if (xfs_is_reflink_inode(ip))
 		xfs_ifork_init_cow(ip);
+
+	if ((from->di_version == 3) &&
+		xfs_has_nrext64(ip->i_mount) &&
+		!xfs_dinode_has_nrext64(from))
+		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+
 	return 0;
 
 out_destroy_data_fork:
-- 
2.30.2

