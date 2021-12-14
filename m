Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25619C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbhLNIrT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:47:19 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:8906 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230007AbhLNIrT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:47:19 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE748BR021570;
        Tue, 14 Dec 2021 08:47:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=AkjMJqdXY8NQDzFN3yMR8HPGoQLk0h3Bp1mLNMfq9JU=;
 b=BlZBrE8dANASX1zP75waFsRnPf7WMa6OAWc15mWbtmHYIAdYmEr0iXNBg0kXMX++rQuZ
 lFqCsgORcbGquz2I7gCrCrZsT0IURcQGrRnTBx9IaJMRAiriHhaKXDh3sGtXxQgQkG4K
 0VFzErXm6m+WIAoaeYxrTsh1iGpLpvchcINW0C2TFW/EEo4wpPRjxxoilRdVMPwU866Z
 nom4kadavcWB5X6l7/rTvytbQx4iW2Ydgrmc++iTjnULhmINSCWaQKimEQ/5kTGWMuzU
 ULz6CV7t6Og/nKaI21HiRpECjGMfV3nDkteu9feSkOTGTw+NP1Y9hGJIKpOHHHdJkVe5 7w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3ukb2sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8f5MD107713;
        Tue, 14 Dec 2021 08:47:15 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3020.oracle.com with ESMTP id 3cvnepm066-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZedjB/Ij+t+CBBLXrnbBM4V2NfgB6T3KeLKfwgfNuRCklb7haiw5Q6nI8wLPfvxna3ObhwIpITDDm3v5XiKfv4gElNbQugTilIJVWc766/hv/PV40wbiq1F01QzEdp4Ht4ngo9qq5W64SJj6sw3bCEuTsFWD2y0awm81p75gB2JqXphPKVSoqL60xHrOG0X5KjqDyZ3Ybun22LMzw7XY0agEmUcENcNNY18MSYfTG+pAPBsxl8VoTUFswJRa52XOv+Q1/x//4nTA4XBieD8a4TutaAqUCbfzpBuMleO5DzboK2NvDVG4KHr44zbc+3cIHEqlNK5lATfaGYEsydNrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AkjMJqdXY8NQDzFN3yMR8HPGoQLk0h3Bp1mLNMfq9JU=;
 b=LFG49jW9Nfs1Cebasqgohz8QTVqZfj5e+MSo6K/aovTQn59A3KUF+2V/+C6uQGzSreFD49fgOqHh72/DJQDU/GHdCtD2jtHfizsQQ+VHrKhN9owE04ZIppagJvYV5o1beQaln/eyryH6ux3jpbRPBF+EC1Cka2F74uuJymtMoncxA5uj3i7+wySucuDvUcSskXO8NEeDoYx6/RWL1YJUJSuw8kpqqEwHO+WP7yGJoUtJg1hPlxbb+6z6K/hHjQXbK5Hg6/LcocUWZwTS22EpIzv1ECiSa4jVfftZX7tj4lIJ7yefCyiu6odx/2SDUxH2PC2hL8CwUoXDlfENhHaDyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AkjMJqdXY8NQDzFN3yMR8HPGoQLk0h3Bp1mLNMfq9JU=;
 b=fj7UHXowAO63DdCGz7QGi+X53nBglvRFNdA1UJW+yEN9oC/nw0dB7uITjIDwmXXH2kn1unx+NlFsnHY5Q90Yc0pWFaMFzBulIjPZWgUCs7oJHeLvCBPMWfhzt/sN48m0BNkooKxh3lvwcPqBJJYiAzKIcGARI3PCd6zz5UzX02Y=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3054.namprd10.prod.outlook.com (2603:10b6:805:d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 08:47:14 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:47:14 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 08/16] xfs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
