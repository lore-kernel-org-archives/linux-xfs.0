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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C2BC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D446E64EB8
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbhBRSqK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:46:10 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60450 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbhBRQrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:01 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGURpH059508
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=8R9jBhTWQIxrQfGEbl2EVctMSu3cDYXQeK81xnE+K4o=;
 b=qTpAOTuc7ZbxTgtAUwzrNzZNl1XffXrb31JlaPZ02eo7SAZ5waPwHaqV3XqP6hNduGny
 h0PUFNbg8D7D14qiHsjKvCmTHdaX1hth47xFaBO1rd44WmvgUUOD4+P9qX7WCFRP2EcM
 TEprcORXqqsWIDck/CXD1o23wT2u/T0yG5Vk4GxmNSS/L0R1huCGiJUJ7cE9LGbcSRA7
 hp3Mw3hbvCk7zoBbyyEoL4ZvL+shmTPDAKqyaytVC94f6MfVNtxk/fGsSqpzP7BlfgGw
 O+DloKQrJW2uZXvuc5/sSk7Pvejrx2x1muHcFFC1LzUaLHUCc6AT1ywtWfobRjeuN745 Mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36p49bersr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUCaC032333
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3030.oracle.com with ESMTP id 36prq0q51j-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLBCjM/ofmmUiFick1ax+TBs+jLKuZS9eniM+S8R303g1tWJmVkd0j0zntje/Kvk2Kzvpjb+6EFhnXgly9TL0D7x20tKzvD0/O2w+BvTsV5CsX9xBSR5jWxq8GkL+2g9iCBFI/fwiw+HnHRWjfOUNrzq3DkWqpwjD+rLYY/eexrvuCX0VUB976HfOD2mMFilBJ8RrGD5LY3bGOOxfZHWBy/ygL+CBGLbhERCgzAwfR6egT1nxPFEBYVhQXmgUVYn3z2PjHf5NPi6AO2Zh9l0Nut60eFyx25++seLwO1S0LslanReb0XnHSGWTGVnmtBUW7E1+9FvJdERKH9PBAjpnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8R9jBhTWQIxrQfGEbl2EVctMSu3cDYXQeK81xnE+K4o=;
 b=dN3uMS+feAaSzdJ0KBqs9Z/nmiK2yvY/Dbbv6D3j8yD1CNkuQZRhrg4+Vt3d8G3H/FFrNT74ci04RMNlW/lLEcGdAPPIHBrkDcVr+mptZMvohlG+w+dIpZUXQT7S5aMfmmb8auLc50UYwSDh2ULQWBwR2tQKisj+gapLOeycPOdxix0ii01PGpz2p3KA0xpaWjwLulEYarIz7LnntnWuYoolUxVGQmxdRTj3KR0kwaO2dsBftoV7w5vO6O70Xp+8QCAV2DB6YrnzlPhz1WhNRbOIQuNMl1LsxHM4ez8MG79zXotji9P5heO4MMIAgy8OdMmmg/Z19S0Jq8X+Bd5yzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8R9jBhTWQIxrQfGEbl2EVctMSu3cDYXQeK81xnE+K4o=;
 b=CLyrM4yqBYsF0H2JTxAqgHSDalHdTgFcK8HL7cs3BAczXMFY1qvImylu4agbGxrherq0tzJEdLm8/UHDNwUTicUIY7z6+o9KARbUVW/xJ+Cl2VWlWLX7ilzaYPjqg/4YAdLZql4YeAIIOno1yzCqDFmk1Pm68q8GyfAqfPxf8wc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4290.namprd10.prod.outlook.com (2603:10b6:a03:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Thu, 18 Feb
 2021 16:45:37 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:37 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 14/37] xfsprogs: Compute bmap extent alignments in a separate function
