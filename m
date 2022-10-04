Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F604C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Oct 2022 10:29:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiJDK33 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 06:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiJDK3X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2022 06:29:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EDE2CE10
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 03:29:22 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2949SHQv029354;
        Tue, 4 Oct 2022 10:29:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5xgtfSnUDwmoSmEmpDf5RUcIFF+w0a17TOLPQsr9bqU=;
 b=BnUX+iftoDzibv2oyNbY4M0wP7V922QXOlH6qdPagEV2133Fk9PDtpce8c6iYVxxApZc
 6vtJZPsPJVTSvSD34wmRutnoGhQ7vR42eT+2f9NOMSs2R59OQNHPIHkbTO+W1ffIcXs0
 J6WGXh0UtlxAb2C4c1fW9wzs87KlgFltTlVIk3C1XlOhJ1ssjv1N+0SXMnPzTmJaSNaF
 ko6zHPgyFbpn6N9R3inhAIMNZ+mKcVilBnEpd9V+mSBrh4iY9MCLIxXgzljWd+YXHdpS
 RKFViCai1A9YuMB5stwo7OgZWN9FqNyS6EksR4HTO+b1xP1lcK+QxcP1VUfBdORxiNN3 7Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxc51xb4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:29:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2948Aks1005348;
        Tue, 4 Oct 2022 10:29:18 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03tq3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:29:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k/EMQ319KQ3dTH7OGDMsVPYlorY5oDydJbXzO2/6BiR+0VARoQ+A+Puvr4nog9v6dAqOI1YYvu4yO4v3Evwry7CpSUrW5dyQZtKs+STbWSaFCsTxZE1G6a+Vbd7HBjfjQxYDTibeEPk1SqmYagBayzIh3RD+Kzka5NLdiV3tWHuECynltdDtHGgOsGYxhrGvCDYePwtZHmEN3v1ANQYeaXeqObcZfyO2AY6ei6GitX3K84ubsiqY6B7Mpf4g22Lz0y453AlRHbotmdzSyGO29J//XQajGZKabHT3MYGZZwpH1TWzIKch+ju5PMBghOxfEkeCL72qBzh9Zt9ngNKpyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5xgtfSnUDwmoSmEmpDf5RUcIFF+w0a17TOLPQsr9bqU=;
 b=Dts+mYr4JoVZ1ohU0FZSbXKz4rcsPcd5KPmtXlxjFIufyK+NKuozwRCY09hiLA+4FZf0NUuTXlNoVuWUzkOoX6qzpNgHGVq5l2NYCSVUbgCau2BciYvVqV+BfwsnW4Z8MSn2x+z79K4zHql5rocqCWN69+4afnl+Ocqqe3IxRYeSNzM8P5BcW4EUI6Zl9tOl8GOWkqyXIPN+PxeodJTCOhAesH3/XbGNLIaLUbZ+aQ3gvs1LlNSoUo8kjilo6Fm7NLTf680DSLuBb1aLnVybQE/BBo3x9LcKeFA+gf7WnBH+GkIvPaMocdebr0Ia0tZ9zIej4l+nKMBFGG3UgocDFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5xgtfSnUDwmoSmEmpDf5RUcIFF+w0a17TOLPQsr9bqU=;
 b=zz7r2Cl0OAIJdJsqeZ8FUL6hpqfKpJ2/x7WM4sRmcsQ7fmhlll1IvgYbruAlLeNy1/gcCAlEYTz9T2GDIH5AqsD/OWrOQgZeEDL6icrOiRI8rDY5dnyHO5DY0g6LPEXj6Zldn38syQy17f7fpFya1p6GPy5Mpnh7U95tTHGAvnA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5184.namprd10.prod.outlook.com (2603:10b6:5:38e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Tue, 4 Oct
 2022 10:29:16 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 10:29:16 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 07/11] xfs: fix memory corruption during remote attr value buffer invalidation
