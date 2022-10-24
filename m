Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C76C3A59D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiJXE4o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiJXE4n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:56:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D447AB04
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:56:40 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29NMKxmi019479;
        Mon, 24 Oct 2022 04:56:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=l1T+OCmoekpDpgYRnrrTIxUgbtFZA200/NTtMRkKNtY=;
 b=1ghZOoUFM74g9y96dTXAEaOADSd2CBr7PBNultMniEMa8cGu6D/4px1LVshi3znHTpjI
 8nwJ3o9fNZPvpX+TWROXtokTHpqpvDp9bDx97qbLn569ovtkl5yxEK00laopsgPT8J2o
 1DGAosTvT0reXCrxr844LgzzIxg6CuHjycp3ZT6txVLuFIz1qn8nnZiXgFifVM8yp74X
 700Ng17vBOWzE93kErYBrhy33mNPa6u+e+cXah1/rcSSfurfx1AfTX0Z/Ugxk0eAtuMl
 JMIt8+miBebbCVKT5ZecLy8ChyCAuy8/UfFOgekIHJNzmOUC7ToQrqGs3X6a2LSMyW7G Jg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc9392y2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:56:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29O4oHlk040579;
        Mon, 24 Oct 2022 04:56:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y945n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:56:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/QNIaO1uGKlSXAkEiyoFa/xY4HNVnqILUzzE8xZ5O9Zr2t1fyQzMM9J3HtWq+YTZWrAMD4tfoDo43i5msVvsbsgpalwvSd3Nyhmz2mxQcvUs7H5C3CjcxO3sgQv2Yq01hFYiQ9bmSMPSbGB7KjorNUfay0UATpngBniF5MqifOgeOR7j0KyvcucRFe4JtvU67Zl1o0BytMSpjolQvu9SSwHMhQG/vuV7MqaA156U8+nVjUpW/CqzA+D4NczRpq0cA/51QQ3Tc0XYa4E4mVY2g43/XDbF03K9bIUAa1pFwnVKkFyynTMRHNjElxu2vkizCqzwR5Sd81+Pu8ajEtzeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l1T+OCmoekpDpgYRnrrTIxUgbtFZA200/NTtMRkKNtY=;
 b=EXTSpZcXEqqaQ4Y/bKZcd2fT10K2kUAe1S2p9G/Dx/H6RzeLwQdHnPutnzzpRCQ4jz+OaPtpdEJzinOOl65f/anWZt/6rmBig3N12VvI0JxAO+pATjxmYLFo0DsrNtfK9UQRbMtMMXXVMcM5VSI8wVBvtQjT9wffqn4mqauHTx0v9V8nezmjFiWlmgavoEnOUlMOhNpYkHiObT9Rc7GBWmCIqw6HjmcF6wAg+9yzVBKSM72cJkB6+GQM23sb9LUoc7tdEFKg/REnALzJ5+RcBIN3kEczwsP25UdYoOq7pl7ko0j9QucGWzJU+K7MkWBmTeAZqwVLfxOII/CAEjalZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l1T+OCmoekpDpgYRnrrTIxUgbtFZA200/NTtMRkKNtY=;
 b=t4EjbO/Wr17wqOGWXMydEtk0OByvEQhBV9UGjLQ+P+DHFIpgnt7qrb+9eQ77vLAeFJbP0e778Sxe03gLYtx/C7zF7TBo1UbX9te52dbn8wLbneOU1D/pW/qFC6661dLQT5nqtwogR2HpqNzjEHhVfBE84jj4/WeKw0dtpw2X9yc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB4906.namprd10.prod.outlook.com (2603:10b6:610:c6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:56:31 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:56:31 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 26/26] xfs: fix use-after-free on CIL context on shutdown
