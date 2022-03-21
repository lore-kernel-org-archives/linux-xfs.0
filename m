Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B85BDC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbiCUFXJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344403AbiCUFWt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:22:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554763BA55
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:21:21 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KLLRAu006156;
        Mon, 21 Mar 2022 05:21:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=brLYlywMMMOyz4uvfVABc1jXyU+lhPjj4ttrhqkfKng=;
 b=P0QiVUX9KKGk8nFMlaXuZSjq7L4HN6FN0ER5t4I3RKqMEJ6y0+2pNwIBWQm6AwgbhMit
 MwMub/1mBDHt3dziE3LBM8ap54/T4W7yt9yQr2MEf9D9HIYGFHAbpmdiukKUpomWObJ8
 Fbf/unsLuiuNHzjkewj8YcQt/P2to+CukEzLUbMbCjiA9X1k3u1r7uN20EVKpKFOfAjJ
 SKu5nBGZTE/chContFL0aHZVOABK5rIV5ud24ggYnBU8qHq8ddKXIcALlJP+qdIVz7bG
 x4m1jIzYWLxApENpSikbOQ93oCAmkNmSXso5w38hMEs/Y1xoMWTnSJkXJxSXa2SE1bw5 Rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5y1t4tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5KJKr163147;
        Mon, 21 Mar 2022 05:21:17 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2170.outbound.protection.outlook.com [104.47.73.170])
        by aserp3020.oracle.com with ESMTP id 3ew7009795-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCV9+cbrgw47frr1qbdXOrFbjwsKacqlp1UC1duC9TU7W1BgKS7QY0f1MGUnHolKnZ/od1uZw3qlD0Ydng5ROi54pupSBRjr1EOyW6s/f5dkWXMbXZUShwvxrGZ9OcFDRQNOcTkFGri/8bFa5GMV3PRandQxaxBohOxad6qzIKkT824klWEUiRh/eYTBpHeCio1C9jOLLqgial7hWY8Xo/sGvwHXe8Jz+R53RbHPINHFpDaDSwCXR/lBVsp7cUDmXLmM60SwgGPrH12dV3UIHUdAcIlxWi7cK0MhW4y7h06364tWHmOfj/j0JAwvGfD9llfgbhnZmXJQ2XBd8RCvoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=brLYlywMMMOyz4uvfVABc1jXyU+lhPjj4ttrhqkfKng=;
 b=aroyXG+oRAsX4mjWHWMHuItFDXTUwjr6YZAUEYQ9I00BLVZXOyV1stZfjGzPdavVaXSmm9SlBhSyI46fu793bMH2w6+pJ6llRDYEf6ISQ6/l3PaSwbuBjtTKAF6CLhrVajerLaE54l8C3iOOBTTZx+8VRfa2XYaJsTbKkvuyj0FM0uOe+SIKeBqfMF3t8MMsg23wPq56Pkhor/Sc/zBR9xyhtaHetkosvbmwbWJfzo/tl5mCFdmvU+FijJPz10dIEa+LxmQguGqmTlBMBJKitpm/2v+zwUcGC9cQiOCW8OYnEv5XD7IzzbJUUr4bPMVZaiRuOHFmDYB94StXd0F2MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brLYlywMMMOyz4uvfVABc1jXyU+lhPjj4ttrhqkfKng=;
 b=QJ629+iH64A2A2tOvEyp6rdieMljd3tqhdsFCSSfciwR/Kdd/IgSGnx1/NvqPd949niaFarfhmfmVmHa1+eiGnTABHSF1Fkl7Wv5AthBLaLQODt6U137UAiiEpajucnj6gl0kvYPWxApCwAJkHMO0TEWjjcatttOTKl5puF1Lm8=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4473.namprd10.prod.outlook.com (2603:10b6:806:11f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Mon, 21 Mar
 2022 05:21:15 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:21:15 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 16/18] xfsprogs: xfs_info: Report NREXT64 feature status
