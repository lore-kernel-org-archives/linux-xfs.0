Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C664DC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 09:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238335AbiDFJkn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585315AbiDFJgX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 05:36:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237B92A963F
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 23:20:27 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2361urMk014702;
        Wed, 6 Apr 2022 06:20:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=YWudooVaI2j8Gli5DK/dGhWqEOpLnmkftY+curHF9g4=;
 b=Z9xOP/qJHlDXqgutRewsK7foKZfeUrj71Kfp9hJJ2Ow1RB1pxYlDMdWY+w9By8Yv5iwf
 jace9opOAWoRME1WLtU6rhWonvV2NEfAWJNxqaYtQ3oZ5P6uxNxWqG4Nbe1VSrCd2mY0
 ztiW+ByZ0l+4C6SwrL7fxqMZb3JOjUbb3AAmlwx/CJbRUuWj5j2YlrP6V3d5uEWgLkZI
 ZosZKDS0med6PHPonPysNTf1X0MXUBQc2SSkeMeeWzWxQmo3YE0KtDeCmi7r/LaFuLdx
 T7vYyxzbC/g9kbObj5K2Ytd7J8ulvIz+VghUl1nda54vyuim6ppSzdmGtonYsfeliYr/ Ag== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6ec9qrrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:21 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2366AQKs036332;
        Wed, 6 Apr 2022 06:20:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx473dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ocJgy78bUwL3+knenlZA3B8SAdGbPyjdpzAukY95MocnWytWwhsw0YU8Om6xkgIe+rF+ba97qmJkuTKrb0LLZd+VOvpspj3w1h9ncIV/Q3x7htEBWtnU63oiv2dBibpHfWKnGSP8cbhZ50m4/ZH9cwEBDC1wa6Ge/N/1z61KRp0VgfvjIeIcM1XjsS9I9DcJ9FwgBHnTDgkUULNEAOEKu3wHdzbHjHV6TDWbr7lABLVilnW0Fb+QUNpxguORDYZQK/+0XGhQBgc6xEo7z7FipzauiapdvI42p1N3kxk6z1MQXhlyxC814kwOsGzHmR06pUarr2PT4OiCSVHOn6vJdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YWudooVaI2j8Gli5DK/dGhWqEOpLnmkftY+curHF9g4=;
 b=DW4c+MX/CvXiHsoIBblByUlHxgeUG83QXc2qHdybkIJOBvhJNmT/rIcRR0sVZUj+2HSMuxjDHpYmdQorWEGpL6gGITKkrj3OhAgUYMfz6gF1IjVeCeaMmVy1mLRPs5f/Fpa7WlZ2jt3ZLAK5oPh72GrpQ08DDMjgvQJM7pgUg2ZChkap03fk0ntNBPexTumoXQsCw2VjLVx57atMTNxRExuUdC7Rw5CATfYTLwqIS60gLl2adLgmDx40w51H0yOICa0FPwscsoc4ljN8bugO0g5E13P/K4GZbRQ+XMjbg5xeysuhA8+/XJHtXxmtmYkQHLn9EV2vkZfsxywSZLCDAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWudooVaI2j8Gli5DK/dGhWqEOpLnmkftY+curHF9g4=;
 b=Wr/y39d4dFi0gpc++RjMd7yBb6ofwnV05JOPMX0EO7lVV21feBYvSU0QiXy0pH7VWDW+vaa7m9axhm+klce+6tgbg9Yilgh35Xr4/tT8c0N0tVvwBEUvjvp5pEgWmNxWYiFBSGPvsEUQ4GTgzENBZDyAFgMnbT8O/6kzzZo4OtQ=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 06:20:19 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 06:20:19 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V9 07/19] xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits respectively
