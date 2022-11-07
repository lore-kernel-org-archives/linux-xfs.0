Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77BD1C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiKGJDC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbiKGJDB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:01 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD6F1659E
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:02:59 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A75fMHB025318
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:02:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=9C6WeaxO10Iugr6OQPyyw7HDzTrL7IVfsbTxKy/l7RE=;
 b=SgHFKx1tYyIK/TgBp/j1QMuhkAWJJzKW+f2TC6VrdTZKoAGttcEp4hEGCggCV6cf1Y2F
 aSf5/Jn/gBoZDRJMzcHXfhxsusDXPM9YnN2IBCjLBOmSLTrZJB34I5Boex7Q/cvbzY5G
 93dSnSq9MUYC0Um/QFY3gYoinrEjcGm2fOdPu5pdH3aYdQB38/56yYyjhWpqZh2zdPuP
 TI8HyNtaZIffQr3/BHZJ1LmFcRqTEWFBu/7H/7qlAptgcbXOOGEiZaZR7JNkJfwjrkGr
 wf64mo8rEDMl10+RvB2ak/FX1x3UV7oVyUq1sjg+JsHqjB1/Me8P9lhRVAMPABW9UeLH sw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngmj30h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:02:58 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A784nKd014429
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:02:57 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctatkrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:02:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HrmLvSxJ22DLMEQ2upjPmzFTZbvb31FK9f8jU/W6pPfh0EbJTwJKJ7sqygps7WZDkWYmuWWev1eHH97KXCHMqkzQLXyihHmDJvvCwptHI8CKPFUQwTXg8os3f9y+KgStht2fimQE8de7vQb4TQkM7OosWr+s4rGs23V5/N5bgkyZbCFr4hw9ZbYHysrZ1pDLI5ZqPK8BNCXzXje+EJt4n61ArZlaXnKa/8E5nisW7wzfMxriwYSFkVaheQs7jsretLVqBiCFhT72kR0DvaBq9DsumzpA34B44y3NtNL9P4r6QwfyHcfFzg1tEoPEs8fvwbxmYBp+FcKcjzkdwpO7yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9C6WeaxO10Iugr6OQPyyw7HDzTrL7IVfsbTxKy/l7RE=;
 b=bDz3+OWMVtQ8WhNUEgL06G5uw6c0xB2PUdrIe4kSI4tL3GBjIrfBPCYnuJuHc8LowMVkyU32m0/mo7ZsbGnhgb1NLcDljIPvm08mb8Ong75C5dPzBgj8e3eDeJgUzomUGrvOP8Z/wyh5236pCL7Pr1kcXSPbc/V1GCTZHRkqUS4wcn3qvb1u95WS5qZBLgUlENeY5DOvUO+dTHrVltKzTbGlAtTg6kBYrN6wgcXu4YDC4I/Ai+Ul9AVlEIW9ggimzfpnEf1YSphRtmTgoga0mC4PLqXsbDwB+Eu3yB0C4M7nQ5FUnu29BX5hDnS4dndH0qYQSPBOk0/9BX+7eEgBoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9C6WeaxO10Iugr6OQPyyw7HDzTrL7IVfsbTxKy/l7RE=;
 b=gVuPvEnuvcCjuhQCvP2bCjFKh6jIJZhzzZP1xEM83/OHWj/J/vioX8xK+cIaYPz5Ik+7I3K6Pd/0I3i9/zJcwnmIwICZliyIWcf3K7TwHYdIoMHVwS3CurfMiSxCrCOUyMY8zSovocPjcn91slsXN+XlG2uPS/AKmd6welLfVOc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5848.namprd10.prod.outlook.com (2603:10b6:510:149::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 09:02:55 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:02:55 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 04/26] xfs: Hold inode locks in xfs_trans_alloc_dir
