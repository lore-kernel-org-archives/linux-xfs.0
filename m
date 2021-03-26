Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF84C433FC
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A86D061A38
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCZAcH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:07 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38524 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbhCZAby (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:54 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0P3RI066476
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=KddXlnfvuJMuYLnDle/fArJYx9iyty/anKKDxkJYTB4=;
 b=jfcqOdCyEHOXWJtaKrmT2ORTbMdUwVYfoa5cCX9BIMExoi+jGJNnm0TjuuyzCVtFjXuf
 4iy3t3noyPivib5Q6Bq+BBy4cgmCosCYsbJZx4beVxvOOFKBvVn1NG45J9K+UWw5U3cN
 S4g6sEFSHe/KaKISenmXjW0lM6knbXupwqMn/QBcA/XGjTJrOSyh6V0FbVibN/+Xogh5
 OHjRfgyNyvpGfE+Vcl7HTyzZlbY5PumUKHkb7bTzHsJS/xPEOniKTrBmoBkLIm+092uZ
 t/G3HGXXOgIZg163CIYwUPNh3cd1+09hDxGSYoH5EmJ+9QktoDNGO6Gzh1PdP6GhZA1i Uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37h13hrh5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PK2d155443
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:52 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3030.oracle.com with ESMTP id 37h13x048e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUvvsknJToiPCqWKaynBkpBb6J9y4LWjUg5hxoipW9+6qEaJ2IxP3lHdY0r/08BuPFAJbXXOrejGkB3ecmA+TURA2NF9nSemStfQEpQR7+7Ak0NEpZHJy26V6MyaVlAJykoe/pbpEXqqapamVA5tZaD8zN/8PBQ0f7Ne+p9T2k+0zfN6bTwGl+HFQFV5KsZ0oIy+QE5Rj5Gy+CD8hycbZCWYz9CFAdki+o++RHSdwrknuMic181k92tXIIsGJx6drNgfg7Af9IgyyQAsb7i8x25ZdRfpzRng0JXX/AyK/Gh/CZO1xtl16b43z9Z/DYA9Cbduw/TfJTvhXTFYthU8zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KddXlnfvuJMuYLnDle/fArJYx9iyty/anKKDxkJYTB4=;
 b=LTgCCllcug0138ybjnxJNdAG5tDRogWDbNID3xrL3CjfZ2pcUZTObg9fA/FcXsB/CiPW4JvuQKMXaCCJt3Vh/gOsGhb1bg/bq49sIfh3vxXP8wHiqjmnSyqOZDAnsRX4QS9tEVab3VwDpEIZqFO+LJMAxMTO+LHH/NoUy5vkl3nzIqaKvEA2ht9y/QOvm1fF+5+JNk8TOfmpYjAmaTr05TILeClLbqSi31pcE1Rr0fYMcYBobR5T39DymqMuoINoj9DvSp59Eq83Lae7UOqTHCgQwnKyewjPGxrGAkPplCFFylZhS/LszsCDYBU+2+yoUhQ7iDEZDRgd97U8FNdqYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KddXlnfvuJMuYLnDle/fArJYx9iyty/anKKDxkJYTB4=;
 b=P8wfTGDP9Gx/uiIadDkAQVlhzYqNPN6RoCwATll/2TseL7mFEP9Iz51Ddv0+xFV9ra4Q+7tuw9qPAdUNDm2fYx4VejThU99wwbN5JgH/1VYoPxmbhI1kP1ZTdE8mEmjNZx8pO0DQEyyVICsWvtTwQ8nrs+M3WlfwftwElPCBLog=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2758.namprd10.prod.outlook.com (2603:10b6:a02:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 00:31:47 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:47 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 15/28] xfsprogs: Process allocated extent in a separate function
Date:   Thu, 25 Mar 2021 17:31:18 -0700
Message-Id: <20210326003131.32642-16-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: fa4ad764-e31e-45a8-5be7-08d8efee8a01
X-MS-TrafficTypeDiagnostic: BYAPR10MB2758:
X-Microsoft-Antispam-PRVS: <BYAPR10MB275800E011A6DD4E32C6465095619@BYAPR10MB2758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UBpuGY6xCyjC2J6pFbFoTfjdJ33kXOfmIbCJ7qb1BD499ANoIwgUa9OWoQEgvVlkshklwVu6veWNBO0gAS5A8BbISiSHdmW+lL31LAcM5rmlArS+QddiIONSZXnxp5FJv5tke1FXFRLk0ZP+1Fi0Wehn5IBdR8MJyZXZS8OdXL1KdF9WrAQjvGllFQZfW+SBPsd8sV147VDonGNoMvBCIibOm8wLvfscRJ+QAs8mYcb2Y0oqWX4ZsMznVRwYjp9NdNzt1VOIR5lUDEUB5Yr7Azam4oV9Iy4p18KLIISDUWx0A+nYFwMYoEPm2SVEnQXKBPsk9KUdhOTuPWyoOxlLmFRxQavs5c8IH2PIvWGSD49J+aEUdUiOICIy5cEe9W4kPyY6/LVbEw1jT13xhsDEnV4NCayDOEY9fjK96VuFdrrd67SAwj8EVypnNTB94jK0Q6tagw/dKsPZta2k0H2etVRy5s+XBVyv0jz5QSbk9E1VxV6oNynX12EF7iadb/ruxm0xYCO8hIDGgrKuMpJ63VEWb/b8xDaDoeqXFty9sAuMlJnVgKPoU+DO22dutZ7SoDvPJ7dKuCi6zCo45DYmDJArggPg9bQBHgN1NhTjCgJ37W+/UXR+Z/7+yEQdYCfQDk4GDDUcz5Z96EJz72IY4Kay9V+a17SivquM2gIJzbKbZ4IZnr2z8Fu2/V8Dovqy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(316002)(6666004)(5660300002)(6486002)(16526019)(478600001)(52116002)(8676002)(186003)(44832011)(1076003)(8936002)(956004)(2616005)(66556008)(38100700001)(83380400001)(6506007)(2906002)(66476007)(86362001)(6916009)(66946007)(26005)(69590400012)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3yXFVp13S6RI0gkuhf/DZRXJtAfRnC8t5t9JUPibFpKNM3l3+ts89Gm+VfZ9?=
 =?us-ascii?Q?OlDdhEjF8s8MW4ny9kQmBTd6djpVfJRsESXTtJB5brYRy95tadtMLk9meOeM?=
 =?us-ascii?Q?yskYr5NKSKa4z6F+zqVO2+6rjpDeHgRMZZnBaf7PyEZyjRDhOxQFYr+Cg+zs?=
 =?us-ascii?Q?i+Vnva8YQJ7lmhs0bSUsIbZRaPCrqQAqZFktPxVej+gMmjvF2wTaQjqeb3l0?=
 =?us-ascii?Q?BLv0fLeEkNYSYgCr2AfZ2d6UhMJLscWEBd60K2oGnibD3Hqj6+TStCQht49Q?=
 =?us-ascii?Q?Wm3td48gmv7k9NZ8GfE600EzPgB6YSmXR0TcFmS4nDu+nvJw+dkHImzA4EyC?=
 =?us-ascii?Q?kQxnOC/i2gqxPgL5XIJYB5NmQcf9JuaKqw3QyEpJTs9e66IIb/qtwqa0paxW?=
 =?us-ascii?Q?+vf4PmqApphgZBFfFMTZ0Ia4T1gKPWsRGtxzJ6dZfMuwyCDQhJe+X54KKCsI?=
 =?us-ascii?Q?W0dQq+6WqEZgdf4l+HNIRuqK58HJcR8z6y+HXa7j+LaqWc7yRkBiM2x71WcS?=
 =?us-ascii?Q?y7Q790d/VXG+NBYzp2hCEKm0044UEvzMQ7Weh6eWWx+595j0s/iqSeL5zB0r?=
 =?us-ascii?Q?9M1p5bgBjqq7TIBvpnkTY/TypZpSaRMmtED1c1LgdXlNo+nDiKQrbv6PBmhy?=
 =?us-ascii?Q?b57NaDExUnjoT+RbT842AOdMrTC01UUM3RdwXyfnB1m/F20S92HnLZ76PoYe?=
 =?us-ascii?Q?RKCeD6/xDdS2kECiUTMzEr2x0A6eqzAktQJpWpqx/ytPopH5NPAXDwNFvUWD?=
 =?us-ascii?Q?7WVD+cwHuFzp56IxCwdkkkWsFFsByKQ+28KBY6CkyyHfPSy0L+94Z+0YDml9?=
 =?us-ascii?Q?TKxwdp44+xmNAWa/mXlMVbySd8ZLZNN2y05dPQYsZqmB6AVqCDftuSb14tMs?=
 =?us-ascii?Q?WA6PI+iBd2pt0K/PchuVSz6aIpgRxC0s1tFaOnMFs3Iw7NJJ0dI8+fskT0lj?=
 =?us-ascii?Q?b1O6w8Xt7AwKT45jtR4hzyTgZbso+kg4EedTtB6DKh3WTEfS84TDT0JcQi7c?=
 =?us-ascii?Q?TsOpbVYZPKDls4xs6ZUJnb71HRQFiWtl8y3dissCeVykBYQyBGDvDrxqVZOC?=
 =?us-ascii?Q?TH1Jc+i6QAdP6NGwhuDgR0EkNcuh09yhUwsVFBdZOKvSrE0HiJAQDMd/EDlq?=
 =?us-ascii?Q?KfwuoIiTV3RwJ4qGEJu2mGTtnr15o066iRjBp5QSk5iKbnvECWOzizCtIAsh?=
 =?us-ascii?Q?fJ+IFL9SnfAz3tg2yJTa4t9IMrBWiDeNy2XBFfyGU38+absyk/Rzgfm55zTc?=
 =?us-ascii?Q?fREvsLijobvp3CPCRc6de4WzKfjkDBkEcANqcZNR+UJu/2msYU17qZzy3Tvs?=
 =?us-ascii?Q?LzbgwviA6BRL1XeHskIATh8H?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa4ad764-e31e-45a8-5be7-08d8efee8a01
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:47.1088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /K12rhnIVxfpt+laPnpmtOikC5bd6vUmw6vexKGGKzFO4B5nWDMvtWguH/+R5sEM82aDZaiwGRAjz2r0N9OUQg0SRKhEsuShTYrDHKaNaIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-GUID: Wo4JNsl4H7VKzE3VLG8iSEL1QYMedE0b
X-Proofpoint-ORIG-GUID: Wo4JNsl4H7VKzE3VLG8iSEL1QYMedE0b
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

