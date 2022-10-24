Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7408FC38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiJXExp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiJXExn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:53:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C84F7993F
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:53:42 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29O2UoUr026197;
        Mon, 24 Oct 2022 04:53:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=E7Wzg4WUNbtQXH5TNZvFIzJX2fYWXXyMEGfy6eDE/zA=;
 b=hNiCUyJCBeJik46kuBERacrwvisEtUL6MppRxUaROU0qV0/vJz5TNbAz/P95YWY0d+cl
 SXXcWW4QD1UieI6uxdNAo9bx+JJRzvpcoQAbOO65Kdc3+jtddO1woYNouDMEwL/3uAtU
 5/7Rxp83+7gnWeXAtx8RnyJtg3CSW9Z9UU5/iMeBgyo/j00UhXItKKk60mkV3Nwke9ub
 WjNjFLRpk5ChjY4OdAl9lEssWlIz7KkFbZrth++xJKuDu/qXHwfmPbexP0BV2ASfucgu
 ncNR3w9OVT9l2oFmSXo+TO3Xb4jSeJK+VUR5Go1S26tNy1MeznPIsl17PHkV1xwAz9ns SQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741jw55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:53:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29NN0Exo003584;
        Mon, 24 Oct 2022 04:53:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y9bnxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:53:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVjnPMtcM+tz6tVn7+uzfH90WB5dBQILSgSSGJqokYTapD2aHp3lLDgDRrYhQWeXij440b2p6gFjwp55OobqLIRk6SKTyXG/5k9R5Eb3mHALpMKs9XosQRQISgLM8tuWYSAR+YqlKfwtDz+4o8DtWiAnqDEReoDbSJzV1NhAhhw1R4v+Zx4m5MkB7Jvv/BkRxwZoczvDv/iheWo2vg0vAoclXlRalFmFZWDxkEZg2QyEw/F7I8NxVR/jWctotPgehjPT2ih9LephWhVHsrLQYBfkpGSjrP5pSNIPS1LTxKpBzSSmSWv+1nGwqJEDowbne6M8vPasEcZTABMRx8I4MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E7Wzg4WUNbtQXH5TNZvFIzJX2fYWXXyMEGfy6eDE/zA=;
 b=YCSgvWJQwZbsj5qnvv3xP2H4v+c9Aajc/cEGsKDZWlNyPRShVcujEcK/vrrefZ0s0QrvXo2vZ07UEF23RAegWnCFgt9A5Owd2lb0TWucfcv6dEYEGXcETD+BkzBcJDwSRFQ2TuJZG2H/Q1iTuV1Gk1Xp3Ru4oRNJknGO0AbJt/Bt5bhSLQldVZOQ1+rrfnV/vhebSdC7ZSr+INxavR49+kM53TTRqVJsgu/tbtaaJ/tQov9ZhpoQv54WnJNTjaq3qAvRXENXZXb1IHwfuJ/ZGKGNnMTi8hVFQnDNQGtJxAKhO2cbtXldEMfJpPmtDyg9jzeYA3czo//s0PwB3rZopA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7Wzg4WUNbtQXH5TNZvFIzJX2fYWXXyMEGfy6eDE/zA=;
 b=LkdUik736vLhyRHgrQjrGQ34rDxUqmVNR6r9dsGe3zTSnw7DTN5dv2X7UMe0whoTrSFZb/I5acC1JzyS+124eaqz6flomjP8CjQdXImODvyJl0w3wzruCicCoMPc17/kOGkzALesq6wlbg08nn79yFpuCCsG4o/hfvy6Ni3Z7lM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5374.namprd10.prod.outlook.com (2603:10b6:5:3aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:53:35 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:53:35 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 02/26] xfs: rework insert range into an atomic operation
Date:   Mon, 24 Oct 2022 10:22:50 +0530
Message-Id: <20221024045314.110453-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0229.jpnprd01.prod.outlook.com
 (2603:1096:404:11e::25) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5374:EE_
