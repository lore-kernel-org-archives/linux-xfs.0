Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB57C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhLNIuK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:50:10 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:27360 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhLNIuJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:50:09 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE71w80018096;
        Tue, 14 Dec 2021 08:50:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=yNQ7ebnbClfiH4wfQgmLMpAvdaCM82jys3K7HSsk1Kc=;
 b=MuJQaLYHCkGo3hdrvDiEs2hXuZ8uJeKe/m424k83XbfnIMWIoTA56vtWy+WpbQoEKOF0
 5orYWdPs/pTD4rZ9tNMeEs6osOqKgRR4eHyKad456OhQ/28SAagbS9VB9bM7ZXTIEG63
 t+apsJStEm7T6Y28rhzJD1AnPRgsOaT5lhSzrSIul2Tbhwsak9rK3hzB3I/q7UNGdbMU
 onlyDLGavSMCCXQ3TKPPSGt88fEn56zPywzliq7L6Wn1trXAJJI7fN9AoR0yDKcME+/f
 Xfl8L63R48OEx3rL+IoLQwvPqvpxOh2uVZoXSflrx2nbl/y2nrh1t8TgaTLzcm9Mkgcu WQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx5akau1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8eSHs074180;
        Tue, 14 Dec 2021 08:50:06 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by aserp3020.oracle.com with ESMTP id 3cxmr9yjp8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYq8r2LP7cAltILO2GHdcS/B8Z0gMQQfSItvcL7y6ooOughnP/e8wkirR6nyHp+eb55I9SQ9GFUyHcmqf17otjYS2yb6rBQk+a2IFe2HcO3XnQTJvVZu66Dfj+QKUdUJ+KtlJCbH30L91ptiCEhb0v4lh+s9pbiWIMC0CVvrZyCJ95IPuIRCucF404hnACVFmyHZ4D92Zi7t+h8m+lUeQJAzKD75Wav952W0kCN8TFbP6NShn7jew2T14wPPIHKxYc3V5Tjv7n4HOa/aobAVnwFJeZnEgxUscLa1lrPUazWaShWPZDp+GBI9ccPBJAChXu4U+lHJJIrnIY9tsu1Iyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yNQ7ebnbClfiH4wfQgmLMpAvdaCM82jys3K7HSsk1Kc=;
 b=MXZq15lgwc4nLRuR/fxTQxrZmvqDGrwSUDiaBsg51hnDqntlfhY2qqR4bL5AzgyGXzIaBl64YkqJBFyIrcxBMzhR/BVI8PJ+57hTWiMFId+sdUME6wWh2Yy6Crw0P8xF88a7R2gZXp4Q2JTWpnTnetHzESRgeZpZUhB+CQcA4sflq+GOCQqcH8pKWmeniQicoOpawXF2grzS704DOMWnltqKuDKxuNXdM1m+A6viu+j8IviYIojWgINWhmY2ACpwISpZGtfeX245p+xx1QUX0E6YH16wm/8xJZJLdxdekMtOXq2YVMe/8+3U4gTcHnbSWQHgCVjvfohWL+K5rbOQUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNQ7ebnbClfiH4wfQgmLMpAvdaCM82jys3K7HSsk1Kc=;
 b=QDFZf9AQy+b56v2Q87UoZ+zCzYWuGMYz7qEQSZaujXxhr71yrVEdKieqWxUIKnjwiJDUXYB4rHHQNM9s0ccwiZqsGE9fKuCnJ17lEs9SpdVv65tuijm0tShB+PrWY2vpaq5sTYt7/1t2r5Ml1Gs5lgKiOl0WBfa45F/cY0f2TaE=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2656.namprd10.prod.outlook.com (2603:10b6:805:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:50:01 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:50:01 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 12/20] xfsprogs: Introduce macros to represent new maximum extent counts for data/attr forks
