Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3FCC43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 09:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbiFKJmb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 05:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbiFKJmS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 05:42:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DBAB7B
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 02:42:14 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B1hwNp021516
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=71FNKC6gJofw7JsGgD8hs/h5FiBURuRad75YEhhgECY=;
 b=X8w2GGPCGPfmzaDUnvIDmHcpp83mVUFvYKcCyv4MSynuu0xwlo2xaBYm2tUAAsVV8u1L
 Cx0OfoSnJUdaKHcCmYeu36MqW8pqGOjMxduR+PUDiE2bED20rUkF0h1C/Zhs9TY73Mbs
 vARVdFEXT+XJN3oftQnEMh62i+zy1jgrPwSv/WJbbSvXlydLdJDEhwXedhtHqloLiyJn
 1itobxpBgbrtwYNnSbaDozCskhSFcnBdP9rMthSioS9gchSBXuvo6Rt1lrKL7kEWV/RA
 JYZy13JxiDkq455d6r44mwHAtVTpYBCxsu+Q0BGz9PQvuQpunsX08DdfiEbXUTmWLVPG 5w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhn08c72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25B9auec021864
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gmhg04unh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bym6ncHQRqpvaRefvo6b0nHz1mVxpdOqsrpRqCMBGJZifUHJMZYfjshissJn3oYozOnNu3CVnh3qZD4mGDfLY8lE9dvnKHU7XG4LNTaSq4owmcnz3M7LF/reOZ4wyUIsLn1JwjLxDAxLqKQZyEbu8kQez6WdX+VONe8OEx4nzV0Mh1q0s7Oh2tnMvd0n8TqrZnlqlXwXZdm1wIJPsce2r8ugPjCktPPm5Qo4mGf2h/JJn6q9CVB3pdEHdBFS3maQWnX8VdbdmwW+h0Ta8VhlCU/iXckwKaX5gC2nsImrtwuq4jnkuI/+m+V1BnnCniinsZBF0i5NJBoA3JYmVamhcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71FNKC6gJofw7JsGgD8hs/h5FiBURuRad75YEhhgECY=;
 b=DoXkFme+1Xnz5z0ua/nHcFyRdZ0GW1J3sIzkGgARHZiLIS0tmrzQtRZKrodhAlWAlm+MyqLMfNjv8vjJSpjXEzvjZ//O0dY5uzQ3FqF/DpVMKfTf3pByEUdy0D2J1rO0SQYDdWQ3CvXd8sycaL+6nWOCMK+HJOTjcKIg5TveGbaCZB05134T/PIUyDEz0LbcqsXTgMwAc9qAcz9fN2LEFHnCN9aofrEXYFKeHCfLtKrWAq2nSOTFhhC3z+Rsd4XRMWO1QGozI2CSo85PSrNa7ax/BDbb1d9aF79ePKVSblougIzOzjMEJZyjepeEZ9QIshcu3hnEiRyhb5JQ+PlQew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71FNKC6gJofw7JsGgD8hs/h5FiBURuRad75YEhhgECY=;
 b=xcjJiSgRtg12zHUBHljC7sw5zLqQR1D78V/OpwP62WosTgS+67zMVrtIzpiscdB7XgaXe2GR0vZfBb26b5UwDw5QR7CyaxSHwliBkM5vAitbDZi14LwR0AhxhkylAlxTsommAHaFsTqVcMXERcWPYv2LtMlGGhEYFPk6mRwPgIo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3971.namprd10.prod.outlook.com (2603:10b6:a03:1f6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Sat, 11 Jun
 2022 09:42:11 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%7]) with mapi id 15.20.5332.013; Sat, 11 Jun 2022
 09:42:11 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 17/17] xfs: Add parent pointer ioctl
