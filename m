Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA37C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3A6D61606
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhBRSqv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:46:51 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60516 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbhBRQr2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:28 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGURpI059508
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=B8DJloQGpsk0JcsBjqIv1cL5a8Le1oyBPVp5eRsxtLw=;
 b=hEgBUDkIjbZTjrsJ2LvNehABDDYBSYrnAf8fQ1mcFuz2A0T+UR3xBJ4EIMzX3OVmCNcy
 yV4gHJPtAaGz8Brf9g+Ek3svqPS4C7nB2p7Q732NyM2ZAbIP6m3ZY3sODuxV4Qa4ixoA
 8NH5wF21b6DCfOGeAam5LJXqMv3gkb9WEKru0OmyAA1KJF6dpReLzflHzMISr4dOqqxJ
 9fQeofJ8Qp0X6Ux+Kcf9+62wOUZEMPZQFEN3vlJZDlKTNDS1sN3mszDmILcZRDBf2i37
 zGtMJC1XL03R6HundOSXYScJaG+7jVrK5mCMn9r02oZKJkWG0XxxL0ZygSDK+M7CT2M3 Vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36p49bert4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUBLp032269
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:46 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by userp3030.oracle.com with ESMTP id 36prq0q55k-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nb1wz0I4h4bbTuEEf3MXZJrBXBF+8145afOR/sMAd7kiewkGutSNbUSv71Jt928mh9HU6X3+5aWUFkWXqy9TohNJR5KaY6gIzlFsHai8dVC5ivv6XZdRcoO4rbk/qzVsKsJWmT1M6bGFEuj0vkSmo/5KoWQVVxtLTAXunwi6L6syKM5FXfMfQH/uSiZUHnPqVcud2hq5CFcxNISP3MwzVmWx5peiCx+udzsLF2jRFtLzwd34FPnzvXiU2yEDlRemK50t6c38rgca5tweAPTTwtLUyQV1kTqTVe2R3UlI7dsiqaiUoCRiHAx2kyAMDO/LPq3zKNvsji/Tdu87lj8vEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B8DJloQGpsk0JcsBjqIv1cL5a8Le1oyBPVp5eRsxtLw=;
 b=YUMecANDcDc7KOLkELmI1ndnvPuGl98NXtXIHtPemdGmF75F32c4HjSIj8GbSX7E6afnHsuvbjrvkkg1beiMd9ea8QUbC5Cfure6SuyusNSb0MYzWUtXvgOy9U7ZLo2YftBg9jhJSFeY5yapni+wu8eVEOUl95apWOVwstQXJubYAStr1h47E/3ftwRlHgkmzDdmy1kghL5Q7d3C176rHL4sEy8Yy7pgM/bNJ8GpgBgMkaPsTvrRoLFUSDRZ18KUb7LD4XDxXD5rEHAt61W0cV8NiV+7iNMo/NCNlNw04bZh4Jay4Fs7z2+DRBMdbZAMkNFepBgRmnie0Myvymgmqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B8DJloQGpsk0JcsBjqIv1cL5a8Le1oyBPVp5eRsxtLw=;
 b=qwygpI0c1LXEak/vt805Tr+ZEIh2FqrTLzLaT5bOySkISPSIO5eRn02N6V7bWsgp/KA6+7CoEDeKabWaVS4iqg6LgyNnFtW6DRCOr+YPCvlnRqsHjRI4cS/cdyLh1Oep45xDTM/bJEFV6AgFooOcok3jJKGsDNPH0/JaaKAyd+M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2965.namprd10.prod.outlook.com (2603:10b6:a03:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 16:45:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:44 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 28/37] xfsprogs: Add delay ready attr remove routines
