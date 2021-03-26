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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4440C433EB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF13161A43
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhCZAcD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56892 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbhCZAbu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0Ps3a057993
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=CjI+abj50WR1Jpub8g/BG7jETIgA4+It8y8CxQ3v/Gg=;
 b=XFICoTHeWLuf5+Yq7Vm/hyurzAM6tD8R9B9xdkzuMk58JZ6EtdnjgrVB2+qXZltMYew0
 5LL5uci6pB6H0+T+XfOB+0l6LNYL1us3fY9cGzAwlb4mshDqU2CT5Fcm3l80vKl9Aw/d
 8CgwToffpPm7meQpP1o17A3tuwVcFmYM50y2HKD2POl5OJhX82NRalKoVDLGDNcclAcC
 TxEifvfqF6aqokINyfKYLjuTkmEu1/FvFjqgG1mqget4kKpr81Y2Z964loPQ6qvTc1Ee
 kRdRRBLaNDPrz6erU4Pui+iWs3ZBM4uyVsDNUAbU+xxGuv7ADQ9f4/0G1DHfbUP16T4x 3w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37h13e8h46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PK6U155451
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 37h13x0454-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4SMwps7PSFKzSQ3PsqZOHjkjtmZBv+ymxPJAxfLBjCVdQlOmPXOe0/rc05Ikf0XgHpTcmSBj/0gRoO3a8hCEsnSEmEfXtBHjAInuArSJMhRtZieTw1VNtVRZ4aXlT3eCIPVUwGXs2eYzzFxKbpJZHEnPDWxhCETuMVJ51iNoW0XLB5ZRSa31XscZQL1vHJVeXnfRSV3+GvbXecPE5KTe5u1SKX1egpWavij0jvR9Daps/Amj6A9/qjYyoeJ/f2kBCHABGE2xFj9tz9I6L06jPFTofpTxvJap9QW0Kab4jWdIHCsqGETMr5WeOxG2ttj3P63ld+Gef3rmhFKAuhu+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjI+abj50WR1Jpub8g/BG7jETIgA4+It8y8CxQ3v/Gg=;
 b=BCdjgw7qY8b8xHapyAayjxPQ3y122irt1zl9UiGELeGtEawZWJr9f5kHQ1zKofBESP7cVwXFYFO7ywbdpWL7QajK42bMWF3IULzzN6bA9B7JFL8kr/+phcdA7PTFmC+txfv5GeZP/vxMCW/hsdc8ynGjDArWId5P784KkWC7Lm31eUwexXOnqugurbTDKW7vzl8bwkeWWPw6PCqMrVhcsseDaAcwHFuRU4k61ZpDbe9iqqBFSUm80qXgmV3R926uXIGIIml8sS6OEw1E2sYMUh2hM5S1fPYk3uOonxNKJmw4jB5QOv6ErYTqVtQvqDf3Y6ICoX96oFGeA7n5nnpeCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjI+abj50WR1Jpub8g/BG7jETIgA4+It8y8CxQ3v/Gg=;
 b=IfJZmFJLuRtu3W3V668r+ahn/vPgLnrR4Ag66lMKkxkqVaEyOcuGWyqAwoLkEZNxnULMGeDksCRV0D3POQozzztkBbVuRTJPmAQglAQsu43SJy/E3x53mq3/YTienGwVpyAIRqjq4lctJrMus8xQe82Jq/+8mdMubE201wSWfS0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2758.namprd10.prod.outlook.com (2603:10b6:a02:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 00:31:46 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:46 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 12/28] xfsprogs: Introduce error injection to reduce maximum inode fork extent count
