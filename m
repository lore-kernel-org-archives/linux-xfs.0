Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271F7C54EE9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 12:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiITMuO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 08:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiITMuN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 08:50:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D4B422F0
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 05:50:10 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAktHE017950;
        Tue, 20 Sep 2022 12:50:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=YraD99kaXD/Ea50Vp6XPeZmHNLzJ32OnlHy9FYPDnE8=;
 b=R+DPWuYrWTGpBuuFEVMWxb3ndwv5gJeCGiKYUeOoRiHbyFrhxVyWzNFPgaoZnK+A4D6S
 GMIh7a4vfqcjZ+RXLkpY6cn5jfWhmpREgb14NubKOmqGnq4SgqMr0SR0VouGYA0nn2RZ
 cB0/xO5htrOCAOaqafKKRbr5v6ewBeXA+g54EjnD98oUM+3cf7gWGbuhEzSyPIhiW38e
 ONKia+xUlO9PyLZsQMAm0dPbnGbYX3IszUj5R9BmMx0yIeTEz45Jh8ESkga6BZ6Itgoc
 QrCzM6J6izv9u8JGOYjLRW6+5JZcLxYcx70phQJx34sbozDs34cWKmSJUr8qpZVAUE1O Ag== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn688en3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:50:05 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAroc0009986;
        Tue, 20 Sep 2022 12:50:04 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3c90e0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:50:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+LpbgT99GNTr1P6/nJ6dQwFgr72ZKTJIk3B7TpMe6V7POXpF1Ep0esy9dqFaxSYyFwiao1ixCE6Ez7iB3PG415s4AeBNxjwe/QPukUuHgNf5xQTSgL30LNMBDpw5vcBqxUgK8QOfQ0umEVfeYkZo8GcDmChWImahVH4KAOAaEpFPHm32K5wheJYYwskL1OGsyAECorlEDjt6aMVrJloViFdXu5mi5zD8ZDV8TWsdVDo26P0b0W4189FOjqWIceCr7iQzrICwFMhnvDPI8H9jC5ZroYw7uIXnLiPdoAafIjSw4XEUmTBWtHgYdxUtBEcrXMedktb1H4RxcA8xWWAug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YraD99kaXD/Ea50Vp6XPeZmHNLzJ32OnlHy9FYPDnE8=;
 b=A90r64WCk3AfKz3wXiCHvMS527Wy4ngRo9VcpZH1y0hdxTQOWAa9MryYJvbpFL2y19aJB6+SPL6xwXUkR8UhEjfyC+qrIaR9HCgcjpehS7SMG1Oqlpyrs9wbmPH/MXwDL8aQsQMAIFq+Mm7eGUyGHm2O5jb4ptBwStWED3I0LULKH1cX83HURdMgTQQ+iJpApOqaYfbS8Jaat+f6xxrC/3ic8jYjUvZceMVGeaPZ8JZhKh493EkAkWx0NJkJd5qFZVCdxJaUKabhLV21MbY8XmfoqS0vOJzcgS9Kxv/XqE/Uiq3ba2mNlH0QtLPbsgwJ/Hcdx+OrvLbLVN2gNvKO1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YraD99kaXD/Ea50Vp6XPeZmHNLzJ32OnlHy9FYPDnE8=;
 b=L1jvANbCqyUPPQXCkfe8CxrXyf0glpX+IRgdoFaRFQXghNxUGFUFgNmlvis0KcvXXuNgUdte9IVASmeEvgGUx2z4zPTfbSx8Yj230Uam0zz1qpM2EhEvWpkc3PCemp2rJfuBdDox4V3xzGlh1vahK5z/qXfLmibbwGAijnGZxX0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA1PR10MB5784.namprd10.prod.outlook.com (2603:10b6:806:23f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 12:49:56 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 12:49:56 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE V2 11/17] xfs: always log corruption errors
