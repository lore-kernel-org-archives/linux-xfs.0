Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64410C43219
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiKGJDm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbiKGJDj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:39 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225E512762
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:37 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A75o3dV023913
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=NfyTHvJ12BPv5xdzPYkoMXbZyAFtySg9qdXVH2ZVC+Q=;
 b=HifVmuXVo4JAk/VOPEssV6my1q1j+gjQws2t2oapIFm92C72NQqBRdbPM9BmB2mF5taT
 1vWbZGIKm99U18KV9TBjiiM9UIrgW3b7LSSNmN2aoPKrpaL6j5vbgAeBKxXAf/xru+I6
 ZrGBf2WpYzpkyoFKz2ouz/UDe+4egwWgXKRAJXrlnoMFp1SZR1V75r7P6W/9b34hCIXq
 1ZInDT3HYnuUg/GJUUwPxFHCX4yRvTzfwMPp5/QX1BaNM22yyvebjRGPQQjJVQ+AdMTd
 2PdP86t7OhRyc5/Ve+gk4bDdnyF1FYw08I8H21PTTpYO+EwTQXJMo718Q0tVnAxDboWp VA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngrek5fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:37 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77JXoB025146
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:36 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqek6ua-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGB1r0OIyCT5/l4KGw0wf3lPc8/wZn9xtVB8vHLVA/AMxDFoswNJR84xDkclIevOM01tEuuQGWJ+B0PjuUEeqrffPHSAXRbMM8fUQjddSC+3cv7q7m5w95N7h7whCgd9PVWEKu9+1yJL0OuIbNmcazCZfGKpYgToL7A/nBKyLpF3VJi0ZwWdkdUBdvGCnVt9snHAqcjaSr63637ZJy+k9j9IV76WpxzcdzcnQQWb/5hjdezCoV+z8p/JlydzVRPaH22W9CrBwc2q3Ly6w9HqoRtg/ZkhYzPH3A0ip0ZFDYpgnG5oV1OAB2mx7PXEhHfQRXA0ROuaXVdnh42S3wI7tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NfyTHvJ12BPv5xdzPYkoMXbZyAFtySg9qdXVH2ZVC+Q=;
 b=UHSJyfbtyrp8d+2u/+Idfr3StvVZazZ2Aq7OzeRD3d72Hj+bLlXFVT36n7uoFGZasqEgnMLF3ELNH48VjgTyPJ63RqBC7fufXvWkkrHfNtNXc2C3zDlau87DBLta2VQsAV2ktrCcSrKFHLIVvhh01kEbMqCFZndfGI5axAPxTYDdUfgoB3XlzEOp2rxMtIALhe6t5rSkSBA2nT5i4lfTBqCD+Bk+KdKqLrxTg1YtF6IloFaxkq58y05udvEjXL2WoVoKaNp8EV04C1D/yyttqQf3ZVRMDjI23Ql2lftUV09z5wpZRXz0Vkz02o9X7yQXygDtPeNc/niwS9j4ANEq/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfyTHvJ12BPv5xdzPYkoMXbZyAFtySg9qdXVH2ZVC+Q=;
 b=rG7GewNxflF9oHsVlurOMaSeBGveulPTtN0hbZsk78qcbP1ZW/BiO10aoIbcEG0QFDzgMUIdev+SLeWe3s1MTSh/Sjz8OIKpZpBE64m1YXWMyo6RImtqxdPeS5O7MBdNq9C1HFEXxAhelrnSbhhpW1lTu0A2vGvwUKP12PzAqwM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MW4PR10MB6346.namprd10.prod.outlook.com (2603:10b6:303:1ec::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 09:03:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:03:30 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 24/26] xfs: Add parent pointer ioctl
