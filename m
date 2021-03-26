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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB7AC433E3
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 144E8619FC
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhCZAcA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:00 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38464 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhCZAbq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:46 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OY0e066348
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=UpD4SMWJ+lyY3P0GXAXH8Zkyhl6RYdNTDY7yrpL+68M=;
 b=qOWA1lWFYBF72gVlQ6FaBRPr1bKW8BmdNhInd5Xy17/nfSYqajV5b1RFEYt83JNE522X
 rfSuwU8leu1WyZ2ADDu8dntPK53dbq4ou62c/GHO3srZ18Z+f3VYbkNkqrr58TZfesrS
 aShFO34jX13mj+ssD7WlAEsx7A9GSDl6NmvKjFkX8dFYC3K1uiDIIV9MvJWyYNNvXRJK
 ZXr6Agz6at2FOU9b//OC4tg8ccIT/hxYxjy9c8A3iSBgNb85j43q6d0PaKfP+vRyyY0X
 6xrwdKIi84RJgUa6KA6J4qfFRzbGRl86tdbhpa2p5mJ4DdlH8U+EdDVw0EJGXXDNlNuN VQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37h13hrh5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PK6J155451
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:45 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 37h13x0454-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXOxOG+JzfZNgiJkM46bkIEypoxTOT/4XT6oWZ6btoS0LNMMu/nsU19mbEl4tuYW3LHrd886pEGdRb5tIdjQvreiYhWrl74IVxvt8co+9fdMr6j+CH//ICncDEHwgWOgtitTvXHlsKE1HdvYnwwcuWEUotQ/iB+daEFnzX9r1pzcHzG7q+LfAPuaN15ROwJC645pr/J9L0QpDy6BcpOlz2wE7TNJyM/PHMERxz8dZ1+/Oyec24Z+0ociSYEC/wXQ2G2j1dcxMDn2SJv/JRifJTDczgDeeAjOqfoG46WXVVdIOYi3OlVoQiCjFCawi/DD8YpFrCKZTAvwVeZS+XFKLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpD4SMWJ+lyY3P0GXAXH8Zkyhl6RYdNTDY7yrpL+68M=;
 b=NQ46yA2YMGnU/9IVbvcnUrT3bzoTcXe0LPqhzZSYxkoIs00+ZQM5cBKh+AuxTRZUq4fCXCpXm9G3vU2TzG2dtTmPuMyX79Z4TeP10c37Dkm51NiR/Ih0aDaTIKYcM4p1TU1xhKvFuv4lLlhzxXKoFWFJMbeV99jSJHLf13JJXFY8XRDe1sgIwMRyhz768KwQR1T6m/1iaXgmPRMZj9VXPJoUa0ylS9p12pEfqjGkYLRubeZgnpHn6pNE2UVBtuzstEPXoUt/p1G/v+2qnH10jrI/Brx0tN/8ykUq3rPVHUAa+4KrnbBbeUlLI291j+6R7SlXarJgCG+vjOfFzkNBWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpD4SMWJ+lyY3P0GXAXH8Zkyhl6RYdNTDY7yrpL+68M=;
 b=jYT1b2P7dAhsEKtK1LMnz3YwJ4KI7RvdGtnJjXkpDakJLObjsWJNxRLwvnf8gpFJ+TjDsMinViONLFoVjpzIssMy9cRrNJLdaE2mOllK3YvJ2bXwvrOy70VP4mD4VOhAAx01ljSuWA+/NY1WRYIKGvYSrpaZVHNmrVsCaEw6GME=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2758.namprd10.prod.outlook.com (2603:10b6:a02:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 00:31:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:42 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 03/28] xfsprogs: Check for extent overflow when trivally adding a new extent