Date:   Tue, 20 Sep 2022 18:18:30 +0530
Message-Id: <20220920124836.1914918-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920124836.1914918-1-chandan.babu@oracle.com>
References: <20220920124836.1914918-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0023.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:262::10) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA1PR10MB5784:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b28d91f-b58a-46e5-883b-08da9b069ed1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Ho/zPe4BRNknY7nPYq+lgdnVP/W9v7604NcZ0WQQPV54Lj2RFgcMLSpc7gdO6XlcROUUYSlly1sb31Dpa7KxhdoSQmfk/UttcjRL4QUQ0dyXGPm4oypvbc1wtXJXAoD1JvC0BZIz5fSOKZgf1AzchfcfbaNR3irnqx/oxj+Pv/sJy8Fy9oW4rtLqeTGdsopvb7WAVO+DB4y6Sy31raUxsMQhY5vTNl5jLy5cbdfYxgMo04TSWvWsPGQZrEwuSLr/xgQ+GerLfeFnxtVPGlZQb2hNga5UL7ef2+NASm8jv1uHHvbMRXnHF7+h3wbxKOpz26hVQTWEqjfwQBdfle/Ubf7eG/Fi1I+Lwwf5MlzF8Nz4N86fVUUbbIzABNQnrtzPeS9Q0SxgilOmG4KFpFjeZ0lcG1ZULBH8KIKZyZuilP3+B29pgf0K/4LCbPyKMjUxWfqqVZ99PNX308+lJ7wwIsSGbIviqwUpbPC6XBREFSlBXZPmNXXazKkF5qIhEeZqqJIN98x3WkhbeuaKXEtQVyas3NtUzgTHng6AAGZ+VW6k60EAnptjbqcmW0ImOEGUnZ9Rs+1M1eHEHnLfnXT+yxAdXk0vEAAIFNZ25vbmia2z9Q4k8zcYVcuJVCDd5AXIvRfJcTDmVqBi+rFVnu6dnrXDjM3/1jusVLyWVKbiksKUAn31BDKeLImjXnQS1ljHVfA16sHXWGInwjtwJW8tA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199015)(8676002)(30864003)(36756003)(478600001)(66556008)(186003)(6486002)(66946007)(6916009)(6506007)(86362001)(26005)(66476007)(4326008)(41300700001)(8936002)(6666004)(83380400001)(38100700002)(5660300002)(6512007)(1076003)(316002)(2906002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zepa5HnG+mu4b6+wr2aJ1GCdOAUZpkUT+huQwHo4CaDOu8QXN1M91uv08j4V?=
 =?us-ascii?Q?HM7kuX+eb5qNcpH5jDUche/+99x8XNbg3GdmX8+xZesYu2ocrwA+DEozy7wC?=
 =?us-ascii?Q?BlDdlfbszR/8CrhhyVu5PQ+JZTYuXHqJjqxODiNa4NaW3yo13TwVlaWAjZrX?=
 =?us-ascii?Q?HDUf5mH0udzmGF/C7Zvwf3KrjI5uiYeaWFeT5stP2sNdRE4g8caOCU4IFHs2?=
 =?us-ascii?Q?/S2U/SfprWdakQxLBhjD1UT0FqSQOjs7fgy67X3RqU6RcUMZ5bpqK9Ejl+os?=
 =?us-ascii?Q?G+TqM9Uw1EmrR7StoH8TeSVGZL9IAmFBhcDGeMbM92a3CYOksg66WcZJhUqe?=
 =?us-ascii?Q?bZaz0KoQXEMS1P65TeBXwqfo/v4HDqmMHnbFy8nu1eaeC/h1WOzO0Z30EcJm?=
 =?us-ascii?Q?vw3cNvJHcgPLOr7yiUBNF9HTM3T8rsd9MLxlkjX+RBbVyR0Ja1BiaOyCYp1d?=
 =?us-ascii?Q?DgJ13EmhdaiEfuw6z4IvOvo/SMVFnoJgU/rI5CbWZGSXizSPNez+qmAkaqXO?=
 =?us-ascii?Q?ZdHGiN2utFatmeJCsCFvD7XoLliGXj3vtBrFAqYM0huhcw8aSWzL1jCus9bQ?=
 =?us-ascii?Q?PgH0At5VOEc7/PZxlYZG85d3t753fI2ouRTu3Nhw2sG0/IwwU87yKmyetaPF?=
 =?us-ascii?Q?mbd1mU9GZ4AX2nE+AlPihAaCKUPF7EWWL53o3FvTsclxCnX70NQjgg7kQVol?=
 =?us-ascii?Q?O8nZFfJrp8QeSbyvcNhsKnLhdSPhAvjbemm7jQnt/o/MRxXKN/Lwm+0l1XWO?=
 =?us-ascii?Q?adA3CUDlg8lU71tPOY2LjTmCKMD0z4fy8ITHpFG/DiwSOuvLEqO1skfxN//X?=
 =?us-ascii?Q?IwC07wU2XSh6hwSA0lhbRt7bV9WAlEqQ1m1tb66MWzA6UCyBwE8zyltlBLoO?=
 =?us-ascii?Q?tGApFlKbXxvQR0rVBwMrDIOiHtbTwt4pIvocRlhHYLBW64ePdwjIkq2Y3m9t?=
 =?us-ascii?Q?VE1yAsfq5bhmXGBsX9wMcszc5+gz9GHOMXDFWaN/IsG+v/43IYty6dR8HBH4?=
 =?us-ascii?Q?bm6+RTL3V0JApw4Q/y1ssumr73SUXM6RY9osITdqMDIroLS73GWBwlXF1hL8?=
 =?us-ascii?Q?5YQI5ZYMBJpOd0nMNnNb/UlXiwjrCS4XinuuV/33GrwzZTb/1WcDLzsaHyEV?=
 =?us-ascii?Q?s8b0DEOU00KQ70PH4hs77VXcOR9i1l9840mBGM5u0F7Ol9zI4HjdL7VwNm5o?=
 =?us-ascii?Q?DSIWGAbiZI2yQO298JuApaJ0ErtSzlpYWkRD39mYYTZkoJPHxTZDKd3tTqfk?=
 =?us-ascii?Q?0QzUJ5cXDpuXPB52Gvrb0cYN7B658L3io445Py0kxpI/zxFXaTbN9P6cwzKC?=
 =?us-ascii?Q?LNyjEP7zf+1mie1ZrFLIcZautTVK4NxUWTHwnOLpSHJKaLZz6+SyxlmTxH4l?=
 =?us-ascii?Q?drS7H6xodrYa7zSUH3ig7SacSb5iuNh9p+YlevmK1q/JvAXFJQmVYmuaWhNG?=
 =?us-ascii?Q?3Orc/Uxm180ev7n9uu4+IBX8DAWCNVT7rFtbb+3Vt93GC90g1NkHGdBzFu89?=
 =?us-ascii?Q?tdy+yOULqqisyEkHtNmYaIbTLufQ/zbF32RYtXAQfy19QngPDPoy+eEmZvhk?=
 =?us-ascii?Q?3a+oTusm2EwDRbeeRMzVubzfAQNrmoS7k4XnBadzrD8T6Y2Ntg+KvRCEv/PW?=
 =?us-ascii?Q?RQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b28d91f-b58a-46e5-883b-08da9b069ed1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 12:49:56.7218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ciU8/Sehc9lWaTI0e+9BLbKCJX5YkPNjl/sFIk6nX+6E2ngsNFdQMgnF/qQWQQLU5nhajMtsKVoHEi1mx80FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209200076
X-Proofpoint-GUID: 6QGvZ42gzlj_BRTBaSpYXwLQLprSH4Hg
X-Proofpoint-ORIG-GUID: 6QGvZ42gzlj_BRTBaSpYXwLQLprSH4Hg
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit a5155b870d687de1a5f07e774b49b1e8ef0f6f50 upstream.

Make sure we log something to dmesg whenever we return -EFSCORRUPTED up
the call stack.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c      |  9 +++++++--
 fs/xfs/libxfs/xfs_attr_leaf.c  | 12 +++++++++---
 fs/xfs/libxfs/xfs_bmap.c       |  8 +++++++-
 fs/xfs/libxfs/xfs_btree.c      |  5 ++++-
 fs/xfs/libxfs/xfs_da_btree.c   | 24 ++++++++++++++++++------
 fs/xfs/libxfs/xfs_dir2.c       |  4 +++-
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  4 +++-
 fs/xfs/libxfs/xfs_dir2_node.c  | 12 +++++++++---
 fs/xfs/libxfs/xfs_inode_fork.c |  6 ++++++
 fs/xfs/libxfs/xfs_refcount.c   |  4 +++-
 fs/xfs/libxfs/xfs_rtbitmap.c   |  6 ++++--
 fs/xfs/xfs_acl.c               | 15 ++++++++++++---
 fs/xfs/xfs_attr_inactive.c     |  6 +++++-
 fs/xfs/xfs_attr_list.c         |  5 ++++-
 fs/xfs/xfs_bmap_item.c         |  3 ++-
 fs/xfs/xfs_error.c             | 21 +++++++++++++++++++++
 fs/xfs/xfs_error.h             |  1 +
 fs/xfs/xfs_extfree_item.c      |  3 ++-
 fs/xfs/xfs_inode.c             | 15 ++++++++++++---
 fs/xfs/xfs_inode_item.c        |  5 ++++-
 fs/xfs/xfs_iops.c              | 10 +++++++---
 fs/xfs/xfs_log_recover.c       | 23 ++++++++++++++++++-----
 fs/xfs/xfs_qm.c                | 13 +++++++++++--
 fs/xfs/xfs_refcount_item.c     |  3 ++-
 fs/xfs/xfs_rmap_item.c         |  7 +++++--
 25 files changed, 179 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 436f686a9891..f1cdf5fbaa71 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -684,8 +684,10 @@ xfs_alloc_update_counters(
 
 	xfs_trans_agblocks_delta(tp, len);
 	if (unlikely(be32_to_cpu(agf->agf_freeblks) >
-		     be32_to_cpu(agf->agf_length)))
+		     be32_to_cpu(agf->agf_length))) {
+		xfs_buf_corruption_error(agbp);
 		return -EFSCORRUPTED;
+	}
 
 	xfs_alloc_log_agf(tp, agbp, XFS_AGF_FREEBLKS);
 	return 0;