Date:   Tue,  4 Oct 2022 15:58:19 +0530
Message-Id: <20221004102823.1486946-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221004102823.1486946-1-chandan.babu@oracle.com>
References: <20221004102823.1486946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0129.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b6::17) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5184:EE_
X-MS-Office365-Filtering-Correlation-Id: ebdce871-de49-41cb-8e83-08daa5f349e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h/dOinKlKkFwB4ABPDWXK3EkHgfkHPZlfw3XpAuBSGUKgHZyrP4cD9+bOm5nBxIC3ercwpx8454HvvYQnUJ/KawlfzNFDquo7DBeA9KIz1u3d/C87RXtvvSAg9BYLIqNeya2G32gndw8sWLg7uEpZv81ksn8HTPpLDSObmJ83T+6nAiMWFqVwu65a474d5h8T1t582Jpr3FlvJfJjeDTJ4xeFMpLYvEycljrzfjND7Jk5GQPvU4ybQ5UPm/h1Dz6I4C389ulfmDF+fgpHOUjuUiPv31WHWhXUFmG9l0dn4XITTHv2dfeJ/oMahWxj1ZCwKDJg6qkGbdEcWB9Ed/W7Cd5a067y6ArtHXrDFFISzQ2/hKRWjynoGhYkEOn7xVKOA9SOrTVdirsteQ1jXQ/zl16vH/p+Q2GY7VLaDsdOk5OwaLiwwW4/AemNOj8p1LT60ik6NG87U9GbO3XpHpXz4P5427SLavcePeOpD81swuxf8PXX+xm9RGwgQcnL7+PV6JSVT85AuJ+Gn1n3GCaW70GOwZ7puORxGpw57pUlplpWjjrE5RPjdnHoELWkYPl8Tr8Gt/rD5mSv7NHm8lIKIrbO74fpXqjPKy040yT53upjcO6MEIuG74TQ4b7XtBDdQxalaIz4BeN80iF+bPfraNx/Q17iu33GVQqLm52fZFJL8i9agvW9Zy5IosSggZaOI6kHg5F0ZoUn8rxx4kP3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199015)(83380400001)(38100700002)(86362001)(186003)(41300700001)(8936002)(5660300002)(316002)(6916009)(8676002)(66946007)(66556008)(66476007)(4326008)(26005)(6512007)(6506007)(2616005)(1076003)(2906002)(6486002)(478600001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uf85NnmKtBWEKWDWGAkyXTTAcMhmSlmovd3X/92HgmpDOz18MWWpSOJjXDOb?=
 =?us-ascii?Q?CMtgLTc9V4vhSLv1nMh8Eq6oriq2TiJbwvKrmwb9EouQlrkzUMVGzve3OJ/n?=
 =?us-ascii?Q?VjEujSIIGM+NyaXZfbR+pn6wXl2VXP4QdM127SToEJtjUBT9qTrmADoYCp6m?=
 =?us-ascii?Q?y74kXilXEQ/QuvByjSC4qxL0ojEgUl3lnEkQVjuON/p2UEXUMqPNxdjlJjps?=
 =?us-ascii?Q?wp6+AXal8tXKrlAECOhuOpo2RxOBG1sAGyIcdNBXwXbDUCO0z8uUkPwwm7rC?=
 =?us-ascii?Q?rvDVzXl1YSnTL6ZHwS28fVayGOZ/lJc4eiEyinbivlEqUyHQ2jKKHV4gTnuJ?=
 =?us-ascii?Q?fF+rPNziFisQArEWGXMfXv52PW9iPximbDuEk3+MPDDhreEGbHnCMsFS9gwz?=
 =?us-ascii?Q?Uge9yTx32lfjfAofauIoGsRaeQnnDjM6XYgD2WHFcGqA8cx4xdk3t30rOpA/?=
 =?us-ascii?Q?J62biEbZrcGvTnEDt7EBo1Oy1EL/JW1UzGxmogZDg75+4qt9fGTfMNN7TAii?=
 =?us-ascii?Q?qaLrPVYdxwZecU6/fkI/l4HRoBiljfTYUVx+GK1K+aQh+AqGnK3NIWaheGsJ?=
 =?us-ascii?Q?nq6ivricgcOkvKPUKDoytOa7Ia2ytkFQ3TcUHiNsPeZrrIDy1CIxfSEF/ibE?=
 =?us-ascii?Q?FW52XYkbyNO/sQQYe/jV4lxX/ka6V26lbmnMuyQ+fsYlpHSSB4gVnLAlikuW?=
 =?us-ascii?Q?3ploSWbucxxT63t03pV1lTa3gnWqW8YVghEh1JVnzMqS1YApctnuVwieROli?=
 =?us-ascii?Q?lXiMRWT7OWBGablEHkskg2+GfVrIlvbHl3keb1u7y4wG+gBakOOzScVU+Q2D?=
 =?us-ascii?Q?X287pxItsErQHBcIqtAjEyjtghNArg/MA7xkqFaYboRZnz2gXU2hlUOTQeGg?=
 =?us-ascii?Q?okVGsI/60wf5uTLMZSkcbjXuYfxiRxDle/Xp5sP6OG10iUbcPW4P77nCQoIt?=
 =?us-ascii?Q?GJOGqDCu7LjX7VOeMdiDHyebopZoLpFrsrZG3bpNzFb4suSH+HXXfwDSCm8o?=
 =?us-ascii?Q?s7Et8nM6LoKYr5cY9/vya60sol3D1+iKnsusTdADdAwkraG1hGwEOmnBrYrw?=
 =?us-ascii?Q?m7O4KRP+G7GvqT6ynELhyAqM0XYZetWd0fJjIx+ysOoZ5JU8xv5I7qtLEizr?=
 =?us-ascii?Q?bj3mh6HDJ3EmxtBR0e0ytU2MG1JMW9ailILjzmkO0GtqUim9zqgTfllHekJg?=
 =?us-ascii?Q?STngWueFnUMg/QA/6H/lz0ShlATH/Qy8M26sn0O1D3IVgQr/HLzROWEF+oIa?=
 =?us-ascii?Q?mpuSYh1q2I2vhPYQ86cN3eafRLnJo56pDp/Jo7Eq6tv7RWfzI/OGogOxv8TG?=
 =?us-ascii?Q?Z4KlbftFPRSxWDVUsoVIugH7uCiQMBTC7t6vNsZNl0gUU4589W7I5lnowal/?=
 =?us-ascii?Q?5nSeNKLaqi+76ZMj8nk8JuKj8oG5jtrNkAOlmRL8B7bEuh/DZ8tkN8Q/YB6V?=
 =?us-ascii?Q?UI9XR70kzAGtOn+F4oVpKeIXDrE5lynodz6ZdVOxmltAE+dYcSOVfaJlwgBn?=
 =?us-ascii?Q?mwj1OI62JAxKEfzUu/Yx4lgUj827xcXXWANCko6tSxfBVzD1jAHBm97nYkEr?=
 =?us-ascii?Q?8stW2E/mibeZHEiQydGC8YPweOolV3AEeaQ6mPistiZ7Q5j+ZPB7FBXOB00A?=
 =?us-ascii?Q?jA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebdce871-de49-41cb-8e83-08daa5f349e2
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 10:29:16.3285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HNSb1k4frg0olWG+EOVGAajqx+esMihgJ8jj5fcZgGCubT9qrBSJoDkj0zoOTu8DukFc2S/Rgz9Q7gse/v+ybQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_03,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210040068
X-Proofpoint-GUID: 9fY-utiAEBjPhqaKyVK8WL6J2e9chYAN
X-Proofpoint-ORIG-GUID: 9fY-utiAEBjPhqaKyVK8WL6J2e9chYAN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit e8db2aafcedb7d88320ab83f1000f1606b26d4d7 upstream.

[Replaced XFS_IS_CORRUPT() calls with ASSERT() for 5.4.y backport]

While running generic/103, I observed what looks like memory corruption
and (with slub debugging turned on) a slub redzone warning on i386 when
inactivating an inode with a 64k remote attr value.

On a v5 filesystem, maximally sized remote attr values require one block
more than 64k worth of space to hold both the remote attribute value
header (64 bytes).  On a 4k block filesystem this results in a 68k
buffer; on a 64k block filesystem, this would be a 128k buffer.  Note
that even though we'll never use more than 65,600 bytes of this buffer,
XFS_MAX_BLOCKSIZE is 64k.

This is a problem because the definition of struct xfs_buf_log_format
allows for XFS_MAX_BLOCKSIZE worth of dirty bitmap (64k).  On i386 when we
invalidate a remote attribute, xfs_trans_binval zeroes all 68k worth of
the dirty map, writing right off the end of the log item and corrupting
memory.  We've gotten away with this on x86_64 for years because the
compiler inserts a u32 padding on the end of struct xfs_buf_log_format.

Fortunately for us, remote attribute values are written to disk with
xfs_bwrite(), which is to say that they are not logged.  Fix the problem
by removing all places where we could end up creating a buffer log item
for a remote attribute value and leave a note explaining why.  Next,
replace the open-coded buffer invalidation with a call to the helper we
created in the previous patch that does better checking for bad metadata
before marking the buffer stale.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 37 +++++++++++++++++++++-----
 fs/xfs/xfs_attr_inactive.c      | 47 +++++++++------------------------
 2 files changed, 44 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 4e5579edcf8c..de9096b8a47c 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -24,6 +24,23 @@
 
 #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
 
+/*
+ * Remote Attribute Values
+ * =======================
+ *
+ * Remote extended attribute values are conceptually simple -- they're written
+ * to data blocks mapped by an inode's attribute fork, and they have an upper
+ * size limit of 64k.  Setting a value does not involve the XFS log.
+ *
+ * However, on a v5 filesystem, maximally sized remote attr values require one
+ * block more than 64k worth of space to hold both the remote attribute value
+ * header (64 bytes).  On a 4k block filesystem this results in a 68k buffer;
+ * on a 64k block filesystem, this would be a 128k buffer.  Note that the log
+ * format can only handle a dirty buffer of XFS_MAX_BLOCKSIZE length (64k).
+ * Therefore, we /must/ ensure that remote attribute value buffers never touch
+ * the logging system and therefore never have a log item.
+ */
+
 /*
  * Each contiguous block has a header, so it is not just a simple attribute
  * length to FSB conversion.
@@ -400,17 +417,25 @@ xfs_attr_rmtval_get(
 			       (map[i].br_startblock != HOLESTARTBLOCK));
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
-			error = xfs_trans_read_buf(mp, args->trans,
-						   mp->m_ddev_targp,
-						   dblkno, dblkcnt, 0, &bp,
-						   &xfs_attr3_rmt_buf_ops);
-			if (error)
+			bp = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt, 0,
+					&xfs_attr3_rmt_buf_ops);
+			if (!bp)
+				return -ENOMEM;
+			error = bp->b_error;
+			if (error) {
+				xfs_buf_ioerror_alert(bp, __func__);
+				xfs_buf_relse(bp);
+
+				/* bad CRC means corrupted metadata */
+				if (error == -EFSBADCRC)
+					error = -EFSCORRUPTED;
 				return error;
+			}
 
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
 							&offset, &valuelen,
 							&dst);