X-MS-Office365-Filtering-Correlation-Id: 12b1bd1a-69f2-408d-8bf6-08dab57bb553
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tIvSG9ZExKcoC1cprwOhIshVDSZY2NQch5AY/zd3/5Kju2ASxZvt1b04/WUzxY1hLQPVxofcoZ/xp9KpWQqT72ZkSutln4LoZdkgPc6+oCd6LvRStwAGGIhanWD98CKOqChkLTKIspj+sYb6GbA1o7yksURfjTBheAQCEDbpX9ffYkt4Ud7kciJK5gF5YbuvOPx9cYo3NwwtzG8i/rTpAYa+wwRjg4ROfsklDMFc9sDsO3L6HwHvfDsErUCnRg2cBWWURRbTgqLZ9KWhSNdUowX30RQy6777l0J74Y4vyqFuZv5Y9FYDRDg8DZVZOUT8UG+D3p0qFes7isN3e0NbeKnHD+tyUrPgyJdoPd9wCE4/fL7liodXPk89hMu8tJ8VdFFhRG+pwW2umASa9Bxkd/HL02EOVXETnIGji//yqd4dB6vbyOAQUoOH53ohLM7PzAZ8h12ZuOuQElfEQlV3qQt8KtRPFeZHcb/CxJXZ/HwqOrcKYHuYum3V6xlXVZTMEECb2AAuwxek5G+aIsWHdsw36by6qlWAfcRJGFBqvTpPZ1NwvaqQmiunzf/WgbqtiLzssewjV+Dq2ueUVtIb4WfyZ6CGjOSkHtnOuv5osSIm4YIT+/9sn1h4S8oSkZ+88XyhcYlouYYOz6dJLlHaZsY4WQQKEZrtdIwCNMYIip3HFDXbpjP6gf5V3WPH9V0xxtxIUgHruqp3R3tP/QArfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(6916009)(83380400001)(2906002)(5660300002)(6512007)(26005)(6486002)(4326008)(8676002)(8936002)(86362001)(66556008)(66946007)(36756003)(66476007)(2616005)(316002)(1076003)(186003)(478600001)(38100700002)(6506007)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sYIxnntgudZLqC5shAUTyJ53xfHlPgc4jD4PktOwSxYiNAYXvY+ehqr0OBi6?=
 =?us-ascii?Q?+ymeywqAJHngOAsvUZtwkTCQPt/Ma1BpxqKN903dK8myBtivE2UZNVK2qKAb?=
 =?us-ascii?Q?BEHZ7XfSxJs/e6Ws2YIbw7pY6ZGlhxXDcNUt/5yhkjTa8L2Hrp+RwPRGwat0?=
 =?us-ascii?Q?t3R1diFCWpzBDL/W3F95iwGVbt4e/YfBsQ+BlfixQByXCucOeywC152kAB75?=
 =?us-ascii?Q?sy+fHCY3W5Zm/meqMRLpemzaNQzDU2WMvJfbesA3WfM74DWi3YeC+J0x2eP5?=
 =?us-ascii?Q?DQsSSk/hH9crdCGqK1KVGn+ULeiyX/g5cr+lvc525tdzArzzIcTwSHn7BngP?=
 =?us-ascii?Q?Q+5jwRjeuHIIQW1NWK500EFwKFKXqJYdtrEJKcuoCEAJwBdSNWW8/5dVYH2D?=
 =?us-ascii?Q?550a6PggkjtyhFXyz/tsXUxOnRYhJsbNRzZflBcWp/Wun0EJdTPWm8RBpyhu?=
 =?us-ascii?Q?/RcZ2goib9uk3kmZJIT1os0gvwq/aF28cwNwG8A4rhClE5Naf04MgRT1Oxa5?=
 =?us-ascii?Q?JsZK+F2O/ajuCcBsazSItFigb8uR5thR/EVuwYdq4xH6Kvc8oCLmLaj6ynYE?=
 =?us-ascii?Q?yV53dIEQC1n9UkgAo5nEc/VGwj9F/q3GDeZK+dYqGOmOl7ZOQbxPgLOyUvtK?=
 =?us-ascii?Q?TF5K+c/gXisUOLhIivHRh/JoTlix8S8nRVrMuDUeh2yYZ70tJPLbD+S9cki0?=
 =?us-ascii?Q?OxtreVmKpt42hdzJQtR16XDf4bdthTjb5UBv3uOy2OGouFogTg38gZalaFOD?=
 =?us-ascii?Q?6sPQ9a1DJc+nENhQ+Lyy7+ux+3rivxv4PnJCXhSPuo6+CDx3uZ9GTcLtLtTr?=
 =?us-ascii?Q?fHfPJGJOJ0rmX2sr8+CCsw6vE/Qm1kxf0O/3cGQozUw58tjEdgp03gy9dHUa?=
 =?us-ascii?Q?xKSafGwO+odsWTkRk0B2Qmr7/n2A1xTQdfz8o2O1JMCnYelTNOb3CJQ1sIeH?=
 =?us-ascii?Q?Pu8nZ+jSj0tryf4ybvUMTnM7F7xCu+HK/kAYgULAZ+0W7fr80MzFgrLPSyrQ?=
 =?us-ascii?Q?i4+ntXeotUR32V31qJ6935pmGs2IHRFMJOsh7ag0oENlKXIIuLdp7NKD1Y6u?=
 =?us-ascii?Q?Ccba9EV/Fz1o3fquKGpe7tgLiWCmkhycdA8aS9uJZBpwBIlz9ZVUEjvIaWyJ?=
 =?us-ascii?Q?a4sh2cCSjDasjPX2R/y7I+Uy+8puMqNA20Imgg6PBMbdJyMhnbObl86YRovB?=
 =?us-ascii?Q?p241vxnKghtFPptceUpwcVNXiX1ZgeAzYlfHZXpoSqtozejuXVqXQE2E/4dY?=
 =?us-ascii?Q?4c/xmGS/QeH45sOH7DulcA6xSuLmch/0/uVMM9fI/Gc1p5a2aMP42oyvGT9R?=
 =?us-ascii?Q?DqidDqUk6OIXtq88Y34WF82+IuIVRBzD/aOIvkzLkT2ZbOMP6ikdFB2eGZxH?=
 =?us-ascii?Q?ohZqpXiMUN+t5fkTHxzs67SzAwnrLWck/vM76PaseBUke474lhEGCOXykAcy?=
 =?us-ascii?Q?PZ4P8x/M694EePhROurh+UVjZDyf6cn7hmwpx7cT9vMiITjtIpZMafz/df9h?=
 =?us-ascii?Q?lBj6LSMU55gwX0f4AarHjxixAbG187IAz28YDaxr/ydPzMrpLOSNCxrlbGpJ?=
 =?us-ascii?Q?eqNdqEpRvNzMVQZvveEC+i8cxJMHXh327J6Za2IIdl8Kd2iHYgGSmlTQXYUU?=
 =?us-ascii?Q?BQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12b1bd1a-69f2-408d-8bf6-08dab57bb553
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:53:35.6289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rI5gPu5oR/Xfe4ppqDLH3x5mO5L5Cvslll14j0/lu3bFv0vTyhLmjwmPiJgYkIeF7AGli6T1Im80Xeh0kpUi3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240031
X-Proofpoint-GUID: uWq3dBR5N6HdMXsNjJgi-6m1nXX356iH
X-Proofpoint-ORIG-GUID: uWq3dBR5N6HdMXsNjJgi-6m1nXX356iH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit dd87f87d87fa4359a54e7b44549742f579e3e805 upstream.

