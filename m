Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 046A8C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B143864EB8
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhBRSqa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:46:30 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35632 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbhBRQrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTiDe040357
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=i3yKMhImNEyFq32P2qdDjQAFlZYT9YDd3rqPl998lcw=;
 b=EToOrzCUF19bjprP6J3EqFq9G/nuDLeq8PSeWaVTteJIqV5ZT20g1FgYtn2l06FtNDGi
 Do4CxtqMDm9FEpvmWA9VYtPxpTCl7ZflZqG+O+RB1I0l8g10Jcg66LebY9rDEXOtSRvX
 HII/MAQyAOQJ7NcgwPie4nqP9EPojJT/ImneniUEecOjVeaIONGdTdSYKvytcl9GDVaV
 Izl/I9/xmrNYwDfBREAe5CXGIKclSrP99gHF0yUiCH0rqghhhXurUrmkd3jCJ1sDBsPG
 m6nh5PzxKGh1xic695baIVMF368W5FX+lRCq1Mh8alhQMPa2fDaqMRqp7xsfvzthk4nw /A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36pd9ae3hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTffn074752
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:42 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 36prhuf43k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2K4r/THdoDNXBg3laG34kkmcZUFR78fnFQY3/Y0WuACpi84zgbkNN2s8Nm0+9+lCw/r1C9sP/rVfzZtmJxJZks8ay1YZYDYZyGwZ024G+uOlKl9OjDqYzVrWUwH2RBxN3d0GrR2npMB2JnBGgTgqcvrR/49LatgfG7/I2b/5HMHdopjeB0VUCSQ7iyW3+3TYz784l4Oimpp23TXepIsAQc6R9w/GeepJImCnvx4/xwJICa9VH0MBvIgmdH3F+7UVVIJHkvGRjXlvAZbgNRv9cG39Q0wrTIeX50qObpjNwpJlURgeqpvU5Pr1lB0k9uZDv7N+Wt9xDprC4VhNPdmEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3yKMhImNEyFq32P2qdDjQAFlZYT9YDd3rqPl998lcw=;
 b=FCwRKWnrAZLQ9XG5JB8pO5m8y5VcKrmwlE9dy1Vo5ydbzK3RleXXON7Q8i7GHYh42iR1QnD19PpahJxmCBvYMnY0Ck49I6aOoYhcG0c67azGE6M0DzUYTZ+kQWmERdLRh0rrTxE0FmKNPnOslomUSMhaNMl6WDVk8O2fwZ4sRrmvSFJ83sd2v9xP/LkS+HpxcBA+I+ooZeKU326pTjkz8Pk6Y4nq0g04Z9b6BDL5na7NmrvG2LvmbznFNGtfbWvcXDuG9ZoiIU/S9NE6ahLqLIZXbrsfH8QcDmRqnK5tI38nlBw57us0YaCIQ9y1O2vMNF83p+jnKf8ilAGTtuknmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3yKMhImNEyFq32P2qdDjQAFlZYT9YDd3rqPl998lcw=;
 b=eF3ga1r1D4pR7XLOx46kRcz5FC1o2CK9wGMK76VQ4QSgb051cAEctiFOoH5ei5TQCzMH8dmT7Qow6Hm7mfkp4/mEdf8lzC5F3Z2krTKtKExDkwCyhpZdIJMxk9FFL3UB0A/3AXbHBpgg4PVSgu4MFPgNTpzJMMUvr2TjZLF7lPw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4495.namprd10.prod.outlook.com (2603:10b6:a03:2d6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:45:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:40 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 19/37] xfsprogs: Add xfs_attr_node_remove_cleanup
