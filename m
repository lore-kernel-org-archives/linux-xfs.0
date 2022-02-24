Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F0DC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbiBXNFV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbiBXNFU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:05:20 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9E537B5A1
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:50 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYSrI023283;
        Thu, 24 Feb 2022 13:04:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=e1NyiMlMXqapNybgWDuZjGBCOi1oKe/IshwTpp/fryA=;
 b=dzARgsN/vODD2xH9I6Wxh0y4cxzVuScuUDI7WP3hOyDmTKnYx3HTLobDfnF3a8QrfE2o
 LEEC1oOeqYpYpYHUrX6kGV1iEHogsHudSx4v3LCFHepnE22Sg0Fi/O6MVeD8WWpwSuc6
 1ioI/nMIcsaerZ9nUCAS1rNhExXw6plu7bBP34U4avUmvH75IcixlgWZ9Yn1fHpD2RVI
 ddpNiERzH1spG5R6N3D90E9XXfz1Nukr/InRvJkSpvT91okwDdIPmW/mrvklt5UzYrPa
 031tqDeIX0xCGmAcl1y6lDN0YzgvVE1mEQSJ5qPNoGkrulCQ+eQImSHkcyP4R/Z8iSKb QA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecxfaxmms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0YKE120552;
        Thu, 24 Feb 2022 13:04:46 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by aserp3020.oracle.com with ESMTP id 3eb483k8tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2bCvL6WAPZgp+h4AW45DCttAEE3TUoiwbkLsqo4lMdwt73xBkzyCu8bW7Nl0aYKPVi23kbQpEbi1FiWmN5RVOUfRd76NMLXw5ZvrLuPwp31t2aqwiNIB+aUi4XS0K0dcZksKale961oCJGM6cXXAsS/S1G6Yt8wGP4/cv+7OVJwniKInnaiaGRu0YBxTpZrREDXTiWjj3Kdk2AnvCKcydF4oMqH19mWHTWaz/wb+p52t6fGtR+4/eAvLW69wP1tY2rwkaiGLbHj5dT10JROjkM3/s+obZqKFt6DeUZAexXkD2UMWl/6zczER+A8UZ4E7qHsBypPC23xtryCDKFXvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e1NyiMlMXqapNybgWDuZjGBCOi1oKe/IshwTpp/fryA=;
 b=QaHtLMB6PeNi34NuUP9MbAgj/LbPY/5IZJlpypW2WtUCAWQkbFn/hnZCBeBhU58xFdoZJ9yNsRZeNfnfhue67H7N67YiN54vNrcHfTQDd18DY0iTnbsGmoFWQ4iaxKZNeSzz0wcfz4yotwi9Mm4REo5BHQPrLbdb0Kjw3zbHIJyfmJyuRGiScHVBRmJZb769gbPEeWW+xMYFKpSXaSIFx1NaEFI40N7fbLw2agyadG1Mgk5jZi/3m2kZaL6TN3M74FFZM3T/y2PsqhmC/xx8d9IKa13bDrhH51h6jHd7d+ChLp1EMX5f5+hNLjvYTeWBUzQymKXL3PksjHL7UxfFlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1NyiMlMXqapNybgWDuZjGBCOi1oKe/IshwTpp/fryA=;
 b=qj1z9K/8cOLLmeSH8oUYu3ZI6KAKTuXxZUsBNNLyJ54+6KHcMHf2YAp/il6QBrFq1Ablhg4s+3tLRWKubyvuXlTMcqnsQxSzUJwhOFWDnyWKX7eaX6hWqbD9+5DQ1Xy+cq8Lf4T7oMP+vlic9alEQ3e2SFMK6wYc9GeJjzXcW0Q=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SJ0PR10MB5405.namprd10.prod.outlook.com (2603:10b6:a03:3bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 13:04:43 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:04:43 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 19/19] xfsprogs: Define max extent length based on on-disk format definition
