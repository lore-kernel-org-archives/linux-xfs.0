Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C038C3A59D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiJXEzT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiJXEzS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:55:18 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7043FD52
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:55:15 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29O2ct4u031152;
        Mon, 24 Oct 2022 04:55:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=JcmvDPwo3reIGsVRlV3LzUTvKHmzfFahu29LjliXOYY=;
 b=Zilb68Nngxv+9nwNrL3/0ElaT1jvQ/Ea52o3rUxPfneR8u/x2An+I2ZY2WdghASO7nEV
 fflas6lxv7LS3oV0imT9J9CVtSG5NTluhUTKQCoBQfqGUPOgNKHpdEVjs3EWoeeMtDW8
 5HWRUMK+Np+xd7O8ZD1jjvPGEQEqaGjrMafCTAB+/Jt86VIahGabSeN80N8JQYnlPxna
 tvRUtgRQdCMJhaZ/eN2F1dekaY7+/GnsG1utEiI+5ADOfRH3vt3yX2R0sikV6zvELtt2
 tmTeP+J/smLQuUxXC+MYgGYLcs5A1dBgbg289BY54lupJiZs4HOj6HwZ07Uvu2/ytYLQ Wg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a2tnra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:55:11 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29O03WwL032281;
        Mon, 24 Oct 2022 04:55:10 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y3k8q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:55:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QtlM36IJ7Ue0KLNur/QuBXlM8C/MAlUCLPO7FBMBIjKav+JviYoEN1qSV0/XfIODDnLCOQyNM4xiwHB/m/OQ+3JxOPSgMLUzUMaEQF//0P0y6Zlxy12xQFd6M+Vgz6O6VPE4kTHjDWFz4rqcY7sdP/u9gs6gEWWiUXAt13UxtK2pZx8BtgyhkNNwvYR6YA0uaMKE5FbRBRAZG0Mok5kFfZ2lULfG9+KCFoBgPX7VnHmW3z/TPUu3ImOFZH42OXBp6wZTFjowJPR2kT+u2Ol0+jH8nqZKoswYPmZr27D3ZkOKO8opLX1RiLYC8XLAkvA3S6sBrrvfU0PKugFXB/xZqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JcmvDPwo3reIGsVRlV3LzUTvKHmzfFahu29LjliXOYY=;
 b=AcTycBCtXxsOfY13H8JPUhdbcGIrxtBdHM2JghPj4Ub+SyTbaXQBbWi7MDjC0PC8LjOm5wqik0Kg2l7A6cPisdt8mX5aWyjeE3cfOuU8xCxoIIHC534d8wa1Pi7TAfoFGIr3vzgC2JG1dpgo83oBakQbdkaQhG6BneyIJFrnJdtzdUIYcLVWuRsnx1NqJaAIYeJeT395ZWbQKWbxXop6pc6OTB/IiKJ7WSeLgIQRhPQOGTyC2WOtA+GVJllEErXKH2V71aUlg8zZSdxfZpeZtnJBCAcPQSXIgngQllfWi3topSUzAMu7z1GNqMLuRhrD/8+lSBdcmuo9bB2LWJPe2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JcmvDPwo3reIGsVRlV3LzUTvKHmzfFahu29LjliXOYY=;
 b=uWtMaX5DBhPQJphTXYXfcgRCoL1P9C1JSr5B0ChulyN6RH3bifK3T1msIMAqMvwYV/+t6rPEc85LvBEbug0Akd0d8v1xpkmmmhZmApv+NiTFSt8PMkT+CweWyNae7a4+Mj4EntGw99WprXLgdh+73AQ4pAT6GlTFnj0MJck2tmc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5374.namprd10.prod.outlook.com (2603:10b6:5:3aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:55:08 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:55:08 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 15/26] xfs: fix unmount hang and memory leak on shutdown during quotaoff
