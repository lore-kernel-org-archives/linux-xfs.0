Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5BACC43217
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D30A060EB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236376AbhIPKJP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:09:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:49056 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236373AbhIPKJB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:09:01 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xuwP010995;
        Thu, 16 Sep 2021 10:07:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=RnCuiVLDSAy7dcsVyp4Qjszb2PpTKBJCDoIDQytDxQE=;
 b=zmziNgQvq/FZwWRn0Oix/oCIoNocwmCe3qBBHpCb66PcNGhkqOlEZ3o9jBIhBCEBZZf9
 q4oqKqrhBWsFAgmPVIUpkdeZbQmpz23JXcKfNB1diIOqy2yDy51oX1fK63Y27PgtitPd
 dmg9U51zao8xOco/oZhGabLmXvV2/Mmd1VaMmQ4PXKdsAYn0doK93kZe2/Y1MNJbg9IQ
 R0BlRBIsu0rNF315PxqjI4zsIvjKbMYkGLve+VT6HHes9f8VTvF2Q+3agohsPZzeCmMy
 osW7pBjzJCX8R3W5GwTbeg5kF+3MQ2q9aDdgfBxM95xZ3Csa/UQvKo2PRwzZxuEEeVIv Yg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=RnCuiVLDSAy7dcsVyp4Qjszb2PpTKBJCDoIDQytDxQE=;
 b=vEZKKh5Yf/vj6M17ygY/yEVLZLU2O1HEQ40gMjrAnD+uQ5kqHwSTKKPjq2Wr0DX9uxjf
 D00F+/Ft/rpgwvFudK+4YjoAb5CDpjXJgKwhJqNq/3hxJPGcsKBPleAj2zlPD7+amUuD
 2tNq3fNa7wHpLF9IBP16xCZ8NWO6oMc+Ku+/+6GepE7Ap0zXh/8xDCVnmh/my2im2RXl
 ohJ4WEyUWeLXdRtT5VyXqmjMffGEtAwTdGnn9nLmYzuh2Yb7QYhT4j2eKCZH1ad7gpcc
 1vwWIUczySOv42EED/bbO4awCmfQQBRypuCDRsX64Sxw+tK43PL/AkaX1pnhAiiynCpx Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3jysjvac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA5is5171556;
        Thu, 16 Sep 2021 10:07:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by userp3020.oracle.com with ESMTP id 3b167uxnuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y58Z5ry6fKp9jfMQagZZqPaLcB3KcaUdNk9/4HOF3nPOisskQvRe2ezipY6T11BX4SEB6Py9i7lVIfoApA1/0IOV0t/s6enPWXmsbyzEs+T7TcJj5fgoyYwOo5nntw7Bn0LZP4xfUS+ovLY2y/3KofhpU9Y6v+LM75MPpETI5eNywmqe3+BRs6+Syo1qZoDWPKdFY60Of1YYYQ8JndDYtUJEMg8ID7w6MhcFc7M4uN7AGZArnMttaU1xa6/SpV7lja9jSZlUMIxSrW3u/KsSeg9lvftMzc7A99DOe/kGDZiC8Q1tLn3UBThhhgLFy4ngLFWQ+L/6kWLf6VjKw9iFWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=RnCuiVLDSAy7dcsVyp4Qjszb2PpTKBJCDoIDQytDxQE=;
 b=iUgL+uP3yqHgAtABGbe+vpftYkzsEVORHGv+EC5vLRy74c4cHTXhbotm0mHKRFJLgbH5o4SlzLUToHJUmUUH/J1zGTmZidvRALP1Oiz+UqyLh3SJt/3f2mi8e65xaUzCnuyEqrdT9Gsp8vbpCabsRlWnCe2iWLtSiARGicZdI2XgxzdQcsIM1/M5ybYdmmHL3Z6jzzIX1+gELYJ9Ce+e2WpmC2WcDFQq9ic1GWEQrTi+Lnj1ezuOPF+TPHucJDVCYY0o6jns39zUTcT4Jz2SAA87K6CkzGIri1L8E9aZvgFSOm5DNmyINt9Sz/ZUgzFLrJa8rgglmve0/4j+L+tgIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnCuiVLDSAy7dcsVyp4Qjszb2PpTKBJCDoIDQytDxQE=;
 b=Pz4sFP9H0nQLiS1Pf4fnhx2c+avkeC3fm1zksLhjBrmKci7h3grJmLYjbCclUcFxk/SDQLbJsucO2lq0bbJEmGXtQ/YlyYBpGLWMEUbfKN5oGTMpZ6ApvSuv2yqqLvHXe/mJjG2lBlmyCF86AbhaEcIBmdCQFC4HjOuGHkg6Ym0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2878.namprd10.prod.outlook.com (2603:10b6:805:d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 16 Sep
 2021 10:07:36 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:07:36 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 10/12] xfs: Extend per-inode extent counter widths
