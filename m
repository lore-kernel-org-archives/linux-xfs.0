Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 301CEC64EC4
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCHWio (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCHWik (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:40 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5B46043D
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:31 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328Jxfij001678
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=yx7qPqSV28+oFqwLmDnSGOa8X90dvbh8eKnTaMF1UxQ=;
 b=DavGHmQh2h34ZMSC/9tih2e0wuWzlT/dxDjb4A3mGPI5IsfmUjiTPC5WKu2xIvM0TRPC
 gUI3PKbTu+cuS7D+QgMAxksGYs9zwFzZDTaQRn9sZXFZHG1cMG9yIehM/FcLcRWiW4H0
 KpiFRP97tBaJio5Pk4TKs0KAwtuHJ9RAJAziPM1H/6pWP2ebUnXqdu3e42PB9T54pDYW
 5aGBqMPfLCCnBysWaBmXs7SyFGByBAVKjN6fCltk1SSSG7UbebwgHeneGrpUjYCbjTYi
 wMGHzti77cTVbk4c4CyOurqV5IhTVH0Z/esUwxNPpESNCXNGJG3fcFpiNupNYbeKCz6o WQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p416wsd2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:30 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328LljWq022398
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:28 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fr9dwxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFVDoO3O1ZeQ1tfqYy2yaMY6I4BcSZzsId0+zCO/aRxVHN4TeDRWwB/SkV85AhHsFLRGJpHvkmbB+Mxuc7BCG00nRLbXE8JB59N/iDT3dxeilc3uxvqP9BPCXg32VliI4Zw3sAupJSQ2s/ay3JBN6FLckavd61cTeOB51u+8b2rvKUhqKfNAX1GGjvC8W+Oxu9U+uJs+jDXe6wjU03YBMrNoeHcjEZx1mOncvaU9qN0px7Nd7KQXTxDVtPXozuCX7j73s/0TpAE1DxLwhsHq9gYmgUd5JxhnO6/U2vo3UiUkDmgGF6A5M5/ouMo0ISzLON6FBHGGdQmqA6JI+75nkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yx7qPqSV28+oFqwLmDnSGOa8X90dvbh8eKnTaMF1UxQ=;
 b=dwxIBbPnxTuLi8BmaUbmdR1O8pX6H1aWzQGdlzWOJVoy2ACNNPuM3Q/o+b7ISmKWMoROWJYW/O6lROq9XViFHNuLImRftxAHzuQHzTQHeMOKmY+X8wPailfD4sWc/C6OXPcsFhkJ+xl/kH/HwdSayhO/maTFSirPsCOfdTabobGbwl9yipm06z46O54kTyi2kC5iRXD1dPcdw1JxicNt9XEL+TBjHyLuC28dPNSXB4839jo2A4tbQFfnVpGZQjLDH7KIIXhrbScu8Rd2PcvEJ/2wQK2H+Wua11DFrGYqNA3Qfa2CK9NvaDTNpSORop6nDll6HgmFD7cLkrgWWmpmGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yx7qPqSV28+oFqwLmDnSGOa8X90dvbh8eKnTaMF1UxQ=;
 b=qUPuQKSM3YFakMjLR7ZDHFJGusRVa6vwaWu1PqOH89cAb6/oAzciHHYt16JloakRr1tHakMlPWinwUYkP2EFe67Uk4cRon6kZzKJflB5gq9pzVf9/3+ID2xrpHMLmFxa12XPlqZkJ1fBotEdX7CUMIywpDWNBDtJvtMN2HbmR5I=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7102.namprd10.prod.outlook.com (2603:10b6:806:348::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 22:38:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:27 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 17/32] xfs: add parent attributes to symlink
Date:   Wed,  8 Mar 2023 15:37:39 -0700
Message-Id: <20230308223754.1455051-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0084.namprd05.prod.outlook.com
 (2603:10b6:a03:332::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: ac35c147-afab-4d54-9d84-08db2025d571
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V0345a78n/N/4cggKISjRD9sls5da7V3dFLzL4gfAFfbTYGXfZVVkoABhVXP3X26mudRcbhlgxlerwFevE08p74Padv7Na9red6lbrHKScZIly6VzljhxkVRaBtOqeAJwF6tU6J1aAhnkqCgHUiwJq5fbDaWBC39WdGct6RJsZ3kOAf94JevkZckRAxSJsiR9RQ5cg7qOubFWUrTQAhOE+puWXpYWbdruYrqNRPv6BfbwA4a0zXcFsjCohKyIU/i3SOb3ZnDRz0PvP+huLMhSOEI6mIExVQUilS1O4O8/PGR84H1EpvirJSn3djDm6bR9IgTg9AOoTRbd/3vQIlHocBdwLp/hVzMcCCsJAlQAXIXaaRHBAUUBX7HODBhu+AYJlp+AjRUKqKHQNiykgWVi3VGKBpuLf9T4Wc63hLJ5LMpkKgNT1Xn0L4L5+rUsJIcQZ44+NwZ7vqLqg2bdthazNOAFOeBnGcnC26FpMwQmPuU/9XrUf+XuweJ+KAUr5U5BNNYvVH8Us61+c7l3rliM+IRz5HvNhMRFZ/VSZHlKVZCZ5E4tG3EghM5Hm6UD6JdGg7rTnVGHIcU2vSDl58lqGddBlp62Skh2ZoQsxy+iRQVuCyimc4k2V4dxk3mQz7rqKY3sgyhqwBT1yYCZD1R2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199018)(36756003)(6666004)(8936002)(6916009)(41300700001)(8676002)(66476007)(66946007)(5660300002)(66556008)(6506007)(2906002)(38100700002)(86362001)(6486002)(1076003)(6512007)(316002)(478600001)(83380400001)(9686003)(186003)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T28hESq88cTUB4WwUehzdk5v7sM9vfZtsnudpvv0wN2pbtgwH9S6VXrvL16z?=
 =?us-ascii?Q?YFP2rzX/+ZSa3EReYkCsCCdIv7jWaxuodF3m4ERBiOKhonDWz05ZwAHGLeai?=
 =?us-ascii?Q?0z1jehxpIZl9ZBzZOia5bJ/2M3quOjEyPS4EyfQl5EE5PSw+BugqDL0HBHNe?=
 =?us-ascii?Q?imeX/xuQI7CB1YqRHAicVE8/wiI6D7leWGJ8mNSquVLRC/5Q62A9isNjizRV?=
 =?us-ascii?Q?JeRi1HEj/bJfRIFGi7UoRhTiFJriUBCNVZ+BHBSeSGVLDuEcyyN2HjM9hC9a?=
 =?us-ascii?Q?JXCVa81My0QzOhGeV9DPyAXj9J+Av1zz1kI1VDPUkYltgdyEJ0TE3fJJQ8x9?=
 =?us-ascii?Q?0w1rHiVN4hpEVJool0OpTwy8schuGU+6/B8IKnZsyxzFRkVlDX3GjWhxqPeg?=
 =?us-ascii?Q?58I8PvpmAefR2PY3O7+g9oZ6wAyFxuOwEYVouMVUJ8CB2/0y7DVmQWsZetkK?=
 =?us-ascii?Q?9DzR7Q4a/RiP/DjW5ykSV15EcZzDk67PckLih8SuZKNFU4RxkuOKWupp5v4t?=
 =?us-ascii?Q?2ebNM4dG7C7sgw5IvS2qmxX0DTD6f3mjZdGxVTrVZm8CNQhu4yinX1sQ9hNm?=
 =?us-ascii?Q?PbqlGdeGWnN/dJMfYgdhjqbTovK6NQQ1iLXC+bBAUEpMLa4ybXULKHuFwfuj?=
 =?us-ascii?Q?gjeHb0ecwRVmFFPSg4/qdLUDZMu+GJfSigZKDjfaYK0HRMBo+OcFFaictAgE?=
 =?us-ascii?Q?VZ9aKVy0ZsBRksMCxDz3R+HIjxb0bA4gI4uNb0csQK6ONWMlfe1AsWtleuqo?=
 =?us-ascii?Q?PSoSPoIOZngW59IctQWvC/DndfI+Li9Y9hiUbfwjyks0xRBNUXfoamjEaY1l?=
 =?us-ascii?Q?ELQGgT1Zp9vk08Ufeyqp963N8XnENqfEGmsBA3xt6mTc1n4nuHMjF2kuSjV5?=
 =?us-ascii?Q?gf+RW+pcrvcg4/CwHimCnP/Dt4qeFNLM95rdJIN5IWuEA7YtV8zwgkrG27eD?=
 =?us-ascii?Q?n/VylJh+JIMeijRL7RMtApYi41xOTBJyxjFOrAp3ZlRE3zuRWDRRibOFxMiJ?=
 =?us-ascii?Q?lbxXEzQV7azixJOM3nnTFzmTFSdJpDPCJIU/NXs1kbPsdhYrNawqS/RMvmP9?=
 =?us-ascii?Q?GqusczwTIBiCQkhAYhGIt2slMvvFSGVIn1d4DwoS5oBNtri608Sqp/b44iAC?=
 =?us-ascii?Q?KV1aUc4QFeAHo9VBcel/cUFkMkOtHu1n903BTymnyHh40TfCDaBdfIL2C+HR?=
 =?us-ascii?Q?l7JjHaVtox/QYnuegP5YVvvo0UumpqB389j0irMaxPh14oXpK17H2FB2/hs0?=
 =?us-ascii?Q?FtY5Iq2LEbK12uAIqGgagMuBzGBCvsApcfIruxJlWqi3eU5aXeZ298PEYbEJ?=
 =?us-ascii?Q?lt8WseBTaAbTNqMIpfSXuxo7x11OkJToQ1Bz21c3enspdogynorPSS+do9bK?=
 =?us-ascii?Q?sjxCVfdnHpSLTHbw59z2cYSvEX8j4Lk/ZiUOOWWaQZGQh96+OJKkYrSzWwXX?=
 =?us-ascii?Q?wOtbpE72n+xmTlNugMBXBZGyECggzynw8x3coApH+KpbG1EGd+0nkBAMuzPX?=
 =?us-ascii?Q?9F+9HMGB3BhkIozH054Fx2w0vwIyVld3aGqUXU227t3/4eHNoVKkr4fn+wnv?=
 =?us-ascii?Q?K+6t2JE246EV12dtdAs27+fuB3/Oyh+8/s9ePGMS3mGTjNPEwedFJgwSdNqj?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Z52j1/q04cOAXUBEIUf2ujpouqw55uB5Ry7SO1fz/ATQtHF0ibPDn1vCNCuBZB9NafY5eYbUA0JkUyIchJFGBCWS2tckIH3uhQEpW+BeSLjHEKHq1+HWGUCkmBd6aBK9KepVr/H8Gz41/n7KhnAX6aYt8G/KNws3z8HlP/IZBYRx/qTazoKyUxB05qlNMZq2VVc+KGqdT3jVfYF1+3uhaM5AhfhWsqzuZKV7B4CJ6KUi4TUM4tuLyzJxu5tGsmply4iYgpGceOyv3RyQm6LLiqKZFNU1fA+c9FfVS0KK2UBS1sZ+rk0fWNPhl8+jn/uoFKPN+CvTVdzpVIHJWM/Zz7zsiQnFNPCOgP6AeiBFl9vmC1Z9YKWfF6oVrJQqonOgMIXZwIiBLk/faKgO/adX78N1/WBIhd570fSnQel9s7C6X62wAFUhkfkQ2JZVMaCdb77fZtrXKOWGlR8wDdX3/KExDOanjTqswjLPfOlZmsdWCYdIGzClZdDhL+Ofk0CdgIxlKiQqZQcGyUJMsuAq2DNMxxzmw4xLAm7khjBUnTXfF1p7wicV2juIBvHKVx5xlO5oWWK/IKFimMec8P0RFB08VLy53BETALeuM0tmuNweOHSFVtDONsGCrdntFWKO3Xi8lAIYb3d/Lm4repdAIVbb/4H1pmbNBvQDJhBlMqWfhQGK8LO25qcdF3xKCzAH5PnM7ZtwfkbWT11kqM+AyzIhhHYDpHLwv+unlkwHPXI3PZkAqttFLqOV0MdfI2LcjXUb12gLNV0iUGYRjU+Yzw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac35c147-afab-4d54-9d84-08db2025d571
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:27.1647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: INrTmlVvfyY+eV8JZ5TaJJNUzphw3xQqUR/dyqS8vZq4EktOAdlxTAWNiiTuLW4roE/B85Fkq8C9l7qLX0p1jkKCEKPP48YdlZeGeuaYH/k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7102
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: pKtdBXihQFI8WsLvRMzj3hvmFSRXxmG7
X-Proofpoint-ORIG-GUID: pKtdBXihQFI8WsLvRMzj3hvmFSRXxmG7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_symlink to add a parent pointer to the inode.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_space.h |  2 --
 fs/xfs/xfs_symlink.c            | 58 +++++++++++++++++++++++++++------
 2 files changed, 48 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index f72207923ec2..25a55650baf4 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -95,8 +95,6 @@
 	XFS_DIRREMOVE_SPACE_RES(mp)
 #define	XFS_RENAME_SPACE_RES(mp,nl)	\
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
-#define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
-	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 4d5f38936a20..7872397b8b5c 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -23,6 +23,8 @@
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
 #include "xfs_error.h"
+#include "xfs_parent.h"
+#include "xfs_defer.h"
 
 /* ----- Kernel only functions below ----- */
 int
@@ -142,6 +144,23 @@ xfs_readlink(
 	return error;
 }
 
+static unsigned int
+xfs_symlink_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen,
+	unsigned int		fsblocks)
+{
+	unsigned int		ret;
+
+	ret = XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp, namelen) +
+			fsblocks;
+
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
 int
 xfs_symlink(
 	struct mnt_idmap	*idmap,
@@ -172,6 +191,8 @@ xfs_symlink(
 	struct xfs_dquot	*pdqp = NULL;
 	uint			resblks;
 	xfs_ino_t		ino;
+	xfs_dir2_dataptr_t      diroffset;
+	struct xfs_parent_defer *parent;
 
 	*ipp = NULL;
 
@@ -202,18 +223,24 @@ xfs_symlink(
 
 	/*
 	 * The symlink will fit into the inode data fork?
-	 * There can't be any attributes so we get the whole variable part.
+	 * If there are no parent pointers, then there wont't be any attributes.
+	 * So we get the whole variable part, and do not need to reserve extra
+	 * blocks.  Otherwise, we need to reserve the blocks.
 	 */
-	if (pathlen <= XFS_LITINO(mp))
+	if (pathlen <= XFS_LITINO(mp) && !xfs_has_parent(mp))
 		fs_blocks = 0;
 	else
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);
-	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
+	resblks = xfs_symlink_space_res(mp, link_name->len, fs_blocks);
+
+	error = xfs_parent_start(mp, &parent);
+	if (error)
+		goto out_release_dquots;
 
 	error = xfs_trans_alloc_icreate(mp, &M_RES(mp)->tr_symlink, udqp, gdqp,
 			pdqp, resblks, &tp);
 	if (error)
-		goto out_release_dquots;
+		goto out_parent;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -233,7 +260,7 @@ xfs_symlink(
 	if (!error)
 		error = xfs_init_new_inode(idmap, tp, dp, ino,
 				S_IFLNK | (mode & ~S_IFMT), 1, 0, prid,
-				false, &ip);
+				xfs_has_parent(mp), &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -244,8 +271,7 @@ xfs_symlink(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	unlock_dp_on_error = false;
+	xfs_trans_ijoin(tp, dp, 0);
 
 	/*
 	 * Also attach the dquot(s) to it, if applicable.
@@ -315,12 +341,20 @@ xfs_symlink(
 	 * Create the directory entry for the symlink.
 	 */
 	error = xfs_dir_createname(tp, dp, link_name,
-			ip->i_ino, resblks, NULL);
+			ip->i_ino, resblks, &diroffset);
 	if (error)
 		goto out_trans_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
+	if (parent) {
+		error = xfs_parent_defer_add(tp, parent, dp, link_name,
+					     diroffset, ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * symlink transaction goes to disk before returning to
@@ -339,6 +373,8 @@ xfs_symlink(
 
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, parent);
 	return 0;
 
 out_trans_cancel:
@@ -350,9 +386,12 @@ xfs_symlink(
 	 * transactions and deadlocks from xfs_inactive.
 	 */
 	if (ip) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
+out_parent:
+	xfs_parent_finish(mp, parent);
 out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
@@ -360,8 +399,7 @@ xfs_symlink(
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	if (ip)
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
 	return error;
 }
 
-- 
2.25.1