Date:   Thu, 25 Mar 2021 17:31:15 -0700
Message-Id: <20210326003131.32642-13-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3019324-9ed1-44d0-c436-08d8efee8967
X-MS-TrafficTypeDiagnostic: BYAPR10MB2758:
X-Microsoft-Antispam-PRVS: <BYAPR10MB27588C34A00234BF5A5E266995619@BYAPR10MB2758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:168;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AYk9V0FZCdJxxMcgORirxh6ung70NlF4m2B2lgK53S4wS/yzGHz+uvJrbwJe8tZgr1TkuQQvdOpwiAIzXV7AlM6iFRhUnuzk9Hrk1GKtpoEkLuUZNxvHWBV2xBCSG/RzJCP7MH3+/HTaxvGJrKSib5+y4Cq1toeFkFRyeMRqwAO79F5l5kpe9yfQGGe/xLDh6MiaGDhwq7GL0nbc5GVJs0mKyR7gMp02FNef1zFZ1k4o+D18eLp7LBAodn8gtXJYHEBYU6FbAvISscDo1g48RdHBg0E992dL1SKEiTNvTyCQmY2yb8EuRJxW6HGDL+xg0JXfpLtDDz8lkHFRPL9Cc0PhH4vnsn2xJzFOGrAW2P1mS+vqa7rBK4W3YwCLhftYbjfN25MUk4giZ+VkyLR4aXVn9MLs7HCFPZIfkxHHZqfI8VIiZzHujXELMjA01k68ImIT6Ey8m7bnyWU77OzxMTrTw/PruUw1ncnSp9cbxsHe3Itat4+Rf6DzI9ZWatIIXg0ma13OZaqhjvQzSVADBgW9yydlyDTXGYNWcsJR7BtcvLn7n/hgAVAh9n6Ceuhy9D6PyFzaodF4NXm/gcZBgEVu85iJhulQaH/ULZzxambDIjc2g1D6U98BopPHPOvvA0c256m0TJqPddVGsupti+Rj7rx9BwsA4KG2wCk+7vZ2V5wb7gTdRg1nqFdbGr9K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(316002)(6666004)(5660300002)(6486002)(16526019)(478600001)(52116002)(8676002)(186003)(44832011)(1076003)(8936002)(956004)(2616005)(66556008)(38100700001)(83380400001)(6506007)(2906002)(66476007)(86362001)(6916009)(66946007)(26005)(69590400012)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FaJvU4JduqmJsNNopvy8+eQNbtWoPiE3iEah9MnBTRATRZUE2d8zL3hTUg4W?=
 =?us-ascii?Q?9mVs5XBMGYPRIW0x8qKQ0vLG8k6dbidevV1O+PnC8spDfFoGQSNVWLdNKr4L?=
 =?us-ascii?Q?fk/So45sl5esxA4spu8ZnJIF0EBG7IOcYlwsj+KGj2DCcTgUfSb/oRuE2uXz?=
 =?us-ascii?Q?KQiTwfTRagDBYzzTEA5Z8D6cOfHL8wpE0eNZwYikMKVQiKU+FL+srcoPWhku?=
 =?us-ascii?Q?2WoRwSRCGi9N6cs1DE5r6A/TAvPde0ZV1ISJIEyygjgbF4lnCm9rY+JzuG0m?=
 =?us-ascii?Q?pWBolvvQ4NxS/tAUEm6JMa4VNYKtLZcrYK11wqcfk3FBpiXV5gS5bcx3T5Rs?=
 =?us-ascii?Q?Jqftc/KTT8ij+zq3LPLWFdclm9zvJmLQFSHvyRX42RZxNjuh2hNZIJ5odlgH?=
 =?us-ascii?Q?/cwQGKcR5o52ENPMK5JU+a8zzcPX2cH+RRI4wv7/x8KCNTvu/x9vX4KMYz8R?=
 =?us-ascii?Q?2PA3qlOW+d8OoKaJuyGW1JcMB0+29BvJck47AJtm/5aImmlvAmUzhj6spwKq?=
 =?us-ascii?Q?Zq8JM1LhX46487cZNfT/TAK3MTCNhM5Yzm1Xpr4lS3CLskZhx7jUCkpQgD75?=
 =?us-ascii?Q?YdQOnWlmmyN4qU92o+wsMzMpZNw+YWJQeJ3/0jceZfmQ5Lrha/d5LTnXUiUh?=
 =?us-ascii?Q?wDdw1R4AG07Nswz7uuWWQXm/+REASMgt1AySCBOGNSho9PDsdKMwrd7iOVGe?=
 =?us-ascii?Q?CMewHZUxBMWGNtZ0VK6cDRQ+bzBFL97rehXLZARxan01a7saMqbNfarp2kTZ?=
 =?us-ascii?Q?yCIXhYFE/3vs6svm4GO/u5rlD72w4SeW7zqxP7up5ZGD64KGgVVsXPpCs+20?=
 =?us-ascii?Q?RlarqZ/PSz25k0uCmOxVJAd9cBNVMGZEhjKdkTIz6b5KsvL982e9RY269U8T?=
 =?us-ascii?Q?kZq5wMfDcSvLKDQl+j9THFCWCvY8MdgrLpTr6QT0HZM4uEsHHGmKPtoklVce?=
 =?us-ascii?Q?YLNCZJgICFM8onflIRZSPd4FvBBx23KkwxGygUHLjTrXVlhkl90xX9wE41RO?=
 =?us-ascii?Q?/Pp1kIRYqR4PqQbNG593rM+txoWm5fYH0wgJucnFXdwdlgzluw74sAn2rCRn?=
 =?us-ascii?Q?qv4T62OfwMlE6HtyquhEorLxb/4oAdCU+rOHjXms10NRx1jHDnyHbTSr7V80?=
 =?us-ascii?Q?xxJvbAIiCU2CMqSTs73gIBPxueIEaUuwF9c0BqzuFiR8enApfTzbemD2/+7k?=
 =?us-ascii?Q?EQJCEIssX9yS7+g56VMSeQHj8ss3IY3BdeP8wxjDsbIyVJ3WeXR/0LIgI1gL?=
 =?us-ascii?Q?IcXle5EfU0KlUu8W9FWn8ntMtoWpdujW95Apiwt5SDzzoD5JKReOoeNZSEnF?=
 =?us-ascii?Q?SeU9doTd7DVGQ/NFKLhC/QcO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3019324-9ed1-44d0-c436-08d8efee8967
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:46.0733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zhs/j5ydVVDJ8/q5com7TOQKmz29Lr2KCB4YtmY1grmGCi82LSicj00S18U9CcVhk9j+5D+AWHbozpOaQbNlpjc0SuaQCA+s1ZrVlE3Nago=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-ORIG-GUID: Mhefzo2rO_p_6PqtXxzpowLPuYV0cm8k
X-Proofpoint-GUID: Mhefzo2rO_p_6PqtXxzpowLPuYV0cm8k
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: f9fa87169d2bc1bf55ab42bb6085114378c53b86

