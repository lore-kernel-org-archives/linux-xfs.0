Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA5BC3A59D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiJXEzi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiJXEzg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:55:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E78F4E85A
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:55:34 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29O2e6bb001390;
        Mon, 24 Oct 2022 04:55:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=nEi7RvyG+BXjqFk8hYyKtkoi96XhEe0oO29QRLTudZg=;
 b=JESV6Vh/0cGBX1mHo926R8B/vfzID4DjziidSDluuKlnbonpQaKShThBTa3SZwa+oxw2
 LZkf9ZHqarcjpLuCD8J8RntGMwHkbw4sveqUtOEUng4PX7BU+0PYafZx9MqGRzlo06nu
 /K8AuRIWNBl4Uv2uzO6X1Uwg8pA2M9Akn4BS+xUQ4o9qIVuBf+9XZVW874UpDKxBPf6M
 M/LAsxXsWZzyj+Ob2LdvQ69A7veiul0iLngM+loLXDTTkwqGaESE52qLklBlnoIvH4F0
 eCxipJ/qmO6/bjRFYrsfZ+8pttzYQwfTY2qAYk1ZBKo6jM2OZbnNkIF0qFbxXuevPn5a Rw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8dbasb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:55:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29NNv9on032270;
        Mon, 24 Oct 2022 04:55:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y3k8sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:55:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5vXDHWCUxJ/LmMgqfdqTiJidC9Pegy+rF+6rfbsFGIghWJdahybOsajLDgbkqQstqa2n6q08kQeIqnCWWNRitoJ09utJDbOd1VdQ4WRA4n3zE+tV7Xr6ZSJQ7BA6PvKhD1merN3WtscfjB6Tw3rQO5QDzp42bURmrnHpygAlhQzYBLPUipc4k8jQK37jGlTNDAgeKj9khF2XThsiBF6XfO3/Tfm949tsPljgV+0XtUFTBcmQrHBJ+lan7uY3Z5LwHdVQkzEIhFrp39WeoBhV+W6uqkEZ1hdZWfXoJnmMY6B/DnKcc+RPQB3ZEiY1QBKYb9EcMCVjfKxLvYDJCAe5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nEi7RvyG+BXjqFk8hYyKtkoi96XhEe0oO29QRLTudZg=;
 b=M88XRl8VQGVNxMHXNcHNdHI+v9BImnuGhF4bzwQl0CyQh7s302H/azfLYVYfa1hVOUnDNG6Q1z4yuXyiBPwjSBrhSi0KKR1KHpes7RCAa7+qn/Orrut4riBvJac+FPFpp5gfS7aWBAVt2JsOh6dwNK3rlmwa3bK5FuEEqol0FQJxpyJE1HKnQghzugmPCOPr5DJB8t/jTYP2njL/4MkVbUVOMrp2IQHg6NXtrTNNyNCSsFpS1k7S6e/64U8PuLXYQwKpdToP33Slg7TUgJhhSR0NqPO9WPrIPoqafcKBWwPa7fc4cbUmn3SE/zpOZP118IaWoFnH1qY9yZjYIiE/FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nEi7RvyG+BXjqFk8hYyKtkoi96XhEe0oO29QRLTudZg=;
 b=cMVWIuCQFkfd49DBycJyUbEK4f4xDMk2XYx7O7ANiGzDgGjUrqoQEq6IxQIpMc6VXm6JwG0KOs/r4ZPSF3eQCaj3rjKAchq7p2Lnp2KYlp+eDksjSzMm4kmygFwI/0p7GhYOaBU7/sDF8xJv0jPxAAKiu+iHc038nhFt8vLLj8E=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5374.namprd10.prod.outlook.com (2603:10b6:5:3aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:55:28 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:55:28 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 17/26] xfs: Lower CIL flush limit for large logs