Date:   Mon, 24 Oct 2022 10:23:03 +0530
Message-Id: <20221024045314.110453-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:4:195::11) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5374:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f387dc3-ca89-4e34-fe95-08dab57bec9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: peYTScdZEmKtohGz3tXsN4N09kZrSwDIAofDLaodc9Rb982dVp3ke0k4fA4A+/hLPdadbegPi3cnzRvE8F3TfVumzV8tUj4RtEO/Ataq/wYrm2CJvwB4jf6KwRFX4dN7+LRPS2HGFvpWU0YEYdVuvRxhRb5mN6+n7VQyCoXPkaefewBH03cIHjZy1lHZ/8+3mMtl5b36xApf6P/csoyS67NxbVG5CG5U7kRVpb/xrf+c8pHW836TPTk2JUU/FzyRYgc5+PHijlRQ42fNrZe4IalgrKZrX/z0GE8Gs0gih/Oms19yrtRR2hnjMXh90Q7eoWLRWXiTBC1aZGpYvdHBV92jn5F+hBDDZ1qXRttSWIPBmKZdK1VxE521Gv6GWlDTPSyYWA9Poj7Uxn80c2hiknTyxmIG+Fja+WHGrkKP0fML/+Z5se046ebbCf/KMchWuMvnmDMRr+sH17li/+qhNX6bqkiyTXreYSl2qYsGe7e9Jv+EvGQ3IZMinQLojmiC215BE8q2dSn3+WZEFYLhDMIymhPwrbk6Wf6bhiNKJbqfuaoZYYuU2Qe6POBByGl439fdq9HKHLsoMtzXPZ9gnow+VN4/vsCCc7Wkohx3zVrnfczCYMiSsN8tNygu5gZW8wvXWRf3Adppy2aH27EyDFrsXiR+9ArLRr07bNVvaWp0onDsjD0PcZpdow5NHT8RlgyBOSzn+CpiYlbYcmHkng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(15650500001)(6916009)(83380400001)(2906002)(5660300002)(6512007)(26005)(6486002)(4326008)(8676002)(8936002)(86362001)(66556008)(66946007)(36756003)(66476007)(2616005)(316002)(1076003)(186003)(478600001)(38100700002)(6506007)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zHdApSnKaGbO1z8aFJ1C5mPateL9fj8zMABmFyDNQ0PCblhDQbNK9iwC27vE?=
 =?us-ascii?Q?mXDkz7iW8GaVHOcJS2ofJy4fO7So/exyb6/cTD9v0YwdZa5ae3vrc10NDc/Y?=
 =?us-ascii?Q?O8gn+giFJ8E3H6DoUCNE514dMx2HUdzCZHlFnW54KmzLwEgyzN6hBfC8d98f?=
 =?us-ascii?Q?+qk9W8aJnY2OMaNmUorXo8Bnb1ojR1awJlH7jVzr0x3VB7EqV29+BLxc5MaJ?=
 =?us-ascii?Q?zhakGHnMaopmdxxRgVcLg2EdZF3BRcPz0djk5cpsukTk5YvJ6/LXATG3mpQH?=
 =?us-ascii?Q?/c1wr36zx1PdWHRu+nDDUGqeiC08dBpd5WU4wYAVUwTMygS+EJZnNgneVrrw?=
 =?us-ascii?Q?KzzHhf5pafUixfUxi93aUzziIYGM3GesKGmhXfQBLLZgJ89o9868oRJp67fa?=
 =?us-ascii?Q?PCEHx5U9WCH/mCf4pW8K3IGF9GZ1ydkNP+4ozrhoAwn0LnK0DDnENLqlKWOS?=
 =?us-ascii?Q?8uKsnPiDAHFX4jTcf2+Q7kEb1uELG/q0aTM92bvA/kXTNB8mOjxHFO/hkOD1?=
 =?us-ascii?Q?7mAnz84gnRQkNi523ZzqZqLrqnIrAeGii0yAzNhch3bBfP2JFcT5FMPMrTcS?=
 =?us-ascii?Q?KLs4jZvo9aeMzOxzHg8psq5OoJ9zaWq3u4fqPvS2YpOLiU0C9Kzup8jZDcrN?=
 =?us-ascii?Q?hrShotbq/H8zVrIRq2HnLfme4o7z0LAUD1CUVpz1FolZR35OGZAHc5OHm+DD?=
 =?us-ascii?Q?mwRDxzQIaGxcgxXmnf6cCX2rsXhVR6ttgXTkUKGmI1XN0FP7hUa/gsKGySex?=
 =?us-ascii?Q?OME0YxGYmGj55jBqEwWrmnnsWnQYVxPOxtksLPkXCVSli/C5Dx7x9AOD5sXM?=
 =?us-ascii?Q?WY4zWZezrN3HNkxMdO1IWv7mxczYjRq5ZGe5eJ27HIyB3TYREKEwRwo7dLTH?=
 =?us-ascii?Q?nJR0sBptP+PmnEoGFVwVMf1bxW9Sd+uRNq/xkjhau8W7LpNXLT08qE290o3a?=
 =?us-ascii?Q?Snd2kYK6CmNYs9kRg9maL+vtLWONRH3hzRftYxYW8jKZ9Bie2pzYLN6K4KCB?=
 =?us-ascii?Q?U+0TOVQg0/AWOKjeStFjNR/+PptHT298rzo1tYvbAyKs1dxCqo7OvbFUZBJ8?=
 =?us-ascii?Q?2dn4hFp8X1OiviRRPvL2fjelSd+8s2k3+XjITXq72/xChU0UZc7JLmjsfwvY?=
 =?us-ascii?Q?dMae0E8EVc/nC0TiPICYjcc1w9A2VmviR9xhK2ugTxZYqTrzsCNVjIdF3ikH?=
 =?us-ascii?Q?gfLk9zXANmUTxfvOi85eXAd0jXhNK8IOejGAfm3FD/Ja/0diylndDZjvCieN?=
 =?us-ascii?Q?iL/zkPkWo99ngUJ/B20R0+7qsVNoYdpLe0rKZqSb1jmvHxSFuFh+5EMfGZX1?=
 =?us-ascii?Q?bBTvYQXVmIwkViimEFLNWdhT1NNPYUiiJwbAqjbZC4BiQDNFRM9B5NKyeOUP?=
 =?us-ascii?Q?4LQTcFZWr8B88E6XCcP3COThkeiKIfzeBStN6cGMe/aHXaEvuHT1bQj+7vT6?=
 =?us-ascii?Q?TUOnDfep7/t0we5QJUKloiODaROxM6uWOBrmC/UoCL2YzCYmLGIqPX8vYg8S?=
 =?us-ascii?Q?XBqzJEVcJAQZDs9djAl4jpSs+zoq2SMtX8hpWJQnxRaeS/8QBJFNWv4N89G0?=
 =?us-ascii?Q?ssdxZqTSZG7ZXIEtGXcrlzn5eXGvAcdiFAe6x6RLBeOC4nklRJsTE1dpTRWk?=
 =?us-ascii?Q?Ww=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f387dc3-ca89-4e34-fe95-08dab57bec9c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:55:08.4630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dPbspaPviIhvyX0jDvEYjRR0Cjw6Ga6ogafBH+DiwfzhZe5cQNLclBgfS9kSaZUovuvpvd2cidyym/HBHjvx0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210240031
