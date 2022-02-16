Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C059C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 01:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243706AbiBPBhp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 20:37:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245513AbiBPBhn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 20:37:43 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98C919C29
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 17:37:32 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FMrfZX024709
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=O+6Y00U7BLZAyS8UvwlS2YOYLgiyr3B3vi5cG63Sy5U=;
 b=zbH+dIYLfVUADzVLRQA29HUp6/Hp59LgNFVtdixN3vqWcubqgTu84B+E7w20T7gs76Y7
 kRZlm9Qmui22hbzQWLWyG3Bm2VYEVpPEnTIWx68+FcFdBeWoAl5i1HcnTg/kc9LKcjZD
 Q2/mIkWWDu6zM0xwizKFLhliNhUBX7iC4P4471DsoUmkwRdnofSiyn+INGBr23L2Xvi0
 TJ4SAlpxPks/D1l+mnTt10mxwzO/wTC7rVtB9ho+qpupUZRDbe14SZks/02TXMYa5mda
 RZcVLOXVm1WIG3LJJEqzIh+TQtlFWrDBxODBwiRY7l8YEdXL+L5IeZmftUgTxL2kX8R3 Cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8ncar77e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21G1UZxP165528
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 3e8n4tuxvp-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kPjzp33QA2LVWVXhST9R9XFQwEwpvczNcz6YGxaKz/swBcaooOzg+518ommffGK538bPpjAjTPJRXtl0Yl1vSQU0zJJWOPWZwfMYbpD9BJmfVDw5cEhGy+1uGowSqNcIUG9VJUA36ys18d6Tv+RFJlqewZOwYWiqHuVqZLugW2kSCf/fO1hh30Saas2Yz0/pzeK2/SyDh45pbydc/EF2AaUG6M0+uuQDtJ3kdKHRAGm0blDC40w3nL3kDSov9xEzEDfxJTPbRdiiw2kUjvMRDK1zt5nesk6jN6JjJlH9b7XV7KK4c6DUzRRV3C7s+dcjs31AjMs45VKP7x65MuJMMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+6Y00U7BLZAyS8UvwlS2YOYLgiyr3B3vi5cG63Sy5U=;
 b=iPdRiOfv3IbDQrjLrJKBJ66pnAh+3kSMIhxrHg3Dp8lbLiFfNso6RB2KdZgh1riqlD9Y/e6uTOc+RXdsZVGfwsNcgpWyXqZwYuh8qn9OcPZxC4PGKSvobNYtR9qmo5QZImpq5TQofWhs4RBCZ1ohJJzXYph2Ir4wG0xv+LEvghDmdzMFvSfitvz4jVtd1guYhALUTX2ooAtwQOqP7/XC5fHiI58wesyTPIKhJRWFdLQUze5EWpyCs14aSq2Oh2Ku1XT8BX0E4Ylq9nsaBjpF5MCqHl/pILLSrcZ3TrHHhHIFy96HbaOa5WN8Z4NKKq/DcDlQ7Tu13key5+qn+khIIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+6Y00U7BLZAyS8UvwlS2YOYLgiyr3B3vi5cG63Sy5U=;
 b=P0k+KUEMfLX8iLW7+q3Jn/We1oPb1HtSWhD51wVbLzkg9Z9x/Py5N6lxCSAnV5DV/EUDphkhJLaJXjJCirHhP83oVTnMGEPxewWfWUcHHsLqLHbomIu6eK5XVe3+04QS8hiIYXyUz+vikqRGz5m6t1Fzgm/PuuqlPCdjBgVDvyU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BL0PR10MB2802.namprd10.prod.outlook.com (2603:10b6:208:33::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 01:37:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 01:37:27 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v27 09/15] xfs: Add log attribute error tag
