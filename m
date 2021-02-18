Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F14B6C43332
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA33664ED4
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbhBRSsO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:48:14 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:41312 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234043AbhBRQzV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:55:21 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGoOaR088799
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=0Hg1KhvkFZFjKijbVBZiY8vPLRXFFmSBVMkN0fi69D4=;
 b=MPq6KiP91ftqrVEMhpKZZhHB52CpW5yA/UkNQopte6Lbkb+M0e6vOOLMIKRstU0g+SrY
 nDxPg+eJPNOaF12VVAUdfyt37IeXpnH7BmbWKXxtKlVuSbwWtvXAYTRDxYP4uvgtXwHZ
 Rgofva7W52aWFoxjiLL6qRnRximgBMLE2VPJF+G977YqwqblLZu6cjRvoeADhrVCKfi0
 YTSXHahaQJASTMYS93vHLdAB8JNFF0xQ68YgCYj4e8Jr+rsBYnvtjGVwglvHXwFz5+vL
 cpeWvBoxUFNu04/f2aQ4i7xKnaoRCmMwt8Gcko6xEAkBtHyNL/Qdbjj5X4ISpl3h0Y8D Vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36p49besyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGoALL119728
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:16 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by userp3030.oracle.com with ESMTP id 36prq0qeh7-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UsXI2QBmSzWHMbqz6VC5/EuvmfFI4/nzT4+NXLtuYKsxcyQJhVmw6hnr2yAzCZR/+5TZItnp7gNZdgF6pVlJwhIeGPABvDXgJavMEGEKXIhnl7kSWiHmbCV1FRYEK9m1p+k5XWcghjRme75PlsRayk1C9wO0Pl1Ym6SNnfdVpxwlB9LWtQg7yLU8LV7ZxBtm6NaYrQFkw86Lmyg4wnR51EPF+grh6m+6zgTaypmOlOWFJrO7YDjfD1666GW2mx2Csz8994Ium6+PP/lzW3phFk5oJ8m1gJM0matJSRnjcqSv3/MW3d4r/NSXWIq2ib8UJJKW81FGnQXPzYtu+8jjmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Hg1KhvkFZFjKijbVBZiY8vPLRXFFmSBVMkN0fi69D4=;
 b=gqLPotTZwP+7NEAT9qzJWn2D1QxX2Z8HbOet+BK8mYJAae7QowFscd4jk5XDjZr/fqV/bVp1X7s+rt767YGdz1TJyBgvYPTJTelzDo8WGEDALCMCfTPoedWdPB3F67kCBty9OYg96lRH2fxus/1JNwKxEoCt5nwUJUQpKaCu6A36EA44UBbIJyK5au+2UkUCgu4wFN8z06fS53/gw6eMbAHGBnRFxkj6ztHE5UTJ3RUlPyimCqWE1/aHaTVUg9wrQrQLpxXokM9mCvMJwzeo9/UPo7uhUFFP0PVNY9JkiBcSpIwQlzACG1QkGPQWxSY4Egq7j6yiM2mnkJUHwPVVLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Hg1KhvkFZFjKijbVBZiY8vPLRXFFmSBVMkN0fi69D4=;
 b=u8AgVQcSoDbssX2GiBMdIYNXN7JeqzLcnquk3EEY8Fyv9xHp8jMMyUMy7H6Yv/1Q9fxCUrhY860DpXDJjOrA2I8LZyIWhXqXV0crFpyd8Z/tVv453u5nJoay1GqQyxzgp3NzvymP2rJTkKfB+q35P+2KufyThF3nk7oGVt+qwXI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3605.namprd10.prod.outlook.com (2603:10b6:a03:129::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 16:54:13 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:13 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 20/22] xfs: Add delayed attributes error tag
