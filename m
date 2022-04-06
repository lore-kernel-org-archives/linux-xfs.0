Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7891C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 09:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377648AbiDFJjr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585689AbiDFJgo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 05:36:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D52917F3D1
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 23:20:32 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2365v2xI024458;
        Wed, 6 Apr 2022 06:20:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=NEgwpDbYHwP042muSjauZUSY48vWBtV4slfQ2mBNbjg=;
 b=GrZnxpw4nMM/oNS6/d7lJbewb7HNRCQzv4KfKgmW26SCZWphey2zlpM1Z0trTWlH9dgS
 alE8zMq5qfHpPr/ZLsaNeNGRijFv5RYc7cfOBJyPTqhlWVj29eG4LiB5oevJ+nE4NBXN
 5Rvo6AyzKzUMP8bRXrx2iotWMgejKNqu0UZ91YC66Ue/8TsRNo0JKyLVlZWHlyE7cT5v
 obBxGyw9EnTfxU69fFVyoj8bPHGylS5CFFhICEfBwfX+n4/Mz6/5KBJrLHuMhIsyLad7
 PUsAhI5Ycuw7MDkk5929FR8FabEuj3/So5w6KRUJGhdFR4w0FsAuhnhIqnILgeUXivTE +g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1t7yfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:27 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2366Asj0037243;
        Wed, 6 Apr 2022 06:20:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx47t86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDvHmO3H1n9Arm6xbVHVst+9aGcbfiZ0bBQ+KeIGwGFKYk9jnwF1m9NbZKVggOAvyVLXmbLhALNGzMvftnJKzx0tmsIDSygPiY4BJmDilj2nQxO3ixVyoOR8Uh9tWDjCWKBlMaTJP5ow2cy1JGIf6ySsjbB6/EYu1Lfi4Y2Osn8ht5BUHk0vadQgPzV+u/dG01BHnzIN6cikPIXD0URuuUMqwtSyRcl+P7CetUpaXFJxhia2v/CZkvLyXjWONIqUaXpEU9w4Kfn3PENKdZ2wttRmHC2VjPJ5G3N6Sl2V0R82svGkQZ09yvQryPes0GJfTcrFRh2iMx0haDyH7Ye4sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NEgwpDbYHwP042muSjauZUSY48vWBtV4slfQ2mBNbjg=;
 b=FbQp0oHYs3ELjk89/0iR/0GmAII4WmhgJ035AEAjIv6Dnb7wSa9iBbNAbxZN4TvZJ5HAtTcfuAOyDaZZ+bzR0qJkX1z1kmtkb6s8WWPhfdqy2scXo8KixYTAFohqVcir4WITxU5EVF6Qz5brc+R5TfAmYfUZEsHz216t4aUmkyUZMVlnz3fiuFAk7BpBOBlrxwlzswZTjsXF7H0j0mhbE0JKNm/0OKAOC8OS5m9U40R2BiX7ic7Nsrx2V8BjLjC7e8fLQ5oYcPD9nTRWUwclT5kC+lKbq76sExJQwriGiNrtDic8ZaWhTeUaAqnjisstYFxJAKc4ncxvc0lDE+bm9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEgwpDbYHwP042muSjauZUSY48vWBtV4slfQ2mBNbjg=;
 b=IH9U4W89DBAvP21/jzT6luumxVu8WjwmuWHlWHIeHoyOOlBilFgy/zNgtStM1WKJudR2KjJpxJU6tsCcx3GY5cKo0Cs97H8wOrGnRJk4eux1Aj6iMHy41anNmpK2WlLtB+8aTvVzvKcBr5FmCUgsaC9mEMozDYOw+hsMKv4gh6E=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 06:20:23 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 06:20:23 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V9 09/19] xfs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