Date:   Thu, 24 Feb 2022 18:33:40 +0530
Message-Id: <20220224130340.1349556-20-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130340.1349556-1-chandan.babu@oracle.com>
References: <20220224130340.1349556-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bf376e0-a3d9-49e6-87d5-08d9f7963985
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5405:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5405227020033A565CC8A093F63D9@SJ0PR10MB5405.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B3xWKs7e84a2V5HEHMem1+Dcjw6go97qYj1AOl/KHl0BAhuiXbh/z+OR0AY0xdAYo7DuTy051BoMzDyWhSpfuDlNxURVB9wiBRuCApYHCrwW8gV5Y9OhZtSG4Efn1J6slhLc7mQxYI3qsDZjIagQQJVhODKg0jT9dUFQFxVK3dPjHIxGeG29p1SzXra7T4UPDLQVUw837yHYVSnDrQoyOwBf/isiZXWXgBP5a3OGdN/BNp9+doRslQ0fxmXx0ZbCogSyD5hplAe0vNRWOxlFBgfTLFwa+2qHdY6iEw6i2gIwHFKNbYxdO32Nq9PXZnmU8iXtBn6CDDoZA7SEMdg+I+TI1la5jdgageanaMIwzLWivn0FiUp4YEIfM4si2diNGkl7LHurTm/rEoiktYZp/so6JffA6UbLzZXj7tfdJeyLc/7eHz4WO/dYQ9bmCSJxx6bw/b6lVW6ASGUzSBgrj9InIzUqk5tr5DG1CWqD+WoHsLjyEd7jDwA+pFatuzZMgK+w5b9goszsXqDx5IyeoFDX8Vfgd8FHW+K6006hWpdsvE+1spd8Leii7WnqlnUMGGhgFuyPGsEwlC+lKLXHp6USUN0+sGgJ00IsfFhX4sCtdgjtxNEj6MAcKD1Gsjl3S7ysKAlTjdmkFu97DilciLQj6Zb2FUpl41e4mqU3e09q2GJVm/32ohei2PRmoVgvSZdbSQYJIaRtMFgfAIGNUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(36756003)(6916009)(38350700002)(2906002)(86362001)(508600001)(6486002)(316002)(52116002)(186003)(26005)(4326008)(66946007)(6506007)(8676002)(66556008)(66476007)(30864003)(6512007)(5660300002)(8936002)(1076003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+/WzuXtrFpUUjeaotFUzEYU2oSWmrTTyMgTjFDOGhUCgj8/GNFPVnzd1+o6P?=
 =?us-ascii?Q?mTSKpQVPX5h74QqX6RGzH00Rs7i0JYGttMdtQFvWtSIf4eQDD4jCHAG9lK0v?=
 =?us-ascii?Q?ltzLmI5qwhPowVVk4wOJCBEbf/A721jKk7Kxt53DoW/bZrRA0bd8/lzym1sk?=
 =?us-ascii?Q?60E/6zrDyPbdBR4/qj6N1QL1AuXejqgk+WzIJppzFElZCKYF7fRMjJR66StP?=
 =?us-ascii?Q?pnx6+wiSQDyeQT81jZp8CyKsquZM1ULe+EskonlG4p6SY501hv65hUOFwcQ6?=
 =?us-ascii?Q?9POY4dXSmSL5PyCvPj96+iNq5vSJBhXbDGLn2B3Ku2eUv2BpERyQ8edGNgN9?=
 =?us-ascii?Q?t3Cwxz5088IBI/bpY6jCFQykxcIsNfW5MUZ6mPXD6LSVjq0cwmGP3uspSlf/?=
 =?us-ascii?Q?pwr3i6gEjjO4f1USVabOE7ul5DvG7L6mwALKozcWgsUpFe7PSSCcaVpCJIMy?=
 =?us-ascii?Q?qS9VKq6OiQ2MOaHzTqgRDaEZBIaMSRLDC5pDTDRfsoT9tD6GQboM2AtPOluc?=
 =?us-ascii?Q?WDuDFLjjK0e6dMXy5DCtawdjQyMxNB48OUkTlUmbWk36z30CKvm1LsdfP+/i?=
 =?us-ascii?Q?3RW8fmNW4+GkdtkaUiw/CdB1b28mwtajJBTo35FEDCfENFCbNvEUTi0TNudF?=
 =?us-ascii?Q?dJQaTqiFpat53Vaf+IP9eo4NyfSvw9i7y3/qh4dt1RlcVAZEdBzPw57XSDd2?=
 =?us-ascii?Q?Rie3tGdjnkTAG0nJnzArgrivMxSdJpuYn1/IsLyLODKyzekzz9SrzUB8qCUS?=
 =?us-ascii?Q?VLwbjAjaFsFev7FG46xB3bqu5iwDiFnQg12hDsrHYMJuMihe3QQ0Y/cKZKXE?=
 =?us-ascii?Q?bj2+E2E0QqsKjC3c3gkrmB5wbWchQgyEUGC0QBRmINtQzins+9ZhIaZOJa3V?=
 =?us-ascii?Q?se15LU/A8k/0KjhVJSumDCZa9CpZNRsdkW9PAqEoyMbgI8AmP0DefFKhU+rX?=
 =?us-ascii?Q?ikSOnhFyEyPdfYOF7ePGtFDuaH7EouVV5FwTWxZGjLUaC2dNVdtKgf5i5B2w?=
 =?us-ascii?Q?UeI6JJxTMhtGTiHnGrl2v+TzYk5DUw7v1LVirnc/OOR3ig5l15DSxEPG8N8/?=
 =?us-ascii?Q?UCqIt7UOBw5aJXZbFSd0NyY4yNO69vgdSMbrhWUBEHSf9AXewwwvg40pktsQ?=
 =?us-ascii?Q?tkxwmpzRDBbZeoTvciCuX+1R3xf7P8iQn480myyFn5IcwTm0+CQx/EyUKTCK?=
 =?us-ascii?Q?2CPxkDKz3atf+4Z9QYAPwp2TpxP3wz/hstkONfJpoaTRJtUnPAObz8DYO17a?=
 =?us-ascii?Q?xNhCs+TFYtS1NsPz3O6ukkD98LqN+QD1NEKcNiWg42YMT9XDomiiCAR6jMg1?=
 =?us-ascii?Q?WHVClqlgIYtkHoDaNBHFx/uKt9lzb39jfL/F9LijqwK5j4P9CBqkenZmfSTy?=
 =?us-ascii?Q?ZBBvv63pE12Gg7LNwVUDzLBmodCz3yIRNn/yUmqbANEXNaX0RrYMmGcD/McI?=
 =?us-ascii?Q?qWdXH8EFY6uY3CrA5D4pzUz3wZy/BvrpdEmw7FCzo2bf+si98Ao+gKrudjdU?=
 =?us-ascii?Q?OysX5Sj32ptWPQgAVqF8p+jjEYQYVSgia7k40zFSxHECt6Qfp9uFs6BoegEa?=
 =?us-ascii?Q?BRBDSnB96ymbgd18sj+gRJLGfra2pTB6bW5pgx6FoPAoJF827ND+1YBjTaoX?=
 =?us-ascii?Q?/GYDZTsmbHxcZbXlMY6tycs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf376e0-a3d9-49e6-87d5-08d9f7963985
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:04:43.5250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b8YwDovo1I3VwiXgfiYMPCTHSjaT5w7mZECIlQb6iQ9rSD8QbAxCCpBERr6pBxzpeDHCRmxAYVIpGQtPg8opUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5405
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240078
X-Proofpoint-GUID: HkktkeqzyE-pNX9mvFcfJcCPrG4L-PBd
X-Proofpoint-ORIG-GUID: HkktkeqzyE-pNX9mvFcfJcCPrG4L-PBd
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The maximum extent length depends on maximum block count that can be stored in
a BMBT record. Hence this commit defines MAXEXTLEN based on
BMBT_BLOCKCOUNT_BITLEN.

While at it, the commit also renames MAXEXTLEN to XFS_MAX_BMBT_EXTLEN.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c           |  2 +-
 libxfs/xfs_bmap.c       | 51 +++++++++++++++++++++--------------------
 libxfs/xfs_format.h     |  5 ++--
 libxfs/xfs_inode_buf.c  |  4 ++--
 libxfs/xfs_trans_resv.c | 10 ++++----
 mkfs/xfs_mkfs.c         |  6 ++---
 repair/phase4.c         |  2 +-
 7 files changed, 41 insertions(+), 39 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 90b2979d..9ea388b9 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -20,7 +20,7 @@
 #include "field.h"
 #include "dir2.h"
 
-#define DEFAULT_MAX_EXT_SIZE	MAXEXTLEN
+#define DEFAULT_MAX_EXT_SIZE	XFS_MAX_BMBT_EXTLEN
 
 /* copy all metadata structures to/from a file */
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 8dd084b9..e3414657 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1443,7 +1443,7 @@ xfs_bmap_add_extent_delay_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -1461,13 +1461,13 @@ xfs_bmap_add_extent_delay_real(
 	    new_endoff == RIGHT.br_startoff &&
 	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
 	    new->br_state == RIGHT.br_state &&
-	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + RIGHT.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING)) !=
 		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING) ||
 	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-			<= MAXEXTLEN))
