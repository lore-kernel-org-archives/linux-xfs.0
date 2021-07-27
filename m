Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B811C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A7D46112D
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235579AbhG0GTs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:19:48 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23046 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235041AbhG0GTq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:46 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6HCDd010859
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=0z7D+hJkG3VQYeCB6JFZbrJtESfer7OF1K0RdKWEpPA=;
 b=Q/S67478ONtopNDzrJ3vClWrFblWocywQ8KjZbvzz739wtHEO9CgGY46Ab/GgInHscEN
 qugPbjJcG850a199r0s150rfo7ilOlHGtVFAoUqpSk7OjATyhWGM1k99njv8/9590N4q
 cjZ/lT/d62XfELxGBGz28spqqc6IY3zEpXHjxRz8CDe1qS6KjldO+MWJUWYzaLLg4go7
 VTyONqdkRgIN/kbLBqDw4fWPqfCNi30LLJkMrA6n5ddOHBApHDqT259rlKEj+gAMqqF1
 dV4PFvlx0nmwlb/W0JUtMBgEHgcuJg5ZR8H8DeodAZdXAfKI40azCtmclR3Oaos9cmm0 rw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=0z7D+hJkG3VQYeCB6JFZbrJtESfer7OF1K0RdKWEpPA=;
 b=JHoKbVSDCnZMvQssT5PovDhKFaOqkslHEvNOYBiG3kDRSyJTn41UjOty9rbiuJ4gFt4N
 M6TE22tXvePFuD8PJ+cPeO+E1b7b0fv7F0AUnMGk8GCAbMYncV9jwrbaaVkZHjYjP0Ol
 ozRw3XYQKj/orVvfg8BH/6wF1TfT3J2jKgpr0o+zvGXbvdZNhNEeLLAcAnR15HPWWeOt
 GXfKEX/02C54IPg2Fj5sRtfPVTyAlTBnJ2FL3sy0Bz41mTe8nSxk0JjPxElRziKJq+Fa
 YEjvPVuSGLqDeKxJehj2I1nowvrvmksBeld0smNT69gRtttoHDm/gRXeo9/37SgRTFlQ KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234w0v6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6Eia5065026
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 3a234uvnq3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3L11BFrxA9I43k8f/XrZg0B2fRglbewizbgo2QO1C3YMw4hu97P6aaKt9JrgBqs3/Q1745N26LnBbwxdSp3yYep9ZGfKGAI25kcOJy0DbRZnE2WVPSZ08FW+cselDKBcrPXSyY7p/crsaWhMv7GnFY2T8gl95KXN6VZYhgR6tvMwVbKOkHwyYxAClKXL0iEr9sSMYOOeV56u1Y4E57G/PTX7cGqF1OjUj2KW0FENiqHrDPdHWB2XS3k9jMoheUZB0v4VVcXuvDv9dSB98pTZ5pG/0VLD/M2wksVj/RvtN67nIF0tGhYhaAr6p78WMRtOqc6WyDcLynL5uZRU4Ijpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0z7D+hJkG3VQYeCB6JFZbrJtESfer7OF1K0RdKWEpPA=;
 b=EWeS6K4KYwzHQ0Gr72Sq08XjGcEoau+eZn2tmd7DwVUolmrmNJ94UTV4c+EwkSQj1nY5SsocNtTA8sNRszBEk5pnbaUjfM91osIGqNkZ+7MAMfVkO796AACtSaKWoQDuArYaoLYXrdDH4cOZCdhprNQEShQ4+87fvGl27ez4k0jLXIk9wQJcD0X/rwELGlaDujQPeTySo7DMPB4ko4w5C1C3OPWeI2tfWvySWqAM/IDUaODTWHRwMrPPa0bH09C9bNju65qbYZEaKG8iLCRQSoTtGP+UMX79khb27H8rUsv6OOOzU1C3RcP/Dfr0dAGHOybQU6HBQK0q2yVD127ByQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0z7D+hJkG3VQYeCB6JFZbrJtESfer7OF1K0RdKWEpPA=;
 b=y1BpjpxsyURYEhxp70f0lU2wo59vcx4zb3bgrh00AiNwsjPyZHgjKZ5z7yCGeRaRzHtMroXGYMNsSJaJMKtOaSYAgoY+zGfnTn7HcIUUZ01lhm5s++ihYoHMwf319sPmm0cQFpXxbWV6zfjMt8ZdwJhOEwZg+kfNTpY5GXThtDU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3669.namprd10.prod.outlook.com (2603:10b6:a03:119::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Tue, 27 Jul
 2021 06:19:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:40 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 02/27] xfsprogs: Add xfs_attr_node_remove_name
