Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00BD0C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7A2C61185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbhIPKK2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:10:28 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:62416 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236222AbhIPKK1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:10:27 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xtup010932;
        Thu, 16 Sep 2021 10:09:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=EmgOFGz/IfD3lPA7ez6AFsNXCky50/nloBd5c6t7q5Y=;
 b=YHFS/UUUfBbetH9dN9WlKyZd/UWzieJ8Hz9buOuv7hvRmEx/GXZeBYT75UzIQ6mrr2LW
 aFF012dJskmea+KcsQn0XaSqWSxfqsNcB0rHRVrQt7Tg3ZHU3WQTLPGJCeb5baMm714O
 gFOFIKsizkfjpbcWPreAq+ntE/ubAw9T18QjXXYhpp3SlWUuzOGVW1pXCA1iRiPZta6x
 8beZeS3GH9GP8ClQX7cC84wzRadggTF3wTtf48F5bLKLwlTyrsH4T7MHUznDUzbHJ9B1
 DUax9+8grkp3c8EGiEKxsAZVBQomo5hecV+Lb1fbKqwrIc/iX4FTR/CMzD6QsHITOpmY hA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=EmgOFGz/IfD3lPA7ez6AFsNXCky50/nloBd5c6t7q5Y=;
 b=VRBcdF7Rx1gqk8WnSwEHuX3ocnfWhrqc4fq7Hoir719zBIEkGkCmgH3SeHL+vjZZLMx1
 3gw6VTlVxK5zEJII5vQeB0CP2CuYCtTbR9ytK/DtQ+ARtr4aKT1dLkeyJsJb51gRfl2b
 HwjRIKXDnHyVcaiAmI1yovpRiMRRQyUmUvNqrWJICXK20vFIFrSF7rf7oa66qz7Az7V+
 jzd4nYzt2aPlocT7n1TDc4c5MXF9/GWw/n2C66vJuDW0pU6J/c9TAREj5uRio/mZqLN6
 wMj/G4TD8PzMn2HHZsn4Io94FEllFnNGWJrfFXyaekkRjMhUsibdL/bwIrZc+dcT4xuS 4g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3jysjvdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA5FKo030674;
        Thu, 16 Sep 2021 10:09:05 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3030.oracle.com with ESMTP id 3b0hjxydbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxRzbFIeUQ0DOHrVXEsvF7q9fUF86I6sAPSmFnMfCQsMJue4ovAQHbQPomwCy2lJ+Acb0iAWJx4mtDyK2GSCxJsW6FCvC+MQc3qBVQ3qUqezlKgX/pdWODjDRyyF6E8s9LKRmS0CjiyuTlW+NLOAfE/V0kyZ7eyGlW2DpO3tDlzBxpIbtceT0QFg+pTuWdO34ZPpBvp/sFGNZV3rONrYdyfKBG7KHvT/HoDauhNLFcQv7sAorXAl8pP/Vv0x6foWGgFi5hZeRxQN/cnrIZSwQDWzjOJhPsBNM7GruOu+xV4hm8JZHkdJnjajZeB4QTWHkAfwn1EISPJftuSPI2a9+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=EmgOFGz/IfD3lPA7ez6AFsNXCky50/nloBd5c6t7q5Y=;
 b=Cocy8NCvqpHDCoLNmmFFexTb3+CPzc7yU3qChWnCL9ihuzrCaTNJPAN5WlTHfP9YXm3bXTAgYvvbq/9GHCCPxTy1GFBF6DuDZotTyRVwFhgDAB8JpfX+uIcB8ZGu7qc8MOmOUSXhJXBOK18fVnfaqHIkxOG9YRDOl3M08vYETzHbcPOKFqUt+t3nQ7PGGr3yAgSjH3p95ApAQ2D6GRnU8pMrWm5yJdJ/zlsD0zyZT6TRCu1RDu/kNiZxbsRzekJOa225rwx1DXDsGJ2B2m8sVKRd7D+fkJ52ErAjN2QlcuVXJ42Jwk3OdDY1nt7LTkBLM+bFSdweCam54OoP/J+nhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmgOFGz/IfD3lPA7ez6AFsNXCky50/nloBd5c6t7q5Y=;
 b=Bva/k4fp/Ve+vYxyiY24qAMp7mceKR2mw3k6Wf0wbGwCW6tkNNxyfQ5BmLq8xb5fzjYwWpFDnyXOf+mbbRBgUrngHtgF+RIzTfme8CrXLILR4yBJvIsI0WTTJHEqQ4MZHq+j3vnUbVSt9SqW+rLSSWsgP1ZNo7F+Wzmvs0PmoNg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 10:09:03 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:09:03 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 06/16] xfsprogs: Introduce xfs_dfork_nextents() helper