@@ -751,6 +753,7 @@ xfs_alloc_ag_vextent_small(
 
 		bp = xfs_btree_get_bufs(args->mp, args->tp, args->agno, fbno);
 		if (!bp) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, args->mp);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -2087,8 +2090,10 @@ xfs_free_agfl_block(
 		return error;
 
 	bp = xfs_btree_get_bufs(tp->t_mountp, tp, agno, agbno);
-	if (!bp)
+	if (!bp) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, tp->t_mountp);
 		return -EFSCORRUPTED;
+	}
 	xfs_trans_binval(tp, bp);
 
 	return 0;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index de33efc9b4f9..0c23127347ac 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2287,8 +2287,10 @@ xfs_attr3_leaf_lookup_int(
 	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
-	if (ichdr.count >= args->geo->blksize / 8)
+	if (ichdr.count >= args->geo->blksize / 8) {
+		xfs_buf_corruption_error(bp);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * Binary search.  (note: small blocks will skip this loop)
@@ -2304,10 +2306,14 @@ xfs_attr3_leaf_lookup_int(
 		else
 			break;
 	}
-	if (!(probe >= 0 && (!ichdr.count || probe < ichdr.count)))
+	if (!(probe >= 0 && (!ichdr.count || probe < ichdr.count))) {
+		xfs_buf_corruption_error(bp);
 		return -EFSCORRUPTED;
-	if (!(span <= 4 || be32_to_cpu(entry->hashval) == hashval))
+	}
+	if (!(span <= 4 || be32_to_cpu(entry->hashval) == hashval)) {
+		xfs_buf_corruption_error(bp);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * Since we may have duplicate hashval's, find the first matching
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index de4e71725b2c..e7fa611887ad 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -729,6 +729,7 @@ xfs_bmap_extents_to_btree(
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
 	abp = xfs_btree_get_bufl(mp, tp, args.fsbno);
 	if (!abp) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		error = -EFSCORRUPTED;
 		goto out_unreserve_dquot;
 	}
@@ -1084,6 +1085,7 @@ xfs_bmap_add_attrfork(
 	if (XFS_IFORK_Q(ip))
 		goto trans_cancel;
 	if (ip->i_d.di_anextents != 0) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		error = -EFSCORRUPTED;
 		goto trans_cancel;
 	}
@@ -1374,6 +1376,7 @@ xfs_bmap_last_before(
 	case XFS_DINODE_FMT_EXTENTS:
 		break;
 	default:
+		ASSERT(0);
 		return -EFSCORRUPTED;
 	}
 
@@ -1474,8 +1477,10 @@ xfs_bmap_last_offset(
 		return 0;
 
 	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE &&
-	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
+	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS) {
+		ASSERT(0);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
 	if (error || is_empty)
@@ -5872,6 +5877,7 @@ xfs_bmap_insert_extents(
 				del_cursor);
 
 	if (stop_fsb >= got.br_startoff + got.br_blockcount) {
+		ASSERT(0);
 		error = -EFSCORRUPTED;
 		goto del_cursor;
 	}
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 71de937f9e64..a13a25e922ec 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1820,6 +1820,7 @@ xfs_btree_lookup_get_block(
 
 out_bad:
 	*blkp = NULL;
+	xfs_buf_corruption_error(bp);
 	xfs_trans_brelse(cur->bc_tp, bp);
 	return -EFSCORRUPTED;
 }
@@ -1867,8 +1868,10 @@ xfs_btree_lookup(
 	XFS_BTREE_STATS_INC(cur, lookup);
 
 	/* No such thing as a zero-level tree. */
-	if (cur->bc_nlevels == 0)
+	if (cur->bc_nlevels == 0) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, cur->bc_mp);
 		return -EFSCORRUPTED;
+	}
 
 	block = NULL;
 	keyno = 0;
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 4fd1223c1bd5..1e2dc65adeb8 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -504,6 +504,7 @@ xfs_da3_split(
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.forw) {
 		if (be32_to_cpu(node->hdr.info.forw) != addblk->blkno) {
+			xfs_buf_corruption_error(oldblk->bp);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -516,6 +517,7 @@ xfs_da3_split(
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.back) {
 		if (be32_to_cpu(node->hdr.info.back) != addblk->blkno) {
+			xfs_buf_corruption_error(oldblk->bp);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -1541,8 +1543,10 @@ xfs_da3_node_lookup_int(
 			break;
 		}
 
-		if (magic != XFS_DA_NODE_MAGIC && magic != XFS_DA3_NODE_MAGIC)
+		if (magic != XFS_DA_NODE_MAGIC && magic != XFS_DA3_NODE_MAGIC) {
+			xfs_buf_corruption_error(blk->bp);
 			return -EFSCORRUPTED;
+		}
 
 		blk->magic = XFS_DA_NODE_MAGIC;
 
@@ -1554,15 +1558,18 @@ xfs_da3_node_lookup_int(
 		btree = dp->d_ops->node_tree_p(node);
 
 		/* Tree taller than we can handle; bail out! */
-		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH)
+		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH) {
+			xfs_buf_corruption_error(blk->bp);
 			return -EFSCORRUPTED;
+		}
 
 		/* Check the level from the root. */
 		if (blkno == args->geo->leafblk)
 			expected_level = nodehdr.level - 1;
-		else if (expected_level != nodehdr.level)
+		else if (expected_level != nodehdr.level) {
+			xfs_buf_corruption_error(blk->bp);
 			return -EFSCORRUPTED;
-		else
+		} else
 			expected_level--;
 
 		max = nodehdr.count;
@@ -1612,12 +1619,17 @@ xfs_da3_node_lookup_int(
 		}
 
 		/* We can't point back to the root. */
-		if (blkno == args->geo->leafblk)
+		if (blkno == args->geo->leafblk) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+					dp->i_mount);
 			return -EFSCORRUPTED;
+		}
 	}
 
-	if (expected_level != 0)
+	if (expected_level != 0) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, dp->i_mount);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * A leaf block that ends in the hashval that we are interested in
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 867c5dee0751..452d04ae10ce 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -600,8 +600,10 @@ xfs_dir2_isblock(
 	if ((rval = xfs_bmap_last_offset(args->dp, &last, XFS_DATA_FORK)))
 		return rval;
 	rval = XFS_FSB_TO_B(args->dp->i_mount, last) == args->geo->blksize;
-	if (rval != 0 && args->dp->i_d.di_size != args->geo->blksize)
+	if (rval != 0 && args->dp->i_d.di_size != args->geo->blksize) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, args->dp->i_mount);
 		return -EFSCORRUPTED;
+	}
 	*vp = rval;
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index a53e4585a2f3..388b5da12228 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1343,8 +1343,10 @@ xfs_dir2_leaf_removename(
 	oldbest = be16_to_cpu(bf[0].length);
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
-	if (be16_to_cpu(bestsp[db]) != oldbest)
+	if (be16_to_cpu(bestsp[db]) != oldbest) {
+		xfs_buf_corruption_error(lbp);
 		return -EFSCORRUPTED;
+	}
 	/*
 	 * Mark the former data entry unused.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 99d5b2ed67f2..35e698fa85fd 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -374,8 +374,10 @@ xfs_dir2_leaf_to_node(
 	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	if (be32_to_cpu(ltp->bestcount) >
-				(uint)dp->i_d.di_size / args->geo->blksize)
+				(uint)dp->i_d.di_size / args->geo->blksize) {
+		xfs_buf_corruption_error(lbp);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * Copy freespace entries from the leaf block to the new block.
@@ -446,8 +448,10 @@ xfs_dir2_leafn_add(
 	 * Quick check just to make sure we are not going to index
 	 * into other peoples memory
 	 */
-	if (index < 0)
+	if (index < 0) {
+		xfs_buf_corruption_error(bp);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * If there are already the maximum number of leaf entries in
@@ -740,8 +744,10 @@ xfs_dir2_leafn_lookup_for_entry(
 	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	xfs_dir3_leaf_check(dp, bp);
-	if (leafhdr.count <= 0)
+	if (leafhdr.count <= 0) {
+		xfs_buf_corruption_error(bp);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * Look up the hash value in the leaf entries.
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 8fdd0424070e..15d6f947620f 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -75,11 +75,15 @@ xfs_iformat_fork(
 			error = xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
 			break;
 		default:
+			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
+					dip, sizeof(*dip), __this_address);
 			return -EFSCORRUPTED;
 		}
 		break;
 
 	default:
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
+				sizeof(*dip), __this_address);
 		return -EFSCORRUPTED;
 	}
 	if (error)
@@ -110,6 +114,8 @@ xfs_iformat_fork(
 		error = xfs_iformat_btree(ip, dip, XFS_ATTR_FORK);
 		break;
 	default:
+		xfs_inode_verifier_error(ip, error, __func__, dip,
+				sizeof(*dip), __this_address);
 		error = -EFSCORRUPTED;
 		break;
 	}
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 9a7fadb1361c..78236bd6c64f 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1591,8 +1591,10 @@ xfs_refcount_recover_extent(
 	struct list_head		*debris = priv;
 	struct xfs_refcount_recovery	*rr;
 
-	if (be32_to_cpu(rec->refc.rc_refcount) != 1)
+	if (be32_to_cpu(rec->refc.rc_refcount) != 1) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, cur->bc_mp);
 		return -EFSCORRUPTED;
+	}
 
 	rr = kmem_alloc(sizeof(struct xfs_refcount_recovery), 0);
 	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 42085e70c01a..85f123b3dfcc 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -15,7 +15,7 @@
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
 #include "xfs_rtalloc.h"
-
+#include "xfs_error.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
@@ -70,8 +70,10 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	if (nmap == 0 || !xfs_bmap_is_real_extent(&map))
+	if (nmap == 0 || !xfs_bmap_is_real_extent(&map)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
+	}
 
 	ASSERT(map.br_startblock != NULLFSBLOCK);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 96d7071cfa46..3f2292c7835c 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -12,6 +12,7 @@
 #include "xfs_inode.h"
 #include "xfs_attr.h"
 #include "xfs_trace.h"
+#include "xfs_error.h"
 #include <linux/posix_acl_xattr.h>
 
 
@@ -23,6 +24,7 @@
 
 STATIC struct posix_acl *
 xfs_acl_from_disk(
+	struct xfs_mount	*mp,
 	const struct xfs_acl	*aclp,
 	int			len,
 	int			max_entries)
@@ -32,11 +34,18 @@ xfs_acl_from_disk(
 	const struct xfs_acl_entry *ace;
 	unsigned int count, i;
 
-	if (len < sizeof(*aclp))
+	if (len < sizeof(*aclp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, aclp,
+				len);
 		return ERR_PTR(-EFSCORRUPTED);
+	}
+
 	count = be32_to_cpu(aclp->acl_cnt);
-	if (count > max_entries || XFS_ACL_SIZE(count) != len)
+	if (count > max_entries || XFS_ACL_SIZE(count) != len) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, aclp,
+				len);
 		return ERR_PTR(-EFSCORRUPTED);
+	}
 
 	acl = posix_acl_alloc(count, GFP_KERNEL);
 	if (!acl)