Date:   Tue, 15 Feb 2022 18:37:07 -0700
Message-Id: <20220216013713.1191082-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216013713.1191082-1-allison.henderson@oracle.com>
References: <20220216013713.1191082-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:510:e::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b26f5ec-9815-4a1c-9c35-08d9f0ece13e
X-MS-TrafficTypeDiagnostic: BL0PR10MB2802:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB2802882C696C0ED16D4C5B9895359@BL0PR10MB2802.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NXs/+YSdFba+v3J7eXcw4wVcLf82Bj6RoW5srS3hKY5bKVrar6aSejnR+Zc+/84bVP4MAHF5pCP2vloKCwYJuQ4f4h+SZDnk8pRvx20WsONfEoMF0mK0/21vZUfZJaO6kz2E7lj8nxCwgclIlZPbUk7A70GD3lMjYxSJD+tEHo6fYD0PvqIw/a8YzsxfzRrLREs421nUHebdS140KKT9CFDCuiFh3R3KQnDGmxozR5vj46itygVKIJCaHmqG/4cFXAMVEmNft7OyinKe47eZw5ymQ7ObHviRt4RU5uISJCcFztvh9P1ctqAa6FUDPrW5jyIV3GhfYoHxyeojGmk7cohhtCplUDP2m93ouLdopX21OVxA305mR7BAd3uqW+wDLUSivdjv74jfumhY1BxiailD/qEMItnSwd0rgDWlAY1ro2wZO0LRbC4MCrqthujyI0JL/TABUPpUT25CSzZFe70tvF5gBlOKu67YW8Jz1xLzQ1cwLkThQ0RvTX6eoQYuWxJCRvu+WsCohDdhm816uHNErlUY/BFqVAzv9gvjWS9swDmNaJtGS/08B7hMpBrslGaFtVbRVOcZ6XiJ7Ig6EHFE4CscpVhhBcS4PdBQNhME0evywvk3zu+pvUqF41kkXz8Hbv1FerJolU8PSL4OPNiUlgZfvv9ijDEULjn7AKdjgxORvFYHy5qVNb3Wc1TkvD39lx/5ZhOPJioWlNkyjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(186003)(26005)(1076003)(6512007)(508600001)(2616005)(6666004)(66946007)(5660300002)(44832011)(38350700002)(38100700002)(6916009)(6486002)(66476007)(52116002)(36756003)(316002)(8936002)(86362001)(2906002)(8676002)(66556008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gOqww0tfuQgfa1QZ1bogJf9N9Bb0DvhuzZaxUkS6tXaTURLAU/2dlY3JH2Vi?=
 =?us-ascii?Q?jNksn5d0vgJ5guX4+RSYzOQ8HT/JpauDL2aJzmi5X6wKvsMRC9Nf9xkFfpS/?=
 =?us-ascii?Q?klX5v8o830fOimyxEW+7bUpahyWeOmYf/HNCdUN4tkm4/Y8iLo2dRbbmwUG/?=
 =?us-ascii?Q?3RGwgnPmmDk2a8o9s8nxi9DkSG8DkEEu6s7hO4VDB5ddP7l+/S749Z4p0EJa?=
 =?us-ascii?Q?voGIWW3Am9A8b6VM9Q7PEDII11Z9bR0+15wYKwktfYZecdbHCg/3V6oaurfo?=
 =?us-ascii?Q?A7QJDh2V/W+YiYjLxJgYu5W7CVxk7ioxautpH2NfcTiWJP+NnpKwgPmGKaiy?=
 =?us-ascii?Q?0LQOGFJ6mSLV+hmRHd7/10nEPEvAiwaXeYUGgzBmlISiEObjJdCbhIcRNrBP?=
 =?us-ascii?Q?elXIt8CiZOK4b7pDNoMJLtdM2QF5/YL1krRaWDEVHV2N5PJLRJf17mmFCdsV?=
 =?us-ascii?Q?jiN3Oshd89GjgjqhsPB073728PNcTd9T1ax2unhxoepsYmXL91q60fAs1lw4?=
 =?us-ascii?Q?cP96EnINKQxx1xof9Pw/1BwlIKWG8UrkdHgNT2Plqk8wrm6dkpbhZ6VnYA/4?=
 =?us-ascii?Q?8nABgFAtoedsiOMFrRryoukonppMYOQhckWxv+twbGe9rDThBwrLoJgNkR/K?=
 =?us-ascii?Q?LWQMJeWOI4jHybO91n/HIHJef/tzWBvhPXK0q8GYfaDskC29WvAV4Ey0FXsr?=
 =?us-ascii?Q?OItBBjQUps5apepH5y59w7a9VO3dq9UsVGSFEBKjGXrIVX7XikodrzKjfyEu?=
 =?us-ascii?Q?GCqE4tuqyHyUtCzWf9mHAT8ePR/tjn6mADhcJbvnoaocMLfNpNPpcBGNLm9Q?=
 =?us-ascii?Q?BLyiUPE1Et/XprDQNsGB+k7LvQK5F44Zy8Q1UTutRUUsRYaCs8XfXEJbrLGn?=
 =?us-ascii?Q?5P+OeqJv+GeoN6iSdX7Q9ds7Vguip5Bg6L+TWFyP6ha7X0Cwyk2KZjlzG6Kb?=
 =?us-ascii?Q?f+IH9sLWCYOOA3YASP1sEozAQdH0oFOufbqYKPupPcbXtOV/XlAeyPsG+o7k?=
 =?us-ascii?Q?F0ytoEzrRBolbIzO59PqoDtVYNd0GDA+vpvEnxrgocx29JhxPsOaNgtl1j8v?=
 =?us-ascii?Q?tb2pAfiR3BFjY0ORKRlzX/yX9/TssfG6EwpNg5j4BrpIXlnZBW3xPTzEooO1?=
 =?us-ascii?Q?C7TvtHWSEUEcuCpRP0R1c1fwNQrAG4pUVM3ppQSVRV3zyQzkdQhs/OqwAFFQ?=
 =?us-ascii?Q?Mf1sSDqR3ul0p5pvGifiY644B5eWhBbQ1xhQrnkNS33SWQYWHbuoo6COC4u2?=
 =?us-ascii?Q?zfOH8x1wkDwpWZi18I7VCaOrcZXTLu5/PeT1dWllkoid15g3OlHafldQ6Oiz?=
 =?us-ascii?Q?2tQDpL9OUiiI3phyux+2tQWnYrfSJbTmQyQyuijFXBYYJSIuHrSGQilRV+vo?=
 =?us-ascii?Q?r9sFfdL44Z2AEYKIEAEXNyT2JAoknMtdQ8twPFmLrH2FkLwFSW2eGVfEOfQs?=
 =?us-ascii?Q?Uk1q/b2ZKMl5MJIwZIDtplSVQaJKAw6CCyy1RRas1ydnrYNPR2rc6/FxvBPN?=
 =?us-ascii?Q?nXGCYGTpSS55fljRZhz3s+rNsqWeXKX0drgUFudD4gXbp01pMyo+NjDEixAd?=
 =?us-ascii?Q?2wmdb5khbbEYI5EvKNZF8l55VCDDDnG1Yku7zC9dBPisP1xQbHaDlrC7bJeQ?=
 =?us-ascii?Q?pSs4W47VfKFD/Ao+9nQJsOLmB+cncb1kBTi+HRWvCSRTvDwND8NysiiQ/9WL?=
 =?us-ascii?Q?ljHc1Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b26f5ec-9815-4a1c-9c35-08d9f0ece13e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 01:37:23.2966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OcAmOJhqoNvKCu4/H8TWxqDYtkhqbkMSM1MtTYs3IwGyG4Ko/V/VO20YiXPvraDPIWBJ8CHJ6Tob8xLuwzO//4F3C0sMCThmyqRoEGaiEs4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2802
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160007
X-Proofpoint-ORIG-GUID: MIJCvnN4yBNRqDmSrbCN3HeFLI_-snLJ
X-Proofpoint-GUID: MIJCvnN4yBNRqDmSrbCN3HeFLI_-snLJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds an error tag that we can use to test log attribute
recovery and replay

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_attr_item.c       | 7 +++++++
 fs/xfs/xfs_error.c           | 3 +++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index a23a52e643ad..c15d2340220c 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -59,7 +59,8 @@
 #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
 #define XFS_ERRTAG_AG_RESV_FAIL				38
-#define XFS_ERRTAG_MAX					39
+#define XFS_ERRTAG_LARP					39
+#define XFS_ERRTAG_MAX					40
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -103,5 +104,6 @@
 #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 #define XFS_RANDOM_AG_RESV_FAIL				1
+#define XFS_RANDOM_LARP					1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 468358f44a8f..71567ec42dfc 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -24,6 +24,7 @@
 #include "xfs_trace.h"
 #include "xfs_inode.h"
 #include "xfs_trans_space.h"
+#include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
@@ -277,6 +278,11 @@ xfs_xattri_finish_update(
 					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
 	int				error;
 
+	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_LARP)) {
+		error = -EIO;
+		goto out;
+	}
+
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		error = xfs_attr_set_iter(dac);
@@ -290,6 +296,7 @@ xfs_xattri_finish_update(
 		break;
 	}
 
+out:
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 749fd18c4f32..666f4837b1e1 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -57,6 +57,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
 	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
 	XFS_RANDOM_AG_RESV_FAIL,
+	XFS_RANDOM_LARP,
 };
 
 struct xfs_errortag_attr {
@@ -170,6 +171,7 @@ XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
 XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
 XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
+XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -211,6 +213,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
 	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
+	XFS_ERRORTAG_ATTR_LIST(larp),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_errortag);
-- 
2.25.1

