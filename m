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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0162BC433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D989E61A40
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhCZAcD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56898 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhCZAbw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OJ9H057396
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=KXWgDusG8RQtQBjveJi1uK3rx0ccdLVbk4hSImrcpyY=;
 b=eqeiPexpCLJhGTUTQXx2cRUH+kQsYrtvQM4N68kmEk3uYMt1R7xRHoqk0cZWeFADdG56
 mz6pIZnpWRaOp5dreGPtNXYXQWVOtQTnHlF02n2dJE+8B6yAIM+gzMawg3+rxUHOx3dB
 V/uqgpJhAQMh12qtfHpBRRzpz4O6EZ3ZVUrb5Zdnx6oN1Wl127Gz3B8CN3gwCoNqx/ZA
 tz86XAHL08QYZxM5Qtu1ddh6VrjHt6agyxR/sroeygYq+YbTqvxKhZr2arxIM7cMy5Nk
 qumtweICn6reXWTuk7qan8W7q9t9pniyXVkS7lHgGVPVhCVs4VQglMdRZQmonKYQBFwD 0A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37h13e8h49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PKkS155633
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by userp3030.oracle.com with ESMTP id 37h13x047t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iO5mfOLXzhRwfQIbDyODMvBrkKEi5WirU5FTp9P5rdYhZORaxzV4D1Cn5qbaR28S1Y8Ay6noyhbgpr4gpeEA7QqwoUlX/NjVJ4xf/xB1KAxu3bhCItV5k5Z/bUvPr+rivUrGe6NyuSzk7OjHv7rMIeC6KruaQGbA59dC+ese+5BHHkRv9Jt94GV9Iv/gUMU6PNERtDZV4TMQYnl7eviyYbv3ezGC/n4RdEnvjuDWQT7TtYWfSb8FWM3SUYttcwPJKky1GEW4mTN+jzlLSomyq4EyyT3J4BnUAlm7yrPzxae+8siKqPvDg2Z2oS3b+tgfC69CbiQyC59Z4gweQUSqQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXWgDusG8RQtQBjveJi1uK3rx0ccdLVbk4hSImrcpyY=;
 b=jt8pMG3L8rIqSt1XzBbOkXd5npswNAbWgvl3KZnqjzJ+ssv5+BkLoDBW/zZ3dAa3AjoQBwW4CubmFnTzRpshDX/gJDh1rHQvv8XkmBV7DM1YKCg7eeq7iJi4l1QETe5+ouiK64cHpjEpqVYQ7sMkYFX8kIQK0WbpwrtP56z3umYyXSDlkRcrAeu2C6JfPw3nuAGLVU+iyBBqFLrpawoInGn8aqCuGHF5IL7hwnmkJNTpDY+BPoXLc0q7LH22zjB9L3nqlTCVNi6pcvey+W2oeTfio2CHtFN4X1HPENC+D50KEhRasi85NCplwxHBtnc/IjrVrEYlxFXd+xDrmAIiLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXWgDusG8RQtQBjveJi1uK3rx0ccdLVbk4hSImrcpyY=;
 b=OqrvHyymqTG7tp6TNgv0hbBJPkcEyHuYV2TIJ//bRcgDXlNh5n6zvR/g5bdmuBu466ofm7XXokpUzx12cg/t/aXRGp9VjV6qhZ+8mm5ZCjyTPnmKKZMl42Tj01hn3rpgXc5G/UfD73MvXuKQahneJNlOZqf+YgGoX6zUdVyTQw8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3924.namprd10.prod.outlook.com (2603:10b6:a03:1b3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.25; Fri, 26 Mar
 2021 00:31:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:47 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 16/28] xfsprogs: Introduce error injection to allocate only minlen size extents for files
