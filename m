Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B0EAC76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 03:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjDKDhX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjDKDhW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 23:37:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD830EB
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:37:21 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AK1OeH026551;
        Tue, 11 Apr 2023 03:37:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=65cjwmfOuTo4nzXM7aYG9D2EXPvQcneTTdpCrcE15xQ=;
 b=JIMqRLvg8ikq3b9j4KwXmZMxzo+HmRePjrmjiC8t9Re3SS+wPsQnhWXFMZjVaqxXlP0w
 o/GRwV0NBpQIGf40GNUdI43QIQkIEqenrJe/JaRkj0vFIFkvzqM4yWVO/b9UtZbwI43q
 KL5jDQyxFoIU0Y+y7SLNZEquaPwG1sA+CUp2wKob3NFruwZkRTUxw5o7eitdTl9Dba8u
 Cw7Na4XT2/wSgqQa0NYVenuehFxLyMcZuV5RmPqYy9MYdkbl/cxFKjg3NgwUgevaoNFw
 AaN92sSs/+bUVqnota6o4T953ClQt4C9vMErOVdcsf/Vx+zgeAIEjm21vMYmSEcBdwyg 4w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0e7c8xy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:37:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33B2nv0h038272;
        Tue, 11 Apr 2023 03:37:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw861m8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:37:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QA1FeQjEM0ESIem+pqTCPfAy3Orx198HrDtA2SfdSGoPUwcsDfwuWdeyQwKFhnade7sFJZKgBUiJ6RBvWqAlh4Hph5/bgU31GMfd/gWD+7ZXPkYWjK4K7Aa/vw7mezTwdkORZpoNazNk18Z89MVgw/m600WsH5SYI6opkZjcFl9PeEKvJOPUhRGvgS7yKHUuS1sjRHzvFFrJXWChzKJ6sNuecvlmRaGnuqs9FA3ey+6frLne3EqvI8ysd/gt1MWefXrPeA6dOAo37PesnJ6NX6MPXpR5B2UZ2NtifVQjEa6R/mI2o0O8vC2Zje9gleOgs6YG2ed1s7m4l9kX3QBUDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=65cjwmfOuTo4nzXM7aYG9D2EXPvQcneTTdpCrcE15xQ=;
 b=m5bm/3D20mB7se4+HlPJCAnrpACSZ4c2P9dKcqgigIUC+4ZeRBUayY9SLClWH9PTApqXzZzl3eC20kmV/BCb6us2NlJ/QVzyCHk01uEQLTbWojP8s5zgU7K+689txtRjP4dislaZdDhbS2v4Rv4u741Oi/38Zhr1cJgG2seXUVWYEr37e8FMLVYOUHON0f7Ixff0GI/aJmuZbHWGIU3GmjIxhZ8Lw4fJcC3hxj5Mtjjoju/MV6tXDLOmH10eDcuQN/xN+wYaZvaf0UVZjb6hFdPZEfdrNx2kVEz1FQgjpuJ2bfP62GqMjHRHCJxutArGpCeu1its6nYLHoIPvTpEhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65cjwmfOuTo4nzXM7aYG9D2EXPvQcneTTdpCrcE15xQ=;
 b=TXx8HLqO16hMUQdh6x+M5VbQHKWw8g1uJbMqzX2Gy8cdCA57W8qLcj+h6Pd2JAzo7G782in0ofOEwYFp7fkqculhEl2VGBYlaG4MVWfgp0Pe8awujzKbtVAlgWq/0YpEOvmirnNXMD0p5F6QNC2yVFNbwSwpTJCAnfPXSSxdPe4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BY5PR10MB4338.namprd10.prod.outlook.com (2603:10b6:a03:207::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 03:37:14 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 03:37:14 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 14/17] xfs: shut down the filesystem if we screw up quota reservation
