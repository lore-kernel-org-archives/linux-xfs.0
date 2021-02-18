Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54747C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07E5B64EB7
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhBRSrH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:47:07 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41604 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233368AbhBRQrl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:41 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTHxI155892
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=lGYBoDBmpKjTzN8PgK/eWkvN4S2Y4sIwPgNIZB3NL3o=;
 b=HZB4USXeIkNzemmgaDFpiWLivnIUu2DbjNd2DRzQYWut4P4CHcCQPvP0FgtNfGerQiJc
 r/rb5maYT+Dhy7aUsZna2PRwe8Y/0wfZhM6vx6iz/rV9B5WmENZ8srBqHQpPQrbVjEFu
 cO8XbNIx7nHOjRZV2QovYzZXoJQR5elpLvk7hGf2ixouZRjIjxkU4xEC22YGcOuf0gBj
 nstG4Obis9fZu57YNiiHmH0eSrX1fi3D6s3JesljiKTSAm/5+0vRxYn2Oebg3nejEkRH
 l2PX9Y7YKxwyzqys8Ho2C9LeFcp1BHpZgZk++zvgcnRkhxHjem8guOXokZAnX7Tmtb4b cA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36p66r6m7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUJtF067888
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:21 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by aserp3020.oracle.com with ESMTP id 36prp1rkpw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1MNQhBDPP/Tzj8NpAk30dLmP6pC/VtUOQgElhv/aYA1K8B94LBC91c2POrRm+9mo+YdZYExmU2BatzVO2C+sRzqtUrZ+FywUIai3J2i2f1cx/Hjz1ujkUDTbeCqUpYTTNGj4GQy301rcuQwwKfDSCZlL41Liv29FtcXTEOXCuYYITzt+WW0xsaDh7vAwIHMEONTqnr/j96fFaHZxNvbthCU5F6rzmCbzyWYTAErCC30nc+htkEmEBW46yarKbcAn9A1Apjb/LYjOaTvajNagWw73/YLdCG75SuTSexWsdwu1UYVinvaCkoOPZM0F4QQvYuXWSYt77PfnX5SCxwiug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lGYBoDBmpKjTzN8PgK/eWkvN4S2Y4sIwPgNIZB3NL3o=;
 b=TbM/f4RLu7Udv73UCCTOMK3hre+E4Y3l7ZYB6fmdGy6PX8rNjbDbss/ClDzo22wJPfJ66GSUgiLU78qkf4d6hoJn8W6eXU9Np5tYvE+nA/kbKAn4btUcLXJsKQWPbpjzcVEuEhxPdCzFWZDce4z+01BZUyB4gqRHj4fHY+RMH6XyK7ZevQo0tJM0zoJQquDitxHsBvMcZcpiIJg5r9B4uDWDopIWuC70eqgQ4t32ElgxaOnMJjW4gJ/hhe66NQB8MwMmhCfR20ObuS6Q+J5ilbitSJJUZRZXS37SatRw5ej7TIbhbv7G3A2jQG1JTPF2HREMD4+mvSQ9ZUCgit8mZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lGYBoDBmpKjTzN8PgK/eWkvN4S2Y4sIwPgNIZB3NL3o=;
 b=Ffq3eYCLHoMRKDt3IBYdStMutAA0owzw4cu3Tqi0o/GW4BeuItZ7pacjj+OwmwKBt1Lqkb1LHq+xJjVRFZG69ZRgFvKspR99y2560ZaFU1uQ9WvZhUijRP5s/9BGRTa76nLxqNvJozvKT0VgAXN+kNurY0imw43ZaWMD3seEryg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4813.namprd10.prod.outlook.com (2603:10b6:a03:2d2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 16:46:19 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:46:19 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 36/37] xfsprogs: Add delayed attributes error tag