Date:   Mon,  7 Nov 2022 02:01:54 -0700
Message-Id: <20221107090156.299319-25-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0206.namprd05.prod.outlook.com
 (2603:10b6:a03:330::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|MW4PR10MB6346:EE_
X-MS-Office365-Filtering-Correlation-Id: 6514d481-f5e3-4f45-e45f-08dac09ef0ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b4T0BJ3aUBuGLVb5U8FnfJ5J8XthCA4zc//JgCNi5Rln4bG8HLdzhxMr7+e0540zzXjflDSIzGY8jAXYj7vngKHnhQkHgZlJJAJqkgF4SNYl2HtgdBI5SLTPAbtwkHNnZDjVf1wn5j9UBVHoOptrnKk6OsUQ/ZJVP4frAG7lNC8pfMxgOT8kfcwuGSn73tKya5G6y5fo+/UmSIbMaUttG5WHzqNGuZbOg5MTRMdBD7mAWeaWFFL2vejsYc9JlfINw2TNZUb7I97UUr8pou2hjQYlyLUnKMmkxegA1J0Hq756eVpJZwtuz5jPg5v77xl58clGmleBLD/AF/pko4j4o02w/Wmv6+Yucw9sTuRKYsWISJmfuXVZWg1JRgrpijxG1hlkLNd07xOyOa+jSAeHWbuAwwnTru65jqPBXAaz1UV8aD+sufMXkC7oqQsXNLyRg4a5NEDRtMPLdm/O49Lcqo2F0Pda44lnQfTJiMXNGVj1vxAcfKOWUpwxgGYPy8ovUjORU0k8sntJJfAv2XqkX8X6gQ9BjMNys0fTcEueFnJpWhA+D84ZUsyxs+9Zt5zR2W9hPy+ObCwH0qqVjT/tjZOqYaRNVENYJRCIUraXATv9Yol1tVi9/Qmmf7AuIX94R6APST7yWgmosiO+pun3dG+guZJ3tsqWQq4FDHCEv/vFHx1IYfxGBQA7sHJ2lnHJdz4aTR2FfGwvJWpsD1vYVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199015)(38100700002)(6506007)(36756003)(478600001)(316002)(66946007)(66556008)(8676002)(41300700001)(6916009)(8936002)(1076003)(5660300002)(30864003)(6486002)(2906002)(86362001)(66476007)(83380400001)(2616005)(6666004)(9686003)(6512007)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?92vOu2ThSuahybetojJfUjUKWOa5alpLBHKJ37ohHQ/cu8CLNldOtJFZwD1e?=
 =?us-ascii?Q?BHet9Inf3Mj+MBMUST12+lcKLF4zJzZj00mJgGuNs7TZ2BSZtDN1Zy2OU/GR?=
 =?us-ascii?Q?3jB+J9dGD9m0fpb7u9ZOb0EzyC/r+vlGu8e1BGeImrWi1X5xHIqdJ4PPlPZD?=
 =?us-ascii?Q?8g/Y2P6jo6J1kmYif4xZ3/tpvRyqH/li2Ad0rt8KqX0E05D/CID48fM98UgA?=
 =?us-ascii?Q?y2OmxP3WmWMNFhhwC+fM8yRIDeWzwqfiLLKddruYM3VzPm4+M9xj7sXtUuI3?=
 =?us-ascii?Q?UQDtMcl5Io1Pd2ySEWDGSJe7qItnr4kPTkWDiuu4vWfrxUh196N/cY6rESLU?=
 =?us-ascii?Q?xYOu5L1Rjfagt/yCWaqNWI00SwTO2Ztj0lHXDizQsOCa+YX2RDrPpK4GmwsY?=
 =?us-ascii?Q?yqy5rW9M1Oh1ROGmzUN1IoL/Nb4lIGuoSuE6yDJz17Vh3sstTlL/etle4EzD?=
 =?us-ascii?Q?gCcTu91wekle6dYR7PG7mDzfJfoKffKjBGW5liUkAXK6jR3qq1c/VXzjavMZ?=
 =?us-ascii?Q?xeBj/yiZk1x3e25fnWASL7kwKbUwKwqOl7HsSXMxaPK+bQxyEK3jKPSV6Kv3?=
 =?us-ascii?Q?Y40TcHdBuY/Y+a9qPKAktStHbdIUsUIC6HL0d5ujb/r9JY34sesbCCWktEcD?=
 =?us-ascii?Q?qJaxlCmSfbWNPmOVvQKV3pbDIp8uj3kBg1QCFPKWFaTCcXTNY8/zgIF3fNoj?=
 =?us-ascii?Q?AhUYfhsrY0UGsPG4X/QkdITDgFkGwRSdDcjaAz/LmuRXeRk3eLzb1UiDH+tx?=
 =?us-ascii?Q?l1MT0ES8KuaJfpQnx2JAC7/dLTvnulm1XhEU6pZjNnbek9/bYO3KzOh1IEmz?=
 =?us-ascii?Q?ISlwZpvowB+QigpLAGj2sPpjVUITg0nPoqlcoDWGUqaYyBPgW6QT+GBdsR5b?=
 =?us-ascii?Q?KnoPFibPg5psayyNu9mAjpmXmFJMrCU1ZGfr4KwPB9RHnUnig6oV8CCFwUAX?=
 =?us-ascii?Q?2/DGr34+MdR7vPCWCPIs8b8vuhI2kHd+ie973zNbu3eHHShBk9xdliBblaRF?=
 =?us-ascii?Q?s0pQIviNifsPrXuki0GWVV86DK6zi3jYzonnSXwkr1f1e7G7cytq4DpeX5id?=
 =?us-ascii?Q?VilmezxYqPlTGRau9m9ULt6cloiUBxH3fJvu3BgrXyHA7TBb0JsjWwYSsxMV?=
 =?us-ascii?Q?eHloCFxMAUy0j/EnWN5knKbFtllqlrSJRqD9ZsjqS/jUi/Lx6X6axlqzEdNs?=
 =?us-ascii?Q?lUH3H+nMYJa1t/CQPfQrE9hF9UOZtiRwUjuVPswc1ucqrO/OD1u6M5Di2fNp?=
 =?us-ascii?Q?/FNFrzZDH98o6tOAvOapip9yEH883gFzoo6dkn/x0LXWQsaajEX+ZUakLV+c?=
 =?us-ascii?Q?phfzthAp/r2tFni1y91yh0d2jgL0rYmDyu+EMPlE+W72uJ3DLvQaR4IQkiQu?=
 =?us-ascii?Q?jFjzg0cFNpFzQp4nTBIIknWg+U3DQzBN4B+cwIZVOG3j4emhzTQtOwONmaE6?=
 =?us-ascii?Q?ZbSHYx9VWiaHXWk15qHXcfkfVPPdH0c5jdGiVUaJZzHk9uSmzuG4uomn//ur?=
 =?us-ascii?Q?PyszItoHX9VSgD4hB0cVoB6Zxo2W8j1dImjeDhLBMebE3zhIYTqPOr09ZRRl?=
 =?us-ascii?Q?dHzU4qL/IGdYkqM/2IrnblKjNnhfV3PyPer4C167fuTmTzUGBx228HSKr958?=
 =?us-ascii?Q?Uw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6514d481-f5e3-4f45-e45f-08dac09ef0ba
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:03:30.3273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CxO8E6q/aE8hx1HR4zC/e8/os4T5jTMt7UoIgMVBi286LpbZIG58niplkY9vEXXtVDa3lksQTAJEjt8Pe1ccOyUYhCYD5ksGCfqrO+FJYk8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6346
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070077
X-Proofpoint-ORIG-GUID: LiCXhZALbMUOHc3F90GsVSOp560R0liv
X-Proofpoint-GUID: LiCXhZALbMUOHc3F90GsVSOp560R0liv
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
 fs/xfs/xfs_parent_utils.c  | 124 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_parent_utils.h  |  11 ++++
 8 files changed, 319 insertions(+), 1 deletion(-)

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
index 5b600d3f7981..3cd46d030ccd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -37,6 +37,7 @@
 #include "xfs_health.h"
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
+#include "xfs_parent_utils.h"
 #include "xfs_xattr.h"
 
 #include <linux/mount.h>
@@ -1679,6 +1680,96 @@ xfs_ioc_scrub_metadata(
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
@@ -1968,7 +2059,8 @@ xfs_file_ioctl(
 
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
index 000000000000..ea7890bd119a
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.c
@@ -0,0 +1,124 @@
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
+		if (!xfs_verify_ino(args.dp->i_mount, xpp->xpp_ino)) {
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
+			sizeof(struct xfs_attrlist_cursor));
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

