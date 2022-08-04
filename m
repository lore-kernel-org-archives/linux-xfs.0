Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA47C19F21
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 19:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiHDTkt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 15:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239285AbiHDTkg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 15:40:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB54213E0E
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 12:40:34 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HbOwG024330
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=ZWrlHGOewd2cgqOPgTr6KdsOfeP5SkK2XskQJx3JEQY=;
 b=1YPVs8F527l15+eMj6kcJ/jX85clMq63dJZGpdkGeESs81l1dVGMbqpejBrJpM/3xj4E
 V47m3HwYBBr4PWOvbpxdOt4C1D/A4Eb40P7UdDGZ09DsJ/G3XMQ6hrVePM2YM1BD8z1h
 IQ1KYWN5JZd+17+qdVNzut5rh7c4Q8W6tV/NxJca5Vo/JQUMNEYNx2oLcL2X2qKhd+gF
 A9rG4Zu4ecXtTD4BoGhZyFkhO+X3Rr+kN2mgD9+tGDyBrtjq+mAm9gvzSmI6CBJ+qcMy
 qPOKjXpmqMG3NHQmQuMHPmhv88FRwQvIxiITw9pOos37SzfHE7KW01b6emLgkWaWJYuf yA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmv8sdyqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:33 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274J7Jnp030850
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:33 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34mm40-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JBq8pYwbr+GXbNlBawCVkIktfbEBj0x/Qo+72F5RDI2QgnSlDgFu0sLGT0z0Pfc+Q5wjyyJr6snXS7ufXGdmcAswotv8wRnx70be8C3/JCvs6TFI4tWqUvUnRwfmfZ3JPs17kdR0qOci6pJAJQ+OwibMk9ktX25Ld19JuJYw5tVUANZ7OFg8BHLRSozh9THz0RVRtmg8JtRu6j8C8kNM5Z4fW1X6lT6J5slr73Swp3xcFU++1JwDhQ9MBmHFB7OpNWowIOZTYSom0j9IBP/NP7QoweYifLHhXE/JaIxc5D+4Kw7LnQh7apXRZSgkqEVCfhxG2uu7y6LFwwGDWc7new==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZWrlHGOewd2cgqOPgTr6KdsOfeP5SkK2XskQJx3JEQY=;
 b=KcKuT1XMt9z/dapq3ER3VrlNc11lg3YQksDwmwtoujnB3b8GGoo/NU3x9ChxYtjd+68ZIUgIySy2qyb2BjTsKKfOf8cN4Yyb5frQoVl8VmyTtaKR4t5vKlRICWSEPBNuvlWZNE83LzFzzgSNNPseAhBviWmG3a05PdWvWckeaoM2vgFB10DkpFHw7GEIBZ21rDV5gfXL151IpdcMTdL3vGItSzYHJ18uHia1tdc7rn+glo4ji5P/aHIqdCxvuEJOyJqq/6K8Ww6Q1wzryuJ7RH2thVQGPC2dTISXrsh34euDWGP3DWi8oj6ltL62MIBt4h6QyHeU6ZKh31pGEWCIdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWrlHGOewd2cgqOPgTr6KdsOfeP5SkK2XskQJx3JEQY=;
 b=IYKjpcHXy80Z4tYS8hoeGyux/Xb0YzO9L462HSQW68EyL+uUllWj085lDv6WKo8bc406Diwzc8sFm0wehLAOgO7FEGgPsIR9GgW/9SUdybGodQcfMlaAo/6R2jWV3aAZ1DSqUHqmpQGpdfVviHmMaUdfmCZMniDHc15CgbfzLb4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BLAPR10MB5011.namprd10.prod.outlook.com (2603:10b6:208:333::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Thu, 4 Aug
 2022 19:40:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:40:31 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v2 18/18] xfs: Add parent pointer ioctl
