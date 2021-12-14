Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB05C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhLNIuY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:50:24 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47528 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhLNIuY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:50:24 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7LE8F022068;
        Tue, 14 Dec 2021 08:50:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=qJaR9aYPUdMDay2IHt8rgVgOhxvq61yKuwGDyIJql+0=;
 b=omWnlmkN2RzWQhhVZWALpwh0Xdod/GpjOXjO7HNkMXUj/Q8+LIVorqyPr9c02JbXL96e
 WlXkcQZJnZM8kqrHGsVPg3CsF0I2YVQGCGXo+/O99eupM7crMD3BMves4rPgYWk/R24N
 g75NwtGpmTpDo7SdiEo/ecMo6bfiwCqfYEN1bLnGLoDwT0EHVfkFWnKOVg/xajTGbrQG
 qB+ckVZE1Tzp5c8xp01YfsY8D/WToCmbXGYgqzLOoxFwG0aGusMTLGcpfvpy9vVllrFZ
 q0s95jL2nXzk1JljV5stPPoQl/JVb7iw5g78cOhppIHTIxa7HHRqCJRAPmS+VJJk8Gr9 hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx2nfb6me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8fXjt156399;
        Tue, 14 Dec 2021 08:50:20 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3030.oracle.com with ESMTP id 3cvh3wy897-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ku5wGeX3zzQ5wl0ZHg3dN3arHQev3bP6bAFn/a6kc4RqpQpk8jzIy8X5OM6Gm8Pg+ms2H0JNiEt14AEWOz8o7Y+lXwhxuKkquRhCg0QTwqRh+qSI0bDR/UuHZlaVVbPp1ha73BVdHxGYxRiwJRH15s7LahdxSMW1TwXlvJmQX57YX1DeFgm2aOg0gCGMch7UH+51qmDcYewqyU80gOhTZSjzpOf7Ny0R7rCzoEgajoFS2uXqDRvDevzzza2XizzPlMrBj/7IyaKWaupgJ9Kj39AzuT+jlLFYpEnYMD/0QneLazkBXh/j+gNgWkTfF+2geU1P9zYLfdoLLAmy2LBrGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJaR9aYPUdMDay2IHt8rgVgOhxvq61yKuwGDyIJql+0=;
 b=hfTo0qyXDv2QYu9pTLVQyCsIjHI3PuMaI2ykOuWJ6Gh/PVvQqyKpNXCquL6Juv7iJOS9HS6i9E5b3WERbpQcsKqX5F+hdRaYnhbWQ0AimmgrC0zOdsofpSZpLD4ragELarDpHznaeya9Ydtc4L9cNJ7ZpHn5czn7dq5Hilz48t9f/+Rx+eC4Cqsq1XJS2xvc0HZGPP58RsiD7BK//lFGTXZPHwciFpOmQwSsb0JCQIxF8ExScOtYqUdRWx+alTtCvZTuQ+2HqB7zFFCuHujogwB6JiD03G/GYTT11F8ONGRQbNZ4nT7nmhMZS15Wi1sNGOVFX1UawoJJmi970N97Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJaR9aYPUdMDay2IHt8rgVgOhxvq61yKuwGDyIJql+0=;
 b=FiW40mAgLk5Qt5h2hI/PYHj4i1yAe3PA/SB/a86ks5FHMBm1rDyr5sEnDsYmJfHfnaWXcSyk6JYnlJnoiq29HzMsPggp1BOP6ioHBDyBfIH+5mmG6ygvkA9dN1TFbNlxcRqxe/PnTNXguqt8mdsTNHHdpZZlaSiatCLo8/KhA70=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4555.namprd10.prod.outlook.com (2603:10b6:806:115::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 08:50:18 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:50:18 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 19/20] xfsprogs: Add support for upgrading to NREXT64 feature