Date:   Mon, 24 Oct 2022 10:23:05 +0530
Message-Id: <20221024045314.110453-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::18) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5374:EE_
X-MS-Office365-Filtering-Correlation-Id: f1217101-2c82-4cdb-4d43-08dab57bf866
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JKkcycauxO/uFIc653XIKi2/T3GFoW6Cq31Eim3Po3VZR6vVMbro8tWx9T6rNdBpLlnq0vDrieUluXXxA6MHaQr4R7jhRE6S0lb8cGIltApLw/ZSla4MJpgpzJqdKJ9nxzLxh74sBQ5kWTPBuCSmZRZW0t6VdYee3Fc8rzrBLuTs9owEVH5qhugCG3ovvynl2/kboVPLAISYqy/w33DpxhKDZbnwMMENP8IHoL0tiFFoTo+EKIFq23VC7mtTObFVEiD7D56uyVQ0EaZ8u3gmp39wBTAHPWhb0dYmPehH9YTh6qOMdoD2lcRlZXO5gw/xWnZZLnKm0MIHPvlw5ju4azP7QLPUy5kk3PhK/UjXQlaqwgGJRMBaMruwpvQP9gOt/g40Gnglq4vnGoD0eUsTFc0VR02Eu8MTnMWtShLsuWY5D5BGIogLRy1iebq27L3kNy/Jfg6Nz50yCMWAT8mMe+lg9mTicIrnWCt1HUmEHMbcHRcNC2lQXaeN+s+V33LF9qUzDQyvTqiupI6knjWV0VVQC376ZMOjk6RZiPnFMWQ0ofOA6SgqA/ZysDd/PsbTPGpwirNL3bOPtyar17oUJ+C6UqdaRfUSh0x2u6JqS8y3oicV1PdhZnaq8p8iv9kIZ+AT6N+OJGNZJXzBQuk7IOVIkid0xM4qvRY4wPk9jEyQFXpEtdHPDCkBJcb93MhMtx2czwwk1E2VgHt7+uhI6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(6916009)(83380400001)(2906002)(5660300002)(6512007)(26005)(6486002)(4326008)(8676002)(8936002)(86362001)(66556008)(66946007)(36756003)(66476007)(2616005)(316002)(1076003)(186003)(478600001)(38100700002)(6506007)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xjyt3Ky57JWb3D76MvxECgBYxnJqqGV8w6h/8cuZGnVmdgOfgZaLnvyX1G3z?=
 =?us-ascii?Q?r3KUZZ3bxoFJFzTp+71oFDScAvfl3eJpT598h2DF4I9Q17sSGj9IZ/OMU046?=
 =?us-ascii?Q?zyMR/LswPPGu3s0tr1j1vVWi7PzVOFaJrcva34/SZAtoWSPoOiNLX/FMhi0F?=
 =?us-ascii?Q?spOhnAEjSvI8FYaYJAMQPpYB4A9WzC0OebUjD8Wv3I0nsQV/dFiIOy/LJwr/?=
 =?us-ascii?Q?Q4v3DRtiHxxEd2FPazOqnUYl51E87FgWdMfCdZ25NndddNfIRCsROy6i/ocl?=
 =?us-ascii?Q?M3rUgExTVfrveJBxh1B9uRrGLwxNhcUI9nkOTlYCRlWqcbZyYe3Gn2FdjujH?=
 =?us-ascii?Q?NpjzkQ8zqjfIZ+zhYQQHCw7kbwkIpfBE9wTJQGk+JOxXntUhiDlop/sHG2hj?=
 =?us-ascii?Q?DnpAkedtdJS5RRCqp367moLnbm4pbKJPn94IkQ8sQvSHT3wV5H8BhhkosmiF?=
 =?us-ascii?Q?TBSRL8U2fZw4AUeatRF4v4zVS1BNDQ6LWnqui0oz4x19jTq2aiUF743UfBgG?=
 =?us-ascii?Q?oa4oB7otm8C34CqkekKbDz0k605NN2gO6GUXssZ9eehYBuoMYn0Ed2p+vv4/?=
 =?us-ascii?Q?MQy7Pjb60xydY9nxFrMnnhlaUADD+R6l0p0HJ4GOFOUHjH3tJEfX6Oa1CKXM?=
 =?us-ascii?Q?j/QcmDxoPEUsXmtobrytpYg1lx6A2+1EEUGWdu3FX7ysfyvplK446mp2AgED?=
 =?us-ascii?Q?X/qAlDdmM4H9GUTBxYUpo/nL7IEq8gXLa72vE1RC9zBK2JYM32Z0QFq+ZPxQ?=
 =?us-ascii?Q?0SrdTItKw5oGelVVD/Mx9ypPs7kwPInuHPuJ0qNsgmkQxnvzcgjvW5yySu7V?=
 =?us-ascii?Q?Kc9m7d85Cd5An2Gcs2yStTWv5/Iay8aNdyX4j6tQpJVOwe7QFKmxIGZtu6YE?=
 =?us-ascii?Q?LGzwzT3Qxeik8U1i/fzgl8qvYQaqkOIeb61wywXc4ZL9LZq21/WJpyD726vj?=
 =?us-ascii?Q?aFCBqHev6slCuBEDtnXxz3d5wSX7URN9wWR658moVq6iH+kILJcoaGWi0ZqA?=
 =?us-ascii?Q?1KJ+7Zn6ZIRLyvqmi1++agzSBEAxJTAhHJVWGALLEKBZPNmCVk2ojWcy3zxB?=
 =?us-ascii?Q?UqHs5Sl3Vcpe5vURNKWe02CZUHW0ufa1jP1JVwSfURndO3c0w8H24ojnYVV9?=
 =?us-ascii?Q?F/BaZRng/aspHQmDzwP/McAHpbDRyqeq+kQxIx6/KPcbg8Sn5ezPoS67Rq2h?=
 =?us-ascii?Q?mS20BEjTgczAmIzccq7u3HAyqhdQdLASpTbmL5lbxvlXHEFeJTp6WwkOAqH8?=
 =?us-ascii?Q?M1jZrwnCEkgqDMUzltZdTAd+8YcqtPiV/30nOSde/fq8AgGjBtEtIFfei7n4?=
 =?us-ascii?Q?vJN12khliNn6KGQTSODlY9JFTPCv8niLSt71UNNGiA0rDW0DkOIhUbw5P1Qu?=
 =?us-ascii?Q?511btk2eMOgsX04yfjpZXPxb4hRJTu1DGKgyjWqCaPxwy2g/e6rWQcyj5ppO?=
 =?us-ascii?Q?7lEq/2JARybY8ThrTCeHH7HT+Ng+vop2kIceXifb0N9bZD1RlsCtjp6wTzuQ?=
 =?us-ascii?Q?1Widn5JDAQjvh8wdmx7mRUVC/MzBWotP5BqFun3leNRExnf7loA2IiJWwYIf?=
 =?us-ascii?Q?Iz0UI+YyC3LLa/uQZntkn9nyOYOzgyJ0SLVbOagcuxCE3iyxVeT+dE9DFLsP?=
 =?us-ascii?Q?7A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1217101-2c82-4cdb-4d43-08dab57bf866
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:55:28.0342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5xnlXIBekv1j5b/HHNyBquqKjvxqQUGwVhXdSOcvhtr70pYWotGXb8ELuJpWL3PwrkYhRa48HDKDHd6OqqYycw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210240031
X-Proofpoint-ORIG-GUID: DkjsZGlVOV9zAsCCgjYN7wgrq58Rw8X_
X-Proofpoint-GUID: DkjsZGlVOV9zAsCCgjYN7wgrq58Rw8X_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 108a42358a05312b2128533c6462a3fdeb410bdf upstream.