+			<= XFS_MAX_BMBT_EXTLEN))
 		state |= BMAP_RIGHT_CONTIG;
 
 	error = 0;
@@ -1991,7 +1991,7 @@ xfs_bmap_add_extent_unwritten_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -2009,13 +2009,13 @@ xfs_bmap_add_extent_unwritten_real(
 	    new_endoff == RIGHT.br_startoff &&
 	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
 	    new->br_state == RIGHT.br_state &&
-	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + RIGHT.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING)) !=
 		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING) ||
 	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-			<= MAXEXTLEN))
+			<= XFS_MAX_BMBT_EXTLEN))
 		state |= BMAP_RIGHT_CONTIG;
 
 	/*
@@ -2501,15 +2501,15 @@ xfs_bmap_add_extent_hole_delay(
 	 */
 	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
-	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
 	    new->br_startoff + new->br_blockcount == right.br_startoff &&
-	    new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     (left.br_blockcount + new->br_blockcount +
-	      right.br_blockcount <= MAXEXTLEN)))
+	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)))
 		state |= BMAP_RIGHT_CONTIG;
 
 	/*
@@ -2652,17 +2652,17 @@ xfs_bmap_add_extent_hole_real(
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
 	    left.br_startblock + left.br_blockcount == new->br_startblock &&
 	    left.br_state == new->br_state &&
-	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && !(state & BMAP_RIGHT_DELAY) &&
 	    new->br_startoff + new->br_blockcount == right.br_startoff &&
 	    new->br_startblock + new->br_blockcount == right.br_startblock &&
 	    new->br_state == right.br_state &&
-	    new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     left.br_blockcount + new->br_blockcount +
-	     right.br_blockcount <= MAXEXTLEN))
+	     right.br_blockcount <= XFS_MAX_BMBT_EXTLEN))
 		state |= BMAP_RIGHT_CONTIG;
 
 	error = 0;
@@ -2897,15 +2897,15 @@ xfs_bmap_extsize_align(
 
 	/*
 	 * For large extent hint sizes, the aligned extent might be larger than
-	 * MAXEXTLEN. In that case, reduce the size by an extsz so that it pulls
-	 * the length back under MAXEXTLEN. The outer allocation loops handle
+	 * XFS_MAX_BMBT_EXTLEN. In that case, reduce the size by an extsz so that it pulls
+	 * the length back under XFS_MAX_BMBT_EXTLEN. The outer allocation loops handle
 	 * short allocation just fine, so it is safe to do this. We only want to
 	 * do it when we are forced to, though, because it means more allocation
 	 * operations are required.
 	 */