@@ -145,7 +154,7 @@ xfs_get_acl(struct inode *inode, int type)
 		if (error != -ENOATTR)
 			acl = ERR_PTR(error);
 	} else  {
-		acl = xfs_acl_from_disk(xfs_acl, len,
+		acl = xfs_acl_from_disk(ip->i_mount, xfs_acl, len,
 					XFS_ACL_MAX_ENTRIES(ip->i_mount));
 		kmem_free(xfs_acl);
 	}
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index f83f11d929e4..43ae392992e7 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -22,6 +22,7 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_quota.h"
 #include "xfs_dir2.h"
+#include "xfs_error.h"
 
 /*
  * Look at all the extents for this logical region,
@@ -209,6 +210,7 @@ xfs_attr3_node_inactive(
 	 */
 	if (level > XFS_DA_NODE_MAXDEPTH) {
 		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
+		xfs_buf_corruption_error(bp);
 		return -EFSCORRUPTED;
 	}
 
@@ -258,8 +260,9 @@ xfs_attr3_node_inactive(
 			error = xfs_attr3_leaf_inactive(trans, dp, child_bp);
 			break;
 		default:
-			error = -EFSCORRUPTED;
+			xfs_buf_corruption_error(child_bp);
 			xfs_trans_brelse(*trans, child_bp);
+			error = -EFSCORRUPTED;
 			break;
 		}
 		if (error)
@@ -342,6 +345,7 @@ xfs_attr3_root_inactive(
 		break;
 	default:
 		error = -EFSCORRUPTED;
+		xfs_buf_corruption_error(bp);
 		xfs_trans_brelse(*trans, bp);
 		break;
 	}
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 00758fdc2fec..8b9b500e75e8 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -258,8 +258,10 @@ xfs_attr_node_list_lookup(
 			return 0;
 
 		/* We can't point back to the root. */
-		if (cursor->blkno == 0)
+		if (cursor->blkno == 0) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 			return -EFSCORRUPTED;
+		}
 	}
 
 	if (expected_level != 0)
