Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA6BC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbiERAM7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbiERAMr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:12:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA84E49CBC
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:12:46 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKPOgA019101
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=h4Ibu70qyZQeOyA3M64Nm8bNnH4zHPAmwCpK3K3bjfA=;
 b=Hid9LNv28SMwIRB2AdQurmSuVvWOnXGXhYJY+gbNHDd9hKZ9M2s5Ew3XbrR24LgUkB/J
 EhUxd4lFMLy2I/eANO4kLMQpbFpo8fgvsn8Vqg/HRY3wCwi0OkOnjp9CMhXi7k6i4zyx
 JvArjDVxD9kVqqOb8r3TIWbjjoUEZcdt3QWahPFYUxQfto0Q+ZRzgzMKqp3CjDk4gbrq
 HTGg7JO+fRvhCKQHFohgV7g3fNxqy25KCuyETXxubG9mJBHalkNrIvU/2/cd5tIzXLVh
 QJ+gtOmwLXIGS1PRg3VbGv/eKD+2Nyl17L5ngPQbtdTC2Mvz8pcH6WXG4aZg1VRtUXrO /w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2371ywds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:45 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I0BXpk017045
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v3ebar-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U5KOhz0mk5lJm3rlC3QVraKqWtBznzkpoJpZnrrInWDwPenesPj5it9XUF5nubeoKMCYpskOtAZgbBp+XoYZmIj8ZZQ9CFMwq8CoYriNnvjQ5drzH39ztUP194f+JTgjJwRYr3DMdCL+D3+mJv8r4lEf9rppnIboSa6SF1IZz+ZJFiM67+Myi3YItTadAXl0/RY+UBAeEGs59Qb0vrLsEd3Y+Tujyt0ZLIeFJkXpyGfTNvWuS37XY/XrDVpmv7+SG07IkG9TJdN/Wnq3PdOdq7uy6rct5ca8uhEkMk5n3tCykmoMq1dFI5wKr4u81wyVxJF2A0nGWWMurQqpl2bjFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h4Ibu70qyZQeOyA3M64Nm8bNnH4zHPAmwCpK3K3bjfA=;
 b=SGNmDTpL+/I226EXxoNBuThYA8PY3sEFwtYsihDhrao8MEbFbV/cmtx+3YmH6QkeRFfWl+ywXDO04aJi+We1nDJPvJ0IO7si5FFsmYKFkw9SNLH3b+yZ7rM29bqFehks5/4vxsO+KFa0/ZrmBpes90+VpWrIAmQocu4Hg1a5gZmnPd+FDdi4AvXwlfxvhbzAPmI7IPUKXDT5GKKzKd5M1yK7CwKPbcVrB1vVB9YaKCmqWOiLes2ricuxQbPMA9sjEMDK2hZnUggLtXeBkAP2yL9/BxA2hH0FXLHpOAO9Rgyzh37TiPYiV66EnXLpvuVXKmfnblKaRZTRX840iFvrXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4Ibu70qyZQeOyA3M64Nm8bNnH4zHPAmwCpK3K3bjfA=;
 b=s66GMvCkesDHBzkT7qmOio5uVecBlP7TSgBIAredSR7m9NAx6VEC+DWh9h6fnuci6cLKshvvlxP3juYyTql2KEKV7Gmo3YRG5fYqfMoRDAAxVFANeQeRvq0Iz4ktgkBRCXpVD+UoUphTBVU0q+5G464utxoI05yXQKclHqTsQg0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1528.namprd10.prod.outlook.com (2603:10b6:903:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 00:12:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 00:12:43 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 17/18] xfsprogs: add leaf to node error tag