Date:   Thu, 25 Mar 2021 17:31:06 -0700
Message-Id: <20210326003131.32642-4-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8619b69-e0bd-4dc6-8794-08d8efee8782
X-MS-TrafficTypeDiagnostic: BYAPR10MB2758:
X-Microsoft-Antispam-PRVS: <BYAPR10MB275818349356A56C6B21303195619@BYAPR10MB2758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:409;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zRSVGSXD32T6kN7DVKDfrM9qmAgvlzyx/zurIQyQQcdfXFDh92sjXEhRfuydofgQMWsd9K/GV/qiPAo6P+ioqDaHBaalYm96h5fkFXV3j4WBNh+T8Sa713DY6F3Aj8EmqCFB2PlAnRLySjIS+LR7u9++8kkOMHfKHuPXRih45qneRcZXkst8SMZD1vwgO+CSgQ0sYnXuV7oJ7K7FvV46R6/wrb3akic8wPxgBW5R9MPdoTfSWMJj+PuYijz15nZ3UUK10ewtmDr/BGO5XPREfr0v4jHDh7s1ocdeQNxcx016qIbuQG+zLsG/A7Vl6sWcth5oZ/F9I1pb0Az5SVds8C85+YeKNDOGXbVcBjfMsmVpB94q1GY/5rZhYzxQ7cXOmb6GX6AJOGbye2+rys/rEGP+1JSR2ylHoS4Ob4q2Ngp2aQ9LO/zpcJ15gnZ15kFfL9OUaxWwP8Hu7BQ+kRMp8+yfF/vOXqua56JXqcZ+XIG2+FIjnHkO9iYUFkr1oNIDEazgcH/UjDqWQ6ogW7UCLLqoyf503sz+Jt7byPLHEjNa9zivH7rCMyraPsKSP+u36+9TJ4XyX9JpyykZQtl1XoeZ6iPtx6YbMEPYnDRse4SIG2TjCOrmhodUiRZrXjSxyati0rtV6h1dj9b8CLe1zErvzhn16DeqGkaqGw2Ky8u052duc3HbHR4AS5M6HB1v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(316002)(6666004)(5660300002)(6486002)(16526019)(478600001)(52116002)(8676002)(186003)(44832011)(1076003)(8936002)(956004)(2616005)(66556008)(38100700001)(83380400001)(6506007)(2906002)(66476007)(86362001)(6916009)(66946007)(26005)(69590400012)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bfWZ/OONESkEc/qPSa6KuQM14yG4UL6bjo9JGxK/qnzHzavr8ewBiZRToDbq?=
 =?us-ascii?Q?LitklGuqSCaoGNzVV/WFyvmA0XcMnVET+MaxoremTnEjAz/k8R1P+UitlPsh?=
 =?us-ascii?Q?wUiPxBHDEkvneRf7v1k/GRvbjQEmZyuCZaAZdooa6oynnkF6pe2rEgodR+Lv?=
 =?us-ascii?Q?0aNKX7jZkuhYp/68nd7s+hB1gWYteTKK0JbkYaI+9FnEzs6OGXioOgpqt9Cb?=
 =?us-ascii?Q?mQpdNaWsltZz+tz5r1//x3JGL104dVn5+Oz/iFqzTdPbw1Bd1ZMRAXdkAObQ?=
 =?us-ascii?Q?y2jUDv2/0V5W0ahUieE0sKNxZfSczGM0JJ5aRSTqHFyDplMaaIiYOr2kxYS2?=
 =?us-ascii?Q?UcEGwxUF17oYcF4p8YeAo8EfTJEWIkh3qeQ7NQCAPX/pveScKoLxlQ1O3kDp?=
 =?us-ascii?Q?WHi2kYbE1B0xpXE207eYehDTXn2lFbcPYTNotOze0hkPM1uJ7O8/at6vRgbi?=
 =?us-ascii?Q?dEmsYGXQ9PmjgDBLwK2dpkmGQKLihMTZY51RwXNkBusxmVJRuLvWcUmkiL62?=
 =?us-ascii?Q?IkASK49xkRVUSV1DmJexczFfDniDk7bFHSBo0LK896r+rCRbSifpXVB2KoRa?=
 =?us-ascii?Q?X+vqxCnr3rIgVTNBpWNbeG99irf2xRuBm2d7hYLBxHNtlDBpbtsceq+A4xyt?=
 =?us-ascii?Q?PPYFPhBh0/Faomt3hoiiw6aPJXVnsPq6j3DABiUlwKC+It7ELNlNONp68iWl?=
 =?us-ascii?Q?aT93Nng9i9S5ZBNG8+WFH3bUaP2b2AIXcrRYyxssfkSN2UQ3MJwdE6Wiuw1l?=
 =?us-ascii?Q?VI+fM7wp2JHS3SwjX9jH3PFeWjoN7VCtnctR2julh6mObPBcfUxaU4dT1NfR?=
 =?us-ascii?Q?TST+6nuNfE/oHdvDwp7lt3VttDDPLiuTpa9Begs/Cu5pGdO6zQCU5rgsAoKf?=
 =?us-ascii?Q?eZgUWug3zjvjGJVrLCGdadgbeHtejbtAbwUjYPCbdxNEFrXyKLD+wsOoFGf8?=
 =?us-ascii?Q?YwhxEJevIQo9bwutgt9G4XF6hLQLYc09V89pesd4wk8StHrjHzGk4m5pL263?=
 =?us-ascii?Q?e5M7OfA/pSEfe9mc7vLMvZkyMQTu1Yu0iu4qjHv4XRuZShpBQKNy2/9AD18d?=
 =?us-ascii?Q?x+8b5LC/fLmZ6UJiL6RpqQpWRmXKSL87/3AkxAjg9z+1ZpJZcvWRHEJavbYb?=
 =?us-ascii?Q?V5xNbpDVowE0TZCwUevqSh5+x0WtdKNcw4AKdMlrYY5S7EBpGd/ATXpHjo1e?=
 =?us-ascii?Q?JvMOkAA2J4wjj3j69sdhgxAFLyQG4s9c8dlDqpd+HM/qwuiH888zyOxzJTA6?=
 =?us-ascii?Q?wsz7fp34p+ofX1VukfBVSqB8IFrIivsmUP3K57WAooqUiaLw7D9ro0QI2oHw?=
 =?us-ascii?Q?eBCAAN/s/JNEMUqMQXYSMWLb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8619b69-e0bd-4dc6-8794-08d8efee8782
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:42.9241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gQvFAMpW79hSBpSixqj24xgdRVmaUJTb6B/4OxLAqP3sCjzjAMLJfuDUKM/MEj9KWxL5IvRUEqjKhHzs+hiY+6TR5LXO4GBRMyzN7gnZv9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-GUID: UzMvZJbW8WVZjhOtGpXVnPj7aGYWVgYS
X-Proofpoint-ORIG-GUID: UzMvZJbW8WVZjhOtGpXVnPj7aGYWVgYS
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: 727e1acd297cae15449607d6e2ee39c71216cf1a

When adding a new data extent (without modifying an inode's existing
extents) the extent count increases only by 1. This commit checks for
extent count overflow in such cases.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_bmap.c       | 6 ++++++
 libxfs/xfs_inode_fork.h | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 1e53cbd..336c6d6 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4520,6 +4520,12 @@ xfs_bmapi_convert_delalloc(
 		return error;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	error = xfs_iext_count_may_overflow(ip, whichfork,
+			XFS_IEXT_ADD_NOSPLIT_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	xfs_trans_ijoin(tp, ip, 0);
 
 	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 0beb8e2..7fc2b12 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -35,6 +35,12 @@ struct xfs_ifork {
 #define	XFS_IFBROOT	0x04	/* i_broot points to the bmap b-tree root */
 
 /*
+ * Worst-case increase in the fork extent count when we're adding a single
+ * extent to a fork and there's no possibility of splitting an existing mapping.
+ */
+#define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
+
+/*
  * Fork handling.
  */
 
-- 
2.7.4