X-Proofpoint-GUID: teiiXTtpHgSebc3FvnIFIDZjQtZAYKNj
X-Proofpoint-ORIG-GUID: teiiXTtpHgSebc3FvnIFIDZjQtZAYKNj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 8a62714313391b9b2297d67c341b35edbf46c279 upstream.

AIL removal of the quotaoff start intent and free of both quotaoff
intents is currently limited to the ->iop_committed() handler of the
end intent. This executes when the end intent is committed to the
on-disk log and marks the completion of the operation. The problem
with this is it assumes the success of the operation. If a shutdown
or other error occurs during the quotaoff, it's possible for the
quotaoff task to exit without removing the start intent from the
AIL. This results in an unmount hang as the AIL cannot be emptied.
Further, no other codepath frees the intents and so this is also a
memory leak vector.

First, update the high level quotaoff error path to directly remove
and free the quotaoff start intent if it still exists in the AIL at
the time of the error. Next, update both of the start and end
quotaoff intents with an ->iop_release() callback to properly handle
transaction abort.

This means that If the quotaoff start transaction aborts, it frees
the start intent in the transaction commit path. If the filesystem
shuts down before the end transaction allocates, the quotaoff
sequence removes and frees the start intent. If the end transaction
aborts, it removes the start intent and frees both. This ensures
that a shutdown does not result in a hung unmount and that memory is
not leaked regardless of when a quotaoff error occurs.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_dquot_item.c  | 15 +++++++++++++++
 fs/xfs/xfs_qm_syscalls.c | 13 +++++++------
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 2b816e9b4465..cf65e2e43c6e 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -315,17 +315,32 @@ xfs_qm_qoffend_logitem_committed(
 	return (xfs_lsn_t)-1;
 }
 
