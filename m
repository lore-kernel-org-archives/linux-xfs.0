Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B92C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 19:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348725AbiETTAy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 15:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353035AbiETTAu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 15:00:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55CF5F68
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 12:00:47 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KIfmri010091
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=6s3dU2QVrZuqoclPL6LGML3yL1neyH8cZ9KK/D4UMHY=;
 b=HPjt2QXxRY1MzlhQK2Lo77BYHLO6k7sgIt9f9XnwgxLweBjLwBhHAS7m8nJi44IcHNvR
 HTxw8jwxDDVKsbejleUsVmTMZRlV0K4vHa5RJ+VogaCmZ36DxQyiUAmufooMqhrddok9
 vOZzsyNXFKVN4drP9fKZy7W5YmRq5IJmt4qZ7ADxEPzdZEREVeEZe4K4AlTIid0QGcFX
 bwHLMzeY8kJpWbaGmwJFn0kUz++su2/0ri+T3E4sZtZpmqVFtH9ibZYMRoGhRJCDU4cV
 f/AdnlQZ+zWEA5wUPOsh5jsBy6KB65IJMd2WpWOfmfv3AoH8Lu5V3kyQHc5BY1CT+Vl7 4w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241sfvp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:46 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KIppqV036742
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:46 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v6jjcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=As6kqhSmZwtxxW4jS5qknlbB7+LT6XG/3LP/WA3HEkkgxQ6Q4dQxK7+VwXSlNfjbEUWLS7ia1f5dRH5djsUltwCDvkYf1vlCL0TM9+YNEqlnRON6CTCNn7Z7hofgWiuTkzd2KezOwwyZ3S0jesLWSB7kyXsEoQaqeBcW/ZSwHGQ4+yBe5yCoibkXRFF39nGcAFroOdkS/h58L37MHlKmxmKkz6KKDgX8UWg2aUZXvyjJbF3K8vyWKyYPnkovp3bXLWVQEtKKMjseXUAbwaDdfEIFeZFOAm9TAhyJ9SR2+KLbGufpDs21eaY55i79dYq49JGMl0y67OLJ0QDdhKFPxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6s3dU2QVrZuqoclPL6LGML3yL1neyH8cZ9KK/D4UMHY=;
 b=BV0AScNfUJ7DPSx3/BIqiS1ebKlSCZxtmiXlkARB/zJj0bzDo7FW5FrJt41JYfdBNvN/ha+oRUYO8EX/DWtGSPTlKQJX84BajliikELZIta1aI+xd29LZUY2tmAQ2ajwkcuqjn4vNhLeeUOVNSNaDMEtgqpDJLlIfmpAmHLEBWdSFZaXzhjqCAMFz0mHFHO3Mc3YPYQRdZ1y98yzj80KyXCjPF84EG0AL3enY1GLwUQh5mZ7PsMyVTHCoaOI8K+MQMzKTd8tU+qWFwdGq+sXKOycAnaz3/LZz5BdYr0mfY4lS5OJeK2AwYcsldBRZEtArKpvUhPtgx6prqlyZn0gMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6s3dU2QVrZuqoclPL6LGML3yL1neyH8cZ9KK/D4UMHY=;
 b=vdZdTbhWjdXGFMDnPkmUPXZcCe+Rv4ufJdozc1VwV64ZnkGP9fI6lGl7L5Xu/wS4is92kOrb0ipdpttVaEoGNqsVZ26q+RLX1kF+f2JkmhbpSi722MShrzP8U9RIYGtadDP3AhTTcZh1ddiMvdefKEvyR7xvkQ7oq8QQdvgjp1U=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM6PR10MB3658.namprd10.prod.outlook.com (2603:10b6:5:152::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 19:00:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.018; Fri, 20 May 2022
 19:00:44 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 11/18] xfsprogs: Remove unused xfs_attr_*_args
