Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD47C74A44
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjCHWir (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjCHWim (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC325ADF9
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:36 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328Jxuqj026675
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=aIrrq5Azbsvh/zFXYxZRoVztWXpR4KrBZY4D9aFuMw4=;
 b=fmOme2MZFaq+tSoyTiSK7/0wEu8xNeuK60rWh7aggggPHzP83ucRy1i02LNMZOrcUn+k
 VFvY+j+0s76mvLqIqldxXVPe0wBb60RTdYkBIS6vRdNBurMKjEFMFBinMrKM9Qgo/Qku
 DmA4G+IBY4tdUElBALZUy3Ar4M+355ez+944IZdLpMFPwy760kl+X4KW38ik3qQntqcg
 1J2798HIAFZ/LE266WUGU+b/VGFCie9d3QlyajkhVH+VeT+YqnwW3pvzamRG1iKJQ7gt
 QiK+h7Xpu6IIJN8DQ8R4UmwSTaeL0oNleEjCsMphI2op9tFd6H8p+mbLj3V6ciqclyIj 4A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p5nn95qeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328MZ0Jf007322
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:34 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g4gd1tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VoXxssuZFLSEAhlcFsJvKfAiQL03MvQW/8PUlzX71sQVj+vXtUAKquH3z3bLS3J8bP1ciR7ufyZOJTLFKlGz7m+A2OejjsTfgIXFA2Uu4EayKFrFoAeibgIfvSlS1XfFSeGrVFG4iwgXzDqHMgDUcMmmhF5LY/XfqipegL/9N+rVlqmO+bmOBeKpZbgII+o51uUkEwbuUpnA7OHIERZDLtF29I3/NIEXJuxzMhCA608d+YyfN9bfOGUQ3GIBbcyMUSfXlVKg23L19c7CsPY3x7l3+EPFITImGoKPo8cjN60N+uEaKGqEDgoUPbc8YnF1jZvDPxELpbWpJj/X9Jfc8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aIrrq5Azbsvh/zFXYxZRoVztWXpR4KrBZY4D9aFuMw4=;
 b=BJy0vjk5K4LmQnGknB7i/bICuc/7ADVT3ejvfgLo7qXJBUMPiwWp24v6diWrFLk/rja//Qbdu39NYQe+JWEOE+pPbzVB//V9y532kt6P+cIMITNYc7k7Pt9JkINn1d2VGpIbPNS9IPCMbM+lM5PSVSxUMRFixXU7Qo9AoVtR7huIMd7l+wv1EKJnpxv6dsEjco9RAPfSwfCI7MTC1GxSh363fLB4tA6TCAG2BYwL4k5FXUvckd2+zInIauZDK60UTDRZDeyXmh/sIhtT81FmXc988y4f12RFngrSHjRoQbwFEGGdVZ6u+keD+hhwr+9vHUJRi3GeHein/JZL18GKQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIrrq5Azbsvh/zFXYxZRoVztWXpR4KrBZY4D9aFuMw4=;
 b=lbjEmAaRPqzoqRn5L2B6flBgkt4mnPxX6Iv1h79lFOvUSdbdkTO7slgqbgrrNmD0BjUt1MiLJFXFCHWMc7h3Qe7W1nKVHl//fUOR6ghj0UpS87sCP0IsmCJlHEyBWsIn47BP6clhZZdfPd4tUV8uLMZ6ajuYX+4tQ3glMnFO+A4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7102.namprd10.prod.outlook.com (2603:10b6:806:348::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 22:38:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:32 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 20/32] xfs: Add parent pointers to rename
Date:   Wed,  8 Mar 2023 15:37:42 -0700
Message-Id: <20230308223754.1455051-21-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR22CA0002.namprd22.prod.outlook.com
 (2603:10b6:510:2d1::26) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: e0a839db-5bbb-4670-b74e-08db2025d8c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Us0apxRwiZzcix5bDvfiMDHinnKDmIp5+on5C+yBgxZqqnUl+fCaF4tPF4zD2Qki0Tx2lpHNcKBgrv3oh4P440k7F9/+yVTn42kJiImv18rQ3f0nvfGN+UUCdMLtz9lVMhH2XlGQj907AHwbJDOsgwfL4Y0RxQ0QV7nk72l3JOUecQoGSIxyKYq70K/27ljwLviGx7OuL8zSVJIC7fKKtHgEiibD+BN2SfT2VMCSjAS4DVEOnL+9j8hzNAfijradzXAhOQDoNFDm7h04hFASYCm2LpkM1Cvwmq+v36WbeHA+1bWNqM8Bn9bztVCPA0l1PXd6X/dA3jpTe8IqPOouqdfLmZyZ/S/uh4OrOeqIl+8wJj3lmCPZFRmzVd5qpQ7cKk0qb66yN7Jvv4eUdCNaNSuVBMf06jSmyOkeC6c7NW9lbzLZZZV3SfZgjA8uVPKy0B+SWBJbnZ42z7qF2DE9PdgbfvEeMXCLou2f2qQEyqplN00XdC7drNBTEZig21P0xJFPcAUoD/XgKmUNUAijHCBBj99zQSk61Edn7INOTVwWFHQ5vBpMFIp8aD151mzs8TD3oJUw1ajwDnVVa+BXQiIG4obnimyufwJjKEcBLD3UXQwSYzdne7BU7/Cg7yJzrp6PKu/4yc2mwsSkzR5LRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199018)(36756003)(6666004)(8936002)(6916009)(41300700001)(8676002)(66476007)(66946007)(5660300002)(66556008)(30864003)(6506007)(2906002)(38100700002)(86362001)(6486002)(1076003)(6512007)(316002)(478600001)(83380400001)(9686003)(186003)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G/8QDjUNrF7G2JQs4YYU8R2EHDtT7ckU7o69A4dr5fXwhvP8FoFnpOmwxQGf?=
 =?us-ascii?Q?uwPiYOpObYRMYKKtSjuDZDplSXKcLWZKEp7jCV3BYsYTWHINEv2WL1yMNjFq?=
 =?us-ascii?Q?GzMdx/u4IfI5VXaT83gfuRBzvytmGuTljVmu5KnRmnb6wL8lUFcUM/YTVNDS?=
 =?us-ascii?Q?hS5QbuOTQJzaeB2g9zBfYRc/9TG+iPe7irSQlBnNjwF/kIffLktcR/4CvurU?=
 =?us-ascii?Q?4KYNdfAsvEf0BhHwD31vq0QXQ8/u/l5Wy8B8nj0w2rp7TsIR6EXqkvFyT+e5?=
 =?us-ascii?Q?Qwavt6c6FtfL72SU9WE807wgNf+jhqaS1PKUibd3KOQFt+03RnyFevc4NgyP?=
 =?us-ascii?Q?9OyM7J8rFG1lhZqk2YpUMTmwMba2Btt8auBKGA4/a+wV200xuuOhChoRseJ3?=
 =?us-ascii?Q?wJbKvXEqW4WFXTjo6di/SWGiAzk0jm8K8ITdGDVUWudzJZMklsLi880Oc29R?=
 =?us-ascii?Q?DFp88nbDzLVU3COlZ9jZfYQaIV9PrXwImwqXz8HksYz6lEd7/mUV/0NxUmbp?=
 =?us-ascii?Q?Dgur6RvRppCZV+wWDdSDx2a749ZCouapYrYX+OeFGNNvP+8t3L1aQuFgfe3c?=
 =?us-ascii?Q?6Ys4auUp7uaiWGL//aiFLIyvljLAFejrrWNRYJFXhyL66EMdaU8e8tu7lUHO?=
 =?us-ascii?Q?YOslB/5k9snH3dCFCWhV55B1rbaySJq9e+yVyWhYzXLNrqhiQdLm39jyLSmI?=
 =?us-ascii?Q?/xOuCQ/Ao9vMZdC7AbT9l7MLKDc40hBnuiK0gwV7EgnLdNkuFX+4y50hJfve?=
 =?us-ascii?Q?k8e7zQGs3/AHXIfO5GGg86Yr2oOc9oyiR3MRzVIpLcZqA+lwnqdTrZbCp172?=
 =?us-ascii?Q?ISJDEI1yfNKVFNCfR0AxLqH5wO/JWhahTgQ2E+VGGRy9EydsPjfiZv99UHSZ?=
 =?us-ascii?Q?2HiY5O9ele6gfDwHbz677sDDk9WWs2ybKkWa3Pi4eNfn3s+kP3ZAJp4HxNM5?=
 =?us-ascii?Q?GmZZsWHQXimQ4SHGgeWkR+bwCgNpNv/0khy0KdqEdiZ5WYU2+Pdx9qTzsOua?=
 =?us-ascii?Q?bf3xhva/EQNZe+ccQ+dW/Yt3skKPHmP731mOREzS+ffLs4WjRNTpAN86e3wk?=
 =?us-ascii?Q?eEiKbkb0jsYKhJyKZlMgjDCP0GI3z6zFhj6Gz3GXY56d4ciSwxSlCfiPX4gE?=
 =?us-ascii?Q?FPlJqVynD+KPh/Zk+uy0yr/P/RM50oIn7lNohFqTeBJsX1sZTw9CQ8jR8Iws?=
 =?us-ascii?Q?5zHJ1cdFfMr4Zx54yYti10aeAIuRnVLm5sD54yFgRgXF/Oqp3devRKR+TvB8?=
 =?us-ascii?Q?LobNhf9smg8O7DFR6h36cG4crMzYFEwd+zEhw1q12EczNghcDeZth46YViq8?=
 =?us-ascii?Q?0Xk3yFdJHzCfD3/voP/UmUDoaT/s+K7KsfE16qTZlUZ69wBYyvUnGbWZ+cDA?=
 =?us-ascii?Q?AAxzdA4nYvyEvKHA3ZutgsIvTa91ie8j0krbzvFKudfn/byoEQSx9kWKOsSN?=
 =?us-ascii?Q?SNhb4f0vFTr1eVkTg/FRXb+MOYz2BYXOQ9mf1kFBC/kjwrN1AI04O5GYzYYl?=
 =?us-ascii?Q?1Ali7Kq3ZuQNC57EIpqrdu94R8AFkU7m2f3uXqH+tckqCJ0z49//Htn5W+rq?=
 =?us-ascii?Q?fmKHXEQ+id4H42VZY5tVVidCKANkHjogYQYuMzVmqqrbbD3ADaQX0iD8DKX8?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XAHHKDQUX5Y1YHJb4K5BTGRd3roVYtG1sWbI835UoDl2QLctvdKmqOzyUq6/c3kxTsbxIPoG77pKGQVQK8Vb636QLKRHwlW502TJhz4mxKl97EfNsMrP2et6JyAjjpVWociu2X78AG4zJdKuBRWAERhNPtkNgq0LWBCphjnQXHNPZRZEvCG+EpPmlOn2LlLQCuKcqY/vDxM/YxbMP/N2A63jm5JvyZEW86xvSHUO+kuyFLdZwkuRXJCEz5DVGfvgByN6Dsti3RPcKjjLSxWTuWA5wocvTJWy3LEc79qevEMyXSVDyDO4ViYOI4yapngCnhO1vLwfDSwxga9Dt5pcer95DixpvrcAco9IanP6GlqZD+AZ9tlhZL2gn0RSN1vFUSzGGgGrbPIfhjJD07EBg8G1z4ILlUzDfPKNHlQj/0lB5I1dTa4t+jOIV6U0iVbMV49PSYdO0mRcnR7a8pDy4zdHSBfX+kBFR8GG6DdzJE2mHIpMfi0GuJH7W/iqVBM8QESSDTlbCzoysPsQism7bmHcbX0Ect+H7pZVhDCxx8n3gF/R/HKe5I7pLlqoScNTiM5N3iSceAqJvHWDcwAg2AEVF927Y+1HMRnZbOhSyL+vmAHqwuF7NlPCgre/LhOjcpKnUl0nbE/aseNb70sUq8U7X5pM0uUjlibL7I2aGcYC5YVRtJeehNyHcViMp6NqIfEn1ddmUz124MK+cl2mQn0iMX/tmJ2HTPte6wHrm/SUFRjZgBIwOlK7XXtlkYzh+Y7ifm1NbRsEza6yvv/k5Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a839db-5bbb-4670-b74e-08db2025d8c2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:32.7294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ew4jUhkxfbEHM9TUaID6h3iFN4hM8xPNUIp1CcJxC3ER8r6Me3AxUw7w3dzXSLKmtIXritCgSu+l3M8lENTgs7WMH81fmiy6hl4679dfDrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7102
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: 2kYt3YqqkDmpdziRnR0sVTkx4DT4d04C
X-Proofpoint-ORIG-GUID: 2kYt3YqqkDmpdziRnR0sVTkx4DT4d04C
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch removes the old parent pointer attribute during the rename
operation, and re-adds the updated parent pointer.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        |   2 +-
 fs/xfs/libxfs/xfs_attr.h        |   1 +
 fs/xfs/libxfs/xfs_parent.c      |  47 +++++++++++--
 fs/xfs/libxfs/xfs_parent.h      |  24 ++++++-
 fs/xfs/libxfs/xfs_trans_space.h |   2 -
 fs/xfs/xfs_inode.c              | 117 +++++++++++++++++++++++++++++---
 6 files changed, 174 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a8db44728b11..57080ea4c869 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -923,7 +923,7 @@ xfs_attr_defer_add(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 033005542b9e..985761264d1f 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -546,6 +546,7 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_defer_remove(struct xfs_da_args *args);
+int xfs_attr_defer_replace(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 245855a5f969..629762701952 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -64,22 +64,27 @@ xfs_init_parent_name_rec(
 int
 __xfs_parent_init(
 	struct xfs_mount		*mp,
+	bool				grab_log,
 	struct xfs_parent_defer		**parentp)
 {
 	struct xfs_parent_defer		*parent;
 	int				error;
 
-	error = xfs_attr_grab_log_assist(mp);
-	if (error)
-		return error;
+	if (grab_log) {
+		error = xfs_attr_grab_log_assist(mp);
+		if (error)
+			return error;
+	}
 
 	parent = kmem_cache_zalloc(xfs_parent_intent_cache, GFP_KERNEL);
 	if (!parent) {
-		xfs_attr_rele_log_assist(mp);
+		if (grab_log)
+			xfs_attr_rele_log_assist(mp);
 		return -ENOMEM;
 	}
 
 	/* init parent da_args */
+	parent->have_log = grab_log;
 	parent->args.geo = mp->m_attr_geo;
 	parent->args.whichfork = XFS_ATTR_FORK;
 	parent->args.attr_filter = XFS_ATTR_PARENT;
@@ -132,12 +137,44 @@ xfs_parent_defer_remove(
 	return xfs_attr_defer_remove(args);
 }
 
+
+int
+xfs_parent_defer_replace(
+	struct xfs_trans	*tp,
+	struct xfs_parent_defer	*new_parent,
+	struct xfs_inode	*old_dp,
+	xfs_dir2_dataptr_t	old_diroffset,
+	struct xfs_name		*parent_name,
+	struct xfs_inode	*new_dp,
+	xfs_dir2_dataptr_t	new_diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &new_parent->args;
+
+	xfs_init_parent_name_rec(&new_parent->old_rec, old_dp, old_diroffset);
+	xfs_init_parent_name_rec(&new_parent->rec, new_dp, new_diroffset);
+	new_parent->args.name = (const uint8_t *)&new_parent->old_rec;
+	new_parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+	new_parent->args.new_name = (const uint8_t *)&new_parent->rec;
+	new_parent->args.new_namelen = sizeof(struct xfs_parent_name_rec);
+	args->trans = tp;
+	args->dp = child;
+
+	ASSERT(parent_name != NULL);
+	new_parent->args.value = (void *)parent_name->name;
+	new_parent->args.valuelen = parent_name->len;
+
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return xfs_attr_defer_replace(args);
+}
+
 void
 __xfs_parent_cancel(
 	xfs_mount_t		*mp,
 	struct xfs_parent_defer *parent)
 {
-	xlog_drop_incompat_feat(mp->m_log);
+	if (parent->have_log)
+		xlog_drop_incompat_feat(mp->m_log);
 	kmem_cache_free(xfs_parent_intent_cache, parent);
 }
 
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 0f39d033d84e..039005883bb6 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -14,7 +14,9 @@ extern struct kmem_cache	*xfs_parent_intent_cache;
  */
 struct xfs_parent_defer {
 	struct xfs_parent_name_rec	rec;
+	struct xfs_parent_name_rec	old_rec;
 	struct xfs_da_args		args;
+	bool				have_log;
 };
 
 /*
@@ -23,7 +25,8 @@ struct xfs_parent_defer {
 void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
 			      struct xfs_inode *ip,
 			      uint32_t p_diroffset);
-int __xfs_parent_init(struct xfs_mount *mp, struct xfs_parent_defer **parentp);
+int __xfs_parent_init(struct xfs_mount *mp, bool grab_log,
+		struct xfs_parent_defer **parentp);
 
 static inline int
 xfs_parent_start(
@@ -33,13 +36,30 @@ xfs_parent_start(
 	*pp = NULL;
 
 	if (xfs_has_parent(mp))
-		return __xfs_parent_init(mp, pp);
+		return __xfs_parent_init(mp, true, pp);
+	return 0;
+}
+
+static inline int
+xfs_parent_start_locked(
+	struct xfs_mount	*mp,
+	struct xfs_parent_defer	**pp)
+{
+	*pp = NULL;
+
+	if (xfs_has_parent(mp))
+		return __xfs_parent_init(mp, false, pp);
 	return 0;
 }
 
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
 			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+int xfs_parent_defer_replace(struct xfs_trans *tp,
+		struct xfs_parent_defer *new_parent, struct xfs_inode *old_dp,
+		xfs_dir2_dataptr_t old_diroffset, struct xfs_name *parent_name,
+		struct xfs_inode *new_ip, xfs_dir2_dataptr_t new_diroffset,
+		struct xfs_inode *child);
 int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *dp,
 			    struct xfs_parent_defer *parent,
 			    xfs_dir2_dataptr_t diroffset,
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index b5ab6701e7fb..810610a14c4d 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -91,8 +91,6 @@
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
 #define	XFS_QM_QINOCREATE_SPACE_RES(mp)	\
 	XFS_IALLOC_SPACE_RES(mp)
-#define	XFS_RENAME_SPACE_RES(mp,nl)	\
-	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 66d83bef4352..f069556c8dfa 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2871,7 +2871,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(idmap, dp, S_IFCHR | WHITEOUT_MODE,
-				   false, &tmpfile);
+				   xfs_has_parent(dp->i_mount), &tmpfile);
 	if (error)
 		return error;
 
@@ -2897,6 +2897,31 @@ xfs_rename_alloc_whiteout(
 	return 0;
 }
 
+static unsigned int
+xfs_rename_space_res(
+	struct xfs_mount	*mp,
+	struct xfs_name		*src_name,
+	struct xfs_parent_defer	*target_parent_ptr,
+	struct xfs_name		*target_name,
+	struct xfs_parent_defer	*new_parent_ptr,
+	struct xfs_inode	*wip)
+{
+	unsigned int		ret;
+
+	ret = XFS_DIRREMOVE_SPACE_RES(mp) +
+			XFS_DIRENTER_SPACE_RES(mp, target_name->len);
+
+	if (new_parent_ptr) {
+		if (wip)
+			ret += xfs_pptr_calc_space_res(mp, src_name->len);
+		ret += 2 * xfs_pptr_calc_space_res(mp, target_name->len);
+	}
+	if (target_parent_ptr)
+		ret += xfs_pptr_calc_space_res(mp, target_name->len);
+
+	return ret;
+}
+
 /*
  * xfs_rename
  */
@@ -2923,6 +2948,11 @@ xfs_rename(
 	int				spaceres;
 	bool				retried = false;
 	int				error, nospace_error = 0;
+	xfs_dir2_dataptr_t		new_diroffset;
+	xfs_dir2_dataptr_t		old_diroffset;
+	struct xfs_parent_defer		*src_ip_pptr = NULL;
+	struct xfs_parent_defer		*tgt_ip_pptr = NULL;
+	struct xfs_parent_defer		*wip_pptr = NULL;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -2947,9 +2977,26 @@ xfs_rename(
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
 				inodes, &num_inodes);
 
+	error = xfs_parent_start(mp, &src_ip_pptr);
+	if (error)
+		goto out_release_wip;
+
+	if (wip) {
+		error = xfs_parent_start_locked(mp, &wip_pptr);
+		if (error)
+			goto out_src_ip_pptr;
+	}
+
+	if (target_ip) {
+		error = xfs_parent_start_locked(mp, &tgt_ip_pptr);
+		if (error)
+			goto out_wip_pptr;
+	}
+
 retry:
 	nospace_error = 0;
-	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
+	spaceres = xfs_rename_space_res(mp, src_name, tgt_ip_pptr,
+			target_name, src_ip_pptr, wip);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, spaceres, 0, 0, &tp);
 	if (error == -ENOSPC) {
 		nospace_error = error;
@@ -2958,14 +3005,26 @@ xfs_rename(
 				&tp);
 	}
 	if (error)
-		goto out_release_wip;
+		goto out_tgt_ip_pptr;
+
+	/*
+	 * We don't allow reservationless renaming when parent pointers are
+	 * enabled because we can't back out if the xattrs must grow.
+	 */
+	if (src_ip_pptr && nospace_error) {
+		error = nospace_error;
+		xfs_trans_cancel(tp);
+		goto out_tgt_ip_pptr;
+	}
 
 	/*
 	 * Attach the dquots to the inodes
 	 */
 	error = xfs_qm_vop_rename_dqattach(inodes);
-	if (error)
-		goto out_trans_cancel;
+	if (error) {
+		xfs_trans_cancel(tp);
+		goto out_tgt_ip_pptr;
+	}
 
 	/*
 	 * Lock all the participating inodes. Depending upon whether
@@ -3032,6 +3091,15 @@ xfs_rename(
 			goto out_trans_cancel;
 	}
 
+	/*
+	 * We don't allow quotaless renaming when parent pointers are enabled
+	 * because we can't back out if the xattrs must grow.
+	 */
+	if (src_ip_pptr && nospace_error) {
+		error = nospace_error;
+		goto out_trans_cancel;
+	}
+
 	/*
 	 * Check for expected errors before we dirty the transaction
 	 * so we can return an error without a transaction abort.
@@ -3122,7 +3190,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres, NULL);
+					   src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3143,7 +3211,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres, NULL);
+					src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3216,14 +3284,38 @@ xfs_rename(
 	 */
 	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres, NULL);
+					spaceres, &old_diroffset);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres, NULL);
+					   spaceres, &old_diroffset);
 
 	if (error)
 		goto out_trans_cancel;
 
+	if (wip_pptr) {
+		error = xfs_parent_defer_add(tp, wip_pptr,
+					     src_dp, src_name,
+					     old_diroffset, wip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	if (src_ip_pptr) {
+		error = xfs_parent_defer_replace(tp, src_ip_pptr, src_dp,
+				old_diroffset, target_name, target_dp,
+				new_diroffset, src_ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	if (tgt_ip_pptr) {
+		error = xfs_parent_defer_remove(tp, target_dp,
+						tgt_ip_pptr,
+						new_diroffset, target_ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
@@ -3237,6 +3329,13 @@ xfs_rename(
 	xfs_trans_cancel(tp);
 out_unlock:
 	xfs_iunlock_rename(inodes, num_inodes);
+out_tgt_ip_pptr:
+	xfs_parent_finish(mp, tgt_ip_pptr);
+out_wip_pptr:
+	xfs_parent_finish(mp, wip_pptr);
+out_src_ip_pptr:
+	xfs_parent_finish(mp, src_ip_pptr);
+
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);
-- 
2.25.1