Date:   Thu, 25 Mar 2021 17:31:19 -0700
Message-Id: <20210326003131.32642-17-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6da8d8c2-775e-496f-20aa-08d8efee8a3e
X-MS-TrafficTypeDiagnostic: BY5PR10MB3924:
X-Microsoft-Antispam-PRVS: <BY5PR10MB39249782221D9EA1899399A995619@BY5PR10MB3924.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HHPfTzFdZ6aRkc8YdAmqKciGFK6Lfe74JsTqtn0vNkLjkNWx9dp2RPEUK95IZN3LCV+Lwo2rv3bd758SiZftuKulSp8JNnk75Hot23ONMrRntEPM6NrhjjmuYwCWKVF66RP3geLHOsvNW/UD+AsNpM00gJ+i8flcZzXC+V0JChLNiCkJqR6L+ohF1axhqxLtICuTJ1Oq/DvJ5pCU58dwExNHPjy88UNukp6WEJ1vP+BdKH+3fjcZakklyuIR9fRX1UtKMaRpsltv25FrJOiyDB0miORaQhenKccwuaSCyV/h+RY1ZdTc565CPxqyKWXT0umYaMSvra+j7a/raNZM7O/yKkiHqTJxSLUTMnPwV7psMD221pnxyTrynar3PxpLYsPOkkujYljDW3G9Uet3MzUJXzgrTv/pR6tUHEjHbO2KLkpqndJ4n66RwTZPe1oVK4q6eJSFCfA1xqPjqoCZi7LwYLkGkTJaFQ+z4p9fDM+wYLaXbA9y4MZRFEERfwf7c1w+P2ewnW58tXWdXw+WJdYKXtlHU4KleBN53LICtHHPdhZxhhBzWLm7pZvuqtbePRuf0iiBYf5RKqlMWuY30S/oauShFkrfI+NfIZlyX48+j9mCxrZk5KnZraNxXAkTP870HGhyMS8+C8hHWTuKh0Or5AOmFA0lrGAW13ABktFIkKlXECh2uMD8b2/C6Gti
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(136003)(396003)(366004)(6512007)(956004)(52116002)(316002)(83380400001)(8676002)(2616005)(8936002)(6506007)(6486002)(1076003)(38100700001)(26005)(186003)(66476007)(69590400012)(44832011)(86362001)(66946007)(66556008)(5660300002)(6666004)(36756003)(478600001)(16526019)(2906002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YppZyptbJa6vneIwkEy9G8e+tv1BHusMf5Y0JnhJk4HPBlXxwSTjQxgEmP+K?=
 =?us-ascii?Q?UZX5Qvv2y/VL4tT0BSkOUwnR6XILAlWFf56egX0qN5K41K6th2IjjTHw5K8J?=
 =?us-ascii?Q?z8BSnaYJiI2ezDE6XQmXjybiPiasfoXVOd809U7wUXVYLBI+6m7EHryP7clc?=
 =?us-ascii?Q?TkuJbbZRpb2h3bSeHyMftxahvjfEdIF8xK4CfggC9jCp6r6LRuBvsGlYGfMP?=
 =?us-ascii?Q?3PhtFv+UJsO8yQFk32X2MVZWti+BtetXUtFDJI05XcFs4wh/fKHmvKMWtI9c?=
 =?us-ascii?Q?l7K2+NGDlurn//NkyDk2k3VwB9AziPQgqUAGnMF0ItO+5quLlTGmYAblbQTj?=
 =?us-ascii?Q?MjIUZ3WAztFrVO2x6dbj/Gy1zfwV1Du0edmtmxS23HY8IAM6/xJct+bpbXso?=
 =?us-ascii?Q?XiEeAO5WHpmBAVVrtFMqwOFy0c3Ul7bGFpjSCeuG2fTp3/po1pKMLsnmJN2B?=
 =?us-ascii?Q?O1TvZdeFXmSAq8EHQkLNitpNVuEazH95TYyeCEXiyqR5CkeVusQ63w0jBHtn?=
 =?us-ascii?Q?db8M0KFzxouDtEMUD6SKXpmVC539xUbFql2RMfsAjjb5caTkNRJdc0MY8i/C?=
 =?us-ascii?Q?AZf9AgNfAwcWWSuF19TSv47ibxg8VbphUgO3NABOMdTIguU+hEM8vQA3Rjt9?=
 =?us-ascii?Q?XF44aqcE1tey2GCY5pPZVVcpmCS0vTopigm2bb6wTkho9oKs0GsjkFBchCS8?=
 =?us-ascii?Q?hBSztiW/VHThlBAxibqyTXRzUzoJuPVaxyZp5moYG7514HLIvbwxQuBWH7tJ?=
 =?us-ascii?Q?rYJOAKoucpfynRLSDf+T61+DrYF9n1y6A6fvWTUx7By+UE/SgpS6zg6bKe0+?=
 =?us-ascii?Q?dK5lllTCc4RnYN8HgR4gqV6+ay92iYDwAc3U9/bYnrHqHcsicVW9vqokC13Y?=
 =?us-ascii?Q?MCfLDqn3D3rsRlUbnFOpmBU7qeXLsugS84VFClQ3Eod4sZeq8m6crsnNiSmt?=
 =?us-ascii?Q?yEPU2lR3Laeul0G6Bd3xw8NciBZwHTe1hPEtvy+Ic1BP3eoYmRaFcvbAxPH7?=
 =?us-ascii?Q?gLN8uWhoS9nMCO/ihJogwekN8DURuzHYyC81ehm6A6uukb9uTbeFvkdZsXSW?=
 =?us-ascii?Q?PXDmUegBfKroWw+o4o1h2psIqdFynZAVBEq5sNYgkIk+cSu25gc1t4jTqfee?=
 =?us-ascii?Q?sObqe/Wg9GPfpzawV7gLGQoAMmmLANSMrF1k4gicVAtRtCoAqBby3VLod6ze?=
 =?us-ascii?Q?pXQ3MRHW31bWK2mqlc1rwt/5yOc+dC/OKkJklYbIrucslefjUZs8LwQNfg1B?=
 =?us-ascii?Q?IUGUteC4mM90d4m0I53D2/78cpt12GqOCVTtfCF5wIljSY2tU4rgWFIU0WRR?=
 =?us-ascii?Q?v4c9LZwPJx8qPWxEXCkayXab?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6da8d8c2-775e-496f-20aa-08d8efee8a3e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:47.5050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9WJFibjwrMDGBma2FxnsmsObiN3Ozx77l0cDNszl40IURNoKywwF2sKcMQl+xOI8rwW5cDUzJZeqWJcNzRKf8AaugxnBKHXAzmAntHF0LGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3924
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-ORIG-GUID: U40B0eq_r3D2Rvl_Iymzhdz7N41LFs9f
X-Proofpoint-GUID: U40B0eq_r3D2Rvl_Iymzhdz7N41LFs9f
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

Source kernel commit: 301519674699aa9b80a15b2b2165e08532b176e6

This commit adds XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag which
helps userspace test programs to get xfs_bmap_btalloc() to always
allocate minlen sized extents.

This is required for test programs which need a guarantee that minlen
extents allocated for a file do not get merged with their existing
neighbours in the inode's BMBT. "Inode fork extent overflow check" for
Directories, Xattrs and extension of realtime inodes need this since the
file offset at which the extents are being allocated cannot be
explicitly controlled from userspace.

One way to use this error tag is to,
1. Consume all of the free space by sequentially writing to a file.
2. Punch alternate blocks of the file. This causes CNTBT to contain
sufficient number of one block sized extent records.
3. Inject XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag.
After step 3, xfs_bmap_btalloc() will issue space allocation
requests for minlen sized extents only.

ENOSPC error code is returned to userspace when there aren't any "one
block sized" extents left in any of the AGs.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

achender:
	Amended io/inject.c with error tag name to avoid compiler errors

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 io/inject.c           |   1 +
 libxfs/xfs_alloc.c    |  50 ++++++++++++++++++++
 libxfs/xfs_alloc.h    |   3 ++
 libxfs/xfs_bmap.c     | 124 ++++++++++++++++++++++++++++++++++++++++----------
 libxfs/xfs_errortag.h |   4 +-
 5 files changed, 157 insertions(+), 25 deletions(-)

diff --git a/io/inject.c b/io/inject.c
index ff66b41..4bd4138 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -56,6 +56,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_IUNLINK_FALLBACK,		"iunlink_fallback" },
 		{ XFS_ERRTAG_BUF_IOERROR,		"buf_ioerror" },
 		{ XFS_ERRTAG_REDUCE_MAX_IEXTENTS,	"reduce_max_iextents"},
