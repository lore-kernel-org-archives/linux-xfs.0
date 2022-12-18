Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA93C4167B
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiLRKEE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiLRKEC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:04:02 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B5565F8
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:04:01 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI5FLLO016670
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:04:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=tW4XcK4z08ZwBMsWp9AIWXwolRj0L0bDYr26ueWtvC0=;
 b=yb3wz6QR/7Xs/vqF5URVbs+8H0aUSY15d8v0NLTK8AsbsJ3BRbVo+jvq6UKH3b2UE9Jg
 rYwf2i5EsnerweB2klgxaI1gcVzldyvpeed4genXT9kbdJD4dxDLvydfW2sBuKsJk9wF
 I6lgC2IVRnIRA3G36ba/U7oO2NCcKeF9G/7VTKncM13JhYWeXwkLQJYUDevS0q6XN6da
 PtBCDhewoj+6ml1Lbo3heGp8SKYFwp5yKi/TehLf+7CUPN2Gj88UI22wIHMimkAL5NCS
 Kq/eRSpCk7YeYAXb3NKRqf1fq5ZoOe4G6Kx4q3oomBaKbqtguK8fs0cAfhWxD2dTzGGC 4A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tn1972-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:04:00 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI8JeXI024870
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:53 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh478mxs8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j++hBxVYqIEk7KeYJPbxEQaEo7Qu3deQVv7WuVX+HVzTvwTXNHNNreQBN85tCVHhxJ6O0l07EuTiAEyce9PrDryOM9HtWbaZmRyeyrjoXWyObhSNZevmx0jWCNtKyQ7NLrciq74P7afPkVYcByh7bEuH4M1yk7QiXkFhbQdvwiuD8awJabUgbrdqwGFVYB0GOohBwsE98V+TX8f8fQrC9ct9pj6NSN6D/v5TyXAQ405tSAUNLBFBdp96BAJgO9/tyv4mWwSglGimch9slhvkh+IrWZpfh1U3S4JSdnvkao1ZAVvFMjKTvKoP4Sc1Hp1arHLBOdZEeQIAunV5020HwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tW4XcK4z08ZwBMsWp9AIWXwolRj0L0bDYr26ueWtvC0=;
 b=YGudPqLce6UNHmcXyG9cEzm4Bh+8V1ff0zVxQTf5qEj5+GVd1kCPLnkteEN5Epr2BevZoA7+fuENMmnsvMQHjkvYU06BpSP3WTfQQxJauqb7rR7yqT+e14K63EB3gznSXCEDILhQ2uy6+GIf8gLmL3AYo3xSj1rk00eciAj9Hmxy8mpSq2hdyaG3DpoqOK0hIuU/UdNLuM1HnIuuCC4aejyd7tagsyZTDUiWzoVO+rHq1/sCI5+jUQJoVKOEm6PHdZF7G2bCE+6ePZw1asvayiIbUiEu7OJbgXAM2+b3ANF2cP/pnbMFUkG57HyakLjnftrFFKx2R+XcgNpSJVkYcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tW4XcK4z08ZwBMsWp9AIWXwolRj0L0bDYr26ueWtvC0=;
 b=PI/o6lZQrO8oPkD463hFUBIoD7h0cCqIE4i5C54NzfFlRKHjinIR6X3IRGNbRx27M7ACmZb0MsyryQiLuzOGvbplu3RUB2yuAFGuicfLPdjN5rpdXvCeCZcTDLLQBktTOY5kif0VQ/7B4sNrZaxrPJXp2Jbwy8+04yPOnrOhJ08=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by IA0PR10MB7181.namprd10.prod.outlook.com (2603:10b6:208:400::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:46 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:46 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 25/27] xfs: Add parent pointer ioctl
