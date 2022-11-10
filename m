Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05957C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiKJVGi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbiKJVGe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:06:34 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D134AF21
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:06:32 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL0bY2006962
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=4M+pBw66Yvqg+vEgnEQ3LeOltQ4xPCg9tq8L0ftRoJI=;
 b=ACCEFOUQM+qGqr+Im1vw8+r24LiK+Nf0ndWngSFdE7vyXZV6pIzwwbvSzooyePhpGtxZ
 LTj5SdpMWD9oE1wNKOJY7XPSfrsSLPQJqLqki1ryZPkfWh8C3woFZRSPlzDQrfoClC6T
 DUOOZZeQ7ixyfIRb6YN4b8ZICD3JWqnfHg5mEXx3tMkpKtE+azRNr72zJlsy1INWkW6x
 n5cKE6RW2/crYnle0KFc/rgm6MVjE7l5nyi6BGMllsisjri9VekyqwAka1kTQnyLqaut
 Y2gI/J0ap2tW4CXoQBueXQjgydqJX8gNmmRgqO52hA9d9GsJTlhp/jJc2gwXar/wYAGg jA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8u5r1ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:29 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKdQqg009706
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:07 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq5hbdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IRbpN/rZcWLsgBHQiALdDaSpdVwzmJRLIsOkprKJ0voBt/qoLA10xWFrzN+CdLd2Guwrd0nwI6V39QNeZryHA5zrx8bltiff6/YdkUhBuleK23JzS2oXHD0arqe64EM6sImJNvAjsjD1l7uoVJlAnVcudMxR8F14FlTzZU86USEdho0tWfSiGJ1p0hDntPakRLss0zIKeQW6e0U3FJk+rma0GejEVj/rXzzDCGwluiJsqCKCGyLl8wELQaIhzdC/p61MOkp5P/4rheIi3QTtPhRsewF5ree0yEW/CWs7EXcN44sJCuuWSb4MFw+xlab31+oqbdFbiQnh4GOzMK4Rhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4M+pBw66Yvqg+vEgnEQ3LeOltQ4xPCg9tq8L0ftRoJI=;
 b=Pz5lxWfGrRI6RyaAXd8sp1SEYzpXJz6CV2hAL8gSkPZGI14Ez5aKVQaZN+5I1U1jOmF3nHs2Ycrfp5khTnE6ja4IaHFotgXBhIMA1iX82qTVj5cIEO6T4Pjc0B+7VmjW82nE6N5asglSbko/70PeWLSbl82S6a9s1ulk1fraFZmCg+qATHCt9R2kM0AU7Ays/M63lARXEvx8wIHD81cDSlBKGgAIz7Ad8hyLG4nJnKiYoKDExNgl96g1kaa3nts+9LkukZZ6Gp7tLJp5+mqRCYvHn+Fh9x3jBJtDAQiD0TOSe9lIHSzoQBoFIFBig9bqseTOBtvB8CcAyAD06D5Jmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4M+pBw66Yvqg+vEgnEQ3LeOltQ4xPCg9tq8L0ftRoJI=;
 b=cE+2WnKPcED8XATwsfKbqQn4EZudqYZO5l94ypCZIB6DhdxOxUBqVvhWGmzRsc/ddaB7FdA83wcfVT1tbxMJ+jI4QxGHn9E5iRAqFZNAVgYArmiM8Yxg0I8+AKhHZ2ZQFoWiaZDVigcKXHIbe4AQMdLTBpY9u47U25/Et69NTzk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA1PR10MB6318.namprd10.prod.outlook.com (2603:10b6:806:251::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:06:05 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:06:05 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 18/25] xfsprogs: Add parent pointer ioctl
