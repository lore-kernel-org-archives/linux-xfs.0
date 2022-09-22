Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9DDFC6FA90
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiIVFpa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiIVFpY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:24 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45D68304D
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:18 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3Dw1r019736
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=7DO5Os2HwzXFQS2H3iLI/+753tvLcGS7MvqRAVaqGQI=;
 b=dakcQCiaQrkapn8kn47V73xgpEiBLX6eF7TfGOpEqbuC7e7S/n+83+T5kKmfWtuWH3oq
 mcwy1fHk8ikVAn9tP/+c63xS1beHmfXu8Mia2YT986O8iFs812WQifUPuhJrCr9e7Z34
 cy4WUdtAzixM1wNm98S6SleKtonBJ1tPxzkgoZVas7xIA4g8I5RlxBW7uRbh/dGc9Qls
 zNuFcaci9srTVuTJlAkeWKEwMVvCiSIhzwCGRbgmGoaXIZJDtcogh8dqCApYzIcyuYm2
 IB3+J2EPEpy8BMJokRh/ZyUd4ank0eY1+VvF108LWj24LbSvsGxruvHL4kFQWMbDVdlx og== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kvch7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M20Uj4037797
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:17 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39sd8x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VI58w1m2r8HtwIv3r6R9HUOgeqDxvjqNLA03x8Yd3yaLUCR5ouzznuZ2dOqFBDqT7kbCSTgoGPG7E/G5ntwviA7mwatE0d1pd5v10Ro/eNBu6BMxp1LdqDbsHplmFRtOnoy8YlIaW+sRTd59biVxm7GX2IgK7y28vZyuz+u6wt36e80WuYmtBVGxali4j3fA/F9seXErXevaT7CBagvtVmJrdXeky/hXeKOr566WP2wf7jN2XvfyXTjRlTElZqsgCbNq1TL++sMpeCncObkk2UTP6+KzZ7LtT/iSWfJFli0loNB2gqjRdE6z5LJWDg60te809998kXVvKkAtFZ+meA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7DO5Os2HwzXFQS2H3iLI/+753tvLcGS7MvqRAVaqGQI=;
 b=O6dBXAoxlBJfeiewgJiFLTln9NbgW1PcR/lIV+93Qo69VrWdZxmmtVf2yiP8d+zDQHr1AuqRWCnah9C5vJLhalYAq4GeH/fZqqUfzO76ksfnKZ2dC3f34y9PqzkbAMF0giA6cqk977MPjdf6xp1TJqqLD0c/ECdYve99/Xw7lYd+sECXOxiF9o4Fw27kRpKxUfKk2IbdYLIhjFEdG8DxLJwHxi+CpQrEaEareQlcK81iBkg0xKRup6jEKT9io+mJvP6By04x1OmHrqYHhudtI+c3hlRrelzd5PUJYEwKSdqK8LTV5nu6QFTb+Yxvf/STC5SG0pnWNdhl7hRQcVNvsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DO5Os2HwzXFQS2H3iLI/+753tvLcGS7MvqRAVaqGQI=;
 b=bH2kHq0R7TwEMOIuA4YmLULn0rw5UB/MhWg1FOWFi+AkutjSgAGj/qY1/HSDCUouWYCCp+G8l6bRC+k/EjeuKEyfiy2OY/KyHNWj5ZWT/hZmlhwByD9ZHsy+nazPPaFTZOpRw/AkkjLgqxLeE1kiI05vpFXR2t3UBdgpgKW5Qdw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:14 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:14 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 09/26] xfs: get directory offset when replacing a directory name
