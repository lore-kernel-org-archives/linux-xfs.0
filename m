Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B2FDC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Oct 2022 10:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiJDK3J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 06:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiJDK3C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2022 06:29:02 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541DF33E15
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 03:28:55 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2949N0fJ032699;
        Tue, 4 Oct 2022 10:28:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=G2Q1Cn/M9bU9UD6lU3AaJlgNVcHckvS4WdxQcnJT1dA=;
 b=OrchbQavUDSAR6pzt+qfeqvKOw05EzQ20dZBLgDbAQ80UP4nwghQ7yRhfSLPgRtGIHdX
 ZSMW2vt9kZJ0Aw4cFQXJSzcVXX1UVVcR7m+s6gprDtG/judzJhBZpa/lgqXCbx1Qtr+e
 Qah0dFdrH9EjG1KO7ibYSIdCMI6kfhIYnnJUT0H/O8WrFSOffu4TLJH8q/mc893dpeCN
 xbPiAIiP3AGGLvSCYW94LRgpJmy+Aoyx4SAdYBE6/n51RcaQw/ac05UicB51toT2GxhO
 q5ao7LiBeBrHtsFxquzBFQIAEz7IEStlsF3Ls81hBJ0UIchHLYobTGCPV1843komqB3n fQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxe3tp85j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:28:51 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2948AX84000544;
        Tue, 4 Oct 2022 10:28:51 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc04jjvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:28:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ro4A3nW4tc28RUgwU3MDiTNYTcBiROt+PprP9XfJc1WDjso+KyvmUI7XQ2VJDxV83rbClpIrYUiX+sAcHqTqMbjmMCvf6cG8F51jP25lLLA5BHB653CoZ9P99pOv0BWnQWAqtfKvkqHb0p9MehM0mtwvXSQf0cyAnr9L/Ba8ux7NUBXvV5kD4+YXxLjeyqgT/BsHaRPEsf7rSSU9g5MeWttc28bKZGgJmgvF2HwjBwCuyvqmtKB399y2l7EWXOhqdn/r4uhg7vuH5hySnadYwHXNgpLpQmQ7PUUQtk8wBrHYv9DkeILVAhmQM93DHJwZSObrsz/hEIjUSHHH2kg/qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G2Q1Cn/M9bU9UD6lU3AaJlgNVcHckvS4WdxQcnJT1dA=;
 b=jqhby+j/cgs+MchTieKcETNoEpnvULasyv1BH1JSsCs7PSml43TKMaI/FnmYrfT8Slo1GpQX+bzykGEVxXiOLswGMQi6MGYUnuWytLH4UTin1V7qFgMIYqqmqcYxP2WVO/9dDT+4oe6g8JFlawmHL1eqfUtrwaq78YHAMRc7kuEG/Sr0sCrNd1tyeGS/o7etJH3Y4Cug5pADFJm13cyyVoU4oUtv8gAefY9FH8FsBWGOYSK3DHbKRRYKYz3cUB9xj8pAdGVg+XUQ8Dlga/K1BjctzqPDp8ViWlwN20FNhc4HAl7aiy5BetUK7SRSx/TEfnPbpShNRp41+ShWubA+Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2Q1Cn/M9bU9UD6lU3AaJlgNVcHckvS4WdxQcnJT1dA=;
 b=yHnXBCdWldCAI9VxhGnN+qM2kSsxGfJcVSjslrGKqD/roQJj9l6jsQzkAH6UMEy/PMWTVXffrv5fqsvw5zLOnsT+45cvpWaS3FYDuUmdobHMFxK+lihdaKGhPnVTCsfkHlErWB41kfa9dBbezbIhkrgI+ri4PY4+PVV6lkdNzik=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5184.namprd10.prod.outlook.com (2603:10b6:5:38e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Tue, 4 Oct
 2022 10:28:49 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 10:28:49 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 03/11] xfs: truncate should remove all blocks, not just to the end of the page cache
