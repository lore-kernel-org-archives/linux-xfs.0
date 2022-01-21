Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C81C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348151AbiAUFWR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:22:17 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42518 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348559AbiAUFVb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:21:31 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04vTe017314;
        Fri, 21 Jan 2022 05:21:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=8koXrr2EvzcUZvFzFJ8e6Vu242SQuNGbxecrJCj6H00=;
 b=MDM7C8eg0/D7Az8hKnptmE6Qq6GN8cOnY0PYwTVGCnqiTuAU9irReuF8lgoN4oKyE3UW
 fGBgQle8POWfc65hPJgzmnSAjdPeQiXJfZWeznHjk/O03GFj0DcPt7HukCRYnVqW+xVD
 yjMfOJfeIm4Lrwd0qlF+w/hYbqEnt4LWiRNy5eAdHmGqigaU2oT1QE3WrRuw0081RE7t
 YD11tAEE5T5sPjBMSH44Uhfh5j5Qp79pJfxsdrzG7ODYPxS2bHIqGiSaomusSYQqy/tm
 cVpsJrJ6de2ghvSdnFjfUJ5x2w9+LpwCv1uhOWNnka8Ph4CdB36Oy3L60bb9y/j49KI7 Cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhydrc8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5KgeA094496;
        Fri, 21 Jan 2022 05:21:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by userp3030.oracle.com with ESMTP id 3dqj0vbmhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jqwe3keO2o25Lpd6Aq0VMI8gj4L4JTddIuHtCQu9FMLYpVMl/AYdNLCwiAq9/U2XyO7D+HPE2DV1koW5CYg6zaOYRIizqQrgcydfjoCkEGVcWqEJoM0Hvt3BiFQLcBsdyGjRoZb1PHYjPz97vLvQVlY4pZEXrcYOVd+ArQCaUHMrgb/f2qOBcN3TtffFtlrS5r0Ef+D1nO7kY2bggNBfF5kgmaqLM2LSt+4m+Oktc0JN+MRRkC+4WDEJAQTOw8tS2URyPP3H15jt1fJeSsxEONc3q8f2An7qDeIDSegZ3MMIzKYrfBmOgp2tAWlmXWJIjr1aLAJi3Dg0hK0WNS8sSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8koXrr2EvzcUZvFzFJ8e6Vu242SQuNGbxecrJCj6H00=;
 b=LHF1cPLS12S35mdouVr0WthRZOKQRBxRz8mM/hODicW7A+XvZyDU7l2nlnmJoei+eKeru6F7lN4s7NBCARW19A+T1CS2S0dQJQQ64xZ14ms+kkfPLd4o6iriiwTqc4gWfsAICcMsu7xnMG8gcZaUk8kPbotKV5OOI1uZiXhq619baevRsvzwRSmpOI2bIygH3faVdJLkn5it0/Fa4t6nxK3PFLXzvxg1JFGwLpo/q8HLejvyZbUJM8TX+Ym/jdqqZwtRbLuE1mJLwsVo85KLB+C+Esx70erZNbwheIQgJyPxu2gHgJX6ZKSFbT65YHESpGrrxlng7cklaGAkLnIjOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8koXrr2EvzcUZvFzFJ8e6Vu242SQuNGbxecrJCj6H00=;
 b=SndVafFqAtTC1Ux/t3U8pTH+NDV1QrhB18jhYtTWFRfM7LtzcH8RkF5Z1moNHT+DS0l9uBOQzA5pcFA5pLPdNXxYSi0zcvipVkAzzDBQpqQFxLGchxr6EZYI4/0pEsHCRhK9PECtRvLVnSvn0J4j+s030x72j0YDrHsEh+CRR+0=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by BYAPR10MB3685.namprd10.prod.outlook.com (2603:10b6:a03:124::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Fri, 21 Jan
 2022 05:21:24 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:21:24 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 20/20] xfsprogs: Define max extent length based on on-disk format definition