Date:   Wed, 21 Sep 2022 22:44:41 -0700
Message-Id: <20220922054458.40826-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0166.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ad44eaf-1038-4275-984d-08da9c5d9f6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LrMAkLq8EA3w6SUF/JHjGPxOfhj22bkSPSV/cBTNKcErMDxjglogoFJA9fiHQl1ev60s5OsryMi8qVqK5vmWIf6lzcI9jvY/Olac7F4qQOO6zBc4UBH/M6wXmpuPkuykY20w6hbsT+y3mrk6Gy0mZTyXWbtrPoJ7dFReHdlXvlCxB1laNOPZks7nZx8gd3C1J6I1j1t2pU0N9a/6xLyUv0nW3rIUhWFG5LqD34lgHhfCBSmbJ/wvQo563rgK/GPUYE1WC4rqVDFo8LNnNONH1bc//oO1QspRIU75Lqicxd+QOcOIaxYijtp2ZEOx2ByWkq4Rmel1n2cF9mnjsN3SWDkoU3hwuUJlpKSDO4y+nbWUjWNQRUF1c4/ayPAS0sqh4t5Q1H9FItWGfltluD07+6SfJxQpxfuaU2SddPCCS065T49rFSERZY+CUz36YHMY0+WTBwDs629uQ/vSf4vcAoQZA9h5VAU73RIiuIApYEs12kREMZef2m//QtAlYGpxyP2tU18+nRgz4D7lll6EaeO1hepSi/F35VlvbRUDsxm+5SbOW2FX/gwz89X36ejOdfr5RQGpvTP4BCD3IBH10h6t0tDZeS0mvYSvLwLwu7i3uz71l1gMZM/TOazr4+sqUkfMtWDjFv5ubSDr9YzX5AwURInAlsMEJAlvNiCUlPaSuNu+OCfxef5+5rAzDncB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IgoOmxNa2H1MnbFaMdv+tEs62tv50fQhGfB86RfGR4mzdgUSy3Zo0ifd9c4X?=
 =?us-ascii?Q?7KWp0H11t2lO2+zSmhPdeZRoVGjh/wFgYczP9hudOGZL6noF1EL0Vupn1KZG?=
 =?us-ascii?Q?GjCcDEUj8RGwLuvad38/3DEGBwPXoOrrD1qS5gpMhpHIIuecqOxhjxXiyamj?=
 =?us-ascii?Q?X/J4xuIordp/kMJhazd2ouPgABFYOfX+r6VKm1IjSLGh4bhJdlQNDWX4g11X?=
 =?us-ascii?Q?9he994dTJpVEt04yKLvNwtD+V49rQ7qMvxFnQx3Q4kenIPE8LkNghJR6+85c?=
 =?us-ascii?Q?eYEc6VdNTMuPxli32SZ9E5MODVWG0U4aEHTHYV8xGxbIONgFXnFKixKps6t5?=
 =?us-ascii?Q?sy4YnWim2v1FcOi1B8zZiR+9UbPgzboznSPBbGykhs3iO2YLTnw1iE8OhwXO?=
 =?us-ascii?Q?Ge9aYwPo21RnejaSpq8UxJMQYeExdnlG3Z39IKGWU8YgDGY9LluRjK3rzrE1?=
 =?us-ascii?Q?cPjRSOCtE/QUGbB54+fn556XsvfZD8tF47ARfGzgjJrZ0NowejmldSTgmDwE?=
 =?us-ascii?Q?4MQRRb5Yna6/VAdaMiF2qdyaSakDb++pYVf63BtDZwx3LWWpBA9jFPUvWTsY?=
 =?us-ascii?Q?LoLnP8rCWkJoOHTF1U22xw7Ivj30ZuUSFnIjRPmTZsjX8+jR+n5ty/znUZ+R?=
 =?us-ascii?Q?XdfA9SitmB5l8GIFpTU+qteFteCvyPzEB5/lsQpzvFE5n9jtdv+4JB0hCMOD?=
 =?us-ascii?Q?F3oEjHVbsniNG4b/jLFWmXKNu/t5A6NE2tVsEdXn4MbD2T/p4RAASvUtyNwu?=
 =?us-ascii?Q?v3sVXOgqDIFww2p+hEtYoD/sA60jQeEmtPEhSzy6ClJTLbWhGNBdBeDBYoqE?=
 =?us-ascii?Q?m79I/1D7Bb/svtI0uOowCNkWywBCWpuSv+L2UovEqLy7Ozvl8S83VsYXzrCQ?=
 =?us-ascii?Q?tYZP7pzi6v/igpzdZroyIr9GVObGHpviyKk/ZcOEidf9rLf/L7RP/Mt19e8I?=
 =?us-ascii?Q?LTTXNFTIO6E1JfoI2FGZDIbpUL5WeaqDKUG6W8a0zJE7OGZcO88ZE9/Av2X+?=
 =?us-ascii?Q?ZdtFtWKvalZUtS5kBwN4calyg0ZsJQh47LKCUGuVEZR+a/7+oGf892V6ucDp?=
 =?us-ascii?Q?BcwTibwBqnYPl0vq89txFzGQKKO75X4hmeVA3eBomRPXtxEwfiD3cqZWFJv5?=
 =?us-ascii?Q?HLZ3UaBo/cb8vtXTxommCjcOmXud9txJ+Jqa8w5TFxiWjILuVAdsC4Mt1GkE?=
 =?us-ascii?Q?vjcjkETy+rfNj18RYdbiRSdGJH6YCLQpnXeKBP82F2AFUZHN51jEQSP4xM/T?=
 =?us-ascii?Q?kP14hSNJfcwJ+g4/QLJYUokzo7YIq4FZSfV1IYXZkX5nMVYgQQ8WL0OAUfay?=
 =?us-ascii?Q?rEnzz6JJOga8hmXMjkwbZ6A3930SQ/KXBKryGf4fcNTdNdrLbpEluRzdf2Gp?=
 =?us-ascii?Q?aFIH9b7DQmgjaFtzs85RDlaoQxBId3EIaMVSmHPWKMhDG/Iw1prC+CDAw0BY?=
 =?us-ascii?Q?5tGPR0nFmlpLm84yW17cqAiqBdXsLltPvK4egBaCAAIGPjzItBs5sCTHMr4u?=
 =?us-ascii?Q?JN4a/NWEnUrXm4QQZFQoG2j/HCfs4P+s6Wk/XI63sVEsuag64lfg96d+zbwj?=
 =?us-ascii?Q?hsq7omI1LbA3HIBYjUvdaFWJMaRYxjiMPv3fSk4USdkNM/t2o1QcZEADEqgV?=
 =?us-ascii?Q?rg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ad44eaf-1038-4275-984d-08da9c5d9f6f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:14.7910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EVrvpavzz6CbilFWdi+m+BFuHZ0TRM1qy4YB5XIJDV46MuxRKezgAKrDWKySmjTxzlYbXJSkycFVkYUzzTs1E2Qw538OTECZJ2RRcQqbLW8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=981 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220037