Date:   Mon, 26 Jul 2021 23:18:39 -0700
Message-Id: <20210727061904.11084-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8c5c3e8-e026-4001-b87b-08d950c683f5
X-MS-TrafficTypeDiagnostic: BYAPR10MB3669:
X-Microsoft-Antispam-PRVS: <BYAPR10MB36690CD0E0A249B9B6F242D895E99@BYAPR10MB3669.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v11K6RpIVK0tP1ZBibZA7C9BUUS/Astw9SR6RtnvP1Gg3F1epGX9vFDjJqSni/DftKUpk84PPK0HmqReQabcwySzzDZPCUTGfosmS5b4ioZ8BNsA8GVQTftb+KgqSh5mA8r5AOu76eu1x7/1In7OYigj/SoGj7Ytu+xLrcwnG4ocaZR6oPCOC1RD3Ql0BLcyZLo5H4tDG6UJ2n1zoPgunWPtAYygMgPVtLpYnbQ0A7XBPNT6GvPRZjbtG6k6EzYgL05VOJZ6QHTiLpvA0dNk2epNsaNM9gvABRFJ5urCsi23FIEhyJFMR/psD7f9gyvGfqq74jaZxBZFeZGX9hiufpHI/IuH+LdDrg4kbe6sf5Wdpfvuyq/+7SmfEgwmBjB+ie3uttO9fscD7+GGJVw+q3yEW5QgtErrQJxXPDLG490yidO/PbiWD54l/30tevpjGKBO2fhUxSzDYSdkO7OjDkXBsLOn1ayqwR8yMFDRXJKjNqNJH6592iZRspws7TTalZTvQhiH956PHkHUXAbggGxhoOh09s8zH5gb9sL3/v0LFCn6LYqTz+XWotGVWdx3CONOOFj8laOkYs9QDPa4/hefERpWM0erhoWwwX+budjrGtnPbkoPILKJSeWuAfMSYAy3aJ4p69Wih8GcQOfFwmrY10emVJbOupn1SLRsDtO2sgZvtIv8bN/8yfuFDQt84zY89XhjaL+iYn+61Yl/lQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(44832011)(478600001)(38100700002)(38350700002)(52116002)(2906002)(6486002)(186003)(6512007)(26005)(1076003)(8936002)(8676002)(83380400001)(6506007)(5660300002)(36756003)(6916009)(86362001)(956004)(2616005)(316002)(66556008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hPtRHrSPeHUxdkgVf+KeO6+1TQ7o58kZmoQOGFbN9bu68ud+aaLPwpcXVKmR?=
 =?us-ascii?Q?mcSQwHlS3qUNQJdj79/30H7ptEPQYBtWpKPHVUCc2mI0A3+pWEAFqovdIrim?=
 =?us-ascii?Q?eV1MX6DbhtVDGbrtvwU9VtEAi345RAVs52jI+yULjInq76CPCaGXY/h5qxjm?=
 =?us-ascii?Q?R5hLdHTYZG5mnXPemKzjJyef7diJOelz+8XPA03n0qGzPCO7lnZFeO8Z+aF9?=
 =?us-ascii?Q?zRIdVoKESpsUko+NGlcAMQXDEXMbVMJZzuOOKDB2GoVpROIplUmrF9mfgfUR?=
 =?us-ascii?Q?Zyft5eW7FE8yJvcSYR6Oz8D8h7VM9l1dlvbqRlGrAeAUTZfZnRxhYeLVe7ny?=
 =?us-ascii?Q?voqU8XA9C9fLSqBGd2G1s5ZlehCWOITSaasQQz61wFVTYUs6/HDPgTkbDAyc?=
 =?us-ascii?Q?DG+/3o+cufDxZnPm/fUXBDjVcSRhR/ACE/w55tWZaq27KvCPBQb4AubamTK5?=
 =?us-ascii?Q?RcWke7VoMOIFB/4GhuhAbpqPLlVmspnQKnlq4CJ32Jy8pf7SNwZo0C4lslfe?=
 =?us-ascii?Q?p6rGD/AnYspVjWAhQZF+m0Cn1RF4kK1kSbJVSodcmJbNkH3b37fLYrV8yFzi?=
 =?us-ascii?Q?HITsaU9kMgSM5ZyDg6ypsuTWIuhC9tpJ1a7UKlySI0TImuKvqZvI/pTCTf0p?=
 =?us-ascii?Q?rRJ8KoL73ZcNJAjRZE5+qHugKmdTtVJMPADdrkdPDifhRfuX60HY7ZdCaFrx?=
 =?us-ascii?Q?8Az22s86oL70yUwTJhNnbzFT5xDgBUQht9XXIerAvSXvt3X3Fww30yqI6i6J?=
 =?us-ascii?Q?+JvaGEZ3Zct9vZV0Ldd1NuErQHPSDSPHtIwamuSlUd+UXtXdTvBkwGidaiL9?=
 =?us-ascii?Q?bqoVaaa1S0TCz1sytehzOn4eHBGDx3GJKTdqf3U+K5o8d8uXYUbV6P2uBdPX?=
 =?us-ascii?Q?O2j+hg9CUdXgBh6rHTXiCDyWqe4bnVx80NURLs8zvnb+TfvAM+5dKbyfcXpy?=
 =?us-ascii?Q?kYDzKkTI/0X1phItoRmZGrqiWM9uFUPin2clZBMNFV9GPWbmAa2Qw/H8gJcd?=
 =?us-ascii?Q?/qMqeZkWTygb1+HBgaPxmrTQ55Msc3VCstxcEK6uFYILm7MhfMe607dpwuns?=
 =?us-ascii?Q?UmeNAImkz668qQHZ8C2cjZ5RO5/3oLo46nO91HZEKIei3HkZe8cc2zfOvhzq?=
 =?us-ascii?Q?AgsQVZYxq07Gww6HV85CYLGr3PnMS+onWrqpzigswLCNnvDBx4NiiOEwIQRJ?=
 =?us-ascii?Q?4Q1vuZB7C3/ULJkmI605zhUjNi8iZNNK5ppU8HBcIq1//ip38cNtwCMoyihO?=
 =?us-ascii?Q?bqaiP8aK+TnXpbwVWAuz/IITWSO2WTMOzv5H6g5DL9u8DHI6L+CwDIFmp/Lz?=
 =?us-ascii?Q?fcXoxmkpMt4Av01qQp9M5rhq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8c5c3e8-e026-4001-b87b-08d950c683f5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:39.9083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7a3ZEsEDYOHi6cNdzbkXYFFO3OBcIPKC1guE0wO46LUCbHrEDQfg9HENrQ2Yv+yN8HS+bF/o7ZWH8QWTAQ9ITLN/bMITgAhgzxXeIwJZUPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3669
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-ORIG-GUID: LJZHWTLj9AFuqWpGrCGfFhcxaMi_O4hN
X-Proofpoint-GUID: LJZHWTLj9AFuqWpGrCGfFhcxaMi_O4hN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 4078af18570ef0f89fce18e9ed9c1fa0c827f37b

This patch pulls a new helper function xfs_attr_node_remove_name out
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
index 1c60bdd..5da3ec3 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1214,6 +1214,25 @@ int xfs_attr_node_removename_setup(
 	return 0;
 }
 
+STATIC int
+xfs_attr_node_remove_name(
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
@@ -1226,7 +1245,6 @@ xfs_attr_node_removename(
 	struct xfs_da_args	*args)
 {
 	struct xfs_da_state	*state;
-	struct xfs_da_state_blk	*blk;
 	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
@@ -1254,14 +1272,7 @@ xfs_attr_node_removename(
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
+	retval = xfs_attr_node_remove_name(args, state);
 
 	/*
 	 * Check to see if the tree needs to be collapsed.
-- 
2.7.4

