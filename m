Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F3A3C43217
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 19:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353176AbiETTBE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 15:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353141AbiETTAx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 15:00:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E473818E20
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 12:00:51 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KId7EO028574
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=ah1GyGptRsFpKeV43hKA+otpXeZ/7FBjpbS5EyUDo/g=;
 b=QSj5hJVf5a9/xEMkWZXjgMtApnv4r35+wku9Rf9+l4TIBEqR/1DeZqfefjKCIjIsnq0v
 mt1IUBmjecmVBE2QlUkQEvqWHJLB9UOLhSrP7woeMuUMDrJ7+BDTk+mfWVoQ8JiVuLxQ
 U+kndCOO8wtVoFDHseLg4PgYZwKFLebEB52jZ9/EyOzY6zxZgdd59awax79bpGBWHHY4
 q8k1mYjHiXrr5GfN3/ps/sGu2eg3kuF7pjyUvOgx1/GvrK+KdntIKgYH6Qj4970owcCE
 jdK304ThlFilFYhL3kmm3iv6toEfDIqP663R6GpOcAFXxfVL3pEyUSYJEY3EuQbDdAsS fw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g237284af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:50 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KIoAPA034622
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:49 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v6mhj7-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmemOLStRprRCsQM/OFzkM8TK9Gacq90RhmPiOZzusC7v0zVqJMqXoM01MFrOCSfg7J8nd1Yzrw1AWYpaE/ZISXx2o1OlcdV6KqSLyrMP64cNMaIr4mEWo1Weo9EO2oN40NzUqsoxZVf6BbplYCjfhFggiOdVRl5RufFCt09bTe4wXmw/JadJTZMubs2i8amPrwnofCYhvVP4CQGSiaPDzlXLnPHySNVB21/8I0deL655kdPU/mgNuaGgOkotnRiFErgNMAG+huCt0Oh+vkQgJ+sSXC5OxZovZOlHbmee6+z2+8CUliEuxPe2uDhRkVksarzb5YghMnpltyDy2I0Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ah1GyGptRsFpKeV43hKA+otpXeZ/7FBjpbS5EyUDo/g=;
 b=Ua0xb6apojiAO8UHpRezlg3R33MgXsFnKShJf5Id54gsFUEYrS7nTrJgPa5zXvITKi5oiMsTfW/AGawU+KrkhhQp9YzrreHLN/+z7LHbuFbcDeJZGWeYQNSOFHOgn99rJ1uhaU9CMRnbfmBrKxS89DqcGCtI82eZ7zBiEbRY9LJQxGiHiIJNG8jJ4R9kP4IYE/qITJfhieC2cqi09HPotNgV9X6hLbjYhlD13Vi0nKd69Oj7EeL68v3BzuIpfhfwNRtduVaS3gweYBuSdVvdzpipzzsFuoE3wXhGThVrC1woroSgLXaY6jsHjVuAI3jUyTDWnUcxKvdpPi6lDzwJKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ah1GyGptRsFpKeV43hKA+otpXeZ/7FBjpbS5EyUDo/g=;
 b=eKouW0g+imtUaKCSGFlxMXV4SMP4iERJGQXy4MV4GKIXPxunbAICwnOYNe0nx5ydSvz0lGQ65aEe3mlb7oHxasR77zMYX2YEZYherVD8B2cUqHzoTinbLGc3pWdE1IaubMrkQqGf6TOJVGIpzZIA5Pi23vPNpncIEUkJpBsDrY8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM6PR10MB3658.namprd10.prod.outlook.com (2603:10b6:5:152::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 19:00:47 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.018; Fri, 20 May 2022
 19:00:47 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 15/18] xfsprogs: Add helper function xfs_init_attr_trans