Date:   Thu, 18 Feb 2021 09:44:54 -0700
Message-Id: <20210218164512.4659-20-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3806f70-595c-4935-c130-08d8d42c9fd4
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4495:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4495A563B584166D7099544095859@SJ0PR10MB4495.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W7QibpZR1Su/MgQwGNxC9W7KqedoyucgrgNqCn6DHpDrzFhtYws74g7VdS6fzJJ8jS2Et41KgHd2k1UdOGWuVglHNnCLHIs2n4HgxDFK7+sNeFFHPp21Y9e0DuZK4y/p7O8GNFu5dVdLY3AXpVHNjuX2DPzrqWcguoRM08HY+hWIMhULN8Kp2WjM6O9opi/+PTC+x8t0F48Q64QlpnMUd9OIHNEj4uYQ8rwr550yH3kD/E6Y+dOPVwu5UeeyfOyq16GvuFUnjkFBX9nD8HiiNBYv0jDtpSQ4NImmraccnICN9Q5zS8Mq1U23eYNC4LQJshfW4b/UZt1n0jvFfOq1nIx+o+25nUmCYtoAKYhfZE5RsRpe7aBqdiDoZROYmnqyge/ped3B2zhIhs5AmrAAW+PGAp5uY4UPOe4WPminmAvV5evMOzu3FrBnBNlNEbElZD95BFn4I8h6dKYIk1waG+m7qew6tCRamboPcaLPGetOtLz39muJ2rY0zChzECPhGa31Scx1J3JLYkZSwuFqcjZCridU3LJz/0/Qq71Y9tiiwHP7eOByQOA9lHeDPuCKYrZ+zEtfC7wYAerROlvzCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(346002)(396003)(136003)(478600001)(86362001)(6506007)(44832011)(2616005)(956004)(83380400001)(16526019)(52116002)(26005)(6916009)(186003)(2906002)(6486002)(8676002)(6666004)(316002)(6512007)(1076003)(36756003)(8936002)(5660300002)(69590400012)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?H8od8oksTbvIFaKfMHsQoVeksGG/zPUU5UzIJlKChpCVyzrAF3EsGluJ9evO?=
 =?us-ascii?Q?LUnExYaQ+v/3c0ODnCm1d+A6jT5MC63wu2nGWuXjmAe9Tah/+XTXu/foiXU3?=
 =?us-ascii?Q?DdqeLV+MuyQwaycaCsYmmMwfpXjkMOI/htgfdEGNFV5ltniIfAshNAApn6ho?=
 =?us-ascii?Q?+e7H6NsmN9MPDqNradE2avXCA9iHeYkQR/1QEiYitktar+OAhzJvW4ThLjuB?=
 =?us-ascii?Q?PMFJMXmemeqiv2C2709t27vprEnF6XbIF7oYGJURUN11kWvJ1RGNUHPa9T/s?=
 =?us-ascii?Q?y5vMVdVp9xXSbRgwzpiSLZpQ2uzwNYvM/oqWwdXwucjOxmn39C/4vUEnzNwo?=
 =?us-ascii?Q?ck4sQGIcBWoQ2vAKDULeBugZJAuUg9xEkChowNEwEMBDWwDxw52nJgZk+Vd7?=
 =?us-ascii?Q?c3ad6qs6eLqiNAkycOlk/gIPMXA38tzsSb7dFd/NylyEACDW21+CciOJu9s7?=
 =?us-ascii?Q?1YD9vg+RX+UaTkuCGpNhDFxlCT1QJr1YjnL9eNQFG8Rih/pjwc7ZcWYy5Btq?=
 =?us-ascii?Q?2IvJTlsSHuDu6WgVlXetW66tlLW5DYjXAveYw0wBHFPeutrFvdjG2PZfPUC6?=
 =?us-ascii?Q?2YocjFvm+N2Lezbm62yAg24IwIQWhMxfwhlZBC5dDzQa7ni6vS+PfLMXrITm?=
 =?us-ascii?Q?8HhqlqfExt6lfxVG01/R90HV5r+4raf9K1TnevK0Jlyr3P6Rh4oa1L7DjvqZ?=
 =?us-ascii?Q?Xtaf2S8Yyy2wwzvjY2mistnqsTPQS1dAj3ujcJWoL1374xOI84Unxb8Vevm6?=
 =?us-ascii?Q?bm7K3aAu4oMvISKs75hk+kmfTklKPRg9R5HUtbT/+QvfDyOV61r5Fn06yGGY?=
 =?us-ascii?Q?xkc1jslkssTb1FjuH+W2QJV9+RT6OwTJLRBqBnvruitF7cj6lJYe2bmjIfnH?=
 =?us-ascii?Q?1pT3NCtf0l6MQWljvzUlgdvmgnzOLQ08uC89f2APOyjPQi8BMB/BZQP9fwkH?=
 =?us-ascii?Q?efer58pUl+kZegdq8mdio4ltF/5sWs6UVa1kbNk1l8NQyB2SAxgHlOXFwbbV?=
 =?us-ascii?Q?c0fyBQvPfeYrr8sz4RsBdPpE5D3CgXzK3bwr74SxTYCpRT93SGjhvTrKOnDZ?=
 =?us-ascii?Q?aurKxRfPpftCUSOxodjxKBrHjSmbBrU11AQna/i+sPmqf1OEXUt/VYWlQQ2T?=
 =?us-ascii?Q?8HwU+1VIZkyx97IKCkY5uEjrU61qRr3YdXDAmMQDrvTu8PaOAHT2eC5W6Zeg?=
 =?us-ascii?Q?t19LNVRhJCPqtEn5wK6/Xyp8YPkm+mDhkBoJzhse2XoQIHb4tRt0ZF/AtZej?=
 =?us-ascii?Q?1wEPKKxfJOE0pFH+8/TWy+Y1lhSgniuzxluoUpb8X1I+dESxveAmVzenBLPA?=
 =?us-ascii?Q?TnqHLA4qD15KprUgJ/wCKQgJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3806f70-595c-4935-c130-08d8d42c9fd4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:39.9608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1GQTutIi4Z/gQdK1uOznkCLuE3+zg59LooZN/mvIH4LoHJvhH67VJL1a10Mp1qlUsDNIk/xHs1RYCV/rWOupLOYXUvVVYRdKt1nadWe5NHY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4495
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 4078af18570ef0f89fce18e9ed9c1fa0c827f37b