-	while (align_alen > MAXEXTLEN)
+	while (align_alen > XFS_MAX_BMBT_EXTLEN)
 		align_alen -= extsz;
-	ASSERT(align_alen <= MAXEXTLEN);
+	ASSERT(align_alen <= XFS_MAX_BMBT_EXTLEN);
 
 	/*
 	 * If the previous block overlaps with this proposed allocation
@@ -2995,9 +2995,9 @@ xfs_bmap_extsize_align(
 			return -EINVAL;
 	} else {
 		ASSERT(orig_off >= align_off);
-		/* see MAXEXTLEN handling above */
+		/* see XFS_MAX_BMBT_EXTLEN handling above */
 		ASSERT(orig_end <= align_off + align_alen ||
-		       align_alen + extsz > MAXEXTLEN);
+		       align_alen + extsz > XFS_MAX_BMBT_EXTLEN);
 	}
 
 #ifdef DEBUG
@@ -3962,7 +3962,7 @@ xfs_bmapi_reserve_delalloc(
 	 * Cap the alloc length. Keep track of prealloc so we know whether to
 	 * tag the inode before we return.
 	 */
-	alen = XFS_FILBLKS_MIN(len + prealloc, MAXEXTLEN);
+	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_BMBT_EXTLEN);
 	if (!eof)
 		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
 	if (prealloc && alen >= len)