+		{ XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT,	"bmap_min_extent"},
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 0bef9f0..63e15bb 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2470,6 +2470,47 @@ xfs_defer_agfl_block(
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
 }
 
+#ifdef DEBUG
+/*
+ * Check if an AGF has a free extent record whose length is equal to
+ * args->minlen.
+ */
+STATIC int
+xfs_exact_minlen_extent_available(
+	struct xfs_alloc_arg	*args,
+	struct xfs_buf		*agbp,
+	int			*stat)
+{
+	struct xfs_btree_cur	*cnt_cur;
+	xfs_agblock_t		fbno;
+	xfs_extlen_t		flen;
+	int			error = 0;
+
+	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, agbp,
+			args->agno, XFS_BTNUM_CNT);
+	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->minlen, stat);
+	if (error)
+		goto out;
+
+	if (*stat == 0) {
+		error = -EFSCORRUPTED;
+		goto out;
+	}
+
+	error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, stat);
+	if (error)
+		goto out;
+
+	if (*stat == 1 && flen != args->minlen)
+		*stat = 0;
+
+out:
+	xfs_btree_del_cursor(cnt_cur, error);
+
+	return error;
+}
+#endif
+
 /*
  * Decide whether to use this allocation group for this allocation.
  * If so, fix up the btree freelist's size.
@@ -2541,6 +2582,15 @@ xfs_alloc_fix_freelist(
 	if (!xfs_alloc_space_available(args, need, flags))
 		goto out_agbp_relse;
 
+#ifdef DEBUG
+	if (args->alloc_minlen_only) {
+		int stat;
+
+		error = xfs_exact_minlen_extent_available(args, agbp, &stat);
+		if (error || !stat)
+			goto out_agbp_relse;
+	}
+#endif
 	/*
 	 * Make the freelist shorter if it's too long.
 	 *
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 6c22b12..a4427c5 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -75,6 +75,9 @@ typedef struct xfs_alloc_arg {
 	char		wasfromfl;	/* set if allocation is from freelist */
 	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
 	enum xfs_ag_resv_type	resv;	/* block reservation to use */
