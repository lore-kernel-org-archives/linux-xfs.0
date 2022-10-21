Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E24FFA3740
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiJUWa2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiJUWa0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:30:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A9D2670CE
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:30:25 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDnts004052
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=a8hbNAMJHV3V6XktnLrGcF+aKonAudWbVZ+O7SqKVXE=;
 b=CuQcV44XblkuGMFdvLHRdc8v0WZQfuDImVX8eKUJesNXR9h5xRSbGwTjow9Mcp8cnP8Z
 +MizuBezeeDaDhHn3p9ZcdpsYadfKrNjJocs+1aod/c1PwM7pp2TbKjU5ypwvHxk5/uB
 7QUeRKoPuejKEggpr8g1MGN1I24WUK2jk50loYkD985v2D7Sf7LXBfHCA5h05kP4mK/x
 7Ynjtm5nohC9All53SZzklFE6gSh0+Yy4M6ksYiYvY0+bLEgVjuUGM+dLHVjl0nV8D+A
 A11x2/CWOc9UrMWYRz6gvrAsB+trPuxOJDwjODWRvQAuOxnevTg3NWSAMon6Othx6efk qw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mu0ajck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:24 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LKWCWp018155
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:23 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8j0uc86u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGEEsksVFInTHfZ7Ss4FhX/9uziO+n9y4awZ9ksH7PT6jrzQt1MtZS2jpT3B/kj8IBRmUhM8hy7dd81NlXC8VNmVdHI1q8zPfYZxlo9Ey0evq2S7QK4ggu7gC9ySciPjEcKr3ykKAPFrcZcf7HY/VAh+2ByFhZftINlYAioX6HjXSmUrp35gS75MsRxxmfPG8oFGEQplhBOMv65Iyre/GTuqKxyUslbN35vM4/IXIAQek/2lwdgiGPwpP/1RWDfp27ynA+THVTDfD3NP/z4gotXyNiBkJonTriKj61EDtrlfHu+fvCSF1UeNwPN0BKU+dR1zMNE+tQZ8/VyNV0ISLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8hbNAMJHV3V6XktnLrGcF+aKonAudWbVZ+O7SqKVXE=;
 b=l6nAk4+CAkkLaw4xkxCj99HcT6ewyeg3BcHwaYx65Rr8k9NRhR/EWcb+jl7zzKMtxBqAL+rAFue6E/D2GUPfW8MnzJdw3injCOSQ0fxsBZFbGU3XGbV84OZuLXkG3r1nXsFbiJi+/b/DJijMQINes02aOf87xMvqjxJrkezy5EsmKR8fXQkEjiG5m6vYgNQbgsJLwbQ3iA0B1mm2W8H2K5KqpyUZkwFDmvI030MBEbJ9bTD1ZpkVWJO+vsEalzIwN0cLzBxVYzqWlB2TwUOpXey7d93NkJFHJHeNG+rUCyNogYnzHICqSXJn9WMUW+r/uB+Ftncb5zF5I7yGvO9W0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8hbNAMJHV3V6XktnLrGcF+aKonAudWbVZ+O7SqKVXE=;
 b=0H2rqydWSSqNj5Vs2emKV9GMgRdTZJxfp/DrXFOw9LAYxMZDcVsR0eEQFv//TqlZY/JeSoUjoJqXHVA3sNgi8vYB/Z52SQP/d4J6QIX7tZqrYrHMU1wIHmRR5BfsRfzn80GNfTJzvynzrgFUas0iHkcjk1L1syQa++/36Fb/AOQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5213.namprd10.prod.outlook.com (2603:10b6:5:3aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 22:30:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:30:21 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 25/27] xfs: Add parent pointer ioctl
