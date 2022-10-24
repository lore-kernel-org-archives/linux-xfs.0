Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08168C38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiJXEzK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiJXEzI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:55:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDC7371BD
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:55:06 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29O35jrS031201;
        Mon, 24 Oct 2022 04:55:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ciM+sNuaipy4JDgCy0i/QdQy+f5AoJVWHeMVGHpDGi4=;
 b=FnYG89F8ZykGob8kM3ivOWseHFOpjXYgGBJsP6DgKw4zglLOR4nVU9ABV9PO1DGzEVwh
 nuU2VK2qDVrhY9mdubcJG6+TKmCs6n/7xCKutaD4biJ/834kEhhUzJMnP2G0ipjNRdgd
 vnuY72FEgHY3N62j0ZycNTH4/s6OW7Elav3OPNxqz/SrgW8UYLLxL71nLWFkiDOigvAM
 pbctdDc7Gl4vYKf6onOrJPw/iHqp6Jf7Jfw/deO9qgOda3wsTXmlp3Z+DuzOW87xRC+D
 xUGmQulW+3nPQrPiX9hWeD3ps9k0EiiPANsnN18BLAkaiQKsS0lI9jXOtTNPCNH/MxJM Jg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a2tnr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:55:02 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29O43fZL002590;
        Mon, 24 Oct 2022 04:55:02 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y9bpaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:55:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jkWsw9B90Ec6qPZYZM1lgS9VBx3wCHC+DionO9EHECSgOaLBPagAJE/kwnWxaqlbVoU6eGGjEVwqS6bB0sDkF6TQ7u+1x1G0CfDMPTxknZ41fztBJt879crEHoWofNRKr4Ysoqwdomv0AtcRWgRt2YbU3NAG72dFKgess+yXRGQ3xA/uzEB1YytHef0SiaY1Z9ATVgvI+AEbcqAfNtq44DOpM5GqdHGqV5Wsan0CMd7+sFRmFN7bqu5ii3IDhtdcL3L8K8wTIj4L2+apCu5XIBhKejIcC1Io6x7QK4bVbDoECOmkE9yhyUSu5ng/hDiUOHJ1lE0JW1u846AyFAJPuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ciM+sNuaipy4JDgCy0i/QdQy+f5AoJVWHeMVGHpDGi4=;
 b=GWvD/H58q7J9gNbeonCEkwU2ysHgKHjDUH6IPZgB4vcBr8SQrYBY1JXQAgtNEA5358VfCR1qRLQ15QD1J+AvvlDUTUOT8ZJiH8n8+nILVO5JzHTPP2CtrKQ0EQsI8rkoynOHy1bnQ12phvJPnvs/N6spgWLqVV8Q1I9kcaorlcGdV1yd1iJRTPlNj7s57GibBmRDMq223JCrskW9hs5jP1j8kFPDmum2j04+uH9gni4EJMejynfVxLTeDtDuINrwViNYFJ7sZo2eog1ZBLzLNp2W1hnICEzTyBwuULozv1TkBQEtEl8oXFBxLjtj/aUI6Y5BP0dW0RDUu5SsID6ukg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ciM+sNuaipy4JDgCy0i/QdQy+f5AoJVWHeMVGHpDGi4=;
 b=QU2uoa1yYQB1MfoAXnQ2EHg+nKdaJJL1ocukT4iELybTx4WEGIIEAc7lMQ5D+N8qLjrd4LIG+p1TEIxPYL8P17JWAMcSIlubs85BO8lsoMFnWPrQbByZcg9owJFXnS1nl6zXRmXkSKtQSNnuQ1OS89p/+9DKaC9lnTLHpiYHCMo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5374.namprd10.prod.outlook.com (2603:10b6:5:3aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:55:00 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:55:00 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 14/26] xfs: factor out quotaoff intent AIL removal and memory free