+STATIC void
+xfs_qm_qoff_logitem_release(
+	struct xfs_log_item	*lip)
+{
+	struct xfs_qoff_logitem	*qoff = QOFF_ITEM(lip);
+
+	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
+		if (qoff->qql_start_lip)
+			xfs_qm_qoff_logitem_relse(qoff->qql_start_lip);
+		xfs_qm_qoff_logitem_relse(qoff);
+	}
+}
+
 static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
 	.iop_size	= xfs_qm_qoff_logitem_size,
 	.iop_format	= xfs_qm_qoff_logitem_format,
 	.iop_committed	= xfs_qm_qoffend_logitem_committed,
 	.iop_push	= xfs_qm_qoff_logitem_push,
+	.iop_release	= xfs_qm_qoff_logitem_release,
 };
 
 static const struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
 	.iop_size	= xfs_qm_qoff_logitem_size,
 	.iop_format	= xfs_qm_qoff_logitem_format,
 	.iop_push	= xfs_qm_qoff_logitem_push,
+	.iop_release	= xfs_qm_qoff_logitem_release,
 };
 
 /*
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 1ea82764bf89..5d5ac65aa1cc 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -29,8 +29,6 @@ xfs_qm_log_quotaoff(
 	int			error;
 	struct xfs_qoff_logitem	*qoffi;
 
-	*qoffstartp = NULL;
-
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
 	if (error)
 		goto out;
@@ -62,7 +60,7 @@ xfs_qm_log_quotaoff(
 STATIC int
 xfs_qm_log_quotaoff_end(
 	struct xfs_mount	*mp,
-	struct xfs_qoff_logitem	*startqoff,
+	struct xfs_qoff_logitem	**startqoff,
 	uint			flags)
 {
 	struct xfs_trans	*tp;
@@ -73,9 +71,10 @@ xfs_qm_log_quotaoff_end(
 	if (error)
 		return error;
 
-	qoffi = xfs_trans_get_qoff_item(tp, startqoff,
+	qoffi = xfs_trans_get_qoff_item(tp, *startqoff,
 					flags & XFS_ALL_QUOTA_ACCT);
 	xfs_trans_log_quotaoff_item(tp, qoffi);
+	*startqoff = NULL;
 
 	/*
 	 * We have to make sure that the transaction is secure on disk before we
@@ -103,7 +102,7 @@ xfs_qm_scall_quotaoff(
 	uint			dqtype;
 	int			error;
 	uint			inactivate_flags;
-	struct xfs_qoff_logitem	*qoffstart;
+	struct xfs_qoff_logitem	*qoffstart = NULL;
 
 	/*
 	 * No file system can have quotas enabled on disk but not in core.
@@ -228,7 +227,7 @@ xfs_qm_scall_quotaoff(
 	 * So, we have QUOTAOFF start and end logitems; the start
 	 * logitem won't get overwritten until the end logitem appears...
 	 */
-	error = xfs_qm_log_quotaoff_end(mp, qoffstart, flags);
+	error = xfs_qm_log_quotaoff_end(mp, &qoffstart, flags);
 	if (error) {
 		/* We're screwed now. Shutdown is the only option. */
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
@@ -261,6 +260,8 @@ xfs_qm_scall_quotaoff(
 	}
 
 out_unlock:
+	if (error && qoffstart)
+		xfs_qm_qoff_logitem_relse(qoffstart);
 	mutex_unlock(&q->qi_quotaofflock);
 	return error;
 }
-- 
2.35.1

