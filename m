Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E4B3C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235380AbiGRUUt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234987AbiGRUUl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:20:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9462CE01
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:20:40 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHXfao024556
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=s/pR0C/jiCpALnJA1EEzWUFgLfLKq77vi/3k1uKv564=;
 b=L1Ke6/LgnhCucTW47/imUK9DAamLVWcFlRGnfhPLzYSg1djoLTeX2aAxc2q5wOs95/Zk
 aDn/TyUOK+n4oCsrBlE53CXaAaznQIaUeJkCoA5smIkt0hEF42iiP3f+QoqODuPsr2tp
 PFnh5bd6nwbX8eA9jSaWI+ElEJXqHAQFPQJ6+cdWBv6bFXojAjml/OIp6UXDlWVkULpU
 IlhaKzBH33/LAFDN0/rZ2yAf5sisY7/QT9fMzSe9mqW/Fll0wmODqcs/JpnCPfspwQP1
 zZQf/9kWwPRyndIt2mzgibo1Mt2pRuqRd7ir7kZotYg1usxoFkItBIgo0dFUrZXDqo18 9w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbm42cej7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:39 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHVRS0007937
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:38 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1ekx2da-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BB49SwCrZor/8rh5o1QyoqDXb/n6VPPesJagaAw66/p7YXtWpM1dYooT5ZBcp/yK6FtSRV0JfLZSAIH1z8otePJEGI7bIwlPx7IqRtr0w0IeyGGRZX/hk4vMd9BLOlLpsHkdRE8kVg4F8LjFDWyPPnGEgf9Rn6J7lHePOrcS/rFi8LiJlxur7eSpD6EgI8VepD5jEcHIdCmbdui2I1soo53LLZ/5RuJwlr+cckDa2x+1HVZjVkUSOL00pMvVXmhf5uLki0MatdWlXt4nlzxrqp07cOa4a3moaiQTQUOGrkFwpObyriaQSTYavCJm9df7tSV1HqvgqQR1U6dH2yAY6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/pR0C/jiCpALnJA1EEzWUFgLfLKq77vi/3k1uKv564=;
 b=Dp/ctupJxGbSD1x8e7harj95I4oy8x7TBUbzKmF6PHowVsr159RP6vPz9aABO1izvLAcNlK0ZGK7MprQll4g7c6j6YxkAqgMzAMPrKMOt7mBPb2jQjabpV4jzCMM33bUro5zYzxQf9CYAg47d7+2h7+5/C/XQcBvjEGKe9snOoSOI583mNnWWaRfFRHdrTT8WXRQEB+e9mIccnbCUf02KGLnZeHN9xi0NQeLWVamlbdMUUg6F2ywQ6r6d6WsuLAEaaxKRwAo90GZf5houd6/8cPTr6OVUbIaplnmSTsn3HEM76+E2ZrqLz1ceb2Du7ookG6z5Iy/lOALDUGdcTr9xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/pR0C/jiCpALnJA1EEzWUFgLfLKq77vi/3k1uKv564=;
 b=xNf7UGt7y8fMAVxEGbuSDzgDhBNma4PpA732dZoCjfzhga5m0w1G8YerMwljTLvHDJcGD0m7l9ThZqorOo+4ZPzz/5iaqbQyHLyn82VurSJ4dl07h+GXb6P2b1keAlgUZV4PGuAnsfEAJOLw8lesRr2FkeaJd1zF5cJszniV1xA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN6PR10MB2717.namprd10.prod.outlook.com (2603:10b6:805:46::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.22; Mon, 18 Jul
 2022 20:20:36 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 20:20:36 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 15/18] xfs: Add parent pointers to rename