Date:   Tue,  4 Oct 2022 15:58:15 +0530
Message-Id: <20221004102823.1486946-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221004102823.1486946-1-chandan.babu@oracle.com>
References: <20221004102823.1486946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:4:197::18) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5184:EE_
X-MS-Office365-Filtering-Correlation-Id: c4aa2853-0753-473b-b4e2-08daa5f339e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aiyZz1nfVji7IoxaxtLxSfYXvTGHfueMZDSSH0G0Ad3aaglW443sd5N0+nk2dIUVBqwHfGApjWTSj50k1O7lAyMcmYOTLQQVjPlRLjZkE7QZlvkegKO8vcmj0On2iJyFSyJmzyJmFcxdj+o4DGrh6xLoOIx3wRJPISBrXVnQ5Lhs77dwQckhQSc0CkxbrNw3Ar9f2q1HvkVqLdcf7JZwBhWHsmxxYmVLjC/eQ535wI0IDQ99ZWYInNtODGP7wOy8KLcI3bektEvaPueyQnqNqgs6n/J9LuMO3Vl0nzgq/LHBRqOsgSOCB3Go73j4AygKO2Vi8MMJrAikFGsqd3pv7ve6rBpiKsYCFpF3bewl/lIbozK/980+nO0S/OKOe/N4/SzaMzlOYMOG3Ikf5DJeBwJBaXkloCsbR+MV3TqkqYXV4qe23WJoUZJuzXliZFKfAfCOAzabOLYYY60HdWthdWLvezeqjIXvXaJnqute7IU9Sfsu4Ffxy+gw7Q4cYibjs+jHvXKjOC3HvMoqMmgg+9/0xbXAMF5cPuXoFSgh4gu6EwckVd1jJvtQ7x+c4wq9VKJEHng0OyXMyhUZuZ4C1LQcu3zXvpBWaMmTSg4z1ZASC/wSJHKzRvvNb7722JO9qHZK+2vd7jLKufFAqNogW48rM7j9P/4HTeqx3VHBoiHx6fYHKYU+8PT6UC8MQ3i0OUNmoEfATZ5w/CXuOYbfYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199015)(83380400001)(38100700002)(86362001)(186003)(41300700001)(8936002)(5660300002)(316002)(6916009)(8676002)(66946007)(66556008)(66476007)(4326008)(26005)(6512007)(6506007)(6666004)(2616005)(1076003)(2906002)(6486002)(478600001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?klGMJBP/lKa51Lo6q7c6v//ckJTmGKTnC1P7Zi1agzXWT9uOni5tgpdqLLWh?=
 =?us-ascii?Q?/1dQOhyQdsJP+J+fmJnKA0afakaQ3dqYTiX9GTANVMIlgkLAbSFyxLQwZulk?=
 =?us-ascii?Q?G23lw8cwTe44yRtrCd/MOv6FCdJer/NmP+xzDr95aE15R3fBD1Ot6OcbVnRY?=
 =?us-ascii?Q?Fk7YlGH86njytxikYxa5+wXGQBO3Tz7UZkSfCkmnwtioerJvQ8w+wDE0qeRL?=
 =?us-ascii?Q?2z9BBCXf5yieTLIQ+JgjB8b8mxmlXfwY9hMcw3Qg4KzV86onC3sYSQXvHTHz?=
 =?us-ascii?Q?1/L25ihaYYl1yL1qvENFudUCOcOl7Wxx+Sw35ZLszFIoz8nQJCbjkiUAxo8Z?=
 =?us-ascii?Q?b5iwPgB+2s3FAu60Y6FjmTkGZRbowOaWyooXIGZnaiVXRxjyV+T3vpZCBKUg?=
 =?us-ascii?Q?uLoxXeR7EdSs3gw5sVVbT3aP92dK5Cg+VCoO4OVpbHpK+0cI8LsanNNBZPGb?=
 =?us-ascii?Q?+DEYij+M21+OssHUb5pAhggqQ+msH1QvLuWoHbwn+4ouFdcLWy4+mOTZlfVS?=
 =?us-ascii?Q?LDlBZBype4mCP+1R1Yz5aoYU7KSCpSFDr9mg0BXezymLZO6c8EECkaJLmU2M?=
 =?us-ascii?Q?Vba1QwQQz+bi28YykXHjuDRff13aMoEKdA4qzTtwaxwyDT+buzP13ag3rso4?=
 =?us-ascii?Q?BYCW8rfsl4n+L7bcUX/2geKRS2GJzjHrOUPodMSF9RR3kyOoLuviT2xzIfyZ?=
 =?us-ascii?Q?kWhJM/0t1/4HL1rOHcsLIM5VPS3LM0u7UyMl8iIHrvtGOS3VVHUdqkqvAiwy?=
 =?us-ascii?Q?pigDIdD2A++T+RvahjiFyLYkfNi7TYwhP/P+2GOwhqv0ZU8DGzsMaF77/tL0?=
 =?us-ascii?Q?R5sElg+J5H4Y2tdhx5/VaPt92ZbnmSyZUGT+0mibMYSYgNfeVqHyb/qvTGVL?=
 =?us-ascii?Q?X+kIRr2E2l3CMXQcO73MJHJ3iTDwZSJYSY9VkagP56iSKMLRscTEDBLnGlqF?=
 =?us-ascii?Q?1dY/qt/kOVCXEDdPeFxSFDrtfhZnc6+hqAN0lhQgHawrXOgZpPPibw2t/Xm5?=
 =?us-ascii?Q?u0lQm8hrT0utUTkHBZu1WBR8tRJcKHDQuaz4SrHZ3hTQIR1yN5p+3lW4IZkm?=
 =?us-ascii?Q?hM8AwYPJhZ0f69HsSOOkMNYP2mfgjJ+AaOfaYttLUUwGD42Pk2hVSgPCsdN+?=
 =?us-ascii?Q?U1qTSooXRWrnRwIYCcfSrbbgdinYRGBZ0sRYgTXnufUIkG6PSISJl4Q8/bw6?=
 =?us-ascii?Q?hoUVJN0DJsct4YsUw2KcuG1z8eUWQ5S9jZ7cSfLmU91/k42Qd0CxokhK9W8G?=
 =?us-ascii?Q?j57s8zsz4pfEkPAopOJvXwyYPkEA1HoQYJ88mwJtrp56MF4TF9Tf4spzNG0V?=
 =?us-ascii?Q?Dx1ryiYpVJ93JyP5ofmI9NWDW7bU3KgIaPmwleYdmGwfzhe/cnQbf+8o5j8M?=
 =?us-ascii?Q?B1FNnROYR5qRmds9cLK+VXzsb4rk1tI8ibEUZ+33UzKIpV6QggZP6lTx/Rwb?=
 =?us-ascii?Q?BLQ1BdgOgw82OsU88W1EnrPSAxIQDRiRf62d5STmJRLlvnnyjniOVqIC5yVv?=
 =?us-ascii?Q?zIpnTGQDGxCLNC0DVAj/SJOyJdbFzPlUDQx3lvTNZfP5SUZZbSkkVbN0sbbJ?=
 =?us-ascii?Q?s44NSkVravsOaPgkR8AxQDsUJh/m/mNUoVvqYp527e1X1y7hLu7HbDNeNCDs?=
 =?us-ascii?Q?4A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4aa2853-0753-473b-b4e2-08daa5f339e6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 10:28:49.5902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +NxbCzrWRPexuuaW5FgiBUBk5AlRzmFqf2HhawSKQbo8woloVZhyegJ8Ttd94eYqEIO7Wp97POAijF80k4blOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_03,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210040068
X-Proofpoint-ORIG-GUID: FE-bJ44cfijvueIgygdEtk7ZSbwhWD1c
X-Proofpoint-GUID: FE-bJ44cfijvueIgygdEtk7ZSbwhWD1c
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 4bbb04abb4ee2e1f7d65e52557ba1c4038ea43ed upstream.

xfs_itruncate_extents_flags() is supposed to unmap every block in a file
from EOF onwards.  Oddly, it uses s_maxbytes as the upper limit to the
bunmapi range, even though s_maxbytes reflects the highest offset the
pagecache can support, not the highest offset that XFS supports.

The result of this confusion is that if you create a 20T file on a
64-bit machine, mount the filesystem on a 32-bit machine, and remove the
file, we leak everything above 16T.  Fix this by capping the bunmapi
request at the maximum possible block offset, not s_maxbytes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_inode.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7b72c189cff0..d4af6e44dd6f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1513,7 +1513,6 @@ xfs_itruncate_extents_flags(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp = *tpp;
 	xfs_fileoff_t		first_unmap_block;
-	xfs_fileoff_t		last_block;
 	xfs_filblks_t		unmap_len;
 	int			error = 0;
 	int			done = 0;
@@ -1536,21 +1535,22 @@ xfs_itruncate_extents_flags(
 	 * the end of the file (in a crash where the space is allocated
 	 * but the inode size is not yet updated), simply remove any
 	 * blocks which show up between the new EOF and the maximum
-	 * possible file size.  If the first block to be removed is
-	 * beyond the maximum file size (ie it is the same as last_block),
-	 * then there is nothing to do.
+	 * possible file size.
+	 *
+	 * We have to free all the blocks to the bmbt maximum offset, even if
+	 * the page cache can't scale that far.
 	 */
 	first_unmap_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
-	last_block = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
-	if (first_unmap_block == last_block)
+	if (first_unmap_block >= XFS_MAX_FILEOFF) {
+		WARN_ON_ONCE(first_unmap_block > XFS_MAX_FILEOFF);
 		return 0;
+	}
 
-	ASSERT(first_unmap_block < last_block);
-	unmap_len = last_block - first_unmap_block + 1;
-	while (!done) {
+	unmap_len = XFS_MAX_FILEOFF - first_unmap_block + 1;
+	while (unmap_len > 0) {
 		ASSERT(tp->t_firstblock == NULLFSBLOCK);
-		error = xfs_bunmapi(tp, ip, first_unmap_block, unmap_len, flags,
-				    XFS_ITRUNC_MAX_EXTENTS, &done);
+		error = __xfs_bunmapi(tp, ip, first_unmap_block, &unmap_len,
+				flags, XFS_ITRUNC_MAX_EXTENTS);
 		if (error)
 			goto out;
 
@@ -1570,7 +1570,7 @@ xfs_itruncate_extents_flags(
 	if (whichfork == XFS_DATA_FORK) {
 		/* Remove all pending CoW reservations. */
 		error = xfs_reflink_cancel_cow_blocks(ip, &tp,
-				first_unmap_block, last_block, true);
+				first_unmap_block, XFS_MAX_FILEOFF, true);
 		if (error)
 			goto out;
 
-- 
2.35.1

