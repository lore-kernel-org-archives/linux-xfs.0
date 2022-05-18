Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4434DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbiERAMw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbiERAMo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:12:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E78349F17
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:12:43 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKMwc5019084
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=jpxF76nxvQZdedYr7G37ei0LDFcicP8s7io+/7W3fDQ=;
 b=xlm7IKO41K/ASgsohmGoafFM/HD8T1WkQr4Bw726xtVKMXRS5bn7loc9b3nYeZmA47Hp
 3K6RkpJim0n9ctofGxZRPuTDk5Rv0opx4cPeNAEgx+8fziXQnollOkHXtzKZYISkehsa
 6e9DQaoYhVrWK+pKgUiMj2kjOT1ksQFLq4M2JOs8OUlATI7EZlwNB+CXnqwH8eghJFNS
 jYomnK3qtu8qaBxS92Jxtmckfm9WF8pAwCyTK60Fv/GwOIlPw+tJG7RUW/rolD9Mkbf4
 wMplzsXu9m0/cif1TcUZX54EHQQllyMZg72yC3tDDGIOkVSuwwg7SpFD6FsKzRNYB9JD Ew== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2371ywdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:42 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I0A1OD021321
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:41 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v3nd6n-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRIbG8ijmN4yXPEijgY0QkftmRzBR4dkDdaShANDqSQIT9cC8pbFg/cX/5ZRxQZAjF4MYLAiyKwdsOZondWp2adoN7nlMQbJukliZ2j2sPKouekkXYEafG+lkEAqT4SQqpGn+skvuYuaoxfxsGQf5MG1PQFX5kKoChPQgxSKsZaDtEIDV+7jxfDSVaeISQXpMPPSzp0Pmxxh9dY74rWpd2ru6ZxniXprTPRQNK2zJGY1pLLh+/dl048EBgnqxNVIVhMtS/oBvkprG9RfN+SxOwV//DJXqI0o/rBk+8rohiN7N7MBr934ESBWM17fBSnGhji+iJv6Zt3RtywAMRXYoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jpxF76nxvQZdedYr7G37ei0LDFcicP8s7io+/7W3fDQ=;
 b=IWHMFWMcTcxaBJCtGOBKFgQUDC4JFLG4tEsPCn6/n1UaP1R3PNuPN4GS/qlqAmft31GzcyBkW9+YEPJ0cK6l5R1jHkN8NSy85rfCW5k941RJkj1yPKVA2rLxU7mOWVbEAWWNPlupsbUg+hKOvdbSVcyrQlDFJM4+b/dMv8N+OX+8JL4WXNxXCjmJxlcVhqXISdv9MYyvEj89CS0t/kD0TXH9fBvc3YgjXuHXrfDMLukyrAfpd+cz57+skMq0dckrIXhVUX6oSft1kWWHfwPnkiV9LaUB4bRpGlS7j+JGVjg4FkC4f6kRowR7pAKRpNjhHtXE/Pgg99Whrqf1m/HuNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpxF76nxvQZdedYr7G37ei0LDFcicP8s7io+/7W3fDQ=;
 b=aYe6f97MoaL8Ce+LVpLKMjZ/4nt9vzJn+leerJBZTyV7Q38F965e1EFzhCKDzTbYh2juPxmEiHLqcZu6oSR6l6zqZSV+N9ETurkeVaf7JGLsQAE73CX0YcrLVEUOCEVX46lsoSeP5zldH1xZ31VHkV2Du7B5RK/0zE+sNKT0Hg4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1528.namprd10.prod.outlook.com (2603:10b6:903:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 00:12:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 00:12:38 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/18] xfsprogs: Skip flip flags for delayed attrs