Date:   Thu, 16 Sep 2021 15:36:45 +0530
Message-Id: <20210916100647.176018-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100647.176018-1-chandan.babu@oracle.com>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::11) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:07:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 495b537c-4e5b-4e39-a2b0-08d978f9ce41
X-MS-TrafficTypeDiagnostic: SN6PR10MB2878:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB28783B50AFE11A97AFFB2C0FF6DC9@SN6PR10MB2878.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:183;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +TQcdiDM2xRwkucyUMOCWEqis9WfuhDJztRYTP6m9qRMItrNZVsn9phJ5ni4/4345ExCpTU3T4G8IHodwpaeN0tBhum5qCg0ojOjw2zfqrsp+kFLl0mPkffYeKF39yKDR7OWJd6Zuencz2YWDwvNV3SilcuSjxROxcPUx2yCWDVRqROJw8nWr4B9lMZvCj8u7aFd6k9lunB5tncAHvUC6IPs3ip13ZBjn0qy2YbbrD50BZH3pGOcA5c+xu1MwjBGNDIfAbhKkebfx4r0Bqwlx6ycA329LOnzyRNrsHXtMX6lxyXSp/od0R0nkoakd8Jw/6e1alZB7HHed70yOzjkzuxNWevf+2geVkqyXTPTfpDQqayOXO75sWQABBYzY1LMWdjjljW357NzOFOtdJL5AVrMwr9kb+MyWLRgf1xat1TkH/WPQ7B+NEmNSI0UdbMMiXfC3qsSwxRYg85ag5Irowas/pYVgFIM4lchTh2HRY3rPkolKrYfdD0QnGJAfk41ys99M2jUpoFYfyI3sVBfk1rEnMxnlowpeSgJ3z9IkIoSPWMiigsinULm4PFvjiaAI3s2mbaMu/0um6Tn9B14ib6N8sQvDUWgdX8FzpcU2oOce4N77ClGJXS+9CMFCkMz3K6jOlJ6KnLCufivV/8i7p4Q6Js8YYkzDzzHR0rTouBKMPhbxTGnlsaSqYeY0yrzbsCMOWDdLpEptzQeVGvC1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(478600001)(5660300002)(186003)(66946007)(86362001)(66476007)(66556008)(38100700002)(2616005)(83380400001)(6512007)(8676002)(956004)(4326008)(26005)(6916009)(52116002)(38350700002)(6666004)(6506007)(1076003)(36756003)(8936002)(6486002)(30864003)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?98uepA+7Cze4YTTIi0n8MisKU2RrspXscmOK1U1L0/W+3X6mhgAWkKk08KiB?=
 =?us-ascii?Q?DkYtKmtsc2kdaipRU8eqeAsGxpPm5XKlnIwpKO/Hzx50yeChEDEhus51EWPF?=
 =?us-ascii?Q?+cCHlVtxczsmJgddDRPMI4zcrpVOR5zMmaN22wHFAgmjZnIz3J79xtyZp2aK?=
 =?us-ascii?Q?BiLRJM4i7YqUL5zjujyHY7dsXjG8/+cnM3VwPDF+mXZBsmIA7tH5chfPEvCC?=
 =?us-ascii?Q?DgTSX8auJYLVZ3rEtw/1OXq8QQQ1bd0mR1ns5u+1QvlHLK23oepvY43IU5Tt?=
 =?us-ascii?Q?QagfsBJPEnOOQc2WFjW2F5xgmgbKn88fZyDTW/lZ213sJBGWkDtSfSxpEgLZ?=
 =?us-ascii?Q?6gx/QydcDa3Dh0FnWW11uYvhfRthPN/XA3idvHeQ+z8HpuLGI/CJsF4AL7Yn?=
 =?us-ascii?Q?AgK93VhGOMnILX/GWKbFj5DE3asz4LzqRl0iaL1TbCLLRbT8xcfV5gqF3xUg?=
 =?us-ascii?Q?ChIla6VcSK0Y5Nl25atLVmqGgbIosSLPM4mdHNK5RTkH8CIlJv8VkC9bbLvr?=
 =?us-ascii?Q?NMCWVYP1cMubXg7GWZf38+aCFHSBLEjO+U/Xo2kIB0oaWgTO1gmI/76wxuR3?=
 =?us-ascii?Q?ZuNQDvNcmKsZ5TZdxOwHSC7zXgxnFlgZJTG2nnkyhllDr3fOcHsWIS0BOhb5?=
 =?us-ascii?Q?EG52TXnWqUnuYJwsA8PN2PzV134KTSa38xcHuPitOLd+JI7V9frcIm3pZj8s?=
 =?us-ascii?Q?qI3RW0lEt7YQZr6CVLYKbJqSg9V2EaANkgnpL93+YS/G3pPXh3cM+T1ow+vS?=
 =?us-ascii?Q?TvEmpu1p60NQ2UDaLb+skx78e8spfx1v/yD4LCOzB48TZCEH8982kdHqafDu?=
 =?us-ascii?Q?u1oSoVFu0flx2WKeQXf6yr7J1hatFS4J4CEucpAEH8sGLPeyaJ3DDsCL+vGq?=
 =?us-ascii?Q?wjxDl2er3sHhooMIQ7NUHK38a/RxtP4Am8sJkjFC8R5qZlNBHvYzh4WqGzVP?=
 =?us-ascii?Q?DMxOd5CdaSwI2SKUUov/CABkdLMWXeKoBRsXgCNYSX8OnEfYLoq3RaiQYySn?=
 =?us-ascii?Q?NC49Qj9ov2hMtReuBMRX05D8yE1B5uh7pqMINEGLR7KWpB8EdIOE8zoJaLVq?=
 =?us-ascii?Q?eMCwgZ1w1/1PuIiUjRjQsEldWXQRTyr9VKVlYEvclxTiLSjlLAnHWBEDTIa0?=
 =?us-ascii?Q?PPjXq/rbP8ogg8rFgiIVfIpl0gt5Hr0YzPx9w1UmMVZiN2LjnSFgh/D3WkXN?=
 =?us-ascii?Q?6XDp4U27bZdE5GjcWuaszqGoC+1WLYG1DZ82sl1274Tpy2y99yNiZHskUjjx?=
 =?us-ascii?Q?5PKU3n2VQdr4hUFnqyY2Hz9svL0iV8GSMdaL35OtqoJ/BBdlBhwSmIWONP0z?=
 =?us-ascii?Q?qVS+ymmDjjcjYUSmWUyRtHZP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 495b537c-4e5b-4e39-a2b0-08d978f9ce41
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:07:36.5136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7X0IXFt9RaY0gR74+f/P+993gcClRUFVLf/VfZE8oFqhweqC0ZGwoyP7j2g5O6j+Ahdu06YlthlzLWwsH9EU7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2878
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-GUID: lswEDW9hhvv1QTJcIMUsIJSDXcTstB_7
X-Proofpoint-ORIG-GUID: lswEDW9hhvv1QTJcIMUsIJSDXcTstB_7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a new 64-bit per-inode data extent counter. However the
maximum number of extents that a data fork can hold is limited to 2^48
extents. This feature is available only when XFS_SB_FEAT_INCOMPAT_NREXT64
feature bit is enabled on the filesystem. Also, enabling this feature bit
causes attr fork extent counter to use the 32-bit extent counter that was
previously used to hold the data fork extent counter. This implies that the
attr fork can now occupy a maximum of 2^32 extents.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c        |  8 ++-
 fs/xfs/libxfs/xfs_format.h      | 87 ++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_fs.h          |  1 +
 fs/xfs/libxfs/xfs_ialloc.c      |  2 +
 fs/xfs/libxfs/xfs_inode_buf.c   | 25 +++++++++-
 fs/xfs/libxfs/xfs_inode_fork.h  | 18 +++++--
 fs/xfs/libxfs/xfs_log_format.h  |  3 +-
 fs/xfs/libxfs/xfs_sb.c          |  4 ++
 fs/xfs/libxfs/xfs_trans_inode.c |  6 +++
 fs/xfs/scrub/inode_repair.c     | 11 ++++-
 fs/xfs/xfs_inode.c              |  2 +-
 fs/xfs/xfs_inode.h              |  5 ++
 fs/xfs/xfs_inode_item.c         | 21 +++++++-
 fs/xfs/xfs_inode_item_recover.c | 26 +++++++---
 fs/xfs/xfs_mount.h              |  2 +
 15 files changed, 171 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1a716067901f..a77cf8619ec0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -55,18 +55,16 @@ xfs_bmap_compute_maxlevels(
 	int		whichfork)	/* data or attr fork */
 {
 	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
+	xfs_rfsblock_t	maxblocks;	/* max blocks at this level */
 	int		level;		/* btree level */
-	uint		maxblocks;	/* max blocks at this level */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
 	int		sz;		/* root block size */
 
 	/*
-	 * The maximum number of extents in a file, hence the maximum number of
-	 * leaf entries, is controlled by the size of the on-disk extent count,
-	 * either a signed 32-bit number for the data fork, or a signed 16-bit
-	 * number for the attr fork.
+	 * The maximum number of extents in a fork, hence the maximum number of
+	 * leaf entries, is controlled by the size of the on-disk extent count.
 	 *
 	 * Note that we can no longer assume that if we are in ATTR1 that the
 	 * fork offset of all the inodes will be
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 87c927d912f6..7373ac8b890d 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -388,6 +388,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_METADIR	(1 << 5)	/* metadata dir tree */
+#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 6)	/* 64-bit data fork extent counter */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
@@ -802,6 +803,16 @@ typedef struct xfs_dinode {
 	__be64		di_size;	/* number of bytes in file */
 	__be64		di_nblocks;	/* # of direct & btree blocks used */
 	__be32		di_extsize;	/* basic/minimum extent size for file */
+
+	/*
+	 * On a extcnt64bit filesystem, di_nextents64 holds the data fork
+	 * extent count, di_nextents32 holds the attr fork extent count,
+	 * and di_nextents16 must be zero.
+	 *
+	 * Otherwise, di_nextents32 holds the data fork extent count,
+	 * di_nextents16 holds the attr fork extent count, and di_nextents64
+	 * must be zero.
+	 */
 	__be32		di_nextents32;	/* number of extents in data fork */
 	__be16		di_nextents16;	/* number of extents in attribute fork*/
 	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
@@ -820,7 +831,8 @@ typedef struct xfs_dinode {
 	__be64		di_lsn;		/* flush sequence */
 	__be64		di_flags2;	/* more random flags */
 	__be32		di_cowextsize;	/* basic cow extent size for file */
-	__u8		di_pad2[12];	/* more padding for future expansion */
+	__u8		di_pad2[4];	/* more padding for future expansion */
+	__be64		di_nextents64;
 
 	/* fields only written to during inode creation */
 	xfs_timestamp_t	di_crtime;	/* time created */
@@ -876,6 +888,8 @@ enum xfs_dinode_fmt {
  * Max values for extlen and disk inode's extent counters.
  */
 #define	MAXEXTLEN		((xfs_extlen_t)0x1fffff)	/* 21 bits */
+#define XFS_IFORK_EXTCNT_MAXU48	((xfs_extnum_t)0xffffffffffff)	/* Unsigned 48-bits */
+#define XFS_IFORK_EXTCNT_MAXU32	((xfs_aextnum_t)0xffffffff)	/* Unsigned 32-bits */
 #define XFS_IFORK_EXTCNT_MAXS32 ((xfs_extnum_t)0x7fffffff)	/* Signed 32-bits */
 #define XFS_IFORK_EXTCNT_MAXS16 ((xfs_aextnum_t)0x7fff)		/* Signed 16-bits */
 
@@ -931,32 +945,6 @@ enum xfs_dinode_fmt {
 		(dip)->di_format : \
 		(dip)->di_aformat)
 
-static inline int
-xfs_dfork_nextents(
-	struct xfs_dinode	*dip,
-	int			whichfork,
-	xfs_extnum_t		*nextents)
-{
-	int			error = 0;
-
-	switch (whichfork) {
-	case XFS_DATA_FORK:
-		*nextents = be32_to_cpu(dip->di_nextents32);
-		break;
-
-	case XFS_ATTR_FORK:
-		*nextents = be16_to_cpu(dip->di_nextents16);
-		break;
-
-	default:
-		ASSERT(0);
-		error = -EFSCORRUPTED;
-		break;
-	}
-
-	return error;
-}
-
 /*
  * For block and character special files the 32bit dev_t is stored at the
  * beginning of the data fork.
@@ -1023,6 +1011,7 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
 #define XFS_DIFLAG2_METADATA_BIT 4	/* filesystem metadata */
+#define XFS_DIFLAG2_NREXT64_BIT 5	/* 64-bit extent counter enabled */
 
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
@@ -1053,10 +1042,12 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  * - Metadata directory entries must have correct ftype.
  */
 #define XFS_DIFLAG2_METADATA	(1 << XFS_DIFLAG2_METADATA_BIT)
+#define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
+
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_METADATA)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_METADATA | XFS_DIFLAG2_NREXT64)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
@@ -1064,6 +1055,46 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME));
 }
 
