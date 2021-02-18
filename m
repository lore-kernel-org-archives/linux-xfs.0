Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101C2C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5E1E64EB8
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhBRSqe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:46:34 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40954 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbhBRQrC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGT0Bj155629
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=KddXlnfvuJMuYLnDle/fArJYx9iyty/anKKDxkJYTB4=;
 b=C3S9aywU/J+/hB2l9jMyZ8QU3h46jEs1zomCsI8/mrMWb72nmPt9rF6X8HoXdWaD+c9E
 gGKAOWA9sZW+pDrQsMmjMybNqXS57lvHyS+z/2M5OHCpkI+OSFG3mMudtYYUX7D/i2qW
 LybQQcAU7HRUZeHlRJ6Yo/4TpnuHcZXuStq6YabjID8W1ZKV/gqw3Zird0wRjGsFDn/H
 LNXNgh+kID5JZgmUwKg6q2Q+Pn8TDeM3QeSXJwAmzG/Uzs+5G6Iqytj9zSnjqicvKoX/
 eQLR4vrXpTHQMiCXXslj7gs8YiJA9m8hlXs2YNl4bGOUpvwqo02ddoba5dLRXuVijnco Pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36p66r6m4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUCaD032333
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:41 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3030.oracle.com with ESMTP id 36prq0q51j-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/MpUQ7PP2guldjR4eLOYwl68es48aVSvUaIyNO8Wud+ZeoQvqNX+is07xPhhVS8kw/qHLJJnlu18MrVQb+NNt1ZohjYyUW4d2nxg9FvJLHa4sDFDVfX34bHtkyMuhF7hvT/JeDxYTqYt1t9ZsfLXfSzI7tXOjCiy6Y0zOH/nzttq4GKyjcKZgwdmi1m8ucyHk4sNE/8IxEn688bcfkragkU715yHNDtJcsf2gS8Pyzdok2z0GIpS43MWixcJc9kM0NrXNucZNvzu+hEYino/5I6CmQNLJq5DRzEi6BZdj0IYycXLWBZ7kUbEYLJGI36RjF333kMrwexsUMH/ySddA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KddXlnfvuJMuYLnDle/fArJYx9iyty/anKKDxkJYTB4=;
 b=kL89opHlZDjSxQ36I8jpOUIy7ol+hEygvkItFtiTgJmiTRkx3APgRfysA6dRFNDYExz5JJ6XIeuOdzYMXpFIfdDpan7zQ5J+8IMOUnZbKSCw+pYKFb88Mh+G4CIDOIx+ybv419gNXqs3Ck8FOB/TCdU3hPhxAZiqqYyBGpe7pA7aKT/QNx6QaveeVisy+IxT4Rsee0+aX22Fovh2ZasKFlawXfQqi/QWB8Eh+duaCwpQ4IWudKujekOvZ3AvKtnT5h4lZsqoCdfnJa/5CtttGd/fcBhRMmT+FI5FJEWhO0uRPcI9Ylreo1E1PE/mydivokBdxX9ckueeTdiXDocQTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KddXlnfvuJMuYLnDle/fArJYx9iyty/anKKDxkJYTB4=;
 b=k6ZbyclYC8sq42LZ7xL00cOqZhHyqZYE7VIOF6AKs63/nIVPCeIyRJ1smE5tAwnLrusX1ZWLIyYoxAWqkh0zMvmcG7F5c1OFjmv9oDNflB8DNi+QXxzUclKMUuDobm3lfP0qFnxQzrbCtPU6a8HFhC53PnMgRirbNE4dMmIIPuQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4290.namprd10.prod.outlook.com (2603:10b6:a03:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Thu, 18 Feb
 2021 16:45:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:38 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 15/37] xfsprogs: Process allocated extent in a separate function