Date:   Sun, 18 Dec 2022 03:03:04 -0700
Message-Id: <20221218100306.76408-26-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0191.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|IA0PR10MB7181:EE_
X-MS-Office365-Filtering-Correlation-Id: 93e452bb-88b4-461f-9f1b-08dae0df26f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XS0VMEESsyuSzL+2j9/eqkqPmyM1TsakUQAG+M+n+oR10r+3QCzazlTyQGuVUYAbv7GrIFlWqWKqytJ2VSS6M5DtO0nQzyQvCy0Si1I3wNbBlQ1cQ4arZZ59UAjoHTqBewITRCvFQRpxQ48OjyfqVnFq49+mcjpRarYSCjhrwGBnjNT+z4eYUyspmatfWQJatatav/YIPGvmgeHrmwkqi/A2oQdH8ophZw7iwHZR+6SlhsF44DQwRAG5LjnBV7/SdbtirAaRMsWjSHtiQUG11HbuOLutBIh4tLnfVFKK6w/3TZPRBy+al1k57tBPXxz0TnIeJe1FBspzzU7pvBN9tzPCgfIuMqtAL6Uwl8Rk6Wzx6txpGCtsdqszu4bVOkW4sS8LadKwFKEsIRYI38CxerOUErlfS3MHme8Yvkzh/B+dtutK5rWlJiLETQ6lHvhILYxD7i0RUJu6Vqm0AHGLzGf/RAo0kHsM5u1BEG1NgEYqvpgGL0YuUL1g6uZ4rB9SxRfm7ujaygMjP+0YNBvNBqgPgYopuZLfX1D0ENMg5onXbYLaCciUxK4ft7whaG16BPsvpy1Uq7w/ip3noLYp8+sIf+v4A5kb7gwtmHNj/ocbw9XSuauD8fXSFIVh3VLDJabuM7vrOj8XgNDmVn5o1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199015)(30864003)(83380400001)(2906002)(41300700001)(8936002)(5660300002)(86362001)(38100700002)(36756003)(316002)(6506007)(6916009)(478600001)(6486002)(186003)(26005)(6512007)(66946007)(9686003)(2616005)(66476007)(8676002)(6666004)(66556008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nfQvM7jqLcMd7ZrI/iymAXktx44c1pryre+d7gUWQcZ7onf48CyfsmXNecf4?=
 =?us-ascii?Q?WsjAmnPnAWRQ8why7VmBKWHYgqjQlPQFZZRv9hIlm9W+2hI0C3ErzrEiqs91?=
 =?us-ascii?Q?dspZC3fhYcIDNkycYHU7JpKEwx1/q7Ht9Da8jznSRxH1dEjPCZA1YTx+u0X5?=
 =?us-ascii?Q?NZ/zeFSGNvmYJvZkw0dI+Jn3sDZQDtlx7LTyY6hzTgPpvlrxz7CGoxjLi4ei?=
 =?us-ascii?Q?zDmx58Lpywhtm7Bn2DGUlxUiCZTz6ls2foX3GRZK/2G+ikTtqGJrUGevA3rE?=
 =?us-ascii?Q?RpGGi8S+JkMUMtnAETjkKKdlAnsqfPd9kKqX/PS3/ouDRoLlsEn52+dq1IKS?=
 =?us-ascii?Q?DhlZak7vnZtUhEJ3SZs846msXVXpRZ+8SAOOEGnyjYEGUezDvrprJTKhdPTz?=
 =?us-ascii?Q?VTu2vnKDf5P8s9T5JC1m3XtrLf30NohPoOp0eka6ij1bsNc3B7JRQ+/+dd2N?=
 =?us-ascii?Q?sIdxKw2tb+TX45zYNt6LBQvqn2+9vKC4gly5SJmMsNOP9rX5W7eHI4+aasM9?=
 =?us-ascii?Q?NZInkaMGUg6Rdg2T+9FmesookUippKS2XPMETgl7c6uSkLgf7jBekmKgpzJE?=
 =?us-ascii?Q?a2Kk7W1nYTpng86EmA7dEf3LHos45S7nH0QSyTwu8ntSvhoNvzagTieB4Cht?=
 =?us-ascii?Q?ULgiUosetkUqEkOb+2KsRdX0zqXszrG1mEHP5COPDY+ijxjFRUd4pSUE60pr?=
 =?us-ascii?Q?RYkRTxdUOEnt/8V4MxVSZNBcZPLzw3ghFnt53Ai03ZSrTvJLVeI5piSjfnyZ?=
 =?us-ascii?Q?pgiXXgT0bV6FVrYEl3ejWlTRJhXPWQgzAmDXnAA6TXwILHpdagTyZ2syfDDA?=
 =?us-ascii?Q?V9loy8sIlA0of/Xd3209+coxaoetN+QFN54Io/AAL2CK9TOtq6zDVW6NTJTy?=
 =?us-ascii?Q?p5fam1t3FLd/Yu0ETX3kd4CCrpTAMYK5Iwmi7ldbqP/9zEHIMbIbqWshFtaX?=
 =?us-ascii?Q?4b9FI6iY23CbQZR9ycxk/JRMQ9Ez4j4e/WpgDfmFT3Q1gLZUCuwutsCtSDG1?=
 =?us-ascii?Q?RPWJ19U3W5cNz89FREklePWF803IM3MnaDifUHOQXDN4lseYHk2LnhvS4h+O?=
 =?us-ascii?Q?K2qf1XTav2lV4wiIj64HAUqvCTmTYTnMjJT6YM6cASCnyr/PptxqVFp2dh7b?=
 =?us-ascii?Q?XiDkuQ2KbLvR/q0kDaO/Gx69okrTzclXn0rTZORgMhJ0ZuQisYNxdbl4VUgg?=
 =?us-ascii?Q?4fE2ui1d/k5zMIFTfpZ+Z1lRn1kzQ04X1SzqhxXtmceRIM21kPU9gvdabk21?=
 =?us-ascii?Q?43wqNFCuHVx6u+BbSmFRPXgWQiGL4ygF5RuH+IXYIXM019PSZozcmdbllsyl?=
 =?us-ascii?Q?pvazJbMgEZFkVsUL/Sy7UZD9Ev5apDN+87KkFbWS3XQWXLbN5HedH3wW5Nt4?=
 =?us-ascii?Q?fUS5K3aWqX7pjjPT5sXo8+VMwOuW5Eu/StgAc/lH0qGn4hXknWJ6nksG8h6Y?=
 =?us-ascii?Q?o072tQg+ahpGRxqFFK+QeNDsEPu4vMDGU3hkknZOYyfhzfHYPDVRTL/gRX7X?=
 =?us-ascii?Q?/u9WsMDGMpcC91DuHCCoo2HHyXdRz1O0UCL5HXySFuOng5cWJDFtGBr3Ost+?=
 =?us-ascii?Q?ra5DzeE3If0CWBvZEDPsdJKcf1YQ7I+vrfsw5oSBy+Ooa48iiOlwQvdov0XD?=
 =?us-ascii?Q?Lw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93e452bb-88b4-461f-9f1b-08dae0df26f3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:46.3112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9v8CRRr4fO+22lUAn8MHVUrvKO1Mq1GRPidRKlzPsM7/G539y05Qhy4fgZNhpRFRiqBKZXK2mRk1aLzXGjWH4prz3t5ikaWj6vC7mGXebRE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7181
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212180095
X-Proofpoint-ORIG-GUID: pvVliNZBctqHCSvUHYbaDvNmZT0hm4t7
X-Proofpoint-GUID: pvVliNZBctqHCSvUHYbaDvNmZT0hm4t7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a new file ioctl to retrieve the parent pointer of a
given inode

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile            |   1 +
 fs/xfs/libxfs/xfs_fs.h     |  74 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.c |  10 +++
 fs/xfs/libxfs/xfs_parent.h |   2 +
 fs/xfs/xfs_ioctl.c         |  94 +++++++++++++++++++++++++++-
 fs/xfs/xfs_ondisk.h        |   4 ++
 fs/xfs/xfs_parent_utils.c  | 125 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_parent_utils.h  |  11 ++++
 8 files changed, 320 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e2b2cf50ffcf..42d0496fdad7 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -86,6 +86,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
 				   xfs_pwork.o \
+				   xfs_parent_utils.o \
 				   xfs_reflink.o \
 				   xfs_stats.o \
 				   xfs_super.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b0b4d7a3aa15..9e59a1fdfb0c 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -752,6 +752,79 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
+#define XFS_PPTR_MAXNAMELEN				256
+
+/* return parents of the handle, not the open fd */
+#define XFS_PPTR_IFLAG_HANDLE  (1U << 0)
+
+/* target was the root directory */
+#define XFS_PPTR_OFLAG_ROOT    (1U << 1)
+
+/* Cursor is done iterating pptrs */
+#define XFS_PPTR_OFLAG_DONE    (1U << 2)
+
+ #define XFS_PPTR_FLAG_ALL     (XFS_PPTR_IFLAG_HANDLE | XFS_PPTR_OFLAG_ROOT | \
+				XFS_PPTR_OFLAG_DONE)
+
+/* Get an inode parent pointer through ioctl */
+struct xfs_parent_ptr {
+	__u64		xpp_ino;			/* Inode */
+	__u32		xpp_gen;			/* Inode generation */
+	__u32		xpp_diroffset;			/* Directory offset */
+	__u64		xpp_rsvd;			/* Reserved */
+	__u8		xpp_name[XFS_PPTR_MAXNAMELEN];	/* File name */
+};
+
+/* Iterate through an inodes parent pointers */
+struct xfs_pptr_info {
+	/* File handle, if XFS_PPTR_IFLAG_HANDLE is set */
+	struct xfs_handle		pi_handle;
+
+	/*
+	 * Structure to track progress in iterating the parent pointers.
+	 * Must be initialized to zeroes before the first ioctl call, and
+	 * not touched by callers after that.
+	 */
+	struct xfs_attrlist_cursor	pi_cursor;
+
+	/* Operational flags: XFS_PPTR_*FLAG* */
+	__u32				pi_flags;
+
+	/* Must be set to zero */
+	__u32				pi_reserved;
+
+	/* # of entries in array */
+	__u32				pi_ptrs_size;
+
+	/* # of entries filled in (output) */
+	__u32				pi_ptrs_used;
+
+	/* Must be set to zero */
+	__u64				pi_reserved2[6];
+
+	/*
+	 * An array of struct xfs_parent_ptr follows the header
+	 * information. Use xfs_ppinfo_to_pp() to access the
+	 * parent pointer array entries.
+	 */
+	struct xfs_parent_ptr		pi_parents[];
+};
+
+static inline size_t
+xfs_pptr_info_sizeof(int nr_ptrs)
+{
+	return sizeof(struct xfs_pptr_info) +
+	       (nr_ptrs * sizeof(struct xfs_parent_ptr));
+}
+
+static inline struct xfs_parent_ptr*
+xfs_ppinfo_to_pp(
+	struct xfs_pptr_info	*info,
+	int			idx)
+{
+	return &info->pi_parents[idx];
+}
+
 /*
  * ioctl limits
  */
