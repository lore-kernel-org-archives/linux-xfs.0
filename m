Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC245C4167B
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A343761B5F
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbhKQETa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:19:30 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:36504 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233032AbhKQETZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:19:25 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH2B8TR030343
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=FpPiTYUbP74HDDJFOHuJalSEVmXcFXE/7gYYkPAIkuY=;
 b=mzC4rGfIGqMkbj/t6M0fQXQreyi8flSJmt0E68ggK8zZShEZQjn7/d4zvKywQvb44VOL
 aQEU+dKUmkFahBImAMpFFFBQyS4o2hNda79DtWNdlgVh9hxKYT0sSKLBUcxZ3jvglfx7
 EQidCvMEAmhhn0bKSX36CUe22GradrHfApPQmuov1W2MSwXB4itvLgeuRThWrUA+GeP+
 kcpSzWVG45/80OogATEYFBeZ/Vh6kIb+DzA1EWJ0OTILdBWxC1jZ+GVadubvvdcCkfCY
 j4VoaXKIZm/0oUxP2IU4jL7SfEkrMWonN7r2M2dXMMIzrizTPXHfW7LNWKdSKk4FL+Vo /g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhmnwx85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4AEKn180636
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:26 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3030.oracle.com with ESMTP id 3ca2fx6ayv-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wx2k3rkQKVo6kxB00xbLF0+5AQ0ZUmzs818v8Y7wpvqiwjeWuWo/BBuNHc5EkqSK+I9NL9V8vLoLd0KkS8ZKQU6I4w82koNtGCA5Os/7+5WFEYcMtv7hDlGC6seG6bTDPvZXmi1Tl1FoqDXRWnwvY9r24KxRd2VbosF16hYHlvRluUWB19emLZmZ6CtxvyRV+bUbeolP7CWFIPPmrfH3YYX+gJ54MvMiWQ+4af7+fjEx0zX19ssj4kLkp+Cv/K7F6m/GSu/AUdoPxWguoQU33k7PJe35g+/Hh//XXwQ8GSQD2OA3HK/tSiyhkRCQnG64CbjaM0vqk9q3EvUA3CO5kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FpPiTYUbP74HDDJFOHuJalSEVmXcFXE/7gYYkPAIkuY=;
 b=KOoHiYfAWxH4w66Ps5KoUvR2LmfddPSaRA8B9oPS6SZ6WrLWREXTGSy9oF8FDBCFpdz/R90sf5TAJ7o/hnuCOg0bkCxae//TADBJwM5l97xgGuHiC7jcm0pzQXKbmG1Ul2FKiS54W6Yk6E7NW1IPVNQnep9YxAjAZupLBr57NqhsPEsjziiiVv/ubAej2CmAK+Q6wv0giHhO1iE907O3OEk1krqzaU7S9JmOgaMo1SKmz0QxLGe7lvUIBKwmK1maqpjSWj5RF3wapmAjRwC2sE0CvFxDjFouXAfX0LFk0DhOPAeUZXC4HLYPI8RXgvcySwIKuKilJtg+Wsy+M8AXGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FpPiTYUbP74HDDJFOHuJalSEVmXcFXE/7gYYkPAIkuY=;
 b=ZRC1RLpGXp+ZY0ghYCM6qyc2g1UzfUxTbazra1ncL4a73/9A/Vi4nJTNYfj1QF2r0/9uIOUI4aVIPDPx/o95pePBod+UFS2QlCoVtBKp0fZqp+Gvru8n6Zol00rovqqT/2W3K6qK/o8I/ViTxC/Tq8FIPPgaEK4Igk0C5Fgcp6A=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4036.namprd10.prod.outlook.com (2603:10b6:a03:1b0::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Wed, 17 Nov
 2021 04:16:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:16:22 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 08/14] xfsprogs: Skip flip flags for delayed attrs
