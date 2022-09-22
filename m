Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA94AC6FA90
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiIVFpk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiIVFpb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4657AC33
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:30 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3DxgV019757
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=6sbOXN616MxG3mZVnvZw13E0sYEiIZHo8UkznSHOOG4=;
 b=iUJFFAQOAZYkODy6z7yLd/jh5Aove1ZeAWuAvvDYLlxrciS7uGhji367itxbzr2bQtts
 90668HCHDByVuHm5euQotCK4eRJCM4Zos7UCm5rX/c6+UuujparGNg96ltWJJVUro6EH
 7a/63J4+bP1UXaEYO1YNCYtI2EKYu4bW7Y2VFLwMp0JBqasoBQyqPwLK0G3KQdMXpBht
 UIjgtGQFIWcqC/aGgFzcgNwEyWrkg1U9DT9eYYa46VMvEfCkUYkFRbVtDbqXB7kYHzfM
 ZOAiwsMV1iomtybpt/hyWTCIaWfTUqK9vVfRgkZ42UbMPOEJs+47TuXtHyNNJadJFLRI Gw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kvchj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:29 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M51ici017185
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:27 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cavkdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2V86yXu9veuenALLICXZPMgfv53Ir0mAaLu/j18RrSzoP56UlDpQrndIy3323AqeQTBGkaofzCaqVevrA1dX0aLlg/okRjasF0sUvKU70LaoGzz8eKFsXNo0FrVKunM5rro0E5Rw109u3fix2NthOiAF0wI/MUds0sstfRHrl1f2fXb78Hf2V0+LRQOP9Be4Vl9DGtuUSbdcIEDRT4qKcpBnwpu/Cnr6VucWvO5ZJyC811xnmKz4M2WCOtN/yh553R8reKjUdJ5xMyOYAyCyinF43boCqu9180CRPyC4o7NZz7/sBD8AnHL9iM0qxNi/TLKR270BbSDpkU5kN3HJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6sbOXN616MxG3mZVnvZw13E0sYEiIZHo8UkznSHOOG4=;
 b=MqKNjeR4d9mc9PtXJn49sN3daC8WImeluUYZiwcVbZHsV957UMkrFVKrKo1tU5wpvWbdojsq5Z5Mvc9FreaYByIZsX69sR95SxB5KsT9uPIflU3CzqCasGfY8GuqMv7WRVB7zhoXApwVxyZgKoyF8D8EFSeE/tkAIRDIPW122cRUXqv+SQHF66UoMzXa9KfCOvduljAxs+F1BCJR6ZH9UR5o/PnhxFY/Z2F9xexYOeERN+i8FfAGGfZ9/0KPb9pk2O5lZJP4PuQ2Sx3MJpsIIi9O4jsvAUxLvdAG3o8bqXUcAfZ5Bc757dBw3d2GoxE6XjdeU91eUVAQxuQMBFvPXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6sbOXN616MxG3mZVnvZw13E0sYEiIZHo8UkznSHOOG4=;
 b=n/eVQt7DJNf+dDhHV1OPZlg2MlJXjsk5T9mFpT9Pst1LyQnEU1TrFnTIOrEYB+h1BOK+Ahl/LbiWOoIIEVM3mB1e/Yn/9h9ywBBwlb/f/LlYv6qv0yFL8o7DN2GF9f8tyyNUFLYJ6svy1GsaE0ie8OH3pv7jV7VFBRH/QV/cXq8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:26 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 18/26] xfs: Add parent pointers to xfs_cross_rename