Date:   Thu, 16 Sep 2021 15:38:12 +0530
Message-Id: <20210916100822.176306-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100822.176306-1-chandan.babu@oracle.com>
References: <20210916100822.176306-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:09:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf8b8577-860f-40ae-7876-08d978fa0215
X-MS-TrafficTypeDiagnostic: SA2PR10MB4748:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB4748F3D5AD9C9DA94FFB7BD9F6DC9@SA2PR10MB4748.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4WGLxf8wa5sd8n7dyOvDoP2R1KMIk5iDpTZYTlsyLvLerIVBy8nA9v4l+FCoBtqW3bQNkFgFAbhaI18pv8YWb2weDzV6lM/QwAm5n3FRMKi1CpNfzvDazuSu7ZI9DwU9c9Iyz+Q1kYzR+FMeBdbQEWn0UVIV/qeNVX/an77GatuQcauXgCgkj554LZqmVGI6oKnQ3AqtO/n1DdMZ6Z5/vvpYQhBV5/lyafGjK0FXbD7uSjpxdcR7ZwKvS68sf0VT+Gb4Vhz9dflcES9Nf959L9zyA2x9ooz2m4uhSwZbx6vspxZD6qAR2u1mQ9bTCU1u881X/EQ9zGZ6TzGDhFg6eYUoIk0TfS93tGrUAMcxSqnN/CFtYlZ25Do9Sn2bncfCuw/JaTf897MPoUiha6zM9B3dVyKAktvdJ1Gy36zSzBTW+CeWgUvrUf1E6CBxgnL6CJb8kRRdVTQEh9LiPT5DQZRetKC0SeNRYocBM4UvLjC7W2RVYXoUPjTEKtrNKWxIS/N8DzpMH6euNWjvBuHH4Wm6+wrRzYijUT3FJPkglDgw9N+3i/5DIvnQ+GWbUziz7mGfVGQxm2Y4WlmkDQZzfMpYqKEjEuEBWRuiUKq0PPcBYBfGICPwi2MaW8Bh9NFU2yw36wgsnkrfOwwJCAaV6Er8GV+Hse8JaOhJ9IQt7A7ZWBkfqp/ZxaPopkPk3GzpBIDVjqG9SO5oNdVDIAyPTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(66476007)(2616005)(66556008)(66946007)(6916009)(2906002)(1076003)(4326008)(956004)(6506007)(83380400001)(316002)(8676002)(30864003)(36756003)(478600001)(38100700002)(38350700002)(6666004)(52116002)(6486002)(8936002)(5660300002)(26005)(86362001)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UsYckAwPdTDpAInxe5iGFWmHxk0vrNqvg7OSEq4YajlQsFvNB4weAtRGoOf2?=
 =?us-ascii?Q?SKRD5e4b5WqKJYieybaen31ClU6JN6s8AvL0jkxTujmBDfM/BVfX9W+j6C5v?=
 =?us-ascii?Q?ySFr+E3OkFzukkg4OnKgOHQ1knba0qt7/eBLuLnugECb5sEeNR74hDfkT+9u?=
 =?us-ascii?Q?NK56htvxFRAv/KquHnw1oXnEXLCjR1q5QRGc7AoOvDy7oW62Ht7OMglRg5PW?=
 =?us-ascii?Q?0IVQZ6SuLhCHUWB3upk6gAZ8XJjYn+HqrxnUC8OQmfkr1Q4wTulezs/JkrGs?=
 =?us-ascii?Q?xPKtq4KxmwUrOXoPJ6DdG0E6GjfBCsYJURDjOKOfgRNACU78XeVbIyFs1KFn?=
 =?us-ascii?Q?E0IujdL90toMSuNNSPL0nrSH2o6WwhyESmY7CgFdyX6nmkZOhVloj8If82gF?=
 =?us-ascii?Q?Y6x0hYOjcCPfhPRj8dmxCT8jvMeXNkp6X56D1BTCObBvhRVU2s6LWymZdPFi?=
 =?us-ascii?Q?OHaAwnFd5wVH5L2pXHQ+kcKtdHkk0GtKm9FIjNkeuyy1LJsZGT6fQonn3f72?=
 =?us-ascii?Q?mZYx5gLOShZnc7KIyvnNPX1y/VkUP7Qfz7td99mvg2tcd1SV1LoeQXD+ixa6?=
 =?us-ascii?Q?pAQl7c7QcrfMJ5t47rujB2VUlndgPYeaOZZLxF700oS/YYgh44bra/S0UlfA?=
 =?us-ascii?Q?8jnbD4SrrLWU+7CvUIN+hEV2ZhYOy/WWryBdt6Pk5mD12dAOK9h6XLzOPkg0?=
 =?us-ascii?Q?CgTeMrR+ZjhrSqztVfwycE+vPv57/NcY7yDmEX3U84jOW6TXnJHPGHAISNAY?=
 =?us-ascii?Q?NH5vgjy/WEliJlhDAT3dWEFL4EmLUl7DJUCSgavsYs6VWzi05pSsAzjhnwN7?=
 =?us-ascii?Q?wiqLH805XqDcy3CmX/kl9wfWmAnfoLYVbFZk5sIn4QQ4136Ax4gH4kBFhNLB?=
 =?us-ascii?Q?/GL4T79cZc5MfZ8SyVRVpBKZjveCFGK7YoZeFF9GyX/ZYQYmxRXbK2R/EG//?=
 =?us-ascii?Q?+RiXYB/4XwFI0QwbMy5QvRx0mcfToFmbBETRAZgFfldTXM44thnBdk31xYSN?=
 =?us-ascii?Q?9TsiHJbEYb8VMOcS4s7zbIAcjUJUM+vmbqQrVJQcBi06HAE+KFGOy1R/KaT4?=
 =?us-ascii?Q?GpCmfhOatIIhkcA4hbQdzzPQ87w9KS2Cbyt0PqBZc/TWuHHZ3B+AJ1a/d+Pr?=
 =?us-ascii?Q?5Fy1G7ZgeC5HcukdPld1+aB6mox5okScysDv0tTYUcLjXbM0etXOyqP7Gjwl?=
 =?us-ascii?Q?aVxjPUfd/qi/pKXiqJEeQ26k4dfHP7QNAWKUMngN67h5qu8/hTqNE4rfNeaj?=
 =?us-ascii?Q?k7oUIcUD0FJcOlEOn2/RepxzG9T4W24sMD0cIvjUWR2vDU6l0e9KMumryTj1?=
 =?us-ascii?Q?nrLoTSzoE+nrV0F9tOXr/q/z?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf8b8577-860f-40ae-7876-08d978fa0215
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:09:03.5185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zSIBVG5LFXKiNbcgGWTFTw9hMQ5kv+WfnLLkpDX/IvI37sSiOTeaC24JmOZmDn6CpdOZnzYkr8SyhEFSmwy3Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-GUID: D_jIOLtkhrtRZwe78GlMTEBNP4olsR87
X-Proofpoint-ORIG-GUID: D_jIOLtkhrtRZwe78GlMTEBNP4olsR87
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit replaces the macro XFS_DFORK_NEXTENTS() with the helper function
xfs_dfork_nextents(). As of this commit, xfs_dfork_nextents() returns the same
value as XFS_DFORK_NEXTENTS(). A future commit which extends inode's extent
counter fields will add more logic to this helper.

