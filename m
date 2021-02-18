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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1139C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5E1F61606
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbhBRSqO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:46:14 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44106 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbhBRQrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUCem180367
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=UpD4SMWJ+lyY3P0GXAXH8Zkyhl6RYdNTDY7yrpL+68M=;
 b=Ek3Ked1ALkzv6gnu225VI7lCyLr1rS6eUEe711yvXer8ObRbgK27IX+M6ZLqmJzDdpzt
 f28Qs3fuUzO3cEGtmXA/+e1l3qX+fR3XgLtovi8Y83j7ras7fDE6vE8P41pGU5kw+xAd
 zy/X7Ha0/skqlOoNJ70i9EE5e/DQ5zYTNdYgvdaTFNef9T8NppgkOqPJu2VfpAd+jq56
 lZyzYallUHnO5KYakAZDOInvvXGOM8bQjjUAimiORLYGCMcbnpvGACAlU9e3wtKD+4dG
 8GNcFGgzyXCSdaeU8jkjroDraHsi7j/q16xIlJpnGlnxwY+bMNmXvgttx6YAVxjroIK+ +g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36p7dnph16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUHT6067740
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3020.oracle.com with ESMTP id 36prp1rjuh-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxVh+CAIVishSY9Eu3UIW6wzcM/TyNlfSZvvedJJ2CRvryxaAni39LisfH94zm6uDvJgeImAUmwA4h7svGL1oH/vdH2ky71ZzRWRGm1rNOgWjL/7pMvDEqi4ZGjOs1MaUgRwmYcvpN6qnGyRmcc/ggtvhcWiADjYTqkTT2ka5rZw6Vmq5G+JzP7+faGD6PT8RO2jWvSHAp8h7vpbV/WM7qQBpXOe+C6jLszZwmTMkoxabCDUhwOf0pl2bc+ZS4csa4p8UzHkK+eb1TxrudxadZ93q0Z4WW4b3K9b255y/D4aaj8zLo5SOgDQ3HqnfqDAk+ue69zOG3keoMmeb9OrTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpD4SMWJ+lyY3P0GXAXH8Zkyhl6RYdNTDY7yrpL+68M=;
 b=dsw1T2QPvRad77b+ik7ZHohGYGCo/gb+9HiQxdxKpSlE1WoHwHePxblFlJ2b8W1eZTwZyU0y68MRcKNcg/rjI/ffi5ToyAsMm+GW9ko0UjPLkRdXyy+sU9HS6Fiv/X01G6KrPyyH6Ye20gXNNKcInbb+tnCr3QXL1gi1axebigIAJVItcMGntwt3PJQx9oALzenKzrTV70f0RWEMNQbwN/P1rMQ8sqfg5LjN4shz7esKef8k5F8y4SGsSkunqN4exDvLtCnaXW3h4JpTUiKBQL++WFClm1pW01lStkkE7bJ4ADo6hMZGtVqaOlV1uURwTDfB+nzyvUnSHxGzhACYpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpD4SMWJ+lyY3P0GXAXH8Zkyhl6RYdNTDY7yrpL+68M=;
 b=hmgr0jWqY05vubxorrfNiV905RONCtupCIoSNhHWyaf6+qgcRiCCIWUBy/XYLSNmJ06D69G8lfNXITcVbEpLql7Xo/o5YcB2oIJYTVD2iEDTnOerIygjKBzjWOijogz/K0AN/tu5O2XEByFL/FTjwCIZyBC1pn8GnBrqeHgcSAc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3461.namprd10.prod.outlook.com (2603:10b6:a03:11e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Thu, 18 Feb
 2021 16:45:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:31 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 03/37] xfsprogs: Check for extent overflow when trivally adding a new extent