Date:   Fri, 20 May 2022 12:00:24 -0700
Message-Id: <20220520190031.2198236-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220520190031.2198236-1-allison.henderson@oracle.com>
References: <20220520190031.2198236-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c2a9267-a05e-4b0f-ee08-08da3a93089c
X-MS-TrafficTypeDiagnostic: DM6PR10MB3658:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB36586D7B80BCD07C9208526795D39@DM6PR10MB3658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c/PKxS5ow06VGWqnh3MqPcvtQWgcDfSH/+ttmAiz/CwMmFCfPYsaaFB9YjKMC1EBPmiRLqfH2VO7+kf84KjPleuRrlaIqLCTk1dfs9tgqLjqHVAQ+4ZqmD1s+IaL/UQ5/OVkE44klOS39YPoShEE5LCpHLq6hzFBGUdqpIVjy6/4hFWHdObma/1IaVf2T7nowIUTePE6ddJD/AKrBH0Bdjo0knkrbjNZa7mjFgCg5I7FlQC56Wi1cIe8eYB7WTDJkoougmRiG44H2OgTdTuEGoX8+A/789kf/vIGuuBcMzSUnjZNGkrsSzI1mLM3H+oct17ot85bfcQvFBiQPEsLuWXEEOK2e6kqhUaSBHuAykISrEipX32ruz6FfZ8UvSxfv3lyNponTSr/pJmE1FXD1Qag0fHNDDlrG7DoEYX58Ll8qRgWF/SWQTrGT30oSG7M/Py/2Kme290WinNPi+cFBZOXH2Pv/os+TLJP0AAIJH6XCf3K1q2JjrXbIttWIbYEMrYZqTQQ3VQi6W3xPBz4mM+ysrvb3iJVFFeWf83EvFse16s8/XTWSo9NBgIWT2XGUKF/wgtw7vV23hDu+qnwSPXElCTwRNBAhjOnjyrF7QeH2RYiB/PMtvtDc8cCAuMSoyXi0kXLYTPmMTpzC7XBMLhUizVm8PGB4cCcUl3J6iUUYIfuP7CQuRAMdJ98GPpptjSepf4/O+H34I9HGf6wjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(86362001)(316002)(66946007)(2906002)(38100700002)(6916009)(8676002)(66556008)(66476007)(5660300002)(8936002)(44832011)(1076003)(508600001)(26005)(52116002)(6506007)(36756003)(83380400001)(6666004)(186003)(6486002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VEjSlefdlgtWzXApasm2u72UF6lbqwV3cc9sPvC2WHDmmN245lWviDhjosVL?=
 =?us-ascii?Q?+ADTqohjQvyVApGruxspX8Qo/Zb3hkL047QuXZXhIugYre9H0QvujisEAuMf?=
 =?us-ascii?Q?l0gbIzTXUcRRDaK6idHRL3M4GRgbFotCnjCwOFhmIYl9aI0MechCizo2PcA6?=
 =?us-ascii?Q?MP4aQ1YC8FAxWQiPVP4kLbw94hwmgphUxc93L8T43vt3tAFV2TBtGEoWYppM?=
 =?us-ascii?Q?MB2pIQ7KQQRCb8NSEcPxWfjs8XDk5UVZiVnK1e8WahZKC+R3Y3owUEGQhsKk?=
 =?us-ascii?Q?HB7wvxgdDpFuV1jtQKlESKAOCBSvPWCgXFrNcqvm1eqoJjLpjbSUwld0HlH2?=
 =?us-ascii?Q?ENv/aKsI5G1x3MzaJ44+n4+M/1FHvb0sYILVVwDvqgM5N4gx2Ug14DB/vUeK?=
 =?us-ascii?Q?3sM3HJFo5iEJ7+SQz94Zq0xZ4yrolblCu4k1TcxUOwNtGwhXepoonjfZNY60?=
 =?us-ascii?Q?COHl+Vl70DY9CPPOZa6lHbJp4HBiCvAThvg/Dz+mmQSWbDsXGoYjtFUu68Jw?=
 =?us-ascii?Q?mSjnA/kSiq3R4Jm5njRZdBBWJevKzg7EngVnSLhUS8M+s0zcAyHtgqSAC6UG?=
 =?us-ascii?Q?myvTbAzC5KvROAFSGig2pQXLSqPpnnpKpEuxZx90h5ellbDOtTUyk1qA5IWl?=
 =?us-ascii?Q?z7mgpsddaOX2u550xoDreCSm+4y/UEUKOaBBoZNaefr/DgrZSEhhNzl3hq4G?=
 =?us-ascii?Q?sVx27zKY2SNIBUCmtEWJczq7apIK/B9kJ0w7v9BEeGcROYLnfOsymCQhMGAP?=
 =?us-ascii?Q?d58VW8dtBV1HcVYVRDNhqy4bPqKQaD1LFC9T485amMfPpvub1zTF3Nn/iKFI?=
 =?us-ascii?Q?n+SnrkFh5NewpQxxGWSTbVRbFw6gwQx61PnidStCaw0/acU364fjp3MBV3bF?=
 =?us-ascii?Q?rOrBZv7HvUlGgyHpDwb2TqYSAAF8RpXRsWqc4/UDRIITYeecEOCS91QZDwss?=
 =?us-ascii?Q?tzk5uSgFXGsCk6wkTNg3jjQz2QhhmRsP0tC9sSkjPQhtZGE8zT4Eq9sDCrZU?=
 =?us-ascii?Q?dASjKfqJ/5TVpnaxz7LUdzvnLY7MbgJRAEePOqssQ3VBGYwpAfFutFJs6MwZ?=
 =?us-ascii?Q?fJ9+1C5PhJQlSf3kvs0kB5Dj9XcpdfdAaDnNJjgQvi7/twQoi+cKgwgpXQZW?=
 =?us-ascii?Q?Xz2t2QLwXw5EhHyhbG5rcUIHIMOy3G9DIRq2dxFMDMkqQdj6jMKgq16it8Ri?=
 =?us-ascii?Q?6dqTOHH01r1Va6QWR4HIBRgz8+8Kl+2hNwqRm6PwG/yejSSqBh/C/x/Zvgbe?=
 =?us-ascii?Q?wRo5w/+nFYATZTW6ussuJdtjNEo891nob+a1lsnrtrjD2CK+qDiVP28Mez1b?=
 =?us-ascii?Q?4moUxrRM62rN6VyadotwQ0t9YL61Bdp6wJOxAjJCtOMY4vKHZ/yaxSDNyi/Z?=
 =?us-ascii?Q?1yWF3cy1nMxktUZM5dXVgJ+PW6WSKJCPvxDz2UyFiB9oHGdGN7Jo7r3GFrlZ?=
 =?us-ascii?Q?G5ESnxaej/BvuAaUCjjmY+TwierYHKCP01ZIZjEM3fI6T8+GVdhQXIvLKQgF?=
 =?us-ascii?Q?W5BNwjej023T6+zVEasUWw6c5lqZEQhDWZgqtInvCM5qynmF1QZQdq8rNq3O?=
 =?us-ascii?Q?BkzbzDj8wxfta2oaI6CYv7m6VzTVx5k5jcNk6ejJeeCOAeo6btEc3zvFdO0I?=
 =?us-ascii?Q?uEiQZP4FBAzXIokQRf/2QOPuhvdw/7ptsnqP+gvr0iPEOxXubzd5+E2SkqEv?=
 =?us-ascii?Q?0S9J+Af4fpWBiM5hKupLHTAgViZaE1quxFrrvBX6fgy30eMsG3q2UmYNIJ0v?=
 =?us-ascii?Q?xzJHLIIn0ZPDoJeL8O25gRfUFwdl+Cg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c2a9267-a05e-4b0f-ee08-08da3a93089c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:00:40.6233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aXnhB+CDGAdq3f1xNvNDlS6LIiaaQ6JAtV8uTwmRNiBoqKPDH6/u6rGloNF+8O+Z0nVVe4A1KWOGZO9b4PvAo1s938sA7MOdxGTX8tFyEFc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3658
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_06:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205200119
X-Proofpoint-GUID: zuWxVxmpREd-2isccH7E6CITf3YYAFa7
X-Proofpoint-ORIG-GUID: zuWxVxmpREd-2isccH7E6CITf3YYAFa7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 73159fc27c6944ebe55e6652d6a1981d7cb3eb4a

Remove xfs_attr_set_args, xfs_attr_remove_args, and xfs_attr_trans_roll.
These high level loops are now driven by the delayed operations code,
and can be removed.

Additionally collapse in the leaf_bp parameter of xfs_attr_set_iter
since we only have one caller that passes dac->leaf_bp

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/defer_item.c      |   2 +-
 libxfs/xfs_attr.c        | 106 ++++-----------------------------------
 libxfs/xfs_attr.h        |   8 +--
 libxfs/xfs_attr_remote.c |   1 -
 4 files changed, 12 insertions(+), 105 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index be2a9903701f..eec2c6c27bee 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -175,7 +175,7 @@ xfs_attr_finish_item(
 
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
-		error = xfs_attr_set_iter(dac, &dac->leaf_bp);
+		error = xfs_attr_set_iter(dac);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q(args->dp));
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 4550e0278d06..3d9164fa9a2b 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -241,64 +241,9 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
-/*
- * Checks to see if a delayed attribute transaction should be rolled.  If so,
- * transaction is finished or rolled as needed.
- */
-STATIC int
-xfs_attr_trans_roll(
-	struct xfs_delattr_context	*dac)
-{
-	struct xfs_da_args		*args = dac->da_args;
-	int				error;
-
-	if (dac->flags & XFS_DAC_DEFER_FINISH) {
-		/*
-		 * The caller wants us to finish all the deferred ops so that we
-		 * avoid pinning the log tail with a large number of deferred
-		 * ops.
-		 */
-		dac->flags &= ~XFS_DAC_DEFER_FINISH;
-		error = xfs_defer_finish(&args->trans);
-	} else
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-
-	return error;
-}
-
-/*
- * Set the attribute specified in @args.
- */
-int
-xfs_attr_set_args(
-	struct xfs_da_args		*args)
-{
-	struct xfs_buf			*leaf_bp = NULL;
-	int				error = 0;
-	struct xfs_delattr_context	dac = {
-		.da_args	= args,
-	};
-
-	do {
-		error = xfs_attr_set_iter(&dac, &leaf_bp);
-		if (error != -EAGAIN)
-			break;
-
-		error = xfs_attr_trans_roll(&dac);
-		if (error) {
-			if (leaf_bp)
-				xfs_trans_brelse(args->trans, leaf_bp);
-			return error;
-		}
-	} while (true);
-
-	return error;
-}
-
 STATIC int
 xfs_attr_sf_addname(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_inode		*dp = args->dp;
@@ -317,7 +262,7 @@ xfs_attr_sf_addname(
 	 * It won't fit in the shortform, transform to a leaf block.  GROT:
 	 * another possible req'mt for a double-split btree op.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+	error = xfs_attr_shortform_to_leaf(args, &dac->leaf_bp);
 	if (error)
 		return error;
 
@@ -326,7 +271,7 @@ xfs_attr_sf_addname(
 	 * push cannot grab the half-baked leaf buffer and run into problems
 	 * with the write verifier.
 	 */
-	xfs_trans_bhold(args->trans, *leaf_bp);
+	xfs_trans_bhold(args->trans, dac->leaf_bp);
 
 	/*
 	 * We're still in XFS_DAS_UNINIT state here.  We've converted
@@ -334,7 +279,6 @@ xfs_attr_sf_addname(
 	 * add.
 	 */
 	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
-	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
 
@@ -347,8 +291,7 @@ xfs_attr_sf_addname(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args              *args = dac->da_args;
 	struct xfs_inode		*dp = args->dp;
@@ -367,14 +310,14 @@ xfs_attr_set_iter(
 		 * release the hold once we return with a clean transaction.
 		 */
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_sf_addname(dac, leaf_bp);
-		if (*leaf_bp != NULL) {
-			xfs_trans_bhold_release(args->trans, *leaf_bp);
-			*leaf_bp = NULL;
+			return xfs_attr_sf_addname(dac);
+		if (dac->leaf_bp != NULL) {
+			xfs_trans_bhold_release(args->trans, dac->leaf_bp);
+			dac->leaf_bp = NULL;
 		}
 
 		if (xfs_attr_is_leaf(dp)) {
-			error = xfs_attr_leaf_try_add(args, *leaf_bp);
+			error = xfs_attr_leaf_try_add(args, dac->leaf_bp);
 			if (error == -ENOSPC) {
 				error = xfs_attr3_leaf_to_node(args);
 				if (error)
@@ -393,7 +336,6 @@ xfs_attr_set_iter(
 				 * be a node, so we'll fall down into the node
 				 * handling code below
 				 */
-				dac->flags |= XFS_DAC_DEFER_FINISH;
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
 				return -EAGAIN;
@@ -684,32 +626,6 @@ xfs_attr_lookup(
 	return xfs_attr_node_hasname(args, NULL);
 }
 
-/*
- * Remove the attribute specified in @args.
- */
-int
-xfs_attr_remove_args(
-	struct xfs_da_args	*args)
-{
-	int				error;
-	struct xfs_delattr_context	dac = {
-		.da_args	= args,
-	};
-
-	do {
-		error = xfs_attr_remove_iter(&dac);
-		if (error != -EAGAIN)
-			break;
-
-		error = xfs_attr_trans_roll(&dac);
-		if (error)
-			return error;
-
-	} while (true);
-
-	return error;
-}
-
 /*
  * Note: If args->value is NULL the attribute will be removed, just like the
  * Linux ->setattr API.
@@ -1269,7 +1185,6 @@ xfs_attr_node_addname(
 			 * this. dela_state is still unset by this function at
 			 * this point.
 			 */
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_attr_node_addname_return(
 					dac->dela_state, args->dp);
 			return -EAGAIN;
@@ -1284,7 +1199,6 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1538,7 +1452,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 			dac->dela_state = XFS_DAS_RM_NAME;
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_attr_remove_iter_return(dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
@@ -1566,7 +1479,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_attr_remove_iter_return(
 					dac->dela_state, args->dp);
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 8eb1da085a13..977434f343a1 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -457,8 +457,7 @@ enum xfs_delattr_state {
 /*
  * Defines for xfs_delattr_context.flags
  */
-#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
-#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
+#define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
 
 /*
  * Context used for keeping track of delayed attribute operations
@@ -516,10 +515,7 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
-int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_set_iter(struct xfs_delattr_context *dac,
-		      struct xfs_buf **leaf_bp);
-int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_set_iter(struct xfs_delattr_context *dac);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index afa932904602..5dc93c3b26d4 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -694,7 +694,6 @@ xfs_attr_rmtval_remove(
 	 * the parent
 	 */
 	if (!done) {
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	}
-- 
2.25.1