Date:   Tue, 17 May 2022 17:12:26 -0700
Message-Id: <20220518001227.1779324-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518001227.1779324-1-allison.henderson@oracle.com>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a79b8140-f7ca-43ef-7922-08da38632009
X-MS-TrafficTypeDiagnostic: CY4PR10MB1528:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1528DAFC716136CF8B46662995D19@CY4PR10MB1528.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g0ftvDWrBweOCYQYKeYnl/FnsAwhZ1INErWL2A4XuhloMhhSfqyTa/yq2w+889AA6udNqT0YUcVhg5QCeUJUk/QTL6KINsQptub2IvizyHsYrgNegmoprkRPAzEGqdoVbeQdCbjBpzR3NlCigBnY5NFVkBbI9cS7VKpjeseIpIFJtS5wcj95CRjohSTkHtGSJ0dOfWzywH/mwcZSjH3oX036ApUVxQmA44wYWH+ncnEjy+khC+i7B2viGH5OPVNNvkYpzxMvuZJ4E56HcZdZHYqcl730TTi9es2qg1bGhzMGaYxeOMvVp7/gGBooMELD7OXCdlbB8L6kXkfc3fAHdA3wTnuqjXfn3/xtnAbfJ+VdYtgbgJWz6rhRGsWGkJZmlZKZmjJXxT6EjiiZwSJkpKemKxiBDB8quajMGAjBz6Gk+z95mGdlcxfpudV9VFhLEIxg5cfb2Ok5LU26VulL+Et/FWRJpSMBNIPhNApmvkjxbwA/XeDlMCay3Cf2eGz7oDWg14sRm7XpdMEBssdvVHO6TOxp5s7bxS88bFxvaBhTiMU7DRBuE9juprly9T062B6h9xriG83k5vQlv8/eLMSVTQB33NlP12q8eVyaE8V01fK59p+H+7elea4aEayBCfAneicPyBnMwIWwsxE7/5DBbYcRHY/0nMxVg0RoBR0J+Vw6Ds046l5SF0e6KFss+yFOPal2Cl8mG158gUruJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(508600001)(38350700002)(38100700002)(6506007)(26005)(6666004)(6916009)(66946007)(44832011)(2616005)(2906002)(5660300002)(52116002)(316002)(66556008)(8676002)(66476007)(6512007)(6486002)(186003)(86362001)(1076003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7FyEFV2RSEQZCfbbYMKGylDF9jN8/3RR9rXh+7l4r6YqyvZFmRY9L9A4GFX8?=
 =?us-ascii?Q?qWWp6kHLQxemFRhLFLUwNEh71ekGZoihMblD+uUxbAOW8ZlpatES6cRSYgjM?=
 =?us-ascii?Q?PODQSP3Os0BrIe2d3FhsV+6hwMjBjQaB9LwhOsyjz2ZDCdx9GKLYcjMj+Fcx?=
 =?us-ascii?Q?iQw1we2PWlbAfoWeez2o7xyrgrVvW2+7U6INWbZ0mDGPizQeXyVj0ejD+UWg?=
 =?us-ascii?Q?EukJGokBjE/heg+V8pwW2kiO/0cJnFlT5vG6S3Jl0Tt95EJUoZb5goVgItGs?=
 =?us-ascii?Q?ioUNhQPgERd11brnFoRxkrNq4RvXRzcMEFqYXwRXXvVIe1k96fGAuzUjfER9?=
 =?us-ascii?Q?se1gmV4UC95BVD4rjuu/nCLZMxeFTkeGIBVVfYD46by6enlQjvcDB8xe6qTc?=
 =?us-ascii?Q?hc1v6Qt6d0CVJNkv7ojkA+LGu/GUEfFJmIaXFcohrKHTIhRqf4X7MN1+aS/O?=
 =?us-ascii?Q?yGkIldoEQu7GHfWE1k+/KY2CTbekpk7OhvSfVBPoLx0+vt49WHV5FeD1YuKn?=
 =?us-ascii?Q?/xDEOlAvslUh1cRIIfnrsapd6yUVYnu7eHHcdjqGqkoVgrFZU66G6LG95F80?=
 =?us-ascii?Q?OBWSvW+vFTlC6sexmRsLHsnBj15Az4pvXqeBRK7jqIN9cxPxlqtZyDVyc1H0?=
 =?us-ascii?Q?Got0ZbCzVLCOpk6693zedvYcBryDKWc1vyHSJO8QSAGMgOIUXbofmNKZyhxG?=
 =?us-ascii?Q?jV1v+QfdF1a5nb4PDkP9O0OTiogQ3iqJKGwUENZLjca9+va8VG4SQlQs4nwm?=
 =?us-ascii?Q?phSJENsBAUlvCaITdopIKaYEmt/8AFgvcgJu8uquLqBI8117uaXhc6Mxjk7G?=
 =?us-ascii?Q?lTan9FJzYKdCiUKz/ENDQsUHMi6KpANqVIYNz95TVSoCA1CrHoPiDz0mRhQ8?=
 =?us-ascii?Q?l1hEsKSxcHr5RVUt7JLwFvYqHA2v8QP6tF+o+6ieYkaEtLXO6F4rJQB6j0fm?=
 =?us-ascii?Q?XhS0Q0LMXtAoIdpzJ0PkhDDTYwMAyJk0KYlkqe9r5ZQuDdRk/VwYH9rUdGDC?=
 =?us-ascii?Q?3os7UqOn7qQUCCjTjDOzjEhb8Uh8ddiBm5+Q/stsDkUT8ker2z+JGSl6rn1N?=
 =?us-ascii?Q?FtYt3J0KeTyS0iwZI0jLaFyJQ9bK31C9aYOnfjiDsAYujy77HG288xFzXEL2?=
 =?us-ascii?Q?pinlKcZXKnV1bxNuc4lg3pQ9NK0cCRELB13G0xWpMWT2gw5/Hz0jxl0O5r1a?=
 =?us-ascii?Q?jNS4MEAvB+W14WJlGySCE/PdsN7yjLZyYRDCvYRTb1+h7onQPmVl6JhGoJ76?=
 =?us-ascii?Q?iNbN75M0u3y7nugBo3ocWHX70H1tYlNjwdmWetkvF4h8fJVraQboa2Ads2a9?=
 =?us-ascii?Q?EGVQQg+fGn78mAsJYLVt+ZQDTGQPZJABPgWvhcu4xI+eDjqJlN6H7DBwUbMW?=
 =?us-ascii?Q?aFJin+uu6V/w9TF55cWQJbsYCczdQ1FioQ1u9ENH4SSnNZhESIDcYdr+pKWA?=
 =?us-ascii?Q?xx6iXhgSyH2dtey6WeQ55YzjOE01AmbeMzTClE7Urwwjtf+9BnEkboscBZ2/?=
 =?us-ascii?Q?jK972h62mO8fnfwrdUDjF89xfxK1AwgAa8o3vPw/3Z0i17uxoPalGnW63JtQ?=
 =?us-ascii?Q?plX7lvHQ0lQ9LM7lgVkhuADzjrJU/S4zALSOyXX1q0oyMM1ejZpHDN7qWA4G?=
 =?us-ascii?Q?v/2YgbIG6yAhZ0TbNYgCergEWSxadDHh8jRi/YZm2WpthndLjLL9sDWzQijS?=
 =?us-ascii?Q?FGSO6OEEy9G1MFh0yle+dxLLLDYAaCdJoC3A/AX0mtsX+3J4b8hijVdSwgDd?=
 =?us-ascii?Q?U2/Cgm+0t58ZblKmRJepL4NFSho2DE4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a79b8140-f7ca-43ef-7922-08da38632009
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 00:12:41.8161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 22v3l0wlblm4ok6pkmh7oJ0HpNlPXMQ4djOy7qYL6n4q0fZ0KJknuPUwfrhJy7h47ZjpfhOPy35a0yzoOZWWAOVFQr/jzGDHpgebXD5FM9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1528
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170143
X-Proofpoint-GUID: ihnCT0fucnAmUrOozRRIo-FW0o7kA0PV
X-Proofpoint-ORIG-GUID: ihnCT0fucnAmUrOozRRIo-FW0o7kA0PV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: c5218a7cd97349c53bc64e447778a07e49364d40

Add an error tag on xfs_attr3_leaf_to_node to test log attribute
recovery and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 io/inject.c            | 1 +
 libxfs/xfs_attr_leaf.c | 5 +++++
 libxfs/xfs_errortag.h  | 4 +++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index a7ad4df44503..4f7c6fff4cd6 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -60,6 +60,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_AG_RESV_FAIL,		"ag_resv_fail" },
 		{ XFS_ERRTAG_LARP,			"larp" },
 		{ XFS_ERRTAG_DA_LEAF_SPLIT,		"da_leaf_split" },
+		{ XFS_ERRTAG_ATTR_LEAF_TO_NODE,		"attr_leaf_to_node" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 45d1b0634db4..6bd324844f32 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1186,6 +1186,11 @@ xfs_attr3_leaf_to_node(
 
 	trace_xfs_attr_leaf_to_node(args);
 
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_ATTR_LEAF_TO_NODE)) {
+		error = -EIO;
+		goto out;
+	}
+
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
 		goto out;
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 6d06a502bbdf..5362908164b0 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -61,7 +61,8 @@
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
 #define XFS_ERRTAG_DA_LEAF_SPLIT			40
-#define XFS_ERRTAG_MAX					41
+#define XFS_ERRTAG_ATTR_LEAF_TO_NODE			41
+#define XFS_ERRTAG_MAX					42
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -107,5 +108,6 @@
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
 #define XFS_RANDOM_DA_LEAF_SPLIT			1
+#define XFS_RANDOM_ATTR_LEAF_TO_NODE			1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.25.1