Date:   Tue, 11 Apr 2023 09:05:11 +0530
Message-Id: <20230411033514.58024-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411033514.58024-1-chandan.babu@oracle.com>
References: <20230411033514.58024-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0016.apcprd04.prod.outlook.com
 (2603:1096:4:197::7) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BY5PR10MB4338:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a9d3cce-ce4b-4ac9-faeb-08db3a3e0a71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VS4Z2EIlthGzKNtxcNEx8y98vHLC/WGPY6iSrTjL2AHxroTEj7dc6wftOWgHmdkP1LzRw9ljBZTGnMJBeqWfTj9a8Z1aV6P8S3nEwOCWYYeQa+gvsnVHTwIxbCwox19FD3Zp/LZ7gwf+Ww5A8KL8sWA4OgyLXWTuS4RoBVEdH4Oj3Usmmgb8yZ+KtGSjg73WO7y3MnHr+Od5ar6rAFg4pDMUy5IIIJy2++Fifogetan+KSlPMFcwVpgKSdfBuNijOl40CcJzVZngB1id6SPBCZuNeLeSMCcpodT4+pf20uJ+ZOvUHgY/Lo6RWShJbyb56s2lqoyhXzHfLQVy3rAvDCBsfNPHlNKjRyNdtEBF8ln1CDBWPz8IVdTB4iWLApitIj9FfRcpCXwIipLcbmuDzclFxKln08K/YMABgPQfEl1j7V/mqBsc7I/6VHcQKqF7M8EFam2/yc5kskqfSIQZ3RHnCYmKVtxMJIhdJ+CLvjxp3Fm8A1JWB80rL/kMAXvPhVyitf1zhvrimgL88KZVEA1gBk3VDO2S4cCJH7muMhHveNxOF1j3l9zE9xRj2mc5+SCtOWWgdYPiMPwZygL9kO+DMmfkQFWLcteldvKinFk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(478600001)(1076003)(6512007)(316002)(26005)(6506007)(186003)(6666004)(6486002)(2906002)(15650500001)(5660300002)(4326008)(66946007)(41300700001)(8676002)(6916009)(66476007)(8936002)(66556008)(38100700002)(86362001)(83380400001)(36756003)(2616005)(15083001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dp9ug0L2bgpQpetp78ZZwAkMOHQj/A2A9gQvnH3GdIHu8kUz+tcgaXJdMxy4?=
 =?us-ascii?Q?JA3Eht5zZcQfqmWF/PnLctPI9VxgePfZK85VCw2qmjY1yQuemPGeXSenIbcz?=
 =?us-ascii?Q?F0G9vpSIHJpCBU+vo/8luuakqNKPHjyEujrCVcnBAxZE8zeapDLhgwvhZti5?=
 =?us-ascii?Q?WF+52cymN73EX2pe+6qdiP+B0AWVr8hzysYnnOF1/SEck0o/9rwjr6y21fOw?=
 =?us-ascii?Q?IPfv/LOtqMcBwPCPbM5WZfsaTDj4KYjPSO3FQYRyaSd51czX/C96YrlrvvYh?=
 =?us-ascii?Q?aC2Sm3LoLBXkm5+T/nBdhmx4fkz17i9PnL36ZohrBx1b1PTCmnGwFycLpec6?=
 =?us-ascii?Q?vl/ZW55LBM4m2atTGqPe7bB4whFviWIC3CzqIno07124e/wXb0RuqsVbMIVP?=
 =?us-ascii?Q?E99SrV+cQ0ls2XyUZy7ppt2SGIuN1uNZGKKyK3oYxVTQZuszn/LHOrfw3+le?=
 =?us-ascii?Q?1yQWqDbyKoiyZUAzhh9X9FlPqhDYPj9f3NgEgydaaNqbCJuoF54vBoDpupwc?=
 =?us-ascii?Q?xYOYozceWZXXtIDQZSiBAm5zpGeGYSmWjtGdMuVYM3oKUTNN/aTjgPVg68IB?=
 =?us-ascii?Q?7+y2pP9HunRO+zwBW9UuCREGFfdgg/gFXxY0gNPx5IF/YPmilBhmj9J1UZNw?=
 =?us-ascii?Q?Jjorl5mQSoVw6cF6qg+2kIPSvg15LC4XKAu3aVGSq30f9kTkI3Lv1pqRrYib?=
 =?us-ascii?Q?S+o4aEKwqrtKbFxKU0VIEm/cVNNq1dz7X4W87i4Cg4zaWIzv6U7r7B7raA5f?=
 =?us-ascii?Q?OZqyKtQ391ys6bJWnxhE+2AvJSHu8VW+lfJ37I/F2n4WjTSZmJw6RyMfdcu7?=
 =?us-ascii?Q?e+zm4G2oaj1eVSJmOW2xqxcqrPtu+z/nTY9X60tMAVTtUe4EqCkI1P6k4lEr?=
 =?us-ascii?Q?LPU8rg9IrZ1ymt8NZAqJ+wkvJdi+RKdHWUEZAARmmQ4fUTBbIop/yau6BMg6?=
 =?us-ascii?Q?OobFjdpHDUbwQAkpp7zGIcMu/ktQ+e/Xx27NuuOKQK57JLdJ00Vn/AwjK+sh?=
 =?us-ascii?Q?uDSMfzYbBScwyWjvSc/57+zBs1rm+g3Pyh61Mat1x207btqOKn+L/n8DfBQg?=
 =?us-ascii?Q?VY1pbCkd8+KzuHUvy40XhUEmHPxMXT+idQtHkU7q63mcsOkphmjIAvfQldAS?=
 =?us-ascii?Q?+t39W1oypIqm7t0/nS5HyTGLpc+bhmlUBkbkFxLIJjHVpnvCZfvzIQGwn2op?=
 =?us-ascii?Q?lNay4FQ2ZeslUGMKBoeY4SOgVRWmFTpsuHZ6b6mH6kp5+oxH7VRtwhbSrzjO?=
 =?us-ascii?Q?m+oNgphDucTLDlRdq1+GGFJ6NYvmXCb9PJe53oNRhOKa5xweg7uNJx1TWt68?=
 =?us-ascii?Q?HrrOoOyDZHI6q2nECQVYL6lRaYaHldKxQ2Zd4FlwrUargDzT0J8MdRu2sLbG?=
 =?us-ascii?Q?zmweL+Zpl16LgA1wIpJNFeIUP+bpNcqvaO+hxj1D1eE3ETo/+P70aZ11Nl+c?=
 =?us-ascii?Q?/dzh373q/5vzlKl9GCPr+WXpeFGSdmT665iFCB6tN6lDN7fPf3KzOrw1IYKB?=
 =?us-ascii?Q?5UVjmjMGeOgT/bl+qRVWemfGmlM0t/rHWSAVPJbW4nEGu0EtBqsNRCBqOseA?=
 =?us-ascii?Q?ILPKUtcQnSDwevAB/Jn+9cylRKA/vlAadZx8PfjDuL19Y8K4nUoqpb29mBg1?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: EduLVFrSnPjsqZW+xeeigEyfmHqu1O8hqdK0J2FLi0aYVMN2PThv3jy3gqzh6VLjmCDv1oWYAfMGbUkL87s6OhLBMi+Z1KgFmnII60oy2wdtVQmux6uFOhyg42ttNnQ0EvD7r0DsJcgTvtBslTHXy6giEp5Rw5TO/TFt9CmO78Ei9GWClfv6PwQMP9zK1SLDG+T8NU9rIubiA5s4LmDrIftvEspm0RpIiroHP8ipmA+3G1o7pfylDLL80AKqt7qMwZV71oSNcnfR39veYt+OTiAXkXVSN9UtSjLIUymdSDBS9a3Uw8twVX+P3y/27E0Nxuq/gHzI3sL7GV+VcX6pyPd6vopuRKruuOiodEtgN2BJ7QFIOqxoAPZS7ornPUAzCZe0iVTvuwi+SQIbF50t4t0jC70xt3eW3YDNh8kBNcqcUjRrmIL5rjYmehDj+GXiZpHHO/cXtQZ5P3Zi4LFVWXfPhIz1hB7ML4YumZXQ7IWx1k12Pie8haVO67LsBa+eSVfrXrv3yt7EvICsRvEktEzu9TBSskrxXoM8DwZfNS2UuzZdAwl3/4ouuI4+zyVnRtto9HyNH9OVXQINCqWwA1o+OBgRl4M8ru+XZpUfY3jBzYS5y0kne5emX5fNNuxQ1yoB44yxa6oUOSDVwf18rgb+eSNF1vu/w6ApEgG6ssTXp8Sxt6b3YpY2OQK1UtWWeOCvGps+85tLLiPo9vDznlvaUeHDO+zx78fBaOWnKeoLy1qQCF+jSwO3wQ0k7LJotKCSwmPnrE1kyUDJHAT+4oNrOQsa5VqUNHMyLe/E44Yb68CpltTuEkPPtMmyiIQc
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a9d3cce-ce4b-4ac9-faeb-08db3a3e0a71
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 03:37:14.1426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KxvFM52ePsGZ9X6R0jcX1qDveL9s6hmbYxZ55+2I/zgXkUNDmPFGmZzGbCYhqkDgsqhYZVQaqm9m16juLMndEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110032
X-Proofpoint-ORIG-GUID: cuSB90zYpetIM3cIEzFQ8xJPrsffrBdP
X-Proofpoint-GUID: cuSB90zYpetIM3cIEzFQ8xJPrsffrBdP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 2a4bdfa8558ca2904dc17b83497dc82aa7fc05e9 upstream.

If we ever screw up the quota reservations enough to trip the
assertions, something's wrong with the quota code.  Shut down the
filesystem when this happens, because this is corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_trans_dquot.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index c1238a2dbd6a..4e43d415161d 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -15,6 +15,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_quota.h"
 #include "xfs_qm.h"
+#include "xfs_error.h"
 
 STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
 
@@ -700,9 +701,14 @@ xfs_trans_dqresv(
 					    XFS_TRANS_DQ_RES_INOS,
 					    ninos);
 	}
-	ASSERT(dqp->q_res_bcount >= be64_to_cpu(dqp->q_core.d_bcount));
-	ASSERT(dqp->q_res_rtbcount >= be64_to_cpu(dqp->q_core.d_rtbcount));
-	ASSERT(dqp->q_res_icount >= be64_to_cpu(dqp->q_core.d_icount));
+
+	if (XFS_IS_CORRUPT(mp,
+		dqp->q_res_bcount < be64_to_cpu(dqp->q_core.d_bcount)) ||
+	    XFS_IS_CORRUPT(mp,
+		dqp->q_res_rtbcount < be64_to_cpu(dqp->q_core.d_rtbcount)) ||
+	    XFS_IS_CORRUPT(mp,
+		dqp->q_res_icount < be64_to_cpu(dqp->q_core.d_icount)))
+		goto error_corrupt;
 
 	xfs_dqunlock(dqp);
 	return 0;
@@ -712,6 +718,10 @@ xfs_trans_dqresv(
 	if (flags & XFS_QMOPT_ENOSPC)
 		return -ENOSPC;
 	return -EDQUOT;
+error_corrupt:
+	xfs_dqunlock(dqp);
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	return -EFSCORRUPTED;
 }
 
 
-- 
2.39.1

