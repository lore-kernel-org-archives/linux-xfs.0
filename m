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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF0AC433EA
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C205061A01
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhCZAcC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56886 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhCZAbt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0P0dT057822
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=OuUEtaU6C+uVckHqV3oAuehatGq61B8GbE/ww1ZJaSQ=;
 b=uHaHX7GNhmqTCj8c+deobiC2NzX6SjNs7lEVcMbd3vuH+ZbpzOJGLzTLSjtHH+UtTWV/
 frbef0Ce+tlPxf19yykB2NTRoON6svRggaCvQGAOMDUpFr90w7r1WbAdUrBZiFHeUx/Z
 XXdQVvNVLPi+3jm9Elj2sJKuXKL22+mGr5bKi2Fko8Y8iUo20gXL+MGfo0jRxoBM4rEW
 GfoFYB9PkAoOKtGrzPkDp7XkCCLuYBhmH/QLKjAEluH1m8NyZBpgFS1hMYwWRzSSqStl
 6YBUMH5Ik11BxvxCwmOgo+m4SJYWSZ737+LknOuR/u1cY6Y98jmGZgWv0gFaCgNni8tk kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37h13e8h45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PK6R155451
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:49 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 37h13x0454-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bljlqr1eGwbQTS2GmF9Yz3BSpZz6ci8DxLhiR252EK/MJTxOJOaPs8ScEb8miGCisgS9nRkvqaeg5pPuXOGIAJMwK/1UdhvBpnlVp0BDdC/ZALgFJDQnhNJMQGg3CyBG6X1x1eB5mIoAM0I6FW/bjwr/G24lgsA7HADMfLqJEPVTlg8lH1yn8FesAC0s6kWfqoWFsVLu/10ElwddwyjWU2VOtuX4116/KY5o833/yYn8Ma2lE8S4v2Ad9wj1NZEmiXbELUwP4/ko7tDh6G+HFwl8dtSEzKpc6r0rgKLUkPUWT/edPRV/0dUc4WMbXuPDOkgInfQQ7L0HZ9D8HN3gqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OuUEtaU6C+uVckHqV3oAuehatGq61B8GbE/ww1ZJaSQ=;
 b=d/3bAIP7iSFUEvLk0MFOSdZL5sn6U72tQv4e+kBHupiZQVldtBJ0qlEFnjzdI7EtFicUkttKYcS95rVwXVUJlFqfkTmtyvnPjp2XE6GvZGCp5WFjQz+7icLSDi8v066yKCmkB3d1AEGsT6cbd0d84/4r6hAVpavc8wFTmgG4al7E3gtjaFVL75P8JtL1MNyueBmKLGwR3AVF+r8WkIcz5eE6LQa4beOQ/Ql9tFaEE3CvMqUblMcIiFo8eb7My94B/72GvUN0q4+MAYqS/0by/63BsCIqdrUxgpAwvtsYk7uLpY1gBKcoUHEaGvV+1HWW70/Emx3rrfjMg1bDYDYyXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OuUEtaU6C+uVckHqV3oAuehatGq61B8GbE/ww1ZJaSQ=;
 b=WY9VI1Ww78SWu/mt53PiCf/XDsct3bdWQAWTnCHPyaVG+EaooStescY1I48LnpEmyDM4OWSlHjG7F84ZBwmIby+rMASvWwkd2qZVtcLu8XANN5QNXit3etulbZkU/ESJvU1O0kRiK5C9Y3Kt5vDA8orfUL6armODmx+kDApjx7E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2758.namprd10.prod.outlook.com (2603:10b6:a02:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 00:31:45 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:45 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 10/28] xfsprogs: Check for extent overflow when moving extent from cow to data fork
