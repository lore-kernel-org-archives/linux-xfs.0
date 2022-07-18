Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD8BC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbiGRUUm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235106AbiGRUUg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:20:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BA32CDD2
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:20:35 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHRCn8023354
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=+NzCibinHp779v1IovjYIjGazBzPOeOx99XbFZqICBo=;
 b=S4kyP4oF+lIhXWtS5ZL6wbQVnh6m2ew/FRyVCwpgu4TLzJuIkHp1KRDMAKmcjKJykmZP
 5F9hgRi5DPWDpWtv12V3rER8CM5VJO242Y33gqje0mZv+s+s+kdmeqVCS1ztlxeyaBGQ
 2Tphqpd4BwCCfE9T7+XngBHOedjsPqPf8dkxFCK3dvW35pHEl+lmXAiWHGgzyCMwVyCp
 o9zNGXLQ6ZHt2jvOUyuVVUCYx/TVXevYamd+u89YIZEt7xVPq8dUaNaq+Ba6offFb/sB
 FvTuu3sXfMwYwJveu0RgPz1zJ3b53zn2B6mmJB3Ztp7frTEtoCEByT7yWimOuJiGOOIt dw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbnvtce40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IIp4tA001290
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k2sfbn-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0jYwGnpTA3av9SP8vBcRYLJf20sxg7fpDjjgkTf1sLMoewaLQAHRBZFwfJu6wnNYaUhNv75WwNGWH/bOsatERQ7LXPANM5n75yeRADupnTEP4PBltT71zgmanobjAyKHzXOXeFsdYW10eDpSnI+FIg+OdNtarieH11A+pmdAxGXHAv/9ceWCFZehAzpEWMdjXM2sV9J0KN7DN1kztEtg6Bq/Gau+eTQdomtASLzJXIzj0pu5tiC2wOgLipIhNUeZTzuX4kJS5CBEwD4dismkIJLnirA2mue8f9oxfAUBBq111i0fsmCM3d+7Wm9fdf0LxRfRy/Thw8duPU68GJnDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+NzCibinHp779v1IovjYIjGazBzPOeOx99XbFZqICBo=;
 b=f+VFcYOFJdSuC/wfa+N7hKSZXDPZI/sqaMtchY/xOjeIycQV5QZnzTwZMybwEan2I1yEoseRMnxIGwLX/rTaykGk9FwvIsvTo+Nj4Ygxz12JWvVU3u+i/etNiE3Tq2c/UCkFQV93i9cNTuv11nI0f/IiRncgVk0VdFTGagfeiCNYSU7jvCctHj4OqSC1GsRho2vNr7PuHvze8JV2BFcxuR1aInQ2A0M7OWuB5soyNgsaMtfV6u7UEUSoaC9tYClr/1QzpNLZABC8xgefvb1CDv23x4NKpUGT/yDqomrImoU5wESctACsrEwyjsZ73S6vVA7kYEx3td7IwcjKCMG18A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+NzCibinHp779v1IovjYIjGazBzPOeOx99XbFZqICBo=;
 b=N6GXDmpyMGdXuQ8wHmX6lTzZJyknjukUhbaanS3dqU31EWqbzJItLvYtE1YuleL/BWYyTe+cwNeUYG/lCtMyhK8wSEWu3D6wEqnnw1y0MmSsk9kcvUmgoLUHmVfKJCs2AWF/A7hcTlHpJPVnsen+T0AA7kKKKuqScYHUw9ODOuY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS0PR10MB6128.namprd10.prod.outlook.com (2603:10b6:8:c4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.23; Mon, 18 Jul 2022 20:20:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 20:20:32 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 07/18] xfs: get directory offset when replacing a directory name