Date:   Tue, 14 Dec 2021 14:18:10 +0530
Message-Id: <20211214084811.764481-20-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 998621d8-f6b5-4af0-2c20-08d9bedec10c
X-MS-TrafficTypeDiagnostic: SA2PR10MB4555:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB45554C47DFC23ECF6F63BDC7F6759@SA2PR10MB4555.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:256;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qhcTIFYrdmEcbT+LbvlizDM+GIB+Kt+1dpip1OiyDLMUV73vY3Yn4zIpryToENPnshxGEVB4VvnsaxwsorlA1yhd2KLSDVGmXX/lP8b/fBI5z7lbkpUSqkEPpmsWFPeNkU+tLK+/nhyTufEAjRAVFvimQRNahYmxP3zTvXGj6l0xXSw5AWHRyYEOi5F7L2sDB8y+dkPn9sH1R5ZBSr2+y+Z72Ct7SQkzH0VTBUIHDdn+cSpQ+OOWfBRX/UVrAlAxE2GoGQ84GXe4ELjCQYnX2tjwDv/zAMggfwfarmTV+6Eydx14tuag2KZPuhyvZfPRib7WkBtfW7cVMG9chKAFQ4UoTwYOeXo+68XZMOLOs+7GMB/RduqhVZkwWE/Ghqh+O6f6yOYR6n8b44FAwp1wxwKf2yvPO/l0KElgEFpx/S93OprEa4yPm8qEDu3c3W+3/D3Ln0Q/HVS7gVeYHArFZhM4YzLiHZ+vffkoiKaZI5GCilOYlBOyjgyIcVgke4CEY5LlJADlemHNWGOPwZnZMdlMlou/f0GPYWfxj7ys+BfspPYN1PUy6nvjMP/Vp78HxDWVPCp0DlS1ndxXgB5delBmCPVVyEeHsfz/bpf3ECzTsz8x4J697++8ybH9XtlbjACB5FQK6oqzbIFd89D0207VHF495aYA1cEVyovbkzo9+aUKm3fmlH2Amg2l5AtddiRTKqM/5XI2qKEFe/YLfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(52116002)(38350700002)(8676002)(38100700002)(26005)(508600001)(316002)(2616005)(8936002)(36756003)(66476007)(66946007)(1076003)(6506007)(2906002)(6486002)(6916009)(86362001)(6666004)(83380400001)(186003)(4326008)(6512007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nAzASAigz4NoGnGyDwzQ3oRI3RIyiGrNTxZ8spBdZ7Z+XCRyLSj5D5SKW4or?=
 =?us-ascii?Q?5MgE7r77p8uggpy2GQt4Pp1Ts7/jA8InAEUHvWue7URFcr61TlZZnXOP4C1Z?=
 =?us-ascii?Q?Gaa0tEIsSVEZp2f4O7c32QYQqHg0MFWYNlR7TCCqAn7N7TlN6Vw5yDVApMab?=
 =?us-ascii?Q?9eVCkiT8q0RhgRp1CW35C/pKbmrnQ5No+VQyRCiv3CssWv742esx8yViBuah?=
 =?us-ascii?Q?eNoWycx5VD7tCHkrfinSKYP5XmkDwzHUE/hZxVYLCS7vwIfE1g6PdFRcRT1o?=
 =?us-ascii?Q?Rth4G5BOZimO97Q2UpVUCM7+DbeyLmqVO+T+VeAqQrrnCRwyO+3KNFzS+2u3?=
 =?us-ascii?Q?v72pgAt+JFv2FO1qf9gBaTfi6PaRQ0xJgtIe0l3zJf4BQD9Eh7LRjgfdR+Oa?=
 =?us-ascii?Q?yTXcYGClpQPYerAlezmd/dGB34ohteTcG8Z/d94F/E3coSQQrWIiCBT0mPqR?=
 =?us-ascii?Q?5xKQN9DRlNnzjDS0nOIJ7ls46QJBWiRILe474xNOgHLt51bUZ4xRJMGSlYah?=
 =?us-ascii?Q?i7O/uaIQGzS/V/neAfFK4dUFfxBl9Bqk1yAwMacIASUnNp/15w34FKxTWPIs?=
 =?us-ascii?Q?WQMH2SRDp1d1yTEViaKyTlnJ/03eZtdc/iQCICRYlOPsyniFSYvvndAUxbmS?=
 =?us-ascii?Q?2zeLufTr6BvOL78pSn7ZKN+ynTOGRVVdTQCIFey4scLKYQ6jBQqMMkBQii6H?=
 =?us-ascii?Q?oa7dYVhq0XPIpncEEtDWi1J0XfuOVm1IzX9urbB7EjQiEInAr8cBRtAEmrOi?=
 =?us-ascii?Q?/1Lp2E07IWNJUdxG0tu54s8ee4MhtZ7xh2OSycdy66E95py+/WLnaX3x3zge?=
 =?us-ascii?Q?KJHOK7gx/1NsrMukfmni1Ae/l/yWDkvClM+OLYuVv8m+qtkAcdxWSIEo5so8?=
 =?us-ascii?Q?vpZCfMsRAIw35X0Hmmy+uzv9V2EiLE2VeozFcGhl5dmqQyPRZaJ83JSk4Nnx?=
 =?us-ascii?Q?a60OIIIgOvSBbpVgUn2TvCuaeOGZ98BCNckiQtVlnCxA3Fqyc52NJ4ak4qQz?=
 =?us-ascii?Q?G513auEFYRHb3jd1cZzjI/OxiIEVoUJ7ZJqJ2/OH4zGSfItKnwtHyezvaoon?=
 =?us-ascii?Q?LwBqVeg6Kx4x2Fk4BurSMNCQRv2/bJ/BRa5BeNfUSE4E6D7HF5LtlpaZ/fyg?=
 =?us-ascii?Q?2YkqnNqEXKuksqhAP3WON1Ece+eRXxemrtqdhfTHqcEdsWk5zGINPEjJ9SGn?=
 =?us-ascii?Q?NRNHwAK6eAy+PZD9YFIa67ldpl1QW/W2woGuvqe1mbLo/TnFUgoN0BNbCcOe?=
 =?us-ascii?Q?cRdW2UA+5KeO5ym2R2RclL+uQ7kAY+ywMAP+xnmTd1GP2Eu7UEPlYFOynMqr?=
 =?us-ascii?Q?DcG0l4qqyZrYUOrniUmZ/co6G4Kb3CBYELonXHt4786BfzSbdOUFoxHHhEZ6?=
 =?us-ascii?Q?KIjWBCE2YKgwn5meAgro0MFWmw2zEeL77FnCCDjGRBWmEnAocqN7mWywGn3a?=
 =?us-ascii?Q?but7NxPRC8wQIlEiwOaLXR3ARW4Eve0VjtOBdsFQYxpzn8uFK7+AIFdQsL2D?=
 =?us-ascii?Q?2IfIupJ8Sxg65Tu1a+FunFNGJjHcbBRp1+GElY5xN0NQsPZqMBsDoLPD2Qnq?=
 =?us-ascii?Q?OQNU/6VNeLuWJGk7SlBEdCIt6iiRnnEyIl5luSVtP/3WcMb2rKo0hoQ+gUOc?=
 =?us-ascii?Q?mfhfXm/moU9WFFEiuwYE+pU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 998621d8-f6b5-4af0-2c20-08d9bedec10c
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:50:18.3838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BvplRemWvVopLX8/f4/wnTZOKNzxnBA7TCbUjXurpgj160C9tGxoqGmWaPMax3qBc9l2drb2KtrI+clO2XcR6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4555
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: 4vcyLBQNE_2F0nOHew2GzTcZC2DYx0pB
X-Proofpoint-GUID: 4vcyLBQNE_2F0nOHew2GzTcZC2DYx0pB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds support to xfs_repair to allow upgrading an existing
filesystem to support per-inode large extent counters.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 repair/globals.c    |  1 +
 repair/globals.h    |  1 +
 repair/phase2.c     | 35 ++++++++++++++++++++++++++++++++++-
 repair/xfs_repair.c | 11 +++++++++++
 4 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/repair/globals.c b/repair/globals.c
index d89507b1..2f29391a 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -53,6 +53,7 @@ bool	add_bigtime;		/* add support for timestamps up to 2486 */
 bool	add_finobt;		/* add free inode btrees */
 bool	add_reflink;		/* add reference count btrees */
 bool	add_rmapbt;		/* add reverse mapping btrees */
+bool	add_nrext64;
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index 53ff2532..af0bcb6b 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -94,6 +94,7 @@ extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
 extern bool	add_finobt;		/* add free inode btrees */
 extern bool	add_reflink;		/* add reference count btrees */
 extern bool	add_rmapbt;		/* add reverse mapping btrees */
+extern bool	add_nrext64;
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index c811ed5d..c9db3281 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -191,6 +191,7 @@ check_new_v5_geometry(
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 	xfs_ino_t		rootino;
+	uint			old_bm_maxlevels[2];
 	int			min_logblocks;
 	int			error;
 
@@ -201,6 +202,12 @@ check_new_v5_geometry(
 	memcpy(&old_sb, &mp->m_sb, sizeof(struct xfs_sb));
 	memcpy(&mp->m_sb, new_sb, sizeof(struct xfs_sb));
 
+	old_bm_maxlevels[0] = mp->m_bm_maxlevels[0];
+	old_bm_maxlevels[1] = mp->m_bm_maxlevels[1];
+
+	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
+	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
+
 	/* Do we have a big enough log? */
 	min_logblocks = libxfs_log_calc_minimum_size(mp);
 	if (old_sb.sb_logblocks < min_logblocks) {
@@ -288,6 +295,9 @@ check_new_v5_geometry(
 		pag->pagi_init = 0;
 	}
 
+	mp->m_bm_maxlevels[0] = old_bm_maxlevels[0];
+	mp->m_bm_maxlevels[1] = old_bm_maxlevels[1];
+
 	/*
 	 * Put back the old superblock.
 	 */
@@ -366,6 +376,28 @@ set_rmapbt(
 	return true;
 }
 
+static bool
+set_nrext64(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+		printf(
+	_("Nrext64 only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_sb_version_hasnrext64(&mp->m_sb)) {
+		printf(_("Filesystem already supports nrext64.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding nrext64 to filesystem.\n"));
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NREXT64;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
 /* Perform the user's requested upgrades on filesystem. */
 static void
 upgrade_filesystem(
@@ -388,7 +420,8 @@ upgrade_filesystem(
 		dirty |= set_reflink(mp, &new_sb);
 	if (add_rmapbt)
 		dirty |= set_rmapbt(mp, &new_sb);
-
+	if (add_nrext64)
+		dirty |= set_nrext64(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index e250a5bf..96c9bb56 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -70,6 +70,7 @@ enum c_opt_nums {
 	CONVERT_FINOBT,
 	CONVERT_REFLINK,
 	CONVERT_RMAPBT,
+	CONVERT_NREXT64,
 	C_MAX_OPTS,
 };
 
@@ -80,6 +81,7 @@ static char *c_opts[] = {
 	[CONVERT_FINOBT]	= "finobt",
 	[CONVERT_REFLINK]	= "reflink",
 	[CONVERT_RMAPBT]	= "rmapbt",
+	[CONVERT_NREXT64]	= "nrext64",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -357,6 +359,15 @@ process_args(int argc, char **argv)
 		_("-c rmapbt only supports upgrades\n"));
 					add_rmapbt = true;
 					break;
+				case CONVERT_NREXT64:
+					if (!val)
+						do_abort(
+		_("-c nrext64 requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c nrext64 only supports upgrades\n"));
+					add_nrext64 = true;
+					break;
 				default:
 					unknown('c', val);
 					break;
-- 
2.30.2