+#ifdef DEBUG
+	bool		alloc_minlen_only; /* allocate exact minlen extent */
+#endif
 } xfs_alloc_arg_t;
 
 /*
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 6a9485a..9209e4f 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3545,34 +3545,101 @@ xfs_bmap_process_allocated_extent(
 	xfs_bmap_btalloc_accounting(ap, args);
 }
 
-STATIC int
-xfs_bmap_btalloc(
-	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
+#ifdef DEBUG
+static int
+xfs_bmap_exact_minlen_extent_alloc(
+	struct xfs_bmalloca	*ap)
 {
-	xfs_mount_t	*mp;		/* mount point structure */
-	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
-	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
-	xfs_agnumber_t	ag;
-	xfs_alloc_arg_t	args;
-	xfs_fileoff_t	orig_offset;
-	xfs_extlen_t	orig_length;
-	xfs_extlen_t	blen;
-	xfs_extlen_t	nextminlen = 0;
-	int		nullfb;		/* true if ap->firstblock isn't set */
-	int		isaligned;
-	int		tryagain;
-	int		error;
-	int		stripe_align;
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
+	xfs_fileoff_t		orig_offset;
+	xfs_extlen_t		orig_length;
+	int			error;
 
 	ASSERT(ap->length);
+
+	if (ap->minlen != 1) {
+		ap->blkno = NULLFSBLOCK;
+		ap->length = 0;
+		return 0;
+	}
+
 	orig_offset = ap->offset;
 	orig_length = ap->length;
 
-	mp = ap->ip->i_mount;
+	args.alloc_minlen_only = 1;
 