The insert range operation uses a unique transaction and ilock cycle
for the extent split and each extent shift iteration of the overall
operation. While this works, it is risks racing with other
operations in subtle ways such as COW writeback modifying an extent
tree in the middle of a shift operation.

To avoid this problem, make insert range atomic with respect to
ilock. Hold the ilock across the entire operation, replace the
individual transactions with a single rolling transaction sequence
and relog the inode to keep it moving in the log. This guarantees
that nothing else can change the extent mapping of an inode while
an insert range operation is in progress.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index e52ecc5f12c1..90c0f688d3b3 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1321,47 +1321,41 @@ xfs_insert_file_space(
 	if (error)
 		return error;
 
-	/*
-	 * The extent shifting code works on extent granularity. So, if stop_fsb
-	 * is not the starting block of extent, we need to split the extent at
-	 * stop_fsb.
-	 */
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
 			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
 	if (error)
 		return error;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 
+	/*
+	 * The extent shifting code works on extent granularity. So, if stop_fsb
+	 * is not the starting block of extent, we need to split the extent at
+	 * stop_fsb.
+	 */
 	error = xfs_bmap_split_extent(tp, ip, stop_fsb);
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_trans_commit(tp);
-	if (error)
-		return error;
-
-	while (!error && !done) {
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0,
-					&tp);
+	do {
+		error = xfs_trans_roll_inode(&tp, ip);
 		if (error)
-			break;
+			goto out_trans_cancel;
 
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 		error = xfs_bmap_insert_extents(tp, ip, &next_fsb, shift_fsb,
 				&done, stop_fsb);
 		if (error)
 			goto out_trans_cancel;
+	} while (!done);
 
-		error = xfs_trans_commit(tp);
-	}
-
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
-- 
2.35.1