The current CIL size aggregation limit is 1/8th the log size. This
means for large logs we might be aggregating at least 250MB of dirty objects
in memory before the CIL is flushed to the journal. With CIL shadow
buffers sitting around, this means the CIL is often consuming >500MB
of temporary memory that is all allocated under GFP_NOFS conditions.

Flushing the CIL can take some time to do if there is other IO
ongoing, and can introduce substantial log force latency by itself.
It also pins the memory until the objects are in the AIL and can be
written back and reclaimed by shrinkers. Hence this threshold also
tends to determine the minimum amount of memory XFS can operate in
under heavy modification without triggering the OOM killer.

Modify the CIL space limit to prevent such huge amounts of pinned
metadata from aggregating. We can have 2MB of log IO in flight at
once, so limit aggregation to 16x this size. This threshold was
chosen as it little impact on performance (on 16-way fsmark) or log
traffic but pins a lot less memory on large logs especially under
heavy memory pressure.  An aggregation limit of 8x had 5-10%
performance degradation and a 50% increase in log throughput for
the same workload, so clearly that was too small for highly
concurrent workloads on large logs.

This was found via trace analysis of AIL behaviour. e.g. insertion
from a single CIL flush:

xfs_ail_insert: old lsn 0/0 new lsn 1/3033090 type XFS_LI_INODE flags IN_AIL