This patch pulls a new helper function xfs_attr_node_remove_cleanup out
of xfs_attr_node_remove_step.  This helps to modularize
xfs_attr_node_remove_step which will help make the delayed attribute
code easier to follow

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index bb3d2ed..663c04f 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1233,6 +1233,25 @@ xfs_attr_node_remove_rmt(
 	return xfs_attr_refillstate(state);
 }
 
+STATIC int
+xfs_attr_node_remove_cleanup(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	struct xfs_da_state_blk	*blk;
+	int			retval;
+
+	/*
+	 * Remove the name and update the hashvals in the tree.
+	 */
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+	retval = xfs_attr3_leaf_remove(blk->bp, args);
+	xfs_da3_fixhashpath(state, &state->path);
+
+	return retval;
+}
+
 /*
  * Remove a name from a B-tree attribute list.
  *
@@ -1245,7 +1264,6 @@ xfs_attr_node_remove_step(
 	struct xfs_da_args	*args,
 	struct xfs_da_state	*state)
 {
-	struct xfs_da_state_blk	*blk;
 	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
@@ -1260,14 +1278,7 @@ xfs_attr_node_remove_step(
 		if (error)
 			return error;
 	}
-
-	/*
-	 * Remove the name and update the hashvals in the tree.
-	 */
-	blk = &state->path.blk[ state->path.active-1 ];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	retval = xfs_attr3_leaf_remove(blk->bp, args);
-	xfs_da3_fixhashpath(state, &state->path);
+	retval = xfs_attr_node_remove_cleanup(args, state);
 
 	/*
 	 * Check to see if the tree needs to be collapsed.
-- 
2.7.4