Date:   Thu, 18 Feb 2021 09:44:38 -0700
Message-Id: <20210218164512.4659-4-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6573889e-bdc6-4c09-7063-08d8d42c9a8b
X-MS-TrafficTypeDiagnostic: BYAPR10MB3461:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3461496B875387DADD35CA9095859@BYAPR10MB3461.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:409;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2ZdBXaDFYtzd8xsxKapn5+2xvQTR1KDVVyCLEraNwnP7Krre3ATyJ9IDDM0OmxlF+EByFWu8UCQK1VlDhqUMjKK7M4khSfbrpCWKFHD8ma6yYvBW523ZfKt/22dlXJL1owYndcrontWBLmoQnCKhmcHxDPB8jJRLEt8RRNypDRG+k+cK8MwiGhNBQQjTaqLXouXL17s5u4a8qf7gptjjU0whLlvjpo/D59UKcut1u8T8Y47z15js6Qx9x+bSFkHoJD8LYp1tTFA+NSRDx4NTkvQm283dvCG8vaZnaWywnmXWrDOnEHjyTT3C/xi7oVvI1c6t0ohdXdFRzyz4wtzGVuTbTgAjYw0dzPZYY+ZKmC9Qosjs/0RGw51M3ex54eqj2N7CzTLBnVoHeUAFJWwwk5f6zV3ioG9CI7fmzFJ1J/Agp58JSLg8QsWCXYfQgBEjaPxIxkLjAyWt6KChnMvfPVNI9ZRZV1r1jnHWYWcCsOXi17NOFDHlXiqileX3o5lfZkKKddsWeELKrNFw1p2pN8afhLyhHiDY0JDNgfuCOt9NFGRXuCybqFUZRbr5MpmzD//qTS/KWWtUzh6hqhxxaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(136003)(39860400002)(8936002)(66476007)(1076003)(69590400012)(66556008)(2906002)(86362001)(316002)(26005)(6486002)(52116002)(16526019)(8676002)(6512007)(186003)(36756003)(5660300002)(83380400001)(956004)(2616005)(6916009)(66946007)(44832011)(6506007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vvkvNeI4pm4loYo7KdgasfmK2HWPmxTJL3+Eq5m1Zd0Tt7+6FRAfnXOnzj3n?=
 =?us-ascii?Q?D4CdYfmHxbgkJhJF6128hH41Eu5Es3Ww58IjfHEUGWnZRX/8ZZLva5rskqHD?=
 =?us-ascii?Q?37SzDttnHqczW7a/FKfM0xq6qIsyJ6kuiNjvlriOBMfsIXjNwG9vrQHwra7E?=
 =?us-ascii?Q?TPpzToucTBIbtU/aEZGdocSB+D7vMUSUssRLj5XIXqkRsKtoEE5aviqwd1Mw?=
 =?us-ascii?Q?FCp6S9gp8cQ/SiMkiSVrH+glguCXboGftf8YNe57tk7RMosQP8yVLH5Cw4T9?=
 =?us-ascii?Q?nsvX1zN1n1uKN5BrPnvNaDeVJ8WzbvF9b42mepHNAR4f+vyAUik/7+4cAYur?=
 =?us-ascii?Q?JL1ewY3n83qmyf84UhfdnL9Fv68F85aPvPz9N9tOjD4wjIUEJBzUKr03HB6P?=
 =?us-ascii?Q?YMp8lcYxsg1hVkExYI+Tfyu+DU/Uo7DnFye7jgnRBFBtDNDN+vXnR71Q4+g3?=
 =?us-ascii?Q?gUx4tlmIBaHYcDhjh7CH4E3B3MXdHoNr6W0yoEV3QTyXwKsdlyspYJxK4ODZ?=
 =?us-ascii?Q?dyrYmRQ/HV71dm5VI+rfp25Qa7iySiDvclstWlMOW+3VG10dFqgdLvXsQeNr?=
 =?us-ascii?Q?VsW9Y45h7H4Ln+NLP6JAv73WfJ8wu5lPmgZ870eEzFijNxWezWvO70OSgoCz?=
 =?us-ascii?Q?vvrnIBPVjBdCEuV2nK+95WzJHm35RrZFRgUsvwGwdIEBE+VynVkmsf1vF5Dd?=
 =?us-ascii?Q?MYKofXUCbdFCEBgoGDt11lTgQzngWQhOqxdS5LCzaBlJ9rtbEC1vY8OxAoxx?=
 =?us-ascii?Q?C96cYo41sNhAQ1dbQ/L/N2EXrMS901WVja7iiPf8icTPuPJv6/Zteqd13wvI?=
 =?us-ascii?Q?9/FfTFvBh/iYPQ1gSK04acZUdTtFlR/x6Je7oyj/SHyEtuotP08LHZ74/C2A?=
 =?us-ascii?Q?ZvLr5FuY3QEyY+EdLxEhy2D/l+tPByQO3bVErIiHBDD7w+DaIOlXvwNyuNG4?=
 =?us-ascii?Q?Wj6xMZUuk5t55bhUWc2B2eZTEX0mTquDpxMdosB3MKvB7guZOdL5R8QVc+Kc?=
 =?us-ascii?Q?InC6Z4TbmfdULpkO1gihFHTDOf6GFBLogAPsQsudWnFADnCPFRMOgiUUKVDH?=
 =?us-ascii?Q?dB6rXGhdz3f1oVOu9GH/Ri1WkVzAC+H2VG2Gt+/ZiFPXzKvmCDgv5idJcl7Z?=
 =?us-ascii?Q?heMZ9UR6qxQtdhQUk8tGJb5YXAgym6DOz7Lm889u8lot3xk2zcpsgXFoKUmx?=
 =?us-ascii?Q?br3K4Ekw/42Aaxzdu/xy6hY25T7Dda4SVyplsZVb8AQ8o8XxQDp5H5VPAmqm?=
 =?us-ascii?Q?8nQn0L1yZptIhv6Q3hqkSDc1nUTdxJoJENrYSUR6jjn6MiBwFlysE/s2rWC5?=
 =?us-ascii?Q?4ama+HUS+bxOkmGTQo+BW5ta?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6573889e-bdc6-4c09-7063-08d8d42c9a8b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:31.1106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: giYpBHGrfFqCb8wU3ixy5TGtBxaIVZn0cL+vQTnemenIHgsz6dSyWmNLhC60huOR1LhfMP4rLVdp6P74i4WQJ45mUh22GefsC8qjUgpYsh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3461
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
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

