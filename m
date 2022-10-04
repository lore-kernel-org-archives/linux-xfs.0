Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 858FAC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Oct 2022 10:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiJDK3n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 06:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiJDK3l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2022 06:29:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0504B89
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 03:29:35 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2947Uc93000854;
        Tue, 4 Oct 2022 10:29:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=owO/3p71M6g5jJk+zIgOBQkqWBhkGYlNu2qxcwGD+/M=;
 b=GdIiRM7E50SzVLyecjvHlCRFMsQtfhNQ1EtPqvkCKG0gs8V5XM2Ebnd+jqrUERB2HKx8
 FDtBheAcjbvW4EMK7E5utigjvSOAw4mc7X19RgJLggRn4Eua+ovjVL2mt64AlL4w+iFq
 cADglpsH+t8XSPNYlxJ6F0KEQC+x0p0Y5mbXT6QOpUu/4ULsodkJG1wAp4dYhJQQ904X
 Sz7rIbb7w9lSxZC76FpDtxPKUGnNBPctV2eOq7vCR48SM1vJMru7YEkSbnnvfppYtF6Y
 8f+WLkOMLh+JYPJWY7XXHuLVpGfB8W6y26MoQdPP7HrHtt6z9sc2IT8D3qiaQZ8eiK7F oQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxbyn5vy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:29:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2948B3Eo033844;
        Tue, 4 Oct 2022 10:29:31 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc04346k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:29:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VuMkroxitlm16xgqedEA+/WJKcAhF980YTTaj8N8vmdXJXI2cBQYsgeWmReHT4bjWXIM3Ssy8C5oD1LuMiaFYZmdRYPIu//20GFF2IkQN/bsnTthAkTFR9MlYIrVSo6Woiz3y/+U8KKGcMnFWSVUH9F4YRTdNdH+heRwh86LC4pABY14cI3cNUuI5oXqEs1mypR450ZysDf384S22sWbaBEIlcwrPQ4W5r0E40DmW1xnFftJlQWtkln06RVBPB3agJe2dph0hdFCyGW92+bqBzUF2i5VhASvA0qEGaiN1fIlDAgbl//T5elvMMoZrdSP2Ory8wX3+RgkOuGE7PIwhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=owO/3p71M6g5jJk+zIgOBQkqWBhkGYlNu2qxcwGD+/M=;
 b=b6z4OECI3sJeBUXco4uSA4xk5+Nhuu4hYTfWydAppVxf2wihdC7oIVPSDLVcEOcI/P3+9gUR5OCYVeE+nJc93+juRWNpW5ss9RUPlHTrk+0JlIvOs1m6IFyseIR7lqMZ97FXqYBhW//SF2NQtyF5WeOS4JYQZJez9rIekWRlT7XNqY3uKCPluPxqUpCfbf11/Fyuj7/gpSYyBu4jnsUaLAvM+l9n/gPFoOwNnEmURvHEnFuRnsCJKYaw++vgmexFHzvpJsEzWnQqR4DO1970190sbv8Ygcyb4ZndlKGCPI37l8DrajLZdIlWSvwnKz9vph4VTf9HoU36dyC+iM63zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=owO/3p71M6g5jJk+zIgOBQkqWBhkGYlNu2qxcwGD+/M=;
 b=bm4RoKfTMZUfKUTan6H4SgEOmW/0kN3cdSrrU8l4DmmbVW5nIjcAFQbOBCGZk70H9WzvX/3viFf2mWKZAqSpxj0sJX8noRbiepeLfwjaocQkLqDnwracAqsnyDHLWOjAxRTNFIqB3PdqOJ2CeSjSS4TsN1GRZQrDf3iBjVdx33w=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5184.namprd10.prod.outlook.com (2603:10b6:5:38e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Tue, 4 Oct
 2022 10:29:29 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 10:29:29 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 09/11] xfs: streamline xfs_attr3_leaf_inactive