Date:   Fri, 20 May 2022 12:00:28 -0700
Message-Id: <20220520190031.2198236-16-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: ffd7b2a7-bddc-41c0-3c57-08da3a930978
X-MS-TrafficTypeDiagnostic: DM6PR10MB3658:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3658A3F845EE488B6CF2AC9595D39@DM6PR10MB3658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2P2fZq1t+hHc2FWvBTp34Xm5+rveWUf4rOfKQv9nioKPcCZ92DaE1j0pc+YPdDJEwZh38oZ6SmhQ30k24a0zOV4kqfnFc70e9bnoQ06p7HU1wxMzXlyj3af5dL5vir1b/NLOcStn8hOFRm58HOI3ooQOfMGVHPwTT60NRSS03UnY3kCNZgspB+YdZTgKyj4IKO4VZkIayETa2vAGpKcFw0Hk5gXCCLBToAPNeVcgFkAFwvZQwj8sVTURdPo9B8QxSyEP4GEfSwH/KRMEIuqLFS5yom5wnKXAOHv3ecOYampkZlltSnrxpgSv4ZLccNTwrbmp28Okinm2Xyb610xg3hZ4cMKD5O4popRYhtxnQFvPf0I0rLtap0H9sNUXpRpKx+sVdqYNA1R9VGrj/GI+WF+Rr2POVUNjdGtZUDcivkn0dcbadKOGWVErEPAtFGSg3zRGJRtNcHqhrFNFiZFe/OdJxO+OH302HF7nMnVROe8zPCEYt6uRLeu8mRuLe9zVQVWMgGOAruHY2G7Sd4ALB9ELghy6YZRQQPgoI9GcSY12GRYvVnrrlcYvYr1ux6sA4C8cskrfDvfKg/vOKjBhs9OiiLG5gWBRfcURzm4NtafS/C1cYZ8ru8y/3y2AHIrv85/4Pt2TfY7GxurMJz4kqWYUQCqAb7yZjOX1OGeiYlUshABWPNU1+CnxUXA24c2omwpoIUWrpQL1Z4znEThwwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(86362001)(316002)(66946007)(2906002)(38100700002)(6916009)(8676002)(66556008)(66476007)(5660300002)(8936002)(44832011)(1076003)(508600001)(26005)(52116002)(6506007)(36756003)(83380400001)(6666004)(186003)(6486002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J2+ZXj60FayJtuApO5r3R77DdWzhDjalpxDcbpeUekMp/VJmnXtQZk4I/vlt?=
 =?us-ascii?Q?7fpeA4F9EJOe2jm8yZnCTh6VM/9bV6bQ80G/PlSe7m21FJEa60woHjxSvbcz?=
 =?us-ascii?Q?I9vTqM4DKK6rsGgIV1KYjQRaFKkrz+PANc8Ez+lVkk8LSgGFwBzB/xR4fhSy?=
 =?us-ascii?Q?Mfr/MuQTlmdLDBKGxsT+zM11UXP19RBJyLiOAKLpADluajwy5c4xUXmYSo+x?=
 =?us-ascii?Q?y4n02IfEbYrpDdN1R4J1D8/xoV9OLMjfqQgVabya3Z6BJw4GwjluNe37XtZg?=
 =?us-ascii?Q?SiB4fTYeI0SDPb2XN4M8cYt+fLcVXVCbcLWvqHwkF6eD9HBF5tbV8Qxoa81m?=
 =?us-ascii?Q?T5+eHHADRCSt2PAjukekKy2vsGfTnaBMxSQOCRYM9h2oVlGvvWS86JGTNcSY?=
 =?us-ascii?Q?zcVmmU07ujRaKw8NvHgukb6ryjvYz//ZT31cXEwTM3t0zq+BYnZBUe7NCk+5?=
 =?us-ascii?Q?qjfMAugzGJWvl1KjdKmlmrnwizApcVs74vwnvelIPTkuggiE4D4Ol813JQ0S?=
 =?us-ascii?Q?fvWDkq8PY86MLwVRbRk0+tKP96+LvMhcqw8zWDU6F1r9e2a/ATchRpW+iTb7?=
 =?us-ascii?Q?QLR+1IwJofP3LhWzVPR5h257VwQtS9l+aE6XpIniE/Qxn6ab6EFzV2nxLESw?=
 =?us-ascii?Q?78VkUvyfUoqPF7iDvQqq3J8Jc3a0gR6wUl/zBDL+Z94+q2WMrcoJxc+t+wTj?=
 =?us-ascii?Q?RX/bkfYOlnf5lIgbkgDmce2BpRzh0RHhdayB6qtB703rOIsZSR4VmFX6TQ+R?=
 =?us-ascii?Q?rbQg39rQa4G69ofXstEQKjVyPz53RsOZyWU21+MXLRXdaJs1OpthBVGBiOkd?=
 =?us-ascii?Q?bgM/AIRRzya6Sy8cPhm0um+jTmwVL8tw437HI3fH94Hr6URUDjVNvIsfosDk?=
 =?us-ascii?Q?XDI2340ANj8k+/Q2kyp/+miS+ZiXBYv/Q+2udEQaldnt37em3O51pPujgNr0?=
 =?us-ascii?Q?pN/oFQ5PQ/ccKA4oba1KJUUEblu0ZFn2Vn3SM73QMZ7GCHMs6x0zXA5mqKZz?=
 =?us-ascii?Q?8Mu7qXrNK6ZXTJjQMCFYEwB0MWkGvdylnMHQ81uEkYYyuB12EUk5oTGVAdeh?=
 =?us-ascii?Q?fpgoldU+nKmmQfSYLfvBSknfxdxNT4y+CEotrAnWLerMOK0/7bpPy+FjgncI?=
 =?us-ascii?Q?t1MYXQUQqkB8gPs1VBLla6g8oV4WH7zAaJe+B98P6yZ4/wWuFcDp9qzuGyWn?=
 =?us-ascii?Q?cz7PAcN4KOvOU7EHh7V8py9fKiWzKvz787COREFWHJpLnR8K2n7xXOBORGU/?=
 =?us-ascii?Q?WEV2VsZineIM8Y0JoDixdGaCH2BYKtLr89rxDiXRQFWTiqsP0gFCZb3+GXSm?=
 =?us-ascii?Q?E/CO1KB6l7t0CIIZKvRfISzEfNNE7yFVW96mJhSr/3CezEujt1KWuvqoRQHf?=
 =?us-ascii?Q?O4NSpEudbNb5KkI6+qvesW7k+Plvjz7mKZU9HxX1yGVX3qu6cFjPc5fcWcXH?=
 =?us-ascii?Q?ZoZZBM45cZoxV/6/w5sbOEqcB2Y4Gq983F1IZ9bBmSO2SR/nSr74i2lfqWJs?=
 =?us-ascii?Q?jWLP3t0+ECN5Bh8LvSapPyCLGbIGY7CiZpJ52+88VM5WztB66mKh/jCoZ1MF?=
 =?us-ascii?Q?4Dp4c4f6QkHRsyXu5LKpiI+3QtxUw5AIoe36fKy5FCbCEp4QLEmzCtWAC8J8?=
 =?us-ascii?Q?IOM5jZIBxORO40zHDoNgxXLx4G2Mb0fBYeg59xJjlkSUqIDVlTMgPrP07qoG?=
 =?us-ascii?Q?NHfGoME51VdhaNnsZQnylp7A6s+4Vjc7Db/THn8GAr+NMIxb3PnR5tI3HQn1?=
 =?us-ascii?Q?Y1CV7gRgQERXXmCuyN/1AqXggxNraT8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffd7b2a7-bddc-41c0-3c57-08da3a930978
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:00:42.0918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Xgz9aHZD8tB2Q70nL1qwsU5Vl8VeFJjmsT/BLoD0dn3jpwasCsudv2RlwgFVKpWWDkOvVrUYRvSEMJbBzqvXAZ2VXBbExMBzRykchBrU8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3658
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_06:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200119
X-Proofpoint-GUID: g3ZJwmGi9gtVX5FC6zh5_IY6PuM7J7Is
X-Proofpoint-ORIG-GUID: g3ZJwmGi9gtVX5FC6zh5_IY6PuM7J7Is
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: c3546cf5d1e50389a789290f8c21a555e3408aa8

Quick helper function to collapse duplicate code to initialize
transactions for attributes

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 33 +++++++++++++++++++++++----------
 libxfs/xfs_attr.h |  2 ++
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 6833b6e87f3d..bddadb143179 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -196,6 +196,28 @@ xfs_attr_calc_size(
 	return nblks;
 }
 
+/* Initialize transaction reservation for attr operations */
+void
+xfs_init_attr_trans(
+	struct xfs_da_args	*args,
+	struct xfs_trans_res	*tres,
+	unsigned int		*total)
+{
+	struct xfs_mount	*mp = args->dp->i_mount;
+
+	if (args->value) {
+		tres->tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+				 M_RES(mp)->tr_attrsetrt.tr_logres *
+				 args->total;
+		tres->tr_logcount = XFS_ATTRSET_LOG_COUNT;
+		tres->tr_logflags = XFS_TRANS_PERM_LOG_RES;
+		*total = args->total;
+	} else {
+		*tres = M_RES(mp)->tr_attrrm;
+		*total = XFS_ATTRRM_SPACE_RES(mp);
+	}
+}
+
 STATIC int
 xfs_attr_try_sf_addname(
 	struct xfs_inode	*dp,
@@ -695,20 +717,10 @@ xfs_attr_set(
 				return error;
 		}
 
-		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-				 M_RES(mp)->tr_attrsetrt.tr_logres *
-					args->total;
-		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
-		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-		total = args->total;
-
 		if (!local)
 			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
 	} else {
 		XFS_STATS_INC(mp, xs_attr_remove);
-
-		tres = M_RES(mp)->tr_attrrm;
-		total = XFS_ATTRRM_SPACE_RES(mp);
 		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
@@ -722,6 +734,7 @@ xfs_attr_set(
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
+	xfs_init_attr_trans(args, &tres, &total);
 	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
 		goto drop_incompat;
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 71271d203d01..c0fb4315a7d0 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -515,6 +515,8 @@ int xfs_attr_set_iter(struct xfs_attr_item *attr);
 int xfs_attr_remove_iter(struct xfs_attr_item *attr);
 bool xfs_attr_namecheck(const void *name, size_t length);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
+			 unsigned int *total);
 int xfs_attr_set_deferred(struct xfs_da_args *args);
 int xfs_attr_remove_deferred(struct xfs_da_args *args);
 
-- 
2.25.1

