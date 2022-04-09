Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6655C433F5
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Apr 2022 13:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242193AbiDINtv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Apr 2022 09:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbiDINtu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Apr 2022 09:49:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E493E0C9
        for <linux-xfs@vger.kernel.org>; Sat,  9 Apr 2022 06:47:43 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2394O8VA031505;
        Sat, 9 Apr 2022 13:47:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=6IsqRkju15dg70ue16ZFlp2sAW8YONc1EVTlzZCZ6PY=;
 b=vLSYZNDaBv8LReunVp9owZdXy6IYPN+nqFJPbVY9OGGNtbvTtADe0HK9SdlrbUAy/ZoI
 xIM7y4EPDcG8P021f3KR7ZaOFeaXho4EcelSiLxDMmIjUenvxbZAxFKzLjtBz5A4tcsi
 pDEcjJleDYSx1/aMzgZFOTZdbHjp33gykLiAFzcKWzr3S7WReuSoBey8xWxm6EEwkf89
 y/Sp4KDz51KwCKkwyEUSIr+AT1N5kuq2oV7rrm8GBWcV3G33vDPt6AFGQNvmnrGIxnD3
 YmnOvT3/PtKWWxVIg/sukhzEU0sDLS4dC/R+twYsrX8tc/ATQiNd0CEfqXGHPdorO97N zw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb1rs0gk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Apr 2022 13:47:38 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 239DkZln002926;
        Sat, 9 Apr 2022 13:47:37 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k03ct7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Apr 2022 13:47:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XovgF1BKWxHSiBYMSkK9Ua3l++rXxk2gNkwI3Q9A0WdGNqLTnNxwC8pGSINAn/760sOutuS9TBWWuM7Lg+ktpkKC6vApss4Lgu23tOwogcVoFJ6+ax2TCNGQQvpXOLWKALMLwRa81EXmtLcSWSYIfGCCsZCCnHdVh+M8VAcdThTpDm7GPHuULIZs4vZeJ2m68cRxk1pRPHyeri6+5hP92P+1OFq+u7pRNh5og3Jvmt6OVGBDJLW1DqwjLGJQ5Y90p2O43cC5MG6tIk2JsGSVEVc7oUnA0YBSiQvUGMVCl2uJzBrJUL1xmKv3dAuV3W/5xeLhiSXUSmBOgChk9lndsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6IsqRkju15dg70ue16ZFlp2sAW8YONc1EVTlzZCZ6PY=;
 b=VMWxzs+sJkLw9ZTpl1I3NZdXvjGQc908165uNUxHKHNAObuAPvhs78pyZd1Hr/2u4Usdw8n0FsjeMiHxyL5F+DqJDR8zX8INekPc8pCBI9HAvj2cJqUWt44ZHLMygfLPGvN7NIgTNBVWNha4obHE7EBL7AUUnhf8+t9ybgfHERsv7TpEg0Pr/4Itp9hsFajK+22+rhQzL9xvh8FU5pJ1fBKPBXhsSafPRVv+Xv2uqCZIPye8CRT0oGgg3vkgBIbvJa/nLH3l+1AItfhN8G3keWUXCvx1LInbylwdzx5DGKoIQ6vulINVyVLB19IvK8QfS5jj1zZuEPieZ9ekVex8Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6IsqRkju15dg70ue16ZFlp2sAW8YONc1EVTlzZCZ6PY=;
 b=YBHNWcWosiuYKeVlYWoSaRkyopMY7pzc7TjbWvwr3Fz8oLBOW5BZwGq/gtdA0oLnEEW04VINd4o8NE3M77ial2gfTboA5x+P+OqhAsJ5qg2bivg9UBIh/d+0PgEEwu3IBjYc5epdjKNNcpGla44mJiWidi0AoWF/QXf8GP8RojY=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Sat, 9 Apr
 2022 13:47:35 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.027; Sat, 9 Apr 2022
 13:47:34 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, david@fromorbit.com, chandan.babu@oracle.com