This commit also replaces direct accesses to xfs_dinode->di_[a]nextents
with calls to xfs_dfork_nextents().

No functional changes have been made.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/bmap.c               |  6 ++--
 db/btdump.c             |  4 +--
 db/check.c              | 27 ++++++++++-------
 db/frag.c               |  6 ++--
 db/inode.c              | 14 +++++----
 db/metadump.c           |  4 +--
 libxfs/xfs_format.h     | 28 ++++++++++++++---
 libxfs/xfs_inode_buf.c  | 16 ++++++----
 libxfs/xfs_inode_fork.c |  9 +++---
 repair/attr_repair.c    |  2 +-
 repair/bmap_repair.c    |  4 +--
 repair/dinode.c         | 66 ++++++++++++++++++++++++-----------------
 repair/prefetch.c       |  2 +-
 13 files changed, 117 insertions(+), 71 deletions(-)

diff --git a/db/bmap.c b/db/bmap.c
index 50f0474b..a33815fe 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -68,7 +68,7 @@ bmap(
 	ASSERT(fmt == XFS_DINODE_FMT_LOCAL || fmt == XFS_DINODE_FMT_EXTENTS ||
 		fmt == XFS_DINODE_FMT_BTREE);
 	if (fmt == XFS_DINODE_FMT_EXTENTS) {
-		nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+		nextents = xfs_dfork_nextents(dip, whichfork);
 		xp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
 		for (ep = xp; ep < &xp[nextents] && n < nex; ep++) {
 			if (!bmap_one_extent(ep, &curoffset, eoffset, &n, bep))
@@ -158,9 +158,9 @@ bmap_f(
 		push_cur();
 		set_cur_inode(iocur_top->ino);
 		dip = iocur_top->data;
-		if (be32_to_cpu(dip->di_nextents))
+		if (xfs_dfork_nextents(dip, XFS_DATA_FORK))
 			dfork = 1;
-		if (be16_to_cpu(dip->di_anextents))
+		if (xfs_dfork_nextents(dip, XFS_ATTR_FORK))
 			afork = 1;
 		pop_cur();
 	}
diff --git a/db/btdump.c b/db/btdump.c
index cb9ca082..d48ce6ca 100644
--- a/db/btdump.c
+++ b/db/btdump.c
@@ -166,13 +166,13 @@ dump_inode(
 
 	dip = iocur_top->data;
 	if (attrfork) {
-		if (!dip->di_anextents ||
+		if (!xfs_dfork_nextents(dip, XFS_ATTR_FORK) ||
 		    dip->di_aformat != XFS_DINODE_FMT_BTREE) {
 			dbprintf(_("attr fork not in btree format\n"));
 			return 0;
 		}
 	} else {
-		if (!dip->di_nextents ||
+		if (!xfs_dfork_nextents(dip, XFS_DATA_FORK) ||
 		    dip->di_format != XFS_DINODE_FMT_BTREE) {
 			dbprintf(_("data fork not in btree format\n"));
 			return 0;
diff --git a/db/check.c b/db/check.c
index def1db83..eb736ab7 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2720,7 +2720,7 @@ process_exinode(
 	xfs_bmbt_rec_t		*rp;
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
-	*nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	*nex = xfs_dfork_nextents(dip, whichfork);
 	if (*nex < 0 || *nex > XFS_DFORK_SIZE(dip, mp, whichfork) /
 						sizeof(xfs_bmbt_rec_t)) {
 		if (!sflag || id->ilist)
@@ -2744,12 +2744,14 @@ process_inode(
 	inodata_t		*id = NULL;
 	xfs_ino_t		ino;
 	xfs_extnum_t		nextents = 0;
+	xfs_extnum_t		dnextents;
 	int			security;
 	xfs_rfsblock_t		totblocks;
 	xfs_rfsblock_t		totdblocks = 0;
 	xfs_rfsblock_t		totiblocks = 0;
 	dbm_t			type;
 	xfs_extnum_t		anextents = 0;
+	xfs_extnum_t		danextents;
 	xfs_rfsblock_t		atotdblocks = 0;
 	xfs_rfsblock_t		atotiblocks = 0;
 	xfs_qcnt_t		bc = 0;
@@ -2878,14 +2880,17 @@ process_inode(
 		error++;
 		return;
 	}
+
+	dnextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
+	danextents = xfs_dfork_nextents(dip, XFS_ATTR_FORK);
+
 	if (verbose || (id && id->ilist) || CHECK_BLIST(bno))
 		dbprintf(_("inode %lld mode %#o fmt %s "
 			 "afmt %s "
 			 "nex %d anex %d nblk %lld sz %lld%s%s%s%s%s%s%s\n"),
 			id->ino, mode, fmtnames[(int)dip->di_format],
 			fmtnames[(int)dip->di_aformat],
-			be32_to_cpu(dip->di_nextents),
-			be16_to_cpu(dip->di_anextents),
+			dnextents, danextents,
 			be64_to_cpu(dip->di_nblocks), be64_to_cpu(dip->di_size),
 			diflags & XFS_DIFLAG_REALTIME ? " rt" : "",
 			diflags & XFS_DIFLAG_PREALLOC ? " pre" : "",
@@ -2903,19 +2908,19 @@ process_inode(
 		if (xfs_has_metadir(mp) &&
 		    id->ino == mp->m_sb.sb_metadirino)
 			addlink_inode(id);
-		blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+		blkmap = blkmap_alloc(dnextents);
 		break;
 	case S_IFREG:
 		if (diflags & XFS_DIFLAG_REALTIME)
 			type = DBM_RTDATA;
 		else if (id->ino == mp->m_sb.sb_rbmino) {
 			type = DBM_RTBITMAP;
-			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+			blkmap = blkmap_alloc(dnextents);
 			if (!xfs_has_metadir(mp))
 				addlink_inode(id);
 		} else if (id->ino == mp->m_sb.sb_rsumino) {
 			type = DBM_RTSUM;
-			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+			blkmap = blkmap_alloc(dnextents);
 			if (!xfs_has_metadir(mp))
 				addlink_inode(id);
 		}
@@ -2923,7 +2928,7 @@ process_inode(
 			 id->ino == mp->m_sb.sb_gquotino ||
 			 id->ino == mp->m_sb.sb_pquotino) {
 			type = DBM_QUOTA;
-			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+			blkmap = blkmap_alloc(dnextents);
 			if (!xfs_has_metadir(mp))
 				addlink_inode(id);
 		}
@@ -3006,17 +3011,17 @@ process_inode(
 				be64_to_cpu(dip->di_nblocks), id->ino, totblocks);
 		error++;
 	}
-	if (nextents != be32_to_cpu(dip->di_nextents)) {
+	if (nextents != dnextents) {
 		if (v)
 			dbprintf(_("bad nextents %d for inode %lld, counted %d\n"),
-				be32_to_cpu(dip->di_nextents), id->ino, nextents);
+				dnextents, id->ino, nextents);
 		error++;
 	}
-	if (anextents != be16_to_cpu(dip->di_anextents)) {
+	if (anextents != danextents) {
 		if (v)
 			dbprintf(_("bad anextents %d for inode %lld, counted "
 				 "%d\n"),
-				be16_to_cpu(dip->di_anextents), id->ino, anextents);
+				danextents, id->ino, anextents);
 		error++;
 	}
 	if (type == DBM_DIR)
diff --git a/db/frag.c b/db/frag.c
index f324e776..4105960d 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -262,9 +262,11 @@ process_exinode(
 	int			whichfork)
 {
 	xfs_bmbt_rec_t		*rp;
+	xfs_extnum_t		nextents;
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
-	process_bmbt_reclist(rp, XFS_DFORK_NEXTENTS(dip, whichfork), extmapp);
+	nextents = xfs_dfork_nextents(dip, whichfork);
+	process_bmbt_reclist(rp, nextents, extmapp);
 }
 
 static void
@@ -275,7 +277,7 @@ process_fork(
 	extmap_t	*extmap;
 	xfs_extnum_t	nex;
 
-	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	nex = xfs_dfork_nextents(dip, whichfork);
 	if (!nex)
 		return;
 	extmap = extmap_alloc(nex);
diff --git a/db/inode.c b/db/inode.c
index ee0344d5..b09f9386 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -278,7 +278,7 @@ inode_a_bmx_count(
 		return 0;
 	ASSERT((char *)XFS_DFORK_APTR(dip) - (char *)dip == byteize(startoff));
 	return dip->di_aformat == XFS_DINODE_FMT_EXTENTS ?
-		be16_to_cpu(dip->di_anextents) : 0;
+		xfs_dfork_nextents(dip, XFS_ATTR_FORK) : 0;
 }
 
 static int
@@ -332,6 +332,7 @@ inode_a_size(
 {
 	struct xfs_attr_shortform	*asf;
 	xfs_dinode_t			*dip;
+	xfs_extnum_t			nextents;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
@@ -341,8 +342,8 @@ inode_a_size(
 		asf = (struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
 		return bitize(be16_to_cpu(asf->hdr.totsize));
 	case XFS_DINODE_FMT_EXTENTS:
-		return (int)be16_to_cpu(dip->di_anextents) *
-							bitsz(xfs_bmbt_rec_t);
+		nextents = xfs_dfork_nextents(dip, XFS_ATTR_FORK);
+		return nextents * bitsz(struct xfs_bmbt_rec);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_ASIZE(dip, mp));
 	default:
@@ -503,7 +504,7 @@ inode_u_bmx_count(
 	dip = obj;
 	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
 	return dip->di_format == XFS_DINODE_FMT_EXTENTS ?
-		be32_to_cpu(dip->di_nextents) : 0;
+		xfs_dfork_nextents(dip, XFS_DATA_FORK) : 0;
 }
 
 static int
@@ -589,6 +590,7 @@ inode_u_size(
 	int		idx)
 {
 	xfs_dinode_t	*dip;
+	xfs_extnum_t	nextents;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
@@ -599,8 +601,8 @@ inode_u_size(
 	case XFS_DINODE_FMT_LOCAL:
 		return bitize((int)be64_to_cpu(dip->di_size));
 	case XFS_DINODE_FMT_EXTENTS:
-		return (int)be32_to_cpu(dip->di_nextents) *
-						bitsz(xfs_bmbt_rec_t);
+		nextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
+		return nextents * bitsz(struct xfs_bmbt_rec);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_DSIZE(dip, mp));
 	case XFS_DINODE_FMT_UUID:
diff --git a/db/metadump.c b/db/metadump.c
index 1522380f..891de80d 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2314,7 +2314,7 @@ process_exinode(
 
 	whichfork = (itype == TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
 
-	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	nex = xfs_dfork_nextents(dip, whichfork);
 	used = nex * sizeof(xfs_bmbt_rec_t);
 	if (nex < 0 || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
 		if (show_warnings)
@@ -2369,7 +2369,7 @@ static int
 process_dev_inode(
 	xfs_dinode_t		*dip)
 {
-	if (XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {
+	if (xfs_dfork_nextents(dip, XFS_DATA_FORK)) {
 		if (show_warnings)
 			print_warning("inode %llu has unexpected extents",
 				      (unsigned long long)cur_ino);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 65ad15fc..e9af506d 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -929,10 +929,30 @@ enum xfs_dinode_fmt {
 	((w) == XFS_DATA_FORK ? \
 		(dip)->di_format : \
 		(dip)->di_aformat)
-#define XFS_DFORK_NEXTENTS(dip,w) \
-	((w) == XFS_DATA_FORK ? \
-		be32_to_cpu((dip)->di_nextents) : \
-		be16_to_cpu((dip)->di_anextents))
+
+static inline xfs_extnum_t
+xfs_dfork_nextents(
+	struct xfs_dinode	*dip,
+	int			whichfork)
+{
+	xfs_extnum_t		nextents = 0;
+
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		nextents = be32_to_cpu(dip->di_nextents);
+		break;
+
+	case XFS_ATTR_FORK:
+		nextents = be16_to_cpu(dip->di_anextents);
+		break;
+
+	default:
+		ASSERT(0);
+		break;
+	}
+
+	return nextents;
+}
 
 /*
  * For block and character special files the 32bit dev_t is stored at the
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 72c1c579..63ec5794 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -339,9 +339,11 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents;
 	xfs_extnum_t		max_extents;
 
+	di_nextents = xfs_dfork_nextents(dip, whichfork);
+
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
 		/*
@@ -471,6 +473,8 @@ xfs_dinode_verify(
 	uint16_t		flags;
 	uint64_t		flags2;
 	uint64_t		di_size;
+	xfs_rfsblock_t		nblocks;
+	xfs_extnum_t            nextents;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return __this_address;
@@ -501,10 +505,12 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	nextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
+	nextents += xfs_dfork_nextents(dip, XFS_ATTR_FORK);
+	nblocks = be64_to_cpu(dip->di_nblocks);
+
 	/* Fork checks carried over from xfs_iformat_fork */
-	if (mode &&
-	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
-			be64_to_cpu(dip->di_nblocks))
+	if (mode && nextents > nblocks)
 		return __this_address;
 
 	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
@@ -561,7 +567,7 @@ xfs_dinode_verify(
 		default:
 			return __this_address;
 		}
-		if (dip->di_anextents)
+		if (xfs_dfork_nextents(dip, XFS_ATTR_FORK))
 			return __this_address;
 	}
 
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 61fb0341..4aa9b7d3 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -105,7 +105,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
@@ -232,7 +232,7 @@ xfs_iformat_data_fork(
 	 * depend on it.
 	 */
 	ip->i_df.if_format = dip->di_format;
-	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
+	ip->i_df.if_nextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
@@ -299,14 +299,15 @@ xfs_iformat_attr_fork(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*dip)
 {
+	xfs_extnum_t		naextents;
 	int			error = 0;
 
 	/*
 	 * Initialize the extent count early, as the per-format routines may
 	 * depend on it.
 	 */
-	ip->i_afp = xfs_ifork_alloc(dip->di_aformat,
-				be16_to_cpu(dip->di_anextents));
+	naextents = xfs_dfork_nextents(dip, XFS_ATTR_FORK);
+	ip->i_afp = xfs_ifork_alloc(dip->di_aformat, naextents);
 
 	switch (ip->i_afp->if_format) {
 	case XFS_DINODE_FMT_LOCAL:
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 927dd095..e842db3c 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -1083,7 +1083,7 @@ process_longform_attr(
 	bno = blkmap_get(blkmap, 0);
 	if (bno == NULLFSBLOCK) {
 		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS &&
-				be16_to_cpu(dip->di_anextents) == 0)
+			xfs_dfork_nextents(dip, XFS_ATTR_FORK) == 0)
 			return(0); /* the kernel can handle this state */
 		do_warn(
 	_("block 0 of inode %" PRIu64 " attribute fork is missing\n"),
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index f70194fb..25f02882 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -572,7 +572,7 @@ rebuild_bmap(
 	 */
 	switch (whichfork) {
 	case XFS_DATA_FORK:
-		if ((*dinop)->di_nextents == 0)
+		if (!xfs_dfork_nextents(*dinop, XFS_DATA_FORK))
 			return 0;
 		(*dinop)->di_format = XFS_DINODE_FMT_EXTENTS;
 		(*dinop)->di_nextents = 0;
@@ -580,7 +580,7 @@ rebuild_bmap(
 		*dirty = 1;
 		break;
 	case XFS_ATTR_FORK:
-		if ((*dinop)->di_anextents == 0)
+		if (!xfs_dfork_nextents(*dinop, XFS_ATTR_FORK))
 			return 0;
 		(*dinop)->di_aformat = XFS_DINODE_FMT_EXTENTS;
 		(*dinop)->di_anextents = 0;
diff --git a/repair/dinode.c b/repair/dinode.c
index 94b30ae5..dc6adb4c 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -69,7 +69,7 @@ _("clearing inode %" PRIu64 " attributes\n"), ino_num);
 		fprintf(stderr,
 _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 
-	if (be16_to_cpu(dino->di_anextents) != 0)  {
+	if (xfs_dfork_nextents(dino, XFS_ATTR_FORK) != 0) {
 		if (no_modify)
 			return(1);
 		dino->di_anextents = cpu_to_be16(0);
@@ -973,7 +973,7 @@ process_exinode(
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
 	*tot = 0;
-	numrecs = XFS_DFORK_NEXTENTS(dip, whichfork);
+	numrecs = xfs_dfork_nextents(dip, whichfork);
 
 	/*
 	 * We've already decided on the maximum number of extents on the inode,
@@ -1050,7 +1050,7 @@ process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, xfs_dinode_t *dino)
 	xfs_fileoff_t		expected_offset;
 	xfs_bmbt_rec_t		*rp;
 	xfs_bmbt_irec_t		irec;
-	int			numrecs;
+	xfs_extnum_t		numrecs;
 	int			i;
 	int			max_blocks;
 
@@ -1072,7 +1072,7 @@ _("mismatch between format (%d) and size (%" PRId64 ") in symlink inode %" PRIu6
 	}
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino);
-	numrecs = be32_to_cpu(dino->di_nextents);
+	numrecs = xfs_dfork_nextents(dino, XFS_DATA_FORK);
 
 	/*
 	 * the max # of extents in a symlink inode is equal to the
@@ -1578,6 +1578,8 @@ process_check_sb_inodes(
 	int		*type,
 	int		*dirty)
 {
+	xfs_extnum_t	nextents;
+
 	if (lino == mp->m_sb.sb_rootino) {
 		if (*type != XR_INO_DIR)  {
 			do_warn(_("root inode %" PRIu64 " has bad type 0x%x\n"),
@@ -1632,10 +1634,12 @@ _("realtime summary inode %" PRIu64 " has bad type 0x%x, "),
 				do_warn(_("would reset to regular file\n"));
 			}
 		}
-		if (mp->m_sb.sb_rblocks == 0 && dinoc->di_nextents != 0)  {
+
+		nextents = xfs_dfork_nextents(dinoc, XFS_DATA_FORK);
+		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
-_("bad # of extents (%u) for realtime summary inode %" PRIu64 "\n"),
-				be32_to_cpu(dinoc->di_nextents), lino);
+_("bad # of extents (%d) for realtime summary inode %" PRIu64 "\n"),
+				nextents, lino);
 			return 1;
 		}
 		return 0;
@@ -1653,10 +1657,12 @@ _("realtime bitmap inode %" PRIu64 " has bad type 0x%x, "),
 				do_warn(_("would reset to regular file\n"));
 			}
 		}
-		if (mp->m_sb.sb_rblocks == 0 && dinoc->di_nextents != 0)  {
+
+		nextents = xfs_dfork_nextents(dinoc, XFS_DATA_FORK);
+		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
-_("bad # of extents (%u) for realtime bitmap inode %" PRIu64 "\n"),
-				be32_to_cpu(dinoc->di_nextents), lino);
+_("bad # of extents (%d) for realtime bitmap inode %" PRIu64 "\n"),
+				nextents, lino);
 			return 1;
 		}
 		return 0;
@@ -1816,6 +1822,8 @@ process_inode_blocks_and_extents(
 	xfs_ino_t	lino,
 	int		*dirty)
 {
+	xfs_extnum_t		dnextents;
+
 	if (nblocks != be64_to_cpu(dino->di_nblocks))  {
 		if (!no_modify)  {
 			do_warn(
@@ -1838,20 +1846,19 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			nextents, lino);
 		return 1;
 	}
-	if (nextents != be32_to_cpu(dino->di_nextents))  {
+
+	dnextents = xfs_dfork_nextents(dino, XFS_DATA_FORK);
+	if (nextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
 _("correcting nextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
-				lino,
-				be32_to_cpu(dino->di_nextents),
-				nextents);
+				lino, dnextents, nextents);
 			dino->di_nextents = cpu_to_be32(nextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
 _("bad nextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
-				be32_to_cpu(dino->di_nextents),
-				lino, nextents);
+				dnextents, lino, nextents);
 		}
 	}
 
@@ -1861,19 +1868,19 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			anextents, lino);
 		return 1;
 	}
-	if (anextents != be16_to_cpu(dino->di_anextents))  {
+
+	dnextents = xfs_dfork_nextents(dino, XFS_ATTR_FORK);
+	if (anextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
 _("correcting anextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
-				lino,
-				be16_to_cpu(dino->di_anextents), anextents);
+				lino, dnextents, anextents);
 			dino->di_anextents = cpu_to_be16(anextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
 _("bad anextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
-				be16_to_cpu(dino->di_anextents),
-				lino, anextents);
+				dnextents, lino, anextents);
 		}
 	}
 
@@ -1910,8 +1917,8 @@ process_inode_data_fork(
 {
 	struct xfs_dinode	*dino = *dinop;
 	xfs_ino_t		lino = XFS_AGINO_TO_INO(mp, agno, ino);
+	xfs_extnum_t		nex;
 	int			err = 0;
-	int			nex;
 	int			try_rebuild = -1; /* don't know yet */
 
 retry:
@@ -1920,7 +1927,7 @@ retry:
 	 * uses negative values in memory. hence if we see negative numbers
 	 * here, trash it!
 	 */
-	nex = be32_to_cpu(dino->di_nextents);
+	nex = xfs_dfork_nextents(dino, XFS_DATA_FORK);
 	if (nex < 0)
 		*nextents = 1;
 	else
@@ -1970,8 +1977,7 @@ _("rebuilding inode %"PRIu64" data fork\n"),
 					lino);
 				try_rebuild = 0;
 				err = rebuild_bmap(mp, lino, XFS_DATA_FORK,
-						be32_to_cpu(dino->di_nextents),
-						ino_bpp, dinop, dirty);
+						nex, ino_bpp, dinop, dirty);
 				dino = *dinop;
 				if (!err)
 					goto retry;
@@ -2070,7 +2076,7 @@ retry:
 		return 0;
 	}
 
-	*anextents = be16_to_cpu(dino->di_anextents);
+	*anextents = xfs_dfork_nextents(dino, XFS_ATTR_FORK);
 	if (*anextents > be64_to_cpu(dino->di_nblocks))
 		*anextents = 1;
 
@@ -2118,13 +2124,17 @@ retry:
 
 		if (!no_modify)  {
 			if (try_rebuild == 1) {
+				xfs_extnum_t danextents;
+
+				danextents = xfs_dfork_nextents(dino,
+						XFS_ATTR_FORK);
 				do_warn(
 _("rebuilding inode %"PRIu64" attr fork\n"),
 					lino);
 				try_rebuild = 0;
 				err = rebuild_bmap(mp, lino, XFS_ATTR_FORK,
-						be16_to_cpu(dino->di_anextents),
-						ino_bpp, dinop, dirty);
+						danextents, ino_bpp, dinop,
+						dirty);
 				dino = *dinop;
 				if (!err)
 					goto retry;
diff --git a/repair/prefetch.c b/repair/prefetch.c
index ad06addf..19eaf16c 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -393,7 +393,7 @@ pf_read_exinode(
 	xfs_dinode_t		*dino)
 {
 	pf_read_bmbt_reclist(args, (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino),
-			be32_to_cpu(dino->di_nextents));
+			xfs_dfork_nextents(dino, XFS_DATA_FORK));
 }
 
 static void
-- 
2.30.2