Date:   Mon, 24 Oct 2022 10:23:02 +0530
Message-Id: <20221024045314.110453-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0031.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::11) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5374:EE_
X-MS-Office365-Filtering-Correlation-Id: ca2aef98-f4c8-4900-f164-08dab57be7fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z5x8dvGZ0UYQLHjlG7CnPuAbEyMTGoW2jUc3rbJ7QGsFix3aVj/yjC0E1Q+OzgpEY+lUNEW9lbSTkKtZWXbT7QiKwKcDd4F2bNVc36LgW8VrqkKLzAmBOU9bijnTCkitOHvmzA9SUya6eSyF5MphaUh3Y8k9s2LWlDZnW7iKlZEK94hiuKRJ7+DvXtwvF1/68Z1Ln0Nnas+qLPsa1EAxxLqx11jhXthia+myFGzaT3ONyaFfl7GQ0IxBrVdsjOIUoV8Pw4VGDV5N/hoYj0vqW7fH5rcRjDYhXA0cJEsrTOiJMTjnRXm5rXe7Rla5PwSVnu/vZ0LxHuSKcxGN9lo2Mx7xuPKdST6lBSVt6HHuTbi++vlMBDxtY8jnYePLAskHNaFyb3Qo4A1qhoCClxe+Cj0+toVgHDTsr6Yr0GdmSXojv6kABOKv1TQy0wdRb3uCjjOwbDOIiKAJ6q/rkBMU28HuYQnwf/BZyGjNHPrEaRrxx0IlTpKB65bTtgTKhWFWQ1W4NlvD+YGUK4mv5QMjU19AQEa43f+P/0awvagJgR2b6uVCiqXTEvNu1jUh/sL5Q2USyzwcfkfMLMsrjW+9Ro/Ysyq2sohl+tTDC4h0jsl4lZ2bP8BjrKxddJj2Gt3hGwrxMUp6Tn97AaMBxZjvKmRBumt7qqRMNu6hBm9cPi4h+TUctOgpY6ImXRZSmfuRIjnQvi5g5nlZXrKK9WiwkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(15650500001)(6916009)(83380400001)(2906002)(5660300002)(6512007)(26005)(6486002)(4326008)(8676002)(8936002)(86362001)(66556008)(66946007)(36756003)(66476007)(2616005)(316002)(1076003)(186003)(478600001)(38100700002)(6506007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DQCAkt6QN9ZlWFc7FlP0otyCRdk17rMr8zFB/FqDmLfDzy+Pnw0ksz2Wg+Dd?=
 =?us-ascii?Q?xmOxofIcGTqb/rJOmIeu9tOXnYY6WcWI+dekzF0h05sUHmWyxu24z01KIYvV?=
 =?us-ascii?Q?p8mKZcKsUwEWU6G1kFdyB36nRaODbpim3QPcU6efsf4fW5WGfzI/cmUIqakz?=
 =?us-ascii?Q?+ljUmGIW6VSbC/lGF66/wa++n27bXzRAbB8KFWN6+86oA8g0qByRzXj+ku+l?=
 =?us-ascii?Q?J0l6TMuFjTrecB6dviCqmehe/Q0D0Z5MIrTcNtNv+DV8hMIinru4PLgHl7x0?=
 =?us-ascii?Q?UXmYHKopl5yDn8QJLxDciLbwrMFIWRGJ32nzDxbPtvXjSTv6PAxxIa2cfNt7?=
 =?us-ascii?Q?hNXnkDLKam6B4wXjKbg81ggC74j5Xxrm18GI+fzM+wFtLoSFCGQN/jYwNG6A?=
 =?us-ascii?Q?EXPY2MS32IWB8VsjW3XGGRi5a6oxlHolURDhGZ8vf3EugOQ6ZTi+uiZDfuB2?=
 =?us-ascii?Q?r60k/ZCQgaGirbEbhMwUubcArD4GMdeS2/HjKjoBiH9UjCFA/WNjTa7XTWeR?=
 =?us-ascii?Q?gAYff67uyqixBI5S92H+FWysgu+RaYRj3yLCkdHg2xlbDpX1VaWQOKjUrw2M?=
 =?us-ascii?Q?XiVi45oPjO4OTyMUP8YC3OdRQzx42Ut2btVUF+JeFO2b/UyHaezJokY2kKSG?=
 =?us-ascii?Q?lGOlQWVguzCeMpbWqU8gO8GmEfhMXz3F4v4d9p1RCDRy6EMbvULX4KzkrNk7?=
 =?us-ascii?Q?vDg1MXBvlnyBFu+e5IBumoGAk5ujtNT1WOuufJFZPqWAVoW7fHgJIoVQktM2?=
 =?us-ascii?Q?RiIFWKM/0teCiVsnfJfHB+SPHf4a6LO/54QRLkVI++mKroCzHEHY2BlxTH/r?=
 =?us-ascii?Q?CktG08POsdNs1KLE29cSpONNVKB4bo5ow3zyVEEN8fCA3zurbfrSsyXp44W7?=
 =?us-ascii?Q?DcN3VfB6Eh1my+cM+0OmeW4a5BSIwARgV3lC8DBwXm8lFvnaR7y7EAo3jJwt?=
 =?us-ascii?Q?5d4CCC0sPavfbdjn/HbJ8d1n3AZ3Mk5tGS9Noof8+4SHG1f+dKsr5Fq6aN7i?=
 =?us-ascii?Q?ZrMyjU/vP3N0OI0SrKH4o49zHMjLxBhyWN67woiAe0cttsjptwqUwr+FV9++?=
 =?us-ascii?Q?Ah5TxC67n1vS751mFqkIPrqEoq6q3dAph7at/aYoGUaQZXpFLl1+ipieQzAl?=
 =?us-ascii?Q?86uVeiV26mqkZnombvOy10SMIfMnIb9FdGmfeDh2uFAx9GXTHowWIMaoCrnP?=
 =?us-ascii?Q?Lrw8RyH20U3qG+UFnuKLPdwPctGc573PAqhp+XZgqKsturcI+izdv4Q3YUDZ?=
 =?us-ascii?Q?/UplEWtdmoWhEF6Hy+CpwGXW2A6MkkcgGuHktuzi1HFijinwNf24kt/tKlkK?=
 =?us-ascii?Q?r0kp4Yxy5OMLBhqUPwz24VOHSf4sw7t7lMFHeRIINjk+PUQxjzorI/mJ0HUb?=
 =?us-ascii?Q?x/b2SqLMHgNeqOhe+1GKA53nQVHbj51C35irFo4UfBAxPaH/6eVRfWAHvqlY?=
 =?us-ascii?Q?CYmTrVg9GHdU4bUT5af4jffn0fjd1NT4IWWR6GjRwbvrJD175OWtziTXqyW3?=
 =?us-ascii?Q?x+tNyow1yFMZeMU0Vwk1bZIEKUlebxvh4cJy3Xh1Mydi4xWVaqDnc75h2KoF?=
 =?us-ascii?Q?p0dk8KXUQX1tjRURvz7gGQG1NGZBOUO3xFyMBE2urwt0LALsdT7gCM6XsX/r?=
 =?us-ascii?Q?FQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca2aef98-f4c8-4900-f164-08dab57be7fe
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:55:00.7007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CFRNLjMp3A0knxuT9kT5XHBfdA6fnkX5j0Ayyvlf6K2Q4CtKqXs6qhdZe5YfyMPUhBnN10nXtXN1bacBLD8z0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240031
X-Proofpoint-GUID: Dt7kMTcFNe-Y882oyCEoC4AChV6U9-UN
X-Proofpoint-ORIG-GUID: Dt7kMTcFNe-Y882oyCEoC4AChV6U9-UN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 854f82b1f6039a418b7d1407513f8640e05fd73f upstream.

AIL removal of the quotaoff start intent and free of both intents is
hardcoded to the ->iop_committed() handler of the end intent. Factor
out the start intent handling code so it can be used in a future
patch to properly handle quotaoff errors. Use xfs_trans_ail_remove()
instead of the _delete() variant to acquire the AIL lock and also
handle cases where an intent might not reside in the AIL at the
time of a failure.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_dquot_item.c | 29 ++++++++++++++++++++---------
 fs/xfs/xfs_dquot_item.h |  1 +
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index d60647d7197b..2b816e9b4465 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -307,18 +307,10 @@ xfs_qm_qoffend_logitem_committed(
 {
 	struct xfs_qoff_logitem	*qfe = QOFF_ITEM(lip);
 	struct xfs_qoff_logitem	*qfs = qfe->qql_start_lip;
-	struct xfs_ail		*ailp = qfs->qql_item.li_ailp;
 
-	/*
-	 * Delete the qoff-start logitem from the AIL.
-	 * xfs_trans_ail_delete() drops the AIL lock.
-	 */
-	spin_lock(&ailp->ail_lock);
-	xfs_trans_ail_delete(ailp, &qfs->qql_item, SHUTDOWN_LOG_IO_ERROR);
+	xfs_qm_qoff_logitem_relse(qfs);
 
-	kmem_free(qfs->qql_item.li_lv_shadow);
 	kmem_free(lip->li_lv_shadow);
-	kmem_free(qfs);
 	kmem_free(qfe);
 	return (xfs_lsn_t)-1;
 }
@@ -336,6 +328,25 @@ static const struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
 	.iop_push	= xfs_qm_qoff_logitem_push,
 };
 
+/*
+ * Delete the quotaoff intent from the AIL and free it. On success,
+ * this should only be called for the start item. It can be used for
+ * either on shutdown or abort.
+ */
+void
+xfs_qm_qoff_logitem_relse(
+	struct xfs_qoff_logitem	*qoff)
+{
+	struct xfs_log_item	*lip = &qoff->qql_item;
+
+	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags) ||
+	       test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
+	       XFS_FORCED_SHUTDOWN(lip->li_mountp));
+	xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
+	kmem_free(lip->li_lv_shadow);
+	kmem_free(qoff);
+}
+
 /*
  * Allocate and initialize an quotaoff item of the correct quota type(s).
  */
diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
index 3bb19e556ade..2b86a43d7ce2 100644
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -28,6 +28,7 @@ void xfs_qm_dquot_logitem_init(struct xfs_dquot *dqp);
 struct xfs_qoff_logitem	*xfs_qm_qoff_logitem_init(struct xfs_mount *mp,
 		struct xfs_qoff_logitem *start,
 		uint flags);
+void xfs_qm_qoff_logitem_relse(struct xfs_qoff_logitem *);
 struct xfs_qoff_logitem	*xfs_trans_get_qoff_item(struct xfs_trans *tp,
 		struct xfs_qoff_logitem *startqoff,
 		uint flags);
-- 
2.35.1