+static inline bool xfs_dinode_has_nrext64(const struct xfs_dinode *dip)
+{
+	return dip->di_version >= 3 &&
+	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_NREXT64));
+}
+
+static inline int
+xfs_dfork_nextents(
+	struct xfs_dinode	*dip,
+	int			whichfork,
+	xfs_extnum_t		*nextents)
+{
+	int			error = 0;
+	bool			inode_has_nrext64;
+
+	inode_has_nrext64 = xfs_dinode_has_nrext64(dip);
+
+	if (inode_has_nrext64 && dip->di_nextents16 != 0)
+		return -EFSCORRUPTED;
+
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		*nextents = inode_has_nrext64 ? be64_to_cpu(dip->di_nextents64) :
+			be32_to_cpu(dip->di_nextents32);
+		break;
+
+	case XFS_ATTR_FORK:
+		*nextents = inode_has_nrext64 ? be32_to_cpu(dip->di_nextents32) :
+			be16_to_cpu(dip->di_nextents16);
+		break;
+
+	default:
+		ASSERT(0);
+		error = -EFSCORRUPTED;
+		break;
+	}
+
+	return error;
+}
+
 /*
  * Inode number format:
  * low inopblog bits - offset in block
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b76906914d89..3d0b679d96d7 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -254,6 +254,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_ATOMIC_SWAP	(1 << 23) /* atomic swapext */
 #define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 24) /* metadata directories */