Date:   Tue, 17 May 2022 17:12:18 -0700
Message-Id: <20220518001227.1779324-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518001227.1779324-1-allison.henderson@oracle.com>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7deeae6-8bc2-4858-c565-08da38631db2
X-MS-TrafficTypeDiagnostic: CY4PR10MB1528:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB15283F942EB599AD255EF40F95D19@CY4PR10MB1528.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gy43yFy1n1MfEejd3qlN8sEtZlZuIZnSbfuG09sdXlUJLedNmMwwm0KNAAajBF570zhfKuixBfFTCBRr0RpfLMAMo033lRytbArdFT4U1KPUhNBfPqzdlSvJ/GsxUqH8E+C/jJ+Js8F47CYE8A1tnw8Ao45Q1yrlKAT3YBV6L5CPN9xMGii1J7dHsZgN2t5+plr3oM19Rmr+/lpCuh8VuXbfc4LezC2h+NpDhMsjQ0RUtwyy5SVdJGNNn+XL6SdXrXsUuNJEZyoxLr+ZS4xKpFdczZOXp6GvbznzqU6a0udDqc7Ys57NmsuXcgrSiiN9qa9ZuPDgHHdBm10LyGqe+wojuSnG5+aOBOLrlYe9nnVwLBcztjWdhV6WIy8MpGncEv+tL7YifsWa654ZPRogdLpaIQXFFlFzLCXdmo/r8dR7NjmJHOu6gI+atUBjMFludZgBYg5ilDmzOuQTqAzbj22PFlDhUVyCJ4pmeFyKt3rcADJM31WO7kBh1JbXcFr+GT+ZbQjkIk53BzN+7S0Wtg6KBJptGQ+fhfBvWhotV3aiTpbsvCAK9s0JnQZfY+yTlE21vj+0Qv9X5rJBifBh4NT4UB1Q6e58T71PH6O2nARC6lEqBf6Pl87KoQQV1+r49N3JlFohirMEPtFgNlIdqvrack77Q6g4HedMXzecdY9YBEGJ7B+jgLwH9wdCTGHkZW+OQxHRG3fbo06pELNDGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(508600001)(38350700002)(38100700002)(6506007)(26005)(6666004)(6916009)(66946007)(44832011)(2616005)(2906002)(5660300002)(52116002)(316002)(66556008)(8676002)(66476007)(6512007)(6486002)(186003)(86362001)(1076003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l+n2T2mdPIothfd5woll2zL5ESaoro6JAmyiA+QAopKxg+VIcNAqKYt8svxo?=
 =?us-ascii?Q?FA0QMHcxNvCvoFfc7z1ycXwtq87XqUiqHfXG5yoTx5nk++KGIEe11SFmB1Nz?=
 =?us-ascii?Q?TPfSCWUVqQn6Us/ENKKT8qKWu74tcON7EKIxrxR5pnK7JTpeEtabHr4NJMR3?=
 =?us-ascii?Q?g6Uziv2RjmQ4Y6sp0I1THq90/N/u84C3njMpXCK3rosVJSM11Tw40AOkkyJQ?=
 =?us-ascii?Q?j95dWN5+xxySumiKFfZwP3bIgoRCqOYDBv8DcQ6UCwVV2OintUVwN89fRQUi?=
 =?us-ascii?Q?51LopyZAefu32AScCGJKFxef1epI5GIJSOmYJfLC0E5XV9IY2pDyomcSjqjI?=
 =?us-ascii?Q?yMaKnJAUpZhCM5cOlNp8G8iKf3OgGbXnJzOj6qQ2kY3kNXc27npk5j2+yXbm?=
 =?us-ascii?Q?4tyoLwnVlwshBGzd+t1+hP2M+FFSm+L/0kVUaYFSBh45TmNIb2eTQRStSANz?=
 =?us-ascii?Q?5hWssG7P3uih9l7JYe/h/IkOj1TIYfmGOMzo+SO+FTDY7/62hxWE9LEibeZw?=
 =?us-ascii?Q?zKGD4/BYIaHp8vAbJrP9GEGzgDy+n+gwv7IaMoLvfkUT4OBLml3qsn7uJOCC?=
 =?us-ascii?Q?v98NUTvLx8sPfaV2ywcIt2Akj58B7nU1TsuAkfiryCqwIowu7wuBfmTak004?=
 =?us-ascii?Q?kEFl6JhkZw3fxYrCILuG+CLFBw05sh/FvG/jRSuaK24zmpzjkzLS0HbxW+v4?=
 =?us-ascii?Q?8RM986reXwNpZhQW03NMh0dnH4qFdbKvNsXC5ITxcT8ktLDFE3o8K3Ip95w0?=
 =?us-ascii?Q?x9bC2JLQdbkh2Dce1SP20e9u/8pElxrqQ1ngwouAA7mqJuSjCX7zYBy4mBU5?=
 =?us-ascii?Q?XuemytoxhGmWCHHM07pv706n3csAhxA7W7NPr2nXhy6uJ7VZeOntdo5tFQdX?=
 =?us-ascii?Q?hbkZIkAXnt8H4UKUSuQimHuhlWUu4ZT83tGpsyz6Gk4/wSk//H/Nnp5hJ/Xm?=
 =?us-ascii?Q?9ay8h+cTMcU+sY9zrYvZeMe+CwcanxCpXG91v7FNzRz9u1c7fX7ZPlH52Iuf?=
 =?us-ascii?Q?VkLzGduPCloO2ohzWW6zSJoCmeiMcEPokkEC7GS9NLekaO62X4nInt6eUbfd?=
 =?us-ascii?Q?/VSU8tf+uNbQ9V1VkNuwhU9wvh/ARpv6lyKeCaQgzRoffunTAmB5k3xYtiso?=
 =?us-ascii?Q?E/fvenJdtL5FUflDUPpqNsT0x1Gc/z8n8eGI5Y0ovInjoWI2g44YOznYgD6R?=
 =?us-ascii?Q?hbbBMTVMZ0LtdS7UQas8Ls4SfKk9xbIP4z87sLrN3F1g4FJxiD4CY+HJ8Mon?=
 =?us-ascii?Q?UFykyOQtyoIUhQH90UX6a2/bbkEvS3sxUt8SxlTAy99cPFUifAp7zAfTk598?=
 =?us-ascii?Q?kj/tk5Nd+IhDc5R/1tqwQVldtpcnRSq6uqIlxlqcRlSVM98IvTeve+S4Jtro?=
 =?us-ascii?Q?OfTfJ8nDy8scNdyEha2O03HwUdxbvJIcXkG/iLFaNfrm+qsmE0x97P7KvAR+?=
 =?us-ascii?Q?kCGe1wM6IbWfKw321j54fboVfCB2CQgn+UgudsmF/yZGwG6KxeaW4XoBFOaY?=
 =?us-ascii?Q?TSSeRdLl8zfa3h/YE7J1fy+R/C7w04+xz3GFi5wMWZmnjzgEFRLTL6cLSbVh?=
 =?us-ascii?Q?ptV3itwHPRAWk1fdKN3vbgNNbqeJ0seVYgPqwRVGWIoBykaCHfvqxQyqftYh?=
 =?us-ascii?Q?N64ErckW+Zwm2eH8sR28MITdR572ROUcI2LQa+sQKti2+YGVyfNygr7h3piY?=
 =?us-ascii?Q?LvS+Iw0nXc0UmYmgQRfHTgRjUu5h0svhHNREqeM/pHD/8eWiN7LNYyfDbswk?=
 =?us-ascii?Q?ss3ZsX3Z/1GRgYm5O69lsncTliG4ZLc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7deeae6-8bc2-4858-c565-08da38631db2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 00:12:38.0331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i8bRXJPbj5s8tviAN6qDy/19NMzeymOtktfCPJ7X4rxOaWa3C9Ru0p/1IcIivqE6AxlesGUGsz0J4x/Kv64YWMMann1dGdfFezLYeArNChQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1528
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170143
X-Proofpoint-GUID: nZMc3kEg1zh4Fz2MnpZsVY9IhPzTy3-7
X-Proofpoint-ORIG-GUID: nZMc3kEg1zh4Fz2MnpZsVY9IhPzTy3-7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: f38dc503d366b589d98d5676a5b279d10b47bcb9

This is a clean up patch that skips the flip flag logic for delayed attr
renames.  Since the log replay keeps the inode locked, we do not need to
worry about race windows with attr lookups.  So we can skip over
flipping the flag and the extra transaction roll for it

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c      | 54 ++++++++++++++++++++++++++----------------
 libxfs/xfs_attr_leaf.c |  3 ++-
 2 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 76895d3329f8..6cda61adaca3 100644
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
@@ -1232,6 +1242,7 @@ xfs_attr_node_addname_clear_incomplete(
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_da_state		*state = NULL;
+	struct xfs_mount		*mp = args->dp->i_mount;
 	int				retval = 0;
 	int				error = 0;
 
@@ -1239,7 +1250,8 @@ xfs_attr_node_addname_clear_incomplete(
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
 	 */
-	args->attr_filter |= XFS_ATTR_INCOMPLETE;
+	if (!xfs_has_larp(mp))
+		args->attr_filter |= XFS_ATTR_INCOMPLETE;
 	state = xfs_da_state_alloc(args);
 	state->inleaf = 0;
 	error = xfs_da3_node_lookup_int(state, &retval);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 31eddb543308..45d1b0634db4 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1484,7 +1484,8 @@ xfs_attr3_leaf_add_work(
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