Date:   Fri, 21 Oct 2022 15:29:34 -0700
Message-Id: <20221021222936.934426-26-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0226.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: be27e25c-2614-452c-422f-08dab3b3d6ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NRTtxfb28V6FmTG9g4s2+4CQi7Zvv6JuoWIova405W6y3nTSnlL2JUY9jcSZPCbBRGUlbSB4azl4+FrUzD34cTz4iW012FVBEJm52SUoX7QiTkJpiwg0um0sOPPw8Ab6A8bpqd9QU2/XkJiRCCDlHyrbud97GiMfLpA0XrEYon628jAjkVVerGejhaiI60Lh8xiuHExcP7T8a8rJsGX55hWZN9mwf5X/v1XDm4gSFifjSCRnUtzI2aJh2TQbDX1vbIOYZ4miTLumZFw2zd5i/2DizEDdC1IdmF11KfG0Yut8IgTuJUGJpSSJlcdcu/AP4d7+3I1Z054GzZsmIFhEi2PrHTklxd6n8jBZBFTERTezjdYK0RXich48h5QVE5sLFW/E/SEbDtwQm6gLEbbsoIN4l9/kWuDhN7tezaJTImB4I+kAXhRo00xv121DBMjynVmpdddyPDnVlVH2jKFvIIWtRtR49vsM1xzdCUl9RVPCynE36BFuiRINfTZh3gDAjVr+/fpvsag6q0j4jEYX5BekHdOR5z2JDArMZ66NqZqqmo8tkwXJ4xgwXmoLHvdju6kNwggwxUGkk872/0NWyT7cUzhxN5pkn9MIRL4gnGA5r9w3zmMhWzWkGBm2ZE0vCoB0qLyOE1npuL2QOqFfJ+dUmhq1EEyHaqhp3R4+oemufqCbRZbXPmCBtZpt3IqDnN6kFLH1dlHRhGrMaNmFgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(66556008)(8676002)(6916009)(30864003)(66946007)(316002)(2906002)(66476007)(8936002)(36756003)(41300700001)(6506007)(6666004)(6486002)(38100700002)(1076003)(186003)(9686003)(6512007)(26005)(2616005)(83380400001)(86362001)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ulLIb1g0mBqTPpn835w0YFF0c2BEF3QGGI4Por05yPW5xrrlpKRAbBk34jnS?=
 =?us-ascii?Q?tOVDf5DzdUcvvhhRYiFBjF3qFRNkKRcuXOS6tjayTCj5Ebqd8Zokg6ucJZfs?=
 =?us-ascii?Q?bk9SRbEB0905SZUnYT5bspJxNEc2ff3BcqCwnv37Kg3me/aIkkrueXwJphG9?=
 =?us-ascii?Q?g24Ki+PkzNo/QILnJJqEt0gqeEZr3pAeQygm21vXB8sJ8l2GH30I/5GSIx46?=
 =?us-ascii?Q?1OjK27+SWtEdjgcEDn+xvYUqM9ytffWzDjvltET1TXIGXtW+vV83zO6zkF5L?=
 =?us-ascii?Q?RHW/6NRTBwb01zTsb6qNHQCeu0wd5xeKQsAYMzPLK6g7cPRtE4c9n7oZiVLG?=
 =?us-ascii?Q?gibAvRIYkwRxo+lcOKOSpUtLPWVzjfYH+5PXAsngx80a9DAwUEWvpbhYZMx/?=
 =?us-ascii?Q?5lCa+L9hUdIVK08KtXyoVzBkQxbmBwlBfmX7FQo4SLOLaHKi0m7t6GdP9NrU?=
 =?us-ascii?Q?WrkfGhPGPqoKG3YDj6antwhSyncF/UVQDK1z+fVAh/SnW6ZY9W31F3t3Gj5D?=
 =?us-ascii?Q?9QZDlxKTZKD7xeHzSi6ii4uxag8FdDaTjSHcGP7YMOhRNFkEBvCSGC7PiDRg?=
 =?us-ascii?Q?e9rrs8N/1+MhBE1JE90EYTecfX9lYW7rsU1384X+5SzXRg4xWmibyjfqhkfC?=
 =?us-ascii?Q?86KsSVM3FCI+9uGtV3jm8FfSWZR+I6iY97eTA7cjNOCSKpQPODSLgkBz5GOC?=
 =?us-ascii?Q?1pYQisuDHngMnAQrrxVP69V23j3jqaAoqNtI/WLYWHBdjVbgO9JNBIVCQIc4?=
 =?us-ascii?Q?8wwmsTRI60+Bgs4FJaQekQPKluSaIA+k5ZaYNNoREFmVRUljhn2Ehubkz7UY?=
 =?us-ascii?Q?gdBTmPA9CJzjeyl6PnTXuTF1qdYSMlB702CUkYcib9ycrQv9AR8Ga5WppWpL?=
 =?us-ascii?Q?2zEczvWdOtsS8n5DHelMltQaIEgKEuQWqEHM9ChZesIX7uMVDl7kmoYhF0Uu?=
 =?us-ascii?Q?aCv1BTIx1AdyjNcma8Qsu1lZpCCYDqd2ZeRkskVtXdA5kGNMrdmXAj7mpOGH?=
 =?us-ascii?Q?0MZkSS8qB5zYc3QOHX6hn2o6E43BRzQhvXuUOmAcjQyv/1cJSMpcrqQLAsL7?=
 =?us-ascii?Q?RsFicMQNsIJraJGbqudkTHrevsbNqnbgRsd2YuEb8Dhm78YiN1BbSb44Osv9?=
 =?us-ascii?Q?uhyYy0mRwL5fsOmesn7306mL/qMpp5Nc40PW09gBw6h4LVlZNF1aeS6hUCIj?=
 =?us-ascii?Q?+QgaC6F0xRxsHp8jXMcnV/LJU5lmVnJX9PHgGp66vaMOlLvW7LvmWd7w1dTS?=
 =?us-ascii?Q?BvgZfKaWhm23KUTOSWlehoUowhJHjB868UG8lIWfW7fuRmt/iT+nVyvPZtfC?=
 =?us-ascii?Q?wzYQGO6Id0cNZfiO69Yy74bqyFVH8p+z6iU4m9Tq4uFcpgb+gmir1uHmv6DJ?=
 =?us-ascii?Q?39Rjw4rVFEcrPvXtXBQMJWfdLikR5mN/mTT8FhMRwsE0YuVFF+JbbWD5zXOn?=
 =?us-ascii?Q?XdolzzHDv4/48rvzQYqvfTGs5hZAjfnsfW+jGaL6HQ95va4JYB61yeb0T2VJ?=
 =?us-ascii?Q?sJFQDNMcMZBuY/lDhgfwWBotLPnlOxanbd8scpMLZ2ESs43PTv/qJDrklzXX?=
 =?us-ascii?Q?MbFpkJS4w7QSDHR2aHlaqdVVDgctcc1VMUaLJNYWsrphl8YKwZpcl/qK58Bn?=
 =?us-ascii?Q?FQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be27e25c-2614-452c-422f-08dab3b3d6ed
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:30:21.4612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RP7MNXlQBW5L7IDMf7Z+d2x8Ze3XS6NXXcVD3t9IUznNPkuxVioGywX/sK/bJix6dCwvzuGhXybhZH7M9uFx5DM8lKlW40MlB4amIwCdRy4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: Fhl6DoU4qiEVRbrfKheQt9Ut6AH32OxU
X-Proofpoint-GUID: Fhl6DoU4qiEVRbrfKheQt9Ut6AH32OxU
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
index 49ac95a301c4..ae883d6aaf40 100644
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
index 5d8966a12084..d03e64d74b31 100644
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

