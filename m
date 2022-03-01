Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CD2FC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 10:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbiCAKk6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbiCAKk4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 05:40:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BFD6E8CC
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:40:15 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22188opd009931;
        Tue, 1 Mar 2022 10:40:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=d3lMqiif1aKxdn3iKKw48ManH7yGbbzd4vjwDIFeWlo=;
 b=Xegpnm4yqjiHYCTYJbL13wmA8W5RhearKUmN8adWJ9AfYK2fs7T39THKlz2wBum2rgXl
 oQfG3p+leuTnC7+GhIlgPhqKeeWDN76XayNMypGF0gIqc/6te4jYGtPOH43ZxFjJwBSt
 lMnsimlVoOY8ONCVPKMI/oI73LiImNyIlmn4xucIwTGy6LBJk2wAXrxcT31t/3WGPPi6
 NgDge9TBHv2sRZyEDJkG8HKgvBatIMxi4QoGFSiwUePWn6R3WKSheH79qIJ55ME97367
 TMiHY1i+2JV+1JFDGdoVCb7Fhby+PQHOow1hN8zxg5QuK4+GPON8OEcYcFuQ+MKiSKTv Sg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh14btdmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221AZJCP042941;
        Tue, 1 Mar 2022 10:40:10 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by aserp3030.oracle.com with ESMTP id 3efa8dp64g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctcI9DC9WoHtN/VUieneEPJpg84MFJUQcfYOmj6Dntt9AbsO8sfdGcOTT0Bw5gfXBBqOmp4oeyIO6Y1Z8GJqGrAnQY2ApibGxEB2A1Q1Vl/0+H1T6xLAvo0Ca3pvPacGt74/kA20Dt9sU9dBB3qy2RBCRQXuAAkiF9PyKlEc1z7Dm0Cjx0glNL+UIl+lFgaxCKKBf4Q7LAg3m5R6mJHirTsnl/KUO3pegE+MdnieyCob9ROwH6Q7Gk4Y3XEQnKEfTiHH2HKPBw50ERDi/xRVuwBak80QNXvcS6pahE4a/OUgVxFzSMxYZ4bjdg34QitFySuhwjYVcBKrOP4RvHd3jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d3lMqiif1aKxdn3iKKw48ManH7yGbbzd4vjwDIFeWlo=;
 b=KNdimf5UxrJ9H/F5l2+NPF+Sy/7tpB94XehybcvCsoczju3LS+w0Ss+/vR/V8z4yNepn83ZWpw8/iMpjdXFdk0C6NqnLL2ZxwjnRgWmKxnjAJ2ZD21v1icATbcZZWqGHFmmSWr+xSeL7jDnyy6jY+EyxpEs/TVIhkI4ojftiNswnia1YO4C63HTwYDUV+TdrHzKgLweNji8pgUKnNbhopYBBgDRLXEKGV20WtFWmgXO9HakBnEdpTWU0msdiROIEMdENW5E01TE8Kdsxgj1jlL+NUsAGmcI8ElvJyET9mfjlGHKbxmmTD/3lRlbPS7HTo7/VFvNKuV6I/0BaF6YlVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d3lMqiif1aKxdn3iKKw48ManH7yGbbzd4vjwDIFeWlo=;
 b=A6viJS/y5s6sbwBQCOm1ntrGq7VHK0Mn+Njkn5OB6tTg3b3BlhLAy/PjDHu4vhdeE+aHLIb6XyXFKhvqON0Ktiogrmzt8EnqgjryUa08I5qFbUIg6OD04YvaODzYtzg2b1vnzCrJQv7jLWB77KuUthGQdFr4zt0emQwmPZQdp+o=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MN2PR10MB4160.namprd10.prod.outlook.com (2603:10b6:208:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 10:40:08 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:40:08 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 04/17] xfs: Introduce xfs_dfork_nextents() helper