@@ -269,6 +271,7 @@ xfs_attr_node_list_lookup(
 	return 0;
 
 out_corruptbuf:
+	xfs_buf_corruption_error(bp);
 	xfs_trans_brelse(tp, bp);
 	return -EFSCORRUPTED;
 }
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index d84339c91466..243e5e0f82a3 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -21,7 +21,7 @@
 #include "xfs_icache.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
-
+#include "xfs_error.h"
 
 kmem_zone_t	*xfs_bui_zone;
 kmem_zone_t	*xfs_bud_zone;
@@ -525,6 +525,7 @@ xfs_bui_recover(
 		type = bui_type;
 		break;
 	default:
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		error = -EFSCORRUPTED;
 		goto err_inode;
 	}
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 0b156cc88108..d8cdb27fe6ed 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -341,6 +341,27 @@ xfs_corruption_error(
 	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
 }
 
+/*
+ * Complain about the kinds of metadata corruption that we can't detect from a
+ * verifier, such as incorrect inter-block relationship data.  Does not set
+ * bp->b_error.
+ */
+void
+xfs_buf_corruption_error(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+
+	xfs_alert_tag(mp, XFS_PTAG_VERIFIER_ERROR,
+		  "Metadata corruption detected at %pS, %s block 0x%llx",
+		  __return_address, bp->b_ops->name, bp->b_bn);
+
+	xfs_alert(mp, "Unmount and run xfs_repair");
+
+	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
+		xfs_stack_trace();
+}
+
 /*
  * Warnings specifically for verifier errors.  Differentiate CRC vs. invalid
  * values, and omit the stack trace unless the error level is tuned high.
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index e6a22cfb542f..c319379f7d1a 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -15,6 +15,7 @@ extern void xfs_corruption_error(const char *tag, int level,
 			struct xfs_mount *mp, const void *buf, size_t bufsize,
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
+void xfs_buf_corruption_error(struct xfs_buf *bp);
 extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
 			const char *name, const void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 1b3ade30ef65..a05a1074e8f8 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -21,7 +21,7 @@
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
-
+#include "xfs_error.h"
 
 kmem_zone_t	*xfs_efi_zone;
 kmem_zone_t	*xfs_efd_zone;
@@ -228,6 +228,7 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
 		}
 		return 0;
 	}
+	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8990be13a16c..70c5050463a6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2149,8 +2149,10 @@ xfs_iunlink_update_bucket(
 	 * passed in because either we're adding or removing ourselves from the
 	 * head of the list.
 	 */