Date:   Thu, 10 Nov 2022 14:05:20 -0700
Message-Id: <20221110210527.56628-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0121.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::6) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA1PR10MB6318:EE_
X-MS-Office365-Filtering-Correlation-Id: 037bcca1-5e8d-40e8-77d5-08dac35f61da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zE/dDKXXrg+GRM7+rx1JDVxQg2FUzXd1ExeiC/Wwryc1m5Oc80snWbdTcWAnm6AOTTQ7SzbduckmC0gCXdeXrVXfTryHWX+K58nZo5mWyxrXGLymjLAbR9w7yPXDocPwlsJmdWYxd34O+wg7tVKmA1yTH4H39nAcLGKgpnpKX+yrTNIESafi0+igbe103o0rTdoFAF7g+uKA+HnvMgcdoBtourfiid/zSGn9NFr2Az9YYWmPri7s7aKioqFuq2X/4gXhf9435ae0fIRzJJK8V4OuU+unlsUxNvJNvEfJUxSM9dxsHUCL4qAtQIOchGP+COK1S8BkS5ijejiptDwmATO5I2xTErpfmd2DiTdUvTANyAYlqZrv0ORaKi3HsVQYM+vKnZKOO4bsvxbPDI4QdMXWTCaPyOVBzWt/tO+taSefzUnK58Rbzh7lA313CCIuwdWfZFcTvgjnHG+6r32aqoxdxmeDhh3jpT+n8B9O4ns9TQA/rzojEZ0yQy2net8xzpmIfVo3aRPup/13Wq16rmuoeQHWvfOwBx7bvifMjCsJKFcaTVbREfLtx3fP6AmZM2n87ABTzjwax6NDV5Y9U32D5BPfjCHG8nrNMVya5hTWH0ZctKDkLqdoTxBgXhY5xKialTjGSR6ZBsRTHEnbtJOabXJqSKQkDElQ1Dn4rRMGThhnjQJHRAv5WTFZt2SGq+QLdWBU4fkzXF8HeaLpEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199015)(2906002)(6916009)(36756003)(66476007)(316002)(86362001)(6506007)(478600001)(9686003)(6512007)(26005)(8936002)(41300700001)(6486002)(5660300002)(6666004)(38100700002)(66946007)(8676002)(66556008)(83380400001)(1076003)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f+kMWY5lnEl3n4423d7uN+kfjPT9CNF47BIEmfGaOF8cqQcBs/TdFEFTgMN+?=
 =?us-ascii?Q?56siKrrClCgdJJKV+1c8SuOeL2dy5RGQHSW0qlfSEtH5s1ZUEsgmwXkL2ncY?=
 =?us-ascii?Q?xo4og5Qv1yTX/+IviKhA0PYVdx/WiWiK/yx71ocBpLvKSmSDLeguTXlxTXyI?=
 =?us-ascii?Q?OQrlD9t/fnA/3mtMLHX2ug0ruJ/Pom9JBHKk/vsvkdIMaRI4r7GEavb4dNhR?=
 =?us-ascii?Q?hP5J2bXqh/T4F4uCkHYqwuULmVQ1k/FcAWTNpz64GqkD2waohIKy7WPz8Yw2?=
 =?us-ascii?Q?5KoTGtF0sqIM6WSmydR+snSZ3uxzHxCb6w/uvB9tjskwbQgK0j+7KDbreYi4?=
 =?us-ascii?Q?loUv3WT8R0TJsj2GM/JvkZIsg6u2I9utA0drpk5d2y2OinBziuP8yMpRpxMj?=
 =?us-ascii?Q?wPtDjCWTSKNj0IztM7isgRG6wMpyAD4OlqDdCK4MGq1YuB8s0/mN0gOwcBWL?=
 =?us-ascii?Q?xrb4+4quFobNxO3qA9RZesUrfTpWUistAG+OvHwUuqjxxzTRMpUNbaMAXGV3?=
 =?us-ascii?Q?m2AnxgeCADnCo078G3eNIM1T97KKtfgx48NULliyu7mzHJskXYq36e6dNTUh?=
 =?us-ascii?Q?uN/KH4TLirix268+zzVlVjEzo2CgGpTb6mt+NXTFcWXBxtCmXnfhT7poVZ9u?=
 =?us-ascii?Q?Rawaax7Hea8Ka6O82r0XUSqgL6xzA+EP8ljikOm8jmbCkpNyJlAgdtEe45S6?=
 =?us-ascii?Q?F+407wf4CHRkEwWnTTTmQL3drtZePgCvYl5I26eRafIYMz4m3Mw20Lf/cLVy?=
 =?us-ascii?Q?yEpab9Ao1fpt1o9/8E/1Bi5znhSCHKWoZBqSqFR1diXPhzZ0rEP/nKSFcNWW?=
 =?us-ascii?Q?FefPD07zBoFqqwNFgnAG+7ZkXRwxd9FTk2cCuSDuWzqqn5VDlIczhm43/sos?=
 =?us-ascii?Q?ftlsnsFdIun4jgYrPi4RyrjChX5ptW3zMQE4+h37S0KR/A+0/zkRtsyStJPJ?=
 =?us-ascii?Q?5EfxWlTP0zIiTuYUaLUCmD8rxcNTy4NunSMmdAZpta6y3FIqCn9DKOEJUfNc?=
 =?us-ascii?Q?9IJSWsVnGfmfWzNez9gZYcAgv5phKJCc3ceK+hhoUYC8xNGukKvVt9pOiayw?=
 =?us-ascii?Q?SAwLPTH1eDAJeuqkFhf0osAcmHggccmowbMrsIEe9cvo/BKqZMnkVa4SBwmv?=
 =?us-ascii?Q?JD4vK1jouYtyrYe4NYJssavUdBDwZHXYaL+03hyteoCQV/+Z79GPM3iE9lUU?=
 =?us-ascii?Q?mbfhSKT2stMpy5eLE+cnb4tvz/Nf+13m1BPb1CHdaQs2Z5Pqw6cDcAydLiye?=
 =?us-ascii?Q?ViLx+GP+WsxNrjQphGKZFMg7IrfLIZj3H7lypXq/eyna/p3mGg4dGuKEif8R?=
 =?us-ascii?Q?PaRnQz8MXHtfy+8UFxiHo8I6xHXOVkR48l0LWyYYau+A3ag4szcq28z3yeaz?=
 =?us-ascii?Q?+fSLnNSegHirwKyX5Sl5KTNTCNqWpvVzgBuWOl9MeVwFnPE5tVWBTHU1tv2S?=
 =?us-ascii?Q?6NkUX9+hCZUUrQP5IuWHWw3cKFnIbvA5sotEP85oHTfBXYLbzrsm7cCqhEli?=
 =?us-ascii?Q?zMm42DduuGqhbiA+jI2BmWY+2C6uRU4l4iUky8UCoMOYtNkBwlopTDrzHxVV?=
 =?us-ascii?Q?rcJArHxalHUXM0dJntrbMrt5Rm5J9opAkWqOSoHEhoNT2/j1tdaWDn6eAAQp?=
 =?us-ascii?Q?2g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 037bcca1-5e8d-40e8-77d5-08dac35f61da
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:06:05.8155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jLHLYr0N3VayBk/5l0q289buEOQB4ldnd+dpJgPhKvnYs/L4N174406PUZcSeyLMZAn36zBw2dkpK0yXLVazBBdcb3sFJrSAg3q5uNZDsVA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6318
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-ORIG-GUID: tYAHDjDeXbQRk9RiWwE3o1nfvEgtKgSt
X-Proofpoint-GUID: tYAHDjDeXbQRk9RiWwE3o1nfvEgtKgSt
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 5e5cdd593342c5ff8aeef9daaa93293f63079b4b