Date:   Mon, 18 Jul 2022 13:20:19 -0700
Message-Id: <20220718202022.6598-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718202022.6598-1-allison.henderson@oracle.com>
References: <20220718202022.6598-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a62ba6d3-1f0d-4f0b-29dd-08da68faf793
X-MS-TrafficTypeDiagnostic: SN6PR10MB2717:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PmMkjDQd8Hvq6igtRRIuhQ8FLZ413VfGv8MrFS+oLvVHaGyo0LCqDRLLdSTDZCDDE+/LCZZCUoDJp0PD4X+Boj8POdO+dfRZv1t6LuKAj7ssT9PIivNynYCa8y0qsLf/DF4ZTFCuNvvIgSpWlOYSJXj9aQySgApn5DucPuZzbQrosnQ3xO54FRGFlZTglFSPD6+z4aSK2yivPjuY8kvMvh/OuWy3arfEKZOXvN+T0RZwV2X1NiZ8GkLKF7ffh1Tiu3YyPH7ak1GgmGRQ90o0KMpNG1KdeMXUigF3mNiz1MbnSx/EBQtvrCktif4gKS71lnRLxA3gzI5fFFVyAcTbzf4BNiS5fVqUvNBMgaBHB1FQ8Rlb4Bdmkw128Nt3ZoUsaH8lGs6H0Vh//5j6YZWg+2D5/bLGQCyfTkXeJZBFk3GyLN3q5TVg+VKsWC1yZogxBD0srtX4Li4wqrENX4UPXms6j85zALUkSlfbTIXPYpTLoSj/KSgrtc/GpxDkIFDksMpE9AgNSZ9GK2RJvLheuGnXeu6Y+VP6o46kGibtFT2E7wAKq9IYXO5MxgBaed5/0gS1VxHmPvjzZ0xrpdhOZYhYjPGM5nah79Mq1wlAhtztVKPQW3MKP/R25MDpP5E/4SLWMCM8H3ovUesRMaTAAw1pHGtc/7eudLTdGDe7qGhitRjszD5Fctc5m/+Hp3GX4N90DMlSN1eONHLPbEMquWcmn6GApVJOtmaOgAs58rjjwVIAfiupDJfjk421ebJeDCYgDACikfcsx/gvyURLD5gd/1XBVVnQCdxvm3cZd3Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(366004)(39860400002)(376002)(66476007)(2616005)(1076003)(83380400001)(66946007)(8936002)(186003)(5660300002)(2906002)(36756003)(6666004)(44832011)(316002)(6916009)(6506007)(26005)(6512007)(8676002)(86362001)(41300700001)(478600001)(52116002)(6486002)(38100700002)(66556008)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YTyjsxvAj+6rDv6bFm3vUvXnjgtIaGjcxWxgNyUyD00pR1F+oca1peK2PwDR?=
 =?us-ascii?Q?CPSqXSlQsDjbg+mO3NhC9+Z4zkSeumcv95hq00AhyOmAyLwKacePijzjACMZ?=
 =?us-ascii?Q?vdQnSpXNjAlCs4LvAshqW5zZUhZKR2asp4KpkogjPkURw5ezcBNrgn9QM7Jk?=
 =?us-ascii?Q?Pf4vXjKbCssdKLOdD58FoiQS3Ugwu5iVwJc/3ivqx68uxP0OULZtT7r/3+o+?=
 =?us-ascii?Q?CpsZsMIUwoPULGhVj+YBiXekx0/c8YxiZgbO/lDTLIyuEbaFz4pv3SuNUL2h?=
 =?us-ascii?Q?Y21I8bN0Fu8ULhgYdoKyi9tT/FRc9/JFqkqgEkNS322Q/4VPF/gSbQGR5O2W?=
 =?us-ascii?Q?0hr8ps7VEHLRF8wyVuvNEMo7nIaLo58HYcO/LfYDELXisoFJoVSy2mBfXnmk?=
 =?us-ascii?Q?NX3GT1D/zPfKW3BBjdvFpKws37NyaghhLs2HZMgTtK0qsbIjcMhKzQVIhbnP?=
 =?us-ascii?Q?0xjtp5nS/ANhD4WDiwl560iBQbU01ScE/lAvWL0JkokRDrK9Xau6fAuHfjx1?=
 =?us-ascii?Q?otXgJyoLLTIUFXMtHDrGX+Dfqz4U4UGOto1agEy0DiuUeQ3WHPaFdRjpXPkU?=
 =?us-ascii?Q?e9fQ7K8LmjO2yHnTIPTwhd1PWFmvAg3uAmDnBRjaine8gnuxN4yzfbKKVGRY?=
 =?us-ascii?Q?t6bQCIxnMRhAGcGq9dUpZkd3QJY7GduNTXGXDLKiamnqKt5kILfDABqZjj7i?=
 =?us-ascii?Q?pxZYIVy2km+9cbY06pE24ZQVxjNxGXxZDWwxejILlWsYVw5+p89LL8gsDWf7?=
 =?us-ascii?Q?te2swi7zM6n7+kWQCQHILP6JAE6S5gBud/qiujWtRl/64cLhc/Ln1GCiCasj?=
 =?us-ascii?Q?KWReih4dass8/JQAtVfO6Z7yLjPw84XBYgwaw6gBk/07gxspM0hwRkQAj+Xz?=
 =?us-ascii?Q?IvPUN5UjhLqV4waMUruToR9AWwZ3jUFKlfJL4kxbypoymLt0xlhC6A8xye7Z?=
 =?us-ascii?Q?e7JqULOctNS9ybxs5iOm+jLOEiFqljI4o3W56NZPZBTZnKfw2nk7tjnSmtLP?=
 =?us-ascii?Q?0+OMIw/NB+AEBHm2lec/UtVu+XESQcG4sJcJnkl2me9oqcQ6GN4AP5ArGqfE?=
 =?us-ascii?Q?QQGfg/Az6iL33fbt++jyaN3QEk8out4s8AsDk607Ou3Gef+zVPhLyL6w8/r1?=
 =?us-ascii?Q?Ih6t18dtcO9I9SRwnHYb0TrCQfChDbXFdPjjtH2IeATZUFsYeeOLcI2oUxyx?=
 =?us-ascii?Q?UwS/ghKrBX06dgdf7i5MvObukhPAHLv5YLcte++hlwlpY7PzL4UQDfCC7wyM?=
 =?us-ascii?Q?CNhkIIHpLsfhxyBzneYcJ1ERSh42kG7R0MzA/kxTDvjlbl8sAXq0Lljxr5IQ?=
 =?us-ascii?Q?dl8K4bTEyf8KaPoGrzd1VfbLOY5WFL4LVlVIW90L9YbbD/eGmDhT9GXh613g?=
 =?us-ascii?Q?W7LjlCI/W5b0bAiF6C9Z2gQ5S/m31FUfTWbp+op9pBFo11wZGrfrelP/48PO?=
 =?us-ascii?Q?Y+dz+s2ED2VsgnRh5f8HK05JBmgnCEJLHYPrdA2gU1bq0PvRvdVY/eMtInr6?=
 =?us-ascii?Q?g9W84mU+xTPW8IxjEjSj1hzSSssA5o/M81qJMWkVxw6OKw5/XyAs4jpKNEF6?=
 =?us-ascii?Q?qgGqxJxMIupfSi/Z4Kx07uNuOheSRtYR00czXgvsxgcRqEjS5YWydG6jg4vk?=
 =?us-ascii?Q?JQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a62ba6d3-1f0d-4f0b-29dd-08da68faf793
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 20:20:33.2325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3ngJRouHWGVGBSL8zXoJYPGXFYz5C/2cPIJt7DsNn8NHAU5fl4HTP5S3AlURKmSYA7oro7ziRNS/Z2GblLB3b+x4V0lvipXaBxhKqR/iEC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180086
X-Proofpoint-ORIG-GUID: xE73YtP9zdGNAcqRwDWN9FHHMMeFXnbW
X-Proofpoint-GUID: xE73YtP9zdGNAcqRwDWN9FHHMMeFXnbW
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch removes the old parent pointer attribute during the rename
operation, and re-adds the updated parent pointer.  In the case of
xfs_cross_rename, we modify the routine not to roll the transaction just
yet.  We will do this after the parent pointer is added in the calling
xfs_rename function.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 128 +++++++++++++++++++++++++++++++++------------
 1 file changed, 94 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 69bb67f2a252..8a81b78b6dd7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2776,7 +2776,7 @@ xfs_cross_rename(
 	}
 	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