-	if (old_value == new_agino)
+	if (old_value == new_agino) {
+		xfs_buf_corruption_error(agibp);
 		return -EFSCORRUPTED;
+	}
 
 	agi->agi_unlinked[bucket_index] = cpu_to_be32(new_agino);
 	offset = offsetof(struct xfs_agi, agi_unlinked) +
@@ -2213,6 +2215,8 @@ xfs_iunlink_update_inode(
 	/* Make sure the old pointer isn't garbage. */
 	old_value = be32_to_cpu(dip->di_next_unlinked);
 	if (!xfs_verify_agino_or_null(mp, agno, old_value)) {
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
+				sizeof(*dip), __this_address);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -2224,8 +2228,11 @@ xfs_iunlink_update_inode(
 	 */
 	*old_next_agino = old_value;
 	if (old_value == next_agino) {
-		if (next_agino != NULLAGINO)
+		if (next_agino != NULLAGINO) {
+			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
+					dip, sizeof(*dip), __this_address);
 			error = -EFSCORRUPTED;
+		}
 		goto out;
 	}
 
@@ -2276,8 +2283,10 @@ xfs_iunlink(
 	 */
 	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
 	if (next_agino == agino ||
-	    !xfs_verify_agino_or_null(mp, agno, next_agino))
+	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
+		xfs_buf_corruption_error(agibp);
 		return -EFSCORRUPTED;
+	}
 
 	if (next_agino != NULLAGINO) {
 		struct xfs_perag	*pag;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index bb8f076805b9..726aa3bfd6e8 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -17,6 +17,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_error.h"
 
 #include <linux/iversion.h>
 
@@ -828,8 +829,10 @@ xfs_inode_item_format_convert(
 {
 	struct xfs_inode_log_format_32	*in_f32 = buf->i_addr;
 
-	if (buf->i_len != sizeof(*in_f32))
+	if (buf->i_len != sizeof(*in_f32)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 		return -EFSCORRUPTED;
+	}
 
 	in_f->ilf_type = in_f32->ilf_type;
 	in_f->ilf_size = in_f32->ilf_size;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ca8c763902b9..80dd05f8f1af 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -20,6 +20,7 @@
 #include "xfs_symlink.h"
 #include "xfs_dir2.h"
 #include "xfs_iomap.h"
+#include "xfs_error.h"
 
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
@@ -470,17 +471,20 @@ xfs_vn_get_link_inline(
 	struct inode		*inode,
 	struct delayed_call	*done)
 {
+	struct xfs_inode	*ip = XFS_I(inode);
 	char			*link;
 
-	ASSERT(XFS_I(inode)->i_df.if_flags & XFS_IFINLINE);
+	ASSERT(ip->i_df.if_flags & XFS_IFINLINE);
 
 	/*
 	 * The VFS crashes on a NULL pointer, so return -EFSCORRUPTED if
 	 * if_data is junk.
 	 */
-	link = XFS_I(inode)->i_df.if_u1.if_data;
-	if (!link)
+	link = ip->i_df.if_u1.if_data;
+	if (!link) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, ip->i_mount);
 		return ERR_PTR(-EFSCORRUPTED);
+	}
 	return link;
 }
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 796bbc9dd8b0..02f2147952b3 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3537,6 +3537,7 @@ xfs_cui_copy_format(
 		memcpy(dst_cui_fmt, src_cui_fmt, len);
 		return 0;
 	}
+	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 	return -EFSCORRUPTED;
 }
 
@@ -3601,8 +3602,10 @@ xlog_recover_cud_pass2(
 	struct xfs_ail			*ailp = log->l_ailp;
 
 	cud_formatp = item->ri_buf[0].i_addr;
-	if (item->ri_buf[0].i_len != sizeof(struct xfs_cud_log_format))
+	if (item->ri_buf[0].i_len != sizeof(struct xfs_cud_log_format)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 		return -EFSCORRUPTED;
+	}
 	cui_id = cud_formatp->cud_cui_id;
 
 	/*
@@ -3654,6 +3657,7 @@ xfs_bui_copy_format(
 		memcpy(dst_bui_fmt, src_bui_fmt, len);
 		return 0;
 	}
+	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 	return -EFSCORRUPTED;
 }
 
@@ -3677,8 +3681,10 @@ xlog_recover_bui_pass2(
 
 	bui_formatp = item->ri_buf[0].i_addr;
 
-	if (bui_formatp->bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
+	if (bui_formatp->bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 		return -EFSCORRUPTED;
+	}
 	buip = xfs_bui_init(mp);
 	error = xfs_bui_copy_format(&item->ri_buf[0], &buip->bui_format);
 	if (error) {
@@ -3720,8 +3726,10 @@ xlog_recover_bud_pass2(
 	struct xfs_ail			*ailp = log->l_ailp;
 
 	bud_formatp = item->ri_buf[0].i_addr;
-	if (item->ri_buf[0].i_len != sizeof(struct xfs_bud_log_format))
+	if (item->ri_buf[0].i_len != sizeof(struct xfs_bud_log_format)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 		return -EFSCORRUPTED;
+	}
 	bui_id = bud_formatp->bud_bui_id;
 
 	/*
@@ -5181,8 +5189,10 @@ xlog_recover_process(
 		 * If the filesystem is CRC enabled, this mismatch becomes a
 		 * fatal log corruption failure.
 		 */
-		if (xfs_sb_version_hascrc(&log->l_mp->m_sb))
+		if (xfs_sb_version_hascrc(&log->l_mp->m_sb)) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 			return -EFSCORRUPTED;
+		}
 	}
 
 	xlog_unpack_data(rhead, dp, log);