@@ -797,6 +870,7 @@ struct xfs_scrub_metadata {
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
+#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_parent_ptr)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 954a52d6be00..fa3d645731a9 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -27,6 +27,16 @@
 #include "xfs_parent.h"
 #include "xfs_trans_space.h"
 
+/* Initializes a xfs_parent_ptr from an xfs_parent_name_rec */
+void
+xfs_init_parent_ptr(struct xfs_parent_ptr		*xpp,
+		    const struct xfs_parent_name_rec	*rec)
+{
+	xpp->xpp_ino = be64_to_cpu(rec->p_ino);
+	xpp->xpp_gen = be32_to_cpu(rec->p_gen);
+	xpp->xpp_diroffset = be32_to_cpu(rec->p_diroffset);
+}
+
 /*
  * Parent pointer attribute handling.
  *
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 9021241ad65b..898842b4532d 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -24,6 +24,8 @@ void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
 			      uint32_t p_diroffset);
 void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
 			       struct xfs_parent_name_rec *rec);
+void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
+			 const struct xfs_parent_name_rec *rec);
 int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 01faef8ad1fe..2e56762e8de7 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -37,6 +37,7 @@
 #include "xfs_health.h"
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
+#include "xfs_parent_utils.h"
 #include "xfs_xattr.h"
 
 #include <linux/mount.h>
@@ -1675,6 +1676,96 @@ xfs_ioc_scrub_metadata(
 	return 0;
 }
 
+/*
+ * IOCTL routine to get the parent pointers of an inode and return it to user
+ * space.  Caller must pass a buffer space containing a struct xfs_pptr_info,
+ * followed by a region large enough to contain an array of struct
+ * xfs_parent_ptr of a size specified in pi_ptrs_size.  If the inode contains
+ * more parent pointers than can fit in the buffer space, caller may re-call
+ * the function using the returned pi_cursor to resume iteration.  The
+ * number of xfs_parent_ptr returned will be stored in pi_ptrs_used.
+ *
+ * Returns 0 on success or non-zero on failure
+ */
+STATIC int
+xfs_ioc_get_parent_pointer(
+	struct file			*filp,
+	void				__user *arg)
+{
+	struct xfs_pptr_info		*ppi = NULL;
+	int				error = 0;
+	struct xfs_inode		*ip = XFS_I(file_inode(filp));
+	struct xfs_mount		*mp = ip->i_mount;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* Allocate an xfs_pptr_info to put the user data */
+	ppi = kmalloc(sizeof(struct xfs_pptr_info), 0);
+	if (!ppi)
+		return -ENOMEM;
+
+	/* Copy the data from the user */
+	error = copy_from_user(ppi, arg, sizeof(struct xfs_pptr_info));
+	if (error) {
+		error = -EFAULT;
+		goto out;
+	}
+
+	/* Check size of buffer requested by user */
+	if (xfs_pptr_info_sizeof(ppi->pi_ptrs_size) > XFS_XATTR_LIST_MAX) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	if (ppi->pi_flags & ~XFS_PPTR_FLAG_ALL) {
+		error = -EINVAL;
+		goto out;
+	}
+	ppi->pi_flags &= ~(XFS_PPTR_OFLAG_ROOT | XFS_PPTR_OFLAG_DONE);
+
+	/*
+	 * Now that we know how big the trailing buffer is, expand
+	 * our kernel xfs_pptr_info to be the same size
+	 */
+	ppi = krealloc(ppi, xfs_pptr_info_sizeof(ppi->pi_ptrs_size), 0);
+	if (!ppi)
+		return -ENOMEM;
+
+	if (ppi->pi_flags & XFS_PPTR_IFLAG_HANDLE) {
+		error = xfs_iget(mp, NULL, ppi->pi_handle.ha_fid.fid_ino,
+				0, 0, &ip);
+		if (error)
+			goto out;
+
+		if (VFS_I(ip)->i_generation != ppi->pi_handle.ha_fid.fid_gen) {
+			error = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (ip->i_ino == mp->m_sb.sb_rootino)
+		ppi->pi_flags |= XFS_PPTR_OFLAG_ROOT;
+
+	/* Get the parent pointers */
+	error = xfs_attr_get_parent_pointer(ip, ppi);
+
+	if (error)
+		goto out;
+
+	/* Copy the parent pointers back to the user */
+	error = copy_to_user(arg, ppi,
+			xfs_pptr_info_sizeof(ppi->pi_ptrs_size));
+	if (error) {
+		error = -EFAULT;
+		goto out;
+	}
+
+out:
+	kmem_free(ppi);
+	return error;
+}
+
 int
 xfs_ioc_swapext(
 	xfs_swapext_t	*sxp)
@@ -1964,7 +2055,8 @@ xfs_file_ioctl(
 
 	case XFS_IOC_FSGETXATTRA:
 		return xfs_ioc_fsgetxattra(ip, arg);
-
+	case XFS_IOC_GETPARENTS:
+		return xfs_ioc_get_parent_pointer(filp, arg);
 	case XFS_IOC_GETBMAP:
 	case XFS_IOC_GETBMAPA:
 	case XFS_IOC_GETBMAPX:
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 9737b5a9f405..6a6bd05c2a68 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -150,6 +150,10 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_32, efi_extents,	16);
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_64, efi_extents,	16);
 
+	/* parent pointer ioctls */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_ptr,            280);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_pptr_info,             104);
+
 	/*
 	 * The v5 superblock format extended several v4 header structures with
 	 * additional data. While new fields are only accessible on v5
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
new file mode 100644
index 000000000000..0bca1814dcf4
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_ioctl.h"
+#include "xfs_parent.h"
+#include "xfs_da_btree.h"
+
+/*
+ * Get the parent pointers for a given inode
+ *
+ * Returns 0 on success and non zero on error
+ */
+int
+xfs_attr_get_parent_pointer(
+	struct xfs_inode		*ip,
+	struct xfs_pptr_info		*ppi)
+{
+
+	struct xfs_attrlist		*alist;
+	struct xfs_attrlist_ent		*aent;
+	struct xfs_parent_ptr		*xpp;
+	struct xfs_parent_name_rec	*xpnr;
+	char				*namebuf;
+	unsigned int			namebuf_size;
+	int				name_len, i, error = 0;
+	unsigned int			lock_mode, flags = XFS_ATTR_PARENT;
+	struct xfs_attr_list_context	context;
+
+	/* Allocate a buffer to store the attribute names */
+	namebuf_size = sizeof(struct xfs_attrlist) +
+		       (ppi->pi_ptrs_size) * sizeof(struct xfs_attrlist_ent);
+	namebuf = kvzalloc(namebuf_size, GFP_KERNEL);
+	if (!namebuf)
+		return -ENOMEM;
+
+	memset(&context, 0, sizeof(struct xfs_attr_list_context));
+	error = xfs_ioc_attr_list_context_init(ip, namebuf, namebuf_size, 0,
+			&context);
+	if (error)
+		goto out_kfree;
+
+	/* Copy the cursor provided by caller */
+	memcpy(&context.cursor, &ppi->pi_cursor,
+		sizeof(struct xfs_attrlist_cursor));
+	context.attr_filter = XFS_ATTR_PARENT;
+
+	lock_mode = xfs_ilock_attr_map_shared(ip);
+
+	error = xfs_attr_list_ilocked(&context);
+	if (error)
+		goto out_unlock;
+
+	alist = (struct xfs_attrlist *)namebuf;
+	for (i = 0; i < alist->al_count; i++) {
+		struct xfs_da_args args = {
+			.geo = ip->i_mount->m_attr_geo,
+			.whichfork = XFS_ATTR_FORK,
+			.dp = ip,
+			.namelen = sizeof(struct xfs_parent_name_rec),
+			.attr_filter = flags,
+		};
+
+		xpp = xfs_ppinfo_to_pp(ppi, i);
+		memset(xpp, 0, sizeof(struct xfs_parent_ptr));
+		aent = (struct xfs_attrlist_ent *)
+			&namebuf[alist->al_offset[i]];
+		xpnr = (struct xfs_parent_name_rec *)(aent->a_name);
+
+		if (aent->a_valuelen > XFS_PPTR_MAXNAMELEN) {
+			error = -EFSCORRUPTED;
+			goto out_unlock;
+		}
+		name_len = aent->a_valuelen;
+
+		args.name = (char *)xpnr;
+		args.hashval = xfs_da_hashname(args.name, args.namelen),
+		args.value = (unsigned char *)(xpp->xpp_name);
+		args.valuelen = name_len;
+
+		error = xfs_attr_get_ilocked(&args);
+		error = (error == -EEXIST ? 0 : error);
+		if (error) {
+			error = -EFSCORRUPTED;
+			goto out_unlock;
+		}
+
+		xfs_init_parent_ptr(xpp, xpnr);
+		if (!xfs_verify_ino(args.dp->i_mount, xpp->xpp_ino)) {
+			error = -EFSCORRUPTED;
+			goto out_unlock;
+		}
+	}
+	ppi->pi_ptrs_used = alist->al_count;
+	if (!alist->al_more)
+		ppi->pi_flags |= XFS_PPTR_OFLAG_DONE;
+
+	/* Update the caller with the current cursor position */
+	memcpy(&ppi->pi_cursor, &context.cursor,
+			sizeof(struct xfs_attrlist_cursor));
+
+out_unlock:
+	xfs_iunlock(ip, lock_mode);
+out_kfree:
+	kvfree(namebuf);
+
+	return error;
+}
+
diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
new file mode 100644
index 000000000000..ad60baee8b2a
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#ifndef	__XFS_PARENT_UTILS_H__
+#define	__XFS_PARENT_UTILS_H__
+
+int xfs_attr_get_parent_pointer(struct xfs_inode *ip,
+				struct xfs_pptr_info *ppi);
+#endif	/* __XFS_PARENT_UTILS_H__ */
-- 
2.25.1