$ grep xfs_ail_insert /mnt/scratch/s.t |grep "new lsn 1/3033090" |wc -l
1721823
$

So there were 1.7 million objects inserted into the AIL from this
CIL checkpoint, the first at 2323.392108, the last at 2325.667566 which
was the end of the trace (i.e. it hadn't finished). Clearly a major
problem.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log_priv.h | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b880c23cb6e4..a3cc8a9a16d9 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -323,13 +323,30 @@ struct xfs_cil {
  * tries to keep 25% of the log free, so we need to keep below that limit or we
  * risk running out of free log space to start any new transactions.
  *
- * In order to keep background CIL push efficient, we will set a lower
- * threshold at which background pushing is attempted without blocking current
- * transaction commits.  A separate, higher bound defines when CIL pushes are
- * enforced to ensure we stay within our maximum checkpoint size bounds.
- * threshold, yet give us plenty of space for aggregation on large logs.
+ * In order to keep background CIL push efficient, we only need to ensure the
+ * CIL is large enough to maintain sufficient in-memory relogging to avoid
+ * repeated physical writes of frequently modified metadata. If we allow the CIL
+ * to grow to a substantial fraction of the log, then we may be pinning hundreds
+ * of megabytes of metadata in memory until the CIL flushes. This can cause
+ * issues when we are running low on memory - pinned memory cannot be reclaimed,
+ * and the CIL consumes a lot of memory. Hence we need to set an upper physical
+ * size limit for the CIL that limits the maximum amount of memory pinned by the
+ * CIL but does not limit performance by reducing relogging efficiency
+ * significantly.
+ *
+ * As such, the CIL push threshold ends up being the smaller of two thresholds:
+ * - a threshold large enough that it allows CIL to be pushed and progress to be
+ *   made without excessive blocking of incoming transaction commits. This is
+ *   defined to be 12.5% of the log space - half the 25% push threshold of the
+ *   AIL.
+ * - small enough that it doesn't pin excessive amounts of memory but maintains
+ *   close to peak relogging efficiency. This is defined to be 16x the iclog
+ *   buffer window (32MB) as measurements have shown this to be roughly the
+ *   point of diminishing performance increases under highly concurrent
+ *   modification workloads.
  */
-#define XLOG_CIL_SPACE_LIMIT(log)	(log->l_logsize >> 3)
+#define XLOG_CIL_SPACE_LIMIT(log)	\
+	min_t(int, (log)->l_logsize >> 3, BBTOB(XLOG_TOTAL_REC_SHIFT(log)) << 4)
 
 /*
  * ticket grant locks, queues and accounting have their own cachlines
-- 
2.35.1