This commit adds XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag which enables
userspace programs to test "Inode fork extent count overflow detection"
by reducing maximum possible inode fork extent count to 10.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

achender:
	Amended io/inject.c with error tag name to avoid compiler errors

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 io/inject.c             | 1 +
 libxfs/xfs_errortag.h   | 4 +++-
 libxfs/xfs_inode_fork.c | 4 ++++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index 352d27c..ff66b41 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -55,6 +55,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_FORCE_SUMMARY_RECALC,	"bad_summary" },
 		{ XFS_ERRTAG_IUNLINK_FALLBACK,		"iunlink_fallback" },
 		{ XFS_ERRTAG_BUF_IOERROR,		"buf_ioerror" },
+		{ XFS_ERRTAG_REDUCE_MAX_IEXTENTS,	"reduce_max_iextents"},
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 53b305d..1c56fcc 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -56,7 +56,8 @@
 #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
 #define XFS_ERRTAG_IUNLINK_FALLBACK			34
 #define XFS_ERRTAG_BUF_IOERROR				35
-#define XFS_ERRTAG_MAX					36
+#define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
+#define XFS_ERRTAG_MAX					37
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -97,5 +98,6 @@
 #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
 #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
 #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
+#define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 83866cd..1802586 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -22,6 +22,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_types.h"
+#include "xfs_errortag.h"
 
 kmem_zone_t *xfs_ifork_zone;
 
@@ -743,6 +744,9 @@ xfs_iext_count_may_overflow(
 
 	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
 
+	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
+		max_exts = 10;
+
 	nr_exts = ifp->if_nextents + nr_to_add;
 	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
 		return -EFBIG;
-- 
2.7.4

