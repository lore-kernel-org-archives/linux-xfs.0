Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0522EC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF40D60EB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236277AbhIPKJD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:09:03 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:36214 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236292AbhIPKIy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:08:54 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xuwN010995;
        Thu, 16 Sep 2021 10:07:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=EihPbkpwW+kbmp/nrI3TMraqsouvNVoXNICnBjjJKFE=;
 b=QyU4kpSSPiYVFQNTh5E6nWc+LDehdKwQJ2bWgKkPbs/OZE+7/71oS5gz1rr9WDeOwZCU
 3iClUUXLEwmWCgWedK1Mx7mYagb0dmHOg5Mj8w+ZHRTjhpLGAce1XoWxhTEd/76HHmFF
 ETfmY75HV6GoyNq1TV53cN7VkJSzliB4m1CjFlD+kRPZEmyHywL+9gbJ/Yhcv+V3yGZ/
 bSGfwH7x+omb2t/kbjKplymgfM2tST+Tdbtzt4k8GqULZXz5hflEl2s9o0BL4Sq5Nijt
 m/dgTMCcNTZsQlz7sqYnkrT2qsQvvsMJ3rqSrhiDNaBIkLyZVeWJFvv/LNFMtDBsO33M bg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=EihPbkpwW+kbmp/nrI3TMraqsouvNVoXNICnBjjJKFE=;
 b=aKuHHda4Q3ZmBpjfA2xHLP2rcLy9FmXG86kT9j6iV+mh1QrFihKm38U7PwuHut8DKLiP
 cDh1oh8I1Hu6Abp9ZcM4wk2FFC/PWJwyh4tYJe5q38cNmJki+a8R17AGoPBT2aYocVY6
 OCzaCJMrluw7q7DcfRXtvA6qUnN5AMPBHWexjWObULJiYZfTQgYvrQTZataikJLqW0iZ
 HPatGzhh3+vXNSkFhG+3tI091BMkFJ+6BH0gY+JcaDX3vxI7ofWMFPUAG/r574uNvavr
 bmZT+LUr/46rCq6g9Q8yHmhsvGfYbj87efxTCOYQumje9R2HlhgHvy7EWtI6TI+pAIOD 1g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3jysjva4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA5hju171537;
        Thu, 16 Sep 2021 10:07:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by userp3020.oracle.com with ESMTP id 3b167uxnqc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NiZ6HACudUcmVoEj38z0qkPj0AoxpiBnTL1YWjCYXY+COW4ZtkMndOi3qjDx+mSUNw3kDTQdt5I2Hl/Qv5KFOI6g+i+9pkX1OyK0D3mGRf8KdFCoSI9sp71wkHMkBAQvuAJ/++w+dw6JF6ChWVh8aOru2inBAwETUTui7gDixALBKBuy1tMRC1Cj2zAKw0hyxqI0lF/3yIO31j5RcBFmKnbZotgU9lmGzm3YEJl0/K7hGCmvEXntJ5ryUcNjGbUMlw9qpoWFZ9CuuHTcCHiD1fPBPU9ZKlWmFP+E6YMDXlRnrQqZXDArg56aXJudkqpo9vAB66rnNBSQEL2ZxUvSsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=EihPbkpwW+kbmp/nrI3TMraqsouvNVoXNICnBjjJKFE=;
 b=Wkma2H36+sjd4cso/PrvNuiTza4NxhI+CEn9bEbR6p6XYPQVmQI6F2mm+6DV5cY1shMAylcPPSScfc1NPuCSy2l1vO7aTaF9FUzR0CAtTxYo0e/Cp0hvwkikMoqNmOmQGnJCWT5Sk/I2atdtjKfeNWmQIMXJzxS6oHAY+PIHQowMWoLbJJqA0ZaaP6sSD8UGHNnGqSyaZiG6E+Y74z0js6vJnaj/B6wf7R3Wr7ozo47vOuljKro2LKQFvA6FfSNGTX/H9v1eqbpdFc5esYFsJoja/JH9JTAkAJ9sX4950MIXacsEACD/xAJecrqd69aWCQ46KQqyA6BPQIQcw7ScSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EihPbkpwW+kbmp/nrI3TMraqsouvNVoXNICnBjjJKFE=;
 b=fIVJMi8jiI3xhBk4nsPTg9K2gozMVYYwHyjhcQ8+5wuIXduFIyq62ianfjhYQFI1Su3JUCe6SFdZvss1ogZ4X3q5hXA+M/QOOdp45M9yQZuwuoANhyR4A6Hlx4vNPTAi1h7rjopgNH7HbYPdZc4qkIpTRRNQMXjD+MEV8Ht5z5Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2878.namprd10.prod.outlook.com (2603:10b6:805:d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 16 Sep
 2021 10:07:29 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:07:29 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 07/12] xfs: Rename inode's extent counter fields based on their width
