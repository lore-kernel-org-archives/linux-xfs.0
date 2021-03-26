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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F14C433EC
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2EC361A01
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhCZAcE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58114 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbhCZAbw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0Q4VS111907
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=8R9jBhTWQIxrQfGEbl2EVctMSu3cDYXQeK81xnE+K4o=;
 b=Nq12pAdDg7PV2LvGhc1vgcG1VJ6I4nJzGIXn2NxfbBNT3HN08DXo3bmVciW47Jnuu0Nb
 2kh+zdg/pdFWKbE7O0Z3geJb5oDqmlvxVLFkdhlFXDY5MAr89TVqj8OY4w6CCN9Tiub+
 R1R5K5cbbjRr5TYARiFa15OSrsCYo90+MVvNCd8EnIYNW2Y+FYS9u/FHsyAvujbcAGvc
 9pPdZg82QjNIDPe6jQJiMdcr+/apbBF4H3M9eTPwYLRCtdeN8zufzwc38ARhVVmFohpt
 XPNp4IB8I5Yq/LNLYaSjtMstPh2nx7W86mF4l2mba/o6vETVBZZY9nqTpZDgaR/FqEzD xQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37h1420h6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PK6W155451
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:51 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 37h13x0454-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3WVZrtO7FgBZucxmN2kZvX+pFyUK6TTuMjbxr1VpTRaDswplFsWCUlTtQ/M4s6g8VLFx5vT4Favq8pFEO3tjyQ8N/7clcblk5O/dvj1HmGI89RuoXy6yQFBOSve0NyRedyXYn2GfN/G9pllOyfWvxodT8KvD0tsXyJDAv+2RETmQcBvRUkDwLZsa8K6wd0yEwMo+IZWDotISpmVyIvjziuehNhrGjkUqL73INJ+xo+f36a/l27pBYf1xgCo/hgaeOIaDEYv0gjgmOjvJ57B/V9QgYs1mewOnCzS98nacCI0N2dBfXlVyEuWQR33uC0xcV3r0PAAOxolD0cUAcw0ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8R9jBhTWQIxrQfGEbl2EVctMSu3cDYXQeK81xnE+K4o=;
 b=WW3G66bnRZ7Z3Sjzv1cRZjGiXN0eeIeOKuF/KKORFTFGKSgGHKoBS7WQIFX1uoDw4Sh9JeURzzHB45/0aLr0e5/OODZxkwpP5o3jDdkfhHu8VLNl2H8nhdmSE9e75CcSr9zKFPNfSze+dyiTtelB6Nm3S4GmDmE3O7UPSwAMmEBH1SuooAdwTZkOKlWem8Hx5SYSREuCLm04yGbspxT5BLq28jISSsEdtFeyu21jM3+JqgnBDBXlB242wpAtdEUX3EWZTHNpuzMETwynDjYTFkXowK6eJVPv0Zx7DYs0IleGJzhbqNQmUK5RSHO6xM9ypsANTnvP62iYzSDsQmoG3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8R9jBhTWQIxrQfGEbl2EVctMSu3cDYXQeK81xnE+K4o=;
 b=jeojz1lAo8c4kqfDF7VZOgDfaxciyvAHZMhoqGDv8uYEH9MMpFmFy/9VzkPm7f+Zp5bCcCnfJ+zZA5LI9lp9Z2UkTrTaWW14cKOp6ORkqTRSSmvuQrV1Ser/dNzdembG0Yh9c3RGHmR3jEBNnd+gGLtHeGKRylLX+jAD+j/nKhc=
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
Subject: [PATCH v16 14/28] xfsprogs: Compute bmap extent alignments in a separate function
Date:   Thu, 25 Mar 2021 17:31:17 -0700
Message-Id: <20210326003131.32642-15-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c74fa1d-3117-4f87-5a0a-08d8efee89d1
X-MS-TrafficTypeDiagnostic: BYAPR10MB2758:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2758D014D0B49D1C49C29BC795619@BYAPR10MB2758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:499;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tLN528gbta0TPxy7wXmOEYW83x2Gow4uZof9d49bOYtOCV4+0ZwxVAH8NJIhtE7P+I+VkElBjIoR7IcCXQcwjOFGSwo9CMaVGXZT9KL8Se9MT0ul9T2V8+0oVjkIJFg9KrylqdVmWajG7Fi2+9CF2QXx5aH9EcCRwpuofugkQKqwfbUSsqoQYXgz5Gco3zaZWCrlmaw2yvLgj3Cl3mHBqO+RtpARWSpCyWigN8bf57lNWU/8QUN+XTb78MEntcwZaSNIn+zq+CxgEnPGZ4PqUI4belpStim0Jk0LQUR6FAqaZ2XR0W9RcKtLkyAWWUn0OTA6b6BAdo7K7HQXqL091LP+G1mR7aHATzp8WOH/2vrLT6qesRCGc/Jp7V9mER1JnjjmDTjAirLDoB06/o81P7H5sLL1JX5gwQ6g/Cd+oBCC5nfwopafL7RSk1tUBFnv3OcLCNG+mUk+ykGi3PleAVSGAZyrX3+HeNhf7ckQ/JFIs2pu3ujQdHpZWS0lze1WFdFfeblSPhtRY+h37NThHde0wxpjpbYhKHkMLS1LqNWEp9FmC5NTA7/Jc0UeE7g0DmoQETChSpxWCV4Bc60R39bzoJ8h+lciymdvyAZqgC2jOepp+D6QapsFpvs4wuKVpkyibvbu2sxBbSyHjmpP9IXIJNSEV28UjO+HgWMg2C2AJviIJNRTIyECGre1Zb48
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(316002)(6666004)(5660300002)(6486002)(16526019)(478600001)(52116002)(8676002)(186003)(44832011)(1076003)(8936002)(956004)(2616005)(66556008)(38100700001)(83380400001)(6506007)(2906002)(66476007)(86362001)(6916009)(66946007)(26005)(69590400012)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KHLZv0/IzzEB6E98UC88wy8kHy8XpJxiyQO70itKOj+svw/dvgdp65BUzvSh?=
 =?us-ascii?Q?+CgNsBhEhO/5ZQHrTJ+6yz491jn6d23zhHQsE+iCYml/QhN/ztso00e6NBK6?=
 =?us-ascii?Q?FzdA/WcIgtTxmSNSHttd+MXT4VVXhq3uqH+kpZJ5Alb5PXdliHxcZnvcmrso?=
 =?us-ascii?Q?gGJgK18YWjRabPjUlY2kYSaGTxHyqDZt/teGtjUeKnArqC6cBkNcu97L4iz2?=
 =?us-ascii?Q?43fbWpwoHCWbQGUVY82TN08ld575CQK8S7+k7z+jwYUUotj3nt82DWZZhN7u?=
 =?us-ascii?Q?9g2lakEYRpVVPtAfrefbweVg4cq7wXR/YZcfSY8TWWnRzoW6kRBvc3DyOCso?=
 =?us-ascii?Q?hun5LgOMFbhIdJjlPXK1VqowZpC740M/yAtMPt9ACcVggpjcO/rbnlRKL9hy?=
 =?us-ascii?Q?QaxVhQX9TT7mMwtI2pbDViVrgbXal/jwUlNOsce4xQ52hAfn3dRLgBe9p5Jo?=
 =?us-ascii?Q?c30hv2iuPSCmQpHTDgyU7P6lKu8fW1HCxYRkHupjVJssPBl1LQ+BBZfzdjWO?=
 =?us-ascii?Q?g/jUcn6MkVxvmprwv+v2IkAdGkOISUEo8tlcI6iQIt+t5Hs5a9mpLCBexaPc?=
 =?us-ascii?Q?wB5uFF96wL/Rk7K3e7+vsKupnHHaaT1sMLrXGfNFEXHNDHnYZt5B9f7rvn2n?=
 =?us-ascii?Q?jcGeYde1LZ3WN/wRZwhNbF2YtEY3OkA9RHH5XuDpre/p23UjYFNV0WhINp7V?=
 =?us-ascii?Q?6DZm7cGyNsGO55OVZaSLKI7ecXCFOwYQ71C7tvtPyWnWrpq6nDjwgrbZsv+K?=
 =?us-ascii?Q?3OlLsB7nyCy+aExinycADj9VIHqK2PBwiur9GIzkcHO/STb5+LsDee+d9C1I?=
 =?us-ascii?Q?a8WVyWYpwm7bQkBgtfn0UeYZ62P/FsoQClK2ehFM2vIlqMLq1ymagCCuETaw?=
 =?us-ascii?Q?MdSx3yoCXSfZFmiudI3pnmY1VWkAkkeguaMPIAc6nSoQs+wLj2UNsU37PZ7C?=
 =?us-ascii?Q?knHn1JT1MTK1SJn+6rbSOKzmXEPLC2TsEvIkHS+PKS0bp7xxwcl9tdMg1/Ky?=
 =?us-ascii?Q?PmzNaRp1H4/M6OsLxqvikUEErGY06DMExP7jokzHHFZZb6tNXZtiHMAgSX+W?=
 =?us-ascii?Q?bA9hF8ansjSgvdITuPEulO7HpTb3MR8VsL17Ntw4WBV8bbY/pEqd78xPmHzT?=
 =?us-ascii?Q?o2HonGy2oM5lDqnJzUslBhrGuTHTdSQqNpN2/duiZ3AEDjZHW0+z+L3+yztU?=
 =?us-ascii?Q?+uswOdl9gbfhlCHnHWMxsbMpAWqV+u6ZrpPCfNjIzHx0gEnackwDRLb+3qmZ?=
 =?us-ascii?Q?NlSUWkzI5rkMQ8FfvISyRCj9JPOALdTXYKC1kEs7VhhaCXLU6qLFV01YXJqc?=
 =?us-ascii?Q?OvJUMmpOvenUj2Ialbk7OzVx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c74fa1d-3117-4f87-5a0a-08d8efee89d1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:46.7673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7SCLC6G8jlxyueaxcbfu+gPRc6Fr5/uBlklugqLXMpArdQYBxKG0Ev1nxNo9PiG9HizpLwdwaUGJbBkCr3HKQe4YcjZ8oTXGlYrc7i0k1Ks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-GUID: 8ELXxup7jr_7qN-1TcJcqSiJ0nYCLXFK
