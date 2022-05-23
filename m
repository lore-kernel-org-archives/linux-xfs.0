Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9E1AC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 04:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiEWEfM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 00:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiEWEfL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 00:35:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9AEEE32
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 21:35:09 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24MEXsKg014472;
        Mon, 23 May 2022 04:35:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Tm8tUTdo3C0ySUevfaAuI0NeZP9d5XDspsLu9OVWtS4=;
 b=RDdSPUm2AXmmPSTMCUFpSyHhwonoCYjXvbCin7w5qO5ZMAd/41J+ZUJYeOF+p+Jjbb+e
 QOcYU6j19J470HRatBVHBjICCCHqdKKq1w38AkA6B5Mpar4zR4SPKR0HJskb2+DHlYRa
 Li7lDb7jAXbGEPuaWsetYpmNEB5QvprqZb2JKVmqIyHeq8CwqMDgHuwaQjxCWhzZIZfG
 DPOYiDYfFLnYPFa757qRfnra+S64UCAlFFvEqwJq3Utq2PNCNgbMAMgz/FaKAts6H206
 SC4GePIA1//17X6S17oObG+sFeHeTIniyFRb5loFVTqe96Ta7Mxsajf3xIsT3HZXKh6h GA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6pgbj7hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 04:35:08 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24N4WEbl012716;
        Mon, 23 May 2022 04:35:07 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g6ph0xmqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 04:35:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YdLrhn31b+nM1D2qeMlo0qjMZXt0O+lQTJKilBeihBwkxbs6dtUYVhjmw4vYsVFRe5tv00Z/MBf6MyjqvZRR0+fbIse8qDeVdbT33tYkOQyc91K/lF0Yz9Sxz8avx+k8RgLgh+uZFhnL7FCUou9z7Gw4exBaPPOfDB0Lq4CFQRLxcERkd+Y7vKCFavmS8SNeSsX9CYJz12hyhsV9wfGC4Kvoidjr5yeZjTYzXknyJCLtZfsLqwVFBo212zb44oi5XB9UIgXxugGN1/XvSWvLd1c94ByLdar+F5LWkBw2dDxoZLHO+wObmp6QC1eRAlxN6bQMBr1Bz+RXQ4cKDfX5fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tm8tUTdo3C0ySUevfaAuI0NeZP9d5XDspsLu9OVWtS4=;
 b=dsIbkVD3uySfzXrsKFhttb0hv42xS3MGYMwCU8ZJ19osrDF7Z7P57udK/Q1gp3tFOX8UVUEDTcAx7bq2fEzsSPgwwj3zEbd1wq1cA3Jh2OoHEGgTfQF/4L6tw/BycyoGrfNd9iTGn4ZDuJBR/JRYGwSMT2WOwwfTjQY3X4t7KrEA1izvqZviolA2/KsoMu0vnXX9FGP3OgKGQgjAIKKhIXN2aOn/vW47Ls6xki7ysZPuutRELEEhVQlzyZ6gGG6ESy0bQIatSIK2qTDbyqXnrIP7xVzEckvZf+AtnvZDkFHx67yPNye3hruJBoaCtqaw0Pa2MJHrL+sX51VeW17WCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tm8tUTdo3C0ySUevfaAuI0NeZP9d5XDspsLu9OVWtS4=;
 b=ZK4TkKsHO1QPVcOnVmnag+rxtYxXKRGriCYF2bl6Q2YhqVOMqgArSlC5V/KhFjheXsd4v/BmT5NQXYqwACp/apEAgQk588H22PsKzC2uy5yaJ5f5U30FqQrFNg78L4koFvOWqzTEln5FxCGMcQBIOyecGNy9lpFrRgGjjoUBj6c=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MN2PR10MB4190.namprd10.prod.outlook.com (2603:10b6:208:19a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Mon, 23 May
 2022 04:35:05 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 04:35:05 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, sandeen@sandeen.net
Subject: [PATCH] xfs_repair: Search for conflicts in inode_tree_ptrs[] when processing uncertain inodes
Date:   Mon, 23 May 2022 10:04:41 +0530
Message-Id: <20220523043441.394700-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR04CA0002.apcprd04.prod.outlook.com
 (2603:1096:404:f6::14) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee5338ce-b345-4151-9b90-08da3c759bc3
X-MS-TrafficTypeDiagnostic: MN2PR10MB4190:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB419086176BE89F1FD33B6367F6D49@MN2PR10MB4190.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eaBgN/zboRhyAVXW5kSq1zj43KHxGyKjiu1xNdKsWYzzKlpCUGeQIOIMyJ+9ZrIKDxwAvQSOyiYTa6cpD7xMyO/khQx3Ex5zqWtO7xsm1JLT7X6uMimXpYAwrXt8MJWb6nO0rjUorZalzopWfsw9JGJ6YxOpYzfKKv/2DGcssKPGGC0MecHRuKOFZfSmeEflim21yrn0Mo7P7QAL2yaMwGn9jzLBC74KaiK7whRs+CY5HvqcBUZUwEWRvxoihqdYgsQv6poCPGmjSNRKdrI7K5exangWpXgvoVc0rpfbGevOg9PKShNCOPBBnO3fI0AnalQhlZ2gbZNssZagY9wlogGzWpyFV/1IdnkqmvghCjk88ukTzehKYmrRvJQW81GkCIEe2fpZ8BanvaMgU4b/mNpIAlsIQGcEpDU422yJKqr65yOFNUx2aoyVxiSwK1BHFCW09JIZ5iOoX9hK6x2n4LUPnH8wsM7L+DxvKaddN1fd0QDF9PaoRmoj09Y5uxltbs21OwDLimPPp/Nyt0ogs/J+3pHJxssq7EzZQ75Q3ZEse1ld7Oob0rij6MClokOaC7JT+p0H6pG9Soq0Vra0Ic0SuqxnPR4Ix7JS0teU1OqezUOju1WRERujVpWDNFPUYLPxHe/bJzLQTMb7eh3JfNJM7SKxeg69MMEi73ajylawz1hNtbT/lgA0DHohi67e1/IAPhPHANbyon7CaMFhfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(8936002)(36756003)(38100700002)(66556008)(38350700002)(8676002)(4326008)(66476007)(66946007)(83380400001)(6666004)(316002)(6916009)(1076003)(6512007)(2616005)(508600001)(6486002)(186003)(52116002)(2906002)(6506007)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k/XR+8A4sJFPyu5ooPEp7O1E9OS+csSjJGeBbHIbmASfIpVM3jexO+EVSikw?=
 =?us-ascii?Q?w7d1LO3OCjAqUQHdeqJJxFL+ZMXkSuefABu7XM8lqeVvQzO4eX/REgOGzSQd?=
 =?us-ascii?Q?XLgsEWd7keqWRVjoGvDut/O8K/X4n3si+Al9CXbsm+YXdun6sGKjpgQqczXe?=
 =?us-ascii?Q?8/qGaOgN0AA86ohsLQHGTGaWivaJOeUXozsf1n7f21mofq6aTZcFUT832QKZ?=
 =?us-ascii?Q?SqdFdWWVArO69X474y1KTZDt2UFl1kUdDPqV4oHSn/a7aE7XCGVlCrTpc4hc?=
 =?us-ascii?Q?TmdzhS33/9RcKbgx7JDp4e2Tz4n0EsjmS+90uI/RQHWo7axo5PO+xMBaciaB?=
 =?us-ascii?Q?QfDft2r1boHY2ke1bGZSg/3x+qrPSRC1V1cbTVNREFbTc74osKSeCDO9UNjE?=
 =?us-ascii?Q?S+KDhxrf7SXTRFgNXGsyjzTOZoLvB4fSpc/2nyz+TSGUG1zlaAV86/KPOW+i?=
 =?us-ascii?Q?uLbGfsfsGt6zoe1ZaWUmsjiKxNQzxUz1Z68O02vWCJ6NIogdneI+TI+mBuqf?=
 =?us-ascii?Q?RwKwVKfn+YL/SVpuGpMvo1wDRyhWSI/1Y6Sg5Anr36c5aoMjV751t0RyR8Pu?=
 =?us-ascii?Q?uPi8FITR/G80DE+iDqIy8IR1EBIzb9fNFmelUiFuZg1grUX84cflLi3sUc6P?=
 =?us-ascii?Q?V4pruw/MmnJNn74IaBlr2Zgg+E2eIR4Gc0WCrej788y8V3ipWQalEVVS6ar/?=
 =?us-ascii?Q?Id8WhJBxZDsGya/QFCA6BWF7ifJLUTgVeD03KjnrPDNc2Z7shMxZ3yRIZDa9?=
 =?us-ascii?Q?F4c6j+ZPbtM3BdOuH8UV1tCg8jq04+h+aHy4XUDSQovgtCDT7w7fDOSf35ij?=
 =?us-ascii?Q?kd6G9So0jzbOOK6dmYaCxVU+QOptqxvVA9xSZvQpuS6ZqwdT+QXcTgcFGO1R?=
 =?us-ascii?Q?fSK+uaB2TI4trb4ph0bx1mkv3ZivjHH9gtMZ+JgP1QZ53w/jp3RojFAMNFZ0?=
 =?us-ascii?Q?gvdFo8JdUGu0sVCB8qzVt+Ywcy7JRaMvDsKzW8k4IjN5LnGDqqnmkGU+0cSH?=
 =?us-ascii?Q?wZcqJMwXgldkSZiEhTWAz1+pQ0VA9sTZUb0QStg8UTJc55t+K0ffnfLbCgh9?=
 =?us-ascii?Q?/ulq/h7HzksZQKlzlUldAxf1h593sEBsGpTAXR4sWM6kfL4J7XOvF255jsw3?=
 =?us-ascii?Q?6xknoPx3yrr7gfaMMeKhMFiwP1HW6sZAn1AYgEZkoNRiE1+nZlsKSPj17gdv?=
 =?us-ascii?Q?8xwUzh8GRXbZXR2sViIy8O2yJMpaU7HIBAgJH66sAmHEuNciSqI+KbAEI0xs?=
 =?us-ascii?Q?VlhVDqJ6bK+WzueReEf/23QO/ZY6M1UE3GaYqfTzTifYIxkLbp3mdU3GEsmh?=
 =?us-ascii?Q?kSJolZtaEuocyBlTTZYrd3bshF4sZf3EUDulpvaZicG5Ecn+oKhHJQyKWOqa?=
 =?us-ascii?Q?ETHQTM7/0r5D85Yhp8654MZq27I7k9lbMXajqQ+gjZuFoJyhwe+5ulKPumts?=
 =?us-ascii?Q?6K8ZOVqVLMYAQo+X+BpU3X2bUHQ+Y4p2etLwVGxFtspSFx8rAm5vwDVv+j0C?=
 =?us-ascii?Q?koBT+4lPWYt/nvb0jCup9gW809OuJ2m8PQ9id0iwp0mNKm8dlCmmzHot1awK?=
 =?us-ascii?Q?VIDaRM9ArTkdPr9ZJnlP7jqfJNT7iLyRDf4lEAnl2fzPyXt9jG0pBULSFuMl?=
 =?us-ascii?Q?aCIziw8wAYcTRTDNyEz4RqG8a0F7TRY3siK3n/J+pEPeUYRhsnLydMBvHfOw?=
 =?us-ascii?Q?vawnUfRP/rbQZfs5TRlcq+asfw7v+kGlHkJHUfB0MF+vbrQqx2qM31GUbl0d?=
 =?us-ascii?Q?yz2c7hZjOQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee5338ce-b345-4151-9b90-08da3c759bc3
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 04:35:05.0661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 35H8SMxWNEtpyuFZIjUFq9JhrRxw/Q6cy4SmDYZ/HShCrdUk7+9WN7lCAjqGTmAzQEDIA+MJHCEBG4EHzwleHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4190
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-23_01:2022-05-20,2022-05-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205230028
X-Proofpoint-ORIG-GUID: LbN81IxH6dxamW46hjfpv3aOLNvjaGaG
X-Proofpoint-GUID: LbN81IxH6dxamW46hjfpv3aOLNvjaGaG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When processing an uncertain inode chunk record, if we lose 2 blocks worth of
inodes or 25% of the chunk, xfs_repair decides to ignore the chunk. Otherwise,
xfs_repair adds a new chunk record to inode_tree_ptrs[agno], marking each
inode as either free or used. However, before adding the new chunk record,
xfs_repair has to check for the existance of a conflicting record.

The existing code incorrectly checks for the conflicting record in
inode_uncertain_tree_ptrs[agno]. This check will succeed since the inode chunk
record being processed was originally obtained from
inode_uncertain_tree_ptrs[agno].

This commit fixes the bug by changing xfs_repair to search
inode_uncertain_tree_ptrs[agno] instead.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 repair/dino_chunks.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 11b0eb5f..80c52a43 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -229,8 +229,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		/*
 		 * ok, put the record into the tree, if no conflict.
 		 */
-		if (find_uncertain_inode_rec(agno,
-				XFS_AGB_TO_AGINO(mp, start_agbno)))
+		if (find_inode_rec(mp, agno, XFS_AGB_TO_AGINO(mp, start_agbno)))
 			return(0);
 
 		start_agino = XFS_AGB_TO_AGINO(mp, start_agbno);
-- 
2.35.1