Date:   Thu, 18 Feb 2021 09:45:03 -0700
Message-Id: <20210218164512.4659-29-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ce69c1c-f075-47d5-67d4-08d8d42ca249
X-MS-TrafficTypeDiagnostic: BYAPR10MB2965:
X-Microsoft-Antispam-PRVS: <BYAPR10MB29652E27AE9145C9A514F5C295859@BYAPR10MB2965.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H48Ka+uVgxNxGX71WScSaZmWVYTsKuy21ddZXmI3lOmlCg+WtZlbFFLxPaQ11H42/kankV/BDaGQF3bhdsox3Fp3TWYLn9a4tolxz6CvdIfQfR07UbBbRZy/5Xeei5Bxh1rG39IxVjVOv1WddTVDi1IvuKmMqI4d8BlAo2mKKOqZPonjy7YIp52dSWUVQ8JPNJq1shhn2jUhUAX1M81dQgt2d1Jv4tXu9FwYNfXNUZKpBjrJCwxaG+N3/PkHjHWLjxa64qRZNLxAb0R4S9TwqV5qHsLU6UR0QwnQA3PNvr+/gCnCrntb0zYbTWe9CaI4bAWRrbq60pRpPHIASVyw/X/rB8cbBUNPMB0gjRH3vF5C0REiuoDiVOElZMKowf/0/XI097szA1Ccz6PoV8hc6SQP9e6ni7MU7nq3hgE3Yv9v0qikkbrNi8vHtiW4cEQFXeQZl2Ejv+Tbo1JZJY33cjXuJKCnDVKS6rfY6rusBjAGsqREbU7FId88dwdtW7GZSuzOwgHUz/ZTNapNhN675g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(6512007)(86362001)(36756003)(83380400001)(6916009)(66556008)(8936002)(66476007)(66946007)(478600001)(52116002)(6666004)(6506007)(316002)(44832011)(16526019)(6486002)(1076003)(5660300002)(26005)(2906002)(186003)(2616005)(956004)(30864003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?H79d+8Url9IUE1Uj8isLvqA0L/KUXjc16deF3M4KFQDeRaLxaIo7XTdUGz0K?=
 =?us-ascii?Q?J+W3YGqHiEfJtKXc08VIVkdyJCjMSEtglxyoCfniLhYltfThE5nuBOltp3oI?=
 =?us-ascii?Q?Ma2/PyQa7nV3pCsPu10OqBy9EUY/N1jRGhxPGlytYIn+Fp93TOeVhocTIS8I?=
 =?us-ascii?Q?pSzijWW+amVqUmpDsAXgVWC77c0c7BTTKjtAAZfxQ17chXCGaI9ywqiAswRh?=
 =?us-ascii?Q?T3U+xMkMV+naKCYmVy0ZQ4+fIUca2+21lNl5cEJl08Dg3Ty2S0DznXsw0rHK?=
 =?us-ascii?Q?cb0ZHKupyBO3pOng12fggxWI2wTB6V8JO8lKWgDK54ULEBe9DDeFCvSyqOr3?=
 =?us-ascii?Q?S18oMzpJBv0TCA+9N+aNdJQlyQBQMe5G6RVIDOipnzdeAeg8SPuAtzt4wj/e?=
 =?us-ascii?Q?ZMTNvd0OOvA8L8meppl4IZAk/tMP+XwtUSMiXAnyPgllz61XBItJvX0+ycL2?=
 =?us-ascii?Q?ktT2iBqxpyhiGHZkNx9irw4FVWlu8z168Bq+wJ2sezEb3hARSYLrjczT7gKR?=
 =?us-ascii?Q?wqzov8Q8J6ee23cenQ04iXeor4qJkSNm+VXGnV5HOj72Vc3HZCP0HDxkBJCM?=
 =?us-ascii?Q?Cw38gigD3iKE0FyiyG/WJN39qTM+LOdSoNT8BaLBju5NyFvfcVd2IUY3GLZn?=
 =?us-ascii?Q?jCO93DFpCidk/KfAKY3mtmF1xNcDQZ3SjUV/0Da46dcUAIMNCAvxQEIpjc7z?=
 =?us-ascii?Q?YYhYSgGniCJrQwF3XmGRoGVxD6Qaau0YP45C9ysVkXI/dMBCFCUPo2KL6OLc?=
 =?us-ascii?Q?eBp6mt9hDoy9c10VwO6ZOIQi8ga17kHELJHU/Rt/8NblUQgKQfO5FeZJbzSd?=
 =?us-ascii?Q?vOqP2y27I/91iIEqQc7NOybhY7BQ6OcnK/TbpCSHtUz3U+Z73S0bO6f+jbgD?=
 =?us-ascii?Q?5tLNJ6zZYSb5yql3k/GXb1BPziZkCwxwAVcd1llyMhYmxgo28apggV8UL8p4?=
 =?us-ascii?Q?IiqDWPRt0gYdW31UDS2OoY9TlcQA5JLj9qyIh9FZizaaR1KaMIFL4VUImxTM?=
 =?us-ascii?Q?RT1fBhqQvS+ozlU3WyeMlhNHqzBtveunWQNB5T859EUCcNc5I16waho66IVI?=
 =?us-ascii?Q?0tM10L6992A+xdM96HKz5zBZdhQYthOjosHMQ0PBemQgldOCPmc9nErN8vfS?=
 =?us-ascii?Q?q/NwZD87mE5EbfYpSDeVdLCKYbJlR9DlcNxuAhkbRFc9mpADAG61Ujks9AQt?=
 =?us-ascii?Q?kXkuush9Hqb5D8neY742Pv/bjQTzRuoE9SSfoC7iofvxx2vVn3fLWDcVH8f+?=
 =?us-ascii?Q?A2bIw50aDjAIS7Xs047fr/V77YZjyracxJ+KDb7VSOzwt9BGrxmzr6KRKoq5?=
 =?us-ascii?Q?urQhREiUIZDpTim72Nn2Dy9M?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ce69c1c-f075-47d5-67d4-08d8d42ca249
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:44.1464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gGbD4wB9sy/1vkT1RCl6nfTMlwXX4zbynfcW02qy9MYkywb6swrP/0le2h0ae19ofxf+vBhQ0cLSLgSOB3QeVQMcGmTDQRaYaB17oSEveNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2965
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch modifies the attr remove routines to be delay ready. This
means they no longer roll or commit transactions, but instead return
-EAGAIN to have the calling routine roll and refresh the transaction. In
this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
uses a sort of state machine like switch to keep track of where it was
when EAGAIN was returned. xfs_attr_node_removename has also been
modified to use the switch, and a new version of xfs_attr_remove_args
consists of a simple loop to refresh the transaction until the operation
is completed. A new XFS_DAC_DEFER_FINISH flag is used to finish the
transaction where ever the existing code used to.

Calls to xfs_attr_rmtval_remove are replaced with the delay ready
version __xfs_attr_rmtval_remove. We will rename
__xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
done.

xfs_attr_rmtval_remove itself is still in use by the set routines (used
during a rename).  For reasons of preserving existing function, we
modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
set.  Similar to how xfs_attr_remove_args does here.  Once we transition
the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
used and will be removed.

This patch also adds a new struct xfs_delattr_context, which we will use
to keep track of the current state of an attribute operation. The new
xfs_delattr_state enum is used to track various operations that are in
progress so that we know not to repeat them, and resume where we left
off before EAGAIN was returned to cycle out the transaction. Other
members take the place of local variables that need to retain their
values across multiple function recalls.  See xfs_attr.h for a more
detailed diagram of the states.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 include/libxfs.h         |   1 +
 libxfs/xfs_attr.c        | 223 ++++++++++++++++++++++++++++++++++-------------
 libxfs/xfs_attr.h        | 100 +++++++++++++++++++++
 libxfs/xfs_attr_leaf.c   |   2 +-
 libxfs/xfs_attr_remote.c |  48 +++++-----
 libxfs/xfs_attr_remote.h |   2 +-
 6 files changed, 294 insertions(+), 82 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index bc07655..02d97c1 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -168,6 +168,7 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #include "xfs_ialloc.h"
 
 #include "xfs_attr_leaf.h"
+#include "xfs_attr.h"
 #include "xfs_attr_remote.h"
 #include "xfs_trans_space.h"
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 82dc851..27c0939 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -57,8 +57,8 @@ STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
 				 struct xfs_da_state *state);
 STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
 				 struct xfs_da_state **state);
-STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname_work(struct xfs_da_args *args);
+STATIC int xfs_attr_node_removename_iter(struct xfs_delattr_context *dac);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -221,6 +221,34 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
+/*
+ * Checks to see if a delayed attribute transaction should be rolled.  If so,
+ * also checks for a defer finish.  Transaction is finished and rolled as
+ * needed, and returns true of false if the delayed operation should continue.
+ */
+int
+xfs_attr_trans_roll(
+	struct xfs_delattr_context	*dac)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	int				error;
+
+	if (dac->flags & XFS_DAC_DEFER_FINISH) {
+		/*
+		 * The caller wants us to finish all the deferred ops so that we
+		 * avoid pinning the log tail with a large number of deferred
+		 * ops.
+		 */
+		dac->flags &= ~XFS_DAC_DEFER_FINISH;
+		error = xfs_defer_finish(&args->trans);
+		if (error)
+			return error;
+	} else
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+
+	return error;
+}
+
 STATIC int
 xfs_attr_set_fmt(
 	struct xfs_da_args	*args)
@@ -531,23 +559,58 @@ xfs_has_attr(
  */
 int
 xfs_attr_remove_args(
-	struct xfs_da_args      *args)
+	struct xfs_da_args	*args)
 {
-	struct xfs_inode	*dp = args->dp;
-	int			error;
+	int				error;
+	struct xfs_delattr_context	dac = {
+		.da_args	= args,
+	};
+
+	do {
+		error = xfs_attr_remove_iter(&dac);
+		if (error != -EAGAIN)
+			break;
+
+		error = xfs_attr_trans_roll(&dac);
+		if (error)
+			return error;
+
+	} while (true);
+
+	return error;
+}
+
+/*
+ * Remove the attribute specified in @args.
+ *
+ * This function may return -EAGAIN to signal that the transaction needs to be
+ * rolled.  Callers should continue calling this function until they receive a
+ * return value other than -EAGAIN.
+ */
+int
+xfs_attr_remove_iter(
+	struct xfs_delattr_context	*dac)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_inode		*dp = args->dp;
 