X-Proofpoint-ORIG-GUID: kAXeJXsDV94qbSQmvS92uAQG3MazmXIq
X-Proofpoint-GUID: kAXeJXsDV94qbSQmvS92uAQG3MazmXIq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when replacing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_rename.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c       |  8 ++++++--
 fs/xfs/libxfs/xfs_dir2.h       |  2 +-
 fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_node.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_sf.c    |  2 ++
 fs/xfs/xfs_inode.c             | 16 ++++++++--------
 7 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index e62ec568f42d..e603323ce7a3 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -482,7 +482,7 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
-	if (offset)
+	if (!rval && offset)
 		*offset = args->offset;
 
 	kmem_free(args);
@@ -498,7 +498,8 @@ xfs_dir_replace(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t		inum,		/* new inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -546,6 +547,9 @@ xfs_dir_replace(
 	else
 		rval = xfs_dir2_node_replace(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index c581d3b19bc6..fd943c0c00a0 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -50,7 +50,7 @@ extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index d36f3f1491da..0f3a03e87278 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -885,9 +885,9 @@ xfs_dir2_block_replace(
 	/*
 	 * Point to the data entry we need to change.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	ASSERT(be64_to_cpu(dep->inumber) != args->inumber);
 	/*
 	 * Change the inode number to the new value.
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index c13763c16095..958b9fea64bd 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1518,6 +1518,7 @@ xfs_dir2_leaf_replace(
 	/*
 	 * Point to the data entry.
 	 */
+	args->offset = be32_to_cpu(lep->address);
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->b_addr +
 	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 39cbdeafa0f6..53cd0d5d94f7 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -2242,6 +2242,7 @@ xfs_dir2_node_replace(
 		hdr = state->extrablk.bp->b_addr;
 		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+		args->offset = be32_to_cpu(leafhdr.ents[blk->index].address);
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(args->geo,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index b49578a547b3..032c65804610 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -1107,6 +1107,8 @@ xfs_dir2_sf_replace(
 				xfs_dir2_sf_put_ino(mp, sfp, sfep,
 						args->inumber);
 				xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+				args->offset = xfs_dir2_byte_to_dataptr(
+						  xfs_dir2_sf_get_offset(sfep));
 				break;
 			}
 		}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d77aec375e38..6eb264598517 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2487,7 +2487,7 @@ xfs_remove(
 		 */
 		if (dp->i_ino != tp->t_mountp->m_sb.sb_rootino) {
 			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
-					tp->t_mountp->m_sb.sb_rootino, 0);
+					tp->t_mountp->m_sb.sb_rootino, 0, NULL);
 			if (error)
 				return error;
 		}
@@ -2627,12 +2627,12 @@ xfs_cross_rename(
 	int		dp2_flags = 0;
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
@@ -2646,7 +2646,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
 			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
-						dp1->i_ino, spaceres);
+						dp1->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -2670,7 +2670,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
 			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
-						dp2->i_ino, spaceres);
+						dp2->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -3005,7 +3005,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres);
+					src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3039,7 +3039,7 @@ xfs_rename(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, spaceres);
+					target_dp->i_ino, spaceres, NULL);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_trans_cancel;
@@ -3078,7 +3078,7 @@ xfs_rename(
 	 */
 	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres);
+					spaceres, NULL);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
 					   spaceres, NULL);
-- 
2.25.1