Date:   Thu, 18 Feb 2021 09:44:50 -0700
Message-Id: <20210218164512.4659-16-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 249c8ecb-5a53-425c-abe9-08d8d42c9ea5
X-MS-TrafficTypeDiagnostic: BY5PR10MB4290:
X-Microsoft-Antispam-PRVS: <BY5PR10MB429063583FEC477A1AB1968B95859@BY5PR10MB4290.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e1RuUlDY7IX5ajb6cR9gW1Wpn5C8lkvBpkXxlpoepPccaR2tG19MzMk4vkLyi8eeLipCTuoQY/F/xwilZrZqGng01lsZxZFU6DQWdloYsFd4dxp6+WqF5/FjAGIDmWWRau238pnDXLm0ESTdebhvQzmn73D9Mai3d9NjJr4QtfpKGr6vJ7yWonjbXw+LxG5MVj0k+Wp+9qUcAs/QYynz7NFJfHF/TUiL1Nq993SWmLLAC0UykeEfFiaAruET+Vqe1NC4nEJEpOZa4zbiCC1peyhmCdLQb5dkEaBnCL9jbo+D0n3JRWCfVwaf2qJj0ocd8P+ryzdbmgzNYCHmrBBaW2JHBwRILgjRwvDAOzWePMpmx/HyQ4ms/OuAQtCAGfhIIoiknkfqkB+MYoEsl/qh/uRZDwWnWBHIt4NgJEb6TNdqBmfCYbYJKXjYXxhXNarAoCynTpmX+2RIXn+okuVlQA7IJPzLh/pD6iie6PG9nao728VDKOiGlB7eRqFvTsprcz+WfcvwAtV5pPEIUIo7R8StMcaxxyb56i0URLECThGIPe5aaORos/szK86Q/Niok3FtwfexVZ58Qdg2IEwV5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(39860400002)(366004)(6512007)(52116002)(6916009)(1076003)(2906002)(316002)(26005)(6666004)(86362001)(8936002)(478600001)(8676002)(44832011)(6506007)(36756003)(66946007)(66476007)(186003)(66556008)(69590400012)(2616005)(5660300002)(83380400001)(956004)(16526019)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?v8HA2cJUurNHUujCbcYeeJr17BP/UHpz7E0Bg/l8oZxQCdzlBeDGsLP1quRe?=
 =?us-ascii?Q?FoTbI1JXXwstj0xVPokXPgXTJMhc5v5SYmTaIwusMZgbzhIBsxSzqNQXLl25?=
 =?us-ascii?Q?ubmFzfEWDzVA+KQJZB/+/WIdKimdrz3FWQKFrE6yfONnSAYX+zh7/c1sjatk?=
 =?us-ascii?Q?tbCAcCdBx6OA/pkKmnqJviBSAe/yv0KCy0Krs9ZWOZYQBFbZqYe0e+MzILeX?=
 =?us-ascii?Q?f7o5p/tWDnQddvOG2YhHB2SOv9xw1PUrvtRHWa4aL23b2TaTMUaiPvDHjo4Z?=
 =?us-ascii?Q?DrP3Qu7PlsfOkVWjTYbR0Ic9gXhucGSRzoeUXEWBXFnTUL6IMn8mNa9cSx+3?=
 =?us-ascii?Q?Xo6U0GorpcBgQ7bBmEOdUXA5gjRcUalP2dXmhEMU/lNKK6BsNs8I99DJMr2+?=
 =?us-ascii?Q?RMiFf02WBNiK69lJXyazzKBUg3xRVqTfmsfAxt7TfIjekHnjXoy39VmZINse?=
 =?us-ascii?Q?FfKCQLTAlDLSJfrfGqZSIiArhQ2RsIWAEvONjp1Md08mQ1njRhLPQa8y733y?=
 =?us-ascii?Q?qQ1OXYm26by33eRCjJwVJFWjLYNELeumZTo73zHuCD6V/C2PSDiKpnO+Uhih?=
 =?us-ascii?Q?5Pb6gJoFmZYK9sknE81TtRmAncUXRjATWXjM+KHtxLnadVaJZoI8EnN564kq?=
 =?us-ascii?Q?VfZdcyewZF2/FEdxU4vJjIA4mkkkMpDp8Km/MF9iMqPC2EMi4I3cGyLImxgc?=
 =?us-ascii?Q?yxgJAX82pkaofR/zX52Ccl5bNJYCq+icnxyI6HuC9Lru+qXwehxBzD8rGPoh?=
 =?us-ascii?Q?eaKNCigXD5cIzavAhVTpbpSWPb/SnNBT8HxK70zTyQz7+M0h3nRkVDWSlUkF?=
 =?us-ascii?Q?v6LhUCkt5OMdb9tZqDPuRm9QGiMKxy8225lN3GiG6sTeH8cmXjWQRTxbtqit?=
 =?us-ascii?Q?cl652iCTudAmfZDpuewqP4cdaRIxpQb+VoptlYjHzS4Mvhf49OGXfWvT41L8?=
 =?us-ascii?Q?WE6bB1P7kQ6tFR9jkYoiSt+HuCtrFeU1r8eG9LW0ySW91GZXoasM2Id6PFg/?=
 =?us-ascii?Q?3vcAM35jP4NY2XsIaSQSJSLz30cichtN58q8xrRl/Zz97hXMA5M/dza2ReG9?=
 =?us-ascii?Q?DMVX3eqwrQNPa1Mtd4kW+Rpt0ocak084WVzbo94wHRR78JtUkOYyZaAtbdUi?=
 =?us-ascii?Q?RYMNju+gjzjhTtd77Q/5KDV9AEDQCEO/6skrbeaHdl0LIcmUOEnfWEmIxSLD?=
 =?us-ascii?Q?cGPay5alxIP2KK9N0HckVQLjEDmCdQYC5H2c4tgy7DRu9LFvHL41c0mbIKTt?=
 =?us-ascii?Q?x5D4TemlEcE2aQAqODIMDxC6dRJN+lAzrn0CQAvqJ53xe9CORekqtEmPNh2g?=
 =?us-ascii?Q?acFR8gqqgNjeZBCMyzqeTGRh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 249c8ecb-5a53-425c-abe9-08d8d42c9ea5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:37.9924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QtGLgoyKD7GP0jkLXU5yT0pMvbcb2nGwCF3C5AJ/04v6FSMRbTm/AJnYz2Tvsh+Q3JJMfMBNZEswREhh43uCuuWzmYmxAinFTKuYnvacRCc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4290
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: 07c72e556299a7fea448912b1330b9ebfd418662