@@ -4095,7 +4095,7 @@ xfs_bmapi_allocate(
 		if (!xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev))
 			bma->prev.br_startoff = NULLFILEOFF;
 	} else {
-		bma->length = XFS_FILBLKS_MIN(bma->length, MAXEXTLEN);
+		bma->length = XFS_FILBLKS_MIN(bma->length, XFS_MAX_BMBT_EXTLEN);
 		if (!bma->eof)
 			bma->length = XFS_FILBLKS_MIN(bma->length,
 					bma->got.br_startoff - bma->offset);
@@ -4415,8 +4415,8 @@ xfs_bmapi_write(
 			 * xfs_extlen_t and therefore 32 bits. Hence we have to
 			 * check for 32-bit overflows and handle them here.
 			 */
-			if (len > (xfs_filblks_t)MAXEXTLEN)
-				bma.length = MAXEXTLEN;
+			if (len > (xfs_filblks_t)XFS_MAX_BMBT_EXTLEN)
+				bma.length = XFS_MAX_BMBT_EXTLEN;
 			else
 				bma.length = len;
 
@@ -4551,7 +4551,8 @@ xfs_bmapi_convert_delalloc(
 	bma.ip = ip;
 	bma.wasdel = true;
 	bma.offset = bma.got.br_startoff;
-	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
+	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount,
+			XFS_MAX_BMBT_EXTLEN);
 	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
 
 	/*
@@ -4632,7 +4633,7 @@ xfs_bmapi_remap(
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(len > 0);
-	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
+	ASSERT(len <= (xfs_filblks_t)XFS_MAX_BMBT_EXTLEN);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC |
 			   XFS_BMAPI_NORMAP)));
@@ -5632,7 +5633,7 @@ xfs_bmse_can_merge(
 	if ((left->br_startoff + left->br_blockcount != startoff) ||
 	    (left->br_startblock + left->br_blockcount != got->br_startblock) ||
 	    (left->br_state != got->br_state) ||
-	    (left->br_blockcount + got->br_blockcount > MAXEXTLEN))
+	    (left->br_blockcount + got->br_blockcount > XFS_MAX_BMBT_EXTLEN))
 		return false;
 
 	return true;
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 76bd5181..b2228558 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -897,7 +897,7 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
 /*
- * Max values for extlen, extnum, aextnum.
+ * Max values for ondisk inode's extent counters.
  *
  * The newly introduced data fork extent counter is a 64-bit field. However, the
  * maximum number of extents in a file is limited to 2^54 extents (assuming one
@@ -909,7 +909,6 @@ enum xfs_dinode_fmt {
  * Rounding up 47 to the nearest multiple of bits-per-byte results in 48. Hence
  * 2^48 was chosen as the maximum data fork extent count.
  */
-#define	MAXEXTLEN			((xfs_extlen_t)((1ULL << 21) - 1)) /* 21 bits */
 #define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)((1ULL << 48) - 1)) /* Unsigned 48-bits */
 #define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_extnum_t)((1ULL << 32) - 1)) /* Unsigned 32-bits */
 #define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)((1ULL << 31) - 1)) /* Signed 32-bits */
@@ -1646,6 +1645,8 @@ typedef struct xfs_bmdr_block {
 #define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
 #define BMBT_BLOCKCOUNT_MASK	((1ULL << BMBT_BLOCKCOUNT_BITLEN) - 1)
 
+#define XFS_MAX_BMBT_EXTLEN	((xfs_extlen_t)(BMBT_BLOCKCOUNT_MASK))
+
 /*
  * bmbt records have a file offset (block) field that is 54 bits wide, so this
  * is the largest xfs_fileoff_t that we ever expect to see.
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index caf42f66..dc1a9922 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -682,7 +682,7 @@ xfs_inode_validate_extsize(
 	if (extsize_bytes % blocksize_bytes)
 		return __this_address;
 
-	if (extsize > MAXEXTLEN)
+	if (extsize > XFS_MAX_BMBT_EXTLEN)
 		return __this_address;
 
 	if (!rt_flag && extsize > mp->m_sb.sb_agblocks / 2)
@@ -739,7 +739,7 @@ xfs_inode_validate_cowextsize(
 	if (cowextsize_bytes % mp->m_sb.sb_blocksize)
 		return __this_address;
 
-	if (cowextsize > MAXEXTLEN)
+	if (cowextsize > XFS_MAX_BMBT_EXTLEN)
 		return __this_address;
 
 	if (cowextsize > mp->m_sb.sb_agblocks / 2)
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 61a0a1ac..4759de1b 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -198,8 +198,8 @@ xfs_calc_inode_chunk_res(
 /*
  * Per-extent log reservation for the btree changes involved in freeing or
  * allocating a realtime extent.  We have to be able to log as many rtbitmap
- * blocks as needed to mark inuse MAXEXTLEN blocks' worth of realtime extents,
- * as well as the realtime summary block.
+ * blocks as needed to mark inuse XFS_MAX_BMBT_EXTLEN blocks' worth of realtime
+ * extents, as well as the realtime summary block.
  */
 static unsigned int
 xfs_rtalloc_log_count(
@@ -209,7 +209,7 @@ xfs_rtalloc_log_count(
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
 	unsigned int		rtbmp_bytes;
 
-	rtbmp_bytes = (MAXEXTLEN / mp->m_sb.sb_rextsize) / NBBY;
+	rtbmp_bytes = (XFS_MAX_BMBT_EXTLEN / mp->m_sb.sb_rextsize) / NBBY;
 	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
 }
 
@@ -246,7 +246,7 @@ xfs_rtalloc_log_count(
  *    the inode's bmap btree: max depth * block size
  *    the agfs of the ags from which the extents are allocated: 2 * sector
  *    the superblock free block counter: sector size
- *    the realtime bitmap: ((MAXEXTLEN / rtextsize) / NBBY) bytes
+ *    the realtime bitmap: ((XFS_MAX_BMBT_EXTLEN / rtextsize) / NBBY) bytes
  *    the realtime summary: 1 block
  *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
  * And the bmap_finish transaction can free bmap blocks in a join (t3):
@@ -298,7 +298,7 @@ xfs_calc_write_reservation(
  *    the agf for each of the ags: 2 * sector size
  *    the agfl for each of the ags: 2 * sector size
  *    the super block to reflect the freed blocks: sector size
- *    the realtime bitmap: 2 exts * ((MAXEXTLEN / rtextsize) / NBBY) bytes
+ *    the realtime bitmap: 2 exts * ((XFS_MAX_BMBT_EXTLEN / rtextsize) / NBBY) bytes
  *    the realtime summary: 2 exts * 1 block
  *    worst case split in allocation btrees per extent assuming 2 extents:
  *		2 exts * 2 trees * (2 * max depth - 1) * block size
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 89d38a04..8ace6200 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2418,7 +2418,7 @@ validate_extsize_hint(
 		fprintf(stderr,
 _("illegal extent size hint %lld, must be less than %u.\n"),
 				(long long)cli->fsx.fsx_extsize,
-				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2));
+				min(XFS_MAX_BMBT_EXTLEN, mp->m_sb.sb_agblocks / 2));
 		usage();
 	}
 
@@ -2441,7 +2441,7 @@ _("illegal extent size hint %lld, must be less than %u.\n"),
 		fprintf(stderr,
 _("illegal extent size hint %lld, must be less than %u and a multiple of %u.\n"),
 				(long long)cli->fsx.fsx_extsize,
-				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2),
+				min(XFS_MAX_BMBT_EXTLEN, mp->m_sb.sb_agblocks / 2),
 				mp->m_sb.sb_rextsize);
 		usage();
 	}
@@ -2470,7 +2470,7 @@ validate_cowextsize_hint(
 		fprintf(stderr,
 _("illegal CoW extent size hint %lld, must be less than %u.\n"),
 				(long long)cli->fsx.fsx_cowextsize,
-				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2));
+				min(XFS_MAX_BMBT_EXTLEN, mp->m_sb.sb_agblocks / 2));
 		usage();
 	}
 }
diff --git a/repair/phase4.c b/repair/phase4.c
index 2260f6a3..292f55b7 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -372,7 +372,7 @@ phase4(xfs_mount_t *mp)
 			if (rt_start == 0)  {
 				rt_start = bno;
 				rt_len = 1;
-			} else if (rt_len == MAXEXTLEN)  {
+			} else if (rt_len == XFS_MAX_BMBT_EXTLEN)  {
 				/*
 				 * large extent case
 				 */
-- 
2.30.2

