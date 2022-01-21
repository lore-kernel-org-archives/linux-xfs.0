Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49410C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244343AbiAUFVh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:21:37 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:13700 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348627AbiAUFVG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:21:06 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04TlQ018499;
        Fri, 21 Jan 2022 05:21:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=TJPvf9FHCUhS8dvgwXKANZkYRRiZxg+QPkmucJ1zvwM=;
 b=enrzZhipI3ORGgNHcBS4jvi6bqGyka+wqEhWxobX09zVUnTL6Zg2/sFwCrqYHcUtivyO
 bvVFM+RnIwusJv2KLJQzY/xJr8hSFtqHWpaB9d+8j7DRqGGcR0/Q6jGsu/ZOw2VXCy4C
 sQx8OoV7RWjySpjrLl6xtghot7NWhMvI9yTB6v1+JeXWrNJpOP7kFbPTfHzpwDE4qpEK
 MPzRtz8unB9fCpuT0vIw73N8gcqJcFxK80+EpstC/SybCz3727yc4FKOh4StgtlcFn2W
 MRF7YNjo6S8CxjZGjETLFSducZ9Y+3NcNXanoa2YnXVsGJWvnef8rBqhUL3SdNj4OX4i 6A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhycgcsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5Kgdw094496;
        Fri, 21 Jan 2022 05:21:02 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2177.outbound.protection.outlook.com [104.47.73.177])
        by userp3030.oracle.com with ESMTP id 3dqj0vbm5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hMxjSGNcwHB+/GcRR1MqTuJwBjmV7RHJppIx7ggiOp/Si2Se9upRmoviet19kRJMUc7jZbbBeTfcF/dBtXef0yKUId2p88CwjGPTpgbd5yG/UmrnU3RHC3+M5I2hRmLct33daYTTT6H3YAzIh7Q5km4eKIgBrrkx+QYMa/a7wvrBqgw/uX3542/0qfwoSkXaVkw1Hoz65bVAmx2zk0I42SMTv86k8WKhdfpd3fcYySUBbSvxp2J2y3QRAYtBwWjiUG+3SGDp5AcexMhtEpGEk2pjebioVPmo/SfXju41+GOxHz34iNz/ktcUd3PsGMQ8tfoZrB8vygJvQlsofh6+Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJPvf9FHCUhS8dvgwXKANZkYRRiZxg+QPkmucJ1zvwM=;
 b=h2DkQvbgGYlBHzIXa88RVI5HOvtIu+1NOnpJKka0RCdjICsXDk/jArkXHPFafVWrmGio2gFk7siumAJWCFiYbbeVGAQEgD8uWCahyXxowk1nVwzvrXvj5AlPIfVGPf8Nfjmu0HuY2Cf1NVaCYk1TmwQhkYLfC7KyZ6qhVY0BJIAweOrr7fPDRcdzIUPOo/KUxdmzfnYMWAiHk82t1A4CCvcj573xKalrM4A4yqJe6umu0/FhXQcsXXeaTKyFxD3IEpZqixNBd1UW4w2uANd4E7LXd0NtGU5IqolssUaGbZY5uFpidEpeVF9tmaTaztcX/DCcp3BZZBbvhUcH3UMPwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJPvf9FHCUhS8dvgwXKANZkYRRiZxg+QPkmucJ1zvwM=;
 b=dlX+KhDdypmZ+yk1LdXP57btIcGRiXL8aw+e6dklDzf/TqwPbh3UwFTJSEm8C/q/hqOFlHQ3YNzFCN/Q3ullvaosuSdyPUvkhzkeNYYN/CI124sP6wbtk2eF8NVPkyrMKaTKtXdSLWY3ZqAy+TtdNVEhFiklJtJ1cXC6LELqM1I=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CH0PR10MB5322.namprd10.prod.outlook.com (2603:10b6:610:c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Fri, 21 Jan
 2022 05:21:00 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:21:00 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 10/20] xfsprogs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers
Date:   Fri, 21 Jan 2022 10:50:09 +0530
Message-Id: <20220121052019.224605-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121052019.224605-1-chandan.babu@oracle.com>
References: <20220121052019.224605-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:54::13) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81791e7d-274a-4d90-8374-08d9dc9dcfbc
X-MS-TrafficTypeDiagnostic: CH0PR10MB5322:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB532248481DAD9EC802ABEAE4F65B9@CH0PR10MB5322.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:345;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XoEyCR2gA4hmjcNckUCnpVWnZa6FC6KD1H8b48w9jSZ51gf+p9mWAE5W7McCWf4EC3AhYvzP+pyBdwjW8iS3pxi7Wo34iO99cjSIJi9sfoTW0Q1aL9bXD+3qZ4uMephBFe0cpaouLydPUq//QVCCBScMtJ1WafnUtKmGmk9/QS1lZ6cYgy2MIgUn8izrgXBxscu0xG/+IAtXDZ8xBba4TXssjdcxXEx0KxuIhZVcpKgGPaelKT7yINiU9foQkKV6dot8eowKZ5t6EZ1dpNJGOLAYpmrerUhjTnMveC/9xaEso5gYwFHwPEPbD/eV0VMJzl3JQj8gsMC6odXd7RrucBtTgUflf/XpRTDwgiIhLnK7BvhERhQpZKhE9dCyBiacBIl2ixotzym50pfhmxZ7kyTu6smwukCD1lOFpX/LKh5DGAOWBbj8AylogPw1tzymx1dZDZV3TADVT6WMBjE8cnKeXmDrgmamqrIwS1u7IQ3lOPjj7sJX1jPClrzUj3pjKr0U+SKDy2ffjnN5FBJKx1ovSUdBqcR8kw5etVJQOS6WJRSliRe9ZNn5vnuUNydff9rBuD3f4Sqk2vlr6px6DRLiuB9KJ5jd8EvNwXavkYnGhRpjvQU0FkyKU5U36NnoLpuaKFrNLBtAQKCg2HS3y941nF0yXzGmZWHHp9VLQ8M4P3QdUzHojM2yWNj60Xe7hehsUTWTO7NgfssZN8fXag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(4326008)(316002)(8936002)(36756003)(38350700002)(38100700002)(6916009)(1076003)(2906002)(508600001)(6506007)(66946007)(66556008)(66476007)(83380400001)(5660300002)(6512007)(8676002)(6486002)(86362001)(52116002)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cL34Ay2jp+ecUN39UNkMUxUjBhXHu9yxrm9EAIGEBF3wGIhzZkajjG4zyVaZ?=
 =?us-ascii?Q?Q7CTjAq2gTnz7k6lOwp2Jw+a8IkdA211s7zG6ocXujQDk0tHmTPPbyU9MDjL?=
 =?us-ascii?Q?mhSZQwf1Nj69B+6EuwA+1jrJJE2MgwjLgQj5gTvnfLjsjqX93Yzd7+/Ev10I?=
 =?us-ascii?Q?8YdHTtfrhQDh1Bed43eqnyUQOmvECEA9jew1Am1Wg84HrSp76QvWRr+jbFib?=
 =?us-ascii?Q?f2iHHi6I7r6jFQTucm02BlOyGJYBHvONgTygz7awSbnrneUVubeXx63ogHeU?=
 =?us-ascii?Q?IY3Bm4vIMG+2uzeKES+0bv6YY5la1nza1Y7pUqyrPuBKQuFpMDCpwtw1HspV?=
 =?us-ascii?Q?RTaFrCenXlvrkgrwTB2xHy6eLwIE9YxFLaggm6osa0tS8OsAR/idJfLIxi4N?=
 =?us-ascii?Q?+STtam2UslH3UX3MHukV67SXrqhCiQp8MvT5SNIbCg08qbjtKfTvDMMiJVBq?=
 =?us-ascii?Q?Wv1B3/a/Yh3EIfz03zozL2KoYHiwWlj/M5weoi0thr2SeVk+TnFNIagGzUSW?=
 =?us-ascii?Q?23IGTolc+wzlUdysihJPJzixvFu02dIHtyXeBJC1zED9vyudOSY4CPuYShu2?=
 =?us-ascii?Q?oGnnwtv5LXdIPGMbZbH6b5RpyhN7LR0khrCqec3tlTZr3E8hjdMWWbcjb/5R?=
 =?us-ascii?Q?2s4iZG5IRyDqUKCG53faD9HF4ak+ztqljt+zKUHywRIMi9aWl8dbMNNh59wi?=
 =?us-ascii?Q?wHNwv7prrRPum3mi124yGM0bUy79zRvvFH7CWfgxpjhBdfeFQZUIbdB7iUcU?=
 =?us-ascii?Q?Wjd/aYgLxT8dDrI3v6K/LohLKaMn/ImkKPiFLcx+coG2GVxasJ8Frr7p7OVo?=
 =?us-ascii?Q?DLWnQw7arzKzMcubVFqj5zIiuSmhfmVuJrZXlib5l+Jx8JaSlxMYMNEhDMB8?=
 =?us-ascii?Q?PWSokc1NRWz7YvB5BCAcBjH2on7DTlh00Rsm/V7Mq1pruLv7620pjDf5ThLD?=
 =?us-ascii?Q?A++12829n7AbJNcZPW7td0Rg+QHqlXSZ1Wl2y8C+4m+6PaUrH2ESL61ERbjl?=
 =?us-ascii?Q?f36GivTyNmkEsH/leiPSEucGSpP0/1cXbO8UHbDcK3adtmP8+pqorWq5qv4F?=
 =?us-ascii?Q?SzrKe5800+4T3JBkR9rEEtN8XO2dpyDJixjPXhr9ieU4vytPQm9pQUmZhKD9?=
 =?us-ascii?Q?1KsNwj+Dw40YaBfnbpz5xWASmFNhUp4f9Wo1yqyVcVwhppAHtCNhCdHXH6A8?=
 =?us-ascii?Q?Vx5bhQx9TkYgTgbgiWzuY7rfjpnBhQEqnjKc6ZQ4mFQ6FfMsS5Ztbd63lb2q?=
 =?us-ascii?Q?NCg9Ayc/fcIX/GmmkXU34FvChqPOj3BwQFjY4EMcrR0h+OL+4CEYBcOq42tP?=
 =?us-ascii?Q?mMA80s5wPW0adsUgNYF5gPexhoeBYLEdwAygla7Jqopa1GVv5BJFlaViThe7?=
 =?us-ascii?Q?gj5eta8VwnZLWELzn0jlIYacTCVs3bBLLQVNVJyEEBFJfaY0SPqDxPbTqBGI?=
 =?us-ascii?Q?akdaurv3wBmhC8D74sxnMDOuFsIm8csbzI05rNZrzD+WUy7qnnkzK8ucY0Ze?=
 =?us-ascii?Q?BEYv+DDtaQGqleVE3AJ/go6x5qX6O/55NBDcBDCqw7TafkIZFiSendPm2XoT?=
 =?us-ascii?Q?X71zHuoywTGTGQkhOTzUg+x7SqpVwwhe8uQERGdAGkUagn+8QCKVMimvp7OR?=
 =?us-ascii?Q?WmdcTbBwsMZih4quaQ4OZv8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81791e7d-274a-4d90-8374-08d9dc9dcfbc
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:21:00.4412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ddWNb0arHupx4Qs5RjwbYnWgjzLm6cZJu7j0kPD4hLATuTdUbMN31pbCzEz41hpQA8UgvN5CX/nkAHh3wyivpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5322
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210038
X-Proofpoint-ORIG-GUID: GrtWevzjqAxAVJxBe0qSfRLtYU5rN7ty
X-Proofpoint-GUID: GrtWevzjqAxAVJxBe0qSfRLtYU5rN7ty
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds the new per-inode flag XFS_DIFLAG2_NREXT64 to indicate that
an inode supports 64-bit extent counters. This flag is also enabled by default
on newly created inodes when the corresponding filesystem has large extent
counter feature bit (i.e. XFS_FEAT_NREXT64) set.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/inode.c          |  3 +++
 include/xfs_inode.h |  5 +++++
 libxfs/xfs_format.h | 10 +++++++++-
 libxfs/xfs_ialloc.c |  2 ++
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/db/inode.c b/db/inode.c
index 57cc127b..a9e6cc70 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -178,6 +178,9 @@ const field_t	inode_v3_flds[] = {
 	{ "bigtime", FLDT_UINT1,
 	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_BIGTIME_BIT - 1), C1,
 	  0, TYP_NONE },