Date:   Tue, 14 Dec 2021 14:18:03 +0530
Message-Id: <20211214084811.764481-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084811.764481-1-chandan.babu@oracle.com>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::31) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2da0f7b3-2365-4b33-b75d-08d9bedeb6f8
X-MS-TrafficTypeDiagnostic: SN6PR10MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2656EB1EA2DE2059AB65139CF6759@SN6PR10MB2656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cNLI1vzpfzMq0GfFEiQXs4YWCK/UqC/sRDEBsmYKKpoTg2l3OJQMgFYrkhcsETv/QBkOR90iA8R1OPBb59fl7NMdj9iUXcn+vp0efQXgnxg1l2zjn1i69KBnBVaiIy0RCuRBLO6YCjVixfDKnigHTEUPMtCimnBj6joEpIbvQFnb3gwhJkzGYaMY6G++dNUoQcsvTsex6ecsWBwzpIcfpnI8s4tgoIsYJYY3V8U1BCECTW3NYxWjiudfBSAde+w73lUjEAOYAsU5jAQ3hD3IXl7FymNvMof/QoJgNHabwBAtG4pT8DhxT3iu2PnFokMUmQErF//HgZ8mCp224b8y1bkTk1DkscCS/RflcY8iOm9bwzrOegTWjsja3wWhCnJ/Rx4CvG112O1sBlL0/IFQwzqnCF3FRUSl5R0KddCoK7Bn9FpUtLenCMsKJK1/SqHxyKzmtplQ2xi3tOD0/Urjce2om867n0pDGaMD1yhalDfxn4J8kdiTbChN7GYqHjEt3pDGjtYOSWN0l1i8uD1HACExx9jKVuWdUQAG08hCDqCa/KoBMLZroCblJQ2jYVngwFsoR+45fjXvqM7HsN/4HFfUYuXZU7pQZLEtR021B7K+DyqHraAs6aamp8/IPBw0ys/uNfNBMZ+os2+u0XUUpuX7FosAMK3TLyNJ4kuOHywWy92u+r0AEqnix2Kpi02i1WBYSg6ORSdgIQhb6uzjcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(52116002)(86362001)(186003)(6512007)(8936002)(6916009)(66946007)(38100700002)(38350700002)(5660300002)(6486002)(316002)(8676002)(66556008)(66476007)(2906002)(1076003)(83380400001)(2616005)(36756003)(4326008)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?knQfkTKYUhBOd0SS3nRRrIr4jzbNCPqVeNkyuiy+j2MRYmFGA0jCRi8UhAvm?=
 =?us-ascii?Q?oBi5IWssR2uXHNo/taph5f3lT3Se6eX6eZM34Bwsh+5a9P+QRPZHVPmvsZ1r?=
 =?us-ascii?Q?X6o8LjZwI4hpDQ4iXEnDgB7QWBUYwNLLlPpiNsgpTLszyT2QmcG2SyqhBjmU?=
 =?us-ascii?Q?9yEvk0qHpGHHqmGRnsTOLMfjdagm9zMPMPjLpyJFXVc0GlBPeWZ3rWJnOsM/?=
 =?us-ascii?Q?sZRdZUOkISClPdCMIE1lxwYynA85VvFC4dCc96D0m1ml8Gzj0q6MqPMD2QtG?=
 =?us-ascii?Q?CXjuX3Xn3sjWDZuZQ070Om/2Vv09U+oJUJEt03HwBqgBZrF1gCpIa5eyGl8b?=
 =?us-ascii?Q?oxV4bF878hinQBb0POFf/oNMn53lhfVxVYowHBh4pZEmipxxqfTkXlYx9XnJ?=
 =?us-ascii?Q?lUb1rdBGKmqs9/X+t+p8oRMnBrgIGFEkkytuO2adEnbCPnjV8//lCYg26Mot?=
 =?us-ascii?Q?M0EfIOdMWvmL3GIE2FPfC/Wiu+nykKZl+UwI0zNgud6/yNF7aowG+tQqU/PS?=
 =?us-ascii?Q?VP4kjCyd+hkdNO+1clfMk9eYppU6RX05vAi945K7YX5o8bt9r7iItoLC2t1Z?=
 =?us-ascii?Q?TAna30ckipgeUMPtFNZmuMLHF7baWKT5ZSeefpw/4P5P1lzSALgLauR7fCnh?=
 =?us-ascii?Q?nzPDzX8UU2zLZwwIbj2F2CQk2rMdATyG2J8CWs7Tm28OjdX7JhQ5/2JmGgbL?=
 =?us-ascii?Q?KEPFCjESa4NvSA7XbWl9t89dx4pAyuEiZxtdzDlfJ9/wFb74cDiSNNJeRZs0?=
 =?us-ascii?Q?LgwWXy0FuEL5Y6SeAlFCuURTnaGu5C8yn68uiGsfEEBvDSBBJdTbD8N1kIBp?=
 =?us-ascii?Q?SXXzdNVCMSy4ePs+E3HYeI6qXJZximHBwInDLkjgMFz2qV9QHbpIuhxKeduI?=
 =?us-ascii?Q?5NA0EfhcQiRe64cEmezKp573BnPsSON0lESdQPiY2sfGAWecA/E9bJOUc+dU?=
 =?us-ascii?Q?oWJw1wUCC2AcszcIAFsemqWNRraZ69r1UzHrrA3Haldb85QH81FtEufg4Qtc?=
 =?us-ascii?Q?IIe+7Sb8GaEGG/v7v8JT73QAah7V3vloVuuUZp8e66RjIJMnNIvsBp7MllFE?=
 =?us-ascii?Q?nQ3iJJoqteorphGLaWPM/7cDz2bERkQ5yewaeZ9K52UwnL7pMtcA774GOo8j?=
 =?us-ascii?Q?Cz1NYhKUrse46Ay5WNyNZ44sHdtRlvgvISpN1tYiV3a/6fRyLVQtLUtQy5SI?=
 =?us-ascii?Q?mvWvi/0QioZOcN2lGn8umE4Y/VsIHIWmVAQMj7lmu8JpEOqGDeJ/wEA3bv3o?=
 =?us-ascii?Q?7hFL29Tbw5UiCy3dEvFzRukwi4ALUCh0Ak5hnaluxkpWT09psJEsZaM00mij?=
 =?us-ascii?Q?ivN+DcKTw8Q720u6SxZwK0/kXfZdYMerjzojqFK8ArOYewnEQOhsDCBES7v1?=
 =?us-ascii?Q?yGFSfLlhdC7WCOf38Zdyxt5MvTNrm6EZ7KuwlPLt1AlojlbZaah8jM+AmwMY?=
 =?us-ascii?Q?KlIfFv0AIsuiAWMvMKUMJOgLNEHSI+TbN1NBLslrewaY/5NKNhhtQLqPDfVP?=
 =?us-ascii?Q?rHs743X9oGSVqidEGfBdSpqUtURW0xoLUVgucpbZOo1cbsb4UJAhtJ0s4C0+?=
 =?us-ascii?Q?hBdVulYk+h/sQqBmGJgcwcRRDAhykoBpYcE41zx1+D/94cxPSnxCfW3APTsE?=
 =?us-ascii?Q?ZPJB9eGpT26eoz823dqV/fE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2da0f7b3-2365-4b33-b75d-08d9bedeb6f8
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:50:01.4990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UdrICyUtuejRhXNEK4yQKwoarn3WBP3IjegiuhEiytwu5k4eW18xDHdK8XodCjmzrlhbgp0Khp/YtyhSMffL6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140049
X-Proofpoint-GUID: m2vNyyLewfnlPr580qwgRWyhde-2Q166
X-Proofpoint-ORIG-GUID: m2vNyyLewfnlPr580qwgRWyhde-2Q166
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit defines new macros to represent maximum extent counts allowed by
filesystems which have support for large per-inode extent counters.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_bmap.c       |  9 ++++-----
 libxfs/xfs_format.h     |  8 +++++---
 libxfs/xfs_inode_buf.c  |  3 ++-
 libxfs/xfs_inode_fork.c |  2 +-
 libxfs/xfs_inode_fork.h | 19 +++++++++++++++----
 repair/dinode.c         |  6 ++++--
 6 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 37d9d47c..9dd24678 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -55,10 +55,8 @@ xfs_bmap_compute_maxlevels(
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
@@ -68,7 +66,8 @@ xfs_bmap_compute_maxlevels(
 	 * ATTR2 we have to assume the worst case scenario of a minimum size
 	 * available.
 	 */
-	maxleafents = xfs_iext_max_nextents(whichfork);
+	maxleafents = xfs_iext_max_nextents(xfs_sb_version_hasnrext64(&mp->m_sb),
+				whichfork);
 	if (whichfork == XFS_DATA_FORK)
 		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
 	else
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 58186f2b..bdd13ec9 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1061,9 +1061,11 @@ enum xfs_dinode_fmt {
 /*
  * Max values for extlen, extnum, aextnum.
  */
-#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+#define	MAXEXTLEN			((xfs_extlen_t)0x1fffff)	/* 21 bits */
+#define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)0xffffffffffff)	/* Unsigned 48-bits */
+#define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_aextnum_t)0xffffffff)	/* Unsigned 32-bits */
+#define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)0x7fffffff)	/* Signed 32-bits */
+#define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((xfs_aextnum_t)0x7fff)		/* Signed 16-bits */
 
 /*
  * Inode minimum and maximum sizes.
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 06b6c09f..9bddf790 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -358,7 +358,8 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		max_extents = xfs_iext_max_nextents(whichfork);
+		max_extents = xfs_iext_max_nextents(xfs_dinode_has_nrext64(dip),
+						whichfork);
 		if (di_nextents > max_extents)
 			return __this_address;
 		break;
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 627eb23b..17265401 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -743,7 +743,7 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = xfs_iext_max_nextents(whichfork);
+	max_exts = xfs_iext_max_nextents(xfs_inode_has_nrext64(ip), whichfork);
 
 	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index b34b5c44..7d5f0015 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -133,12 +133,23 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
 	return ifp->if_format;
 }
 
-static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
+static inline xfs_extnum_t xfs_iext_max_nextents(bool has_big_extcnt,
+				int whichfork)
 {
-	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
-		return MAXEXTNUM;
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+	case XFS_COW_FORK:
+		return has_big_extcnt ? XFS_MAX_EXTCNT_DATA_FORK
+			: XFS_MAX_EXTCNT_DATA_FORK_OLD;
+
+	case XFS_ATTR_FORK:
+		return has_big_extcnt ? XFS_MAX_EXTCNT_ATTR_FORK
+			: XFS_MAX_EXTCNT_ATTR_FORK_OLD;
 
-	return MAXAEXTNUM;
+	default:
+		ASSERT(0);
+		return 0;
+	}
 }
 
 static inline xfs_extnum_t
diff --git a/repair/dinode.c b/repair/dinode.c
index 8b6cd60d..0df84e48 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1804,7 +1804,8 @@ _("bad nblocks %llu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (nextents > xfs_iext_max_nextents(XFS_DATA_FORK)) {
+	if (nextents > xfs_iext_max_nextents(xfs_dinode_has_nrext64(dino),
+				XFS_DATA_FORK)) {
 		do_warn(
 _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			nextents, lino);
@@ -1826,7 +1827,8 @@ _("bad nextents %lu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (anextents > xfs_iext_max_nextents(XFS_ATTR_FORK))  {
+	if (anextents > xfs_iext_max_nextents(xfs_dinode_has_nrext64(dino),
+				XFS_ATTR_FORK))  {
 		do_warn(
 _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			anextents, lino);
-- 
2.30.2

