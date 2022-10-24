Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB9FC3A59D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiJXEx5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiJXExz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:53:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE2979A5D
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:53:54 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29O2WKqK031538;
        Mon, 24 Oct 2022 04:53:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=KYs6Sk6L8F2stI5Fsht8sTwExs4U6KuYt0sXSP3LeX8=;
 b=clCnlmsro0UxkuDFQD2gyqBvc8C+bGVNWnUj4lD9fPWSt6j1oIyUuEIAN6Urq1LHLpFb
 XL1Dv77WGTVU7Cm+pDziJUx4YB5Hkd+eungSb3GdpwlsaMOOPf1oMIxOX4hDA2FGf4uW
 gjVROvJUMHxuDa6PrvKGfQduXMgQIq0/IBuSlACeFs4cz9Gqv9kpY5VlQbKXUKl0rfg0
 nSdcon7Di0XiFgnhAjQ7TVFJGmKv307cHhtcaSSkzMHs1RQam97iBUI7Nh869J45PvMH
 EmsTjUFWq0OfflPLRkY3Q+L91IKpPFzWQyT5jBBgz0Gd72ToFAg4Mkdxfou63vGkY5Qn zw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8dbasa0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:53:51 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29O0m0bj003617;
        Mon, 24 Oct 2022 04:53:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y9bnyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:53:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ORXEiUDzEcDZm4Htxy396oNVQfPCEt+1nwgVN4H9SvMLPdKmjLaKrLOW6t3zvzhTJfi6CMC9A7F6kFiQYB+lx8jPo9bVV6UWrEeKmZbiYak3q41OQmrdWwQQ+bCbSSP0Ie3b6ZA3G7DCWV/0YSawoLqi9g5uWw5OdRI0t5o7ds62oID33/T/dXiN4XMdh01mLH/h5OjtcmvSJCPnV0CUGn/hB/Ov4aNdlwfO8vXMhIGQsbLThws1hhrjFsPjaTUmMPZOdmt+w8fgrDbnvAmyafFbXMvmXR4AM32NoUbKm0WVkt9o8ZdUoIHECFAJkmzyVO6ftChk46T6mMNGUH2rTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KYs6Sk6L8F2stI5Fsht8sTwExs4U6KuYt0sXSP3LeX8=;
 b=ix57KSL4Dyr4jZy5ocvLhLltn3Db0JZClj4v6Zec1/UBAeIHk7tYTnTZqWP9A+xtzkGLFNpnho5u5YMIZ5s27OsaU/yQCT3FvXJ9461uRMmHryjbp/pOuvpc+HrxFICyhdj2HuU0lcdWIA6Yhudm4hZXx5KRj7Z3mFuo0Pl/ob/5DRHe2UJm0jkcNjp3QQnTpNstgz9wTHDZ3/s2cM+DbPVIrUJPNfqrKvZ21vUsHWjGRoD/fj2W0wG1dwWIwVknEf9m2W7B912fvBC+m97TuE4CX3f+1B2Mp2Ey0sJg0ZohQCpCYLdcF3I3FgmFe8WTBB7HSYkhovz7F6F92RdfaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KYs6Sk6L8F2stI5Fsht8sTwExs4U6KuYt0sXSP3LeX8=;
 b=qsoXhrklY3l+qJRB8qQGCG6gDvTGybwkLrFZHzkQT0P3hi+GQkWdXBDUtp5lbpLTyba+1G+tA6u0/rOMpmymg2v9Ngow1oYGLbiG5uK8kjdXch9Wg+L7K72d+lm6pAVe8UPhmhVqwEqhsjwLUY0JrQ/lz5MVyQ2E6lHToEjB4us=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5374.namprd10.prod.outlook.com (2603:10b6:5:3aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:53:43 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:53:43 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 03/26] xfs: rework collapse range into an atomic operation