-	return xfs_finish_rename(tp);
+	return 0;
 
 out_trans_abort:
 	xfs_trans_cancel(tp);
@@ -2834,26 +2834,31 @@ xfs_rename_alloc_whiteout(
  */
 int
 xfs_rename(
-	struct user_namespace	*mnt_userns,
-	struct xfs_inode	*src_dp,
-	struct xfs_name		*src_name,
-	struct xfs_inode	*src_ip,
-	struct xfs_inode	*target_dp,
-	struct xfs_name		*target_name,
-	struct xfs_inode	*target_ip,
-	unsigned int		flags)
+	struct user_namespace		*mnt_userns,
+	struct xfs_inode		*src_dp,
+	struct xfs_name			*src_name,
+	struct xfs_inode		*src_ip,
+	struct xfs_inode		*target_dp,
+	struct xfs_name			*target_name,
+	struct xfs_inode		*target_ip,
+	unsigned int			flags)
 {
-	struct xfs_mount	*mp = src_dp->i_mount;
-	struct xfs_trans	*tp;
-	struct xfs_inode	*wip = NULL;		/* whiteout inode */
-	struct xfs_inode	*inodes[__XFS_SORT_INODES];
-	int			i;
-	int			num_inodes = __XFS_SORT_INODES;
-	bool			new_parent = (src_dp != target_dp);
-	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
-	int			spaceres;
-	bool			retried = false;
-	int			error, nospace_error = 0;
+	struct xfs_mount		*mp = src_dp->i_mount;
+	struct xfs_trans		*tp;
+	struct xfs_inode		*wip = NULL;		/* whiteout inode */
+	struct xfs_inode		*inodes[__XFS_SORT_INODES];
+	int				i;
+	int				num_inodes = __XFS_SORT_INODES;
+	bool				new_parent = (src_dp != target_dp);
+	bool				src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
+	int				spaceres;
+	bool				retried = false;
+	int				error, nospace_error = 0;
+	xfs_dir2_dataptr_t		new_diroffset;
+	xfs_dir2_dataptr_t		old_diroffset;
+	struct xfs_parent_defer		*old_parent_ptr = NULL;
+	struct xfs_parent_defer		*new_parent_ptr = NULL;
+	struct xfs_parent_defer		*target_parent_ptr = NULL;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -2877,6 +2882,15 @@ xfs_rename(
 
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
 				inodes, &num_inodes);
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, src_ip, NULL, &old_parent_ptr);
+		if (error)
+			goto out_release_wip;
+		error = xfs_parent_init(mp, src_ip, target_name,
+					&new_parent_ptr);
+		if (error)
+			goto out_release_wip;
+	}
 
 retry:
 	nospace_error = 0;
