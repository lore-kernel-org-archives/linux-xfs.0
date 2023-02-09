Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A643C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjBIICB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjBIIB7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:01:59 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B135E1352E
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:01:54 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197PtGC016242
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:01:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=kjnJXb4QLTI/gC6onLA0jkmfXuy0GCZXIVbvceEUfO0=;
 b=HugSoNfaW/pWzSfyKzBtdYreMmsMTaheTgHyP8y+Jc3XJPynlhc/oq2J0sjovO+vztiD
 T+IcXrVUcou9TKsbfB6jW0rI4QlKjR1mwbv+yohlM1xgqLwqPnIe7S13J9SNhu75ozNa
 qIR9xHkYN6EIner1nDBjHEVbrdwUqH+6wOrQ7BHzodn/SS1BRE74wupiOAuJRuBi3gws
 s6c7nSF5qDWUnTuFjhfEx2gxrR63UxGBs6kliJWUv1g2AMlf6/s6laBgOxtarMTE59jF
 OwcBOqOdEdVKZxwmNuhFQIU4ncvyTviOQSIKyUvkaGV/n9g7/W/+kdx9sjKUhNv9zXUP Ag== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhe9nj4d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:01:54 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196U9Ip036257
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:01:52 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtfg3gn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:01:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6LTPu06PegX00evVQ+lH5Ugr/gOcyAXbPhpXZQ/20qNod6daDtncmu8y4LwE8Hkvo1g4HfK1qDWfpbcHRy6XEU6iUfyDCRgR5Gx3j1OG6gHVCgfhF1yuiCdorJUf9Gd+aqsn6vThexu/7K/cVfBnauvtColOvZ5VLkWYoQ7p/pCbZTNzyIZlhScfrLq7dbN6hdAG8tBidWCVg78nHQVObtODbnrGySmJtz8LqFilbT+z7K1mqL1VKlpNFL5mWXaYExYwXkY/xPtLOX5pMDPSZzM9xdJJiKZ3IWTxsLKuvk52fMwzMv/7QG9Eef9dXD/G3XNJWzAeYvEU8ZB3WSS0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjnJXb4QLTI/gC6onLA0jkmfXuy0GCZXIVbvceEUfO0=;
 b=SGKDBqBrKBnu74HW/GvOpgOidBZzNxDjAtMZmNYlnGCAtxFiTHLL/1XvIqjHWg0fH8JZLGGqWZdOZIwBrYBYvA2b3wgiuMbhwNKYNrnp+7O+ePalMfrGeZMW8aMC/lVU118TV8DasEFq/ZAqJyHr/9SsK9FUOFLELbLvLvyDZ21fCK7NXnQNh7QR/vH3bI63YuJ2ZIW/8eKUfFE8LV2WrVb9pwYZuYfPuzpFSqIYkd/Zv8ZXYn4xn8KFjg7mdupNN3kiv3rvO2KYn4C9trUuYufeoJDNb00TfuCLHLhSbgLjsbiF4/Ud5qOO4XjNqRVWzN57k03VvgSO2GOZrGM2Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjnJXb4QLTI/gC6onLA0jkmfXuy0GCZXIVbvceEUfO0=;
 b=yho5kCVQlXhScgxctoIZDDpLIM2HWFvxqhCWJkIu2s9zpM/W1DKJB1r4nLNbvF+i5CnaIyXLQYDpDFTjP+XJeBoyC5DiAW0ay3qQbgVzlPVf1/c7fRRiOdi2McRzZAj47YrrnFOrj8oXTYeGkcxOKbYNUvlZtEWoGVDnl9Likts=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5787.namprd10.prod.outlook.com (2603:10b6:a03:3dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 08:01:51 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:01:51 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 02/28] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