Subject: [PATCH V9.1] xfs: Directory's data fork extent counter can never overflow
Date:   Sat,  9 Apr 2022 19:17:21 +0530
Message-Id: <20220409134721.471501-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406061904.595597-16-chandan.babu@oracle.com>
References: <20220406061904.595597-16-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0011.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 683df65f-3617-4b6b-9a9c-08da1a2f806a
X-MS-TrafficTypeDiagnostic: DM6PR10MB3577:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3577C1569AD6FCEB01832B98F6E89@DM6PR10MB3577.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z90N5OWEdN2osmtSZPdAfb6e6hth9JR2UOnC5s6+z5DbarFP3BjkYHGIc3wDiXTO259XctALx7KkURdCVP6CWr+Rs1OEFmYKwoHsck4EQxf8WJ1yoOJPqn4k3w+spm2/LLu9pJqHAK5gExpaLd/iditVAPgzceMwhtjRRr5Kyf5F/AFMg2ScydKd7gdYxq464mgxfsBaDhi7p/m6ogi48m/B8vz2RAzBt0vrEdh+7+MT0JZF0fcBL9jCIKhpNZ7WjU28AngOwpepnj8YVtfYRncbtUsiYf2wvK2h4WfKfnCEY5OVnG8CKcmJoxuTp/5NjAo6Bpe9x5LMVE1JNJUPEpC9jxfdsJuAMI0PqCUo8DcdX12LCLKQDSba6XuFwSvzHXLWVWPdUopLCYZXO3boQM3s5Enqog5af72JU0HBNAkfkCioHms9j+VkBRDl5HT5/kVT3rlETeE5IB0lvHn1D3oYh+tDp/IxAnCyKGFPe8qziPusbHXymwlMyZ3lqtpE4DJbA0BM++EUJcCMWzaHgNx9B9Hms+R0eD+euJGtbUZMI5wmiPAMA1z+TuKiuCmcgY87zLGC7zL4WirFxPyDDP6LWR1ThOsXfRLHOgCOv05gU/JcF4DHHlZ6fUIYgar6JHfSCqEgD2tA2XPIBFG/E8pv3g4iLzzG+psayn/ayIc8MDSJWbSCKWTzUJOho7hq3d1pHO1tdyrNNjAIHaGHWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(5660300002)(8936002)(83380400001)(186003)(36756003)(107886003)(1076003)(26005)(6916009)(2906002)(6486002)(508600001)(6506007)(52116002)(4326008)(8676002)(38350700002)(66476007)(6666004)(38100700002)(316002)(66946007)(66556008)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0AVMI5qUpL27k8YsHdAlvARtFUui1SnmulHtJLPK2AF+MVUKIbCAUNUdg9LR?=
 =?us-ascii?Q?myqa3incBnvHVpS03XcuqZSqY7IEqYAZGkZencK0eIiz2r6fOjPrISKvm2kO?=
 =?us-ascii?Q?kdez/q9c927YAawjJxr0vo9W6zOrJh001u5nRKPDXmj3VIVcPo1vJSlk0RWx?=
 =?us-ascii?Q?oznSH4PuRSsqQ3yet/2abCHLTT7+Fas20gcpWGgTagYJakGNzI3S8j2Z7rCJ?=
 =?us-ascii?Q?comVKi8uU7F2HYUrq03Q18kR47jbMQGtzhC6gAExDp42AIZZmTde487OezXt?=
 =?us-ascii?Q?4pW1llLKtCr28D8IiagGGoXAMyhg1fjcRzpW8LHADYvowOT56yrIUfBryy/g?=
 =?us-ascii?Q?ptTeI6/9WN2wQikQ3GYq/WHAJTNKhqfG3m/qUt/hM/laL1pg62MW4ln4uVZK?=
 =?us-ascii?Q?454bnonEjCrzn4yEZ5O724x9hHkMq1LbtCas0WhZXkqoEAe3agdmGX/UXWcJ?=
 =?us-ascii?Q?kg8Vv+jK7yGk1t7jSzKwRyDI97GMJ8hV9K2Bc5r0LZtZNiJIz65yWil5MTaH?=
 =?us-ascii?Q?72/L23G+CF3nQ3TVix1dv4TsiY8BlWUj8INiuOdqPxeQLhwrEFnW6XC109pr?=
 =?us-ascii?Q?HOB5WjgnDPlG3vRs8GD1rfauQxMMEvwiz7kEZsDtPv+KxGCfLgjNZ0SqBfam?=
 =?us-ascii?Q?/LsXjWfQRk5kWe4gp4Xz/7eHJSwRLQKvLDU6hZSnkV+mVzXm5gWNOBH5imEF?=
 =?us-ascii?Q?PdPlmm9PDUgQ0AIgDRWKKTJG/AyR/oOniFd07Y1oe9fgqhRKGSJB4Shhq8FC?=
 =?us-ascii?Q?/iix72efqZaTVA7xnZLkZvpQ8NjJpYoCRVABSQDpDxlwsh38IQ3wc4L0+5xq?=
 =?us-ascii?Q?IHjzEMealTLBca8rJaQoB8GLS6G7iB0StiWX4eoTeBRBAP6yuVPiIX4i2cPD?=
 =?us-ascii?Q?gdJpa7R+YxDMpqboEbmaNOPKTSJhzG1DruO1ED75aRwm41JinEP09TI0Qf4F?=
 =?us-ascii?Q?DoVwE/rJfazVphGlJykshNo0YVXYH1kW7RHFFTrjCx2pucnhM8I4F8yB4N//?=
 =?us-ascii?Q?YZM49zgScBwkKJYshA0tNZCENUCKF+70H/ji/UxqFFxXbdbzKURHK3kNM+Lj?=
 =?us-ascii?Q?m7/DzDH+p+ol3XHyzxhfOb1Mjn4Qoi6ET3IljT83XUetIIPfn69ZxvjbvYmv?=
 =?us-ascii?Q?hqIRmWV1P9UXgcDQU4Yqg414QAtRCOmeiqpzGwjvzI51nrz4Rdnfoxi4VzRX?=
 =?us-ascii?Q?6Awxj1LtJT96ingNUQAg+Ab7PbkvZfh0ZBBl8Xso0PeVwl5SoMjfFF+TQVY0?=
 =?us-ascii?Q?nYAS+QiEpihNq24lhlJ0VDAtUYz4FuKb8dekDW9LDvRccWNJCYcpy/KEY3zs?=
 =?us-ascii?Q?xB9HCjfHyL38vek/Gu9NjN50vq+AdMdNHpcrMENuJ0aQ2upjLEPz6gOi5GJl?=
 =?us-ascii?Q?I1E7hBQTqq/OL26xV7RjI9YQjLIpOPavaudvSDPqXehPaS1PRe9wH49XJN15?=
 =?us-ascii?Q?wS7wrLVJZNPa+uY0K7s/hr68JFAecmnwWKejGfKgHUfnYSh5kdy/FxWTxFNs?=
 =?us-ascii?Q?aa6SLdw62Smt9thmK8LxDVFEhIW+2y1d6f1HZnCNbvSveonwNqUr3qfI0iUY?=
 =?us-ascii?Q?7OzuF/vzWfzXnroxJN5fv5dW6L9wGop3is26wp5LqKnusBHEsK8UM9mEz1T2?=
 =?us-ascii?Q?75rj6STAdxh4hMczgxwXEYxfGBH7QyRyoTYlJ/btkCOq/siIwRLLxFGmHI7f?=
 =?us-ascii?Q?8FCUodIVbkrrD29tjSMscFBGjV2j/Bj+jSoOwlGCSP1CSMvICFDJuFKq0WdG?=
 =?us-ascii?Q?1STE3fcf0DPO+MbU/dEijfLLvDzCNtg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 683df65f-3617-4b6b-9a9c-08da1a2f806a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2022 13:47:34.8776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xXdd9QlUkm+sddp/3C4S9JDQsx/5hPKMYXrEno/6YcxEyXPrGWKZA1L9Wn5cEoZzd8J5eEyHmHR5mtGm/hInjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3577
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-08_09:2022-04-08,2022-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxlogscore=730 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204090092
X-Proofpoint-ORIG-GUID: Gq2R2nILV6FTCRTti3QS-Eu8ECrgpY5R
X-Proofpoint-GUID: Gq2R2nILV6FTCRTti3QS-Eu8ECrgpY5R
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The maximum file size that can be represented by the data fork extent counter
in the worst case occurs when all extents are 1 block in length and each block
is 1KB in size.