Date:   Tue, 16 Nov 2021 21:16:07 -0700
Message-Id: <20211117041613.3050252-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041613.3050252-1-allison.henderson@oracle.com>
References: <20211117041613.3050252-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:217::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY3PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:217::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Wed, 17 Nov 2021 04:16:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c9bb3ab-2d10-4dc6-277c-08d9a981036c
X-MS-TrafficTypeDiagnostic: BY5PR10MB4036:
X-Microsoft-Antispam-PRVS: <BY5PR10MB40364518B86F4FDA2EA842C8959A9@BY5PR10MB4036.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:792;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O2y5H4ulQ1nR9QbCWwo9oxDNtjgUB7HpzjbFErsLE4GGgO6RVD0QspGIT6fcj9uAFl3q/7FHX5EEMOfUwyAx/7RnX2L50QRp51q9ioZyRUrx/hefb99PdwDAaGLyCpmnpubiv5hND4E9y7hIt7mcBsD5nNw5Jbj05mA4AlDv1iaXNQ9t5h//huTHdoaXQAgvONuwAGjTyLgMe7FRhGb7xZqdhVUZxS1WdAnGrL8HpXfDPFue3PFdB87mpZ8q1Y7rPbhy1FUVFPNyhbVcOhVNTl40OYZcAOCC9aUrhTz5zvz2X+5comUTED0/W0kasmWNT638t2qiR9KuSqF2wD+PUPcuH+OE0y7ZsjTBeUqMjNItNx+bPEDMdH0MyX0qGAECkGqeYZtmS+bOKT6o+U1wTpCZfKv5yCu+AtdDmm/xY0se2+8pYokzIGFdL6UhVp9c0x6xymZ8XJE3C4opksj0FPGsx1Tm+g6XKfGiChn3ENtXgxoHSUziKrM8XYchBNMQzAR1EwXsO29L7uQ+RctrPTj1IF2nzWogWgammmyiU9rdyVR1pSkXwHeK4XVFUcnfEIYY72kdoTtgbEiQq9bHnBGjG+6lcVv5PUJRVj8KhoZZs/qOwKtyBIl0Z5oeNvA5WG8UnsWdVwU5haWRrVBREH/8z++lU/3wZoh3yy9OM6TNc+K1JcHLi/jgpuaCOZ8gRyxOU0rODF/xZ+AQH4sPEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(6916009)(956004)(8936002)(6486002)(26005)(44832011)(186003)(83380400001)(6506007)(8676002)(66946007)(1076003)(36756003)(2906002)(52116002)(6666004)(6512007)(38350700002)(38100700002)(5660300002)(316002)(508600001)(86362001)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sJFnrA1WylKvAYCoZFvf3bcfRXJqKRp4p+aBy+5uSQeGVZoryTv4xnkAdmnY?=
 =?us-ascii?Q?sNmUbyTKfx9DorDQwtcn2Cp4dyBi7XgF3ArKN4lONU/mej++hflZiCnkaFRQ?=
 =?us-ascii?Q?Pj36XZPcxMhTip0LBKwlZGduVQPJHq31kmj7mBfL40TGKXJdCB33jdJYvwwc?=
 =?us-ascii?Q?vqrwSzzFruKjdGNFoZWVV8wirNYCSdh4tahWXab7BN1nA61eeTobCQIKt6zv?=
 =?us-ascii?Q?KOLIijjjU5i/KGkequmU/V8TPZe1krsWVAMFwCW80QYyeJZMvRyui5lIjpfM?=
 =?us-ascii?Q?u+b5zI0Ri1D6svEpkd9QglxMIF55+n0O3aQNue7nn7ZFUPgK0OfdhgeQ1ZZd?=
 =?us-ascii?Q?24WvmUKgvCRPUD0sm9vu//HyPySJlkkm6XkvVSvdAm1fcq9GAWB7plSB7dtE?=
 =?us-ascii?Q?383IzT27PlPMn9vQLyTpfx3i3CyubdxUe5vxuOtV7Jbo9b91wsw4H3iWu95h?=
 =?us-ascii?Q?6v5BSJAjKKrLs0BqVosWoOGZcGoHbW5AKD95/L0cY1E6QIGfRYLUsKsaEa51?=
 =?us-ascii?Q?MSte/hvQI5OTCCuYnOFjkxyk9plj+K+3wPMB/EKDOR+rA3QOawMqcULjAHDr?=
 =?us-ascii?Q?S6UvgGup42aEemSpT0Be6C9qqg2GD1U7h4Au3yRiWG+0bzU1wY64PdEJYvEc?=
 =?us-ascii?Q?qNS6ycN6ZlFpCzq58Ar8UC0UnCkJdNsQSZGLGigOtOpu60LyOIFyFuMHIKc0?=
 =?us-ascii?Q?8KKKZSkl0CFH3ry4HpUHLjNQSItng1iumKpsuh/BhlpX1kbdosxLska6nXfC?=
 =?us-ascii?Q?Q2BgI1FOVOY14m3c/CzQJ9O/3HLbd3cgnCwvNuGuXvtf0N/QRf1tBSVLDbhi?=
 =?us-ascii?Q?de78fWn7mZf6+wVSJZDIvkc+iqlqQPq+vwYi8zY+dgpNE5whlbZZ3/NBuEJY?=
 =?us-ascii?Q?EZALwPeCchxK9NRhFTHvitNFh6KQ/OzWeYtsVKEpaUTTijC2lGva1ySeSl8S?=
 =?us-ascii?Q?+t5up5qixKWp7CdHchb+BfbDcpxBmakYJ/eNLGS/WpNeqBTz9XKneRaSAKBI?=
 =?us-ascii?Q?A32BsmqD869ghvd8P574lW2ZLIJRkOEUlo2uiKdh+2kHngaUL9uSgi7LpTha?=
 =?us-ascii?Q?oT+JBDACeeM68dOTt2kkmQ2FrHaiVFguFonKIKw00yJyxCcueUPcU8LP3IVz?=
 =?us-ascii?Q?/et+axTXZ0AeMBpzya+8ivz8vTN3yjO7hfL5DsGWxHaAOkgdFI1Q5yjqtXLH?=
 =?us-ascii?Q?J6RESOweWuEnVT9IpEO+ZvtaLIVFEXFkjwKmTYFxskWTZmzD0Xgcm8mrWNqQ?=
 =?us-ascii?Q?ZmNrPpPuIsSWvq9GqVltCgGri2fmcTEzR+gZ8lHXw1Dc/laShaFXsnYibckz?=
 =?us-ascii?Q?urWKXXQi5rG2bCTuoSpY6GluVBMv3qOg1bM9IowN2/Sz9QatYF1jzJUr2mUs?=
 =?us-ascii?Q?qURnD/vLWGp26fbmqip2O+YaW4NJKsV/sBL4JIN6/0Afv+a6mTG0eq/Psx6j?=
 =?us-ascii?Q?8nZcfg4fK8/Jh98PAlfX1UTmBqEptuUlZtMKpmls5TuB0R7ffEPU05rhaRw3?=
 =?us-ascii?Q?pDUcssclaALk00QBPPyv/NNYrBZGmNFP+7eZ+lBX7YFgIOYJT68K1y0dDVa3?=
 =?us-ascii?Q?xQlaYMbflLZ3yWoEFNla4Ql52Snz/ZkL2pvbz12p22B3I32Y0wDeaNPNxIV3?=
 =?us-ascii?Q?aZx/DkaLs75qoabTxLaCspX808cMLUWM1EXKuA7Sjts/6voJ8eyoATbP8v/t?=
 =?us-ascii?Q?1N38Tw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c9bb3ab-2d10-4dc6-277c-08d9a981036c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:16:22.4175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CVZ8gAKUPWYppEWN5j8Qtnowu+7Z0Il1iqyGUGWsKPOP7ZOR+/X4nU5IU+n9mbfRya2mXjgYJ8e14jkKRXyXhYdoWwnpBo7iBrb6LeyNCJw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4036
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-ORIG-GUID: INWLxvi-iSDtiQMvoggel8hXs3lfjNhi
X-Proofpoint-GUID: INWLxvi-iSDtiQMvoggel8hXs3lfjNhi
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 2b1c81a8c3f453ba16b6db8dae256723bf53c051