-	if (!xfs_inode_hasattr(dp)) {
-		error = -ENOATTR;
-	} else if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
+	/* If we are shrinking a node, resume shrink */
+	if (dac->dela_state == XFS_DAS_RM_SHRINK)
+		goto node;
+
+	if (!xfs_inode_hasattr(dp))
+		return -ENOATTR;
+
+	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
 		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
-		error = xfs_attr_shortform_remove(args);
-	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-		error = xfs_attr_leaf_removename(args);
-	} else {
-		error = xfs_attr_node_removename(args);
+		return xfs_attr_shortform_remove(args);
 	}
 
-	return error;
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+		return xfs_attr_leaf_removename(args);
+node:
+	/* If we are not short form or leaf, then proceed to remove node */
+	return  xfs_attr_node_removename_iter(dac);
 }
 
 /*
@@ -1204,14 +1267,16 @@ xfs_attr_leaf_mark_incomplete(
  */
 STATIC
 int xfs_attr_node_removename_setup(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	**state)
+	struct xfs_delattr_context	*dac)
 {
-	int			error;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		**state = &dac->da_state;
+	int				error;
 
 	error = xfs_attr_node_hasname(args, state);
 	if (error != -EEXIST)
 		return error;
+	error = 0;
 
 	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
 	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
@@ -1220,22 +1285,28 @@ int xfs_attr_node_removename_setup(
 	if (args->rmtblkno > 0) {
 		error = xfs_attr_leaf_mark_incomplete(args, *state);
 		if (error)
-			return error;
+			goto out;
 
-		return xfs_attr_rmtval_invalidate(args);
+		error = xfs_attr_rmtval_invalidate(args);
 	}
+out:
+	if (error)
+		xfs_da_state_free(*state);
 
 	return 0;
 }
 
 STATIC int
-xfs_attr_node_remove_rmt(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	*state)
+xfs_attr_node_remove_rmt (
+	struct xfs_delattr_context	*dac,
+	struct xfs_da_state		*state)
 {
-	int			error = 0;
+	int				error = 0;
 
-	error = xfs_attr_rmtval_remove(args);
+	/*
+	 * May return -EAGAIN to request that the caller recall this function
+	 */
+	error = __xfs_attr_rmtval_remove(dac);
 	if (error)
 		return error;
 
@@ -1266,18 +1337,24 @@ xfs_attr_node_remove_cleanup(
 }
 
 /*
- * Remove a name from a B-tree attribute list.
+ * Step through removeing a name from a B-tree attribute list.
  *
  * This will involve walking down the Btree, and may involve joining
  * leaf nodes and even joining intermediate nodes up to and including
  * the root node (a special case of an intermediate node).
+ *
+ * This routine is meant to function as either an inline or delayed operation,
+ * and may return -EAGAIN when the transaction needs to be rolled.  Calling
+ * functions will need to handle this, and recall the function until a
+ * successful error code is returned.
  */
 STATIC int
 xfs_attr_node_remove_step(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	*state)
+	struct xfs_delattr_context	*dac)
 {
-	int			error = 0;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		*state = dac->da_state;
+	int				error = 0;
 
 	/*
 	 * If there is an out-of-line value, de-allocate the blocks.
@@ -1285,7 +1362,10 @@ xfs_attr_node_remove_step(
 	 * overflow the maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_node_remove_rmt(args, state);
+		/*
+		 * May return -EAGAIN. Remove blocks until args->rmtblkno == 0
+		 */
+		error = xfs_attr_node_remove_rmt(dac, state);
 		if (error)
 			return error;
 	}
@@ -1298,51 +1378,74 @@ xfs_attr_node_remove_step(
  *
  * This routine will find the blocks of the name to remove, remove them and
  * shrink the tree if needed.
+ *
+ * This routine is meant to function as either an inline or delayed operation,
+ * and may return -EAGAIN when the transaction needs to be rolled.  Calling
+ * functions will need to handle this, and recall the function until a
+ * successful error code is returned.
  */
 STATIC int
-xfs_attr_node_removename(
-	struct xfs_da_args	*args)
+xfs_attr_node_removename_iter(
+	struct xfs_delattr_context	*dac)
 {
-	struct xfs_da_state	*state = NULL;
-	int			retval, error;
-	struct xfs_inode	*dp = args->dp;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		*state = NULL;
+	int				retval, error;
+	struct xfs_inode		*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
 
-	error = xfs_attr_node_removename_setup(args, &state);
-	if (error)
-		goto out;
-
-	error = xfs_attr_node_remove_step(args, state);
-	if (error)
-		goto out;
-
-	retval = xfs_attr_node_remove_cleanup(args, state);
-
-	/*
-	 * Check to see if the tree needs to be collapsed.
-	 */
-	if (retval && (state->path.active > 1)) {
-		error = xfs_da3_join(state);
-		if (error)
-			goto out;
-		error = xfs_defer_finish(&args->trans);
+	if (!dac->da_state) {
+		error = xfs_attr_node_removename_setup(dac);
 		if (error)
 			goto out;
+	}
+	state = dac->da_state;
+
+	switch (dac->dela_state) {
+	case XFS_DAS_UNINIT:
 		/*
-		 * Commit the Btree join operation and start a new trans.
+		 * repeatedly remove remote blocks, remove the entry and join.
+		 * returns -EAGAIN or 0 for completion of the step.
 		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
+		error = xfs_attr_node_remove_step(dac);
 		if (error)
-			goto out;
-	}
+			break;
 
-	/*
-	 * If the result is small enough, push it all into the inode.
-	 */
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
-		error = xfs_attr_node_shrink(args, state);
+		retval = xfs_attr_node_remove_cleanup(args, state);
 
+		/*
+		 * Check to see if the tree needs to be collapsed. Set the flag
+		 * to indicate that the calling function needs to move the
+		 * shrink operation
+		 */
+		if (retval && (state->path.active > 1)) {
+			error = xfs_da3_join(state);
+			if (error)
+				goto out;
+
+			dac->flags |= XFS_DAC_DEFER_FINISH;
+			dac->dela_state = XFS_DAS_RM_SHRINK;
+			return -EAGAIN;
+		}
+
+		/* fallthrough */
+	case XFS_DAS_RM_SHRINK:
+		/*
+		 * If the result is small enough, push it all into the inode.
+		 */
+		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+			error = xfs_attr_node_shrink(args, state);
+
+		break;
+	default:
+		ASSERT(0);
+		error = -EINVAL;
+		goto out;
+	}
+
+	if (error == -EAGAIN)
+		return error;
 out:
 	if (state)
 		xfs_da_state_free(state);
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 3e97a93..3154ef4 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -74,6 +74,102 @@ struct xfs_attr_list_context {
 };
 
 
+/*
+ * ========================================================================
+ * Structure used to pass context around among the delayed routines.
+ * ========================================================================
+ */
+
+/*
+ * Below is a state machine diagram for attr remove operations. The  XFS_DAS_*
+ * states indicate places where the function would return -EAGAIN, and then
+ * immediately resume from after being recalled by the calling function. States
+ * marked as a "subroutine state" indicate that they belong to a subroutine, and
+ * so the calling function needs to pass them back to that subroutine to allow
+ * it to finish where it left off. But they otherwise do not have a role in the
+ * calling function other than just passing through.
+ *
+ * xfs_attr_remove_iter()
+ *              │
+ *              v
+ *        found attr blks? ───n──┐
+ *              │                v
+ *              │         find and invalidate
+ *              y         the blocks. mark
+ *              │         attr incomplete
+ *              ├────────────────┘
+ *              │
+ *              v
+ *      remove a block with
+ *    xfs_attr_node_remove_step <────┐
+ *              │                    │
+ *              v                    │
+ *      still have blks ──y──> return -EAGAIN.
+ *        to remove?          re-enter with one
+ *              │            less blk to remove
+ *              n
+ *              │
+ *              v
+ *       remove leaf and
+ *       update hash with
+ *   xfs_attr_node_remove_cleanup
+ *              │
+ *              v
+ *           need to
+ *        shrink tree? ─n─┐
+ *              │         │
+ *              y         │
+ *              │         │
+ *              v         │
+ *          join leaf     │
+ *              │         │
+ *              v         │
+ *      XFS_DAS_RM_SHRINK │
+ *              │         │
+ *              v         │
+ *       do the shrink    │
+ *              │         │
+ *              v         │
+ *          free state <──┘
+ *              │
+ *              v
+ *            done
+ *
+ */
+
+/*
+ * Enum values for xfs_delattr_context.da_state
+ *
+ * These values are used by delayed attribute operations to keep track  of where
+ * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
+ * calling function to roll the transaction, and then recall the subroutine to
+ * finish the operation.  The enum is then used by the subroutine to jump back
+ * to where it was and resume executing where it left off.
+ */
+enum xfs_delattr_state {
+	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
+	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
+};
+
+/*
+ * Defines for xfs_delattr_context.flags
+ */
+#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
+
+/*
+ * Context used for keeping track of delayed attribute operations
+ */
+struct xfs_delattr_context {
+	struct xfs_da_args      *da_args;
+
+	/* Used in xfs_attr_node_removename to roll through removing blocks */
+	struct xfs_da_state     *da_state;
+
+	/* Used to keep track of current state of delayed operation */
+	unsigned int            flags;
+	enum xfs_delattr_state  dela_state;
+};
+
 /*========================================================================
  * Function prototypes for the kernel.
  *========================================================================*/
@@ -91,6 +187,10 @@ int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
+int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
+void xfs_delattr_context_init(struct xfs_delattr_context *dac,
+			      struct xfs_da_args *args);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index a59660f..2c7aa6b 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -19,8 +19,8 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_attr_sf.h"
-#include "xfs_attr_remote.h"
 #include "xfs_attr.h"
+#include "xfs_attr_remote.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_trace.h"
 #include "xfs_dir2.h"
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 3807cd3..dd4f244 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -673,10 +673,12 @@ xfs_attr_rmtval_invalidate(
  */
 int
 xfs_attr_rmtval_remove(
-	struct xfs_da_args      *args)
+	struct xfs_da_args		*args)
 {
-	int			error;
-	int			retval;
+	int				error;
+	struct xfs_delattr_context	dac  = {
+		.da_args	= args,
+	};
 
 	trace_xfs_attr_rmtval_remove(args);
 
@@ -684,31 +686,29 @@ xfs_attr_rmtval_remove(
 	 * Keep de-allocating extents until the remote-value region is gone.
 	 */
 	do {
-		retval = __xfs_attr_rmtval_remove(args);
-		if (retval && retval != -EAGAIN)
-			return retval;
+		error = __xfs_attr_rmtval_remove(&dac);
+		if (error != -EAGAIN)
+			break;
 
-		/*
-		 * Close out trans and start the next one in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		error = xfs_attr_trans_roll(&dac);
 		if (error)
 			return error;
-	} while (retval == -EAGAIN);
+	} while (true);
 
-	return 0;
+	return error;
 }
 
 /*
  * Remove the value associated with an attribute by deleting the out-of-line
- * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
+ * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
  * transaction and re-call the function
  */
 int
 __xfs_attr_rmtval_remove(
-	struct xfs_da_args	*args)
+	struct xfs_delattr_context	*dac)
 {
-	int			error, done;
+	struct xfs_da_args		*args = dac->da_args;
+	int				error, done;
 
 	/*
 	 * Unmap value blocks for this attr.
@@ -718,12 +718,20 @@ __xfs_attr_rmtval_remove(
 	if (error)
 		return error;
 
-	error = xfs_defer_finish(&args->trans);
-	if (error)
-		return error;
-
-	if (!done)
+	/*
+	 * We dont need an explicit state here to pick up where we left off.  We
+	 * can figure it out using the !done return code.  Calling function only
+	 * needs to keep recalling this routine until we indicate to stop by
+	 * returning anything other than -EAGAIN. The actual value of
+	 * attr->xattri_dela_state may be some value reminicent of the calling
+	 * function, but it's value is irrelevant with in the context of this
+	 * function.  Once we are done here, the next state is set as needed
+	 * by the parent
+	 */
+	if (!done) {
+		dac->flags |= XFS_DAC_DEFER_FINISH;
 		return -EAGAIN;
+	}
 
 	return error;
 }
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 9eee615..002fd30 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
+int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4