With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and with
1KB sized blocks, a file can reach upto,
(2^31) * 1KB = 2TB

This is much larger than the theoretical maximum size of a directory
i.e. XFS_DIR2_SPACE_SIZE * 3 = ~96GB.

Since a directory's inode can never overflow its data fork extent counter,
this commit removes all the overflow checks associated with
it. xfs_dinode_verify() now performs a rough check to verify if a diretory's
data fork is larger than 96GB.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 20 -------------
 fs/xfs/libxfs/xfs_da_btree.h   |  1 +
 fs/xfs/libxfs/xfs_da_format.h  |  1 +
 fs/xfs/libxfs/xfs_dir2.c       |  2 ++
 fs/xfs/libxfs/xfs_format.h     | 13 ++++++++
 fs/xfs/libxfs/xfs_inode_buf.c  |  3 ++
 fs/xfs/libxfs/xfs_inode_fork.h | 13 --------
 fs/xfs/xfs_inode.c             | 55 ++--------------------------------
 fs/xfs/xfs_symlink.c           |  5 ----
 9 files changed, 22 insertions(+), 91 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1254d4d4821e..4fab0c92ab70 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5147,26 +5147,6 @@ xfs_bmap_del_extent_real(
 		 * Deleting the middle of the extent.
 		 */
 
-		/*
-		 * For directories, -ENOSPC is returned since a directory entry
-		 * remove operation must not fail due to low extent count
-		 * availability. -ENOSPC will be handled by higher layers of XFS
-		 * by letting the corresponding empty Data/Free blocks to linger
-		 * until a future remove operation. Dabtree blocks would be
-		 * swapped with the last block in the leaf space and then the
-		 * new last block will be unmapped.
-		 *
-		 * The above logic also applies to the source directory entry of
-		 * a rename operation.
-		 */
-		error = xfs_iext_count_may_overflow(ip, whichfork, 1);
-		if (error) {
-			ASSERT(S_ISDIR(VFS_I(ip)->i_mode) &&
-				whichfork == XFS_DATA_FORK);
-			error = -ENOSPC;
-			goto done;
-		}
-
 		old = got;
 
 		got.br_blockcount = del->br_startoff - got.br_startoff;
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 0faf7d9ac241..7f08f6de48bf 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -30,6 +30,7 @@ struct xfs_da_geometry {
 	unsigned int	free_hdr_size;	/* dir2 free header size */
 	unsigned int	free_max_bests;	/* # of bests entries in dir2 free */
 	xfs_dablk_t	freeblk;	/* blockno of free data v2 */
+	xfs_extnum_t	max_extents;	/* Max. extents in corresponding fork */
 
 	xfs_dir2_data_aoff_t data_first_offset;
 	size_t		data_entry_offset;
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 5a49caa5c9df..95354b7ab7f5 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -277,6 +277,7 @@ xfs_dir2_sf_firstentry(struct xfs_dir2_sf_hdr *hdr)
  * Directory address space divided into sections,
  * spaces separated by 32GB.
  */
+#define	XFS_DIR2_MAX_SPACES	3
 #define	XFS_DIR2_SPACE_SIZE	(1ULL << (32 + XFS_DIR2_DATA_ALIGN_LOG))
 #define	XFS_DIR2_DATA_SPACE	0
 #define	XFS_DIR2_DATA_OFFSET	(XFS_DIR2_DATA_SPACE * XFS_DIR2_SPACE_SIZE)
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 5f1e4799e8fa..52c764ecc015 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -150,6 +150,8 @@ xfs_da_mount(
 	dageo->freeblk = xfs_dir2_byte_to_da(dageo, XFS_DIR2_FREE_OFFSET);
 	dageo->node_ents = (dageo->blksize - dageo->node_hdr_size) /
 				(uint)sizeof(xfs_da_node_entry_t);
+	dageo->max_extents = (XFS_DIR2_MAX_SPACES * XFS_DIR2_SPACE_SIZE) >>
+					mp->m_sb.sb_blocklog;
 	dageo->magicpct = (dageo->blksize * 37) / 100;
 
 	/* set up attribute geometry - single fsb only */
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 82b404c99b80..43de892d0305 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -915,6 +915,19 @@ enum xfs_dinode_fmt {
  *
  * Rounding up 47 to the nearest multiple of bits-per-byte results in 48. Hence
  * 2^48 was chosen as the maximum data fork extent count.
+ *
+ * The maximum file size that can be represented by the data fork extent counter
+ * in the worst case occurs when all extents are 1 block in length and each
+ * block is 1KB in size.
+ *
+ * With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and
+ * with 1KB sized blocks, a file can reach upto,
+ * 1KB * (2^31) = 2TB
+ *
+ * This is much larger than the theoretical maximum size of a directory
+ * i.e. XFS_DIR2_SPACE_SIZE * XFS_DIR2_MAX_SPACES = ~96GB.
+ *
+ * Hence, a directory inode can never overflow its data fork extent counter.
  */
 #define XFS_MAX_EXTCNT_DATA_FORK_LARGE	((xfs_extnum_t)((1ULL << 48) - 1))
 #define XFS_MAX_EXTCNT_ATTR_FORK_LARGE	((xfs_extnum_t)((1ULL << 32) - 1))
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index ee8d4eb7d048..74b82ec80f8e 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -491,6 +491,9 @@ xfs_dinode_verify(
 	if (mode && nextents + naextents > nblocks)
 		return __this_address;
 
+	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
+		return __this_address;
+
 	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
 		return __this_address;
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index fd5c3c2d77e0..6f9d69f8896e 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -39,19 +39,6 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_PUNCH_HOLE_CNT		(1)
 
-/*
- * Directory entry addition can cause the following,
- * 1. Data block can be added/removed.
- *    A new extent can cause extent count to increase by 1.
- * 2. Free disk block can be added/removed.
- *    Same behaviour as described above for Data block.
- * 3. Dabtree blocks.
- *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these can be new
- *    extents. Hence extent count can increase by XFS_DA_NODE_MAXDEPTH.
- */
-#define XFS_IEXT_DIR_MANIP_CNT(mp) \
-	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
-
 /*
  * Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to
  * be added. One extra extent for dabtree in case a local attr is
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index adc1355ce853..20f15a0393e1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1024,11 +1024,6 @@ xfs_create(
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
 
-	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
-			XFS_IEXT_DIR_MANIP_CNT(mp));
-	if (error)
-		goto out_trans_cancel;
-
 	/*
 	 * A newly created regular or special file just has one directory
 	 * entry pointing to them, but a directory also the "." entry
@@ -1242,11 +1237,6 @@ xfs_link(
 	if (error)
 		goto std_return;
 
-	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
-			XFS_IEXT_DIR_MANIP_CNT(mp));
-	if (error)
-		goto error_return;
-
 	/*
 	 * If we are using project inheritance, we only allow hard link
 	 * creation in our tree when the project IDs are the same; else
@@ -3210,35 +3200,6 @@ xfs_rename(
 	/*
 	 * Check for expected errors before we dirty the transaction
 	 * so we can return an error without a transaction abort.
-	 *
-	 * Extent count overflow check:
-	 *
-	 * From the perspective of src_dp, a rename operation is essentially a
-	 * directory entry remove operation. Hence the only place where we check
-	 * for extent count overflow for src_dp is in
-	 * xfs_bmap_del_extent_real(). xfs_bmap_del_extent_real() returns
-	 * -ENOSPC when it detects a possible extent count overflow and in
-	 * response, the higher layers of directory handling code do the
-	 * following:
-	 * 1. Data/Free blocks: XFS lets these blocks linger until a
-	 *    future remove operation removes them.
-	 * 2. Dabtree blocks: XFS swaps the blocks with the last block in the
-	 *    Leaf space and unmaps the last block.
-	 *
-	 * For target_dp, there are two cases depending on whether the
-	 * destination directory entry exists or not.
-	 *
-	 * When destination directory entry does not exist (i.e. target_ip ==
-	 * NULL), extent count overflow check is performed only when transaction
-	 * has a non-zero sized space reservation associated with it.  With a
-	 * zero-sized space reservation, XFS allows a rename operation to
-	 * continue only when the directory has sufficient free space in its
-	 * data/leaf/free space blocks to hold the new entry.
-	 *
-	 * When destination directory entry exists (i.e. target_ip != NULL), all
-	 * we need to do is change the inode number associated with the already
-	 * existing entry. Hence there is no need to perform an extent count
-	 * overflow check.
 	 */
 	if (target_ip == NULL) {
 		/*
@@ -3249,12 +3210,6 @@ xfs_rename(
 			error = xfs_dir_canenter(tp, target_dp, target_name);
 			if (error)
 				goto out_trans_cancel;
-		} else {
-			error = xfs_iext_count_may_overflow(target_dp,
-					XFS_DATA_FORK,
-					XFS_IEXT_DIR_MANIP_CNT(mp));
-			if (error)
-				goto out_trans_cancel;
 		}
 	} else {
 		/*
@@ -3422,18 +3377,12 @@ xfs_rename(
 	 * inode number of the whiteout inode rather than removing it
 	 * altogether.
 	 */
-	if (wip) {
+	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
 					spaceres);
-	} else {
-		/*
-		 * NOTE: We don't need to check for extent count overflow here
-		 * because the dir remove name code will leave the dir block in
-		 * place if the extent count would overflow.
-		 */
+	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
 					   spaceres);
-	}
 
 	if (error)
 		goto out_trans_cancel;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index affbedf78160..4145ba872547 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -226,11 +226,6 @@ xfs_symlink(
 		goto out_trans_cancel;
 	}
 
-	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
-			XFS_IEXT_DIR_MANIP_CNT(mp));
-	if (error)
-		goto out_trans_cancel;
-
 	/*
 	 * Allocate an inode for the symlink.
 	 */
-- 
2.30.2