Date:   Tue,  4 Oct 2022 15:58:21 +0530
Message-Id: <20221004102823.1486946-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221004102823.1486946-1-chandan.babu@oracle.com>
References: <20221004102823.1486946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0106.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29c::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5184:EE_
X-MS-Office365-Filtering-Correlation-Id: b7b26a52-2226-4e1d-b9e0-08daa5f351ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k6HFTDTGtW668OIt+kpdrAkGCP/5ikR9DSlnAClMop1uAHfWsViLiDT3DXO8AwmQpM3zeWsj0nTeKwcxGqzfomI0OEhGoNfIDBS8ni/8HYsvW63ajiyU6713uCvLU5eUH/ijuXwWmXwR35mWIP41Sp7F3FvNYnnYDV5b+NNVGPy27H34e9jty6eOW86i3XU0QXWziP0MV/mp5U4gk90RCOh+fC+MCuxT8B+MfgBSNm/13aqXqTgmv5IuKHqWxgnfRyhtvvJUORiZ5ZyCj4+kg4ocyE7Nk3Me3AKSwBst/iWhdU8PEsxU38E1/YLqFjOORtSHl0f1S3m4rRPt3wSbEGpQCC6SFSHakNZIMdiMGKJ/IEl0wCq8XeQdWDcuEPl4xiWD3uFAiANro2WCviz53YxmmxhpKreKnKwf6zCYxZsTfEgO4XirBHgMLxX9Ab1L2ChupuaoFyi+bB17jT+DmxOwhRWNEelCkGImyJfybY2j+FgQ8FYBWc90iGBvQVQF6CxljgQdfNdR66KVKvcv1w8cycYOCgRLLaU04JqZQebC8C/wTrffsqHr6LJjNhMRKwnmTAq0U7dOyubfScRrajKkfWGesZjRUdwYVdXtRXA+SVCTNkd6CxhHGejyGqU7ziZV2ci/ZC8gjJUmqx5HKA9bafWbOZ4VbQoRZu01bXmPbulKrCvdm0rbUpoD+IFMb4BxUKi5Wwr80zRpDftMwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199015)(83380400001)(38100700002)(86362001)(186003)(41300700001)(8936002)(5660300002)(316002)(6916009)(8676002)(66946007)(66556008)(66476007)(4326008)(26005)(6512007)(6506007)(6666004)(2616005)(1076003)(2906002)(6486002)(478600001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cPx2KFpyYy/J1rz+qs8W5NtGHJJJ/iLjEed99MHFJliPxOUwSf/M3lhjntGo?=
 =?us-ascii?Q?Y5DI+K4jJAb6ELD0aazSWdW5qbjQeQU2LyWsDdxh0d7Q901Tl8H9TMWvlOEc?=
 =?us-ascii?Q?cigZw47FoQu4SlxefPkD8mcwCMIiEBiCEZGe6ftfct/YcKxFiJORrmvN/1t3?=
 =?us-ascii?Q?LUx60oHoArKvM42358nFWaY63xXqNfsWerJgxIYFjKJyEo8JGDM3wXCKkqc2?=
 =?us-ascii?Q?IAN83KKDlNCNRYhbCzeV3swq3LufaBnciU6tWg6H2vDdBsW3wgFhtOiij/h+?=
 =?us-ascii?Q?XTo4w9ifWqLUolC3uOIwWqiqGWPLIjgTiLM8NAdy4LtmNKDrDkVWSWl2fGbn?=
 =?us-ascii?Q?nJpU/E8YeaxQioFvZoMbLxBf9LR0g5LzYe5Qol2dNuH3SKFNEjwHpNzRO3eV?=
 =?us-ascii?Q?Vk3OlW2mv/A0Ul+a2toIkA8mHMrp7DBMfGRdgiw992XsHXuTCVVtmhH9jUlc?=
 =?us-ascii?Q?7FLY1LcqhrBdf0vCTkOUw1N9Sjauq+hoanAGrYz/9jmoRdg9Y3+YFruaEmLf?=
 =?us-ascii?Q?4SzE0Bgr2qAwFYvSu6ITznw+bTUIsbdp5/HZGgqYFUIdCt7gwZzaAP/3aMor?=
 =?us-ascii?Q?ISFugaLQUCfUkFSgdUjVi1cPd4Ee0YvjaBpLLxDKTBeflDSTX1u0xVaFAwpc?=
 =?us-ascii?Q?S14zWWA6K5xLvu6U0n+GTy/Qu8j7FU0I/smV1E9CvFAc5GohjNNI8ZewrzRx?=
 =?us-ascii?Q?Uh5A5rOTTjLK4dfyIl9eG7L8DBsd5lvRnWaF9XZoq4YFJYuZbZKhZUmiDi8t?=
 =?us-ascii?Q?ge4rVij/48KwOWlTtmFiSJ7px05aw6c26J67k+xbEJzbb6ly/b/uhg1pzUqE?=
 =?us-ascii?Q?/ZYbsb4H/XOBOHhBnl/ZViWqLp2sOGzX6oXP0zrvGJm5Hz9BUsELXu1e7405?=
 =?us-ascii?Q?64zUWBjtaWtDPWFu5B0Bgrppf+VAoc8US89VYP+tEQbo4YcVNHROXh+mZNQN?=
 =?us-ascii?Q?WG80DhUflpImAXN9f+tOyTCT0w0joIX3TMTBoZEkuxnTp4MJJgbXCflicHP4?=
 =?us-ascii?Q?oRzNeSPUj0EPTyhexk5tWFKyMNcewxRmIVpPUU5RnNngETlyOaY8sMgQe8fP?=
 =?us-ascii?Q?vOo3McWMM18PgMAjQ1c3cM945tWLtXb9QIj7CTh7G8K7f5MEmfDxrtXinSbm?=
 =?us-ascii?Q?z6T/RaJFpyGbpHQs2BYnCgru1jkqJsf6LQoE1lmm1YPmHuD05+0B9R75MoP9?=
 =?us-ascii?Q?k68K5pEFu4eLH+Vnp1BahXmZ3zvq9VuXzlINXjOrXqiBVB5K494Qcb+Dbqmw?=
 =?us-ascii?Q?LM/79XCUmxLmx+KLILBvECe5HO4HZmVQeZEK18KZxTrv0+AcRaq8g+EPcUq7?=
 =?us-ascii?Q?h13axKq8yyfAAh9okEXOgqsNT3Z6Z9nhl8APpqEn4XFmdTuobiLP9EtGdukB?=
 =?us-ascii?Q?rXuFnfv0OPWmwyALgS3arSeuB6yUI4cLJpA7Eyfh2myvHvYrluZZ7rOeQjrP?=
 =?us-ascii?Q?28pl6WC0U3DTygRJML8UXQBm5/pJ+TwDlS9HBJOQVU2KHK+WBxDmh2f2LI8m?=
 =?us-ascii?Q?qAVwFBmJEBpCisQg3Pvo6UGt6rCdlWvWy4IzXEecZFjC3EBq2O7LxdARW1xY?=
 =?us-ascii?Q?4cEB1DBkMO5OWME2EWDc08u00J5fOEdTITW/zW0DiYv3yMm1u4GNxWZPJMLZ?=
 =?us-ascii?Q?DQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7b26a52-2226-4e1d-b9e0-08daa5f351ba
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 10:29:29.3643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TKq8Uhyf///CNQO49yyT5lOVvOVz+2tZRH9PLZmnVl9SKBvA5kTqVDFNLezToCwV/Bx/MEHTwa4ycwkF2+5//g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_03,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210040068
X-Proofpoint-GUID: JjdBgr3g3iSsEXT32E03Co4FRfht-l45
X-Proofpoint-ORIG-GUID: JjdBgr3g3iSsEXT32E03Co4FRfht-l45
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 0bb9d159bd018b271e783d3b2d3bc82fa0727321 upstream.

Now that we know we don't have to take a transaction to stale the incore
buffers for a remote value, get rid of the unnecessary memory allocation
in the leaf walker and call the rmt_stale function directly.  Flatten
the loop while we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.h |   9 ---
 fs/xfs/xfs_attr_inactive.c    | 101 ++++++++++------------------------
 2 files changed, 29 insertions(+), 81 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 23dd84200e09..38c05d6ae2aa 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -39,15 +39,6 @@ struct xfs_attr3_icleaf_hdr {
 	} freemap[XFS_ATTR_LEAF_MAPSIZE];
 };
 