-	memset(&args, 0, sizeof(args));
-	args.tp = ap->tp;
-	args.mp = mp;
+	xfs_bmap_compute_alignments(ap, &args);
+
+	if (ap->tp->t_firstblock == NULLFSBLOCK) {
+		/*
+		 * Unlike the longest extent available in an AG, we don't track
+		 * the length of an AG's shortest extent.
+		 * XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT is a debug only knob and
+		 * hence we can afford to start traversing from the 0th AG since
+		 * we need not be concerned about a drop in performance in
+		 * "debug only" code paths.
+		 */
+		ap->blkno = XFS_AGB_TO_FSB(mp, 0, 0);
+	} else {
+		ap->blkno = ap->tp->t_firstblock;
+	}
+
+	args.fsbno = ap->blkno;
+	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
+	args.type = XFS_ALLOCTYPE_FIRST_AG;
+	args.total = args.minlen = args.maxlen = ap->minlen;
+
+	args.alignment = 1;
+	args.minalignslop = 0;
+
+	args.minleft = ap->minleft;
+	args.wasdel = ap->wasdel;
+	args.resv = XFS_AG_RESV_NONE;
+	args.datatype = ap->datatype;
+
+	error = xfs_alloc_vextent(&args);
+	if (error)
+		return error;
+
+	if (args.fsbno != NULLFSBLOCK) {
+		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
+			orig_length);
+	} else {
+		ap->blkno = NULLFSBLOCK;
+		ap->length = 0;
+	}
+
+	return 0;
+}
+#else
+
+#define xfs_bmap_exact_minlen_extent_alloc(bma) (-EFSCORRUPTED)
+
+#endif
+
+STATIC int
+xfs_bmap_btalloc(
+	struct xfs_bmalloca	*ap)
+{
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
+	xfs_alloctype_t		atype = 0;
+	xfs_agnumber_t		fb_agno;	/* ag number of ap->firstblock */
+	xfs_agnumber_t		ag;
+	xfs_fileoff_t		orig_offset;
+	xfs_extlen_t		orig_length;
+	xfs_extlen_t		blen;
+	xfs_extlen_t		nextminlen = 0;
+	int			nullfb; /* true if ap->firstblock isn't set */
+	int			isaligned;
+	int			tryagain;
+	int			error;
+	int			stripe_align;
+
+	ASSERT(ap->length);
+	orig_offset = ap->offset;
+	orig_length = ap->length;
 
 	stripe_align = xfs_bmap_compute_alignments(ap, &args);
 
@@ -4106,6 +4173,10 @@ xfs_bmap_alloc_userdata(
 			return xfs_bmap_rtalloc(bma);
 	}
 
+	if (unlikely(XFS_TEST_ERROR(false, mp,
+			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
+		return xfs_bmap_exact_minlen_extent_alloc(bma);
+
 	return xfs_bmap_btalloc(bma);
 }
 
@@ -4142,10 +4213,15 @@ xfs_bmapi_allocate(
 	else
 		bma->minlen = 1;
 
-	if (bma->flags & XFS_BMAPI_METADATA)
-		error = xfs_bmap_btalloc(bma);
-	else
+	if (bma->flags & XFS_BMAPI_METADATA) {
+		if (unlikely(XFS_TEST_ERROR(false, mp,
+				XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
+			error = xfs_bmap_exact_minlen_extent_alloc(bma);
+		else
+			error = xfs_bmap_btalloc(bma);
+	} else {
 		error = xfs_bmap_alloc_userdata(bma);
+	}
 	if (error || bma->blkno == NULLFSBLOCK)
 		return error;
 
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 1c56fcc..6ca9084 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -57,7 +57,8 @@
 #define XFS_ERRTAG_IUNLINK_FALLBACK			34
 #define XFS_ERRTAG_BUF_IOERROR				35
 #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
-#define XFS_ERRTAG_MAX					37
+#define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
+#define XFS_ERRTAG_MAX					38
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -99,5 +100,6 @@
 #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
 #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
 #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
+#define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.7.4

