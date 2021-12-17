Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66820C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Dec 2021 06:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbhLQGzJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Dec 2021 01:55:09 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:57636 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229757AbhLQGzJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Dec 2021 01:55:09 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BH2VHfd009354;
        Fri, 17 Dec 2021 06:55:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=1l1No9OX2O9nqsL+AoJ1iA0sxMTxJQIpxnIolB38n8c=;
 b=GU54V4l9PxGGnVN19poLZr4PctCtRqJXhcQiiZx4VM8aCcJ1kFwUuc7JIL1/OJ0y0md5
 XOnMiYE1rN9InizOWpHfm4NVSbn20ilduPPib6nOynAlWsbKnVQHfdgyga0N2NT2zfEU
 W54lmouhYSzemDHaqHqpkWx2MDuVhz11wuDbftvJUUAvtl8vzfO9XLhLj0roQKVtVWCE
 Z0MfyR4ryHMU9bIrY2YSHe5dfQo/dgJlLPMKUZYQnp4w5rQXZ2CdyinC2JfgWIwo7xgw
 9NivEipnTaTD+CAsi4teOJZx2lEWPV2szjCFvTk2DPfkq3jjavmoOei7QYQBEbi1AXNJ AA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cyknp4x87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 06:55:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BH6VthX023298;
        Fri, 17 Dec 2021 06:55:06 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by userp3020.oracle.com with ESMTP id 3cvnev4k16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 06:55:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXHEfaF2tERUs1YqKYHoVKY+z1QWvS7HMCWOBQVNa5zSILIPzPBH8yZyTYwnJKgis7sjMvAwwearc8IDm+oQ4TVIQ4wsWiA0yT61bFRDIf7+P2LcfPQOUDioXFn8M0ovKuwqeEwe84+1DOyq4YW/+AgXkb46LHhkOWe1bTqZxkIp51Wqq7v8Rp35ZoicYN1xvHHiGePRSJOz0qo+/QO0WrEDNWzQ7qYDuu25El3cskfBdCicxGR/xWTwB9IW+W+sR2IC1faS54FyPVmpPPN80pCYKANqzWI1mTd0qc3/vggGYcHWVfZILW89REij/ZW5ajN+9eoHKxOaKuc49MoTYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1l1No9OX2O9nqsL+AoJ1iA0sxMTxJQIpxnIolB38n8c=;
 b=WZcvyl3fIWhEpvv06AL21TV+yfzb4zB/zGcaOXL6MuRbm+2AUle7pCDlLTuXAP8VKinS5H/EfGaXb3qnEGgbqsgV+t3DgAm5WAKwSxAJIfdnPWEuwRJSnmwTI1PvWfKoQt+Xz//6lRxVgLNdCbGM+1hO0myX4F+Y6Q5H8DzTC/g7UT1yDeiJ0qhs6wXE4CJjv722qKyDXMQZdtXMncdXUP7lTaZn2BTXje/D5Y7gAggmFTK3F2WjbiA6u0P0CGCguZIvQT0T6SDG0VD7mxvJG8Hv1ZhqpzqRXJCXXmM8lhidd9pQcKaLLcJJ75mIx78X+hlmjVkFtmulZzIJVgF5aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1l1No9OX2O9nqsL+AoJ1iA0sxMTxJQIpxnIolB38n8c=;
 b=CZboaIHTnNoVXObSBUaqbvYZJVsISO4ezkpmG6eFjdHUlc97zMT2mLXtQZVojw/UA9ZvPYuTLncTuMo3dgMPQ6LHEcMsALlm30sJaWO+LOmQOFI8K8pMnmjVoXCz61ss23YEoNELesqG2jB6xiXrEF23AsSeFIMGcn1XrTFZ9bs=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO6PR10MB5425.namprd10.prod.outlook.com
 (2603:10b6:5:35f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 17 Dec
 2021 06:55:04 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4801.016; Fri, 17 Dec 2021
 06:55:03 +0000
Date:   Fri, 17 Dec 2021 09:54:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()
Message-ID: <20211217065453.GB26548@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0052.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::21) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4dbae25e-5815-45b3-8c4f-08d9c12a26cb
X-MS-TrafficTypeDiagnostic: CO6PR10MB5425:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5425CB1054D76ACF0E05AFCA8E789@CO6PR10MB5425.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HBX8OsIP6wrqPXjzZl1/CTkLgEM14rmzpylQc+IgRdng1Nx/Wx3bztlIcn0zAV5UVcMj3JQjxEm8aGeI1+tcV4vDMXvT9I7jiYmEERlJoriYP3WU++CaCeBG1pnZGqQgH213msiyv3NEfhaPmHoQiygHbxZmgRr52b7vRg78AyJA4Dc0qdEu21TV65fAd+k0/m893oVxDJxtd1desgzkrBW788yNiKmtfh85Hp/TGC4b70o+j4kcGXb/7f7xqk0G54WzMC5/Q1yMEEvkL864Xy6uzt31zd7q28wJ98Po5q1T2+AenF48UoH1bPh92HyMJCUH9N5regmvLz0F4xOni6Fie9Hs97Z6KtxwheFVVNzikYe6qmmwNvFREvErnC41K7cbp4zeznbTlnZzR6ZxwT0gHYgy9UcQAXA2CgT7yI5g9jmTPzTCSBLLgORkgLoIuo/rfywvtiCyYEafCRubvuW4AlpFbGBCLFXmFY1LlezXAxzvJiosHGyoECtpYlvuGAJZrUkfYsKRMfWzkoy/YcJfxMxJIw/G6x+gGKHCLiK8lzzcI5TrxMQW1s2LpGLpdQr8Zk17ES3Tk0VhsOWpsb1GwrAhDED2yfBeaDgBimcDs5tryURp7D0lZJgPlHxECeXY9X753E6vOEd/ruyUu5Vmi5ts0ZKpd+hQDHSLI0BztqomwXd2Tw862m4uFUV44HBY9nNXzAEcZF+1WobdUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(6666004)(508600001)(6506007)(26005)(44832011)(316002)(186003)(6486002)(5660300002)(38350700002)(38100700002)(33656002)(1076003)(33716001)(8676002)(8936002)(6916009)(9686003)(83380400001)(2906002)(66476007)(52116002)(66556008)(66946007)(86362001)(4326008)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HJZFNFHRnjSOl3ODdB1sC/BRSRa2fivLqewrAwnUzdgdJntgTI8G2kAeK9Qh?=
 =?us-ascii?Q?0okcV3tY/AWJeHmgAgtvGwTEfv6CUreXGxXgwdQdvzIO1QucYL1Lm/bz310O?=
 =?us-ascii?Q?szL1Ot34z0TQqs5JGo0eoWIsjlCetazeWojv1bAuzAeJ95LiJ4hr38XxP/HQ?=
 =?us-ascii?Q?2wQdO6Ym1ELKUmIcBfDujD+mTBejGFAMqv6KpgdgZftRVJNMpGccPHbSc9NP?=
 =?us-ascii?Q?ovrYPHW68z7bRWG78EuhbNLI6k2ABr70z+843sPCriM7R3zFEnOOIM1o7X5s?=
 =?us-ascii?Q?sk4z8CE5EODXJ5dnPHHaQ5SjttSCHExCGx5Q1fOz+fYVmrmZ09ebPgTrCju+?=
 =?us-ascii?Q?mMxILzySgieAGDWjNMBejknKF6GQAAjs+idKUP9nsWS5iON++f2RYfodsfBx?=
 =?us-ascii?Q?8HJA80b8pkuYb13nZ0xL2TkEDYsZnHjJbEemBqBW3pDwSK5wYMdbTVVLiOpq?=
 =?us-ascii?Q?ctCu48I61CXrbB2yoZkQKyRFDvgvNQDTuAx/aVWDuGZ5tY9J6aPigeDhzPsI?=
 =?us-ascii?Q?i6u3owX5D+sYupe6EozCgcXPHAEuwNhZ6pbTZnwqrguk0e4cPM/Wh4IfxhYy?=
 =?us-ascii?Q?b7aZYea+V8Myn17AFa0DDCpVE0GfADkcPlPtaa8BFm/pjKXn3LWiFgkmFCgb?=
 =?us-ascii?Q?t7GqO+9uTRykattInPNKgWDMsi+iqFtTbF9/hYyJKcm+4YoCKvwbiqyt7UQz?=
 =?us-ascii?Q?jH4kn5Cc1btae9rsqFVvteU9Kx07umarD5eBwDmQn6izznV1s6ehSo8Xh9ky?=
 =?us-ascii?Q?7ZoPDueb3Wf5ovmZG19pjOkZ2sxprenWnPsHFRk/E01fMfB4mavOIeLB1HHs?=
 =?us-ascii?Q?rjhzlxF03dnTnrayAmOmaMc0LXUo3iOC4+ngGy5fi/jSLVsUeV9Io+2NnDKI?=
 =?us-ascii?Q?5XVbyqo12kDETIaej/6KV2RTmT5R7vCPGm37JPcJRodMJCT9Mdw4pE6zpQj6?=
 =?us-ascii?Q?6PrxsnSolnSugUp2MnTMLGS+yAdRMNcM5rKgsxrhmX2RoTTuDEZzObH1t4TH?=
 =?us-ascii?Q?DgvHSOZfgcTmNPJT2y0BO+e32wQvpM5g+DSAbygF5a8fGbNd0N6WoqbKI/CH?=
 =?us-ascii?Q?EQsyLxZb+tAgW7viF8OzuPooUmBycrV4kFqC9lzFom4eNA/tnBYGzn+oDlVn?=
 =?us-ascii?Q?V2PPVMltTkmmLDTthOis5BGifdCFAG26Sjl3Y8p0KXLcV5f2SsJjqkq5EXGW?=
 =?us-ascii?Q?Bvh9RDyD+OMOtNBwmM2ZWoma4WbgBbd1ukJMRRd79nkVueI+/CqJkTOVdd9Q?=
 =?us-ascii?Q?6b2em0gCMNtJ2DwUbJuEwjPQXLPWtYxteXGK1uSdM6pFgY9dwMFc5ewLqSPD?=
 =?us-ascii?Q?1aNByc3th3ozjk9Fukdjx4NW7gHg3wGplhpNfRBqxjkC9IaKZWDmaHF50tYl?=
 =?us-ascii?Q?Zi2GdE/0wWF7F5FaGNSxPT4Egu8s3kGFzmCcPy/r5PaQo+4452cxJmy6lJx6?=
 =?us-ascii?Q?QHPYzDT6hhqqRMWNXX5xIu9VXgW5Q/5P0lYf+JcfHlYbrck6eeS/00FC9uMN?=
 =?us-ascii?Q?9oFQOya0L1HSO82l1GJv5t34giZHAWUnEo/kOmX2bw6qdiwOVKkYpXAoLfz2?=
 =?us-ascii?Q?9ncmQ5y0ZN/TYIO+PwafHJKqnsEaBINlGPlIMeRfkJWINAUsaSaeeYLCtcRR?=
 =?us-ascii?Q?0OjcZI95AWpXyXK9sU2wM/A9KS5YBDDTVrikA+GXH/B2moqnHATFl+PA8KU/?=
 =?us-ascii?Q?mxsACC2KODNfCK2rmCldRmuHYds=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dbae25e-5815-45b3-8c4f-08d9c12a26cb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 06:55:03.6095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rdNJI/n0EmjywuEENXINJjypDs+b7hsMBhg7CFzfA7OzmX+vSrC4aqqu/ycydaeL4aKl+SaET2kqHiv6ah5d6bUMuMFMoZx6fU1gFZrgIWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5425
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10200 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=1
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170037
X-Proofpoint-ORIG-GUID: Ly3ypPX1k5cvzhstmMu_EnxMGDl4pYci
X-Proofpoint-GUID: Ly3ypPX1k5cvzhstmMu_EnxMGDl4pYci
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The "bufsize" comes from the root user.  If "bufsize" is negative then,
because of type promotion, neither of the validation checks at the start
of the function are able to catch it:

	if (bufsize < sizeof(struct xfs_attrlist) ||
	    bufsize > XFS_XATTR_LIST_MAX)
		return -EINVAL;