+	{ "nrext64", FLDT_UINT1,
+	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_NREXT64_BIT - 1), C1,
+	  0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 08a62d83..79a5c526 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -164,6 +164,11 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_BIGTIME;
 }
 
+static inline bool xfs_inode_has_nrext64(struct xfs_inode *ip)
+{
+	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
+}
+
 typedef struct cred {
 	uid_t	cr_uid;
 	gid_t	cr_gid;
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 7972cbc2..9934c320 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -992,15 +992,17 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
+#define XFS_DIFLAG2_NREXT64_BIT 4	/* 64-bit extent counter enabled */
 
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
 #define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
+#define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
@@ -1008,6 +1010,12 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME));
 }
 
+static inline bool xfs_dinode_has_nrext64(const struct xfs_dinode *dip)
+{
+	return dip->di_version >= 3 &&
+	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_NREXT64));
+}
+
 /*
  * Inode number format:
  * low inopblog bits - offset in block
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 82d6a3e8..1661ebe4 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2767,6 +2767,8 @@ xfs_ialloc_setup_geometry(
 	igeo->new_diflags2 = 0;
 	if (xfs_has_bigtime(mp))
 		igeo->new_diflags2 |= XFS_DIFLAG2_BIGTIME;
+	if (xfs_has_nrext64(mp))
+		igeo->new_diflags2 |= XFS_DIFLAG2_NREXT64;
 
 	/* Compute inode btree geometry. */
 	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
-- 
2.30.2