Date:   Wed,  6 Apr 2022 11:48:53 +0530
Message-Id: <20220406061904.595597-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406061904.595597-1-chandan.babu@oracle.com>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0047.jpnprd01.prod.outlook.com
 (2603:1096:405:1::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad07ff7c-dc4c-486b-371c-08da17958895
X-MS-TrafficTypeDiagnostic: PH0PR10MB5564:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB55641B93765F89DE16116B56F6E79@PH0PR10MB5564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 02NfUa3pyvZgA99RrTzl5LKZkeO7QVRBZNNBSmTRN5HnGUaJSJMK0A43QJ3buLwx9P2MzcgHukRZa0O7cI2bYtD8H94ca1G/yTtT84VGyG+5T2Far0taQAuUgLnpRvg11W5A2+PfJRbgb4p4ZG2igXGWIFykStWIP54pjvInWQ/dwFY2FO90cj7sf5T/AFy7AiRfqPAdm1eKOnCO7xJhg0IBKUdlPSKQhzZjgQcvYitvnRBQ5UYY+lo4uXzYij6C5SNmggGIWNSijitaV2J1sGVHOUQ8HdMyXG5MefCW2kz1uflbWMmm2Wc1hS6Mhvt7DwJsEFviEfqtsIR/L4kInS2VJ+LZTb2J0ojNvN7Vf85jcQVlz5DcDNRldHhr0N69lyQtCEk+Bh9w+Qt4bDa14bYdF2CopjY/4z0CI4kUkixlr+B4cKyklU4EHsjQC6CeOv0TWgSJ0jG4nkc7nNhAp12pA9FetrYk+1Kl2mNzVUuqQQd0IkBaPfHyjBQ78hdZkY7ZFqfTjX/sNXmiViRNxm8Gy4BIa/w05oPD40F6ON/kYr1jjdyS5mhUdpugD3KZuKDwIP3HiwvUiMVuS3Na05pnkwQDR4Ey7VnyQW2lybth7wkaoEMMxqNW08rcm+OEHrfPhTN+j2ttnU8lQRz/qbKW7QqES4vlaH5waNGkn3S1WhK7dcoK6m/lsI+LpVQbQOSPBiI75Nl7dNQ5tkl9Vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66476007)(66946007)(6506007)(66556008)(52116002)(6512007)(6486002)(54906003)(6916009)(4326008)(8676002)(6666004)(316002)(5660300002)(1076003)(8936002)(2616005)(83380400001)(86362001)(38350700002)(38100700002)(2906002)(26005)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YOHEZtL0Cd2GdZNRJ6BDWXH8VgJmquB6XG/Nu7A3YlWLxf5T+BpKaSTC6/NE?=
 =?us-ascii?Q?zI0zeXRAgTXcFgihNVW0Umcjpplq3BlTNIPvhWRBV++BV1dZNCyl6DaFCg8E?=
 =?us-ascii?Q?HZV84VSGLbgmvh+Acjean0fEHVEmBvT/x8sC7QJspCbeZLoqt8SJBQJWLmQZ?=
 =?us-ascii?Q?jwrmOh3+HnIgineNOdaWtmliN75aH46rqLKpKdaZ6K/R0JbIOczlbXeuijMN?=
 =?us-ascii?Q?hCQdeTpryaexfwDmNslTkYEKd0XQsvwdn4KkjUDLiRZRZnYm/ZTWe64gJd5N?=
 =?us-ascii?Q?/EFasxwGRBQB5H5bbUFtwLPbe5/NxJm+noNAKy4tWYb+0LHRcdELijB/4RCx?=
 =?us-ascii?Q?mNUDgT0Ea+HpaemnPE+gSD9GkbX750E2obl90ic7xeqHZn0Xp7OErDvnIshu?=
 =?us-ascii?Q?vWLOlYjhXJJ60KFh+UhOYbZijOk3Dx7Y/0aP5KLnFrwVnUYXFg5w6QQ4ZaDo?=
 =?us-ascii?Q?Rrluo/XQzlFQWsf5b4vkOMVLNdYnD6Vo7CE2QSsRjY0lxDwIX+vX5oIfnkKF?=
 =?us-ascii?Q?FIqqtmhjwJ2VY0NPwiCVhsoi+3ZZMfXQ/WHGY4JC4sIgbSbaEvDofpGK5fKe?=
 =?us-ascii?Q?8zo8s0W9ylEHCUduPYrS7DN6ZUjhX4D/usQO0n8+bD3RA5BBI0vfwJf6Gyqq?=
 =?us-ascii?Q?UVgvJ2ka4IRTbAQhb8q0iG2ms6T0Igs3Vn5M/xK/n8MPAGcrJhdTWWiyJ080?=
 =?us-ascii?Q?c1FPJZYcBHTqG8/n5cMRUbVSkQ9v51JDcqBGMtbdvp41l9cmgSpZh7bKQoLo?=
 =?us-ascii?Q?wzNJroVeg0IIGbSJxK9AGoZLIMEpJo8ZdqvTI9T3v2AdetBnQnqN24hpBBSW?=
 =?us-ascii?Q?IqBz+xDcXeA7oFmJrbByZTflUuVMjOfJeHI92APP80TooAkaScArPufMfi0h?=
 =?us-ascii?Q?C/Dt0xSvBaKmd0eiVHmrJv1WByChOd6+53JMcdW2FFrDYepdsLeSxiGCBeBz?=
 =?us-ascii?Q?Ekt/n9CIM2RGtQJ3mtCMSqg9T/DmxSjb984sl8VIQ8yPgfzrHBDZBNlMLhtf?=
 =?us-ascii?Q?OYJKFRxVMWJMfg+zgyuW49uJBAP66fEJXyXbBobGvsbBfVRR2eJmgS6FdYKR?=
 =?us-ascii?Q?YzF4sULI3rXUQfWEX/AKx4w8zTMVAfbCJv/Gh4MQXI71aWH3aXI8tor3jd/n?=
 =?us-ascii?Q?iTmUwU08BH54GtHfr9m8bgW+e71r6Im3cIn8UfF4ngGUIoG6XP0+isii4fEe?=
 =?us-ascii?Q?995e5uGq0sqjEwLG7sDklVqw5eLBwNoK1PoAxVTWljSQIZAjuZNlJetPcGWl?=
 =?us-ascii?Q?CCMGnxaIXCMzu08VfLwRmi8TDCHPkdhtj3u/coXa9G8ChCkvlzcO10weWmbT?=
 =?us-ascii?Q?WH4yjlvCN7uiSbVMs4eKMxYH4tgTUEQzvGTZzAPb/Nbg8N+oORmSA62osTKa?=
 =?us-ascii?Q?tHCcxRgqb+d1GJAYO9pRWFQbo861bvD8ZbKp/1KDUtts/Phs5ILfh5CBikCS?=
 =?us-ascii?Q?s3twqHNpIXeH17oEptyyMMVTguid/cP10+5yzpWTZQpr+bHaR7cud0h2u0GC?=
 =?us-ascii?Q?k0VnmPvZFcVBJwQ5Y3CUvwyu/nLwm5Xjheme0nJ69xxqoIP4cGPEsJPmSOvL?=
 =?us-ascii?Q?TqLMM4RQK9c1bgboh07x+MxAHMTd+EEk+8R3vGxFqWhBJ9Axu6AgakJvc5FK?=
 =?us-ascii?Q?k7UiqpyrIowPfLo586Ug5Z5qgmuMgXReV/J9saUhoJCNcopiSac28/T3lCRb?=
 =?us-ascii?Q?3zUHddBk0tUE2TQXapse0NSootJQqyPfi/zznp4WmnSTBO8hiUwE/sUINElb?=
 =?us-ascii?Q?s358nOWbceQ4BWgCzwDtOxSWiktH2IQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad07ff7c-dc4c-486b-371c-08da17958895
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 06:20:23.6018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CquNnO9dW1qMV0WIDuy5hMIExOw17i/r2+K9SEXjCngU4TqLekJlhQB/0x0zs5XzXNHPl3HR2ttQYRyxS6Tv5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_02:2022-04-04,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204060027
X-Proofpoint-ORIG-GUID: UaophHbO-pHVrryAxgJt2cEpDEDleZ6V
X-Proofpoint-GUID: UaophHbO-pHVrryAxgJt2cEpDEDleZ6V
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_FSOP_GEOM_FLAGS_NREXT64 indicates that the current filesystem instance
supports 64-bit per-inode extent counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h | 1 +
 fs/xfs/libxfs/xfs_sb.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 505533c43a92..1f7238db35cc 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -236,6 +236,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
+#define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index bd632389ae92..e292a1914a5b 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1138,6 +1138,8 @@ xfs_fs_geometry(
 	} else {
 		geo->logsectsize = BBSIZE;
 	}
+	if (xfs_has_large_extent_counts(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.30.2

