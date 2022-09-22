Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C0EC6FA8B
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiIVFpr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiIVFpl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0C97C32B
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:40 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3E7kf022075
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=tC5ZBmduMpbgjl7y/ei2Kbv6JXRHxUvTlyVVbuU4n+I=;
 b=djsSYdGqgms3Oc1woZrx5GRoEBFyV1Rrg7wf0Qk2Yb8fsMY45YRN1tQJU3QY+v6GhjZQ
 ThWYrvZ80NsEuTqVSacH2HoPViL+a3FolhVjB3C5HFxK1FuporX4taBu+FmfCAsS4NLR
 yXCjpFvzvZTZNEoygjb5mrIeVxL9UvHP12II3z7fZiqrsMM11/JlMXyZwjycx0kbegfT
 8TcEYl7RjUaYlp83Dy+fjhmpZySRDcvA5RgF0bwlSDklc0CbYqcsYoyw9AT/TCde+pLr
 trvjGBQKHMhz6/KKNyBYhpLRSXcG7gYU1tmIKh7XPPGspGn9LXuiuD5urClCS+BfK+Sa Mw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn688kv5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:38 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M1oMdK036614
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39fmuy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLP5uyjxhqVrM6zDp7a/r4Uux+/GjNuBdU/xR8hS4aZQx46O3hKLlveWMEchqcLqkWJtr+lE3jAXPnzTkrgtVHPKduawmNbvhSky6YrDqyoBhHxqlhwtzZGv2tfNrR5PG2VFgefna7ZQ6oP1mo9ZlqXb6vH5rM8fBSeHAOJ5LdMFcQGlAXSk5s5sqSxfIkod+j5Vl7LKceGac9zwZq6eZxUF7/nchfu+sRlCjcDKyvDCejNR6lW8s/v8NZ1I1lQ6WTKmcMUlqaYSFMYJnNf7YI+1J8yr1hS33B20rasZAO2jfv9W3NqtIsDZILN6UOP+SDWAXwtEXMycRx6LF/oBPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tC5ZBmduMpbgjl7y/ei2Kbv6JXRHxUvTlyVVbuU4n+I=;
 b=MUX/kEFrFr74aNw61IyBl4nbMpTAirrJbOY/mB5bfcs/E1j3vKbm3ZyOZVvmNBmS8x6x5vs+StdLztHyrLBqZITj1RfMsVfe1RkHbvGICYBPMpfCRJ2dmeyZCJtHGaCmTdQp8UXYqoNgcTQhvYgkSO7rYo83emO2jg+v5TmHSPwUoFygyq/XkJ5uwDPPFWEW4GYFqVx2wBQ63N3NnXAK8VpOSiPrwc3U6K5w1mVx7gUlj42zKbKC+f8ojZj9gj6N8WVQ0EYd3pJZdISeDG/JBP7GjGaF0jKxVmPSBKfSBF8vFD4yo+QRR5zmGl7+7U664bPm2TgIMQtpyjonphSbuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tC5ZBmduMpbgjl7y/ei2Kbv6JXRHxUvTlyVVbuU4n+I=;
 b=p1/0g4qV57ewDBk2NCfqH3oePuPp8+T2RGmU3nbfFn2oe41ZdPL1w1IyHoRbCJb+uVs1uSVRX944W8sqBnnI/CqldkwZ94UPes4GuCFAX7KU0qMqboLekr+oBUVUKNGS0FvIAlXirEusi8K3NPlydpdj2VCQOEoXY4UkobP34kc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5952.namprd10.prod.outlook.com (2603:10b6:8:9f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.21; Thu, 22 Sep 2022 05:45:35 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:34 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 24/26] xfs: Add parent pointer ioctl