Date:   Mon, 21 Mar 2022 10:50:25 +0530
Message-Id: <20220321052027.407099-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321052027.407099-1-chandan.babu@oracle.com>
References: <20220321052027.407099-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33e2eb4b-e361-4308-ba91-08da0afa9f17
X-MS-TrafficTypeDiagnostic: SA2PR10MB4473:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4473660958C8DC6311AF7289F6169@SA2PR10MB4473.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JQfX2X6uzwyC0BUHylzVKFLfx0j1jMUC4MTsJnA4yx2o8/U29dL1diWe3p4lUdE1NQOJgTsPlGTKjKX6z8RqtID73ttFfRCZn52EBLeqM1c8qcMBVy4Y5xAmv+a8nTK6HCjmLyYk3vUnh21/ISOVKnuXL6UhFEP32VLBPgk30sVud7bfatzLERMHXF4Ug/EiYQDideANGOZmk//Gpk6ACvVLzXNjAV8xHRu3TtjOA79dH12O9ESBhOTtQpICMii3NQd7dXAzIXkPOH7Csi0EzwF3Z18zXxv0PTmacR2+yaNH+lS1Nhm39H5MaoMn1T5emf/vPkpZyfFUHRixROY2XZeqHl4cSQuj6u2ubrFKlHc2+9X9C60e0c91Edh33YFo0/w4+7RaBV9TtlAAFDCDMaFLIB0lizMF0lFzT0DOCLdvCiDCyLkxV5YdUkhxLWX661kZkQkKGWi+aEX95Sf8zuPA6AXSRR6vLF7d36ll+n1rXo3nrV4+7RWso0aT2jfqjoxhJr+52y2EfgSeFUqjaJ7OZNNwf/hG06vfrRxxlfZHkF7Bk72OXILvlMgSs4v8zjDJefGHNTc0/izdhoPaanKkczkZDR1UofO4XUQvVz7CIReiFetjKPjUh+Bef6bnN5/RRoJEjOT6PAWWmSrjKX3Q4rWnSF3/m6D80i34sScTwZAPQv3CU9ftFHPVBDFFN1zysGnfN8ABcGGsP/cq2dmemYMGK8H3WEy/tO51K7vsfUDcU0EC24TJ2rRjN4yb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(2906002)(508600001)(83380400001)(66946007)(66556008)(66476007)(4326008)(8676002)(316002)(6916009)(86362001)(5660300002)(38100700002)(38350700002)(8936002)(186003)(6666004)(36756003)(26005)(6512007)(52116002)(2616005)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zdyG3iev1JC5ZGH8Vaiz29huR8vlFy15mMd95M1FHCYIpflVXEAx2uRWdQzH?=
 =?us-ascii?Q?pozeptn33nJ48pT4Tj06gr4xU1tN4VdS3uQQ/KWNRCXMlFz6PBA3Gqj1x4dn?=
 =?us-ascii?Q?m3lMpmclXtLzO8r5DPNJ72oJeM60/zzvEoXjFfJQNdYL4dbeBrWOeG8hLtgk?=
 =?us-ascii?Q?h/MN2m0+ulqi/F0yUV9482N6rCkM5JviXlq38COEJ96fcmbKU+6V3gcblsZK?=
 =?us-ascii?Q?GvKKeuPRYTwRl8F1tWBBknxDZzL7Jfj+ngcjgcMgXe9/u0xhfrQ1vz+Ewv3e?=
 =?us-ascii?Q?W6fZvXE3SiQ2o2ABJKu3BnWrSnM7/tsgxRKqsLY7nd7rfH4Ma1/9rh6YZo8y?=
 =?us-ascii?Q?GZbKkP4WzpXHqHs5lLsg0wU8+muFymstFDyEXyfD8gNvXzx4jD3ge6iYRErK?=
 =?us-ascii?Q?5y4A/bmhnIGLBiTFD+uIjgjzk+4U/iAq/mUGHiguxV3cvNWvTtq5GaXNAD15?=
 =?us-ascii?Q?qkv2zy3WU0sYvb8C6M3jbHOx7bVjTmjllatZwfTIFFB7O/CpptAqdlbqOL6k?=
 =?us-ascii?Q?w0LdiMPSZ1bdydPpIGCgsCWx20gdHRYuLdSdOPX9Wu18QLzg7Ymjs32nXRJi?=
 =?us-ascii?Q?sy0x2CQRMdlZlH2Tng07E5w6wxm54NhwYaW9ibxuZ5nRCDnFzjqTP28FgCxD?=
 =?us-ascii?Q?rAYV6vfPPHQ8idWiugIKSgwTCnddPqW95SfiI4IKZPoVLocJTLvhGS/8ajd5?=
 =?us-ascii?Q?4ULsn8YpJMKN8l3dHsM8IXhNluLxTmyYkbTzs5see49H8YU1pt6yBuo83YiY?=
 =?us-ascii?Q?xcfzUFeI24yN+XM+5ZaW2NvSKm/xCnl6ZOx3thqzkDDCZDyxEkYswxQ1Aj8N?=
 =?us-ascii?Q?wbxai6X4HnfcqiCAYasuyRxqYUUAG5WseZFULMTxr3fLe0S5a0pMSBs2VtLQ?=
 =?us-ascii?Q?NA41jLRwWW2OvyOqDkE9Act77xDeROCN+rrmZsv2zudEZXxvFpGblLXJwG2N?=
 =?us-ascii?Q?fAAZVioVQcvmo0SaNige0T+Gw8vd8AXr2pftmXGHMDbErHXkVI2rxh31kLXV?=
 =?us-ascii?Q?889vq7eTCHruhvKgh/7V4QfXy4jCTT7duB98uxNfkKCGo+/AJ33xGvYs5sUU?=
 =?us-ascii?Q?lUyqnvXtQSviY/BVC2dWPnAVSUVBs1eKoFiqK6zX5Vw6Ajfk0nah5gNC2rU/?=
 =?us-ascii?Q?qfHqoHSK2GE7ENZJTxoZIbrAMosSXL72VhCwMUgRYX2oAtB3fsslGIY3LSDo?=
 =?us-ascii?Q?qPmKpfpalf1bNkfnsC3hq5CUoeGqiHIAjH5LB5RM5/eVDtyzs3RXdkQZA0dn?=
 =?us-ascii?Q?J3Del6noi5LHQcyFXVTrXHkCmQVnzLWhhTmnLkupbVeHk5ggOtKL94GvApG6?=
 =?us-ascii?Q?pMlPdQAwfCLn3z2gm+4G+DugkKLIYOgwKLEkBkfq3PO8XkitmbIXhtZ/y5Ne?=
 =?us-ascii?Q?OhKlxZCAdllotT2644p3ea/7LmOD8j3Cl/omlRLMevrkrer9oXXsYRXdFZ7o?=
 =?us-ascii?Q?af04xGJ2FPOpHH/WXbgYvTgo44d0mGAFn/84Rd1Ez/d0bnnyjn0n9w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33e2eb4b-e361-4308-ba91-08da0afa9f17
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:21:15.6079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GE03RFnBivuFYfjUGzGjtWJSHJAxvpL54T5A8vh15+Ai5nsJVG8FaA44A7CcegvtmyTumdwhQOgDmIALYs7Sjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4473
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210034
X-Proofpoint-GUID: t6J0AXvOfvBB-JwCifpeysBzE3onIZ5S
X-Proofpoint-ORIG-GUID: t6J0AXvOfvBB-JwCifpeysBzE3onIZ5S
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds support to libfrog to obtain information about the
availability of NREXT64 feature in the underlying filesystem.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libfrog/fsgeom.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 4f1a1842..3e7f0797 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -30,6 +30,7 @@ xfs_report_geom(
 	int			reflink_enabled;
 	int			bigtime_enabled;
 	int			inobtcount;
+	int			nrext64;
 
 	isint = geo->logstart > 0;
 	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
@@ -47,12 +48,13 @@ xfs_report_geom(
 	reflink_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_REFLINK ? 1 : 0;
 	bigtime_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_BIGTIME ? 1 : 0;
 	inobtcount = geo->flags & XFS_FSOP_GEOM_FLAGS_INOBTCNT ? 1 : 0;
+	nrext64 = geo->flags & XFS_FSOP_GEOM_FLAGS_NREXT64 ? 1 : 0;
 
 	printf(_(
 "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
 "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
 "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
-"         =%-22s reflink=%-4u bigtime=%u inobtcount=%u\n"
+"         =%-22s reflink=%-4u bigtime=%u inobtcount=%u nrext64=%u\n"
 "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 "         =%-22s sunit=%-6u swidth=%u blks\n"
 "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d\n"
@@ -62,7 +64,7 @@ xfs_report_geom(
 		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
-		"", reflink_enabled, bigtime_enabled, inobtcount,
+		"", reflink_enabled, bigtime_enabled, inobtcount, nrext64,
 		"", geo->blocksize, (unsigned long long)geo->datablocks,
 			geo->imaxpct,
 		"", geo->sunit, geo->swidth,
-- 
2.30.2

