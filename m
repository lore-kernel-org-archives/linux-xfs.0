Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4865C25B50
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbjAXBhA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbjAXBg5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:57 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69981A4AE
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:55 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O05r8d022928
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=B6+3UQsU0sw9d77q0+WDjNDgq1Sdd1q73pA+X+HdgOQ=;
 b=l88B4cWew2cUvbZVq80GDyWLY0UBnPBVly71CqgxoyGG11twIuFFoM1BY2cb9HcKLngE
 J6EkB33zTz10zt/54z0u420+i5FEHre9mVMiruJEZdo7qF3c94mp0ECEUrRWvglM2hxK
 wZNzM14LoJYaL8n/lEMtgIYDLGmfIs5FkGiKITdnxa/4DXX4gQqX2CXOB+BRNe6IgxaX
 SLtDcgvKXFVLS+dbPb/oU+FbGjoKMfl7T8sRwUoBhWFS6vDL+RgWJgT7iLvwz+ep0KVf
 cmLSlTd3dnqs91/pbD0Pplz1tM5jilGikTGQ4/q+hC2N9DxvEkXPUypqmwiPLkwCUgAr 4w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87xa4a1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:55 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NNPUWH001439
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:54 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gakvta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5WyHSjUadoQTD4RaU7roeL+0noANbIgtren8ekWOeYQqOo0rUw2UQfJI6oNZw+5u5RF1gUiHCJdWlgOOrkZTp4th49RJ91EA6DwTCCFO5BTMbw8pvzYe/vQpl47dL7mm8Yo6FKPLacGN07zDPv+ji7DS7GpsLaNHLYh7K6OdVsulS5D687MBWAVQ9U7pgJ9d3lrPK1iU3L2sFbSSMnUlp3kob5OtzviWF451dHeDS1MgNe5vS6GN8vKk+gYyyVWf+Oo7T+mDFsReV3JFVuBjH86ruMDNim4mPkkpJnLq2/ls1DypkK4esZsHHFwD0wdHrDmFuEln4J6a2w4HvdZWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B6+3UQsU0sw9d77q0+WDjNDgq1Sdd1q73pA+X+HdgOQ=;
 b=D5Axz7jYtxlgaRkZz+qXV+1PLgdqX98w6dVg4zzOfn1Cbn1JWwjqJFUjr/lWlFTU5RVnsz16q9lsfQ94lNJC89wwEifIlD4XNARSz+qxSZ6cQ3iG4un9OjMbodzlZZY4pd6kqAtcrPx6FD4Yo+3eEa7SFPjjWsOCMimfblQa8gcGoB+r5wem0VBW5Ipaxx0E6aHAWwTPxl+ASaVghuCGtpFw8bPAoe2VC78g178Hn94TwvgQQ+0+6D8LXPVGOvD17tnd/0HpWnNyYDCT6siaDSRV8bqg5D1aodjP73/wp5KhG8VzACBmiki/0sLT8bGW0IYHteEZZUksYxLu4kRX+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6+3UQsU0sw9d77q0+WDjNDgq1Sdd1q73pA+X+HdgOQ=;
 b=asF37rebY3bUyHgXZinFvp+pzQbo0WyEBbFOpY82c+r9QFOoE/S+ZUzsjjug6HrMQjpGPyxjqLWb3S5LrOEql7ERpTbmtd33bNr0v3i5X+V3DqIYVieDPxl3+wlyHkAK8NNPlNgsmfFzPGkVudX6ZNx4wov9OYyobJ7KIxI900M=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.8; Tue, 24 Jan
 2023 01:36:51 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:51 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 18/27] xfs: remove parent pointers in unlink