Date:   Thu,  9 Feb 2023 01:01:20 -0700
Message-Id: <20230209080146.378973-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0048.prod.exchangelabs.com (2603:10b6:a03:94::25)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SJ0PR10MB5787:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c2c6286-7d5c-4121-1767-08db0a73e6d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AuU3FZrq0eUxCFBtpLYMrlqsc0iWR04ZDYIp5aaMDW/+l7JmZvEZF4NDnWb69osVvPHXAAIbnPdhLdklEUpgBOaZqnhYcf3GU8tM7VK0C0HQZDOH2MWQCFozIgDwj/DR2YoAkn1yZhtQauoz6n+1jOu3gp4V+VV4z+g64nCA3goUo8EC0Mn7CJNmkb1GID9cSsaEQ8PZD/0I1fLXEdJNgYKCoH476Cy0T+UBnDNWyk/PBwZoFCPWnSm016hCtCyzPUwyKZY+6O5YeH0raYAKTHuDKy1JJU3pTtYr9To+l9+sJ9aWy+vR7bI9SHKScL+7AK8P1rg90UkMpYgdMtGj/V3UxWBEHunMt9GyshxHbdrCWjLEHCJZFBnFI1jXMEcqMQeLp2HrqIKABtRx0NBoNFwY9Lr7/RlFY3RQ7hbcRXbBAwYQ7piBeH7wokuyVEm5kAwWnDONQSTyDSrX89gyRb9wHBvGU9znkKO4ky+lNspcS2jmPDj2a2614P2qS5vpmxAetfdC4P58HqBYCg24bDkyzOwbnB3WEcguTXRBLt9dn+Ik8yjI0wokEOXi0hvmcrCFb+pLbpfpbiwGeOa/xU7C76SWWlWeZAafaAU1pE6Va9eRNpiDBjXkSkXJjLCXgOdcnA2BHn2CoJ8g4SH7dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(366004)(136003)(396003)(346002)(451199018)(478600001)(186003)(6512007)(26005)(6666004)(9686003)(6486002)(316002)(83380400001)(2616005)(1076003)(6506007)(66556008)(66946007)(6916009)(41300700001)(5660300002)(38100700002)(8936002)(66476007)(8676002)(86362001)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oRfBNpXSZxAqew5ocGHe787PUwkMRQ8GYghEj0QIblRTieAtwce4rI+Zo76j?=
 =?us-ascii?Q?DHOaEx8oKDo6RCuiDKiW/T+ZH7c5b117DeHd0E4iicrAiXIoBf9yFucNrnOP?=
 =?us-ascii?Q?JNKYZeV+tFNxkmCgw4+8RsyCippJNIj8vNtrSQlQgtfEIYBYYnMJEKDOQxuC?=
 =?us-ascii?Q?PoOBjhu33cIIiGCcHlBz+jhFNug5Vg+vWemibe6O5A3GJkgsl/S42AhceL7x?=
 =?us-ascii?Q?/WV3QdpRKSxUj3X/oaJUarYAV9ExFOfFFwajP18HSuiwfYfGoPsRJpOSHmjy?=
 =?us-ascii?Q?Hmx+vBYk+AxcZRC42hSSsg83App9DUGSp6EYRuoYp5NLtFoBhtLNYlmJgC6J?=
 =?us-ascii?Q?CBu7a7lbBXPmzMcoYLwA08FEm+/jb301Cu5fY0EjG9e3zlU8JObYpFEh8O7V?=
 =?us-ascii?Q?6YaIN2PRt/IDdEgliTBoCsMOa9eo45tXf6h0VylqIBjUcJhEssJWAIAwJpiw?=
 =?us-ascii?Q?A1n6GrrXhyTocg4MOEyCi9Ys1dn5Lm9qjH+7Jh1Nz2TdNe081d/M1JFWYyMq?=
 =?us-ascii?Q?yXF1yXr5BF7G+Ot/I6brFKvEuq0bcsNjh1J8lqGZg/pGGwS+ICDjJy3N8R3d?=
 =?us-ascii?Q?PhpkRmn84fzLbtFVk+weuzJuF0cJ1cSRVRyf6uWbSGxrdwkcQ2+9Qsnccbuu?=
 =?us-ascii?Q?zgTUwacWcEs8vlA3oDK542DM2FxTX3cnSRssgOg2Vdki1Oy5fdKaMzAEypWa?=
 =?us-ascii?Q?kXrqm0CcoDqS/U+7LtsggUmpLieUYnlLZh1tTu4xLEfPJSwwmM7nVotkXtsY?=
 =?us-ascii?Q?zi0Bi5FA9FWLzZCtHQ+Ov+TvRI2uc6W21H4am25X/hsWOgxnHxK6bhwzz2y3?=
 =?us-ascii?Q?RZPvrcndnXEEPaJjpkViR1b/nrry+7GPgiFQlo1Z5W+t7dtreQIqveok0C4P?=
 =?us-ascii?Q?e77t9LQQeXy9j2T9bEcfGzKEN/eFMeTOPKsnKIM+M9vBuP5giNtQrr/d0J4f?=
 =?us-ascii?Q?igOu3AwGJyQs/MIevmoGOWp/covCdVHKspKeFRe0WzEYBdq/ceyaeYwmozEj?=
 =?us-ascii?Q?X/gYQesiEXJo1efwIUH5rWZYEV3HBJHiWmkzqDQ0MY1lRgtcOt9UT83PH3qa?=
 =?us-ascii?Q?1ojtKPfS0j59tr4avpacu1HK2/hwouFotIoEpUii5kNnckAL+3Sfa8GIKZAC?=
 =?us-ascii?Q?xumT0oIAG5gWYuWd+DlRRxun4o5YdplkkAMPj5vAtaI3vqcubVVPivR2sEOr?=
 =?us-ascii?Q?wcFJnbXZcJbhLB6om6UDSxzOXWGmBZsQx5qb4nMuyQp11rz3FIkKuZQ/ePLx?=
 =?us-ascii?Q?cNRraEZHA/xh7ITAD+BxEzVC0/MgjMoXNK3CFgRD+SORwJpfC+FyZnoAiVAL?=
 =?us-ascii?Q?QHtxCU163p1fUtA2CZuR0IAVxxsLg3J0AzdSB/S/YU7eoYpCSsB/so7mXQX5?=
 =?us-ascii?Q?c/YE5wETuhoPzEiZugD14reCe5/tC/1UQ2Cu6Zyz0LHMolnqMIAobSiF9VE7?=
 =?us-ascii?Q?oVR4k35z0JAd2yitpV2dffJwhAVEhpdD/xM0ms1RPO7KL0ggO2JlLGScdF4l?=
 =?us-ascii?Q?hnJePDTbisBMOJQAk9Uy7kOoTpfAAuvtLlHv04iv3hyh9oHP26Ru+YwugEUX?=
 =?us-ascii?Q?wyJ5Jv2sCnd0COTMOU/rwRrLUt/dPvHD2nsG7dOxH2ACDZ9ud/Ulh5AmaEAw?=
 =?us-ascii?Q?Dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: at3bcc3eFtpUQeEeN1/zVsg+1UMm4YpKJIgEO6QvqMTch6MxurXd3yB7tbU6fOk4deguAMEKxargy53a8diKRSk/j7S8/XG4avtlB/vTqLnNplsiSStVQ0kB0jz1cNO8xahyaAaoStR6WGTxBWbvhWM1rjftTUQMqlh4+IPL+3BZTIULT521RfvEoYwMq8zihxoOUoFdnqhaAGEsQOU2SmynnOvkfFYjQjLfvNozn+XomIJ0qlfpEQoTV2YCq6dev8scguloiWSuVRenoyykgJp0dUpYvvotVQO0/VECUBMPTMJ1oeD5pnvJ2JZNpqoEDR3GqQ9KSJIbjlTqiW24Voblcnas3SL02A02cw0XMIsclY5QyNLxF1vHAA3X3PPH7H4i6XBGInmBLYwuSA67LTD67aK6gjrJ+r0EVtzGcr9FCkQ1kgNCE2CUv6jh0tBMKLIEq6ScXIXeSdQeBOBmrpYHqU+Db7AJiS6kK09LOZQcDmaQV4jsQWAbDuYBEkE7DQMkNTO+UPMiNpiR7wAe1hY/Xrs6ejgMfQe42RDvfJVT3ddwxxXm/KW9ScpgbOCpaXxurHBZemWCzU5injjoP/EE3JBu4W+UPFY1033wAiLKapyhG1ujA9ZIDIPgig3bYKpRwvMUnimj2Rkto8tF185dBMtE/xU5Qw+iuZXy1i8dV2FVvCEC8B4+FehInbJq9lf7df3niPaxDUVrt6OOL96i0jG1Gqc5dNfGqi+AWXSVQFhxz++ZEQLxzrcttfut
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c2c6286-7d5c-4121-1767-08db0a73e6d8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:01:51.4745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qMn6KaoueZy4Z/XipXk2et7/U+zPdXDOcztQdb5y0JkvSjAODwy4oYuujQMWJ13KdFJ479GOxl7PrGebnhrQyun7Zv+K9FzLyPPwodyyyWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5787
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090075
X-Proofpoint-ORIG-GUID: rTY7O6bp4mlOtb4O1vkySfIqYPXz3VJI
X-Proofpoint-GUID: rTY7O6bp4mlOtb4O1vkySfIqYPXz3VJI
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Renames that generate parent pointer updates can join up to 5
inodes locked in sorted order.  So we need to increase the
number of defer ops inodes and relock them in the same way.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 28 ++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h |  8 +++++++-
 fs/xfs/xfs_inode.c        |  2 +-
 fs/xfs/xfs_inode.h        |  1 +
 4 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 5a321b783398..c0279b57e51d 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -820,13 +820,37 @@ xfs_defer_ops_continue(
 	struct xfs_trans		*tp,
 	struct xfs_defer_resources	*dres)
 {
-	unsigned int			i;
+	unsigned int			i, j;
+	struct xfs_inode		*sips[XFS_DEFER_OPS_NR_INODES];
+	struct xfs_inode		*temp;
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
 	/* Lock the captured resources to the new transaction. */
-	if (dfc->dfc_held.dr_inos == 2)
+	if (dfc->dfc_held.dr_inos > 2) {
+		/*
+		 * Renames with parent pointer updates can lock up to 5 inodes,
+		 * sorted by their inode number.  So we need to make sure they
+		 * are relocked in the same way.
+		 */
+		memset(sips, 0, sizeof(sips));
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++)
+			sips[i] = dfc->dfc_held.dr_ip[i];
+
+		/* Bubble sort of at most 5 inodes */
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++) {
+			for (j = 1; j < dfc->dfc_held.dr_inos; j++) {
+				if (sips[j]->i_ino < sips[j-1]->i_ino) {
+					temp = sips[j];
+					sips[j] = sips[j-1];
+					sips[j-1] = temp;
+				}
+			}
+		}
+
+		xfs_lock_inodes(sips, dfc->dfc_held.dr_inos, XFS_ILOCK_EXCL);
+	} else if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 114a3a4930a3..fdf6941f8f4d 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -70,7 +70,13 @@ extern const struct xfs_defer_op_type xfs_attr_defer_type;
 /*
  * Deferred operation item relogging limits.
  */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+
+/*
+ * Rename w/ parent pointers can require up to 5 inodes with deferred ops to
+ * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, and wip.
+ * These inodes are locked in sorted order by their inode numbers
+ */
+#define XFS_DEFER_OPS_NR_INODES	5
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 /* Resources that must be held across a transaction roll. */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d354ea2b74f9..27532053a67b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -447,7 +447,7 @@ xfs_lock_inumorder(
  * lock more than one at a time, lockdep will report false positives saying we
  * have violated locking orders.
  */
-static void
+void
 xfs_lock_inodes(
 	struct xfs_inode	**ips,
 	int			inodes,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index fa780f08dc89..2eaed98af814 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -574,5 +574,6 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode);
 
 #endif	/* __XFS_INODE_H__ */
-- 
2.25.1

