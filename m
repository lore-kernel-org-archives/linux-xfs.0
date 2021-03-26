Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44551C433F4
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2674A61A01
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhCZAcG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56904 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbhCZAby (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PRwf057948
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=bmmikxgvZCFZfci74fodHJEb8oQjKo9Vq3N6pXDvSrA=;
 b=itVKadtY/+68U6RwuQP5ysgofqxqd8VM9dFH4wQxBYPnSen+hBNXhvE9rzp9yBRvsL9M
 SCWvCmBahGbEGosU+fBp5kEwzC4GaijBa1WKAw0nsO3K/FEK972M8e713q02UN4RXx0D
 DKQVKp1Yf9YB4qDyYcL8NLtEx2Qdol541fE953MiuYwDUn2DfX/jS5RuxPZLQWNCvX39
 NFXbt+mPm3jFNGMJhQf5vKTYDsNLOAOrnAiXR9iSVAsHdbVeEQO2I7RxJ5AVCAEYxLAe
 XJeNZY9Ysn68JJDXGvw2NBGJwEXqRSkBIRf8HtGUb6cC6IR6Bklne5M8qrXiooUizRTm cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37h13e8h4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PKkU155633
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by userp3030.oracle.com with ESMTP id 37h13x047t-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ylodb2yoygENVL3s7x1Z3b18jbXRLP0gg/osZsnOUwToZ+P/YaUl5v0e6e33OLeiUIOdVyeA/NSaHhlWXG6mexIMmnBQz1NNQaCpRguaV/h+Sjs6xxN3I2G9RQvS+/nSg7Tl2ci8meIw2uZDwmRYBFVXbedcYCAmLoBgmPJEd1IaSBnpYdx8jH3wYLCl11gcg4e+yRNu5duyCfMIZKL+li++N5JkZd9jZMogK8+ThjLWe/vtOqKV7XhyKc++KBsXKkDSJK1BvB8rr3TSsVNoklEQJvQ6kwCelE6I5bl5K987pBg9QK8B7Kt4Gp7jGxgvyxf0nzEa6LmEvYEKbDn+QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmmikxgvZCFZfci74fodHJEb8oQjKo9Vq3N6pXDvSrA=;
 b=CUXPSRLU7+iXYt3c8LQKsHEsZ3Oz/O4x8rIw4auDlhfog3EjIf0f7xLPO42HkoRURN30tli8Fl1884kOhI3GfRoEkeJZKfF+zv2g/FelOn2o2awq7OGGljrG4y8LNFOaaTIDqE7RgekoDclbiUEHKuCggk1PCe43O5aA7PkT0G7XRw6gAJclC/ucasJeZ/g68mgy7gBmtpikn4jn8/OmpIL9lr0eJKDqfLKloMJfjsZSTNbb/wNA0RfQ0N6pzIkW6W+OQVzLLfjF0HmiTrBL62jKTv/GV/CQ9xIQan5T6cP8NEHBmJD4lvvbx9B/OwAgDjRk8db0RkgxPVq/xET0xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmmikxgvZCFZfci74fodHJEb8oQjKo9Vq3N6pXDvSrA=;
 b=aKXRXcqZHPTaw6+XhUvXsps/YpFoSn10ggsw0tgN/0kmHwlPUaGej8LrZP8nbfVzr++MNryXlcpYCR7JSdUiwMjBMNX1mG9c0mrhEd9euOPr44mDCfRXqMybhEC2LtqOuCQlO3ozGoQpfw3qk2NbxjHn+Cy3AYaz+iGrx0cTPHQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3924.namprd10.prod.outlook.com (2603:10b6:a03:1b3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.25; Fri, 26 Mar
 2021 00:31:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:49 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 19/28] xfsprogs: Add xfs_attr_node_remove_cleanup
Date:   Thu, 25 Mar 2021 17:31:22 -0700
Message-Id: <20210326003131.32642-20-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326003131.32642-1-allison.henderson@oracle.com>
References: <20210326003131.32642-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d3df2c9-1e40-4a0f-5a48-08d8efee8ad6
X-MS-TrafficTypeDiagnostic: BY5PR10MB3924:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3924206AA1F2F7C1B06CB71995619@BY5PR10MB3924.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fvXVRT09ZFPi2kx1LAcarMyz//Jgb+W1DknSInv00ukZ3PmEZ898xiFmgjaZhMkb6VrOA7kGyWjGMDCrvm4/N+MXCHYt70Hd2Jk6fSwnjeoyfNbpHN+EBKTLniOPkWO/flmMgWjhbyNpS4L8tcAeP2cWc5+57gQCQ+Yousv1QfHq4X4RdeTbMhKXAuwwOEXFolHax4Oxp1KhnLTgplANUBUD+0GmZQW6OzyTDFERKemvrnzhthTEH4j4TsDl752AX2VhPA3MyLkhO63TBoQHJpDtGk30XkRH7YggD36K2HD6KP6pcBLnxFYstvDeO1asuP3ALzrui2BI82m1Z9cTciU4Fr1zWhX+duUa8Uf0gJl7f08dfi+1pzF2hT+GeM0Xg6kz24cQyxe0simYuH5n/AcxG6vh2P6LQcksR/bswc1UL+9clYJdPeb0XIQHccVlgx1QaANHGX79WhovEwbiE2KyGAKS85AAqW8s0UU87gDlPY7q8k7/kV062GIGxAFKfDPiT3wx2MevjbKLEAJJkz3836tVdDqCgYop3VtDjlOlxxpgfx01o1VUOomuNqop1zG7tWdEx9CRFXRYvMIw8FeZEj0mIByz0gIvTi3S8h8teJvt953qSNPuU4pwU7NgnIA5BBV1oLEWG+5zNUBfJJto2qI4i9wbKiOd6K2nHXtnbM1vAHDZUke5x33xkHof
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(136003)(396003)(366004)(6512007)(956004)(52116002)(316002)(83380400001)(8676002)(2616005)(8936002)(6506007)(6486002)(1076003)(38100700001)(26005)(186003)(66476007)(69590400012)(44832011)(86362001)(66946007)(66556008)(5660300002)(6666004)(36756003)(478600001)(16526019)(2906002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?esACemqRYGRO21awVGg3s2Hoaf5C/szxHo9dnStR5mBK9JBYmOjrLi3qAMmR?=
 =?us-ascii?Q?s3cwhVidFc0Y1jPQjrrSGTrOIzeUmzp18fhJ6IfWKkC6DGG7JpLCfrNxyhB4?=
 =?us-ascii?Q?t4e5RTnePogCqKB8kEJDCZYL3Iam5BdH4AVpSjGDeuP5rReMRpML/Envf/jX?=
 =?us-ascii?Q?D6RM4q1npkU+/FetHEnGOg8pie2tIlG2pcQdi4z6vJzf35Zl+KZIvX9yi8QV?=
 =?us-ascii?Q?Fm2tjZ5aUezKz4UWQ1KRU2b1D2JM7WYj/lfnv+PG4jyOiqVq/ZuTA0RR20vy?=
 =?us-ascii?Q?IYrPb5st9LFtKrwD3PnRelllK1fDyHrTfu13G3EkPc5KUuVsSBG38CHgxmLN?=
 =?us-ascii?Q?JlEVzGV6XrT6g1se6PYTXwCPusFcMpTlRYd6uOPo43gQU02Egf2wxHFfktep?=
 =?us-ascii?Q?QBo+bc6KCcEgeJPruR3kaUaQ5yk3T9BL0SUf0OocaIVTC7BgtiYiD7kQT/7G?=
 =?us-ascii?Q?ewR29qGrQXmuSQYUiChZ+lGNkP0pPYQrYhnbxg1rOSHVk6J6yyqMzsq1bFDE?=
 =?us-ascii?Q?frqRIuXpX+PViKe+ZqMiXYqzSA50DLueBJkXZNI9dPr+3VcRiRQErBQeRomO?=
 =?us-ascii?Q?n7h2g6yy1LLR/+DC15RbS8UVM2mtuiUYQer3d7TLPJwhr5g950QrazJ16+Mj?=
 =?us-ascii?Q?laS0aqp8eB5VveX+EZMLIR9iu9AWD8ZHP2ZornixpCETVNwmA0SdO25Bn37V?=
 =?us-ascii?Q?uw1lnVIZ6eUNABMSOxM4v4U7Ln6LhN3QdjLc1fU228T+UVtpcxCPkjReoLAo?=
 =?us-ascii?Q?aLdKPe85+xCYysZ6A8ThRRyLSMwooyk0w0XmROQYAsAvsvfwhZuTP3bEfcKq?=
 =?us-ascii?Q?mE6xrdj51upMSWQ4+R23AxJGoGULekb1ROr309nOZyElxwU7AgKGK+Tbqo7w?=
 =?us-ascii?Q?ZV+91cXUOqBhLJMjBAeCy+JZRsK4D45IIS6SM0QSNGX+YOjOqvUa/HdEeNmr?=
 =?us-ascii?Q?pLqulyw/p7PBinJ666wqEY3ErUTfL377beYUS5cQsmdBS4YsSCTNDAO3GVUv?=
 =?us-ascii?Q?/Tj/xPlruVnMmo2cPzBWx+/veHokZzUwWKrKYrXLE6+2m1XcYC6iw0ic22gb?=
 =?us-ascii?Q?7yLvoJpPauIptZZtcxkgeoICY26tgCUSHTcagTprN3wtU6ZzpbXL2rxgGDZJ?=
 =?us-ascii?Q?tfM5vdcEjVt1UxD9Yvj3vXiieaPYUwfzKeneCypYphKeMwEwJo1NpSIoZndH?=
 =?us-ascii?Q?U3M1HVndYVpZ5dJ5IjyZ+HZoDQAA0WRTnB+z/dlmd/NpAlCD1hZ+GJp5A+h0?=
 =?us-ascii?Q?wv1JwCiTTqwJqQurHGKl6xfUOU1f8QCYx1m0fsWxhm6HmI8aXJ9Kf+kaG0GQ?=
 =?us-ascii?Q?UtgknAfqUbL3dH/rSUrkeVCy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d3df2c9-1e40-4a0f-5a48-08d8efee8ad6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:48.5435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IfPqUeEH0rU2kZ40jstJrcvdNvbWuY2IVKiIzVnUBdrLzFnwCfrfywciw0u7SjWrE5FKZEc+m/63inD537cFIQDIpjw/ZB6OM2x5T9UK358=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3924
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-ORIG-GUID: qaJAaFiyFGNJNzmFdZLe0tsEPHQ5YMRQ
X-Proofpoint-GUID: qaJAaFiyFGNJNzmFdZLe0tsEPHQ5YMRQ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_attr.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index c01ed22..8f18005 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1215,6 +1215,25 @@ int xfs_attr_node_removename_setup(
 	return 0;
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
@@ -1227,7 +1246,6 @@ xfs_attr_node_removename(
 	struct xfs_da_args	*args)
 {
 	struct xfs_da_state	*state;
-	struct xfs_da_state_blk	*blk;
 	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
@@ -1255,14 +1273,7 @@ xfs_attr_node_removename(
 		if (error)
 			goto out;
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