Date:   Mon,  7 Nov 2022 02:01:34 -0700
Message-Id: <20221107090156.299319-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0190.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5848:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e9751ac-96ba-4c84-0243-08dac09edbde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rYWPfc30J+Qbuyap4LCQ2cjjacQs1iWXgPN0k6/OVUMG3g+isX9g8uVqrV5THdajymCXmYVihyASziDnqaa5cqe0hJyuYooy85fbjZVu+Jb2KR872LFM3oXrQbvjwL8aNmsqfe20BwmbhcOvd+EmY28dUjbv2vIqju8vuIUk5osqj3eINyjDGIn4uZDUHH2PQ7bbmDF+vZ5V7qRFOLlg6NQo+kDjEGoJO02Wq0EFr71wh4wYydOAglLChSzvjZOzB7gmUgLUoIJ3RfJfxb+x+jeRRB6YHFIHwfJ0zIThnXquCCSUgw/t8xDXJebyAu+6saKQ9r5jk/CIFsaX7IFIYRyrVzsXJdzllj8fVr8yuTIi3pd2fVHrLRwCc7X08dqFA7IneFjYvBL9M0nhHBaquk3H7YNqSRdGd16ZTX1ZpcFPaYC9IDCzwui8fQUXC4aj6u0SVxzsKpiK3XDZOisjbWJdziSgKofT9oiXmqyPHc24LsR/6HKwzG/gLBpDNk3Ugr1Hrrdiqj7QDhXNXn3xzh5B6PFLCanUgRNUE3FPbIlFnwVZj2X1UuAEzn9MA/M4YhGZAHEprsyUFKtDGGs2a4rzsBwmO5CB2pGMyRLVZ5dyquRk7A1fTIdPhgIpvPy7EaqI5bvS1v7iHRkbO64HmCbHBH24YXhw/JMRTgeL8HlqfasiDmeuLbuYsxCzhUd6v3dUydmpYe1UQ3j6zBOvqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(36756003)(8676002)(66946007)(6916009)(66556008)(66476007)(83380400001)(2906002)(6486002)(41300700001)(5660300002)(8936002)(478600001)(6512007)(2616005)(186003)(1076003)(26005)(316002)(38100700002)(6666004)(86362001)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QofXGL8sm4OYVtr8Dc8U/EcZm74wRwWKDTRa8P9Ib2sVAOPOI1YaEL9gEW1W?=
 =?us-ascii?Q?nUuQJXiGX10G61yRVlYzDpZrTKXN/j7rnfRqjZ4whz/pgBUN8Da/bKaSMWLf?=
 =?us-ascii?Q?bSAi9n0K5hc8/8/FHmsUKafrv8Dwv8UxNz9NxTyr4GHGg440XMWfvZSE7iD0?=
 =?us-ascii?Q?rplHDZp3qAPywAX6rbexj/p7RsFdPS5deAkRP9v8W/joCBYEEuV9uPhAowbF?=
 =?us-ascii?Q?RTa4mJCSYUb91JJdEwjkgIslYqyJ3SVe7PxKDd/bpQwgiWuML4X5prQXNvN/?=
 =?us-ascii?Q?64PnK2+TF8cn3acfZ+pHt32VPr6XMhQRggJ/mtoyMRIguFTioP0CW4bhY6MC?=
 =?us-ascii?Q?JNk/IpVx399KKCnVrUvGsQ4uyFQ2H4UPOTOZWPZjOIGVQ0zIh1lUGj710aZH?=
 =?us-ascii?Q?/Ah28dsEygu5wlPWQwcX1YKNxNtE01zsF+o7FO7AVUgqDwIukMwXaMCQXqAn?=
 =?us-ascii?Q?Zs4bucjIw9P3trAyl0QZVuS5cCZecvEFQNEOrIFhLIagpkoizRRW08VZGPcz?=
 =?us-ascii?Q?ZRuDmzo1VS0GrEQAQ0vNOEIeNUBtyJQQQaIWUf/b4EZ7gXq5QjwAVPEpJWWP?=
 =?us-ascii?Q?26xyD7Je7j/Kmu15QkQgtEf8ZhNK+o6HsuBQRuLrltxON2uUwUxnokDrl3j6?=
 =?us-ascii?Q?u5HyGpGkr9GzN77GaPIeTGBZZNuMxI886z4FdeE3UTxu5sX1SgJEMSZJag9Y?=
 =?us-ascii?Q?8EdnutS/k/lSUB9flqqHMR1D+DyUd+wbZQm/ioaZMRF3p+qeUBHXGQJhMSI2?=
 =?us-ascii?Q?DCjjEPTSRYPbH4wYqZfvqZS+9o0pqv1dzo7XlD62Q26j5CIAaQwasOdx2pUB?=
 =?us-ascii?Q?H5UKY0+aH4ytZ8jnMJFcMmJZDcOdEe5g2oemtPPViQPdEdIBWy73FGma0650?=
 =?us-ascii?Q?3iRJe9Rq9mc4tbiq8wTesKaU/qcx0xbdhn8L1MvfAmwSknMmneMHhExYtZlh?=
 =?us-ascii?Q?X6u93niW/2vH195tJyAjIyheq/Cxm4uUcGLraEq6kbQioJPDGZcf5ulDyWz3?=
 =?us-ascii?Q?NwsCqdQH865hKcmXFi72Zpm0TaeMrkuDnPqCQMxRw3uu5GPA2TXoaXGOYzp0?=
 =?us-ascii?Q?hugPrdoMLmcViDqewwozibjRPy1CsVWCqQwCQkvPSo5UuDxuKVeMmPITjdoc?=
 =?us-ascii?Q?tyew2hx2tQrUDlrLkt/okZpSSRbR7cIrxt31KRreXuC6wu6nXgp7aNL2BmHO?=
 =?us-ascii?Q?b8KbTMLgkzlB38vQ2PLRKn3c9QChMkgxLw518/zSD+4o1IK9woRrEgbvrWAC?=
 =?us-ascii?Q?24nRxluZebyOW6KbT22hPfq4F9ArmAjU+oN3MUefVP+AeRSE+hn4S0SBDt5Q?=
 =?us-ascii?Q?CdamG+sl9ivY9BVTzfik5I7b9hTgfooGqNOeWZdPAJh0mSeyOoLNz/1uStT0?=
 =?us-ascii?Q?fEOx9D04zBoceB4q+53N1egPQVdj8DF49qy2kk62STvK+beWjwHkXhwtW4Jf?=
 =?us-ascii?Q?KBGJ4f3eom4zWb4swAkLijMQjOSVNlbj+C+mSiBS6YhEGil4vTFJPqO8DHMP?=
 =?us-ascii?Q?6KLqDqcFDWGUQd7uCuXbwNSka0p92L82EUJGZMFPnClyWn8GeK3JF2QgRVeb?=
 =?us-ascii?Q?GO9kzQXBQF+mpX5NFeBUt2zaKCyhZTW7En4imq5d7icmVJPoIvdXIafKHrxQ?=
 =?us-ascii?Q?QA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e9751ac-96ba-4c84-0243-08dac09edbde
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:02:55.3253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7e9EsV4+gQ+V/6teGrOI0PmQqWdmiFpWyb3bfJFBDDLvAZZnfyjRPyzfZsy7enuoHQqu2rLicJtPqTFPuZvjk4f0BhyfiOkmQj9wIIhfbMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070076
X-Proofpoint-GUID: itauGU3OD0aBg1f_42uckKplBRILCR2u
X-Proofpoint-ORIG-GUID: itauGU3OD0aBg1f_42uckKplBRILCR2u
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_trans_alloc_dir to hold locks after return.  Caller will be
responsible for manual unlock.  We will need this later to hold locks
across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c | 14 ++++++++++++--
 fs/xfs/xfs_trans.c |  6 ++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index eebbff3b5866..eb4a9c356e77 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1277,10 +1277,15 @@ xfs_link(
 	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
 		xfs_trans_set_sync(tp);
 
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+	return error;
 
  error_return:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
  std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
@@ -2516,15 +2521,20 @@ xfs_remove(
 
 	error = xfs_trans_commit(tp);
 	if (error)
-		goto std_return;
+		goto out_unlock;
 
 	if (is_dir && xfs_inode_is_filestream(ip))
 		xfs_filestream_deassociate(ip);
 
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
 	xfs_trans_cancel(tp);
+ out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
  std_return:
 	return error;
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7bd16fbff534..ac98ff416e54 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1356,6 +1356,8 @@ xfs_trans_alloc_ichange(
  * The caller must ensure that the on-disk dquots attached to this inode have
  * already been allocated and initialized.  The ILOCKs will be dropped when the
  * transaction is committed or cancelled.
+ *
+ * Caller is responsible for unlocking the inodes manually upon return
  */
 int
 xfs_trans_alloc_dir(
@@ -1386,8 +1388,8 @@ xfs_trans_alloc_dir(
 
 	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, 0);
+	xfs_trans_ijoin(tp, ip, 0);
 
 	error = xfs_qm_dqattach_locked(dp, false);
 	if (error) {
-- 
2.25.1

