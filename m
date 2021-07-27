Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94C23C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C912610A0
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235675AbhG0GUD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:20:03 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50580 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235691AbhG0GTv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:51 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6Hge2023061
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=K2E7qvG3FrPd9pWeBPpcDaXk5KEgCcpbMA1g7PaUm9Q=;
 b=veDKm15xaZaveAi9OXuv3Q4+G8ApuyLlgHcMj2GuiYxa7gPmQClctvaHyQi53JR5xWft
 ZvRN5QYdOQqa9fjrq36wsjrpm+yU/iUFhyF8rUoh0W/aLX3EY/eVj4cdPxaGwhEiVzQy
 4hfjFdfbd/+n5tCU9MAdiB8S8RCpyUWiArZaL9k5555UACK1r/S0bDN7zBxvYDCP/j+X
 O77yUWWImXpegUZpXxYqGprCq5CE4oyyB9E6KCOQGkJI+6qk4vDnJGZclKsaDnv6Dxss
 C9m5DtJWRj4SZa/5c2qGDLTDUYalb700A6tiLH6TzOgi1p4S4GzB7ebeiaMtJmUUtsCp Zg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=K2E7qvG3FrPd9pWeBPpcDaXk5KEgCcpbMA1g7PaUm9Q=;
 b=YHrerrMnjWWvqyNJ0t0OJx+2Ab5OeKqv2yynQ3+zBDmLp0amSUMiKw2r/o+tVwduVdHw
 +s/ufgJ2ESjkoY20ky3jh+t+M4ZDCz5NY7jXXrfMo13rC/bc/Mx2DATq8d29A0brux+m
 jeRXwc0w6G51VBTbZ1Ex0V85qoLevfnpvI1MdKlRaeZ1KRW0hdSqr2NLlN0ZU5JkzPi+
 Spqj+iJKVZymKnDmK1FWwQ91q2igoMIC9rlGr/xRpdH4lBdqokYOkVdnssHNGNrc4nze
 xa9Y6rdgpk8XxxSqZqzVSGP6iw//YOnV+K0SgeBCArd3TqdUASDSibaVLpZDf8vNB7fM Zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a23538uwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FknQ114917
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3030.oracle.com with ESMTP id 3a2349tqr9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQBEVg4hbg5+jDdQ1fCsPOeZAd+gdP5f69ruGvGN1RQqeiOtI0wmGfnWrW9AMkzgPALSK1BRSqSlhR61MGmpWRikv5Ng7JoBcnQr+aCDC6q7VHTPYZUk77+xwwnTSWfznRQkIjwqihRe3Ji0eBVyP71vc+eOXjs/t3xyMhFlsjVjsQJ13IfVdimY44O4g3fp2BENwajykdqFgnAaN19Q6UGHSqGbiYCwNQpw10b06oxjKwUbDDmcOf+YOCiOMZdoUd9f8LAvovMkGLTc+n/joD6e9jOJ0wjWyrk+ibZS0w0vaAarZipy9guan4vyq2JbjiC93vAFjCQlxMwfjbkHVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2E7qvG3FrPd9pWeBPpcDaXk5KEgCcpbMA1g7PaUm9Q=;
 b=E1slet6ElSAODRBmED00y2F2NXlmcB24cM3XBRgXRsyrfPTCW5FTpbl/GchvqpM92q2/fYJeanE6f12dzqa9W9/mdrJ32sNCDJl68b1VR2gHaWex2pPKEHaB4kUrJjk+63tl6lHvREh94hJjVbfHpb8FzAuWinaUKroiuCioetZEitmAjWMa+yO+wsObKnhpC7cTh/GLdIkDtV4BVR3xZLE5x5m//TmNNrnJm3Sy885HPwuk6UPPnA2gWxLSudK6TWDW7EhPM3afFw1YNJIBuC14S7FRR0iEsbOR53sVPYi5Sj3pWz9SXxRryuGdIqsxyqgVYrq5PXPP8xOd6bWLsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2E7qvG3FrPd9pWeBPpcDaXk5KEgCcpbMA1g7PaUm9Q=;
 b=B/3mBOfRRpJKGvD03FKRj98/etjYwRGr5B+wxLDhoMJQi2J4IdakTKa5wcLOlkA9d8GxvDFn3qzejjQ3nknkqvQKoPsqlNlaJIyMQKi1FVey8B4V8NUBuBkHlbrCXZB9Rz/QVUgabN+aGtOKHnQ6Wj2eL4/P00+SRyBe19SJ0Ww=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2791.namprd10.prod.outlook.com (2603:10b6:a03:83::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:19:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:48 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 24/27] xfsprogs: Add delayed attributes error tag
