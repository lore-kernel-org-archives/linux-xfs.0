Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 699B5C742A7
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjCHWip (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjCHWil (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:41 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24BF86DE8
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:31 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328Jxpjl009786
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=ruiGXC3XkSOuSfmlSYf8jr13Z5YtuUN52vrQPHA7REA=;
 b=rEDNfOsICTTpudONR6Q9gfsemaGCul51G6oWaVUhpxl+ba17n6g5xk9DnaGlYNL1R8Ay
 buFWh0fEhLyXk+G8CfJuQCq/ibF4Zve4hSMb0scf7M2HCYlBtHkKF1NWqamjBhRZYEO6
 8jYPqKpyyyvn/cwkbS0i+7RWKevFTeHQFZgSwRg9HPELIXv/1ShTwQG3M4liZSdELssX
 ww6OfPXveZGS/L+sFEQpX/NpVZC1tGquYhNjuOXEMMv08iYVkRxZlTxKjfNOdG85Yne1
 FBlX9+7kTAwu12VY5CWSrIbf2FoA3pO2T4aYsgFa7a4LM3ti3BOJ9+9D4jnU7b9jy4D2 fw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p41621a55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:31 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328M4HFC036526
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:30 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g464wf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/jFNarYUIV8y8M/Os7Tv8Wcrg2+wPIFVyyfeYHkfwhrtw8Wh2fysDGbEhZ4VP/ik/wcWPvkEy1wK5MD2dVKTszNz3Ylnza4DDSw03OYzWNQAaUimX/yDytS44GbzvTc2n7Z8zuhIdu5d9qFXsrOp9fXISs5EZqXfG7amMcgBqwbUoV+6Yd/mt09e4IW9OcreYivS7rPa9WKCos8ariduVlWHAfPK1rBp7ciBXtWyOC9J+tHxL+ZvbUbIbLNYis0jKEqF7KI6cCCrnmc8nFLPtZZKznwmD2gRarCCaqXYX0fZPgIMvf5hDaPBQHGxj08tuJOFmNeXQrVYhH4zPxChw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ruiGXC3XkSOuSfmlSYf8jr13Z5YtuUN52vrQPHA7REA=;
 b=goUqbXocUVdZYYUS+0gTmfqPEX+NjJ1DyiTsMGUxwph6wMaScZ+gFbcR9PUbMOPgmb+cD5NgjR7yXyoVZcav/uO5XpLsql2U3b6xpAGlMiLtgKBFgEx5BvSHJ5NoPeGG57D3KD8KybAnPHD07NQeoBS7Kv98NMGzUIUoeRCW/QzJwGS70PfOSSMniBru+enQoF4qqd6yTIpv+osqvpMdWSeHsGSlJ74BP1Qw0+2O7bsMJR64faSrpdThGqF60KU39AfoBzbccTCRhzhlSPktLig0AzCBk3j7/JP51J8KLi7BWiR71PiZFuYu6FdIP/0JNE5iEWAAAfdYzbBMwzFhYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruiGXC3XkSOuSfmlSYf8jr13Z5YtuUN52vrQPHA7REA=;
 b=PvZ20hAlmRhFivthF8zRuscjsvjeUhHav9rqINEAod1ks0brPX64WJukwOrAfPP3GNh8VJmlKsuItNcv289VR0yuLJpn2BlUu5h/i6jktt6T8PH7D2tBlaKhC9AqUEYJt1QFyHGig72lINgWAr3MKJauP4Oxftz7Aepek77XcGI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7102.namprd10.prod.outlook.com (2603:10b6:806:348::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 22:38:28 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:28 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 18/32] xfs: remove parent pointers in unlink
Date:   Wed,  8 Mar 2023 15:37:40 -0700
Message-Id: <20230308223754.1455051-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0185.namprd05.prod.outlook.com
 (2603:10b6:a03:330::10) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: f02d61b2-ade2-44fe-a733-08db2025d656
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6rHunedDfY8UHKwDWVJQ6zXO0fKf445M2droARL674Rd0aXU14dc7AwxrnwXvRw1XDXi0iJpa/fyiERYsOilbF2yhmym7haBeJ7ah7cgBmkokB4jGyo4l0y3F4ei39r3Hzg5O6D9huqH7ILPff3bDwsAxjd7ccZXTGlLsjqVgZnV9ULf5vcr2GygsIVydSt2wqcOmH5Nzj9ok9sNxF0Zb2r8lxmTuLu2QQRCliI6uxRAYRbdN3Ko/zXjRva+/AVWxp++ZScpdK6J8GXIJKbobl9+bYuVNVnQjyla2Pk9Sbb6bZWNcl8bJqo1CzU5ICZECNlL+TRpA3snwQByJ32neTpvZQjuQ0AyngKJvqYaNGXC2wPGPyYeM4U4svePdE/9SzBza1AjDWnbnyLKxvOm3aTbGPSXne6C8dJPZtayxVerZRGqTOJ4EOh5yPe/iRHn3Sojo5qJaJYWiYUm9kbQas4WuGOEaIIOlC7R6ndH1aJjvNEO+D2/B1FSAjOq36Os7AFQWMmrhG+YQAmm5gJd8r1wAmeL7tNEfBNGWR3SeMZcR58z10YAa0G2ZabCc0UF+3GbI2td9Sr7X5BMqsVQjNs7FnLLT4NXlwiGve8OJZtolkqM8BIOqzZnIVseLspAf8b3BQLfTOHwU8g2VjFGDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199018)(36756003)(6666004)(8936002)(6916009)(41300700001)(8676002)(66476007)(66946007)(5660300002)(66556008)(6506007)(2906002)(38100700002)(86362001)(6486002)(1076003)(6512007)(316002)(478600001)(83380400001)(9686003)(186003)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2ciTcvfPr6W+e3mvCQeQqg+8E1MDjt3jMPC3zQRNaOR7LCrYiQW37Cz4l7ZL?=
 =?us-ascii?Q?YEWnYPCrrCI+aWbux+jMnxLlKr8mZfwmdafBbHmsX9/jCTvA+zX95gwXMJw/?=
 =?us-ascii?Q?PmF0Y41+hRFi9SgWgIRsS/aiqdMfzzxgN8eZK7d9M982ivyPBFO6Jc3jXeen?=
 =?us-ascii?Q?WwVsEQVihwsF/Sao1cZrgMh4rH0Ed2diqwFQWYP7TfaMJw8ZbcgzBbRfIQy1?=
 =?us-ascii?Q?nNnhxGwP5XGM8imki/OhE02DTN+GAonOzxHqB2F77XZIrB6HIOptleKJsMz/?=
 =?us-ascii?Q?fJ5XlO6Bh5lbGIzhftsN7diRMhoFMk+uACeX/OLjawh1V+yscgpBwDQXjkfh?=
 =?us-ascii?Q?z1qg+n4248vt13+yEjbg2r4HklSLLlu/4yyJTR2d0G5Fe2Xfg1R9grk6YUQO?=
 =?us-ascii?Q?3G06xfK9wCiwqCeW7GSj2TLl8XPsNRdxuzH/fOMjxq7ZZTjKORcgxsZhwnAm?=
 =?us-ascii?Q?FUhoGKDtMtVufqu15yUTidz/ZEFhzXodLcskC/neu2rimDWPBx5oGz3lCNyn?=
 =?us-ascii?Q?X6IltYCA7qXflnT3kDNxJp+BU66MFGcFBZzk7QxNqIT8kA8vFu8D5T/oVR/n?=
 =?us-ascii?Q?BXKzqmxxO1r9qcYdbZU15NDn3nJDG5U2U0DOFSaGvnXgqH5jPwarGUnN659l?=
 =?us-ascii?Q?uavLj/XpHYZ2q8q5WWmk3wBfMnc635hIFUNdY+gev2nfhthCtktpMM7YlOLs?=
 =?us-ascii?Q?mVg5wLhOlocyO6aThGjmc4XQjdV7xNkMngUY+EkfSCkzGF6lfXtzSoyyMkgd?=
 =?us-ascii?Q?dqIkJBD5Qj2lkYYdLRbPSaTYGeo/ccHPfc2G3vegpnRDfaavVMDHkgmRlLOc?=
 =?us-ascii?Q?R+bKkIQmB2oOT7v89nwoqoh67y7qhKWUQ3gDL4j2XeqTF2SnGTCCthDt8Cta?=
 =?us-ascii?Q?DSmVjFT7iByIY6chRfFlVMMPmi2H73/b/dnNSg8xXv5dYPnMWSWDX9/miVrw?=
 =?us-ascii?Q?tG/FBHaFHksJtMhPCKY+b/Z7YlQlZ9xpCC97oLiTVBFVRdisUeIWbXQpCw64?=
 =?us-ascii?Q?aZonwQrjdLZc0jmgKcgUwqd9YFROQwBf8ktZdglDVj2XWxHLIL31veOr0UCK?=
 =?us-ascii?Q?4VB9zUJTb/lvEic01lbbh9ahebMFrCIGOjf4646Zllbq3B+KOREEEAyLhP30?=
 =?us-ascii?Q?uXrAQcy64zSxntt8Rq8kMBz/tXfpCPFG3JugUxW32oYCtQ8OOrPFsozf92KP?=
 =?us-ascii?Q?tINCWq0zfoTJbck8Rui5HZTCrERM0eVy65asShuEpRvAn65M/hYFiZXq1u8i?=
 =?us-ascii?Q?aRuQJqnc+zlzKhubDf4xayzJin4z4d7CLUsZp9FxQne6a+uMm6Xx7eLge9zN?=
 =?us-ascii?Q?blcWNE1fP59uDwJLyFHslPtOaIY6vZiy9Qd60Q+pd3EfzxriNQywupLSAt35?=
 =?us-ascii?Q?fFv0S3X8zn1MklAgrYkGojYXCnSA34i9S7zx4Sh/b21OYCmou8ObBXwr6RZV?=
 =?us-ascii?Q?p8K6m2LdB1AEzLFjipdKegafnnTflale/5MGiuEwGS/rEVznjX5l/T/FPJou?=
 =?us-ascii?Q?FPsE9OVWs/6clEK32zk6akHcyXr9IQTZQfdW8Z1dkb97Zt+8DuAzMEYBLicP?=
 =?us-ascii?Q?8mDcshJ6DPbaCLhMRB4Hs7OAUZ98ZfxTLbl3ijZv3Ec3vi+D+ps4nFRfgIQN?=
 =?us-ascii?Q?kQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: HjkkNqmPRn1zIsB1PmG8RCGcOnRWujvzJENkBTexS/HYnq0k1fYl+ut8fDKQ+Lor2A4Ms57AjtEpK3pxhrxQ63k3Kcd6cmMuhCbbXoDS5RWVU3JoIcbkbbIE7ccKzY2YiZXzv9KJAZKh4Yg6kf9Pw6OW6vglI/cnpNAGQ4RTGy04P39kZW8ApZMVA64yz6HfqG4RQ1pWKhtPQosoc3KK/7fSdJcoEmzDoOmaOKYMCj0b0kRIUnkbGFL5Xd8BtfZIbIs3oe/KavgkaNFBzjOr6d8hDMd9WsM/xgnt/5puuL7HGD77Ixql/Y7UEsQCf1se6Q4hB97YwwIp2sFbjVGu5OVhz1iydcMcHvlVWbXLLGpssufP05O99RvKixywkpuXIYeX4sNNLXV6nuY8kS9qbZzRPZ0M0yoDZ0STqGJ4O3m3GRZnrwjkvKiK6kfYkFWvdE6gE6zPATgAkJsCGU4JjBmI4wZev1Q6JX/9Q+Qj8r4SXiOaBU11LVhIm6bHFOh7TK0tUetMqeTJQOfw8s280PouxHkQ6hIGuirNbgop5c5Lkg53QnRSW5cuAUGbmKu1q1rDyERd4ilyl7OxXEjbtF5143BxYkNcvu1JM6AnZTgfuTv+DME8pz8Zre9C1MgHclmGzB8Yim/nU5BagXkHlQy1nJFd0SPe9i2M06Y8RUq8UjhNb6b9x+UJVpF/pC9bYsvOgEWZvsQcf2gQ+CphKP1LOhUwCFmyp1i/pu+ZqxjafKVQTxJXYK8DZu8Te8kq2R8CympOXrhgidVcwlg2Hg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f02d61b2-ade2-44fe-a733-08db2025d656
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:28.6501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QJpAwtECj79xf2WlyD7x9z3bkYUWlfN3oQJ9LncHvSfS+rJNw1M4XXBpo1vImFmXaojetgtLtcQpZeCmwisaT6e7be76iqcAGySM+g+UXcQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7102
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: Ca1h59Az5Nftp0hctVA2ii_2zoVqojPd
X-Proofpoint-ORIG-GUID: Ca1h59Az5Nftp0hctVA2ii_2zoVqojPd
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch removes the parent pointer attribute during unlink

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c        |  2 +-
 fs/xfs/libxfs/xfs_attr.h        |  1 +
 fs/xfs/libxfs/xfs_parent.c      | 17 +++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |  5 ++++
 fs/xfs/libxfs/xfs_trans_space.h |  2 --
 fs/xfs/xfs_inode.c              | 42 +++++++++++++++++++++++++++------
 6 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f68d41f0f998..a8db44728b11 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -946,7 +946,7 @@ xfs_attr_defer_replace(
 }
 
 /* Removes an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_remove(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 0cf23f5117ad..033005542b9e 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -545,6 +545,7 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
+int xfs_attr_defer_remove(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 6b6d415319e6..245855a5f969 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -115,6 +115,23 @@ xfs_parent_defer_add(
 	return xfs_attr_defer_add(args);
 }
 
+int
+xfs_parent_defer_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_parent_defer	*parent,
+	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
+	args->trans = tp;
+	args->dp = child;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return xfs_attr_defer_remove(args);
+}
+
 void
 __xfs_parent_cancel(
 	xfs_mount_t		*mp,
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index d5a8c8e52cb5..0f39d033d84e 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -40,6 +40,11 @@ xfs_parent_start(
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
 			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *dp,
+			    struct xfs_parent_defer *parent,
+			    xfs_dir2_dataptr_t diroffset,
+			    struct xfs_inode *child);
+
 void __xfs_parent_cancel(struct xfs_mount *mp, struct xfs_parent_defer *parent);
 
 static inline void
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 25a55650baf4..b5ab6701e7fb 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -91,8 +91,6 @@
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
 #define	XFS_QM_QINOCREATE_SPACE_RES(mp)	\
 	XFS_IALLOC_SPACE_RES(mp)
-#define	XFS_REMOVE_SPACE_RES(mp)	\
-	XFS_DIRREMOVE_SPACE_RES(mp)
 #define	XFS_RENAME_SPACE_RES(mp,nl)	\
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define XFS_IFREE_SPACE_RES(mp)		\
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 63d750e547c1..f12966224005 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2477,6 +2477,19 @@ xfs_iunpin_wait(
 		__xfs_iunpin_wait(ip);
 }
 
+static unsigned int
+xfs_remove_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret = XFS_DIRREMOVE_SPACE_RES(mp);
+
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
 /*
  * Removing an inode from the namespace involves removing the directory entry
  * and dropping the link count on the inode. Removing the directory entry can
@@ -2506,16 +2519,18 @@ xfs_iunpin_wait(
  */
 int
 xfs_remove(
-	xfs_inode_t             *dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
-	xfs_inode_t		*ip)
+	struct xfs_inode	*ip)
 {
-	xfs_mount_t		*mp = dp->i_mount;
-	xfs_trans_t             *tp = NULL;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_trans	*tp = NULL;
 	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
 	int			dontcare;
 	int                     error = 0;
 	uint			resblks;
+	xfs_dir2_dataptr_t	dir_offset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_remove(dp, name);
 
@@ -2530,6 +2545,10 @@ xfs_remove(
 	if (error)
 		goto std_return;
 
+	error = xfs_parent_start(mp, &parent);
+	if (error)
+		goto std_return;
+
 	/*
 	 * We try to get the real space reservation first, allowing for
 	 * directory btree deletion(s) implying possible bmap insert(s).  If we
@@ -2541,12 +2560,12 @@ xfs_remove(
 	 * the directory code can handle a reservationless update and we don't
 	 * want to prevent a user from trying to free space by deleting things.
 	 */
-	resblks = XFS_REMOVE_SPACE_RES(mp);
+	resblks = xfs_remove_space_res(mp, name->len);
 	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip, &resblks,
 			&tp, &dontcare);
 	if (error) {
 		ASSERT(error != -ENOSPC);
-		goto std_return;
+		goto out_parent;
 	}
 
 	/*
@@ -2600,12 +2619,18 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, &dir_offset);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_trans_cancel;
 	}
 
+	if (parent) {
+		error = xfs_parent_defer_remove(tp, dp, parent, dir_offset, ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
@@ -2623,6 +2648,7 @@ xfs_remove(
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, parent);
 	return 0;
 
  out_trans_cancel:
@@ -2630,6 +2656,8 @@ xfs_remove(
  out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+ out_parent:
+	xfs_parent_finish(mp, parent);
  std_return:
 	return error;
 }
-- 
2.25.1