Date:   Thu, 18 Feb 2021 09:44:49 -0700
Message-Id: <20210218164512.4659-15-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: ea18f914-e22c-4f24-927d-08d8d42c9e5e
X-MS-TrafficTypeDiagnostic: BY5PR10MB4290:
X-Microsoft-Antispam-PRVS: <BY5PR10MB429040570FC3873F279E5F5E95859@BY5PR10MB4290.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:499;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UfIXi6q+h+qI1BjDS/y0QRaEfPmk3ygqkBVJy2SXXLiuf89x8fsCUHQ0lmFJBEySS6vMRL0m2zZFOts9bNBbbmtUsBEnrmrLMJjGIvgWCrMTLKl0kKvJhMN+/RGCsaB5kPEIWFBI1cqcQq2ahCOxx45RpIJivUwdjxg0JC3Xo/lvEbkyDzx9WhapP0Pw3eQ85ecbGDKPpEY+qwJwNaB3pFiD/+6B3pvyAXB1gSrzMbaKQytSTEP/bhaLHkmJkWJcAse1AE2oPKPh+CfLQGGCZ42YsjdTrCyDpD1ztd5QUlBNIjAjLUb/7aZgKGXgBrLxXxscM4zJRstdDvqlitsVbOgKEQteyJB3Cep9a/UeDp6KVlIrnVA8BTw5rXRGSkoN8Z6KQU1P526cRLsvi76xjbUkTSPFjuZgHYdYkYskeVKnHRysfrPqnr3cn+0yC2vZQKmYdGjTJE/hXhTAeaZtLfyvQ1FP273avXUtSOxvvTav8O/DiwiXHUHOzrabrk9frjtQfE7Pr1WkenDJurNIXfCzNrBigizIhvehAw6NVvIE7Nwsdu6I0It+HDWKF6MTsgqioHQ7s19kr+xS8t4TNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(39860400002)(366004)(6512007)(52116002)(6916009)(1076003)(2906002)(316002)(26005)(6666004)(86362001)(8936002)(478600001)(8676002)(44832011)(6506007)(36756003)(66946007)(66476007)(186003)(66556008)(69590400012)(2616005)(5660300002)(83380400001)(956004)(16526019)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?AUvXNacv46B6kE9tf1OHr+kF/8xI2xKZJY80TWI/mPDezNTft62bghsJJUs6?=
 =?us-ascii?Q?GBpt9h4T8+nGjinvk7GfnfRUzmb5WymI0gz/glaBMwYvarGmSoKVwmuO7vng?=
 =?us-ascii?Q?bDN3QRhkwBV3Fd/JjVgPc6h4iWY0oJ7vsVN7TtiNmGOjJ0W870XAjeKaPkKm?=
 =?us-ascii?Q?91QFkLAxT4tmR7gBZ84Uy9mVlTgzEV3eoTW9CAm66qYiG8HjjKzLwBbaHj7y?=
 =?us-ascii?Q?AyVMQAT6XhplG9xuI6WeIGktobwn+NoT50OecYzz3z5coQf4ZJ2tSt5HGx0y?=
 =?us-ascii?Q?3+5TiAeRkiIaL7uAGo+cKBTccDY4ZHneic1W/WDXYwqqawpdrs3YwZ9WhOnu?=
 =?us-ascii?Q?I5rfxPcIeGMjumUKNakBXXrsvmGfKUuMnuLsFb0KGKY3rmjp6lGHzOLfm1mh?=
 =?us-ascii?Q?dM1RkPhgYRGciAtTQ6bM2/JXDule4Tec7ouuvnOcMsRpg5gfjL0jg3Pv03fO?=
 =?us-ascii?Q?qMWpSjltLYK/LPsqMUVcRwhE0dZxUrj/TDRUPUFkx6zBQOUnprvMk/zVgUNE?=
 =?us-ascii?Q?piwCt8WR+ODShxancKe8SXgIdLXM7q7lb9cvRRAJHNTVSnYp0ufZWpbQfesd?=
 =?us-ascii?Q?q2NOdwjGx/C8GsWSCpHvVpA4RRaARnJoabu6STnkXjiufGjaAoW4FJyc5gIs?=
 =?us-ascii?Q?SVnccimmChN0KPKzmfbmmS9S0FXxDggzRKpqcyh3Um0IMQDhf9I6O0ZjU7Cg?=
 =?us-ascii?Q?C0CCjjitV7vYJHC2bIp/CYGYNvJJrE/VGmYxSy8cWw5KF3sxscWbHfAsCney?=
 =?us-ascii?Q?UQguNrzMIGZTVDMV/70YLu3S1I+FxlfHwvpJXL6M4iYvMai9sYgZpJ5q9Jhn?=
 =?us-ascii?Q?4nVDGCiaAu+tQutdz1WtDQRfstvKIKtNGUvrgRU5YQmflRq++VcKaWtllvwU?=
 =?us-ascii?Q?R2jc17I9Qt4qmxz7dYcDrF0VnfKmZjqEUI1Nozrl96A43ZTxAQgx/1NSyN16?=
 =?us-ascii?Q?FIHcOj9XMNICBfTBqXa4flgp0CVq6Zn77GvK6m5O9LIbg1coOf2VL7Mj8QtD?=
 =?us-ascii?Q?EQ/MpHdH7PoTT/PFOsZQ0MNUiM3m774PX+ySlxVpDOesIU3Glk8w/9Hm5ya+?=
 =?us-ascii?Q?tb8ayk/C6VKV8n7086dJMSFDrxrELebjAHR5lKa5t4F85ejRe/hk/4BT7i8J?=
 =?us-ascii?Q?avetmO1Hp3NOaey1dFzOUQp4yMuY8SCLPHC2JNazTauuFjM/o3ex0VpubZUy?=
 =?us-ascii?Q?fynvlopGRB35R5rvGTbfMo3RjbGAys3RjyqNts8K/5PskPNYWiscJWN8K8RW?=
 =?us-ascii?Q?3/NFVSkbb4/6JZWBSbgfDmI4sSIKrrs52oKVaQQtYNi0L/4h9qrxpK0T4u3n?=
 =?us-ascii?Q?qG6cH4FsCunSi3uzKC9RiOzG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea18f914-e22c-4f24-927d-08d8d42c9e5e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:37.5335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SYQv5I4en5NWI6ViAt+6iyNSD8nIFcv9bnwcP3dqLwqn/UA3n82jWRYMJYJ+tdK3x7ABUbIRO74Ftk3njdf1Y8M41lPSEwXsJ42E+CvW2r4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4290
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