Date:   Tue,  1 Mar 2022 16:09:25 +0530
Message-Id: <20220301103938.1106808-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301103938.1106808-1-chandan.babu@oracle.com>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ddaea69-576d-4233-89c0-08d9fb6fdac4
X-MS-TrafficTypeDiagnostic: MN2PR10MB4160:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB4160F2944828132D8CF2ABCBF6029@MN2PR10MB4160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3aj54G73U0Wk29UP7uAZiou4EUKaWl/hC6TGvaJ7PVNXYZIAW48CrwHb7NyyFygWuLTOgfUgrUDp3bI+k6gJ+r24O8Gya15yUQkr96JKRNN5xEOWxSmzP+Z9KFG6ZPvGdaB1pakKfZ2z0qW7m6aHG0wL5M2EYZbV16f+IbaB8Olg6ulofNUE+h5mb0TS2100QC2KjXXup3hAQ4K+1mHVD9Jm1eiEO8hInq2GiQuNEScWtXecB3xF9BteA/D9XhRxzy8IPKiNfgCLhee7dVHFoPRZwPztRV23Da7SydGPiupKTCgtcnwRtpeshA4nqEcMAyfgP4mRaJhYfifRVR99q3yWU4WJ5keyorTsj6OsbYm1QJpTxcd4lGbb75tTeqqq0n3UJWzUd1GSbV+5GPCFhDdOic42BAZJ9DEvi9pjX/YApTnE/zHFDSQBKBw3Dfyb8fjdv4H88ekz8BjBJlK4vHq+sdsnw4mVwQM9lgFzmxYpg50soQbgIEwxTL71o3h1t+wsn6rKmYosCSpINYK2ozEZpGWnFEVepjWkZfH9wE/V4gHpR3NnQS94RUe2Sv2z+ovf6PZ6OUxSga35A1S/iXAkuxS0HNdBc4oiruztnYiSuL4XYTBUoOgBb3gKfT68u3TfSuA6wbg8H6vUHulAeJ94L06ZlB5gJP6bZKwqir5+4mt++iJGfefzYGw1Rl8ypg/xbrPPq5D2yQF6O8u/2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(38350700002)(186003)(83380400001)(1076003)(2616005)(8936002)(36756003)(2906002)(5660300002)(66946007)(6512007)(6486002)(508600001)(6506007)(52116002)(6916009)(316002)(8676002)(4326008)(66476007)(86362001)(66556008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yBUO8KPe3ar6yZBDZNUpw3Ms3afK1ICPane0fXZWLyfyI82O4ELabnxDI4Uz?=
 =?us-ascii?Q?MtgHftHvqMo2OFxT5NYU7ZknXdFXm0DjZYZHIHPYFUcrlNExuXHumVhAgPcX?=
 =?us-ascii?Q?wUmECBEnEsyw0LO7MEEWoI2ZM/nEoFvU8r4zfDzQrqGg4sOg2LTPgj0qCOad?=
 =?us-ascii?Q?8oc9XTuHiFZIUMtKYy3lOmcyHuQIgH77DQJgxFsDZva42XONfykMowsXiyEp?=
 =?us-ascii?Q?Tgi9VZ83UBXmcG69m512fMGQQt0+rhUnO+nbOHrazyBc+fzMpBOeH8ALqV15?=
 =?us-ascii?Q?IQbF6gOEUh3t43rckSRrg559zqeSmzwGQ7CwcFkuOTYxSblWpGrGpLreVtxa?=
 =?us-ascii?Q?z84sFkd0JkEIUNRLtmf1xtYqE7sYnx4aMt7ZCIjOrm84THfTkLTo9xjSYuaN?=
 =?us-ascii?Q?Esizsy4xiNsQKVBK8qwnZ5Z84e4mq93za6uTJLIQc5PLeQa3K7j/dzhDcFUy?=
 =?us-ascii?Q?NY4HiVW6KSWsN5ysXJYba0ZU9buWEk77dHV2WgoURf5cNBI1wZPBimi5iHsv?=
 =?us-ascii?Q?0aHldpA4E1nmOY+kq7Q1CsJosOziYOvzfnuX0+uREcafgMbqo9uNO4My1Qh+?=
 =?us-ascii?Q?V++1ZFjIya7qXnu21xIeeK4e2iYjr3Gsjp5h3+kpnkkvWRzPW2qiJN0NHVkp?=
 =?us-ascii?Q?wGczpmDlXCulvSE106m79fNX2WD/FHUaQ8GDwloWJNk0ZaQV4fvR6mRqQKXo?=
 =?us-ascii?Q?cn0sut8ZdLp1NAGeE38MoxdyJ6HCR1vbwzqJKvY69ZLHWU4jw5WKrAUxGNC8?=
 =?us-ascii?Q?ofpUop5OweCdW/V0V+DcHcFO/iFXvE7vkNWFMB2vcfQOQSIc3t31tX2hrPmh?=
 =?us-ascii?Q?4+x0nIydF2cKbVURT0PHQnBwBZVaTlM4f3lh3MedisPdF6kJx3nKvYU/xwLJ?=
 =?us-ascii?Q?lq2hCGWGsVHKvvvC08aKtRcr1Itwu4auC3eOzA6Tzeh12KP5cH+zLuJSYnHW?=
 =?us-ascii?Q?XoK+O1Ltb0nB81R7Wz6lmUF+Pog9+J1+4U76c7QRcSiBJp1/50LXpsXvADb/?=
 =?us-ascii?Q?TXFl35EDMutUYsA75cKe1OsSy9B/ivDLY/gM0c1Ry4LsUdFCml9J+ycanygH?=
 =?us-ascii?Q?o6K9LQXbeIWQeMxGvnaJ1ONzj7r+d1pRwGjjdvfIeFAyD2O/d3iVlcOtRRIb?=
 =?us-ascii?Q?RKbXTXF7xDPJuZuz9Q76WTFOGKpblHEdf/mDg242ubcq1zbsRQnEvSzBRZif?=
 =?us-ascii?Q?XvCIn90GUikyKbM0RCQbWPpBGGTDzrL7uNTRlQQtbiB+GIKRJeG94Ac+Ri0N?=
 =?us-ascii?Q?/B4JCC+voY9F7ZyVDqJ4M5qMj4qvzJas5z4wMJPql2R11eSAuz1RpuKaOc7K?=
 =?us-ascii?Q?0aS64QWwwl23H69Q4bXxa2WQSZuZAp7KdcPD+vrG11XWsV4zeA9+GG6nBEGC?=
 =?us-ascii?Q?8i7dSyqtzHFZNNfNoyarvY6pY0wYrtdcwEMszxtf3UxUHlq46vlMmKLn6/Ta?=
 =?us-ascii?Q?7zb8miLkyqWz+ihXnDFA2qt7GwCjA0sIm0gNf0QHHI4hKiGHPrFKffRnR6H+?=
 =?us-ascii?Q?gYeageYPl8vHt11ttyN2IP7GXKJ/tTjiryo0nKmBcyeT1v3IGfvavWjMDbkA?=
 =?us-ascii?Q?uSArIPsa31/kMvLLAjEPs5r+yGVkgFOZzeCWCdkyYQPGtnzzXFMSuuKOH+Fv?=
 =?us-ascii?Q?9Js91u5KLGOSgLWhE2REmD0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ddaea69-576d-4233-89c0-08d9fb6fdac4
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 10:40:08.6911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7+bG37+V+7KsA8woJDpKihuNt2LxHiB8qpHsJUidvLQC0u7Mopphdul79PKYXsSdckAULBULzi2phjAjK5JR+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4160
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010056
X-Proofpoint-GUID: AIenCeCpGo1AlXhu0lmfzFKmEi75v-my
X-Proofpoint-ORIG-GUID: AIenCeCpGo1AlXhu0lmfzFKmEi75v-my
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit replaces the macro XFS_DFORK_NEXTENTS() with the helper function
xfs_dfork_nextents(). As of this commit, xfs_dfork_nextents() returns the same
value as XFS_DFORK_NEXTENTS(). A future commit which extends inode's extent
counter fields will add more logic to this helper.

This commit also replaces direct accesses to xfs_dinode->di_[a]nextents
with calls to xfs_dfork_nextents().

No functional changes have been made.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h     |  4 ----
 fs/xfs/libxfs/xfs_inode_buf.c  | 16 +++++++++++-----
 fs/xfs/libxfs/xfs_inode_fork.c | 10 ++++++----
 fs/xfs/libxfs/xfs_inode_fork.h | 32 ++++++++++++++++++++++++++++++++
 fs/xfs/scrub/inode.c           | 18 ++++++++++--------
 5 files changed, 59 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d75e5b16da7e..e5654b578ec0 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -925,10 +925,6 @@ enum xfs_dinode_fmt {
 	((w) == XFS_DATA_FORK ? \
 		(dip)->di_format : \
 		(dip)->di_aformat)
-#define XFS_DFORK_NEXTENTS(dip,w) \
-	((w) == XFS_DATA_FORK ? \
-		be32_to_cpu((dip)->di_nextents) : \
-		be16_to_cpu((dip)->di_anextents))
 
 /*
  * For block and character special files the 32bit dev_t is stored at the
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 5c95a5428fc7..860d32816909 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -336,9 +336,11 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents;
 	xfs_extnum_t		max_extents;
 
+	di_nextents = xfs_dfork_nextents(dip, whichfork);
+
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
 		/*
@@ -405,6 +407,8 @@ xfs_dinode_verify(
 	uint16_t		flags;
 	uint64_t		flags2;
 	uint64_t		di_size;
+	xfs_extnum_t            nextents;
+	xfs_filblks_t		nblocks;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return __this_address;
@@ -435,10 +439,12 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	nextents = xfs_dfork_data_extents(dip);
+	nextents += xfs_dfork_attr_extents(dip);
+	nblocks = be64_to_cpu(dip->di_nblocks);
+
 	/* Fork checks carried over from xfs_iformat_fork */
-	if (mode &&
-	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
-			be64_to_cpu(dip->di_nblocks))
+	if (mode && nextents > nblocks)
 		return __this_address;
 
 	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
@@ -495,7 +501,7 @@ xfs_dinode_verify(
 		default:
 			return __this_address;
 		}
-		if (dip->di_anextents)
+		if (xfs_dfork_attr_extents(dip))
 			return __this_address;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index a17c4d87520a..829739e249b6 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -105,7 +105,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
@@ -230,7 +230,7 @@ xfs_iformat_data_fork(
 	 * depend on it.
 	 */
 	ip->i_df.if_format = dip->di_format;
-	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
+	ip->i_df.if_nextents = xfs_dfork_data_extents(dip);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
@@ -295,14 +295,16 @@ xfs_iformat_attr_fork(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*dip)
 {
+	xfs_extnum_t		naextents;
 	int			error = 0;
 
+	naextents = xfs_dfork_attr_extents(dip);
+
 	/*
 	 * Initialize the extent count early, as the per-format routines may
 	 * depend on it.
 	 */
-	ip->i_afp = xfs_ifork_alloc(dip->di_aformat,
-				be16_to_cpu(dip->di_anextents));
+	ip->i_afp = xfs_ifork_alloc(dip->di_aformat, naextents);
 
 	switch (ip->i_afp->if_format) {
 	case XFS_DINODE_FMT_LOCAL:
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 2605f7ff8fc1..7ed2ecb51bca 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -141,6 +141,38 @@ static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
 	return MAXAEXTNUM;
 }
 
+static inline xfs_extnum_t
+xfs_dfork_data_extents(
+	struct xfs_dinode	*dip)
+{
+	return be32_to_cpu(dip->di_nextents);
+}
+
+static inline xfs_extnum_t
+xfs_dfork_attr_extents(
+	struct xfs_dinode	*dip)
+{
+	return be16_to_cpu(dip->di_anextents);
+}
+
+static inline xfs_extnum_t
+xfs_dfork_nextents(
+	struct xfs_dinode	*dip,
+	int			whichfork)
+{
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		return xfs_dfork_data_extents(dip);
+	case XFS_ATTR_FORK:
+		return xfs_dfork_attr_extents(dip);
+	default:
+		ASSERT(0);
+		break;
+	}
+
+	return 0;
+}
+
 struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
 				xfs_extnum_t nextents);
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 87925761e174..edad5307e430 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -233,6 +233,7 @@ xchk_dinode(
 	unsigned long long	isize;
 	uint64_t		flags2;
 	xfs_extnum_t		nextents;
+	xfs_extnum_t		naextents;
 	prid_t			prid;
 	uint16_t		flags;
 	uint16_t		mode;
@@ -391,7 +392,7 @@ xchk_dinode(
 	xchk_inode_extsize(sc, dip, ino, mode, flags);
 
 	/* di_nextents */
-	nextents = be32_to_cpu(dip->di_nextents);
+	nextents = xfs_dfork_data_extents(dip);
 	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
 	switch (dip->di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
@@ -408,10 +409,12 @@ xchk_dinode(
 		break;
 	}
 
+	naextents = xfs_dfork_attr_extents(dip);
+
 	/* di_forkoff */
 	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
 		xchk_ino_set_corrupt(sc, ino);
-	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
+	if (naextents != 0 && dip->di_forkoff == 0)
 		xchk_ino_set_corrupt(sc, ino);
 	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
 		xchk_ino_set_corrupt(sc, ino);
@@ -423,19 +426,18 @@ xchk_dinode(
 		xchk_ino_set_corrupt(sc, ino);
 
 	/* di_anextents */
-	nextents = be16_to_cpu(dip->di_anextents);
 	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
 	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_EXTENTS:
-		if (nextents > fork_recs)
+		if (naextents > fork_recs)
 			xchk_ino_set_corrupt(sc, ino);
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		if (nextents <= fork_recs)
+		if (naextents <= fork_recs)
 			xchk_ino_set_corrupt(sc, ino);
 		break;
 	default:
-		if (nextents != 0)
+		if (naextents != 0)
 			xchk_ino_set_corrupt(sc, ino);
 	}
 
@@ -513,14 +515,14 @@ xchk_inode_xref_bmap(
 			&nextents, &count);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents < be32_to_cpu(dip->di_nextents))
+	if (nextents < xfs_dfork_data_extents(dip))
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
 			&nextents, &acount);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents != be16_to_cpu(dip->di_anextents))
+	if (nextents != xfs_dfork_attr_extents(dip))
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	/* Check nblocks against the inode. */
-- 
2.30.2