Date:   Wed, 21 Sep 2022 22:44:50 -0700
Message-Id: <20220922054458.40826-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::48) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: 95e2614a-9c0d-4cc9-0408-08da9c5da637
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eG8cf44lXNjpi0C0/Vbi++gzYQDtT6nzjdrpK/o/YUx4GIspyDoLSnmtd3bjvnewkNrsvGWcj5Xc2v/qMsCzmC9ChyqPT91vG/a1IhEuk2oUrx94kbHjy61tQ7sMkvw3gv8RUWZ8d70Yz8+D+PaaI5b5+jj4OI+niZD3sEUBjbIVxYYFQy4djX0g4aOPS5UFUy3o+mKpsqc9MVtgWLwvNZl+7/swHJQUvQiXA1pzMRgr5fMDm5OvZlwQKjo+XurAdfdxyO0Ur75iwfwspxnSiUtEbDw8ZP1JO4QnNfzRdMtQN+uQuf/POPHqsvuY2dPuzhe8W48mW2aAkWXdg9GaBbp5bI9c36MngdxuOavLuz6yEAve6xlL+DCQDHUqmkEkVtKi5GxUHjhLZT9phrh3ZqClgzFyXrn5Juc0KsCWonbIlrJdnRR/mQKmk2RWCJ6cCJtZqdPHS9cvs+3qGr5yfza/9nuC3A3IdH3w8WVlzLTzi0C5UPAdevLx16TBjLo8NMKbHGevnEAg9H7MtIhFp3qFMl5h2Xuiq2Mc88l43SermoblJleagf3fMfHwnXJSHOZnWVTeJgEA8xi2pcoAB0aefV0KW0xQbBtd0tc1J9cV9/hcqN33RYbdeoNXi97iCRnqf0+kBAmnAA9iTwAaXoL9AhT1L1DAJ19mXwpZo42hzb/tTJtQOoZ1tWwz5f4ZlCmLa6aYYdHDnDQ5h3PJcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xWAv/+PAki4h4U/KrtxLiVFBL0Hmb6Hfp4RWfwHzsHtUEFMy5lpO3QNZOGMN?=
 =?us-ascii?Q?6r47iiA0qKdPwgSyNvVwmHvoo5wo3tSx2N8sotjRxL2t9tnByahi1Uxs/31E?=
 =?us-ascii?Q?I5m/A81cjBs+avQ/MNk5cpZb0mop95Cp5lGPNHvieKHA3zs06ArCULBnqfx3?=
 =?us-ascii?Q?x1Vd8p1GNGuOCg/V7EwTNKk9TuDQcgt1n/Q3v6sxleA+/d9G7CXghKxoJ82G?=
 =?us-ascii?Q?V8AdEwK6bmJpiXapQeU0wqfLjxIJ87ZqbbP5hsNKNHsgs+SbQ4BQbPa7Svm9?=
 =?us-ascii?Q?VnbBrwYLXP3M4Z07VCjhY0V6c+LkcRwOiVhzRE1IlE4wAG9hlz5DNsw85OqW?=
 =?us-ascii?Q?p9HXKcjvx1fLHU2ufbCq77Wbi5MPMcpFNwJVMr5GidyMTAFwvV/wAEDsXEgM?=
 =?us-ascii?Q?ShP0t63w61i0kX4E4JgQfmItd3UEA1WYA25uQIX1OQlDe0iTgDUbjh+Gs9um?=
 =?us-ascii?Q?74c+QuRqiiQTIHJ4osGvUzccxPeMu/AtYPcHF5UgNGumL5xkAJ37LexJgdXZ?=
 =?us-ascii?Q?K0mmFG+eOkXdKI76sU1N6JM7BC8ebL+gyUxEal4OIOxD8p+G0VRl26agdHbD?=
 =?us-ascii?Q?fMnm11rvdCa4CVmkAlSoMCXJBpf9Z9+SqWcHdws+Kjk7fpdZ7FVok4dBdMrL?=
 =?us-ascii?Q?fBCEw/CbcSuJl1ksH4X5+oNOk0KLzWvhxNM2sF/jsLggIqRYpfXg9geE0aBu?=
 =?us-ascii?Q?enxEryYtA78Ik/PobreB6pSc+MoEkMtaG8qGCXgGCqHSwrYhCT7POVi9evec?=
 =?us-ascii?Q?47L3ENsekIiN6C9hEgBi88YkGOeNQYnpjwfBDEl4VuHyhqwvEUPxVTkdcwos?=
 =?us-ascii?Q?vC7yaGeKGV7LmU4a0pk9mkz0NZ+ti/LnQs/m6OeKHMZ3LhDV3HPoMHA8PuED?=
 =?us-ascii?Q?KReR21Wf7twrZ2GPfZOQyENjjs2R8H2CZTN+ikQRSjZO//HBwk6wknQ/0v5t?=
 =?us-ascii?Q?gxlO0KL0HA03AHWYLkkOImbFcT6+wsCCysvuf5u6U5JDKgftHF18uu2mLRjv?=
 =?us-ascii?Q?qUg+6Uwa+is2VOfK0dI35zVm/QMY24u+5AlK8X3ouY3Sutf3zPvBPaWO8yg/?=
 =?us-ascii?Q?GAKfvAK5PJxt0k8bUaMfGse/D3CAGXR6twR6QQsDPidrsha4YjnYydIyUXiu?=
 =?us-ascii?Q?MgTybyxMLAlkjek1uzZgonPGp0giy/HiPA3vtOHDHDUXtQl2l4Vkaa34xLSd?=
 =?us-ascii?Q?apb4OH/WTbV/SUkZ/J1Na3dJzTWVJRWJk18HdHlAVV5fvbpH8PZDy0ap3d19?=
 =?us-ascii?Q?DUDq7w8VlX+E25oyOUOSM8JC1qFLmpQy1OCH4olbaQfOHKW14ZfOwiGau1Xq?=
 =?us-ascii?Q?ZM3vPybghpg9QhrQlLzvfE0FTB+rEtpOFEG1+7E/xzLQqqdVwo3WDtr7X7FQ?=
 =?us-ascii?Q?2v/0mG3e9gFpOjgFRd0mjMLSgtL/PAbeSSRlsWYXxAqzkuvzsYXBHHoUlWJk?=
 =?us-ascii?Q?+mDV0arkHlIBIuOt9mYyuid2LRURFBFyPNc4d9vTxbXQ8emnk12JfZjgJKy8?=
 =?us-ascii?Q?zTXsBm+lp5ge1Sru2BuK+jWe+lPUjM5cuxwXAxZCVBin2nhOj4/4VxvmdDXE?=
 =?us-ascii?Q?WazRELlqfiywKLvm+LwItUiZE+1IX5ByM+szeNHrTRgpzkw/LSf2dOGTnEQl?=
 =?us-ascii?Q?uA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95e2614a-9c0d-4cc9-0408-08da9c5da637
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:26.1643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DCwnC4skl5kg2yjTbkWXT2hubVvmS2odauhQePL8aijc8neqnqN6y1tNFxKXgrar9gXDdsM5bdFrfFw6PsfJwpCSZbHNxVBQfar2OL2MwgQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220037
X-Proofpoint-ORIG-GUID: Wefx_NJLmfp3X-0GqBOQuSudpR7zgyAn
X-Proofpoint-GUID: Wefx_NJLmfp3X-0GqBOQuSudpR7zgyAn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Cross renames are handled separately from standard renames, and
need different handling to update the parent attributes correctly.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 85 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 70 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1a35dc972d4d..51724af22bf9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2682,27 +2682,49 @@ xfs_finish_rename(
  */
 STATIC int
 xfs_cross_rename(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp1,
-	struct xfs_name		*name1,
-	struct xfs_inode	*ip1,
-	struct xfs_inode	*dp2,
-	struct xfs_name		*name2,
-	struct xfs_inode	*ip2,
-	int			spaceres)
+	struct xfs_trans		*tp,
+	struct xfs_inode		*dp1,
+	struct xfs_name			*name1,
+	struct xfs_inode		*ip1,
+	struct xfs_inode		*dp2,
+	struct xfs_name			*name2,
+	struct xfs_inode		*ip2,
+	int				spaceres)
 {
-	int		error = 0;
-	int		ip1_flags = 0;
-	int		ip2_flags = 0;
-	int		dp2_flags = 0;
+	struct xfs_mount		*mp = dp1->i_mount;
+	int				error = 0;
+	int				ip1_flags = 0;
+	int				ip2_flags = 0;
+	int				dp2_flags = 0;
+	int				new_diroffset, old_diroffset;
+	struct xfs_parent_defer		*old_parent_ptr = NULL;
+	struct xfs_parent_defer		*new_parent_ptr = NULL;
+	struct xfs_parent_defer		*old_parent_ptr2 = NULL;
+	struct xfs_parent_defer		*new_parent_ptr2 = NULL;
+
+
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &old_parent_ptr);
+		if (error)
+			goto out_trans_abort;
+		error = xfs_parent_init(mp, &new_parent_ptr);
+		if (error)
+			goto out_trans_abort;
+		error = xfs_parent_init(mp, &old_parent_ptr2);
+		if (error)
+			goto out_trans_abort;
+		error = xfs_parent_init(mp, &new_parent_ptr2);
+		if (error)
+			goto out_trans_abort;
+	}
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, &old_diroffset);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, &new_diroffset);
 	if (error)
 		goto out_trans_abort;
 