Date:   Sat, 11 Jun 2022 02:42:00 -0700
Message-Id: <20220611094200.129502-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220611094200.129502-1-allison.henderson@oracle.com>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc459984-1a13-4e8e-47e3-08da4b8ea84e
X-MS-TrafficTypeDiagnostic: BY5PR10MB3971:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB39711DA29A14C446587C025195A99@BY5PR10MB3971.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8xRWkNNOx8rtxZabamSWl1LbM4naVyXidazErSbO4W74GDPOBRvWmxiyQFs9ddbc0qcjNXs7iKUrsJ9owvZQhhWygWaMa0/jFN6ZxhT/tTs4tGp5wvEeRwjIK5bFlNeXJ5xHqvaPhv0qFDADdJFoBgqrKSufi5kFsfWgXM1jyDZEJHzgsuNPOYRTzjYVNl9va9RKNNuoM2AxrFffIrN+uoqhwnPuK2c6jGgGSTcdqTsFta6n1H+VIJ0CQwL2kFB3DhBzZ1jMbHvQUFMdoFO0abZoDgwIKwJ3cXeYmhPFvyMGhLAq59v4iPRpThTy98kMtzWZjpdTV0fiLyLwloecnXXsqGeEhOZhctWGqnYRqYvq54KfTs1E7r82ffZlJpMLFroUxn7X3qPJ/HIkBhwGNC88nZE4Yoa/gjf+KStY2GShYn4nKwbvdPHz+RemefGoSonwL4sd43s7C6dgZXA43Kf9nY12jTyLLx4wntQLvjP/GDLMeaIa3NRc8JGOt1s2GNtcV+nmIV6cI5JjZpNM3MCtAJckpoT++U+MZHOb23kKPgZ+zdzx/miK8y7wL0RAA7NyRZZtgDDdJNXJRclq8Q/dsErohTwlPWXUYnCGUppVoRxKEkNjLEuin7quLgROZ7+pXplKFhQw8+QOllb197LcJOlOaIwtrhV+n3Ik4zXuQ/cKJB9Y5oBgiUE/UmPiEtQXcYp8YkVQ2GfnaHr161bkJH5wVhdGQ3iuO31vlHY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(1076003)(2616005)(83380400001)(8676002)(52116002)(86362001)(186003)(316002)(6916009)(66556008)(66946007)(66476007)(44832011)(26005)(30864003)(6666004)(6506007)(6512007)(8936002)(508600001)(5660300002)(6486002)(38350700002)(36756003)(2906002)(38100700002)(2004002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HQWD6K4EehyUF7rdJZ1LBC5qEA6NoCMfR7j1z0ZtI8ZUcOibBz5Sz2EDbzvT?=
 =?us-ascii?Q?xYqKRHEqoPICF3GLb025N0fTEcjDXpt9b44tWST7zk9CnyWsosxV+x3IAxKE?=
 =?us-ascii?Q?OVfce/BjZF3oZ6VOc9xRdh98P9aTcp2EHfIMYEXAn5O0GOe1uipgduaQEKPh?=
 =?us-ascii?Q?Xhk3SFkiGUzEOcZfMpm5+qGXKMkLIl/+Ecmghs3EakAaYyk02ttypOlU9CGe?=
 =?us-ascii?Q?xX0E8yGtwBW4XmEhA3G19HtA1LhsfNr5dCuzL7RCUlXkTazf+hc80SBDXoAG?=
 =?us-ascii?Q?ZyGBMFeV/ItsxHLboorVFFHR1XXZSTrkQtWg4mmi7akD+/C+AwO2r5MfZG8e?=
 =?us-ascii?Q?Cir5Bxy4dzBQB2XS7j5rZsrR5epAB3THc8thVXTREro4YBF6B1ZhxhOcuk8I?=
 =?us-ascii?Q?E3sVwHsWzw069gVQyhYEuRRa8BBEYKWcK2A5fjjOpaHPj7dU4rzlpBy+vy2V?=
 =?us-ascii?Q?lOjMkCdRDj9J8qet4NOnNSyDiTwchGPqJ54Wn/0XEr5xEUZb/9uM5fhYIqZ6?=
 =?us-ascii?Q?HrtrnE1bmxlYAqJ7AZjw9fBDxyT1SP8guOKNM4Lg/giF9Ib4VyNnr49K1mdS?=
 =?us-ascii?Q?uVgVf4AaeDeyQR6o9PrqnJPwHabHJW51sfKPCJoxunCqDvPE4AScsc5L7zhW?=
 =?us-ascii?Q?iykExz1+j49Nw8oET+N//5uvEEyDQWxhpHf9kHPqK5BRnI7AjLkQFpHBOsBp?=
 =?us-ascii?Q?atJGUw71WoT59TUkgxwDmQcoCB+g03amF8aMY/yVSSrNI9PswRKGuJkmXjoS?=
 =?us-ascii?Q?wc3tlr3+MVORO1l70IChPuI1lMZj1YoCzivdDTDuKNxVwCw43WskvNfdwXCf?=
 =?us-ascii?Q?iPvcZqXR9h/G9kmRIazkf+6rWEMh+5hgxZhVtZOGlr1xpt0aj7S2IO97dSM5?=
 =?us-ascii?Q?QMqncgq3Wl1zmFI1WoNqlYKvQDNA1CbtmPJk7mQUWU9UFQkLXd/JUTz9eGhv?=
 =?us-ascii?Q?eKW0Xn5+ZBxkAxEUJViUIx1o85pDQpumXZTKOj4xgx2egcI0WRlPgzq/Bgp9?=
 =?us-ascii?Q?A94dEnwISk/lMlM8aDYjwnrcBEh3PZpr7560pKnn4kCwT5Hfq0nJZOCnKCw+?=
 =?us-ascii?Q?9d/AuG7tK9PN6/5cZfG5Ni3XfDJp4KpxDi0r05kOd1tgpyPTIL66PkAjMnIC?=
 =?us-ascii?Q?pt/fUJrEelBtvXHxTi5GIuK3y50golBu2Ls1soATFH6l3akMHoPRoms6b4o6?=
 =?us-ascii?Q?KtJFFofPqCnHiDk9l2gZBgKDi86YThjxyf3z+hwtwekBo4vC8DMF7dLU4Vq6?=
 =?us-ascii?Q?Qtj6IpkwcbhJyuxMgoYDB+dkyIqWuN15NCUjXf5geumEpIY34uvh4IVuT3Ib?=
 =?us-ascii?Q?iipfUb24Q60uSdQxY27ryeKbjI17muq8wq1/EgLiryz0UgfLcf9etK4Tig0t?=
 =?us-ascii?Q?evAWClYLaN0UUl4Dmbxvqbdwi8aPtMJPCP435zcsuf/vq0d0HD5MHAo1HT9R?=
 =?us-ascii?Q?27v9NqkRG/RsEofqR5xYdT4cNVJ8y95BAIjiqBbsjgcwYm6QUe2yJLPfhmQG?=
 =?us-ascii?Q?vHriU0ctYaC/Sx7XWELvj+ywDPrR6w6trmdvOza4aCnBrIC1ti4HNdW6695N?=
 =?us-ascii?Q?D7E6vgjx+NLC/wdpzzMaY6ug7S4fA04XXu4QoDViSqaFo1z7DIS1JPxD2Ucq?=
 =?us-ascii?Q?e2M6qfK8lAJiO+GAzmjKxLr/VWgMZta1G3yPZ5a9gYjl3JucwcvSjEZMci1+?=
 =?us-ascii?Q?UYCdFEhp0G/aYF037DIFao28PtzmhRBm8PjqrWSKTyQv2U449/M+8J/1xgMs?=
 =?us-ascii?Q?z9rro67Z7o4sN1Um3fRTlYrkhAPyPQM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc459984-1a13-4e8e-47e3-08da4b8ea84e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 09:42:10.8581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hwV4hVc6dCdksZrO4x8gZC9C6duhQwBEvET3/tUXVpuC0OJhA1E6JGXZnePhZY5VeGf8tUna0jQfQ0NEkdFoeHBfWXDUu1lxISMO4SmmGw0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3971
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_04:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206110038
X-Proofpoint-GUID: EyvZB3S4Ohjsalga5QTUFuGyJ76AUsS3
X-Proofpoint-ORIG-GUID: EyvZB3S4Ohjsalga5QTUFuGyJ76AUsS3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a new file ioctl to retrieve the parent pointer of a
given inode

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile            |   1 +
 fs/xfs/libxfs/xfs_fs.h     |  46 +++++++++++++
 fs/xfs/libxfs/xfs_parent.c |  10 +++
 fs/xfs/libxfs/xfs_parent.h |   2 +
 fs/xfs/xfs_ioctl.c         |  90 ++++++++++++++++++++++++-
 fs/xfs/xfs_ondisk.h        |   4 ++
 fs/xfs/xfs_parent_utils.c  | 133 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_parent_utils.h  |  22 ++++++
 8 files changed, 306 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index fc717dc3470c..da86f6231f2e 100644
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
index b0b4d7a3aa15..e6c8873cd234 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -574,6 +574,7 @@ typedef struct xfs_fsop_handlereq {
 #define XFS_IOC_ATTR_SECURE	0x0008	/* use attrs in security namespace */
 #define XFS_IOC_ATTR_CREATE	0x0010	/* fail if attr already exists */
 #define XFS_IOC_ATTR_REPLACE	0x0020	/* fail if attr does not exist */
+#define XFS_IOC_ATTR_PARENT	0x0040  /* use attrs in parent namespace */
 
 typedef struct xfs_attrlist_cursor {
 	__u32		opaque[4];
@@ -752,6 +753,50 @@ struct xfs_scrub_metadata {
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
+/* Get an inode parent pointer through ioctl */
+struct xfs_parent_ptr {
+	__u64		xpp_ino;			/* Inode */
+	__u32		xpp_gen;			/* Inode generation */
+	__u32		xpp_diroffset;			/* Directory offset */
+	__u32		xpp_namelen;			/* File name length */
+	__u32		xpp_pad;
+	__u8		xpp_name[XFS_PPTR_MAXNAMELEN];	/* File name */
+};
+
+/* Iterate through an inodes parent pointers */
+struct xfs_pptr_info {
+	struct xfs_handle		pi_handle;
+	struct xfs_attrlist_cursor	pi_cursor;
+	__u32				pi_flags;
+	__u32				pi_reserved;
+	__u32				pi_ptrs_size;
+	__u32				pi_ptrs_used;
+	__u64				pi_reserved2[6];
+
+	/*
+	 * An array of struct xfs_parent_ptr follows the header
+	 * information. Use XFS_PPINFO_TO_PP() to access the
+	 * parent pointer array entries.
+	 */
+};
+
+#define XFS_PPTR_INFO_SIZEOF(nr_ptrs) sizeof (struct xfs_pptr_info) + \
+				      nr_ptrs * sizeof(struct xfs_parent_ptr)
+
+#define XFS_PPINFO_TO_PP(info, idx)    \
+	(&(((struct xfs_parent_ptr *)((char *)(info) + sizeof(*(info))))[(idx)]))
+
 /*
  * ioctl limits
  */
@@ -797,6 +842,7 @@ struct xfs_scrub_metadata {
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
+#define XFS_IOC_GETPPOINTER	_IOR ('X', 62, struct xfs_parent_ptr)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index cb546652bde9..a5b99f30bc63 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -33,6 +33,16 @@
 #include "xfs_attr_sf.h"
 #include "xfs_bmap.h"
 
+/* Initializes a xfs_parent_ptr from an xfs_parent_name_rec */
+void
+xfs_init_parent_ptr(struct xfs_parent_ptr		*xpp,
+		     struct xfs_parent_name_rec	*rec)
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
index 10dc576ce693..fa50ada0d6a9 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -28,4 +28,6 @@ void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
 			      uint32_t p_diroffset);
 void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
 			       struct xfs_parent_name_rec *rec);
+void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
+			 struct xfs_parent_name_rec *rec);
 #endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index e1612e99e0c5..4cd1de3e9d0b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -37,6 +37,7 @@
 #include "xfs_health.h"
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
+#include "xfs_parent_utils.h"
 #include "xfs_xattr.h"
 
 #include <linux/mount.h>
@@ -355,6 +356,8 @@ xfs_attr_filter(
 		return XFS_ATTR_ROOT;
 	if (ioc_flags & XFS_IOC_ATTR_SECURE)
 		return XFS_ATTR_SECURE;
+	if (ioc_flags & XFS_IOC_ATTR_PARENT)
+		return XFS_ATTR_PARENT;
 	return 0;
 }
 
@@ -422,7 +425,8 @@ xfs_ioc_attr_list(
 	/*
 	 * Reject flags, only allow namespaces.
 	 */
-	if (flags & ~(XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
+	if (flags & ~(XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE |
+		      XFS_IOC_ATTR_PARENT))
 		return -EINVAL;
 	if (flags == (XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
 		return -EINVAL;
@@ -1672,6 +1676,87 @@ xfs_ioc_scrub_metadata(
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
+	ppi = kmem_alloc(sizeof(struct xfs_pptr_info), 0);
+	if (!ppi)
+		return -ENOMEM;
+
+	/* Copy the data from the user */
+	error = copy_from_user(ppi, arg, sizeof(struct xfs_pptr_info));
+	if (error)
+		goto out;
+
+	/* Check size of buffer requested by user */
+	if (XFS_PPTR_INFO_SIZEOF(ppi->pi_ptrs_size) > XFS_XATTR_LIST_MAX) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	/*
+	 * Now that we know how big the trailing buffer is, expand
+	 * our kernel xfs_pptr_info to be the same size
+	 */
+	ppi = krealloc(ppi, XFS_PPTR_INFO_SIZEOF(ppi->pi_ptrs_size),
+		       GFP_NOFS | __GFP_NOFAIL);
+	if (!ppi)
+		return -ENOMEM;
+
+	if (ppi->pi_flags != 0 && ppi->pi_flags != XFS_PPTR_IFLAG_HANDLE) {
+		error = -EINVAL;
+		goto out;
+	}
+
+	if (ppi->pi_flags == XFS_PPTR_IFLAG_HANDLE) {
+		error = xfs_iget(mp, NULL, ppi->pi_handle.ha_fid.fid_ino,
+				0, 0, &ip);
+		if (error)
+			goto out;
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
+			XFS_PPTR_INFO_SIZEOF(ppi->pi_ptrs_size));
+	if (error)
+		goto out;
+
+out:
+	kmem_free(ppi);
+	return error;
+}
+
 int
 xfs_ioc_swapext(
 	xfs_swapext_t	*sxp)
@@ -1961,7 +2046,8 @@ xfs_file_ioctl(
 
 	case XFS_IOC_FSGETXATTRA:
 		return xfs_ioc_fsgetxattra(ip, arg);
-
+	case XFS_IOC_GETPPOINTER:
+		return xfs_ioc_get_parent_pointer(filp, arg);
 	case XFS_IOC_GETBMAP:
 	case XFS_IOC_GETBMAPA:
 	case XFS_IOC_GETBMAPX:
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 758702b9495f..765eb514a917 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -135,6 +135,10 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
 
+	/* parent pointer ioctls */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_ptr,            280);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_pptr_info,             104);
+
 	/*
 	 * The v5 superblock format extended several v4 header structures with
 	 * additional data. While new fields are only accessible on v5
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
new file mode 100644
index 000000000000..9880718395c6
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.c
@@ -0,0 +1,133 @@
+/*
+ * Copyright (c) 2015 Red Hat, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation
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
+xfs_attr_get_parent_pointer(struct xfs_inode		*ip,
+			    struct xfs_pptr_info	*ppi)
+
+{
+
+	struct xfs_attrlist		*alist;
+	struct xfs_attrlist_ent		*aent;
+	struct xfs_parent_ptr		*xpp;
+	struct xfs_parent_name_rec	*xpnr;
+	char				*namebuf;
+	unsigned int			namebuf_size;
+	int				name_len;
+	int				error = 0;
+	unsigned int			ioc_flags = XFS_IOC_ATTR_PARENT;
+	unsigned int			flags = XFS_ATTR_PARENT;
+	int				i;
+	struct xfs_attr_list_context	context;
+	struct xfs_da_args		args;
+
+	/* Allocate a buffer to store the attribute names */
+	namebuf_size = sizeof(struct xfs_attrlist) +
+		       (ppi->pi_ptrs_size) * sizeof(struct xfs_attrlist_ent);
+	namebuf = kvzalloc(namebuf_size, GFP_KERNEL);
+	if (!namebuf)
+		return -ENOMEM;
+
+	memset(&context, 0, sizeof(struct xfs_attr_list_context));
+	error = xfs_ioc_attr_list_context_init(ip, namebuf, namebuf_size,
+			ioc_flags, &context);
+
+	/* Copy the cursor provided by caller */
+	memcpy(&context.cursor, &ppi->pi_cursor,
+	       sizeof(struct xfs_attrlist_cursor));
+
+	if (error)
+		goto out_kfree;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	error = xfs_attr_list_ilocked(&context);
+	if (error)
+		goto out_kfree;
+
+	alist = (struct xfs_attrlist *)namebuf;
+	for (i = 0; i < alist->al_count; i++) {
+		xpp = XFS_PPINFO_TO_PP(ppi, i);
+		memset(xpp, 0, sizeof(struct xfs_parent_ptr));
+		aent = (struct xfs_attrlist_ent *)
+			&namebuf[alist->al_offset[i]];
+		xpnr = (struct xfs_parent_name_rec *)(aent->a_name);
+
+		if (aent->a_valuelen > XFS_PPTR_MAXNAMELEN) {
+			error = -ERANGE;
+			goto out_kfree;
+		}
+		name_len = aent->a_valuelen;
+
+		memset(&args, 0, sizeof(args));
+		args.geo = ip->i_mount->m_attr_geo;
+		args.whichfork = XFS_ATTR_FORK;
+		args.dp = ip;
+		args.name = (char *)xpnr;
+		args.namelen = sizeof(struct xfs_parent_name_rec);
+		args.attr_filter = flags;
+		args.hashval = xfs_da_hashname(args.name, args.namelen);
+		args.value = (unsigned char *)(xpp->xpp_name);
+		args.valuelen = name_len;
+		args.op_flags = XFS_DA_OP_OKNOENT;
+
+		error = xfs_attr_get_ilocked(&args);
+		error = (error == -EEXIST ? 0 : error);
+		if (error)
+			goto out_kfree;
+
+		xpp->xpp_namelen = name_len;
+		xfs_init_parent_ptr(xpp, xpnr);
+	}
+	ppi->pi_ptrs_used = alist->al_count;
+	if (!alist->al_more)
+		ppi->pi_flags |= XFS_PPTR_OFLAG_DONE;
+
+	/* Update the caller with the current cursor position */
+	memcpy(&ppi->pi_cursor, &context.cursor,
+		sizeof(struct xfs_attrlist_cursor));
+
+out_kfree:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	kmem_free(namebuf);
+
+	return error;
+}
+
diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
new file mode 100644
index 000000000000..0e952b2ebd4a
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (c) 2017 Oracle, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation Inc.
+ */
+#ifndef	__XFS_PARENT_UTILS_H__
+#define	__XFS_PARENT_UTILS_H__
+
+int xfs_attr_get_parent_pointer(struct xfs_inode *ip,
+				struct xfs_pptr_info *ppi);
+#endif	/* __XFS_PARENT_UTILS_H__ */
-- 
2.25.1