Date:   Mon, 18 Jul 2022 13:20:11 -0700
Message-Id: <20220718202022.6598-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718202022.6598-1-allison.henderson@oracle.com>
References: <20220718202022.6598-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5daab38f-1b3d-4c4a-f962-08da68faf636
X-MS-TrafficTypeDiagnostic: DS0PR10MB6128:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IDGu2qxKwIeULFumBZNkTUW4r1jVJ4r6vZMSk8Zd+5jYi7zuGXTwpwsx73RQxQhf2+iydD/b/vQdwXPN7e83gYyL/MaeswCi3azaFUdBl1iPBUmVDRH0sjrG8O57RT01Zquf8is5HzeuBNLaiabTjuuE7V1TW/wfi4fdcZkCObInyiaLYnkt3Zizt8sSr2lbip8lRXjI6O0umT84PwRpVa2k+iewh7oPkImi9ZoAmWQBF9fD45ALuD0JmvtDKvGoNsYa6GSZWK16ofvwWGJo9pJ9iokrtLhrOKIWgfu3IwMXnyxk964Gcd52zI8qG1z0zLSdM/vuVH0KoOwzPDTmEOqiQfXbGACwjeD8GvPk/6MmDU+5tMY1iF45DBNvTjcQvmOcN3tXZZBfys7j+0cUJIKNn9CFTuNh7RSUKUaL/xB8F1OtrSCZ/JzbGY++TaN5YuOyhBiXtkjlNaioJoo3cKevBpLFjj3NjvF+0RGkuKTIy8g0btaI3W/Zj/tHZ1UndWkoFJYC83DXNx1yAKimvXI639QauuyWlU7TZfwVBshLaM3Tc1kCRLKQ5lYJfWvOyfkMwGeviGz6RG1p96FzHTG7Xgt7BTlNcpBNvSm7EZsXcNuFwKppr0uwHE0Emy6bV5biIu/pSe/IfhrBH+m/VaKp26zVRa/MIin0Y6AxkZ/YYG2Dfst+b9hd6h96M/V0BbOwecDSx0N4gWQEOtT/War2WA8JsMnWBbOYDqlhFsFDZar8jwSDZvUWWwaMvW03r0+vliKjxYKkkv70QFzQ2JU8aI9Nk/MuXEmAgxr4s2g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(376002)(346002)(366004)(6506007)(52116002)(6666004)(41300700001)(6486002)(83380400001)(5660300002)(478600001)(26005)(1076003)(186003)(2906002)(2616005)(6512007)(44832011)(6916009)(316002)(66476007)(66556008)(8676002)(66946007)(8936002)(38350700002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e7UZRdOhQPOQ/HpSXryrU6o2gm03v+zOPXOrY4Yk6D4XWczzeju00g3doyXY?=
 =?us-ascii?Q?1k9vggUNOZcoWDJD1elYjQLOgZGa/KAX/XjtGJccOU5Xvw0a1EnR+c4+TwI3?=
 =?us-ascii?Q?EpjVRLa5cmEvoLcoSw6uu/grsO5d6GLUoBAiEQphJOKQP8fXcXt8l3GLcv1q?=
 =?us-ascii?Q?LyRHAY5uBBybz+M9Y4/AtVltdzJOdmAKGHM81oQa1xiLpOfGBqeuCH8UC/JY?=
 =?us-ascii?Q?fB8ekcNVycMWSJhlvGCI+siTYJ2B02B7sg/Nq4nGRkc4uOTDzH/WxMkKAahl?=
 =?us-ascii?Q?gA6hUAALVhkZENaSU8hKJfw5ou6x7I+lzLQ9L4smMQ0og7aUCGuOdaniMcoc?=
 =?us-ascii?Q?rSI0PsbK7lbYWzgIJlVUpOUl06V0GkIZoMx3E8mbUySpg1cqyPOItZkR0NC4?=
 =?us-ascii?Q?A7lFrZ1GWDJr0ApCpI/s2mNjVwBAYRMSc1yvv5YDgPwU11t2Kn2KCfkRSRzM?=
 =?us-ascii?Q?oA5vatbwbd989w3FMacQEPf0Q6WGJWznyLqjx8t3GB/vqJa2b+aL0R1h0kmF?=
 =?us-ascii?Q?axivpz6Aw6qqOlCkHShZRPvxM9b8y6eUhjRRgFEjq3a/cBvoiku4GV5rc7jw?=
 =?us-ascii?Q?8m8j6apNFZlKXwfzNRTRmJ9npHxQnYmiEsC5eFWdZTLVoum3xLv0Fm/RjRRT?=
 =?us-ascii?Q?BnlrX0GAwHNEy2GRDorZJdbuzbD/Vn/VQE4msrn9UNEDVm8i9HYm0nZy2Eq5?=
 =?us-ascii?Q?xFRnbaBT1/rNNl3KQyB5kFxYhe7nMDtmq51G9+hrZUFjdUujE5slfZsTM/8e?=
 =?us-ascii?Q?s67PKvboBPnWO3oWMjff7fWk0na1T4hj/svpyIvBQgH+RXEBKmJzH4huRceF?=
 =?us-ascii?Q?yAOFtKMQBrsAiSnXv/OrXZ7LfzaXPXMtacL+QOvmkpzw1/U2hWPxvYQzOeTX?=
 =?us-ascii?Q?5Ya23wTuLsjT9Dgpr0nxg39S/PdeMVTU2N3iYxyOkzglHgV/CSU1dFsddEri?=
 =?us-ascii?Q?8kRiAie0chXufkvBar2PzagYm2WE2D+6KYmYKQpOwm19BQKYfct5X1lUsu1j?=
 =?us-ascii?Q?oadsElHLyz/gbyX2tPzqf9WyDkzc6oNpkDgQMqgdeUaqzs1kta1e7z4hWiAu?=
 =?us-ascii?Q?0S98uxFK7uJ9EV1hDspGcIg1qgg7QB51dg5TV0OgimhtRbmnCa34KTEb9fkC?=
 =?us-ascii?Q?ptMXuDfOi/d96++65leYV+LfinVA26MA4OCs630Nhgtbj9LkN7BN/WmOxY46?=
 =?us-ascii?Q?F5vraosMq/CdNK4KtJOT8yJGLiFWQCkR1zeZ7Uzgfmqq4BNgMyQrQxQ1H1iy?=
 =?us-ascii?Q?XmpSiQrrSiMUOX8UvpwgeZxhpIdlhyzBoe4bU5mzAhRqlRe5BlSZq+8VsF8D?=
 =?us-ascii?Q?HNeSOHf4x7M2DAjCSTH3/Tq51ZgK29qlL2sdr2nJZZ5U3f/Fux9hpoVVnRuj?=
 =?us-ascii?Q?K76VZ9zh0GBy5WGVvZtXbIenCOC/p3PMbGFrgeiF6GF/I5OXLNwMlDU43NIS?=
 =?us-ascii?Q?ecfEPgXyWIikBx5fS+EFW8xSk5vQRYVwUOW8NlMG9HucyFfW7HyB62WXET18?=
 =?us-ascii?Q?WVIwuyGrVxOCMK2pKKPCmlX69ggzAitTs1RisVHygZhmUsp453BSG2PLg24a?=
 =?us-ascii?Q?Rfd7/PP3XcF1K9mCymv+0dV9URS/iELsuYLcS3xdMxxbM0E+sCq8WwS6v50x?=
 =?us-ascii?Q?Xg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5daab38f-1b3d-4c4a-f962-08da68faf636
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 20:20:30.9663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9gZ4ONrOgOgt89U0PtNUqQAQZirx4VFIzyiOvY/JXPvZRUm2zac2Dre/yPFdaMPvISrkEY410wete+PiydWjKTrou7ecbJwGOTw0r6fZJvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=922 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180086
X-Proofpoint-GUID: BtLjMqaAxqwnF18CXWGXGu_bKApA7ML4
X-Proofpoint-ORIG-GUID: BtLjMqaAxqwnF18CXWGXGu_bKApA7ML4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Return the directory offset information when replacing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_rename.

[dchinner: forward ported and cleaned up]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
           Changed typedefs to raw struct types]

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
index 2dc1d8d52228..2a8df4ede1a1 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -1109,6 +1109,8 @@ xfs_dir2_sf_replace(
 				xfs_dir2_sf_put_ino(mp, sfp, sfep,
 						args->inumber);
 				xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+				args->offset = xfs_dir2_byte_to_dataptr(
+						  xfs_dir2_sf_get_offset(sfep));
 				break;
 			}
 		}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ce888f844053..09876ba10a42 100644
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
 
@@ -3004,7 +3004,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres);
+					src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3038,7 +3038,7 @@ xfs_rename(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, spaceres);
+					target_dp->i_ino, spaceres, NULL);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_trans_cancel;
@@ -3077,7 +3077,7 @@ xfs_rename(
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