Date:   Thu,  4 Aug 2022 12:40:13 -0700
Message-Id: <20220804194013.99237-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804194013.99237-1-allison.henderson@oracle.com>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0198.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12387400-e745-4fe8-43b1-08da76512ea9
X-MS-TrafficTypeDiagnostic: BLAPR10MB5011:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cn+FM5EnPqItxbSXjMQIpNVmVhbvet9u03HSOboiqBeaUVvnQHhMspw5FE9U9dDE6/sZc3NdIeRQruwzh0ytl+IOwdIbd4rcTuK/ZRcSFbcU6Ef0TPy2f8oG61BAnAnGMEmVficP2/sfvpLB2Mq2VzB6JiTLMbaNGER/uRN3pyjIvIznQ7TZkV0HmEnxRF15r6oW2JskTnz1euG2rQTHW1Ox97mcfwXzKFwoPAbghwVNeQRTzbqVaB8yM0jia5MXQFb2uj3WIJuiCqgQGt6NJ4Gf8QNF6gxiQgvBdkmJDfsvQMDWzg5mohEe1xwdbY4fC5+aBYEdbZlTC64wgENK3l5OFp/ThgdAHrGHS+Hhqz4eJSY4yhxM8qXjHY4aTT70lnlkgfwUDIzpUCr304Ig/xZ7N+KQVh5ruBFnhoRNRWzDBRo93MdRmkVGb6Q4bwqhXD99QL42oP8w6KbhO10LPfSBAMLCFLbW52Jd60ouzeoaNFBclKQi52QuocQY6HtZuxpvxOKLQ58H8ss/Q4YWa1wtK9TwYU1hNVIIQDpYsXBpHBPBNyT9mTFBa50YJv2Gf/8DoDjeN02R5Klx1TxuWyTOG5h6yyW2YOAdTHRMAQWQmmst1QuWSHWoVzNeBU+aT20J/RVGb3iyu+yUz6Flj/jaAQsPk9+yTKH19ehRqivZpuk+My+A4amnOvMZwrVPxTmYEPZDN3yzCqrGbYWiO68Cmodfh9y6jmiXPpVhxga1DoPCZw8GPgSKHFdc3F1M1+HUSvqzFSOeT9Dkl6PBFkVLntxuD6uCz9BFxJK+MhXpbizn/Ebofuz/ZKXY9w5/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(396003)(136003)(346002)(376002)(6666004)(41300700001)(478600001)(6506007)(52116002)(6486002)(6512007)(26005)(44832011)(2906002)(30864003)(36756003)(86362001)(6916009)(316002)(1076003)(38100700002)(38350700002)(8936002)(66946007)(5660300002)(66556008)(8676002)(66476007)(186003)(2616005)(83380400001)(2004002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WiDKnqnSm3rDU9mhZo/X0KzeqAvOrx2AEwIkzZsZNB5Mg9MPasbROvFXLsQ3?=
 =?us-ascii?Q?mssdjnV2bd1Rjhj69+9OHlLuXbDnYL/GZunto5MY5kAy1niTL5o6VaIRxwym?=
 =?us-ascii?Q?InKazMHTQ3WKQLu9F58owA6seQHJRH0tLRSWNG4L4bN/ED/N5ixT/wAmCnDs?=
 =?us-ascii?Q?mDzIw6LvcSLxkt6VzFWeCOj9tdTNtI3x7b43naUJV3d2vhXVSUozsXiMlk+V?=
 =?us-ascii?Q?tLYbTkUq9Xp6/Eh9jPnWXRkV/rwlaCZczfsEAuhdVmVSngCJvqemajbfENFv?=
 =?us-ascii?Q?KDArt1NTe3dA8pxUIGIV05UZRfqJB8DLEUg5F3UoJIjmkJUh7EZItQyQkqt6?=
 =?us-ascii?Q?LU8DDFtc3ZKLelvMbEg5KW6rPLrm4w+8JKs1tVc0dKRjjJNDTeCESZ6gOM5L?=
 =?us-ascii?Q?Ni16nmdozQpHdIbz5F+n6O5P/4juQIJC3xwvRH6093yJf260i8CNH1/fn7ar?=
 =?us-ascii?Q?kiQp3pz6Vm23qoq3U29iJ37I73M1DNP4GgQDfKLbJIApa+ZHbAOVwlZNNR+R?=
 =?us-ascii?Q?n7H4cqGgKkzqiszdK3FHk66GbiXGlJOABqo9ooTBlc4BZzoxkpxtXF+7jEYr?=
 =?us-ascii?Q?hWYH273FCTVP2rvOwxMV4tLzF5sqhmzwwBLkw2vqW0X8+KNz4qNIxytfoate?=
 =?us-ascii?Q?DiYnGEbIUH1onDUE1qB4nBJYGzRdW13GCnfSoylIL9DO5mYI/wyqYeHcRp43?=
 =?us-ascii?Q?LVGunEWMT3+ThnGRjNFrsdqGGqrHtMbro5Lfih4HnZKOI8BgPo1fypOB8exE?=
 =?us-ascii?Q?Sq4EpneltFguFgpvAX6b2P2RKdS2J/peapkTMiIuSWfRRQo+gTAp5HG+NN0H?=
 =?us-ascii?Q?gv/FLGienu4CUFhGh8bkZvvIvJxGalnd2IgujE81A+y//B1J84ZMPatGOytq?=
 =?us-ascii?Q?3PK0o7HaFHp9eZOpsWfi9ygjW+ev+EFJzPeTQ5jEkrTTBCSqIaiJhxTLRfhl?=
 =?us-ascii?Q?viBKsqrbHlmphWt0quXUl/ZoPNdXpW3wtDPZgBLKhmW4lUg6AV/+F3KPj0lR?=
 =?us-ascii?Q?2CNktJKdBfIPFmF/VPksMNGAGrNbtXEhLtCb/n3OS0lp+ypLktjz1AQ6FvLf?=
 =?us-ascii?Q?/x5atbpCjjDXswH6HpNRQK9i1YfTFl1MvZaxb0xN8FkTHYlUEPTud/nJmmUa?=
 =?us-ascii?Q?qK/J0onuhAvi2XYnftlwNRnHHA1MNEDBhfaPE72Oo90WHPcF6U2cE9IGWm4H?=
 =?us-ascii?Q?zI9+qzpgwgHds9x5IHMduWYxcy4TBH5VgYEaSgVlWXimuWYzc+WSQRhMexvo?=
 =?us-ascii?Q?Td9x7lBH7R9nxNOS5IwVk33tFW0MpwsEpANphZX7ulUR6Ifka9h6tINKsw9v?=
 =?us-ascii?Q?MPO9BJXEXNEoyjtT4/OnzRm7vIBziZEUKCbc9Pgv7RDKfRRHunFkRWQvZfIz?=
 =?us-ascii?Q?7lHFIZax3RUPauR8HR4R5MncYIWpBrfz/YyTMk7iNwGqsI9da64mLPuyWGHa?=
 =?us-ascii?Q?zEwD6PjNp4GJX673pZw1ZnrGeSVayeEAeuQgLABUFbvw44p++mfCn7XMzEqs?=
 =?us-ascii?Q?TkRYydySeeIuldfnB5ZCEuIeju1ZtBwiKaPW8shn01RnwY6h1Nqvy9s2Xd8m?=
 =?us-ascii?Q?QpZY9ZJ5hlrMihn9U4sCPVkI70qJEnId/fAqdM7rvh7fSrn3hh7hdaoj1tII?=
 =?us-ascii?Q?Vw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12387400-e745-4fe8-43b1-08da76512ea9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:40:27.4869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4hzbnmm5/nEQV42SeiFGOMWj2+3ocQ+Pb3mcvQiMIwZLMXhD8cDs/WpiS8MdSt4pmgbMMo1oLlrY4COE0J6WI7Jb7M8kpt+jdwPiSHu5Rnk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5011
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040085
X-Proofpoint-GUID: EqJMt5gyeejjyR0CADMmAQEul-tEgB81
X-Proofpoint-ORIG-GUID: EqJMt5gyeejjyR0CADMmAQEul-tEgB81
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a new file ioctl to retrieve the parent pointer of a
given inode

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile            |   1 +
 fs/xfs/libxfs/xfs_fs.h     |  57 ++++++++++++++++
 fs/xfs/libxfs/xfs_parent.c |  10 +++
 fs/xfs/libxfs/xfs_parent.h |   2 +
 fs/xfs/xfs_ioctl.c         |  95 +++++++++++++++++++++++++-
 fs/xfs/xfs_ondisk.h        |   4 ++
 fs/xfs/xfs_parent_utils.c  | 134 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_parent_utils.h  |  22 ++++++
 8 files changed, 323 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index caeea8d968ba..998658e40ab4 100644
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
index b0b4d7a3aa15..ba6ec82a0272 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -574,6 +574,7 @@ typedef struct xfs_fsop_handlereq {
 #define XFS_IOC_ATTR_SECURE	0x0008	/* use attrs in security namespace */
 #define XFS_IOC_ATTR_CREATE	0x0010	/* fail if attr already exists */
 #define XFS_IOC_ATTR_REPLACE	0x0020	/* fail if attr does not exist */
+#define XFS_IOC_ATTR_PARENT	0x0040  /* use attrs in parent namespace */
 
 typedef struct xfs_attrlist_cursor {
 	__u32		opaque[4];
@@ -752,6 +753,61 @@ struct xfs_scrub_metadata {
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
+
+	return &info->pi_parents[idx];
+}
+
 /*
  * ioctl limits
  */
@@ -797,6 +853,7 @@ struct xfs_scrub_metadata {
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
+#define XFS_IOC_GETPPOINTER	_IOR ('X', 62, struct xfs_parent_ptr)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 03f03f731d02..d9c922a78617 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -26,6 +26,16 @@
 #include "xfs_xattr.h"
 #include "xfs_parent.h"
 
+/* Initializes a xfs_parent_ptr from an xfs_parent_name_rec */
+void
+xfs_init_parent_ptr(struct xfs_parent_ptr	*xpp,
+		    struct xfs_parent_name_rec	*rec)
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
index 67948f4b3834..53161b79d1e2 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -23,6 +23,8 @@ void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
 			      uint32_t p_diroffset);
 void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
 			       struct xfs_parent_name_rec *rec);
+void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
+			 struct xfs_parent_name_rec *rec);
 int xfs_parent_init(xfs_mount_t *mp, xfs_inode_t *ip,
 		    struct xfs_name *target_name,
 		    struct xfs_parent_defer **parentp);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5b600d3f7981..8a9530588ef4 100644
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
@@ -1679,6 +1683,92 @@ xfs_ioc_scrub_metadata(
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
+	if (xfs_pptr_info_sizeof(ppi->pi_ptrs_size) > XFS_XATTR_LIST_MAX) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	if (ppi->pi_flags != 0 && ppi->pi_flags != XFS_PPTR_IFLAG_HANDLE) {
+		error = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Now that we know how big the trailing buffer is, expand
+	 * our kernel xfs_pptr_info to be the same size
+	 */
+	ppi = krealloc(ppi, xfs_pptr_info_sizeof(ppi->pi_ptrs_size),
+		       GFP_NOFS | __GFP_NOFAIL);
+	if (!ppi)
+		return -ENOMEM;
+
+	if (ppi->pi_flags == XFS_PPTR_IFLAG_HANDLE) {
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
@@ -1968,7 +2058,8 @@ xfs_file_ioctl(
 
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
index 000000000000..3351ce173075
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.c
@@ -0,0 +1,134 @@
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
+		struct xfs_da_args args = {
+			.geo = ip->i_mount->m_attr_geo,
+			.whichfork = XFS_ATTR_FORK,
+			.dp = ip,
+			.namelen = sizeof(struct xfs_parent_name_rec),
+			.attr_filter = flags,
+			.op_flags = XFS_DA_OP_OKNOENT,
+		};
+
+		xpp = xfs_ppinfo_to_pp(ppi, i);
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
+		args.name = (char *)xpnr;
+		args.hashval = xfs_da_hashname(args.name, args.namelen),
+		args.value = (unsigned char *)(xpp->xpp_name);
+		args.valuelen = name_len;
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