@@ -2763,6 +2785,28 @@ xfs_cross_rename(
 		}
 	}
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_defer_replace(tp, dp1,
+						  old_parent_ptr,
+						  old_diroffset,
+						  name2,
+						  dp2,
+						  new_parent_ptr,
+						  new_diroffset, ip1);
+		if (error)
+			goto out_trans_abort;
+
+		error = xfs_parent_defer_replace(tp, dp2,
+						  new_parent_ptr2,
+						  new_diroffset,
+						  name1,
+						  dp1,
+						  old_parent_ptr2,
+						  old_diroffset, ip2);
+		if (error)
+			goto out_trans_abort;
+	}
+
 	if (ip1_flags) {
 		xfs_trans_ichgtime(tp, ip1, ip1_flags);
 		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
@@ -2777,10 +2821,21 @@ xfs_cross_rename(
 	}
 	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
-	return xfs_finish_rename(tp);
 
+	error = xfs_finish_rename(tp);
+	goto out;
 out_trans_abort:
 	xfs_trans_cancel(tp);
+out:
+	if (new_parent_ptr)
+		xfs_parent_cancel(mp, new_parent_ptr);
+	if (old_parent_ptr)
+		xfs_parent_cancel(mp, old_parent_ptr);
+	if (new_parent_ptr2)
+		xfs_parent_cancel(mp, new_parent_ptr2);
+	if (old_parent_ptr2)
+		xfs_parent_cancel(mp, old_parent_ptr2);
+
 	return error;
 }
 
-- 
2.25.1