This patch adds a new file ioctl to retrieve the parent pointer of a
given inode

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_fs.h     | 74 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.c | 10 ++++++
 libxfs/xfs_parent.h |  2 ++
 man/man3/xfsctl.3   | 55 +++++++++++++++++++++++++++++++++
 4 files changed, 141 insertions(+)

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index b0b4d7a3aa15..9e59a1fdfb0c 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
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
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index f9513cde3b01..2605704f854b 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -28,6 +28,16 @@
 #include "xfs_format.h"
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
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 9021241ad65b..898842b4532d 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -24,6 +24,8 @@ void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
 			      uint32_t p_diroffset);
 void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
 			       struct xfs_parent_name_rec *rec);
+void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
+			 const struct xfs_parent_name_rec *rec);
 int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 4a0d4d08d083..7cc97499e0ba 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -321,6 +321,61 @@ They are all subject to change and should not be called directly
 by applications.
 XFS_IOC_FSSETDM_BY_HANDLE is not supported as of Linux 5.5.
 
+.PP
+.TP
+.B XFS_IOC_GETPARENTS
+This command is used to get a files parent pointers.  Parent pointers are
+file attributes used to store meta data information about an inodes parent.
+This command takes a xfs_pptr_info structure with trailing array of
+struct xfs_parent_ptr as an input to store an inodes parents. The
+xfs_pptr_info_sizeof() and xfs_ppinfo_to_pp() routines are provided to
+create and iterate through these structures.  The number of pointers stored
+in the array is indicated by the xfs_pptr_info.used field, and the
+XFS_PPTR_OFLAG_DONE flag will be set in xfs_pptr_info.flags when there are
+no more parent pointers to be read.  The below code is an example
+of XFS_IOC_GETPARENTS usage:
+
+.nf
+#include<stdio.h>
+#include<string.h>
+#include<errno.h>
+#include<xfs/linux.h>
+#include<xfs/xfs.h>
+#include<xfs/xfs_types.h>
+#include<xfs/xfs_fs.h>
+
+int main() {
+	struct xfs_pptr_info	*pi;
+	struct xfs_parent_ptr	*p;
+	int			i, error, fd, nr_ptrs = 4;
+
+	unsigned char buffer[xfs_pptr_info_sizeof(nr_ptrs)];
+	memset(buffer, 0, sizeof(buffer));
+	pi = (struct xfs_pptr_info *)&buffer;
+	pi->pi_ptrs_size = nr_ptrs;
+
+	fd = open("/mnt/test/foo.txt", O_RDONLY | O_CREAT);
+	if (fd  == -1)
+		return errno;
+
+	do {
+		error = ioctl(fd, XFS_IOC_GETPARENTS, pi);
+		if (error)
+			return error;
+
+		for (i = 0; i < pi->pi_ptrs_used; i++) {
+			p = xfs_ppinfo_to_pp(pi, i);
+			printf("inode		= %llu\\n", (unsigned long long)p->xpp_ino);
+			printf("generation	= %u\\n", (unsigned int)p->xpp_gen);
+			printf("diroffset	= %u\\n", (unsigned int)p->xpp_diroffset);
+			printf("name		= \\"%s\\"\\n\\n", (char *)p->xpp_name);
+		}
+	} while (!pi->pi_flags & XFS_PPTR_OFLAG_DONE);
+
+	return 0;
+}
+.fi
+
 .SS Filesystem Operations
 In order to effect one of the following operations, the pathname
 and descriptor arguments passed to
-- 
2.25.1