-/*
- * Used to keep a list of "remote value" extents when unlinking an inode.
- */
-typedef struct xfs_attr_inactive_list {
-	xfs_dablk_t	valueblk;	/* block number of value bytes */
-	int		valuelen;	/* number of bytes in value */
-} xfs_attr_inactive_list_t;
-
-
 /*========================================================================
  * Function prototypes for the kernel.
  *========================================================================*/
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 9d5c27db1239..1f331d51a901 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -37,8 +37,6 @@ xfs_attr3_rmt_stale(
 	int			blkcnt)
 {
 	struct xfs_bmbt_irec	map;
-	xfs_dablk_t		tblkno;
-	int			tblkcnt;
 	int			nmap;
 	int			error;
 
@@ -46,14 +44,12 @@ xfs_attr3_rmt_stale(
 	 * Roll through the "value", invalidating the attribute value's
 	 * blocks.
 	 */
-	tblkno = blkno;
-	tblkcnt = blkcnt;
-	while (tblkcnt > 0) {
+	while (blkcnt > 0) {
 		/*
 		 * Try to remember where we decided to put the value.
 		 */
 		nmap = 1;
-		error = xfs_bmapi_read(dp, (xfs_fileoff_t)tblkno, tblkcnt,
+		error = xfs_bmapi_read(dp, (xfs_fileoff_t)blkno, blkcnt,
 				       &map, &nmap, XFS_BMAPI_ATTRFORK);
 		if (error)
 			return error;
@@ -68,8 +64,8 @@ xfs_attr3_rmt_stale(
 		if (error)
 			return error;
 
-		tblkno += map.br_blockcount;
-		tblkcnt -= map.br_blockcount;
+		blkno += map.br_blockcount;
+		blkcnt -= map.br_blockcount;
 	}
 
 	return 0;
@@ -83,84 +79,45 @@ xfs_attr3_rmt_stale(
  */
 STATIC int
 xfs_attr3_leaf_inactive(
-	struct xfs_trans	**trans,
-	struct xfs_inode	*dp,
-	struct xfs_buf		*bp)
+	struct xfs_trans		**trans,
+	struct xfs_inode		*dp,
+	struct xfs_buf			*bp)
 {
-	struct xfs_attr_leafblock *leaf;
-	struct xfs_attr3_icleaf_hdr ichdr;
-	struct xfs_attr_leaf_entry *entry;
+	struct xfs_attr3_icleaf_hdr	ichdr;
+	struct xfs_mount		*mp = bp->b_mount;
+	struct xfs_attr_leafblock	*leaf = bp->b_addr;
+	struct xfs_attr_leaf_entry	*entry;
 	struct xfs_attr_leaf_name_remote *name_rmt;
-	struct xfs_attr_inactive_list *list;
-	struct xfs_attr_inactive_list *lp;
-	int			error;
-	int			count;
-	int			size;
-	int			tmp;
-	int			i;
-	struct xfs_mount	*mp = bp->b_mount;
+	int				error;
+	int				i;
 
-	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
 
 	/*
-	 * Count the number of "remote" value extents.
+	 * Find the remote value extents for this leaf and invalidate their
+	 * incore buffers.
 	 */
-	count = 0;
 	entry = xfs_attr3_leaf_entryp(leaf);
 	for (i = 0; i < ichdr.count; entry++, i++) {
-		if (be16_to_cpu(entry->nameidx) &&
-		    ((entry->flags & XFS_ATTR_LOCAL) == 0)) {
-			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
-			if (name_rmt->valueblk)
-				count++;
-		}
-	}
-
-	/*
-	 * If there are no "remote" values, we're done.
-	 */
-	if (count == 0) {
-		xfs_trans_brelse(*trans, bp);
-		return 0;
-	}
+		int		blkcnt;
 
-	/*
-	 * Allocate storage for a list of all the "remote" value extents.
-	 */
-	size = count * sizeof(xfs_attr_inactive_list_t);
-	list = kmem_alloc(size, 0);
+		if (!entry->nameidx || (entry->flags & XFS_ATTR_LOCAL))
+			continue;
 
-	/*
-	 * Identify each of the "remote" value extents.
-	 */
-	lp = list;
-	entry = xfs_attr3_leaf_entryp(leaf);
-	for (i = 0; i < ichdr.count; entry++, i++) {
-		if (be16_to_cpu(entry->nameidx) &&
-		    ((entry->flags & XFS_ATTR_LOCAL) == 0)) {
-			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
-			if (name_rmt->valueblk) {
-				lp->valueblk = be32_to_cpu(name_rmt->valueblk);
-				lp->valuelen = xfs_attr3_rmt_blocks(dp->i_mount,
-						    be32_to_cpu(name_rmt->valuelen));
-				lp++;
-			}
-		}
-	}
-	xfs_trans_brelse(*trans, bp);	/* unlock for trans. in freextent() */
+		name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
+		if (!name_rmt->valueblk)
+			continue;
 
-	/*
-	 * Invalidate each of the "remote" value extents.
-	 */
-	error = 0;
-	for (lp = list, i = 0; i < count; i++, lp++) {
-		tmp = xfs_attr3_rmt_stale(dp, lp->valueblk, lp->valuelen);
-		if (error == 0)
-			error = tmp;	/* save only the 1st errno */
+		blkcnt = xfs_attr3_rmt_blocks(dp->i_mount,
+				be32_to_cpu(name_rmt->valuelen));
+		error = xfs_attr3_rmt_stale(dp,
+				be32_to_cpu(name_rmt->valueblk), blkcnt);
+		if (error)
+			goto err;
 	}
 
-	kmem_free(list);
+	xfs_trans_brelse(*trans, bp);
+err:
 	return error;
 }
 
-- 
2.35.1