Date:   Wed,  6 Apr 2022 11:48:51 +0530
Message-Id: <20220406061904.595597-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406061904.595597-1-chandan.babu@oracle.com>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0047.jpnprd01.prod.outlook.com
 (2603:1096:405:1::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8774980-52d5-46b6-50e9-08da179585e8
X-MS-TrafficTypeDiagnostic: PH0PR10MB5564:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB556406EFC01B1CE1F56ACDFCF6E79@PH0PR10MB5564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ic/iCCRASKyd6cLt64fsD0kb4aJjyL8qP5DvbMlYgLlFyo4XQQYLS6AYYjHW1naqZ6W+WJIcRi5z7hyoIgIJOx3RBlHGpqeNg60fV7T53nhER2xiHT3r1NbhKiLQKY+aUPpSPB1akx7lBmJnDiZxHUrc9euKy1YHNxF6xb5eyC5el/weaeCb0TkFmwglTDes7q3qT6+B989z0mG9WsSWCoUv7eFXIrygcmHv001qbwAMF/Sn1/t6speIe5qNL/E1X3pRVHN3X+iBparx+MIzUY5jH8cQPhbHCviJVzaaTvay6X6ahVv/7UDIgCDcbS8Dv2DfM+GYign0AjXybhpGl0gTu8QHFggAnuNByxKdcB8oOFNz2lta+37adl3hZEEVzaUwhXX7KTJDnENuaDRK+paWddIquQznKBXPDQITW4yHH/heJ1Ct9vebp2YxWPi2z1VwEWGQZb7CcVIez/vH2mx9iPQd+p/Jh9PfNE+o0JE2MnHOrSWv3WxMbrbdLboYg2/Z5KRmdJSxa96ixZPY45Fd7cQfAtcg7YzNF0gyM7sjdRVPtl+L0S1A8lQGbr0DYS70SbWptp2RlOlj809w8sNPlWvwG9byXBUsaifrTiDwGpmG7wG/d/wyE29Rj9nURyZvnSYw777TvDSd0omuBDNhTovNKQrYSQj7FDAqYvi48FSgUTaqCXPkrIz+D5oEdjmPYaDLnymQr/PhEZKXcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66476007)(66946007)(6506007)(66556008)(52116002)(6512007)(6486002)(54906003)(6916009)(4326008)(8676002)(6666004)(316002)(5660300002)(1076003)(8936002)(2616005)(83380400001)(86362001)(38350700002)(38100700002)(2906002)(26005)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rRBffFBEnPhl5QxfBw17gDn8azspI7eJop6mNgvu6nny09i6gHhuXvnU8rJ/?=
 =?us-ascii?Q?t7bfPsHXpHm5HT3XBcmAyn3PVjLjlz2Qf7eiwq8wjdaCoJSaFPMU78yddOnw?=
 =?us-ascii?Q?QBGW53fSI+SsX4G7ChMuwIy/3kwpuaAmj/cz8PfYNkdkgbtR22cHTRoM8Oli?=
 =?us-ascii?Q?6jfYMGwMjr2Yt5Jtw7KmErMV81aTQtcp2K4MjV2SgEWZolaLFVo/VhvNRI+P?=
 =?us-ascii?Q?6wBPbSL1stxo8HoHHDCSdWTxz+nKSVRtOYLVU/6HNJ2TX4EHRGb/IHeiXH2c?=
 =?us-ascii?Q?3P+hqhJSpshuCVWRk0T4nf/rB2Qxzi61vRQNlZ1QlBbKJGTnK6WAOWZdNll3?=
 =?us-ascii?Q?LiX09Mk7l1eeRQkidudrLtTsWgSWiL81ms4SMbzPM4XAzsvwOXsrwyEwoi7u?=
 =?us-ascii?Q?Kbo0FfvjTScTbMHgTApCFZ9EM7kBE3bD2Ehe9h5KgTtGH5frsJ3qNiLQwNNG?=
 =?us-ascii?Q?7KRNw9BnxmZrQewsxYdhx5ikbojeYwFt5wICVaPR5REm3PvC+235yFAOyUYg?=
 =?us-ascii?Q?I9gRxq0eUMFkw7k5npttFPi8gIGikA6h7X9aWCx1KzZijzX6YchtTLxHYAsV?=
 =?us-ascii?Q?mqhv6d1YqwYqQAyZGZC0xiSN8aGbSO9W/DcDKfpYhyoCmvn4rF+OWeU1H1pw?=
 =?us-ascii?Q?SId69Wi4f7NH+llJO16TfkzY/0xklepbCr3P/M7/pn+clj74Kg2ttpZMAlWe?=
 =?us-ascii?Q?UJixL5flLSw9SUN4MQIXH7oMAn/pnfpedtE0164hpw4FcSi19xs9Xq5oc12h?=
 =?us-ascii?Q?JBSPpgiYyaLvGS5C51YVWCP3ZFj4D73lb4XSrBvszDwWv59xyplUOHJ9pSMM?=
 =?us-ascii?Q?39oCP633xufD0cia0ori95+Qhv0qUwEJvgJaUXaPTzt8JAcrzltINeMSQuvo?=
 =?us-ascii?Q?BJHpW8zvzmAu+OX6Kn0Xsf4sEuKKlWBQhkXmNYHRlpi179szjSWuesOeCtKI?=
 =?us-ascii?Q?JpoHwPPFi+tC34v/w8uIyUUiJBhCTi26NKsV/cDWMsQHQu3ao1dHfanCBdji?=
 =?us-ascii?Q?mlzM0dfm/nx9TsqmzxFHHToNmnSCFxICGAfhY+zxfgLdlftoqXA8Nvs/1SLE?=
 =?us-ascii?Q?omDtCIBWyx5No6OaqkBw2CJbBQmJubpaF4mZ1YxzmuedTj6S3jyZ0mKey+d8?=
 =?us-ascii?Q?5OnhW2DmE6s1d8xur66kQx9r6ZYjd5VWjrlNl1fUjMpjYlBLtbhJs0l69tBL?=
 =?us-ascii?Q?mvM8kceToX/RT9glglzTXqSllWs+Oo39zh7OlQ+1Ggyh4lVHVMeNzcOFT+tu?=
 =?us-ascii?Q?ru2ZD6LMHKyiuLe+r/9vM2XVpq8+qPC10qDxvUgceo9FEXBUr3IQasUQhud6?=
 =?us-ascii?Q?D3vvsoDhwF0Nbw8eo4Gwx8OCr4gyKr0/7AhAmzhrAbj2D059f4P91W8I67jY?=
 =?us-ascii?Q?NzhicT6p7+tFLOwb16cVpedUIn/yr0kl+4yMumAXIsfYWD9ysialfIrN+/I2?=
 =?us-ascii?Q?ORampvyaLRKBMx9QIy6weT4oX3d8jVC0vQTGogR66RlInyb293QZkW3GT07P?=
 =?us-ascii?Q?21AtCHiANl/XhesWkxroBuXGrlBMTzkxUbI8SzITkGOE8C6E076CYejTh7sY?=
 =?us-ascii?Q?QQ2MbXlBdhl3Vcgk63MMlijXDt7SInfwjfCHqOs8xppmlywmBzP0qtwy8OwP?=
 =?us-ascii?Q?B0MUUlWeS4YD1gHFTCUKJOVaFxgHAfxVzlY2IqtAxMJwMYYE9eWqnip7FS+x?=
 =?us-ascii?Q?q1xfJoJCJen79FkKbt5XjgRSpaHEjqUWNvHE3ZU+9LPBmLI47rIBDqlZhhpz?=
 =?us-ascii?Q?lZfK8QaSky2VAR9JaRjYQ19C+mN0ZrY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8774980-52d5-46b6-50e9-08da179585e8
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 06:20:19.2394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8gWK0qUUdGhevAVrbgNE4bagXocjvxqVhAiMuAlJGZRGH6XrYtesehUkSHK3AtcbgdEoIcKuMMmSXstB0mkdCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_02:2022-04-04,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204060027
X-Proofpoint-GUID: S9YU8EBG01i2a60VZbJckHHfjcR3c4Ic
X-Proofpoint-ORIG-GUID: S9YU8EBG01i2a60VZbJckHHfjcR3c4Ic
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will introduce a 64-bit on-disk data extent counter and a
32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
of these quantities.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 4 ++--
 fs/xfs/libxfs/xfs_inode_fork.c | 4 ++--
 fs/xfs/libxfs/xfs_inode_fork.h | 2 +-
 fs/xfs/libxfs/xfs_types.h      | 4 ++--
 fs/xfs/xfs_inode.c             | 4 ++--
 fs/xfs/xfs_trace.h             | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index cc15981b1793..9f38e33d6ce2 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -83,7 +83,7 @@ xfs_bmap_compute_maxlevels(
 	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
 	minleafrecs = mp->m_bmap_dmnr[0];
 	minnoderecs = mp->m_bmap_dmnr[1];
-	maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs;
+	maxblocks = howmany_64(maxleafents, minleafrecs);
 	for (level = 1; maxblocks > 1; level++) {
 		if (maxblocks <= maxrootrecs)
 			maxblocks = 1;
@@ -467,7 +467,7 @@ xfs_bmap_check_leaf_extents(
 	if (bp_release)
 		xfs_trans_brelse(NULL, bp);
 error_norelse:
-	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
+	xfs_warn(mp, "%s: BAD after btree leaves for %llu extents",
 		__func__, i);
 	xfs_err(mp, "%s: CORRUPTED BTREE OR SOMETHING", __func__);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 1cf48cee45e3..004b205d87b8 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -117,8 +117,8 @@ xfs_iformat_extents(
 	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
 	 */
 	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
-		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
-			(unsigned long long) ip->i_ino, nex);
+		xfs_warn(ip->i_mount, "corrupt inode %llu ((a)extents = %llu).",
+			ip->i_ino, nex);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
 				__this_address);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7ed2ecb51bca..4a8b77d425df 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -21,9 +21,9 @@ struct xfs_ifork {
 		void		*if_root;	/* extent tree root */
 		char		*if_data;	/* inline file data */
 	} if_u1;
+	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 	short			if_broot_bytes;	/* bytes allocated for root */
 	int8_t			if_format;	/* format of this fork */
-	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 794a54cbd0de..373f64a492a4 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -12,8 +12,8 @@ typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
 typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
 typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
-typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
-typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
+typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
+typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
 typedef int64_t		xfs_fsize_t;	/* bytes in a file */
 typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9de6205fe134..adc1355ce853 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3515,8 +3515,8 @@ xfs_iflush(
 	if (XFS_TEST_ERROR(ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp) >
 				ip->i_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-			"%s: detected corrupt incore inode %Lu, "
-			"total extents = %d, nblocks = %Ld, ptr "PTR_FMT,
+			"%s: detected corrupt incore inode %llu, "
+			"total extents = %llu nblocks = %lld, ptr "PTR_FMT,
 			__func__, ip->i_ino,
 			ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp),
 			ip->i_nblocks, ip);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 16a91b4f97bd..fe6cb2951233 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2182,7 +2182,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__entry->broot_size = ip->i_df.if_broot_bytes;
 		__entry->fork_off = XFS_IFORK_BOFF(ip);
 	),
-	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %d, "
+	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %llu, "
 		  "broot size %d, forkoff 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-- 
2.30.2