-			xfs_trans_brelse(args->trans, bp);
+			xfs_buf_relse(bp);
 			if (error)
 				return error;
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 766b1386402a..9d5c27db1239 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -25,22 +25,20 @@
 #include "xfs_error.h"
 
 /*
- * Look at all the extents for this logical region,
- * invalidate any buffers that are incore/in transactions.
+ * Invalidate any incore buffers associated with this remote attribute value
+ * extent.   We never log remote attribute value buffers, which means that they
+ * won't be attached to a transaction and are therefore safe to mark stale.
+ * The actual bunmapi will be taken care of later.
  */
 STATIC int
-xfs_attr3_leaf_freextent(
-	struct xfs_trans	**trans,
+xfs_attr3_rmt_stale(
 	struct xfs_inode	*dp,
 	xfs_dablk_t		blkno,
 	int			blkcnt)
 {
 	struct xfs_bmbt_irec	map;
-	struct xfs_buf		*bp;
 	xfs_dablk_t		tblkno;
-	xfs_daddr_t		dblkno;
 	int			tblkcnt;
-	int			dblkcnt;
 	int			nmap;
 	int			error;
 
@@ -57,35 +55,18 @@ xfs_attr3_leaf_freextent(
 		nmap = 1;
 		error = xfs_bmapi_read(dp, (xfs_fileoff_t)tblkno, tblkcnt,
 				       &map, &nmap, XFS_BMAPI_ATTRFORK);
-		if (error) {
+		if (error)
 			return error;
-		}
 		ASSERT(nmap == 1);
-		ASSERT(map.br_startblock != DELAYSTARTBLOCK);
 
 		/*
-		 * If it's a hole, these are already unmapped
-		 * so there's nothing to invalidate.
+		 * Mark any incore buffers for the remote value as stale.  We
+		 * never log remote attr value buffers, so the buffer should be
+		 * easy to kill.
 		 */
-		if (map.br_startblock != HOLESTARTBLOCK) {
-
-			dblkno = XFS_FSB_TO_DADDR(dp->i_mount,
-						  map.br_startblock);
-			dblkcnt = XFS_FSB_TO_BB(dp->i_mount,
-						map.br_blockcount);
-			bp = xfs_trans_get_buf(*trans,
-					dp->i_mount->m_ddev_targp,
-					dblkno, dblkcnt, 0);
-			if (!bp)
-				return -ENOMEM;
-			xfs_trans_binval(*trans, bp);
-			/*
-			 * Roll to next transaction.
-			 */
-			error = xfs_trans_roll_inode(trans, dp);
-			if (error)
-				return error;
-		}
+		error = xfs_attr_rmtval_stale(dp, &map, 0);
+		if (error)
+			return error;
 
 		tblkno += map.br_blockcount;
 		tblkcnt -= map.br_blockcount;
@@ -174,9 +155,7 @@ xfs_attr3_leaf_inactive(
 	 */
 	error = 0;
 	for (lp = list, i = 0; i < count; i++, lp++) {
-		tmp = xfs_attr3_leaf_freextent(trans, dp,
-				lp->valueblk, lp->valuelen);
-
+		tmp = xfs_attr3_rmt_stale(dp, lp->valueblk, lp->valuelen);
 		if (error == 0)
 			error = tmp;	/* save only the 1st errno */
 	}
-- 
2.35.1