This means "bufsize" will trigger (WARN_ON_ONCE(size > INT_MAX)) in
kvmalloc_node().  Fix this by changing the type from int to size_t.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
It's sort of hard to figure out which Fixes tag to use...  Maybe:

Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")

so it gets backported to the kernels which have the warning?

 fs/xfs/xfs_ioctl.c | 2 +-
 fs/xfs/xfs_ioctl.h | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 174cd8950cb6..29231a8c8a45 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -372,7 +372,7 @@ int
 xfs_ioc_attr_list(
 	struct xfs_inode		*dp,
 	void __user			*ubuf,
-	int				bufsize,
+	size_t				bufsize,
 	int				flags,
 	struct xfs_attrlist_cursor __user *ucursor)
 {
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index 28453a6d4461..845d3bcab74b 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -38,8 +38,9 @@ xfs_readlink_by_handle(
 int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 		uint32_t opcode, void __user *uname, void __user *value,
 		uint32_t *len, uint32_t flags);
-int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf, int bufsize,
-	int flags, struct xfs_attrlist_cursor __user *ucursor);
+int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
+		      size_t bufsize, int flags,
+		      struct xfs_attrlist_cursor __user *ucursor);
 
 extern struct dentry *
 xfs_handle_to_dentry(
-- 
2.20.1