Date:   Mon, 24 Oct 2022 10:22:51 +0530
Message-Id: <20221024045314.110453-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0073.jpnprd01.prod.outlook.com
 (2603:1096:405:3::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5374:EE_
X-MS-Office365-Filtering-Correlation-Id: ed182580-14bb-4c9c-3981-08dab57bb9cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XIDegruqK7PKv4d+mx6rxGiyb1rmo+OAzZ8Gb1rWY/MhFDVYU+zoe4cGK+oY5Dqwe/w59hKdwZzgP4YcHNVhY3CTo/hQqzCtJRi7ZvKeoUG5wrR6bjqY6ZTj+QBimL1n/OI9WOkkwUWKNs5NtE0Ox932oHaOPGJ9Ooe4svOO299dZab/t5Z1rWAmlcHleomSfnN9kVoEN3zkw+G+voc2FOxRtQgATjAJnh9fAU3DY/Si3vAVmTa3N5G+pkz8wB21KDj1YF+LcWb1LxNrGuKDU+OULZO0+857EoCuCCVSOZEoBNq0RJu25w6lXyhkHGPEH6hkcRhm49h+jt+sn5vr90Gn8wNoSbou4xmY+BbE7oJIy3dEh/2vbKbUyvbCyf6Lr2Uge8uOlwn++JQGeckdaLULStEnn6zIUBEejL5MkX9ZppUCMIwRnlNciWyvuIj0bvX8++A2sQbknQGRWI5lz8dU6NJWyGjHzt0WaEyLZXIMPEbdoObLe0cQYizLPjtA+IDypwuf+Ul78RkcXqj5+45Zdq4IiMMkphBAJLu4e/b+B8StetY7FG5svXfyC2C1vLzPAjXd8ZYzQTB5HZOFs/HQE//hasy5Pf4Du7Ox/Ip8MCo0KIDGCKxtVg5vbItkE0gr1JFj5YziqouvOomWGhnHfMlJ7NxHHbLRGgYm6U+LpVRnC5fljHKL2ClU6ZfiMAjPjfwj6GCOvgzyGkSkqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(6916009)(83380400001)(2906002)(5660300002)(6512007)(26005)(6486002)(4326008)(8676002)(8936002)(86362001)(66556008)(66946007)(36756003)(66476007)(2616005)(316002)(1076003)(186003)(478600001)(38100700002)(6506007)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wMz3AOFbNSDIHH/o9WGr9KqJ2sEW4WOZwWxbCA6tOuFytG+I8rLrRkLqh4UZ?=
 =?us-ascii?Q?z6bSvdJBUeqUtPh3t1sscMhPx41cE3cJ7QZ+nd/ouUKZwCBkBVWAYNyhLbrq?=
 =?us-ascii?Q?DyvP+8PPhnM1eJKEX4Xm2HbWN3CK0WWyyplYV1JNqsO5YrjEAyw64jZjtuAX?=
 =?us-ascii?Q?jjf+FKrBG8rgE0HgrMzMxtKIelWSXnfRTvyf6PraDXajIui7m49AzTZeIPN3?=
 =?us-ascii?Q?cFnOxC76euXGoUcLNND/7wfsKBYsOjYyyp3acQ0srXtr6ukLIvvxGIEjN8O+?=
 =?us-ascii?Q?Mbv1eChJ7WXwl7ZcDnbWYALhsbJMKPkXjRSIFvGyjIU+Qzxt1pPvRw+AA+xq?=
 =?us-ascii?Q?Y7gz8e/GqlZLDCQ6pZW+SwE8hI13iwZREDYVjiya9QoVZ6+0QM+xDiZdRGLj?=
 =?us-ascii?Q?v7xpe/k/a7akMYzbe4be4v5QdjsnlwUYW200Q7v5NhITOdMDrvl0bR9J4vH7?=
 =?us-ascii?Q?9lMX8ymPVZBhGRgtqagJGujAhcjYdlb+tckUHw97EwW2IHKIi4BobTBLv6Q5?=
 =?us-ascii?Q?ImQpzw7BhzJu3nLT/qIA/3vfxL1fUNFjApBCyVcrHFTWbX1NBftiJGN/J2X9?=
 =?us-ascii?Q?F/RpNWCbugII1rBeLIAXDf6G+VbPsqSuFEKwKd1S7xhOIZ6y2WlJJ4gI9THe?=
 =?us-ascii?Q?EH+3tLMHx1cNqo7uOuM/Qq0mZTtbp3yGa5JUaIo7dCKy1+6ghjj/iz/3sN/D?=
 =?us-ascii?Q?GEdw4tRpJuCoa4UpKxjy7/7BwDn9mkRyodASv1O5UpDToOQeFyqxCL03nySa?=
 =?us-ascii?Q?x8k/unOuD4iy6nAxTfzb9szR6iMV6iWD+EYPVSxVK1gyryzExost4J6b8ZOQ?=
 =?us-ascii?Q?Uk2lAiP1YEQ7fbNr1mKJ+0d89OJhuJYYxswwQ7v4h3HvelIkCX0nHeome7I4?=
 =?us-ascii?Q?sypdme8v46cLBOAFCYSGrgznhJR33H4w03+0Kzzl0VM22j/smx7a1vAOCrZd?=
 =?us-ascii?Q?lp4RFbAx28SFs2b8egRZy6qLTgaRtYr2FxRmwMk3C7q8DjSqvC1M4Uxj03AT?=
 =?us-ascii?Q?gKfqX8aA/EwmF/28uYDWd3lolmOrU9q3DLdfBUYvNgHM4VbzJXKLs0tQ4DF7?=
 =?us-ascii?Q?s4ZvPGKiKEPyVnzYAL/6wFL3ZROEYxlmj4h2+EiYKvnUG3ahQ2+FR9Akx8UT?=
 =?us-ascii?Q?tu4/hIBpi0CZDT5Ji3vA7orQzectdtQmfhUsIyzHJZq60rOgw3M7y2qlQ65T?=
 =?us-ascii?Q?QWNEyREot4swnI1FBrL+dFtarKZPWmvZkqtTvY0yzhJsSp0slqFZeok5i/Nn?=
 =?us-ascii?Q?MC1d+xYOpvbDnjwJO19BE3kIQc5aU8JHtZoqP64d4hNazt1vo87A8sfkL9vm?=
 =?us-ascii?Q?2+4/wO5ipDzMTDxU3ueyyHHmDhSDitSg+Y3qHsyqW8TRKapFiG9UueazEBpN?=
 =?us-ascii?Q?K8sqA7EoqQri1PNu4y/EiQ+xf1JA92gOvP+DNKw6rNKd0WQPv+u0SsNUP8xz?=
 =?us-ascii?Q?txd8tafdSPeH6eDMkqpFANZ+rRcgvMzPiNFITZNWLphjprkEshkIrZoLyMaG?=
 =?us-ascii?Q?lNQRgaSDGlleFYw8FTwfXeatM7lvx33oBst7nOCLJJfYax+G4/eDsrAP1bfL?=
 =?us-ascii?Q?4mah55Au90XpwK1pHh+AEO1G6nLOM0VZ02PZuIU2cGKwU5TGYNKY/ydMSwjP?=
 =?us-ascii?Q?ag=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed182580-14bb-4c9c-3981-08dab57bb9cc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:53:43.1478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lkpI2zerpW6q3DA/VIXVb1wSNjQm3iPvHLAX1Yx856LcgGW3d9FnV8eIhlyaorag8OqHmEtcxboPH/aKfBCAUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240031
X-Proofpoint-ORIG-GUID: rMq86EsBPscV1DyuXq3_Tm8jKnuoLfn-
X-Proofpoint-GUID: rMq86EsBPscV1DyuXq3_Tm8jKnuoLfn-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 211683b21de959a647de74faedfdd8a5d189327e upstream.

The collapse range operation uses a unique transaction and ilock
cycle for the hole punch and each extent shift iteration of the
overall operation. While the hole punch is safe as a separate
operation due to the iolock, cycling the ilock after each extent
shift is risky w.r.t. concurrent operations, similar to insert range.

To avoid this problem, make collapse range atomic with respect to
ilock. Hold the ilock across the entire operation, replace the
individual transactions with a single rolling transaction sequence
and finish dfops on each iteration to perform pending frees and roll
the transaction. Remove the unnecessary quota reservation as
collapse range can only ever merge extents (and thus remove extent
records and potentially free bmap blocks). The dfops call
automatically relogs the inode to keep it moving in the log. This
guarantees that nothing else can change the extent mapping of an
inode while a collapse range operation is in progress.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 90c0f688d3b3..5b211cb8b579 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1237,7 +1237,6 @@ xfs_collapse_file_space(
 	int			error;
 	xfs_fileoff_t		next_fsb = XFS_B_TO_FSB(mp, offset + len);
 	xfs_fileoff_t		shift_fsb = XFS_B_TO_FSB(mp, len);
-	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 	bool			done = false;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
@@ -1253,32 +1252,34 @@ xfs_collapse_file_space(
 	if (error)
 		return error;
 
-	while (!error && !done) {
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0,
-					&tp);
-		if (error)
-			break;
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0, &tp);
+	if (error)
+		return error;
 
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
-				ip->i_gdquot, ip->i_pdquot, resblks, 0,
-				XFS_QMOPT_RES_REGBLKS);
-		if (error)
-			goto out_trans_cancel;
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 
+	while (!done) {
 		error = xfs_bmap_collapse_extents(tp, ip, &next_fsb, shift_fsb,
 				&done);
 		if (error)
 			goto out_trans_cancel;
+		if (done)
+			break;
 
-		error = xfs_trans_commit(tp);
+		/* finish any deferred frees and roll the transaction */
+		error = xfs_defer_finish(&tp);
+		if (error)
+			goto out_trans_cancel;
 	}
 
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