Date:   Mon, 26 Jul 2021 23:19:01 -0700
Message-Id: <20210727061904.11084-25-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12325bac-72ff-4b0b-42a8-08d950c68921
X-MS-TrafficTypeDiagnostic: BYAPR10MB2791:
X-Microsoft-Antispam-PRVS: <BYAPR10MB27914CCC4E4AFAD574D7AE1A95E99@BYAPR10MB2791.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZTHYSHUihtUWsDqmac3FULcFFhW+jPQh/YLdma5dI3oXCpLvdFcx664yArfUDjCIkAs5SSrVTUNEytk+nLyznMUQXY4WHtFnkwJr/wlLSbjwXMBO6iCoYtcQHhumwoxZ+VzUZY3MwEec3rC/mKXJRfpDUyFC3+KF0YsTfqUlrz81ziH3y2GzMuCdDaWgXcG2csIkJXtgH7X1l7KZifJNV7qo7wFdeHY1xwazWFwyPcq7+DI817l8JR4KC/cM5ysLmbP8Id43NL6qL8gr1FqplAQk+s8dovsJRGxj0fXd5Hc4DxDpMJhbCzW1bqUpTlqLfe7euIV9smoNbphG7lEwm1RmN8GuIRGFQlGJUw31r+jn88xcMbn4ht+CzSB0oYOBNQavfWAMm1eXBfrlcmtLVkI2XmzVlrvcd3hd57kgAAf4Fwr8nFJF7dI7KfMF9x40obnv74+fpfNGQdR28jG41clU4lFaf5hiFuzQrTEnvdGNLx6TuW70fAOVbMppr1ZfYxH5Fpr+2AJQzv9khqlRcG/ObGMXYwybDsZ+uXo+lcHo2OBmguhC/WMjonc03uf6PO6VVmNT7ISwIOfx1h//gcmY8EiBAXlI5Aq/aIWYKQRgYjqh4s5AYhXhPszbAsN/bf4NVAdAeKq52iBzz/nkD/5koOxTBRMGYAFSfDHxVfDUwAU8f4J9671M0le6luPfBeiHlwOd/y3y6tAC0ueMZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(44832011)(2906002)(36756003)(52116002)(86362001)(6916009)(83380400001)(8936002)(478600001)(956004)(1076003)(38350700002)(66476007)(6512007)(66946007)(38100700002)(66556008)(316002)(6506007)(6666004)(6486002)(26005)(5660300002)(8676002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H1zCxcWbbzb40F4c/XSohIsVVz94xsUOqvHUktCH5QWZ1IRCnBRZeNeHejkz?=
 =?us-ascii?Q?5Vut2tWUv9WE+ogk+beleyaIK3oE7Qok2x5wLfFTHLdowcrpFNUtoGuY2/Xe?=
 =?us-ascii?Q?7KVzrSbnBUYJO4QIV4lJ9Up5S3cuEGKVe6WVPttHh3D4Yo/fWLtGLalkwWHD?=
 =?us-ascii?Q?o4pL+ZTx10CKc4WcSpSRwN+OG6ckqgn81M5mYLaCFqKykB+x7N7eBg8acgWP?=
 =?us-ascii?Q?P5tiLgOkiKvY0BCHfRIZnl4P/+p8/l4y7kZr7UVBFWoeiLSLMv1Ct+5p4EGk?=
 =?us-ascii?Q?l/eoyqtdoi8DfjN8WJbQTS7TsHxUlyVzlQQrNZk6h0YlulaE4CNUlv7tEdrA?=
 =?us-ascii?Q?NW8gE6JdO9Ip+ZZFH6Z4loxNsQlWQtkofCVf8jUn/qnrPuDb4ir51i5tAv9j?=
 =?us-ascii?Q?f4cZiTDa/FzuJy/J3jb1tMf3Sia307Zjktt44l/DQotYdEfKkFyObCC7PT8e?=
 =?us-ascii?Q?6Zgvy3xl6hAchs/QiyLoLeo6MkASmx9yvcLHbXcUb8zXfKsVanHcJBoLBMP8?=
 =?us-ascii?Q?lPsKl955tKjQMHBL1FVJgkaon0n2GP/HEqZPHMZD/BBfRChMQvZj6Nka4uw4?=
 =?us-ascii?Q?rxWHS2yFSKPrKNsuqArkYoQkT3sQKnJq9/IFnU7ASjFsHNi8dKIiOUnay7LG?=
 =?us-ascii?Q?iEtWZrOxcWsFfKpiM6N5bHOZ8EmfVKzOWjIjh3oLE4D3JyYHQAi0eTbfSDZe?=
 =?us-ascii?Q?tMNvelcO57lyS0Qng9ME25Tn32bAEgo1LWkdJdUEpe2gWV1JU5rwko5pYfFe?=
 =?us-ascii?Q?MczGJtzR4OI+s6F82u6kgj/KlDr06rPLe4llcJstNI0HDl8jOCrk0OOrxnfC?=
 =?us-ascii?Q?I2QPrqvRDPoZ5RcOfM/PoZxuNfxb+9XFYiYXnWoWfJ6kn1qnJM3r1MhWSC/+?=
 =?us-ascii?Q?qCRBfTHcCUZn3U+8UItAFgZcK3uXR7cv3rS7o6LC5UOqdWOlR4vOX0fJVtBT?=
 =?us-ascii?Q?ROIbpyoPLEeXjeSdK75jt7/MRNZyNwVAD7+dLHOQIvregaXa0Hhcp/UyW1RC?=
 =?us-ascii?Q?ISyzdsmBdjftiHdI70PprZmyInlQGYLNvvFiHsrW0VeasFEgbuKLjSRIkn6L?=
 =?us-ascii?Q?qz3Wm+Puilff4xrjwTNv9PYqWPePYMXWTpWyH2jXc9xeI4GFAfGX8V9og7zI?=
 =?us-ascii?Q?f7mGgQn09pjIRjEJdNLhvo27L64cKVAPG3OHR5tYeea4HpUdHr/IlwU9Fsh1?=
 =?us-ascii?Q?6c7mDtNe9fhdnY7/r5XdL7sZ+ZkOqQws96LXRUfWvD0u8Rh7RyHc/0sHUEk8?=
 =?us-ascii?Q?VrM56gT0+DZOYKL2vbxNvnoEgUgPTUmUGNjSVIhiQa5AWKQvCUWLG1LWosoB?=
 =?us-ascii?Q?AnHQlkYRi0FZSJJivIjGCPul?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12325bac-72ff-4b0b-42a8-08d950c68921
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:48.5554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: plgyTF95XH1X3G9O3+Jicc9vrNDie6v7uI8KyNE+Vi4NaETEQbCUN7jYHGJQ/EwAZaqYAnO6KtisMAHHnbjlx2tpm4H5Kd/8IK/dkHETXA4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2791
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-GUID: sscCaEK9B-zPvwaj_xf3e1Pxh3L2AxAZ
X-Proofpoint-ORIG-GUID: sscCaEK9B-zPvwaj_xf3e1Pxh3L2AxAZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds an error tag that we can use to test delayed attribute
recovery and replay

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/inject.c           | 1 +
 libxfs/defer_item.c   | 6 ++++++
 libxfs/xfs_errortag.h | 4 +++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index b8b0977..53286a3 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -58,6 +58,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_REDUCE_MAX_IEXTENTS,	"reduce_max_iextents" },
 		{ XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT,	"bmap_alloc_minlen_extent" },
 		{ XFS_ERRTAG_AG_RESV_FAIL,		"ag_resv_fail" },
+		{ XFS_ERRTAG_DELAYED_ATTR,		"delayed_attr" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 41cf921..6db4380 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -135,6 +135,11 @@ xfs_trans_attr_finish_update(
 	if (error)
 		return error;
 
+	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_DELAYED_ATTR)) {
+		error = -EIO;
+		goto out;
+	}
+
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		args->op_flags |= XFS_DA_OP_ADDNAME;
@@ -149,6 +154,7 @@ xfs_trans_attr_finish_update(
 		break;
 	}
 
+out:
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index a23a52e..46f359c 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -59,7 +59,8 @@
 #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
 #define XFS_ERRTAG_AG_RESV_FAIL				38
-#define XFS_ERRTAG_MAX					39
+#define XFS_ERRTAG_DELAYED_ATTR				39
+#define XFS_ERRTAG_MAX					40
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -103,5 +104,6 @@
 #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 #define XFS_RANDOM_AG_RESV_FAIL				1
+#define XFS_RANDOM_DELAYED_ATTR				1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.7.4

