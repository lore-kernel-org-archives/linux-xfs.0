Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CBAC433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AAC364EB7
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbhBRSqk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:46:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35586 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbhBRQrC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:02 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUGhE041018
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=JZ0gj0rJsZ+GxKmzl7PpaMqUcQWoH+366YTJeQKNCpY=;
 b=CSjoHxD5SGMsh1Vh/xPEoGLZmNexpbYU97FHyw5OWJop8q+O8aKSRgxRMFUaofdUqSit
 s5iehICbO31bLWxIDZQ0kIXdARmr1rak6+mv1iy2rJW6nuFv0U7Jo0iksjt6C0fwZyNc
 5Q5sfIUZ7ShzB1xwO308iDxNiYm0n0x8vtvwz+DMT0p3uF5+K9kZSXSl+RyCS9RkZxsp
 NJSjMphDXkgYhuPirOsUgPwGH7xDo2nwO10/r7QJ3bYzGUZeg7U17oEhY3Nv2FpycqEw
 4t1bs/iZVWeWgtOt6HkLBzoAn7kElaa1wBQQlmDUnVJwlms+t9Do9wvD3ZkfoWnoOnWU lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36pd9ae3ha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUCa6032333
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:36 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3030.oracle.com with ESMTP id 36prq0q51j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ah2R7yVeVPjgP+4WQanVbecbcQzKHQnV88sPNbbsJOQlkFR/us6a/vzaUVhwrSzss9k+tE3ur8mCfxgvKORSjAP/O94psKIqVDCZuKbDlpybqLu5UgFZa+xUAiKPofeolKrntFQ/1eYok9ko4fOp0VCbv1QkTuizA1Gr4eyzCThInk7h/7Bf58AeShCfy+/4kETXijl3y0dkyW3APtAEuYVSZhnUgY3QRD4/zrKgshjPrLc5RDLLPlemareepkXlemSl6PBdxZ02+sHAyM1Ic+51BWCpMKA/uZoxWlzK2BSGGGwa8iq8fbWxt5QVEL9Qfz8NdQ8vnXSO0Afo4qbuUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZ0gj0rJsZ+GxKmzl7PpaMqUcQWoH+366YTJeQKNCpY=;
 b=AT6IgvWLuQazoiYAZ2J4XNz5lQkHb8Kp+L2pM/BNAy60W46kopFwA13zDkzeJEgwI7DHQMPNWz1SLloMJQQTOE8FnbyMcQGHnqLn1D9/Bpx8o/nROsftIkHijn6a2zHR3oKus03ISWp59A9iW5QLO95YYS9x9XkldRdBKm8k+VvzwwZFgkc31wWq4PSB0nbAX7eIsgJXpE6EjEJ9mdDpHnFQI4aG0a45s+uvwf2FS8guhPJvRva49yZYFEDTy9k9hCe+yOlXfr/T3ZDcEmN5hljpxfaJrssw8j9XBshlK1gmsS8FfhL8PVevEKJUdLDyywH1ngqnnMVSKVjhSHjKmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZ0gj0rJsZ+GxKmzl7PpaMqUcQWoH+366YTJeQKNCpY=;
 b=Nlt7kQSry616Xwb709MvXxbCpbTEHZRcCTJUNZhkBtqMPx135haXVpyvXyGml6dhEB5/ZB8MBnxeHlXg/T+0TnIwCF3ghi0fmgfc9/rZ8M1GnJiHkt0RbHVnfyhG8QrguLi3kKEhPGMdMej6Dku4JuhFvw5Dq2xK4qLi94glawY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4290.namprd10.prod.outlook.com (2603:10b6:a03:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Thu, 18 Feb
 2021 16:45:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:34 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 08/37] xfsprogs: Check for extent overflow when adding/removing xattrs