@@ -5305,8 +5315,11 @@ xlog_do_recovery_pass(
 		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
 					 h_size, log->l_mp->m_logbsize);
 				h_size = log->l_mp->m_logbsize;
-			} else
+			} else {
+				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+						log->l_mp);
 				return -EFSCORRUPTED;
+			}
 		}
 
 		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ecd8ce152ab1..66ea8e4fca86 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -22,6 +22,7 @@
 #include "xfs_qm.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_error.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -754,11 +755,19 @@ xfs_qm_qino_alloc(
 		if ((flags & XFS_QMOPT_PQUOTA) &&
 			     (mp->m_sb.sb_gquotino != NULLFSINO)) {
 			ino = mp->m_sb.sb_gquotino;
-			ASSERT(mp->m_sb.sb_pquotino == NULLFSINO);
+			if (mp->m_sb.sb_pquotino != NULLFSINO) {
+				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+						mp);
+				return -EFSCORRUPTED;
+			}
 		} else if ((flags & XFS_QMOPT_GQUOTA) &&
 			     (mp->m_sb.sb_pquotino != NULLFSINO)) {
 			ino = mp->m_sb.sb_pquotino;
-			ASSERT(mp->m_sb.sb_gquotino == NULLFSINO);
+			if (mp->m_sb.sb_gquotino != NULLFSINO) {
+				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+						mp);
+				return -EFSCORRUPTED;
+			}
 		}
 		if (ino != NULLFSINO) {
 			error = xfs_iget(mp, NULL, ino, 0, 0, ip);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index e22ac9cdb971..d5708d40ad87 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -17,7 +17,7 @@
 #include "xfs_refcount_item.h"
 #include "xfs_log.h"
 #include "xfs_refcount.h"
-
+#include "xfs_error.h"
 
 kmem_zone_t	*xfs_cui_zone;
 kmem_zone_t	*xfs_cud_zone;
@@ -536,6 +536,7 @@ xfs_cui_recover(
 			type = refc_type;
 			break;
 		default:
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 			error = -EFSCORRUPTED;
 			goto abort_error;
 		}
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index af83e2b2a429..02f84d9a511c 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -17,7 +17,7 @@
 #include "xfs_rmap_item.h"
 #include "xfs_log.h"
 #include "xfs_rmap.h"
-
+#include "xfs_error.h"
 
 kmem_zone_t	*xfs_rui_zone;
 kmem_zone_t	*xfs_rud_zone;
@@ -171,8 +171,10 @@ xfs_rui_copy_format(
 	src_rui_fmt = buf->i_addr;
 	len = xfs_rui_log_format_sizeof(src_rui_fmt->rui_nextents);
 
-	if (buf->i_len != len)
+	if (buf->i_len != len) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 		return -EFSCORRUPTED;
+	}
 
 	memcpy(dst_rui_fmt, src_rui_fmt, len);
 	return 0;
@@ -581,6 +583,7 @@ xfs_rui_recover(
 			type = XFS_RMAP_FREE;
 			break;
 		default:
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 			error = -EFSCORRUPTED;
 			goto abort_error;
 		}
-- 
2.35.1