X-Proofpoint-ORIG-GUID: 8ELXxup7jr_7qN-1TcJcqSiJ0nYCLXFK
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: 0961fddfdd3f8ccd6302af2e7718abbaf18c9fff

This commit moves over the code which computes stripe alignment and
extent size hint alignment into a separate function. Apart from
xfs_bmap_btalloc(), the new function will be used by another function
introduced in a future commit.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_bmap.c | 89 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 52 insertions(+), 37 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 836e5a5..57d6273 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3456,13 +3456,59 @@ xfs_bmap_btalloc_accounting(
 		args->len);
 }
 
+static int
+xfs_bmap_compute_alignments(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args)
+{
+	struct xfs_mount	*mp = args->mp;
+	xfs_extlen_t		align = 0; /* minimum allocation alignment */
+	int			stripe_align = 0;
+	int			error;
+
+	/* stripe alignment for allocation is determined by mount parameters */
+	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
+		stripe_align = mp->m_swidth;
+	else if (mp->m_dalign)
+		stripe_align = mp->m_dalign;
+
+	if (ap->flags & XFS_BMAPI_COWFORK)
+		align = xfs_get_cowextsz_hint(ap->ip);
+	else if (ap->datatype & XFS_ALLOC_USERDATA)
+		align = xfs_get_extsz_hint(ap->ip);
+	if (align) {
+		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
+						align, 0, ap->eof, 0, ap->conv,
+						&ap->offset, &ap->length);
+		ASSERT(!error);
+		ASSERT(ap->length);
+	}
+
+	/* apply extent size hints if obtained earlier */
+	if (align) {
+		args->prod = align;
+		div_u64_rem(ap->offset, args->prod, &args->mod);
+		if (args->mod)
+			args->mod = args->prod - args->mod;
+	} else if (mp->m_sb.sb_blocksize >= PAGE_SIZE) {
+		args->prod = 1;
+		args->mod = 0;
+	} else {
+		args->prod = PAGE_SIZE >> mp->m_sb.sb_blocklog;
+		div_u64_rem(ap->offset, args->prod, &args->mod);
+		if (args->mod)
+			args->mod = args->prod - args->mod;
+	}
+
+	return stripe_align;
+}
+
 STATIC int
 xfs_bmap_btalloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
 	xfs_mount_t	*mp;		/* mount point structure */
 	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