Date:   Tue, 14 Dec 2021 14:15:11 +0530
Message-Id: <20211214084519.759272-9-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2f682772-20dc-4bf6-8814-08d9bede5329
X-MS-TrafficTypeDiagnostic: SN6PR10MB3054:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB3054AA20DAEE3C06936C3CA8F6759@SN6PR10MB3054.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rxOKSIeerGmsG0QcS3nMWt9DSstBB/KpBbCGuHQj4Jr8kEyCzCGk2u+B9g9Z1c5oCo2Y37bcvmW5xwcDWKaldcEALIwbfqjovGq00PVUqcHd6u9FrdsUZkAVuAFT8AwgfbAaSAgqh7ZkzsypLEQMSk4ZXSEG9QkcjYp/OgKbRyetwFx5m7pO7o7IzWTuSStfSptl6Xxa+X3cq2dpSSLDsV5CbkAz21SHRgeY6KKHDK7el5Q02Aeg4ctdrN4alL9AZAJMG3OWVsqZIeu1R2A4N/lBE0gt1PERvQX4h49a+R+zqbrnJ+AOuZNNnXGf/kkmWC5ko3D1+dPETawq/85/uZ2LhTqhmFRENjAeU1Cuu71chC245tJKkhVRqkvQFOv1gUcPt/XWtbMHChyZX/2P0sqsA9y8bFDlP1owRab6W+L1pQ1k+7l2XFMn4pt/FvQ3xknkY8etkbW14pfvxXQxCLGUdS7Xzgf4iC7y3JkKyaS6VNEF7+d4dMDeaABIVqbZ9zFeGTWycHFXt+r9TeIY/lfA0OkqaNIE6oYCGZFFDGVxnJDxv+ZxrZ/U5uWq24kEYSqo6u+asq9bpVw4gJJk/1hmYMLWM+ct7lBnJ02lpafsnLBGJiuwi06Oee+UCC8dL0vqd/v2COVZ+7EGrbef4OzbaYup+ZL5Koj8vkafREUUpZOo3tUjpATOWsC4HmsXyOX7iUtqYPkqjyl6rJzowA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(66556008)(66476007)(6486002)(316002)(6916009)(6512007)(186003)(5660300002)(2906002)(36756003)(83380400001)(26005)(66946007)(2616005)(6666004)(1076003)(4326008)(6506007)(508600001)(52116002)(38350700002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hei/1ajCNlEA1lgSwmbq7H6/j9Xm00VlxeqqUx3XQ3SlDqMRPJe7P0izwpAN?=
 =?us-ascii?Q?3bJqZ522EGrI5+XmBzxpr9D+UPJeqSkNyonHxOzTBpI4WXMyC49shGypJaER?=
 =?us-ascii?Q?yl9UZcp+KPUAwgUvRAXLjL4IAF1G9POxhf8jij/tMmRAeqekJfcDotf42hYw?=
 =?us-ascii?Q?bi4SBOD6qg0G/QrKF7VmfdxmiJ1jJqT0nk6qaqLJGjb9U3Og+nFPZ+P68Ouz?=
 =?us-ascii?Q?yBxqxfjVhaVMLn4OPG4/TIcGjLalxO5uEbgqBeJjI76E4lHSpeRNNNuee0Lx?=
 =?us-ascii?Q?noqHEPWFP4+Ach0oNH/OT3DOtYnsq59dkqabT+w8uYVYExFDuxagcI6MAMrz?=
 =?us-ascii?Q?2uy1ngxN3Q6enecDFlwoce5YuKi/qhaAwCRzVnUauFlhweS4zolt2gTQqN7d?=
 =?us-ascii?Q?roz+IcSiU+PF9wh5gK0krMbkGO6a3AnDfBT/5poSlkTTf18+yPGtYommMczk?=
 =?us-ascii?Q?R/5OQXmJYXQeCec6xQVz03vaAkC9DdxuE1o58RhElKDTxwoJ402x7MIN2q6a?=
 =?us-ascii?Q?sbQCyf9ULG6mr5NpbZtPHjJu3UYf05Au2268Vvz7q4eKw3yCQrV/U1CSv7sO?=
 =?us-ascii?Q?ZqQ8e60RDL9/l1PYEj/6S6Xmc3HbFoCcKMwUh6pMQeo15vMr5Q430jf31t6K?=
 =?us-ascii?Q?OkZoZuIq5Wq9Oz/fMahHy+xErEIIIeVYwUp7jR9LsAmNR9AKR+ttm4cGfKM9?=
 =?us-ascii?Q?MRySazuN7JBOmlaIl1sL6vnoNd0D6dNh5V561An+mQkIsR4oP1zTF8dWol+M?=
 =?us-ascii?Q?+O5kEqVvQ70/KaSWRvX98m09hv0CgXgWBO07j2k0Q7+Y2bswKvhoef4iz0vz?=
 =?us-ascii?Q?U6vpCevnQW702ruB7VpCkn8/YZ13yGVoeOcOKAWI3AbhzxpYTaglvYosEg3T?=
 =?us-ascii?Q?KOu3J4LEtnvaJZCSPw6HccegHBdJVh0OvYY+6BN/W7w/4ZhAHG0jHz+vIwYn?=
 =?us-ascii?Q?g2a6/hrI0DqHkJ3NOLKj7846rg6x5jP6TIF7vsf3/eFwL/XRdAO7nzOcJbtB?=
 =?us-ascii?Q?PlMOxfUzlmvg6nMl/N0YOuwOO9ksWSeEQR91tWxrLmPu5KZYwVrU4PnNfmIW?=
 =?us-ascii?Q?aZ0UgA8SzoTWCzxtmnTvqXmmFYKnHw22RBrq5OPzyYLSewhOoJUWEJfjsi0n?=
 =?us-ascii?Q?MSFtZn4OO7u4ZVnFSZy4Y1B8WwdBmY6VKBsUIyOTIGm1IDqFq8nMgOmADfkj?=
 =?us-ascii?Q?qj6tuZHn1C2xfyMMpojJOg7ocOHfX3n6dSbB6VZVEJRRdJGtjOk5l/u4KzwP?=
 =?us-ascii?Q?tTYRjPhjobv7nb+/nJfB7JkfJ4dppf2UKXcKaEZtTuoln3V5w6ZnfGCV2CT4?=
 =?us-ascii?Q?DqpUKvqGFw3F4jBt6qrVb9AdKu8C69I3cGpT0elSsLHoPF/HUk0+ysH5aeAX?=
 =?us-ascii?Q?A7i62iBhcS3TY1/ckfwO6RoeT8Zz8X6dlHFH+Ez+1M9HHrYNQQ+KRX7fa2H5?=
 =?us-ascii?Q?IfDKEAz5oz88CZXKBxI1sh3wg+h0BQJU//YY5B9KU7+lNZShMc6Tu6Mg5rc4?=
 =?us-ascii?Q?3NXonAjiy+6Ty3daTBTEUeGseDZ4GzePT0aVD9W+6DZEL9LEvidGWNRPIC24?=
 =?us-ascii?Q?MKCq0vsb4dhwACKqS3Ff7prV3TIuafDK63psbHWn5joFVbnd3LlmvrgCN3c8?=
 =?us-ascii?Q?TtgQTwyE3CzEkgPmW1D3Fg4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f682772-20dc-4bf6-8814-08d9bede5329
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:47:14.0308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /KuReTc2YONPyuP6CV8N4Q3IViRzUXTgIim+9f2H1RK/PBrRgpg1i9VwovkUK8MIjeDfMLJ9+Ikk94hx1vBljA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3054
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140049
X-Proofpoint-GUID: 6ZkHY1ysoouBcy-7SDTbTqIex_bpRpyp
X-Proofpoint-ORIG-GUID: 6ZkHY1ysoouBcy-7SDTbTqIex_bpRpyp
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_FSOP_GEOM_FLAGS_NREXT64 indicates that the current filesystem instance
supports 64-bit per-inode extent counters.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h | 1 +
 fs/xfs/libxfs/xfs_sb.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index c43877c8a279..42bc39501d81 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -251,6 +251,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
+#define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* 64-bit extent counter */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index bd632389ae92..0c1add39177f 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1138,6 +1138,8 @@ xfs_fs_geometry(
 	} else {
 		geo->logsectsize = BBSIZE;
 	}
+	if (xfs_has_nrext64(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.30.2