Date:   Thu, 18 Feb 2021 09:53:46 -0700
Message-Id: <20210218165348.4754-21-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218165348.4754-1-allison.henderson@oracle.com>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30ed99ba-0faf-4125-f603-08d8d42dd169
X-MS-TrafficTypeDiagnostic: BYAPR10MB3605:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3605894B9CF7EF54E4785D0095859@BYAPR10MB3605.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XqJ9cVJ6lMosH9rTOT6ohtSQ0cWW211AZyNHK/BbELWxSjcBO0rZ5QOZJX0T2MCPWBniqCp55bW5AP7edjtlr0GjWq1hv4VyZ15A7KAP+GnQi4sPZ40WOeSzbvP/k6FXhkKxebKyjFPYvcByuIBflcOoMP2RJxTQDsp7A9G8xGOv62bpDP4uikzHapYfXCrp4/6aS5fzC+4+zqnTXMgAifWSyftPZ6KHhsH/VvcvJdaJAWITbrgpG383gMCIuXiMpNdihgOSLkntbJ5CBtZN4w7ftoUov+4UeTzfTWRYlN0A5IVW2Jqiu8UUwNBqtoNvffvEOm3mEGD+SozubyTd+6uG1x6ZowDrXj/oORnhISHmh8ZsEA4J1lB1jwoeAC+cfPehhhEAZET6DmQHUYq/cbJrJR5AIIXgjseMDMmMX/2Lu6rJWtLNcfjyhOPjWki62XEOCFxhXSDgMNTZq6cz4ueOl7QH2I+NPyr9JhmH0R9+l3mXHL7+Fx0aG70+FN8Ytq3Ep6I0T479C9oqgfgg26hcySnZtBEM/J5XAvc50czZxB95ihaAqkzIl+BddJ6FUMD2n5qUQ165sq4tyPMt/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(136003)(376002)(396003)(5660300002)(52116002)(8936002)(6916009)(69590400012)(1076003)(478600001)(956004)(6512007)(26005)(16526019)(6486002)(186003)(2906002)(6506007)(2616005)(36756003)(83380400001)(66946007)(86362001)(44832011)(6666004)(66476007)(66556008)(8676002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2qnQFmjJQ7fE26gp7swad+gTsLs4SOVH8aFsZxcCxaxVbgDRncx2Nl4nLItu?=
 =?us-ascii?Q?Ne1ZPdrKFYcILE8kEYumiVNIQv47o2B9q7etELiu+Km1pFEnTF5vwa55ToPI?=
 =?us-ascii?Q?YZOW0mMJ/WswJSXZQpM8A/QnXIQVBBbHnKTdSn7S+wpjwulu3HtiHFqJLquC?=
 =?us-ascii?Q?11XhhWs4Lk+4vuM3Asbd+VTpwq5xL6SPgUpQZJ2rJOJeN/i7iDtYIW2236Zq?=
 =?us-ascii?Q?Ywaud+V4tqtS6I8mavdlKNT2eIwd1LQEIuix0WTPFit94BFHuMM4qEOSNgy8?=
 =?us-ascii?Q?lULK2lrnD56FWhQ9FJ83Q6eWFe3L70r027myG7aIvkvvAWzEpRfJYMqvtPwP?=
 =?us-ascii?Q?iRF0bnM72RMBrU2UtCu5WMDSsdMdVjf/Gnjk62IG7ZGgagQNyEc6mQfLj2vU?=
 =?us-ascii?Q?BXEDAXKrENdKA1q3vhmK1lNYW6tBZUho7zvDfR9h2bqkhaYCAkVmMa9eVU+F?=
 =?us-ascii?Q?U3lKcNxzDQKr4N12S8QfwUraAKBiaIE1uGIBNzTE3BDMSJS/q2VNoj9IDL9K?=
 =?us-ascii?Q?jKDLC5LcrLYif1dzlXuFK9XIz7/7wqSBORQiKusr471cs20Ra9eWp7H0la9C?=
 =?us-ascii?Q?OeCEi3IcsFFYrZWV4yFKtQAoxq097F/nIc3cZSySrsFPLOYSR7In/PzFr3Eo?=
 =?us-ascii?Q?CR3kyBtSPxF9EPdIbgYvWR0RQwW5Ght9WaXpJKgRb8z0RtuefrDATD3TwbkB?=
 =?us-ascii?Q?oolSTUb5EYnn1yOIoQKXjadr69vjfGpTzVD5aQVqusHmSPfmPejW4/lG3tFk?=
 =?us-ascii?Q?s3lu6PNyCQnPSwTxuoPokaQttyZ4SvnUnA+urjh4LA2sEmsJOiqC0728AUG/?=
 =?us-ascii?Q?/I92d47o3B1pDz1yicGV6j7y9lzJ24CZFRkQ1bZRQlR1rwUBlpaHT41o/CdK?=
 =?us-ascii?Q?5FxXL2N5EANZS23QNMqLzUxBJCrbxLrwTOY3D3bAKq77xDPo/ppOpFxxVF41?=
 =?us-ascii?Q?SPFkJ8kHF8jaFGofrRbwesV70DEqQKKO9CNA0VSLu2TmNUiuvzmvyEM5Lcxe?=
 =?us-ascii?Q?7KSDVSj750j2tG82/Mrxddm6wqZo7o7XMcJ3ABlAP4mgTGKDCONucLlq/Uxc?=
 =?us-ascii?Q?oxDjznmQ0jnmXOcL/5Si212HyU9EH9JfdyAWDYgxCeI+iMErsp93hc8ywkh1?=
 =?us-ascii?Q?uU6TfgHpTD5qRIGQMLXuUAOGwHO8yQdViH3MIpkK9H1AY8m9ZFRyafJkL7nl?=
 =?us-ascii?Q?LhQEEXIxoXHKTDVtj7cNBuAX2iCdHMA4n/3i4fqDCwGNc2vuGYcEJ6mRv1hp?=
 =?us-ascii?Q?UmRy084Qtj7ins9KHl4dR2G+4wQxyusFbOk3HHGEaWRgO2GyBAX+nURX9NcH?=
 =?us-ascii?Q?bLHIpr0hXevEuqMb/M1DPBEs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30ed99ba-0faf-4125-f603-08d8d42dd169
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:12.6298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s3dhMKxM2DzZn/Zfxh6uxqlMxWKcAIHLq9N9eDfLl7z/F2s5wjNrksPsrxToRStdIbOsfWa0pS1OQ0fM59VWcGoXkPGb9PqF4gymPj84cbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3605
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds an error tag that we can use to test delayed attribute
recovery and replay

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_attr_item.c       | 8 ++++++++
 fs/xfs/xfs_error.c           | 3 +++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 6ca9084..72ad14b 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -58,7 +58,8 @@
 #define XFS_ERRTAG_BUF_IOERROR				35
 #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
-#define XFS_ERRTAG_MAX					38
+#define XFS_ERRTAG_DELAYED_ATTR				38
+#define XFS_ERRTAG_MAX					39
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -101,5 +102,6 @@
 #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
 #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
+#define XFS_RANDOM_DELAYED_ATTR				1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 13b289b..842f84d 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -40,6 +40,8 @@
 #include "xfs_trans_space.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_error.h"
+#include "xfs_errortag.h"
 
 static const struct xfs_item_ops xfs_attri_item_ops;
 static const struct xfs_item_ops xfs_attrd_item_ops;
@@ -300,6 +302,11 @@ xfs_trans_attr(
 	if (error)
 		return error;
 
+	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_DELAYED_ATTR)) {
+		error = -EIO;
+		goto out;
+	}
+
 	switch (op_flags) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		args->op_flags |= XFS_DA_OP_ADDNAME;
@@ -314,6 +321,7 @@ xfs_trans_attr(
 		break;
 	}
 
+out:
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 185b491..39d1130 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -56,6 +56,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_BUF_IOERROR,
 	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
 	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
+	XFS_RANDOM_DELAYED_ATTR,
 };
 
 struct xfs_errortag_attr {
@@ -168,6 +169,7 @@ XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
 XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
 XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
 XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
+XFS_ERRORTAG_ATTR_RW(delayed_attr,	XFS_ERRTAG_DELAYED_ATTR);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -208,6 +210,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
 	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
 	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
+	XFS_ERRORTAG_ATTR_LIST(delayed_attr),
 	NULL,
 };
 
-- 
2.7.4