Date:   Mon, 24 Oct 2022 10:23:14 +0530
Message-Id: <20221024045314.110453-27-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0002.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB4906:EE_
X-MS-Office365-Filtering-Correlation-Id: a41f2368-b64d-4aa1-e817-08dab57c1e63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PkDDQmyuv5JqcNYq5/t/xK5AdMzjSVVPRAy7egwTEfcoupyin0cRecTU2/YYyLm1aE1fOgx4oGlTyECZkRlfIs9ifSkonylgDr35JptbHBkXuCJ8tDZpaisc2MM6mwNhEpq+hYaMVKwCQ7hqMydxGry8k24Q2yO0XcEJZ74dhGim/jm39zKKrTQ2Q5TjnKRT7bVexNPJ5sM6ioi++bN/QDxtotID74VXPriai+Ko8wCdaEhdjM7aYqNqq6NW/FXdR6lFojduHn6mKugC+X20d+2IxQGxChwRcgNEe1RZCOZcqvN+tBs/mOBwytweWVMDCxBLdS0gqjeG5UuTlMaPCDjvOejXz+pqVzMeieLNRTZd1Ro1gQNLKE6ZkJHUDm1FSpkDIYTPIRHT2ycyZuKBnxqcfO/v0QjQAzwv0Xk2H3g6gAHQ/NhfGYudBwq1D0U5yV6+fP7rjK3I9rYQ7p1IXwbe+AjeTd0pcsac69/YuzuXKAnZi/1h8viiwcyO+iMES1y/MB0YIlih9Lamta1MqGwvLfJfPsnDkYjCtF0xm786I0fTOs2Ql6GdQzG3Z8+Cpn6IjD4Ka0EnWrHfEsrKHb5jYVxk6phgQOW6lX0UzJspU0Yc0scIb41dK7Ji+ixpOouBecRNa2y9KVYA1EvCpH8RZ89ya2jK2i4j8vullunP+dAyVFGhyt3U9+c7xm1f+FKIGXm6RYu5u1FjSL2yqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199015)(2616005)(1076003)(66556008)(66946007)(66476007)(5660300002)(6506007)(186003)(6666004)(83380400001)(36756003)(6486002)(4326008)(478600001)(8676002)(38100700002)(86362001)(41300700001)(8936002)(6916009)(2906002)(26005)(6512007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D4X5dn4h19rM1x1uHP6GuPLbJhPbqJC/i7j+r2/hxZHDO4sgE/2H+M6tmz31?=
 =?us-ascii?Q?F7dN8sJngIzFgo0ceHe8HWYUA94LAY/OynNbil9foGmRuOgU4/hBU3H0uwme?=
 =?us-ascii?Q?1wS4HsPi048e4ttyVcZuU6XfJEs75hOLjVHj5xF/+rkV1AUq6Ne+yZxpHUvO?=
 =?us-ascii?Q?z4q6xax7SEFPQuhVpUC7JIxPkm00QcRrlwtjIhUcdRzSCNMnsY4FFIZIcgnb?=
 =?us-ascii?Q?U4LWxxcjqdg4BpD8/+lBlMpeP7+t1XYx+d8b7VDr9BOaTneYiY6TQV+EDkFV?=
 =?us-ascii?Q?FmIwrVx1JlVu7P8PTBzVFC7ViKu5wwmZLYvyGtLukog1JzMZhK9DpKKl9Chm?=
 =?us-ascii?Q?OOaQOUeP1ipl+723RLu40Lobf4jWwsy5dI8n/JCRPvvX/F3k4vZXKx5ZAz9d?=
 =?us-ascii?Q?54aXrPCSf7IecDHRIK1SZsdxpfppn/60GUAwd1yaWtxffsUwYh5Q9AYJctXn?=
 =?us-ascii?Q?2OuFbVs0EEQa7VMWK8GX2on8RtTnjAxq+hJjSi4ad/pfSqT9yzOWBx8qGc+g?=
 =?us-ascii?Q?vJ2O5AlIgffcDW1nrE7iMWtudWwC1eOYtU3ajJ+o9YDmjDeWuUYLrN5W61GR?=
 =?us-ascii?Q?5im3oKpQgmW2eP30DqmeI5MlILM9HUOA27ws26Ce1kZolqyV44hXI2EVJiWn?=
 =?us-ascii?Q?cIoVDRA19Cb+xlZIOxJcXrriw2rIdAGtbdThj+sHzGUBL7Ab6yMbcvg83xtz?=
 =?us-ascii?Q?AnFVJqpK9bOdicTb2qx2zGbQQdUOG2Hfv6rQKmjm1R4a8SUw+aMX6jLP6UiX?=
 =?us-ascii?Q?VrOF8kqyqH5GuXzqDKuv13H8AN/4j1oMX5/rStI1CGgWzqu5zxvLIB9/kwRl?=
 =?us-ascii?Q?zv8Y3OQG7wHB7WxgrLVYrNFslIy+BuDVUKwToq3sHfZO1EkGrGwIZJDeQUHT?=
 =?us-ascii?Q?Hh7LH+Xc9gpDOiJDEK724a6ooaNv6Utc8+vkh/l5V2wOm6XDm9qXDjfCVpnB?=
 =?us-ascii?Q?2ijK/c/OyKdWyCAH9K3EQCOinwgaw6zQJRsaYWUtcQ/BoFAJkwWTsm429w93?=
 =?us-ascii?Q?anF8EIWpRyZbbZQj8AKALEgqzrqnzUYWXLUPF7FRo5ro6/pk680SPGQ1c3UA?=
 =?us-ascii?Q?A3J6MBVcnNZcteGrg+hxTrDNsv0y1hA248UKglVdn/BPCFQ4dg0imLIm+BSW?=
 =?us-ascii?Q?oCPliLJRxaJaWNBBz9T+gjCU7Hl17XutvwkCXPI1l3SH4YB+PlRimdBFLK7C?=
 =?us-ascii?Q?DQL2qEmh1tqj8R0L8R2jNH/kgfJn8D+7HFkVzeXFIvSSQqtUEqNbO0E0OpGe?=
 =?us-ascii?Q?VTD+Ddx0s1VzU6gcBcb/MBHt5A7PtUUO1RK41n4i7pp9LXxcWc1qNi2RFoCW?=
 =?us-ascii?Q?76IJ0HzoNafn0X3curFN4dwJiRXkpBH5A6FUvDe2aj/UppMUFokG+J+RiiHu?=
 =?us-ascii?Q?lDoaxbCEgkJeD+hxUY+XOR6z1Qnzj0D/+9K258iWzzQTCo+Q2cwHX1YMe5M2?=
 =?us-ascii?Q?jZf3wdTfcM+OXi1sFn6XfKemYnTaCCnPrqCa/HfBODUKoU+NAdj6m63OelOc?=
 =?us-ascii?Q?B55+Nq6LLhtt8VWqKN6v8xAR4zTbTt/GUNFqufSsMHQ+PXSv1VhUnQcIsnyD?=
 =?us-ascii?Q?GySwgZJznMcRzM8Nn+e4CMURvXYLrxSQXwHNXCzMr/o2EFaCrteJwEcq7EHN?=
 =?us-ascii?Q?Gw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a41f2368-b64d-4aa1-e817-08dab57c1e63
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:56:31.7720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tLWBM8zoakWda2Nn9PiAQuE+7El/MSp3GDzaT/IlExkrFMNVhOFTKgcrbLkpfmQyjPvnnMbzcqNa8HitQcM++g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4906
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240031
X-Proofpoint-GUID: EZLYJs2dkx1OdqXpqbCooh9SysQkG1en
X-Proofpoint-ORIG-GUID: EZLYJs2dkx1OdqXpqbCooh9SysQkG1en
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit c7f87f3984cfa1e6d32806a715f35c5947ad9c09 upstream.

xlog_wait() on the CIL context can reference a freed context if the
waiter doesn't get scheduled before the CIL context is freed. This
can happen when a task is on the hard throttle and the CIL push
aborts due to a shutdown. This was detected by generic/019:

thread 1			thread 2

__xfs_trans_commit
 xfs_log_commit_cil
  <CIL size over hard throttle limit>
  xlog_wait
   schedule
				xlog_cil_push_work
				wake_up_all
				<shutdown aborts commit>
				xlog_cil_committed
				kmem_free

   remove_wait_queue
    spin_lock_irqsave --> UAF

Fix it by moving the wait queue to the CIL rather than keeping it in
in the CIL context that gets freed on push completion. Because the
wait queue is now independent of the CIL context and we might have
multiple contexts in flight at once, only wake the waiters on the
push throttle when the context we are pushing is over the hard
throttle size threshold.

Fixes: 0e7ab7efe7745 ("xfs: Throttle commits on delayed background CIL push")
Reported-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log_cil.c  | 10 +++++-----
 fs/xfs/xfs_log_priv.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 4a09d50e1368..550fd5de2404 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -673,7 +673,8 @@ xlog_cil_push(
 	/*
 	 * Wake up any background push waiters now this context is being pushed.
 	 */
-	wake_up_all(&ctx->push_wait);
+	if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
+		wake_up_all(&cil->xc_push_wait);
 
 	/*
 	 * Check if we've anything to push. If there is nothing, then we don't
@@ -745,13 +746,12 @@ xlog_cil_push(
 
 	/*
 	 * initialise the new context and attach it to the CIL. Then attach
-	 * the current context to the CIL committing lsit so it can be found
+	 * the current context to the CIL committing list so it can be found
 	 * during log forces to extract the commit lsn of the sequence that
 	 * needs to be forced.
 	 */
 	INIT_LIST_HEAD(&new_ctx->committing);
 	INIT_LIST_HEAD(&new_ctx->busy_extents);
-	init_waitqueue_head(&new_ctx->push_wait);
 	new_ctx->sequence = ctx->sequence + 1;
 	new_ctx->cil = cil;
 	cil->xc_ctx = new_ctx;
@@ -946,7 +946,7 @@ xlog_cil_push_background(
 	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
 		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
 		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
-		xlog_wait(&cil->xc_ctx->push_wait, &cil->xc_push_lock);
+		xlog_wait(&cil->xc_push_wait, &cil->xc_push_lock);
 		return;
 	}
 
@@ -1222,12 +1222,12 @@ xlog_cil_init(
 	INIT_LIST_HEAD(&cil->xc_committing);
 	spin_lock_init(&cil->xc_cil_lock);
 	spin_lock_init(&cil->xc_push_lock);
+	init_waitqueue_head(&cil->xc_push_wait);
 	init_rwsem(&cil->xc_ctx_lock);
 	init_waitqueue_head(&cil->xc_commit_wait);
 
 	INIT_LIST_HEAD(&ctx->committing);
 	INIT_LIST_HEAD(&ctx->busy_extents);
-	init_waitqueue_head(&ctx->push_wait);
 	ctx->sequence = 1;
 	ctx->cil = cil;
 	cil->xc_ctx = ctx;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index f231b7dfaeab..3a5d7fb09c43 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -247,7 +247,6 @@ struct xfs_cil_ctx {
 	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
 	struct list_head	iclog_entry;
 	struct list_head	committing;	/* ctx committing list */
-	wait_queue_head_t	push_wait;	/* background push throttle */
 	struct work_struct	discard_endio_work;
 };
 
@@ -281,6 +280,7 @@ struct xfs_cil {
 	wait_queue_head_t	xc_commit_wait;
 	xfs_lsn_t		xc_current_sequence;
 	struct work_struct	xc_push_work;
+	wait_queue_head_t	xc_push_wait;	/* background push throttle */
 } ____cacheline_aligned_in_smp;
 
 /*
-- 
2.35.1