This commit moves over the code in xfs_bmap_btalloc() which is
responsible for processing an allocated extent to a new function. Apart
from xfs_bmap_btalloc(), the new function will be invoked by another
function introduced in a future commit.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_bmap.c | 74 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 29 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 57d6273..6a9485a 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3503,6 +3503,48 @@ xfs_bmap_compute_alignments(
 	return stripe_align;
 }
 
+static void
+xfs_bmap_process_allocated_extent(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	xfs_fileoff_t		orig_offset,
+	xfs_extlen_t		orig_length)
+{
+	int			nullfb;
+
+	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
+
+	/*
+	 * check the allocation happened at the same or higher AG than
+	 * the first block that was allocated.
+	 */
+	ASSERT(nullfb ||
+		XFS_FSB_TO_AGNO(args->mp, ap->tp->t_firstblock) <=
+		XFS_FSB_TO_AGNO(args->mp, args->fsbno));
+
+	ap->blkno = args->fsbno;
+	if (nullfb)
+		ap->tp->t_firstblock = args->fsbno;
+	ap->length = args->len;
+	/*
+	 * If the extent size hint is active, we tried to round the
+	 * caller's allocation request offset down to extsz and the
+	 * length up to another extsz boundary.  If we found a free
+	 * extent we mapped it in starting at this new offset.  If the
+	 * newly mapped space isn't long enough to cover any of the
+	 * range of offsets that was originally requested, move the
+	 * mapping up so that we can fill as much of the caller's
+	 * original request as possible.  Free space is apparently
+	 * very fragmented so we're unlikely to be able to satisfy the
+	 * hints anyway.
+	 */
+	if (ap->length <= orig_length)
+		ap->offset = orig_offset;
+	else if (ap->offset + ap->length < orig_offset + orig_length)
+		ap->offset = orig_offset + orig_length - ap->length;
+	xfs_bmap_btalloc_accounting(ap, args);
+}
+
 STATIC int
 xfs_bmap_btalloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
@@ -3695,36 +3737,10 @@ xfs_bmap_btalloc(
 			return error;
 		ap->tp->t_flags |= XFS_TRANS_LOWMODE;
 	}
+
 	if (args.fsbno != NULLFSBLOCK) {
-		/*
-		 * check the allocation happened at the same or higher AG than
-		 * the first block that was allocated.
-		 */
-		ASSERT(ap->tp->t_firstblock == NULLFSBLOCK ||
-		       XFS_FSB_TO_AGNO(mp, ap->tp->t_firstblock) <=
-		       XFS_FSB_TO_AGNO(mp, args.fsbno));
-
-		ap->blkno = args.fsbno;
-		if (ap->tp->t_firstblock == NULLFSBLOCK)
-			ap->tp->t_firstblock = args.fsbno;
-		ap->length = args.len;
-		/*
-		 * If the extent size hint is active, we tried to round the
-		 * caller's allocation request offset down to extsz and the
-		 * length up to another extsz boundary.  If we found a free
-		 * extent we mapped it in starting at this new offset.  If the
-		 * newly mapped space isn't long enough to cover any of the
-		 * range of offsets that was originally requested, move the
-		 * mapping up so that we can fill as much of the caller's
-		 * original request as possible.  Free space is apparently
-		 * very fragmented so we're unlikely to be able to satisfy the
-		 * hints anyway.
-		 */
-		if (ap->length <= orig_length)
-			ap->offset = orig_offset;
-		else if (ap->offset + ap->length < orig_offset + orig_length)
-			ap->offset = orig_offset + orig_length - ap->length;
-		xfs_bmap_btalloc_accounting(ap, &args);
+		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
+			orig_length);
 	} else {
 		ap->blkno = NULLFSBLOCK;
 		ap->length = 0;
-- 
2.7.4