Date:   Thu, 25 Mar 2021 17:31:13 -0700
Message-Id: <20210326003131.32642-11-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: d3a51ed1-e9d6-4aa7-afd0-08d8efee88fa
X-MS-TrafficTypeDiagnostic: BYAPR10MB2758:
X-Microsoft-Antispam-PRVS: <BYAPR10MB275821EE6A43AEBF2370224A95619@BYAPR10MB2758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:632;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fuMWrfY/In1ndY+5h91Ks0YQOD0Ud/jM+h5v+qXolirW7H3V7q8apw1QaEppo4QpjAXLbFX6mVlN5a6ctmuxNxiFgtN6CFR8uewY2xIV+A8q9N6COAixlWjk/tZ48R+j/YVf56w3dHgqS9CUtzdOW9aB/6CUdMs6CoFmPOUzBlm8wa0SAcvoBMcN2iPfc3x3A6UszNyGsOrxvEsUSug7I9+pha4/IEeOiubGEIdSlKNnW+3a/AhjDxJNggg8SCx1w7lvlkj+W6E0n1uww/hNu2WGDdmnB1posJF3im/TE/1OPphmLyJkVpR+QAwkYyDz/04s8bchQEm6aWzfO1AMfachpp2Kq99r3mhpB0rAyEovnVAsbzdkQZF1UcA4tjc+AFFNoOWO5MzvZz5UYzu6yA0tGEzMXh3mR+jGOXugP/gVocxjUfyJCllvYkoTYqEvIgtEsBsSn547oTsUKZ7LoFOE2Ipko2rWZfHKBBRFATQ7OpyWPmJbnpUsW6i+cm836rhuzQBvxeYy9kx3sZ/Np9TjveuShVzQ/guGxs7fTsyfQ4AxzttdCznPq+/EAnGIe6SVflmkqf2wEv2kETc8hD48sl7Npf8oZCZ51LyRTina1RcAU2aG6wJlBgl4nywRWMn2FrGveiUqnmz26wNHyMdLj5oopJ8U3Y17WTXTtRRejZeh9Ewee3VH55ilguHe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(316002)(6666004)(5660300002)(6486002)(16526019)(478600001)(52116002)(8676002)(186003)(44832011)(1076003)(8936002)(956004)(2616005)(66556008)(38100700001)(6506007)(2906002)(66476007)(86362001)(6916009)(66946007)(26005)(69590400012)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uutMNSQAHG6SLtE586KnaxISyJEL+Pb/3Chb27YywtWBF0YITnFlfrFqJnCM?=
 =?us-ascii?Q?AqjpdPoz3cPDPCVxJGcJ0YZgJrYi1rgtmCVC/6++iBRExvUu896aa8AJs7oG?=
 =?us-ascii?Q?D0hJuu4PNNgs8YyREaX/gPvKEEFw6BTUXYFnnAkcdRaNxUky3BYTrfaGH4jI?=
 =?us-ascii?Q?Ol1jEbyqJg/W+JLlZrXLZiUNX2aDsITwfeYuyBhnRBaSoRYcYKZRUwhrNYWU?=
 =?us-ascii?Q?pR6xIWXhQfowbTQLjosoUDStEYDw8bLbB4QcJ5AVrf03rv1kI9C4Wl00vV1Y?=
 =?us-ascii?Q?e0f892i2wNKRwY/YrW35sbl8prN649vbEF/YrvkfWgE2Y6Auz1l10qdLWyy7?=
 =?us-ascii?Q?1hFldbyf6t6b7nRvle2g4TqhIH1KXCjaQYUhdu7VQy45+Ls5uvOIE3ONyUR8?=
 =?us-ascii?Q?sfEsAF5lyTiAZMOZn8n7onbnSJsCbVC2puS16llj0zTl0iQyut1sEBcUh+x3?=
 =?us-ascii?Q?fbemxxr8+CpDl5UFCYRLeJSVuQ0kWRfXtMw6LtbbkBt55tzaWQ7Wyguj8p5Y?=
 =?us-ascii?Q?D7NTuCfW/1Hjrw7T/QEsEA+QLHpceXIJpDoonBFPZJ0sOL3m30vjmBNhdomP?=
 =?us-ascii?Q?VI0dL/DgqbXCBMyukwXK1qGmKFxzYgpsuVgFQaDHGipvVdcpX7leXamWRytE?=
 =?us-ascii?Q?5avdVV6C+XhZ6FmXupMqtRm1bKVQC1Yt0jzQ90hxnNLDg8ot1jiEhOzuKPOq?=
 =?us-ascii?Q?5tz78MhjawkvwiQ6qQUU94KjDzPMYaZ1g5fk0Ys93eG1fzTDij+2ZReMevy4?=
 =?us-ascii?Q?anetmgIlUTgZSXGBzqAx46u3foMhY3XcMRyzHxAa1k43vUwZuoKR55ufirR+?=
 =?us-ascii?Q?15aZDAaUi8EEN4fUheEkzxCUxP0f2ADvMS24naNTE+rhi5++hGFHFTUWmNKH?=
 =?us-ascii?Q?qn5mSIl20jaxR6TOmPnbYIIgHqUPeDTO1RXuu0ZgJ9QuQ7pJF1i/NSXtcIgS?=
 =?us-ascii?Q?axR/nhDomXVWMW9OK+DRnhIfm12nRyg6u0IhLIZfaVtd1jcNFMNvx9JPLbes?=
 =?us-ascii?Q?6poKlmKl91Nk2GvznOwi+RnJMm8xs/memSa2WGZD48UOZPvJaE7groCG/yEx?=
 =?us-ascii?Q?kJDNb0PdiBWFOmp+GJx56uMaPknhLw0gvir/d9MkjkGP6GNVIVdp170FhhVg?=
 =?us-ascii?Q?6JdsGvOANoAWnPytNyJ93apgrycD935ctPPAjfUhJj+NL7uHcKd41EMvsTVS?=
 =?us-ascii?Q?s5DpmGhknKseur19WCEAyB+p4m6Z0hPD+a1Sqtxj0MK8w8gNv664R2XtAjaw?=
 =?us-ascii?Q?uxFNTj9UHFBUAbxzavidHrZSg2IVT1V1Bh40GeR+COR0ArvekWB59UrYtZEU?=
 =?us-ascii?Q?8cvDmzpUR5TddqR9cmYg/to3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3a51ed1-e9d6-4aa7-afd0-08d8efee88fa
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:45.3893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ly0J7n3LAAbNdgLqzOOaUlxYy5vgKy7gLzAM7nHpR8a7j0bg47gLBkhEqRKJ43vxG+FjmkRetEjoc5AEt90JpVTwQrKdX3wQbr6mFsNmSvc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-ORIG-GUID: JzsmM-zbYUktqBtdUbg1sbqtLNOkS0Ub
X-Proofpoint-GUID: JzsmM-zbYUktqBtdUbg1sbqtLNOkS0Ub
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

Source kernel commit: 5f1d5bbfb2e674052a9fe542f53678978af20770

Moving an extent to data fork can cause a sub-interval of an existing
extent to be unmapped. This will increase extent count by 1. Mapping in
the new extent can increase the extent count by 1 again i.e.
| Old extent | New extent | Old extent |
Hence number of extents increases by 2.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_inode_fork.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 917e289..c8f279e 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -80,6 +80,15 @@ struct xfs_ifork {
 
 
 /*
+ * Moving an extent to data fork can cause a sub-interval of an existing extent
+ * to be unmapped. This will increase extent count by 1. Mapping in the new
+ * extent can increase the extent count by 1 again i.e.
+ * | Old extent | New extent | Old extent |
+ * Hence number of extents increases by 2.
+ */
+#define XFS_IEXT_REFLINK_END_COW_CNT	(2)
+
+/*
  * Fork handling.
  */
 
-- 
2.7.4