Date:   Thu, 16 Sep 2021 15:36:42 +0530
Message-Id: <20210916100647.176018-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100647.176018-1-chandan.babu@oracle.com>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::11) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:07:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 048bcf88-30da-4e5d-d053-08d978f9ca86
X-MS-TrafficTypeDiagnostic: SN6PR10MB2878:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB28786628E8459E64EC459941F6DC9@SN6PR10MB2878.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:376;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V+oZDC37G2nHBQSoOi4AZDz2+B3G20opBZyNRc8ST+OBayZAysABpEzSa7r4Bsv3aTB5iwBH+0Rd2jH7R1eWGMduUbUjtzPURZGKKNxibSGNXGesbeiLl222V4/h3NiuX0yBReH303lV1KgXB2nMWoVvq2qRKPL1tGkn00cbX9XMw5Bg+C33+stT3YKadF8deBET2EySsDzPZrB+faL0ZamPjj0V+v+1SA+XkNw6o0UQgOHJoSQOHz+wBJ3R4h8MNmSIHqxB4N15e7YZwHUgNuN/kRFG4h5n7CLB+MYkjqRZura+YnVioremgulmTS+luOOZAxSVlSIdLCqzbB33yIjOM2lInSeDiQvIklaHynEfsCxxF8umQEtfacCrHc3jcxy8p5PkpKLbNyh7VT0fsd6w7hL5elV48YN8at9RtSua0fr4ItwkXgtnVv8SlJwkSf+dQkm0mS/7Zb1dT6wJ4CoQSMunA5lXX4TmW8aJyzv4xp5+QmFeptYDZ05JPFpJL03HklgZDIzmc8mPH86aUhQHkOk15ggCAlBMQiL7bBUU6O4A4PvRQPCrvrcsEo6qKjTXxeIuXn5CelkA7SQIrzJv8Y3CspT14G9iAeKjlLbDG5cp9dKcxrW8b6dpFdCHU0KSicO6/1+j/fLqK/teBP8O8isiRrwiGotKKemX7YFLZWFYQtkZeSiJAPCqREhAGQmwathqYbOVEu90NKFHqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(478600001)(5660300002)(186003)(66946007)(86362001)(66476007)(66556008)(38100700002)(2616005)(83380400001)(6512007)(8676002)(956004)(4326008)(26005)(6916009)(52116002)(38350700002)(6666004)(6506007)(1076003)(36756003)(8936002)(6486002)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Lc0n6iKOHZpW6wai3NrSAsoGkD5JVbQ1si2fL0LA+exe2qtp4zwnOBMqHy1?=
 =?us-ascii?Q?oxRhoqSb1MQeLi2g12rl/KEt1ayFbqF4gf/hyu4v8vay4+D+4RsPeZdMGvqk?=
 =?us-ascii?Q?yRCO9Oz4rSwHYqDZEliOoVtKPtDF5XoDTQ+aWBG9M0HXI443ehX3A9aC7GYQ?=
 =?us-ascii?Q?EA89pR0lp1Vdzt/I8Ma3t8VH1uUCFRXE0R1K0srlmDlw9rRRUQ1GQyIH8fBK?=
 =?us-ascii?Q?DuM00iLG7SnaXtTRd3lXqxrW/4W9XIGgdi22zXskj2Jdz7GSmTUVCCsbR4qb?=
 =?us-ascii?Q?H5Y+xeco80U2rMcX0/cx2VIDzX/AqqniVwPujZq6bX+uphw5VwUUmSTsfDbb?=
 =?us-ascii?Q?opuVtGFz7Lhqvl/hQA/x65xx/dCyHSPZ2llz5pSfoG9H24ErBFvpTuVb12ab?=
 =?us-ascii?Q?JCLTAEn1lvIsWCVo+Fb3m+p4wwovqo9T2S2I7V9waxcKAjo+q9kESOD8d17w?=
 =?us-ascii?Q?hhf3Tno7JkkpB6EwQMpXM2hKeKSuuRt/fsLnQBIWh2CZn/KMbs6DB2mGq2Jc?=
 =?us-ascii?Q?U1F0mUnBlxpBQ5J0vvL6jFFqi7Glhy6n6WU/3DNZJ9AvXAl4Gqfndc9qwuOs?=
 =?us-ascii?Q?vTjQoqfMcI7tEp6mSAG+MLKjQI7WKCk6O9HfFtJeHTWwDrBoFPV3yqbNgCE4?=
 =?us-ascii?Q?03fYW3H7BkBsoVVEM5t5AoVB12df/g58+/w2lFwgwJd7RF9kn5/1uhBqE2hX?=
 =?us-ascii?Q?5WfphytQJAO+J8+xMb4/hNjb9TD/k79xmlL1V8OkUAsiHvmwiahDrQ3jU3H1?=
 =?us-ascii?Q?uo7zhcPFw+EUhEceWR68/jUhLNv+7pVvC0veKy1y6fyaBXFIAVSfbWMZtfWU?=
 =?us-ascii?Q?PVMlSv0P+s8P806rbk/COF5on0nSfsXt4Rg7w6IujCkxGqpRXKFQuZE40s3c?=
 =?us-ascii?Q?fxYl4D/b5NLzpzfGdG2gS16m+dwyMVv6vjPAbkQW+bCTzdKYt+LiiEA9xkVN?=
 =?us-ascii?Q?T1SRmwiVo0wirjjzl6QwnO3xHZDkJtQgFRGKDYS3S0fZaPmAqlGntgBAyRRH?=
 =?us-ascii?Q?GuQ8eO1t3QD/EZfx6bDNoi5wKWl15NnCQuRuixsgTNh32ZYxb4ehOEksMq/u?=
 =?us-ascii?Q?96t0JFRHf75lRTE03cap2fNnun5UkwVHOtD0D+OKRUwhLSXVIJeM2UC3bTOC?=
 =?us-ascii?Q?tcEEi668d9xxXiMMZUFP5rbSYiNN+Dk3pEEChO+bktKL+suqfLYyv2O1lhDZ?=
 =?us-ascii?Q?kzWUtLXHwwJJoH1UTZmIQjwqV4o6PzcIkz6y4OGz800V7EQnUdrZK4dp/Wgl?=
 =?us-ascii?Q?VI2wdpFUrOW7Jh8HDk1ZGcncgu43mF54+gIusb8xhGsPKlIqPDDX9JtuN4NC?=
 =?us-ascii?Q?KUkgKmDNBnRj+83JVS5GnnG5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 048bcf88-30da-4e5d-d053-08d978f9ca86
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:07:29.6677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nU3yUA/IyobCPYZBG6u7nFaGZUtXLnQRAn/CgXJTd65+rtumE/bbAgwf7jBrHN2/DJ40W6k9SoSG9n4dxCpHZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2878
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-GUID: b-OBq9dZbkgFf685GNym9lqNs3BvGzfU
X-Proofpoint-ORIG-GUID: b-OBq9dZbkgFf685GNym9lqNs3BvGzfU
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit renames extent counter fields in "struct xfs_dinode" and "struct
xfs_log_dinode" based on the width of the fields. As of this commit, the
32-bit field will be used to count data fork extents and the 16-bit field will
be used to count attr fork extents.