This is a clean up patch that skips the flip flag logic for delayed attr
renames.  Since the log replay keeps the inode locked, we do not need to
worry about race windows with attr lookups.  So we can skip over
flipping the flag and the extra transaction roll for it

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c      | 54 ++++++++++++++++++++++++++----------------
 libxfs/xfs_attr_leaf.c |  3 ++-
 2 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 61cb7ea9ff5b..6306bcf1d1ba 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -354,6 +354,7 @@ xfs_attr_set_iter(
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_buf			*bp = NULL;
 	int				forkoff, error = 0;
+	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
 	switch (dac->dela_state) {
@@ -476,16 +477,21 @@ xfs_attr_set_iter(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			return error;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series.
-		 */
-		dac->dela_state = XFS_DAS_FLIP_LFLAG;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
-		return -EAGAIN;
+		if (!xfs_has_larp(mp)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				return error;
+			/*
+			 * Commit the flag value change and start the next trans
+			 * in series.
+			 */
+			dac->dela_state = XFS_DAS_FLIP_LFLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
+			return -EAGAIN;
+		}
+
+		fallthrough;
 	case XFS_DAS_FLIP_LFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
@@ -588,17 +594,21 @@ xfs_attr_set_iter(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			goto out;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series
-		 */
-		dac->dela_state = XFS_DAS_FLIP_NFLAG;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
-		return -EAGAIN;
+		if (!xfs_has_larp(mp)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				goto out;
+			/*
+			 * Commit the flag value change and start the next trans
+			 * in series
+			 */
+			dac->dela_state = XFS_DAS_FLIP_NFLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
+			return -EAGAIN;
+		}
 
+		fallthrough;
 	case XFS_DAS_FLIP_NFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
@@ -1236,6 +1246,7 @@ xfs_attr_node_addname_clear_incomplete(
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_da_state		*state = NULL;
+	struct xfs_mount		*mp = args->dp->i_mount;
 	int				retval = 0;
 	int				error = 0;
 
@@ -1243,7 +1254,8 @@ xfs_attr_node_addname_clear_incomplete(
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
 	 */
-	args->attr_filter |= XFS_ATTR_INCOMPLETE;
+	 if (!xfs_has_larp(mp))
+		args->attr_filter |= XFS_ATTR_INCOMPLETE;
 	state = xfs_da_state_alloc(args);
 	state->inleaf = 0;
 	error = xfs_da3_node_lookup_int(state, &retval);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index cfb6bf171090..6c0997c51fd6 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1479,7 +1479,8 @@ xfs_attr3_leaf_add_work(
 	if (tmp)
 		entry->flags |= XFS_ATTR_LOCAL;
 	if (args->op_flags & XFS_DA_OP_RENAME) {
-		entry->flags |= XFS_ATTR_INCOMPLETE;
+		if (!xfs_has_larp(mp))
+			entry->flags |= XFS_ATTR_INCOMPLETE;
 		if ((args->blkno2 == args->blkno) &&
 		    (args->index2 <= args->index)) {
 			args->index2++;
-- 
2.25.1