Date:   Fri, 21 Jan 2022 10:50:19 +0530
Message-Id: <20220121052019.224605-21-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121052019.224605-1-chandan.babu@oracle.com>
References: <20220121052019.224605-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:54::13) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fdac47c-2e6b-4188-6dea-08d9dc9ddd85
X-MS-TrafficTypeDiagnostic: BYAPR10MB3685:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3685ABDC95395990BF961192F65B9@BYAPR10MB3685.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: waoTUWQZALT9Guo0B4w7MaZ7BlKHZkWV6L4O8AaSqI7sWkY3iFEhOXZi7eI9JKMJFs+7d38gnXHYZSo/Dd/4ekhRUVEwA7yG9ZktmJ0SV1WaXdFKshxpGen5Alo4smqGUk7oZ7nAycqvkedWtf3V/htUsLQn+x9/6buwcKyyBok5p5pjum4mHpU1CBROeH4ubdh+1dODFS9sREyqW7+H56GQITD1BOC/YMwhS8LCvSBU8M0IsxPZXvbav9EHRJttGuRObrhK0kgrT5tYh5q0T/NoZGA7DDQf2QSkRf2vyjyImhu/VTmGZ+FsXgxTFTSoP9h3DqK+qliJh1wHXpI139poPoGZiVzPtYkzLJyO7ob1vMn87/294LHt/JFRbiXezS6STtzQVM41njylU9AP7xyPRFkchqVkN8BG75ElqpwbEd0CiZyLrmOY/WDOlVGX3FFnRUmf2LIAmFPNr/fFDvsCpcMDh3smymBQZvtnIadNxpWGJckWipUTWoejwthRWuZjQWekAmKwbtuTYs9avZjZXsVIceg8IHSPsDtN8VZnkBm9bFqkma781OUoXod1PWZkRaM+fIeAl6XMKLXe39kw2PzIBKnQPZB/npzqE2zUrVFkCz5jmtH927SZI2Z194pNKRnrtdx+8yOe+nqVjIgNqbu8qVecV2w+5XHhnT/0g4OhR+KeleSCctJv4i2bsVNI845pmzqlBTdleAgsjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(186003)(38100700002)(26005)(38350700002)(6512007)(1076003)(36756003)(6506007)(8936002)(86362001)(4326008)(2906002)(6666004)(52116002)(83380400001)(508600001)(5660300002)(2616005)(316002)(66556008)(6486002)(66476007)(66946007)(8676002)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/DZ0CwML3/+0wsPm61uyNgQKNdVUxo6uRHRqH5AD1TkO8BhZbFcDIHk9kv47?=
 =?us-ascii?Q?+88kxEGyzkKlnmkfuPoKqPRiTi48im3/GSNrL82U/Za3+JGhD+Zd5kqYDIV7?=
 =?us-ascii?Q?c05FgWd0RoQEnLhAmqarsKjrlPqUIbb4OPwJyoGNe/H7yYmKNgybz5R3r4UF?=
 =?us-ascii?Q?sbFUFOusN1ODhXoi3QkOCoHva4r6wCC2vxvg/ADFINhv/NJNHiSOXV/n1pGp?=
 =?us-ascii?Q?tflETSBZnwBMgOAmLY1zqcd2FQOFTg1xN96OWpbi7/gWrjMzczrGMrx/EglW?=
 =?us-ascii?Q?buDdOWTX8Zw1Yvw5ArtAL7oTt21GFVU4pVBHoZQNxofakt8vMe+dfb8Bct3i?=
 =?us-ascii?Q?YK0WgRfTKT4ZscMbWZxMvZzMoQ/mi3lgol4sF5AtPdhfyAxSl6hcyVhccy2Q?=
 =?us-ascii?Q?SVcvUiZvc/Wl7PVe9v8R4iNz5e83rhmczXl9sjWD6PgRnF00FSRikHtCwHbL?=
 =?us-ascii?Q?IbT+0sL8YMKwnLFkExaELcOoP7VwDoRgV3Vtzj4r6o5/Dp/LyVid0WBU9CRK?=
 =?us-ascii?Q?UqgkKUXYjV2ryAVaLjVlP4Jz1t7vCGzSGPn4N09mAMf4STS6mXxqHUqlU2DS?=
 =?us-ascii?Q?iGLXmOXs07qhfI7TnH5VbsHXW7jObnfblvbQDblFho7f3lqZekaJiqaJgxoN?=
 =?us-ascii?Q?LYu+MxfbMfs5SvNx9c4hGgNqLPzvZMKyYCevLeke104mGtPmsMv5WmXkgotC?=
 =?us-ascii?Q?ccFDFByfudeYV0SU7rgE/VOeRSsUKLDLUM+uRKNEoZ2LoU0E5iam64HyuVSl?=
 =?us-ascii?Q?aR+K48kD7xy2hDkSWw38lAlFYrnJith7C2X52WoprcztcrrXr6IbGeGR7DJ1?=
 =?us-ascii?Q?TcY8hKzVI3vYpc4ILJoajMvXNCDF/FLRO17lUnfqCWbmUnlbaDEYrWMKgPQ0?=
 =?us-ascii?Q?Zu7N5ugwYhAdF93efn87byQB6Hi9bPEqfaICh3HZ4b1oUOJPCeDIq4xaNTuN?=
 =?us-ascii?Q?0CY3/vYs0TTuru07ZS4IiViocmYrGMWr977T6ZAhv+pKXpVNgr3zGbfxMxAV?=
 =?us-ascii?Q?Rd4bjBIY1qEyg5CCZSjup1typY88F7GGA7pCkcAgv4wXAKhPDgeKxkH+p99/?=
 =?us-ascii?Q?pJb904pwpiLeqOJ2U9ZENoTUZdyAsfkznSvk6MB9UU80T8qlehXMfShxTQUX?=
 =?us-ascii?Q?kBZmXkr6VWc+6H4YpPzFFQkdAUFdi2Fby2HwTEqgXURjK9w+eHJEDLzngB1n?=
 =?us-ascii?Q?y22NU8X2z/kXvrLiwXWhJds3Oy4tdZbxUzfw7d0rooaMpnLRfqdz97I2BCxk?=
 =?us-ascii?Q?5tD63hfrv0Mwms1qs/qJ/ZLee6Ce1Ppfbmk9+OogZjg1dq+rGEgrW3ZetPoH?=
 =?us-ascii?Q?y7fpPmmZ6SpmAm7W8zjeY5KLSYK8CaUBej1AmXtZW7nm5z2Y6E9HoVojokdm?=
 =?us-ascii?Q?PPO6jtGMzrbN6E2B1WFEd5zeLVHnOrNqWeqx6PjLm/Xk0duM4KadTAiUdZLz?=
 =?us-ascii?Q?rQjk93XgvK5kYnZrGY9WXn1Kq6coQBqs660PUyx/y2qeKm4zDfuXrj3DGLAP?=
 =?us-ascii?Q?Nv3iiyye7Gj67fS5DWnkjFKefmDaJI3zmiCILXENjmUqdIBk62wiRK2T3D1D?=
 =?us-ascii?Q?g4WmCaQJ12U77LXhJJR8ytvdUNguQwwAbTqiZWI7pVSIdCtgF1KEG3FZcFa+?=
 =?us-ascii?Q?kT64RDUHiaJ1/TMuE6PAacw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fdac47c-2e6b-4188-6dea-08d9dc9ddd85
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:21:23.9588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YJAZ8csjEWdGcEiUMbKeLm82sNWw7ndK+5zk4JnCGjTygd5Th+Gk5QZ3qykgP9KuSe4i2Ui8n8EWkszoO4n+Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3685
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210038
X-Proofpoint-GUID: LQa_zjyQUCoUaddZTTfHpeC__qkI0TOm
X-Proofpoint-ORIG-GUID: LQa_zjyQUCoUaddZTTfHpeC__qkI0TOm
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
index b7521c1d..fa11e4c1 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -886,7 +886,7 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
 /*
- * Max values for extlen, extnum, aextnum.
+ * Max values for ondisk inode's extent counters.
  *
  * The newly introduced data fork extent counter is a 64-bit field. However, the
  * maximum number of extents in a file is limited to 2^54 extents (assuming one
@@ -898,7 +898,6 @@ enum xfs_dinode_fmt {
  * Rounding up 47 to the nearest multiple of bits-per-byte results in 48. Hence
  * 2^48 was chosen as the maximum data fork extent count.
  */