Date:   Wed, 21 Sep 2022 22:44:56 -0700
Message-Id: <20220922054458.40826-25-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0023.namprd21.prod.outlook.com
 (2603:10b6:a03:114::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5952:EE_
X-MS-Office365-Filtering-Correlation-Id: c1633e70-f623-45ba-26ba-08da9c5dab59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HdA4prJLu+UPuknaBOA6TvKTxGjJ00kDEnc5Chx9JjJn4SZkvbcpHBTANgGYAakKtrL29enpcjTSsE8r92vmDlxpNlfkHuwO9dR4ukW3OVvB8rQpgLXI+Qpk9uPQXu5PefUBveYOuyh1fk/135VTbXTbxvrLvk6JDTe/+wVMvQU70zCgeLb/d/lw5xD1uY/n2oW4Hq1OB6e7NV+hkX8K52MAyAZSkytd91Jqh6RMAAy1er82tDYecbBw35SNDbhbrQQA5USz9UQyKWglcwJJAJFI2otPayWZ7KwcpwuV06VG1/byPyOYJGORIbltRZImAJkfBWjlcAiqHBdL2VnEZOyMK2RlgP/MjOZMlrs60DJlS5KWaOdHo+JAyoffb+QnJ9s2ouVBDz22+6UJEqlAYYUtUsiXS6IkvKGS+zvTgTRbmVMqF5ESzPCJa3dKT6tvzONhuI+z6YvcfysS6faAEg+zXaIw3y7uvylu2+nITJpNCO/hc+1zArIXjq+ltN6UKfL4yFy/+YOjMMGF8ESh9lMqnxMB4eQ9VqdWTQiaTdb3OUgJOBRcp81KKW1yGUO0aWuAF9B4y1EvUQoBFjTeb845xwuxrQXme9+Evly+uCx1B8Zr69520xY0oz87sHjyUYm3FniqN2/OyMy48QhsULur3ASUsF2m++6TkjuNpCZgp+iehlKiXKXxyZY9GVzIS63Ig8fGkJlgbWwexI9YAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199015)(6506007)(8936002)(26005)(6512007)(5660300002)(6486002)(316002)(36756003)(86362001)(478600001)(6916009)(66946007)(6666004)(41300700001)(66556008)(66476007)(8676002)(9686003)(38100700002)(83380400001)(1076003)(186003)(2616005)(2906002)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5zmElU/Fne+VP9W+orFFHyav9OhJXxG7g6XLo+0Ganz3nQEbPXMz2lE8UpSv?=
 =?us-ascii?Q?n2BclClplx/PbfLh1NucaDeTez3j0jVmMLSG17cjUp2+gZphJBnp5SjXRdVt?=
 =?us-ascii?Q?qGkl/RTvyoLpQ2UGss+RdTgge8aVeJRhX28FPFll4pPb4M5U1ipS30VPKf0V?=
 =?us-ascii?Q?aD2lH7/WVANGKQbxw8KvGR8lkZ/Zpxl6cQduqr4yTVNxJ1PiPuvyZqLlsQLF?=
 =?us-ascii?Q?tyPSX8FXnpPzBc9FDFGrdrAvje3se8KVfJBdDsOT3mLjVrTDGyaoekMKKJi5?=
 =?us-ascii?Q?+G/e2mZznKTv2JGLjv00Pb04KEVmM9u7EyWxY6I/V0jAGjzu/2I67WDlLASd?=
 =?us-ascii?Q?6yNUaFKrF3oVsELxWlYAjEDKBAsQ0+fn8Zho2K0jfTaEq6CaD6pngJdMqYwB?=
 =?us-ascii?Q?9chcGJ72Txn6fH7FstPWaMv8heNn2m9MXzIq+Q7scLAGXEth08iKenzoJdoB?=
 =?us-ascii?Q?+AB/5i3g25uZdFcQSE9vV+6mu8dpzWrBpf33xVvMdWBthvEaCa5KJU73RToS?=
 =?us-ascii?Q?Cu2+AQRkhYRnPT1AzTsWNc9gLOSNXVhIkhunLFiiP92zWGYZwo2s2I8eY1qj?=
 =?us-ascii?Q?TYekwxrRqXF7M4kT92JTDyin/ZZF4V5bhsyBhNRd39++n9jgktPIKRaQw+tI?=
 =?us-ascii?Q?t9WIhl5RP9QeM2tHMMRGegX5sLn+ZkpzfMrsvsqKfndJJz8qb6ou6+1mqV1e?=
 =?us-ascii?Q?82Je+g7wvMfAqsxI57vyZelOtC94ZxQ7T0WUZxyH3LH6xmp3/vgWc948NKN/?=
 =?us-ascii?Q?PXCABgr3RIshNxpr0BboPpJLjh+zpomnre8iZbnmvoRSYBqLluF7rVBEnsr0?=
 =?us-ascii?Q?BRpzHHteCHr75ptiSENPhjgUhmY8OUKnpwiD/7gtFJUiaF2ccwjBvNJOWkVC?=
 =?us-ascii?Q?SJSYRhRqC2v39nxay26j4i119WPTSANNyBmrbCJ3gYzxekn6pUtbzL61plJV?=
 =?us-ascii?Q?MXxvkWFIAweijt0g+JFKYEe+nLpNbA6+l80mAoplrpBiCn/8SLP2JNtrPbkI?=
 =?us-ascii?Q?qoTffy9IUEeFCsA+DLvz0+/hGvOnQNZgd3V0ZStvAX1OatmIm9Rraio2GF/z?=
 =?us-ascii?Q?5pNQlK/5R4Kd6lM5nf3KaL7V62Wx0rbVzyn57EGdYAZWxanHOsiYH3KZ6AJK?=
 =?us-ascii?Q?ZjylEyG44e2sAjLXeSax1XS6HuP3416YIAEYef/4LmLBHPkXykpGGlZdtJVV?=
 =?us-ascii?Q?KO1rQcbfhd8M/pM0ZKCda3t7LYc3RIWd6QRv1CMVRkXD8M6jPLQgnYw3gEwH?=
 =?us-ascii?Q?CDecJzi/8qcBspCb2SDq7qUcW+INmM+ZIAC4G76AxG37TmLHnSJDifVLoz20?=
 =?us-ascii?Q?gW4y1LK0h6GUeAPte6mmkQYT7De7rikzG4Z+iWl6IYZlo+R4e1CH0Rp1lZFd?=
 =?us-ascii?Q?V8Eh8WdrFBMMMaWvhUYQa6Nyz2FlIGjbVbBj/EHfT5LJOkWINRUiuxPuZ/da?=
 =?us-ascii?Q?MXl/4Qu+qR+hM0YQ2i1zlxNpL8yxRJpe5mLDTyyT9fZROkPCMeOKFTdVF/e/?=
 =?us-ascii?Q?ashT2ZsJfSLK/ehMWy1YIoIgzXbv2UAKbd44kyQ6hbiAwcXJKxUlcWJDJLFw?=
 =?us-ascii?Q?m97OOuD+AAGLcynmRwh/9AzL671azzKZ0+gQvav16g0E7U61oAPOEENO8r+P?=
 =?us-ascii?Q?zg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1633e70-f623-45ba-26ba-08da9c5dab59
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:34.7777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: psvs3uYze0bzl1emG8e8BLpT7pgvwRxW1UaKQWTxtCwg+UldpkitspQP3iS5fnLkCdmK0cKqXvUEg1gi0BXCBoJCCzeXuYvn3RmAR7PW1ro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5952
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220037
X-Proofpoint-GUID: ZJfGWXzggVTHpPuN9cyDT9GCQsv5ORTN
X-Proofpoint-ORIG-GUID: ZJfGWXzggVTHpPuN9cyDT9GCQsv5ORTN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a new file ioctl to retrieve the parent pointer of a
given inode

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile            |   1 +
 fs/xfs/libxfs/xfs_fs.h     |  59 +++++++++++++++++
 fs/xfs/libxfs/xfs_parent.c |  10 +++
 fs/xfs/libxfs/xfs_parent.h |   2 +
 fs/xfs/xfs_ioctl.c         | 106 ++++++++++++++++++++++++++++++-
 fs/xfs/xfs_ondisk.h        |   4 ++
 fs/xfs/xfs_parent_utils.c  | 126 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_parent_utils.h  |  11 ++++
 8 files changed, 316 insertions(+), 3 deletions(-)

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
index b0b4d7a3aa15..42bb343f6952 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -574,6 +574,7 @@ typedef struct xfs_fsop_handlereq {
 #define XFS_IOC_ATTR_SECURE	0x0008	/* use attrs in security namespace */
 #define XFS_IOC_ATTR_CREATE	0x0010	/* fail if attr already exists */
 #define XFS_IOC_ATTR_REPLACE	0x0020	/* fail if attr does not exist */
+#define XFS_IOC_ATTR_PARENT	0x0040  /* use attrs in parent namespace */
 
 typedef struct xfs_attrlist_cursor {
 	__u32		opaque[4];
@@ -752,6 +753,63 @@ struct xfs_scrub_metadata {
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
+	__u32		xpp_rsvd;			/* Reserved */
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
+	return &info->pi_parents[idx];
+}
+
 /*
  * ioctl limits
  */
@@ -797,6 +855,7 @@ struct xfs_scrub_metadata {
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
+#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_parent_ptr)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 7db1570e1841..58382a5c40a6 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -26,6 +26,16 @@
 #include "xfs_xattr.h"
 #include "xfs_parent.h"
 
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
index b2ed4f373799..99765e65af8d 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -23,6 +23,8 @@ void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
 			      uint32_t p_diroffset);
 void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
 			       struct xfs_parent_name_rec *rec);
+void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
+			 const struct xfs_parent_name_rec *rec);
 int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5b600d3f7981..7dc9f37d96cb 100644
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
@@ -538,6 +542,9 @@ xfs_attrmulti_attr_set(
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
 
+	if (flags & XFS_IOC_ATTR_PARENT)
+		return -EINVAL;
+
 	if (ubuf) {
 		if (len > XFS_XATTR_SIZE_MAX)
 			return -EINVAL;
@@ -567,7 +574,9 @@ xfs_ioc_attrmulti_one(
 	unsigned char		*name;
 	int			error;
 
-	if ((flags & XFS_IOC_ATTR_ROOT) && (flags & XFS_IOC_ATTR_SECURE))
+	if (((flags & XFS_IOC_ATTR_ROOT) &&
+	    ((flags & XFS_IOC_ATTR_SECURE) || (flags & XFS_IOC_ATTR_PARENT))) ||
+	    ((flags & XFS_IOC_ATTR_SECURE) && (flags & XFS_IOC_ATTR_PARENT)))
 		return -EINVAL;
 
 	name = strndup_user(uname, MAXNAMELEN);
@@ -1679,6 +1688,96 @@ xfs_ioc_scrub_metadata(
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
@@ -1968,7 +2067,8 @@ xfs_file_ioctl(
 
 	case XFS_IOC_FSGETXATTRA:
 		return xfs_ioc_fsgetxattra(ip, arg);
-
+	case XFS_IOC_GETPARENTS:
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
index 000000000000..fd7156addd38
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.c
@@ -0,0 +1,126 @@
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
+	unsigned int			ioc_flags = XFS_IOC_ATTR_PARENT;
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
+	error = xfs_ioc_attr_list_context_init(ip, namebuf, namebuf_size,
+			ioc_flags, &context);
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
+			error = -EFSCORRUPTED;
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
+		if (error) {
+			error = -EFSCORRUPTED;
+			goto out_kfree;
+		}
+
+		xfs_init_parent_ptr(xpp, xpnr);
+		if(!xfs_verify_ino(args.dp->i_mount, xpp->xpp_ino)) {
+			error = -EFSCORRUPTED;
+			goto out_kfree;
+		}
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
+	xfs_iunlock(ip, lock_mode);
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