Date:   Thu, 18 Feb 2021 09:45:11 -0700
Message-Id: <20210218164512.4659-37-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22901117-8743-4628-2c23-08d8d42ca478
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4813:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4813AC7F6C89C8D48B2EA8AE95859@SJ0PR10MB4813.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N6aubQSZaFqGzfKCIDjZ4F/SJ0DHikdJdvrJk1LTFYcXnit4B3sIczzOZheYLKYmWpTmsjbNTPmv2xy7dpVi4QGyy9ASU47sKPizMzVzNsAJSSFk7NEKvIZFbmEvbuFbeRbId73goC1/z1E4JzSn4iRoIzQERecVC3fxormHDP8n8fJOXGwHkIbX0pEnTTyhHhjK3VbeMnzNpk3ySYH9nl05+TkTAva1Ju+ZYlrpElleXs+QVrVNnhVhD7ibzeaS1+R/1PjFh6RJczkb15DgNNLfxfaEajxwx3ghbP1j3Wu84SUtL6wHiLS4EX/A09k1y5x9f0V9InbCRB96bPPkEQ6eK55lfXkIBUX+FsPnl6TARWHVcA4FmCs43O4/MTgKttW9ej9ZJnJC1dJEUWNj6grBNGOCz5Ers929Q3AE7t4QTPEEjtC49gDXM6vZcZR42lrfhJs8OE+5AJp0qQYDNkKGHCpdck1kotZwITcFSXYXoODsXzmWLKtnWXSRAToEt5coZbak+u2ccizxtcT0A23S0QXapVLmi1Jj+uMIlllKKsmrkQhUJBnioQ0NyHthpqv5bgykeMA4DyqZ2ObeKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(396003)(366004)(39860400002)(6506007)(83380400001)(478600001)(2616005)(2906002)(66946007)(66556008)(16526019)(956004)(8676002)(86362001)(26005)(1076003)(52116002)(6916009)(66476007)(8936002)(6486002)(6666004)(316002)(6512007)(5660300002)(186003)(44832011)(36756003)(69590400012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sTNHCuDeWZfQP1ijqLe4uXTZlgYY4fstIZBalfQbKOXsMaIJJ32NmQADvwqB?=
 =?us-ascii?Q?rEB51TutE3ERI1ns7CAYjejVNWdY+1MJ/DCshxE7pcdpgHAEyy3hTlg4tnGo?=
 =?us-ascii?Q?GbckPeF3rsi9eP59KTbAUin4Ps3DczdFMZQmRvYxvGw9HjY2IVgNkL2sXQrF?=
 =?us-ascii?Q?+dTCpdksE0mmRJlCLvu4Hkc2oJG5zKXePeB2KMH6n3m+sg8wOF6OxQOk37Bx?=
 =?us-ascii?Q?iyZO5D3wje0njtFs8ohfMXT6fjS+y4I31Lfp1lIs0iq+KAPesvXGwOjjXJak?=
 =?us-ascii?Q?ghhxmi7UYTUKqsWIaiLkMW2a7p3HIqrOhjJdartJTD0esLKVmWFA754GYcu/?=
 =?us-ascii?Q?n+YdAgTsA3Qdme5jOQ5IffiWw2oNdJhYjmmu7dVrcvfgNp50jWEp2W0aJm2U?=
 =?us-ascii?Q?avlioQQ5ihUhTxVA6PNBHzRmg8LwnIdI4N0wVhPTxmsmlI7oS9i+rS2NCsbA?=
 =?us-ascii?Q?TeKjv9hc5gUtyodn8YUcBMs9q6QA9UZCW+zbAt/4ZyffqSujf8RaNH7WtlUS?=
 =?us-ascii?Q?GXyzyKwpNXBUcZ1yrk/KiwLMaAx+AhDLSudZ+gUMZLURYZWPYqgBaJq4K6Ip?=
 =?us-ascii?Q?Yj6E4BzeGQKEsAUjnE7NMCPqNifFc5oylg56AqfjdRAaylltqiOYMOApJfBu?=
 =?us-ascii?Q?t3DDF41NYuGTjb43u8mEPxT37RZ0yh+F5FdTgd9QhSN+zr0H+PdFY1fKKioO?=
 =?us-ascii?Q?gxQZUN2B1gzvGFeWbHQXfhrTVWFR/GLfxzkm0pG4HA3H+glLpJNnBHqJXX1g?=
 =?us-ascii?Q?tgnJEFFnkL055Sq4wCKUjkZn+XWA4z8iWbJH7t5DXcCHR4bznzbuBxCnBn+3?=
 =?us-ascii?Q?ZNpd264iijWQXkpZ+S39xRDG2f9iDzBBOBoezhayUqeCduKHQwQd5R0ZRPQV?=
 =?us-ascii?Q?37lFhoe1H3fdyxV3KCG8dRED+bLEHLmz05K++tVq1CCjTwrwqv6RgBE68az1?=
 =?us-ascii?Q?Msm9EPgePnBXwxJ7scatTiPYxHnYTcJVkHpqGfkvIa7r1ws5yMJE2Hl4doWB?=
 =?us-ascii?Q?35rU6ANgEqFc238WB0RuOJn4qEmmahqG7D29nzFd33bR1a9lsRvIMd0aBj+N?=
 =?us-ascii?Q?NPWkTQasxEQXqhagkDbsFnDrUppYryZQKxDRX2jyKYk9/E1cZ2ufBn/9IBK7?=
 =?us-ascii?Q?IpWnk60l8GnxFbTDp6J63N7Uuq5ULE6kwtjirkK3SDwY6mD1e86oyjtMvkZo?=
 =?us-ascii?Q?HCzvwyiG8HLV0isoSAY3LrBNpeqTGoA34xHHmhzLt+PEfW8UNPSpj83cM0zD?=
 =?us-ascii?Q?+KsX4GOt23mSmEPYd2eAl+cjDQRFmhEFRPD+imSOwn65CEQ31SVaEH/uJUcg?=
 =?us-ascii?Q?XpNBbvqBCOjV4v4iRmKXueSi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22901117-8743-4628-2c23-08d8d42ca478
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:47.6919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: doRouZPCtUU4nnKNiYAwD+A2o3n7hmLTZpN3HgjMg8U9KFNVocwG1xPsSaMMBPXziyr6FqGPFeR6Q6ldD4HXpraXMzocbva41JGU/uZbmIc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4813
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds an error tag that we can use to test delayed attribute
recovery and replay

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/inject.c           | 1 +
 libxfs/xfs_errortag.h | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index 4bd4138..7fef1c6 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -57,6 +57,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_BUF_IOERROR,		"buf_ioerror" },
 		{ XFS_ERRTAG_REDUCE_MAX_IEXTENTS,	"reduce_max_iextents"},
 		{ XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT,	"bmap_min_extent"},
+		{ XFS_ERRTAG_DELAYED_ATTR,		"delayed_attr" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 6ca9084..72ad14b 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
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
-- 
2.7.4