-	xfs_extlen_t	align = 0;	/* minimum allocation alignment */
 	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
 	xfs_agnumber_t	ag;
 	xfs_alloc_arg_t	args;
@@ -3482,25 +3528,11 @@ xfs_bmap_btalloc(
 
 	mp = ap->ip->i_mount;
 
-	/* stripe alignment for allocation is determined by mount parameters */
-	stripe_align = 0;
-	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
-		stripe_align = mp->m_swidth;
-	else if (mp->m_dalign)
-		stripe_align = mp->m_dalign;
-
-	if (ap->flags & XFS_BMAPI_COWFORK)
-		align = xfs_get_cowextsz_hint(ap->ip);
-	else if (ap->datatype & XFS_ALLOC_USERDATA)
-		align = xfs_get_extsz_hint(ap->ip);
-	if (align) {
-		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
-						align, 0, ap->eof, 0, ap->conv,
-						&ap->offset, &ap->length);
-		ASSERT(!error);
-		ASSERT(ap->length);
-	}
+	memset(&args, 0, sizeof(args));
+	args.tp = ap->tp;
+	args.mp = mp;
 
+	stripe_align = xfs_bmap_compute_alignments(ap, &args);
 
 	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
 	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
@@ -3531,9 +3563,6 @@ xfs_bmap_btalloc(
 	 * Normal allocation, done through xfs_alloc_vextent.
 	 */
 	tryagain = isaligned = 0;
-	memset(&args, 0, sizeof(args));
-	args.tp = ap->tp;
-	args.mp = mp;
 	args.fsbno = ap->blkno;
 	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
 
@@ -3564,21 +3593,7 @@ xfs_bmap_btalloc(
 		args.total = ap->total;
 		args.minlen = ap->minlen;
 	}
-	/* apply extent size hints if obtained earlier */
-	if (align) {
-		args.prod = align;
-		div_u64_rem(ap->offset, args.prod, &args.mod);
-		if (args.mod)
-			args.mod = args.prod - args.mod;
-	} else if (mp->m_sb.sb_blocksize >= PAGE_SIZE) {
-		args.prod = 1;
-		args.mod = 0;
-	} else {
-		args.prod = PAGE_SIZE >> mp->m_sb.sb_blocklog;
-		div_u64_rem(ap->offset, args.prod, &args.mod);
-		if (args.mod)
-			args.mod = args.prod - args.mod;
-	}
+
 	/*
 	 * If we are not low on available data blocks, and the underlying
 	 * logical volume manager is a stripe, and the file offset is zero then
-- 
2.7.4