@@ -2889,7 +2903,7 @@ xfs_rename(
 				&tp);
 	}
 	if (error)
-		goto out_release_wip;
+		goto drop_incompat;
 
 	/*
 	 * Attach the dquots to the inodes
@@ -2911,14 +2925,14 @@ xfs_rename(
 	 * we can rely on either trans_commit or trans_cancel to unlock
 	 * them.
 	 */
-	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, src_dp, 0);
 	if (new_parent)
-		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_dp, 0);
+	xfs_trans_ijoin(tp, src_ip, 0);
 	if (target_ip)
-		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_ip, 0);
 	if (wip)
-		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, wip, 0);
 
 	/*
 	 * If we are using project inheritance, we only allow renames
@@ -2928,15 +2942,16 @@ xfs_rename(
 	if (unlikely((target_dp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
 		     target_dp->i_projid != src_ip->i_projid)) {
 		error = -EXDEV;
-		goto out_trans_cancel;
+		goto out_unlock;
 	}
 
 	/* RENAME_EXCHANGE is unique from here on. */
-	if (flags & RENAME_EXCHANGE)
-		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
+	if (flags & RENAME_EXCHANGE) {
+		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					target_dp, target_name, target_ip,
 					spaceres);
-
+		goto out_pptr;
+	}
 	/*
 	 * Try to reserve quota to handle an expansion of the target directory.
 	 * We'll allow the rename to continue in reservationless mode if we hit
@@ -3052,7 +3067,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres, NULL);
+					   src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3073,10 +3088,14 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres, NULL);
+					src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
+		if (xfs_has_parent(mp))
+			error = xfs_parent_init(mp, target_ip, NULL,
+						&target_parent_ptr);
+
 		xfs_trans_ichgtime(tp, target_dp,
 					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
@@ -3146,26 +3165,67 @@ xfs_rename(
 	 */
 	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres, NULL);
+					spaceres, &old_diroffset);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres, NULL);
+					   spaceres, &old_diroffset);
 
 	if (error)
 		goto out_trans_cancel;
 
+out_pptr:
+	if (new_parent_ptr) {
+		error = xfs_parent_defer_add(tp, target_dp, new_parent_ptr,
+					     new_diroffset);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	if (old_parent_ptr) {
+		error = xfs_parent_defer_remove(tp, src_dp, old_parent_ptr,
+						old_diroffset);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	if (target_parent_ptr) {
+		error = xfs_parent_defer_remove(tp, target_dp,
+						target_parent_ptr,
+						new_diroffset);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
 	error = xfs_finish_rename(tp);
+
+out_unlock:
 	if (wip)
 		xfs_irele(wip);
+	if (wip)
+		xfs_iunlock(wip, XFS_ILOCK_EXCL);
+	if (target_ip)
+		xfs_iunlock(target_ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(src_ip, XFS_ILOCK_EXCL);
+	if (new_parent)
+		xfs_iunlock(target_dp, XFS_ILOCK_EXCL);
+	xfs_iunlock(src_dp, XFS_ILOCK_EXCL);
+
 	return error;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+drop_incompat:
+	if (new_parent_ptr)
+		xfs_parent_cancel(mp, new_parent_ptr);
+	if (old_parent_ptr)
+		xfs_parent_cancel(mp, old_parent_ptr);
+	if (target_parent_ptr)
+		xfs_parent_cancel(mp, target_parent_ptr);
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);
-- 
2.25.1