Date:   Mon, 23 Jan 2023 18:36:11 -0700
Message-Id: <20230124013620.1089319-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0145.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::30) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: d3072039-dae6-41a6-9d96-08dafdab77ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZNQP3//M2OfjOm941uMbeHacRHYmdnf87yIt8Y/Qx0CrDal1PzMez0FJdFKxeMf5gu6h1h/JkiTGyeZOtWGiOooIYyM/YhZc6fiHE5VzMuMZvlQNEcE8vrGSzvhTd5T3wsGXrUkmgnqd4qYCMKpMiZItJhGGggpKH+3YfQ/7aiOJMpWFtQ1BjxFceXv8SDb/ZWqmD4GT4RFc6URuIyrKk+cx2TxQS59hEpYoDJ7b+Wo/2k843ricm2963EKAPvBEDrcpHeQEahqpylLDMoHlWqi4d5irKCUJMsYWZBvMC4WaBhCJf69AcinhsesRr5CyHc4lBg9zE7yRQw+n0Qz2W4+/PH6vZePhnbJS8qsT2G3Wjh4exbeFpcmnhy3y+Bm2hvyGugpkiCSDx1MXP9FYDOE7DQo0iUOvxxuUorOo4uYsAla8KkxFJ/Pn6MOTktZchvxgrb8ani+B/T1R9GReow6srh57OiSfeBY0dCXil797MZc6A4lLg2l13ZH1Zxx9ze+EFVt9FPft0UN9/2czSjvjTkNFe1laakg/Q242+6B6zTFB2D1trg55otBLU4bV/9AID1GjKg8ywFHQEJzTAm8cfmxrSj7TYwMpbhC+drSkTKKwvRGKgE7opHTIY5zeA2sq2COoNSTXJ9volhNz0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(66556008)(66476007)(83380400001)(6916009)(8676002)(66946007)(41300700001)(86362001)(36756003)(1076003)(316002)(2616005)(2906002)(38100700002)(5660300002)(8936002)(6512007)(6486002)(26005)(9686003)(186003)(478600001)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EF5npTyFzccytFTG+P5o07C+LF2gFiYVJWIwjC+JknFS+QblFkxDUeDaxC9b?=
 =?us-ascii?Q?JGA1zSGYjZjJZSLW8QuPL5h8Es7a4xkw9WifNgHVFzYPZOcR6xxRGXRM4y5j?=
 =?us-ascii?Q?kB7HbPWEAqxLFpiYYzred8iCANEdrSXf9b18LFkvY95Vz6UMj0FFou/cVzpB?=
 =?us-ascii?Q?99LL9TeMqb6KJg0JInkJPqVTnVUvIKS7SAmu1Bm9mjJWnzI+cNeUUtJHLWCK?=
 =?us-ascii?Q?RSGbtbNCBy5VmBMEdT34/LRNpIy0zCMA7moo+dWkB9eFcnNnlI0a/G41mONa?=
 =?us-ascii?Q?oqmG7gIKIIN04HBZnThWeR6IdTX/d7svVHx1ICzPV5eyaSPbjxVTjucMScs1?=
 =?us-ascii?Q?ipDTenWdOsIHhVBNjcySOQhkglA36cw1UursNDu7mdsKx8zzLluB0QK2Ybsh?=
 =?us-ascii?Q?Ac6ptkKkS5tMV10ka+VwKdv46Gv/aPWMwSS6//loJUe7cV55yGgOWU0AdCRH?=
 =?us-ascii?Q?a/KZkDNjPIvZe21t3oLkSOu061Jw97rWqSwsq73Z7pK+B5jQG5RsOuVlltmB?=
 =?us-ascii?Q?DEu1sMpd6BWMLOF5no2HDzsXKnLrcJ5JDCPGRk4VS6kZxhlKBDyvEnEUsjqi?=
 =?us-ascii?Q?m/GHZVVJRs8M0jGsPPyxdCxNtr+7Zok0g8en7hOWraLMJrTbKHec6bC/ST4h?=
 =?us-ascii?Q?LoaWmfclUEevMvxd/VFHOy61/OkjxgsR7YvUSMR65VGb8ExkRfeVYb25vRT6?=
 =?us-ascii?Q?ITDveeBG35YB7L0scGIdQxOzzWvJk8fb+EzSlkAcVHmsg0mXMzIGaFErNLDq?=
 =?us-ascii?Q?Fk6VKdpRmBv8HOkcG11IogAfbk1neUbG0vekJLK7D2BRS8kkS8Q5YyZCNi0s?=
 =?us-ascii?Q?d6UKYEHMJkqp2K9FGM6K28kJq06inTXDMLU0aRSW/ihwaCPY+tXrTT+6XMZn?=
 =?us-ascii?Q?1olyLlGMGX66ibc2md5sTdTdRZbPUYELhKhUu/EIWP8oY2Hm2erVgxnOmYLk?=
 =?us-ascii?Q?N9XDUkKTOx7iDPQ7gNEvzSW5CFZ+4fA5u62GwWTjgU4L7aqq2kZIjBfjmnO2?=
 =?us-ascii?Q?a0P781LFcx9pGwdBzYX25tE2iV9AOFYAMz8jQSn4aBVSq7rvS816ps3a5Vda?=
 =?us-ascii?Q?AhTxPyC6e3VVT5WjXDAO3Q0xdX0gqjkZDQavfgkZMW0OH+fZo7rMuPT3y9rI?=
 =?us-ascii?Q?v9VlFsJnRpLCAu3L7NGD8zg21wbXAY7xrUPrphgBSS1RIHqZE1nVfHXuUsnN?=
 =?us-ascii?Q?edSI9JAUP6MRyK8tUYmW4Ikz6LsoQMAMA4HUw3akhLjH7UqNOV1vd1Efjdgi?=
 =?us-ascii?Q?GOUjeYzVDsd7YCnXXYTdFEFCeT2vtrZbT+WytV8PUc8tuVngeCLapFVrc8+T?=
 =?us-ascii?Q?pbVJI6iuDQga3ISpjyG1TReLChKkaXWCsRXqzvbYOLGF7j4VcLblbLlEuzT+?=
 =?us-ascii?Q?++/W5mJsdo+hIB/hTZaLaQ5ZvfoiF3NqZM6iTPLF5b/lzxuCpTrol/6C/Dx8?=
 =?us-ascii?Q?SwHv2jLO1OK2rvYFDTZ3PkxWHvyRMAH/izF7+PyB5jG9SQm3D2wLRNCKGCnR?=
 =?us-ascii?Q?8ZVcfM2WCNAJexsoRUAiLKwDzTJ/hbdowuWt30YbE51nQqjFk5cbrw2QfQzh?=
 =?us-ascii?Q?4+ueWkX1OiZ5wKcCXs3vRQYkuu9pZx3Fmk5DMJ5NxoxFdkJyu3R3mcL6CiYe?=
 =?us-ascii?Q?oQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: pghitven0Xb7aqCMs1iTIrQb1kpt7pW1UMQMfww0inssOC/FF0m54q9PPvygaJ7e1VY90khZ0ra4+B7QrySnaAI/k5OAVGoV2ZbSAeKZUqIiy3dMJ99uP/yOSgc75f1Kt6FisORhjC5PxErx7E5ns3hqGDi5qe4/BArTW3YguPoXtChQKIevN2Jjn/hczg9PF/SjgwHDTWqdG8txyRw82rVGSPHPAqutUanReoeH/JeIJZxtiNdTIXgP/iY8U/tkeU7enqHKuL7EleKNEESVDt7ZJWNMoXMdWwDhfx2bfqmqTFyuhi6JxmfyQl3VxsHD/XZaiyVVr4FuwT7ZQtji4djXGhlp/CFJXVR22RxIoUkQiZD0bh3xajah8ZkuyWPSdcT3H8ooVvgV71tpjipupCW9mz9DrDc3al+IXMhuGA4NWVHiFa2rrVyIyZHVN0Qyb+X5/TThYGxF+29aYyKeG7klEjitsq37etGG1XCil0XZqqlgrUgDIVhIMMFPDXosFCxYzIU5kckuN8ZkGXvypzowfnVobf/3aptqXmJbtq+CcsN94LmBB6708CQh/qTljHQXNC/YpjnAVoPIdqYLfgdyBDnlPu5H91RI/141bWPLvn/ETur27z0ZJPyaxNuTEgZwvu+29CY8hGtX7g9AzzKBmMPHso9N0myvZ4nDXmoG4F12t+Ladi3FgrWoSioU4t0v3fDWQA+nR2gbBuR3/6xoYz0IdDddTju0OkR4rdYMHmlQoHC35VRUxJIrBWC4ftp/faSGTRvUsdI2bZ1DMA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3072039-dae6-41a6-9d96-08dafdab77ab
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:51.7347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pWdJZDPReekGV05oRw1dAYF+AO1tS9eLWtteGuBB8oXaKuoDPS7hH/ot6kU2JyefpRhpbqAs6IFNFzEZSoVRssOpaAKSU3nbQoXkIlrxbHE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240010
X-Proofpoint-GUID: aXmO0zk8rZj9UZKV2vTgAT8nmIXO9NrK
X-Proofpoint-ORIG-GUID: aXmO0zk8rZj9UZKV2vTgAT8nmIXO9NrK
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
 fs/xfs/libxfs/xfs_parent.h      |  4 +++
 fs/xfs/libxfs/xfs_trans_space.h |  2 --
 fs/xfs/xfs_inode.c              | 44 +++++++++++++++++++++++++++------
 6 files changed, 60 insertions(+), 10 deletions(-)

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
index cf5ea8ce8bd3..c09f49b7c241 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -125,6 +125,23 @@ xfs_parent_defer_add(
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
 xfs_parent_cancel(
 	xfs_mount_t		*mp,
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 9b8d0764aad6..1c506532c624 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -27,6 +27,10 @@ int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
 			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *dp,
+			    struct xfs_parent_defer *parent,
+			    xfs_dir2_dataptr_t diroffset,
+			    struct xfs_inode *child);
 void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer *parent);
 unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
 				     unsigned int namelen);
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
index ccc61cf0f9c6..f593f0c9227c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2471,6 +2471,19 @@ xfs_iunpin_wait(
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
@@ -2500,16 +2513,18 @@ xfs_iunpin_wait(
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
 
@@ -2524,6 +2539,12 @@ xfs_remove(
 	if (error)
 		goto std_return;
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent);
+		if (error)
+			goto std_return;
+	}
+
 	/*
 	 * We try to get the real space reservation first, allowing for
 	 * directory btree deletion(s) implying possible bmap insert(s).  If we
@@ -2535,12 +2556,12 @@ xfs_remove(
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
+		goto drop_incompat;
 	}
 
 	/*
@@ -2594,12 +2615,18 @@ xfs_remove(
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
@@ -2624,6 +2651,9 @@ xfs_remove(
  out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+ drop_incompat:
+	if (parent)
+		xfs_parent_cancel(mp, parent);
  std_return:
 	return error;
 }
-- 
2.25.1

