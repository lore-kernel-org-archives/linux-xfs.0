Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EDEC54EE9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 12:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiITMut (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 08:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbiITMuo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 08:50:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EC26583D
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 05:50:37 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAP0YP011935;
        Tue, 20 Sep 2022 12:50:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=1ag9RncpoVcywSr9KbfiCpt9Byd+/I1IVd3bbnoAnAs=;
 b=TdUwmvjYDpn4UQzMLW3piw3rG/aMVyfWRIzUaHrfvit02GlVz7jor3uQlYcjHvxmS2K3
 rtOQYO8jdBd84O9j6RiTxStHs0MRgQO4xUhnYkOHFm2/ARsDq6Iw9PECuDDIRBg7uymk
 JjyL1qzRQfcp95+z7YNjMjD0+Xcz/kUZkrwEOChbdUgPR6uPPUjfNN5BIziUB+y1tR4L
 iyZ/ld8rsAJeUfzVnKmWfYHFBiNsiskRuMCwnwHk5wogWtlcthjiGWdFpnx9vNo+DrSx
 VWDNQ+8nZds7GuSvASAaJwYWWwaPjCJeNS1Yv432Vw56rLQ03X4awruglNkPLd2zsGhW Ig== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68m6t0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:50:33 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28KArnwd022923;
        Tue, 20 Sep 2022 12:50:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39qh32a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:50:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PtyALz6yCQbqwoiVM7x870KUcBn2+sZBu3Ek9rxJ2xECp5vc1PTnfjjKzE1ikV5UvjuMq2dYGzRKudzajriljbxrZzUHRBkiVGWnndvsZNMUwhCxIiXLmrvVFIWOsshhzE2BPF45sHcpzeKNwR6PwezpllfluLnebQCkOgNDdmWXLsyqx0UYBXYish8NSqKXSQgse7L3FKzonLSHDrgTapkqbVcaejteC+oQ/FCtTOxUft8LTjLbLitDzDGFytbDXe1sJI2qfHHn+gsEqXfGKqhqdTo+hKtHR2/gybYq8wdXyrpOAc0u63Dncf9GOLOSSXQeu2f0GkkTEO7uvpqFYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ag9RncpoVcywSr9KbfiCpt9Byd+/I1IVd3bbnoAnAs=;
 b=Tu1NJKDNvlSgMy3s7CHUsft62TaQ1+OZUt61FTKLgPi6C6RkBnpXVPM2FXuejqJyjIJi0LiokwRSHpu646ooTlw9CMYQEh9IoX51Ufi7DE40kYrifWFuIlkQc7PlqSQtmTVi6T5Mb/OR3zAeExYImx1bBDfz+cnf11zFTh+6pd4pLL4mx/7+O/1ADkgpX8+Qu14Aj/ICKf2RhuTM+s8KMionbrET6EbpZnvERXEFYB1hc5NFbGCu1gYe9laFVRY37Gom+yPHTEGUK6bgaOALpuzpPRsrnHmNESCsX8TCjPZQvRs1JOVWnSpjCO6pU6/Ediqel7TmX8r9MPOEOeufGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ag9RncpoVcywSr9KbfiCpt9Byd+/I1IVd3bbnoAnAs=;
 b=GsPaR0Q1oonFThgLs64h/UEP25zPD60hIeIC1D2Cp1+TYgs57xT2dxuRIF9QmNVAgqIClvFFK8I17oVpm279byIESLzgGy50dYlEKfHH230q9f9AdVV57NaEkZVPGVt/Nv5FdLCvn8kzbGglm/JcbzU+4xFlvhCtZ3MjlUEy6QM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SJ0PR10MB6304.namprd10.prod.outlook.com (2603:10b6:a03:478::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 12:50:30 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 12:50:30 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE V2 16/17] xfs: split the sunit parameter update into two parts
Date:   Tue, 20 Sep 2022 18:18:35 +0530
Message-Id: <20220920124836.1914918-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920124836.1914918-1-chandan.babu@oracle.com>
References: <20220920124836.1914918-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0070.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31a::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ0PR10MB6304:EE_
X-MS-Office365-Filtering-Correlation-Id: 79d7b8f8-dbe1-4c91-e809-08da9b06b338
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S9stgX1sI8KOFL8A8SD/dUnBCTWMf8XGAElCG22Ub0GsbDrJC45zekjXColU59EqV6YSJI+rR1SlaWFcUEY4kyB1eFHBS4oeGiGnD9e2vPWP20KJT1KDJ3TUakzq0ZTQtO9umNk3w169lSIYhEZw/NyTppmsEygTCd4gxLSgP2YY1CMF1ZC5WNdRlGJspDZ5/b3OCfHmFW1ObmiT1X5rFdPbTmg0UlIS+3JNe6Y3fHFXmFhBFZgdIAMQ2v93zlK2c1OyMKdqVdVmWa8a84/2NGfcRcstaSBhvrgScVJs89Hyy3XzKjahaNHBUaoci8mO/7EPSC2mmA/J7T1CWtSSj7lrSAAxMlyt799TRM5sKXtJBe3Ti6hwDszjrGF50kyCLzn/zHhTXh8bHqAbSONiBwKvxfPyglBLeVjw+4xpSwX1ZEMVXeD5YEy4TNKYVB7d3xlAt3KG8G5hkw7KEVbxQ/RxesWLOf2eR03T658RkohpEs3DVaMxq+65WvfylnJ0p3yeL8jEee0aZ/5TWAQMiWmzuiyRXSBED/8RD+t7tbInjXM5h9pnCQekrEOYhhFLTeNSQmpBZa6vXSkcM3FWymrIN+++NDlRI2Qulr3ygoQYIB/8z0tkWVAb64GUAINEEb0wjBNfL+JBWhm2QMkqNJj3fDnqd3VxgXKXH808JcijtcLjKLrMQMwD/NpFQGIXfsN1UErLVcfEXu73lYhanA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199015)(15650500001)(26005)(6506007)(6512007)(36756003)(6916009)(5660300002)(66476007)(66556008)(38100700002)(86362001)(186003)(2906002)(1076003)(83380400001)(2616005)(4326008)(41300700001)(478600001)(6486002)(66946007)(8936002)(8676002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3P/WmAbsrGeq4aRaQ2E4/N4qSz4Q5EdbYzPqgRxriyr6ecUY2jy0DZ+XYizY?=
 =?us-ascii?Q?fWVIWUpJU1g69iwxV3X6nN+YBqHbK8cWt9PH+HJfIg5KNuB2DV/k/kG79wJV?=
 =?us-ascii?Q?X7mOKL8XHYvIjrmIE0qI7aykaAXItPBOqzdtcogtJY3xS7qudyFNzVkrN1s0?=
 =?us-ascii?Q?cS253FfqxFn5W3pxzlOcUOqh2/mfVRi7/P7n+CuyXRSvBDnTQF2E0yTEQNeg?=
 =?us-ascii?Q?sWMxs5RZgsjgRHYv6uN2BWqjX+ijN0IDg54++ACQbJv7SUQ+DiX3L33y8Sy3?=
 =?us-ascii?Q?sIaXYF8GXU75WRna22hHSvM9IgOWxZbpQFUK4JhDELD9gDsYpTJpnSf9+/r+?=
 =?us-ascii?Q?ykIkeJDU9g2gdYGyMeai+Y3hMajERSxPgcN6YJPqahNNfgVIXgve8Fcx7QGH?=
 =?us-ascii?Q?FugUof5lU6pIWRxlOjxnlZBBkWjEL9caAZe1j1i5OXepsoo+6V6+xeMdniZX?=
 =?us-ascii?Q?VuF9zUzgmtnsesvDVGrpQm/o9/kt/6idnbBUGC8cpCYkCYxXzV9ZKG0Jcdr+?=
 =?us-ascii?Q?rofx86sx/pre0/SgVkxb6oKbUbeXbkKPAPxnfi+CewvAR+lmzsLoUzmDOfWI?=
 =?us-ascii?Q?D5TfztrSiFjHUYmpva1JtMxQvSnS1e8Je2RN20+OPK07NSoale4loR7rULcW?=
 =?us-ascii?Q?fduMfHmXJT6LPnelC0h7DUAonHhzFTiPBxQkJ+MDioEsDo3VRZ0MkBEnGA4C?=
 =?us-ascii?Q?fl4Z5k74rDL2fLOO1Dw6mTfNYbawmaVoAOBNeJG0quHR3Foc/+HIAWFGpM9/?=
 =?us-ascii?Q?On8SRHb3E44o3LQvms6+wuGE3ZjofxvLs1Jzf/eAvtsrYqOK0CIQ2Z9MfeoV?=
 =?us-ascii?Q?lFcMU3jlzAAZDXFgTnpvXDSOnUQmqVu239VRWFGkRHbpA99CkBC2Z6u2RnbH?=
 =?us-ascii?Q?Yo4N2A+3kPAtUthOAEeApr1bPd7Jc3WczEylU6c8DAzorEfCohGNyo5a3GGM?=
 =?us-ascii?Q?yOfsUMA+lHasGXZVIsTT0EVOJOCNhm1QRJRAu9oGVmA83TkD1SWJegiRRHy7?=
 =?us-ascii?Q?cDVOjYduaZypYuMRr9emEkuUohum/iYPCgC3LJZ+SaTDqrHEHgTqiJuG4LMD?=
 =?us-ascii?Q?yrPX9gnGOulJO9lJhK51o4cU8IsXTat2JffTjz13Pd2p6ojW0RRqSLpZ6hxY?=
 =?us-ascii?Q?m81d25unfu08VzUXfIwRAJ+/g4LD2GLhxBo3i5tWBzYwKgKFJRqQK1sSGT+9?=
 =?us-ascii?Q?vchcyBfOCIWBkH556BYoq8lwrHcUyv1b9aSaT8zch358Kiz+He2WySaL90n8?=
 =?us-ascii?Q?kg81PX8KfsrnBqqq9tDg/AqN10YQw0wdGmIGSW2LQxhb7h1WtE/smwSti+CT?=
 =?us-ascii?Q?wER1BBHzqp28tnqvGDiwFAtXN/NihKWmDSmZCrhn51imnQkLxJTofvpQO1LL?=
 =?us-ascii?Q?2+TAUnnO0Mw7GWrFR9HHL/6BGD07NUm/2QI8EGB3GKCj6g+Fmz4j72GPhRb6?=
 =?us-ascii?Q?mEN8O3npmJOLP7l3L6Ic1cfkjC2gQof94PbeHFiMslahIqZJl9JByl1iPGb/?=
 =?us-ascii?Q?HkyDEp2AIbCeJ15Tyb5oivWKrpbbw5KOKeJcbrWj8LAtwBtIaskvG6EOThHO?=
 =?us-ascii?Q?Of+FSnckfRDTd7H4Wuwz+grgmZJBRZLohG3wGL/OFQrI0kGArMrh8RFj6EQd?=
 =?us-ascii?Q?Fg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79d7b8f8-dbe1-4c91-e809-08da9b06b338
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 12:50:30.7507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z3iur8cnbCYTXB2UFUukxhbvkuHQizKVPwd6q5CFvpK9fbYIdPEh9Vhb8HtUk6fiBZ48uTWVRgYr7zlmHA+cHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6304
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200076
X-Proofpoint-ORIG-GUID: S8_TPA6SiKU-3SWgWDjGA3CuVyhDfN9z
X-Proofpoint-GUID: S8_TPA6SiKU-3SWgWDjGA3CuVyhDfN9z
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 4f5b1b3a8fa07dc8ecedfaf539b3deed8931a73e upstream.

If the administrator provided a sunit= mount option, we need to validate
the raw parameter, convert the mount option units (512b blocks) into the
internal unit (fs blocks), and then validate that the (now cooked)
parameter doesn't screw anything up on disk.  The incore inode geometry
computation can depend on the new sunit option, but a subsequent patch
will make validating the cooked value depends on the computed inode
geometry, so break the sunit update into two steps.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_mount.c | 123 ++++++++++++++++++++++++++-------------------
 1 file changed, 72 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5a0ce0c2c4bb..5c2539e13a0b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -365,66 +365,76 @@ xfs_readsb(
 }
 
 /*
- * Update alignment values based on mount options and sb values
+ * If we were provided with new sunit/swidth values as mount options, make sure
+ * that they pass basic alignment and superblock feature checks, and convert
+ * them into the same units (FSB) that everything else expects.  This step
+ * /must/ be done before computing the inode geometry.
  */
 STATIC int
-xfs_update_alignment(xfs_mount_t *mp)
+xfs_validate_new_dalign(
+	struct xfs_mount	*mp)
 {
-	xfs_sb_t	*sbp = &(mp->m_sb);
+	if (mp->m_dalign == 0)
+		return 0;
 
-	if (mp->m_dalign) {
+	/*
+	 * If stripe unit and stripe width are not multiples
+	 * of the fs blocksize turn off alignment.
+	 */
+	if ((BBTOB(mp->m_dalign) & mp->m_blockmask) ||
+	    (BBTOB(mp->m_swidth) & mp->m_blockmask)) {
+		xfs_warn(mp,
+	"alignment check failed: sunit/swidth vs. blocksize(%d)",
+			mp->m_sb.sb_blocksize);
+		return -EINVAL;
+	} else {
 		/*
-		 * If stripe unit and stripe width are not multiples
-		 * of the fs blocksize turn off alignment.
+		 * Convert the stripe unit and width to FSBs.
 		 */
-		if ((BBTOB(mp->m_dalign) & mp->m_blockmask) ||
-		    (BBTOB(mp->m_swidth) & mp->m_blockmask)) {
+		mp->m_dalign = XFS_BB_TO_FSBT(mp, mp->m_dalign);
+		if (mp->m_dalign && (mp->m_sb.sb_agblocks % mp->m_dalign)) {
 			xfs_warn(mp,
-		"alignment check failed: sunit/swidth vs. blocksize(%d)",
-				sbp->sb_blocksize);
+		"alignment check failed: sunit/swidth vs. agsize(%d)",
+				 mp->m_sb.sb_agblocks);
 			return -EINVAL;
-		} else {
-			/*
-			 * Convert the stripe unit and width to FSBs.
-			 */
-			mp->m_dalign = XFS_BB_TO_FSBT(mp, mp->m_dalign);
-			if (mp->m_dalign && (sbp->sb_agblocks % mp->m_dalign)) {
-				xfs_warn(mp,
-			"alignment check failed: sunit/swidth vs. agsize(%d)",
-					 sbp->sb_agblocks);
-				return -EINVAL;
-			} else if (mp->m_dalign) {
-				mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
-			} else {
-				xfs_warn(mp,
-			"alignment check failed: sunit(%d) less than bsize(%d)",
-					 mp->m_dalign, sbp->sb_blocksize);
-				return -EINVAL;
-			}
-		}
-
-		/*
-		 * Update superblock with new values
-		 * and log changes
-		 */
-		if (xfs_sb_version_hasdalign(sbp)) {
-			if (sbp->sb_unit != mp->m_dalign) {
-				sbp->sb_unit = mp->m_dalign;
-				mp->m_update_sb = true;
-			}
-			if (sbp->sb_width != mp->m_swidth) {
-				sbp->sb_width = mp->m_swidth;
-				mp->m_update_sb = true;
-			}
+		} else if (mp->m_dalign) {
+			mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
 		} else {
 			xfs_warn(mp,
-	"cannot change alignment: superblock does not support data alignment");
+		"alignment check failed: sunit(%d) less than bsize(%d)",
+				 mp->m_dalign, mp->m_sb.sb_blocksize);
 			return -EINVAL;
 		}
+	}
+
+	if (!xfs_sb_version_hasdalign(&mp->m_sb)) {
+		xfs_warn(mp,
+"cannot change alignment: superblock does not support data alignment");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* Update alignment values based on mount options and sb values. */
+STATIC int
+xfs_update_alignment(
+	struct xfs_mount	*mp)
+{
+	struct xfs_sb		*sbp = &mp->m_sb;
+
+	if (mp->m_dalign) {
+		if (sbp->sb_unit == mp->m_dalign &&
+		    sbp->sb_width == mp->m_swidth)
+			return 0;
+
+		sbp->sb_unit = mp->m_dalign;
+		sbp->sb_width = mp->m_swidth;
+		mp->m_update_sb = true;
 	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
 		    xfs_sb_version_hasdalign(&mp->m_sb)) {
-			mp->m_dalign = sbp->sb_unit;
-			mp->m_swidth = sbp->sb_width;
+		mp->m_dalign = sbp->sb_unit;
+		mp->m_swidth = sbp->sb_width;
 	}
 
 	return 0;
@@ -692,12 +702,12 @@ xfs_mountfs(
 	}
 
 	/*
-	 * Check if sb_agblocks is aligned at stripe boundary
-	 * If sb_agblocks is NOT aligned turn off m_dalign since
-	 * allocator alignment is within an ag, therefore ag has
-	 * to be aligned at stripe boundary.
+	 * If we were given new sunit/swidth options, do some basic validation
+	 * checks and convert the incore dalign and swidth values to the
+	 * same units (FSB) that everything else uses.  This /must/ happen
+	 * before computing the inode geometry.
 	 */
-	error = xfs_update_alignment(mp);
+	error = xfs_validate_new_dalign(mp);
 	if (error)
 		goto out;
 
@@ -708,6 +718,17 @@ xfs_mountfs(
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
+	/*
+	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
+	 * is NOT aligned turn off m_dalign since allocator alignment is within
+	 * an ag, therefore ag has to be aligned at stripe boundary.  Note that
+	 * we must compute the free space and rmap btree geometry before doing
+	 * this.
+	 */
+	error = xfs_update_alignment(mp);
+	if (error)
+		goto out;
+
 	/* enable fail_at_unmount as default */
 	mp->m_fail_unmount = true;
 
-- 
2.35.1