Date:   Thu, 18 Feb 2021 09:44:43 -0700
Message-Id: <20210218164512.4659-9-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87783017-fe46-4e96-d255-08d8d42c9c9b
X-MS-TrafficTypeDiagnostic: BY5PR10MB4290:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4290F473C45A326E2AAB756195859@BY5PR10MB4290.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:549;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J4dbKOgUoSAiiol8ObOxREVn9bSg4eXVjCa81n4/2Do3u3C4JuwxlCNHd4Vw1akqkMBcZUPMrklrEEINpQH7UhimC00EpUl4ngZEFNCwSHU7eMyBr8rp5sGWcwvMtWj4P/eAqmopjhntY5nJmAhWhO4gIU9obSpAGkiiuNKlWwcZ9PSuazBuXC7qyOxor2lvyh25oEh9mo9g3OLUvoTuqMXO6vCvPgcp3qqNcVjaLtAJB6LvQRydL6FUyaks2UGbtfFQpFkR+6QwXbNHHTFSX48Olq+Mzhy8YUQIM3Q1q1KW9IiQvxp1lbD9GlOfQ6q3tZBnLv/Sx4nB1+UhxBEEmhtVG4kg3nQYQtS2IaFWGhaHs3YxL03yA+nIZV71EbTjeAlhuE9QdlqNmkQszr7+vm3i2QKjTSQ8loCNo280fGyZDWNQXSHyl15zXUiPFpyaaB+1URkl8Cazu0Gu+Kh5ElwT1xGUmcjNnFifGTUDmWst684co6iK1rS4I4K0o9ePScf/tpVW7OKHluwOvbf/m0iaduPjUlKD4IXcS78F0fnzDz+MEMFI2cNyhJxZ9qCfhjy+ySMYbfOHSWznXpmnfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(39860400002)(366004)(6512007)(52116002)(6916009)(1076003)(2906002)(316002)(26005)(6666004)(86362001)(8936002)(478600001)(8676002)(44832011)(6506007)(36756003)(66946007)(66476007)(186003)(66556008)(69590400012)(2616005)(5660300002)(83380400001)(956004)(16526019)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IjQrNe19o3gDyh0SJpyIKYyuJw60IhXLF4ZBa28DnGcRtm4gJRApF8mfUo0t?=
 =?us-ascii?Q?m2dCE1NEyLQuwc9t05gssAJgy0Zwzh22C4Twj/GevvkAhbVcDA2ohr13n0oF?=
 =?us-ascii?Q?Kk3XLLiZO+1JClEtMyeTw1DRZtq9hXkeGzia7mA0sZ3WmfeG3iZUpz/z3nbi?=
 =?us-ascii?Q?DdQ+3zmVc2iLm8K4WEbDY7a0E04z7szxfHqfWvoDD1vGI8s/WpdBj1DPUzkm?=
 =?us-ascii?Q?Dd+Xrn7SunDoroDn4Vh7SAgc7pLYwSezFw1QLrYtnKMnRMbwpD/Wxmd1pADj?=
 =?us-ascii?Q?4tiHUoQ3jzwau+NRo0i5fmCXD51tw20zvKea9/XVzsLn6q/IEWxeYrbSHg1I?=
 =?us-ascii?Q?M6R2bkclXSjrjYukRIvcQIIdtvf/i8Q940tQ5t6ZXmH4L1cKW9ACdGOsEEZO?=
 =?us-ascii?Q?dFL+lqH0OQ0ApuI9p+W5TxYvF7wo0O2TspRIfq9cuSa1uTepuCSGdxa0XFm7?=
 =?us-ascii?Q?r5FyDp7vO3Gnddwh1UZwv/vFW3nZ0BfUHD2hmSd4G2ZLe5crNgQF+4idRXvC?=
 =?us-ascii?Q?7gF13oUz5Ikd4FgSvmkPutS1OVbkBoRrKW5KCKpMBQmq20xIJvmwlyioc19b?=
 =?us-ascii?Q?D9U45ZZGNgvsW3nQGj42aR7RBdVG357s07Mv8wzk4xsWeWyQid7WYYd4i3OE?=
 =?us-ascii?Q?jzD2SENdNUBdRl/gqKRa6TQ5mDjOutaEDBXw207XqY4TSIqLw4uIKAR/mKrG?=
 =?us-ascii?Q?wNlS/eANVBGFllhZ+z3J1hLpOXFdyXO8oojSh2AUj1T4aXJsIPo/RmeQ1xuy?=
 =?us-ascii?Q?CpuVzOGpmqqjAg9z9jjdweA+bMrbcLqic0T6wu3TgN9Ay83GAQ3QfojSKHQB?=
 =?us-ascii?Q?8cZhKUNC/nhd+81TSEVWKpgRwT7h+uIItru6h1VQV6tZ7nKsRt412V/aw8Vu?=
 =?us-ascii?Q?XI5MDAhYMR60Aen25Lo0apUArWDAfpKjhbbHWlZnv1KY21D2lrnxh4+dMtdO?=
 =?us-ascii?Q?LE5bNS3A056LgdgMjT2Dy17yF7YD0RhUTTgDXapRxnL4CvKqIkzWcJF6eWLd?=
 =?us-ascii?Q?/behM13IilVNHjlJ55yEbmzsv2Kxp7uYwd1vygS7wgjStowHAjbGPZF/NAnU?=
 =?us-ascii?Q?djyUdJDrIWdmTOS5r7XqhxoEDu3SF5hPw7mcOY9uWArIDmnL+emRrT1HDi+P?=
 =?us-ascii?Q?gVIMNeHfrUL953sTFlI1Uz8OOOf2P14F2tmgxgeSWyRQ8RLqO9F3+iotwY3w?=
 =?us-ascii?Q?asCmf3WOaQ+DXYqtJiiUwt5SmUT8NMc7yRTkycnH28kLLVgJOwBMvpK4GVAN?=
 =?us-ascii?Q?x56YjJae3R3ZfmSTSdT8ig5Xb86A/XvxMQyK+tJIMuZkvl6g+jcQ0XCuZnyE?=
 =?us-ascii?Q?oxpzPw9J3NnaYVCSCYTsx6yb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87783017-fe46-4e96-d255-08d8d42c9c9b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:34.5495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rN0z4GvjKPk8VUs8qO5rIGp3SAsROPpPvMlbdLVXSlwoLxC3wmvulGhCFJLrNcb1bYAexfn0s+cbY25Zip1I93j8B5OVjRwL5ETYlCVytpQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4290
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: 3a19bb147c72d2e9b77137bf5130b9cfb50a5eef

Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to be
added. One extra extent for dabtree in case a local attr is large enough
to cause a double split.  It can also cause extent count to increase
proportional to the size of a remote xattr's value.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c       | 13 +++++++++++++
 libxfs/xfs_inode_fork.h | 10 ++++++++++
 2 files changed, 23 insertions(+)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 0c75f46..237f36b 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -396,6 +396,7 @@ xfs_attr_set(
 	struct xfs_trans_res	tres;
 	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
 	int			error, local;
+	int			rmt_blks = 0;
 	unsigned int		total;
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
@@ -442,11 +443,15 @@ xfs_attr_set(
 		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
 		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 		total = args->total;
+
+		if (!local)
+			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
 	} else {
 		XFS_STATS_INC(mp, xs_attr_remove);
 
 		tres = M_RES(mp)->tr_attrrm;
 		total = XFS_ATTRRM_SPACE_RES(mp);
+		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
 	/*
@@ -460,6 +465,14 @@ xfs_attr_set(
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(args->trans, dp, 0);
+
+	if (args->value || xfs_inode_hasattr(dp)) {
+		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
+				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	if (args->value) {
 		unsigned int	quota_flags = XFS_QMOPT_RES_REGBLKS;
 
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index ea1a9dd..8d89838 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -61,6 +61,16 @@ struct xfs_ifork {
 	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
 
 /*
+ * Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to
+ * be added. One extra extent for dabtree in case a local attr is
+ * large enough to cause a double split.  It can also cause extent
+ * count to increase proportional to the size of a remote xattr's
+ * value.
+ */
+#define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
+	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
+
+/*
  * Fork handling.
  */
 
-- 
2.7.4