This change is done to enable a future commit to introduce a new 64-bit extent
counter field.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h      |  8 ++++----
 fs/xfs/libxfs/xfs_inode_buf.c   |  4 ++--
 fs/xfs/libxfs/xfs_log_format.h  |  4 ++--
 fs/xfs/scrub/inode_repair.c     |  4 ++--
 fs/xfs/scrub/trace.h            | 14 +++++++-------
 fs/xfs/xfs_inode_item.c         |  4 ++--
 fs/xfs/xfs_inode_item_recover.c |  8 ++++----
 7 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index dba868f2c3e3..87c927d912f6 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -802,8 +802,8 @@ typedef struct xfs_dinode {
 	__be64		di_size;	/* number of bytes in file */
 	__be64		di_nblocks;	/* # of direct & btree blocks used */
 	__be32		di_extsize;	/* basic/minimum extent size for file */
-	__be32		di_nextents;	/* number of extents in data fork */
-	__be16		di_anextents;	/* number of extents in attribute fork*/
+	__be32		di_nextents32;	/* number of extents in data fork */
+	__be16		di_nextents16;	/* number of extents in attribute fork*/
 	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	__s8		di_aformat;	/* format of attr fork's data */
 	__be32		di_dmevmask;	/* DMIG event mask */
@@ -941,11 +941,11 @@ xfs_dfork_nextents(
 
 	switch (whichfork) {
 	case XFS_DATA_FORK:
-		*nextents = be32_to_cpu(dip->di_nextents);
+		*nextents = be32_to_cpu(dip->di_nextents32);
 		break;
 
 	case XFS_ATTR_FORK:
-		*nextents = be16_to_cpu(dip->di_anextents);
+		*nextents = be16_to_cpu(dip->di_nextents16);
 		break;
 
 	default:
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index dc511630cc7a..882ed4873afe 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -313,8 +313,8 @@ xfs_inode_to_disk(
 	to->di_size = cpu_to_be64(ip->i_disk_size);
 	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
 	to->di_extsize = cpu_to_be32(ip->i_extsize);
-	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
-	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
+	to->di_nextents32 = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
+	to->di_nextents16 = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = cpu_to_be16(ip->i_diflags);
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index bd711d244c4b..9f352ff4352b 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -402,8 +402,8 @@ struct xfs_log_dinode {
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
-	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
+	uint32_t	di_nextents32;	/* number of extents in data fork */
+	uint16_t	di_nextents16;	/* number of extents in attribute fork*/
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 4133a91c9a57..19ea86aa9fd0 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -740,7 +740,7 @@ xrep_dinode_zap_dfork(
 {
 	trace_xrep_dinode_zap_dfork(sc, dip);
 
-	dip->di_nextents = 0;
+	dip->di_nextents32 = 0;
 
 	/* Special files always get reset to DEV */
 	switch (mode & S_IFMT) {
@@ -827,7 +827,7 @@ xrep_dinode_zap_afork(
 	trace_xrep_dinode_zap_afork(sc, dip);
 
 	dip->di_aformat = XFS_DINODE_FMT_EXTENTS;
-	dip->di_anextents = 0;
+	dip->di_nextents16 = 0;
 
 	dip->di_forkoff = 0;
 	dip->di_mode = cpu_to_be16(mode & ~0777);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index e44ab2d9f85f..92888a6a6e51 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1218,8 +1218,8 @@ DECLARE_EVENT_CLASS(xrep_dinode_class,
 		__field(uint64_t, size)
 		__field(uint64_t, nblocks)
 		__field(uint32_t, extsize)
-		__field(uint32_t, nextents)
-		__field(uint16_t, anextents)
+		__field(uint32_t, nextents32)
+		__field(uint16_t, nextents16)
 		__field(uint8_t, forkoff)
 		__field(uint8_t, aformat)
 		__field(uint16_t, flags)
@@ -1238,8 +1238,8 @@ DECLARE_EVENT_CLASS(xrep_dinode_class,
 		__entry->size = be64_to_cpu(dip->di_size);
 		__entry->nblocks = be64_to_cpu(dip->di_nblocks);
 		__entry->extsize = be32_to_cpu(dip->di_extsize);
-		__entry->nextents = be32_to_cpu(dip->di_nextents);
-		__entry->anextents = be16_to_cpu(dip->di_anextents);
+		__entry->nextents32 = be32_to_cpu(dip->di_nextents32);
+		__entry->nextents16 = be16_to_cpu(dip->di_nextents16);
 		__entry->forkoff = dip->di_forkoff;
 		__entry->aformat = dip->di_aformat;
 		__entry->flags = be16_to_cpu(dip->di_flags);
@@ -1247,7 +1247,7 @@ DECLARE_EVENT_CLASS(xrep_dinode_class,
 		__entry->flags2 = be64_to_cpu(dip->di_flags2);
 		__entry->cowextsize = be32_to_cpu(dip->di_cowextsize);
 	),
-	TP_printk("dev %d:%d ino 0x%llx mode 0x%x version %u format %u uid %u gid %u disize 0x%llx nblocks 0x%llx extsize %u nextents %u anextents %u forkoff 0x%x aformat %u flags 0x%x gen 0x%x flags2 0x%llx cowextsize %u",
+	TP_printk("dev %d:%d ino 0x%llx mode 0x%x version %u format %u uid %u gid %u disize 0x%llx nblocks 0x%llx extsize %u nextents32 %u nextents16 %u forkoff 0x%x aformat %u flags 0x%x gen 0x%x flags2 0x%llx cowextsize %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->mode,
@@ -1258,8 +1258,8 @@ DECLARE_EVENT_CLASS(xrep_dinode_class,
 		  __entry->size,
 		  __entry->nblocks,
 		  __entry->extsize,
-		  __entry->nextents,
-		  __entry->anextents,
+		  __entry->nextents32,
+		  __entry->nextents16,
 		  __entry->forkoff,
 		  __entry->aformat,
 		  __entry->flags,
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 0659d19c211e..e4800a965670 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -385,8 +385,8 @@ xfs_inode_to_log_dinode(
 	to->di_size = ip->i_disk_size;
 	to->di_nblocks = ip->i_nblocks;
 	to->di_extsize = ip->i_extsize;
-	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
-	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
+	to->di_nextents32 = xfs_ifork_nextents(&ip->i_df);
+	to->di_nextents16 = xfs_ifork_nextents(ip->i_afp);
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = ip->i_diflags;
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 239dd2e3384e..c21fb3d2ddca 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -167,8 +167,8 @@ xfs_log_dinode_to_disk(
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
 	to->di_extsize = cpu_to_be32(from->di_extsize);
-	to->di_nextents = cpu_to_be32(from->di_nextents);
-	to->di_anextents = cpu_to_be16(from->di_anextents);
+	to->di_nextents32 = cpu_to_be32(from->di_nextents32);
+	to->di_nextents16 = cpu_to_be16(from->di_nextents16);
 	to->di_forkoff = from->di_forkoff;
 	to->di_aformat = from->di_aformat;
 	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
@@ -342,7 +342,7 @@ xlog_recover_inode_commit_pass2(
 			goto out_release;
 		}
 	}
-	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
+	if (unlikely(ldip->di_nextents32 + ldip->di_nextents16 > ldip->di_nblocks)) {
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
 				     XFS_ERRLEVEL_LOW, mp, ldip,
 				     sizeof(*ldip));
@@ -350,7 +350,7 @@ xlog_recover_inode_commit_pass2(
 	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
 	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
 			__func__, item, dip, bp, in_f->ilf_ino,
-			ldip->di_nextents + ldip->di_anextents,
+			ldip->di_nextents32 + ldip->di_nextents16,
 			ldip->di_nblocks);
 		error = -EFSCORRUPTED;
 		goto out_release;
-- 
2.30.2