-#define	MAXEXTLEN			((xfs_extlen_t)((1ULL << 21) - 1)) /* 21 bits */
 #define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)((1ULL << 48) - 1)) /* Unsigned 48-bits */
 #define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_extnum_t)((1ULL << 32) - 1)) /* Unsigned 32-bits */
 #define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)((1ULL << 31) - 1)) /* Signed 32-bits */
@@ -1635,6 +1634,8 @@ typedef struct xfs_bmdr_block {
 #define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
 #define BMBT_BLOCKCOUNT_MASK	((1ULL << BMBT_BLOCKCOUNT_BITLEN) - 1)
 
+#define XFS_MAX_BMBT_EXTLEN	((xfs_extlen_t)(BMBT_BLOCKCOUNT_MASK))
+
 /*
  * bmbt records have a file offset (block) field that is 54 bits wide, so this
  * is the largest xfs_fileoff_t that we ever expect to see.
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 60feee8b..74bb682f 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -666,7 +666,7 @@ xfs_inode_validate_extsize(
 	if (extsize_bytes % blocksize_bytes)
 		return __this_address;
 
-	if (extsize > MAXEXTLEN)
+	if (extsize > XFS_MAX_BMBT_EXTLEN)
 		return __this_address;
 
 	if (!rt_flag && extsize > mp->m_sb.sb_agblocks / 2)
@@ -723,7 +723,7 @@ xfs_inode_validate_cowextsize(
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
index 28aca7b0..ca121a72 100644
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