+#define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 25) /* 64-bit extent counter */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 77119ea7d1ce..585743208392 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2836,6 +2836,8 @@ xfs_ialloc_setup_geometry(
 	igeo->new_diflags2 = 0;
 	if (xfs_has_bigtime(mp))
 		igeo->new_diflags2 |= XFS_DIFLAG2_BIGTIME;
+	if (xfs_has_nrext64(mp))
+		igeo->new_diflags2 |= XFS_DIFLAG2_NREXT64;
 
 	/* Compute inode btree geometry. */
 	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 882ed4873afe..0ab332c913c4 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -285,6 +285,27 @@ xfs_inode_to_disk_ts(
 	return ts;
 }
 
+static inline void
+xfs_inode_to_disk_iext_counters(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*to)
+{
+	if (xfs_inode_has_nrext64(ip)) {
+		to->di_nextents64 = cpu_to_be64(xfs_ifork_nextents(&ip->i_df));
+		to->di_nextents32 = cpu_to_be32(xfs_ifork_nextents(ip->i_afp));
+		/*
+		 * We might be upgrading the inode to use wider extent counters
+		 * than was previously used. Hence zero the unused field.
+		 */
+		to->di_nextents16 = cpu_to_be16(0);
+	} else {
+		if (xfs_has_v3inodes(ip->i_mount))
+			to->di_nextents64 = 0;
+		to->di_nextents32 = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
+		to->di_nextents16 = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
+	}
+}
+
 void
 xfs_inode_to_disk(
 	struct xfs_inode	*ip,
@@ -313,8 +334,6 @@ xfs_inode_to_disk(
 	to->di_size = cpu_to_be64(ip->i_disk_size);
 	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
 	to->di_extsize = cpu_to_be32(ip->i_extsize);
-	to->di_nextents32 = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
-	to->di_nextents16 = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = cpu_to_be16(ip->i_diflags);
@@ -334,6 +353,8 @@ xfs_inode_to_disk(
 		to->di_version = 2;
 		to->di_flushiter = cpu_to_be16(ip->i_flushiter);
 	}
+
+	xfs_inode_to_disk_iext_counters(ip, to);
 }
 
 static xfs_failaddr_t
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 4b9df10e8eea..f8a85ba6e9e9 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -136,10 +136,22 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
 static inline xfs_extnum_t xfs_iext_max_nextents(struct xfs_mount *mp,
 		int whichfork)
 {
-	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
-		return XFS_IFORK_EXTCNT_MAXS32;
+	bool has_64bit_extcnt = xfs_has_nrext64(mp);
 
-	return XFS_IFORK_EXTCNT_MAXS16;
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+	case XFS_COW_FORK:
+		return has_64bit_extcnt ? XFS_IFORK_EXTCNT_MAXU48
+			: XFS_IFORK_EXTCNT_MAXS32;
+
+	case XFS_ATTR_FORK:
+		return has_64bit_extcnt ? XFS_IFORK_EXTCNT_MAXU32
+			: XFS_IFORK_EXTCNT_MAXS16;
+
+	default:
+		ASSERT(0);
+		return 0;
+	}
 }
 
 struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 9f352ff4352b..de4bcb94c732 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -429,7 +429,8 @@ struct xfs_log_dinode {
 
 	uint64_t	di_flags2;	/* more random flags */
 	uint32_t	di_cowextsize;	/* basic cow extent size for file */
-	uint8_t		di_pad2[12];	/* more padding for future expansion */
+	uint8_t		di_pad2[4];	/* more padding for future expansion */
+	uint64_t	di_nextents64; /* higher part of data fork extent count */
 
 	/* fields only written to during inode creation */
 	xfs_log_timestamp_t di_crtime;	/* time created */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index ffff91081036..a6b84893ebda 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -126,6 +126,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_NEEDSREPAIR;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
 		features |= XFS_FEAT_METADIR;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
+		features |= XFS_FEAT_NREXT64;
 
 	if (sbp->sb_features_log_incompat & XFS_SB_FEAT_INCOMPAT_LOG_ATOMIC_SWAP)
 		features |= XFS_FEAT_ATOMIC_SWAP;
@@ -1175,6 +1177,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATOMIC_SWAP;
 	if (xfs_has_metadir(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
+	if (xfs_has_nrext64(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 6a3a869635bf..ac622097243a 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -144,6 +144,12 @@ xfs_trans_log_inode(
 		flags |= XFS_ILOG_CORE;
 	}
 
+	if ((flags & XFS_ILOG_CORE) &&
+	    xfs_has_nrext64(ip->i_mount) &&
+	    !xfs_inode_has_nrext64(ip)) {
+		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+	}
+
 	/*
 	 * Inode verifiers do not check that the extent size hint is an integer
 	 * multiple of the rt extent size on a directory with both rtinherit
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 133109d84b98..995bad2cedd6 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -740,7 +740,10 @@ xrep_dinode_zap_dfork(
 {
 	trace_xrep_dinode_zap_dfork(sc, dip);
 
-	dip->di_nextents32 = 0;
+	if (xfs_dinode_has_nrext64(dip))
+		dip->di_nextents64 = 0;
+	else
+		dip->di_nextents32 = 0;
 
 	/* Special files always get reset to DEV */
 	switch (mode & S_IFMT) {
@@ -827,7 +830,11 @@ xrep_dinode_zap_afork(
 	trace_xrep_dinode_zap_afork(sc, dip);
 
 	dip->di_aformat = XFS_DINODE_FMT_EXTENTS;
-	dip->di_nextents16 = 0;
+
+	if (xfs_dinode_has_nrext64(dip))
+		dip->di_nextents32 = 0;
+	else
+		dip->di_nextents16 = 0;
 
 	dip->di_forkoff = 0;
 	dip->di_mode = cpu_to_be16(mode & ~0777);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6338a93b975c..3c969803e671 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2539,7 +2539,7 @@ xfs_iflush(
 				ip->i_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 			"%s: detected corrupt incore inode %llu, "
-			"total extents = %llu nblocks = %lld, ptr "PTR_FMT,
+			"total extents = %llu, nblocks = %lld, ptr "PTR_FMT,
 			__func__, ip->i_ino,
 			ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp),
 			ip->i_nblocks, ip);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index b0114c8cef76..348b1dbe42c0 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -230,6 +230,11 @@ static inline bool xfs_inode_has_bigrtextents(struct xfs_inode *ip)
 	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
 }
 
+static inline bool xfs_inode_has_nrext64(struct xfs_inode *ip)
+{
+	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
+}
+
 /*
  * Return the buftarg used for data allocations on a given inode.
  */
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index e4800a965670..5c318aaecff4 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -358,6 +358,23 @@ xfs_copy_dm_fields_to_log_dinode(
 	}
 }
 
+static inline void
+xfs_inode_to_log_dinode_iext_counters(
+	struct xfs_inode	*ip,
+	struct xfs_log_dinode	*to)
+{
+	if (xfs_inode_has_nrext64(ip)) {
+		to->di_nextents64 = xfs_ifork_nextents(&ip->i_df);
+		to->di_nextents32 = xfs_ifork_nextents(ip->i_afp);
+		to->di_nextents16 = 0;
+	} else {
+		if (xfs_has_v3inodes(ip->i_mount))
+			to->di_nextents64 = 0;
+		to->di_nextents32 = xfs_ifork_nextents(&ip->i_df);
+		to->di_nextents16 = xfs_ifork_nextents(ip->i_afp);
+	}
+}
+
 static void
 xfs_inode_to_log_dinode(
 	struct xfs_inode	*ip,
@@ -385,8 +402,6 @@ xfs_inode_to_log_dinode(
 	to->di_size = ip->i_disk_size;
 	to->di_nblocks = ip->i_nblocks;
 	to->di_extsize = ip->i_extsize;
-	to->di_nextents32 = xfs_ifork_nextents(&ip->i_df);
-	to->di_nextents16 = xfs_ifork_nextents(ip->i_afp);
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = ip->i_diflags;
@@ -411,6 +426,8 @@ xfs_inode_to_log_dinode(
 		to->di_version = 2;
 		to->di_flushiter = ip->i_flushiter;
 	}
+
+	xfs_inode_to_log_dinode_iext_counters(ip, to);
 }
 
 /*
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index c21fb3d2ddca..980d6615f6f2 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -167,8 +167,6 @@ xfs_log_dinode_to_disk(
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
 	to->di_extsize = cpu_to_be32(from->di_extsize);
-	to->di_nextents32 = cpu_to_be32(from->di_nextents32);
-	to->di_nextents16 = cpu_to_be16(from->di_nextents16);
 	to->di_forkoff = from->di_forkoff;
 	to->di_aformat = from->di_aformat;
 	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
@@ -182,12 +180,17 @@ xfs_log_dinode_to_disk(
 							  from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
+		to->di_nextents64 = cpu_to_be64(from->di_nextents64);
+		to->di_nextents32 = cpu_to_be32(from->di_nextents32);
+		to->di_nextents16 = cpu_to_be16(from->di_nextents16);
 		to->di_ino = cpu_to_be64(from->di_ino);
 		to->di_lsn = cpu_to_be64(lsn);
 		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &from->di_uuid);
 		to->di_flushiter = 0;
 	} else {
+		to->di_nextents32 = cpu_to_be32(from->di_nextents32);
+		to->di_nextents16 = cpu_to_be16(from->di_nextents16);
 		to->di_flushiter = cpu_to_be16(from->di_flushiter);
 	}
 }
@@ -203,6 +206,8 @@ xlog_recover_inode_commit_pass2(
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_buf			*bp;
 	struct xfs_dinode		*dip;
+	xfs_extnum_t                    nextents;
+	xfs_aextnum_t                   anextents;
 	int				len;
 	char				*src;
 	char				*dest;
@@ -342,16 +347,25 @@ xlog_recover_inode_commit_pass2(
 			goto out_release;
 		}
 	}
-	if (unlikely(ldip->di_nextents32 + ldip->di_nextents16 > ldip->di_nblocks)) {
+
+	if (xfs_has_v3inodes(mp) &&
+		ldip->di_flags2 & XFS_DIFLAG2_NREXT64) {
+		nextents = ldip->di_nextents64;
+		anextents = ldip->di_nextents32;
+	} else {
+		nextents = ldip->di_nextents32;
+		anextents = ldip->di_nextents16;
+	}
+
+	if (unlikely(nextents + anextents > ldip->di_nblocks)) {
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
 				     XFS_ERRLEVEL_LOW, mp, ldip,
 				     sizeof(*ldip));
 		xfs_alert(mp,
 	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
-	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
+	"dino bp "PTR_FMT", ino %Ld, total extents = %llu, nblocks = %Ld",
 			__func__, item, dip, bp, in_f->ilf_ino,
-			ldip->di_nextents32 + ldip->di_nextents16,
-			ldip->di_nblocks);
+			nextents + anextents, ldip->di_nblocks);
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a4c149670476..f558d5c4a5f1 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -288,6 +288,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
 #define XFS_FEAT_ATOMIC_SWAP	(1ULL << 26)	/* extent swap log items */
 #define XFS_FEAT_METADIR	(1ULL << 27)	/* metadata directory tree */
+#define XFS_FEAT_NREXT64	(1ULL << 28)	/* 64-bit inode extent counters */
 
 /* Mount features */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
@@ -370,6 +371,7 @@ __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_LOG_FEAT(atomicswap, ATOMIC_SWAP)
 __XFS_HAS_FEAT(metadir, METADIR)
+__XFS_HAS_FEAT(nrext64, NREXT64)
 
 /*
  * Decide if this filesystem can use log-assisted ("atomic") extent swapping.
-- 
2.30.2

