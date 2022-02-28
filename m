Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25FC0C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 19:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiB1TxM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiB1Twm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 14:52:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B6EECC54
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 11:51:59 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SIJKSa018833
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=piXmY+S1S6x5J8G42q3OPS42p4KfHP7SjH6+nGTm5Xw=;
 b=c8n2vFh7YzSNIAATmmQodC3Ko87aiaeqDA8D6r6bWtjFFrluYQ89w4pLJAAAfxM3Bkz4
 FNAmU+kRwgI80XIkAbpQZ+RGURjdo+5yE8Ky5UPi6/Z/Z2kkL/qA3ZmNWXyE5cqBx83m
 o91kuHqWW0dmbIIQ0125Rgbr2NyIRkpyrv0kFpy6H6uB7r1hVyJOyt7M2h7fMq6SP6Wl
 YFAK2SKlkL9Yod2x68kgFBkXPSQ50izLsOUcjwu0JHPHZMosiYzCvUG5rMfrnYwlEVud
 OoS4lw00WSDNL/4RV4mcudGoVjS9CgBRndxrw7LkfVE4066RklekUwZu823FZvHopiTs 9Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15agqt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SJkltm076550
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 3efc13e3fr-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnjqogAiwdStDZehueG+SyqGdvvIDISxZMkotd21YP/T5jOjcxGFxqP52IrTRG+3q4doqva2XUGa+LzdvBeP7k77X+j1IyhkeWVDgCNfetU0MAJRBQArbk4Isa62tDBmUEIaGbe+hrfaemBO+pwbuzLMEvrDxcgb2pfUwrVV3KdCohquWUgPa8HYfJSdH2G4BziOawi4Cf53mOUFV/mvWgej093T09qFbB3yGmmEM3jHsVG68apRvqP404ExmQUEK8218ci/maec5lBuabsK2sbl/H30al9Z9U7lX6zirkgiKv3iSZwgBU0h7vQVWwiPhHHrmtBbKn2IuoBVswicWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=piXmY+S1S6x5J8G42q3OPS42p4KfHP7SjH6+nGTm5Xw=;
 b=CaIw/bwB2E9venSg7QYpqexWuP06QldOOdX5dDvKBHxHvyGRpbQQEtXlMnqM58o5kdKpMRXNLvIq9oY2gJr/pjo46gelifoX3DF34jXYYdwdmwFgoGTVJ4NpT/w7QBK8HCd1TEVL6+yfYQVrw8FoToZFeorVhtQuEjDHdcOMOjpMUCL0NlJL8ndm+1/U1TAUiEO0HcYPjr3TWsZS+Kh6looitaFIUi+SwK2kkeXtONVS1DyP6tix+4Dnvg6AgL9MsAfeHwQupC+9lQEaRpbBUAzHEggfqdT7GepD9B9PygzpcuVjF7/pwgd5YqKRcj2aLkjMx1QSsMzrC/uWzba1wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=piXmY+S1S6x5J8G42q3OPS42p4KfHP7SjH6+nGTm5Xw=;
 b=J1I787qUVvFNn5Pw9fO7gxFI8W+egkgKh59OPxljiJKjomtzSrHnISnS0bu1qI4WulI2lgA4qsLfNuZgeIqgk0odSreXJIBSx1vN+KAvMaqrO0AdC1PTrI8GD94GxrI3BoqBVndN9VFu0EORyvpNBSyl7qLXCqmgGjWOKvgngao=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5612.namprd10.prod.outlook.com (2603:10b6:510:fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 19:51:56 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%7]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 19:51:56 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v28 06/15] xfs: Skip flip flags for delayed attrs
Date:   Mon, 28 Feb 2022 12:51:38 -0700
Message-Id: <20220228195147.1913281-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228195147.1913281-1-allison.henderson@oracle.com>
References: <20220228195147.1913281-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4939e3c5-8ca9-4414-fa05-08d9faf3c630
X-MS-TrafficTypeDiagnostic: PH0PR10MB5612:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5612C5DAD62032E4DB828C5A95019@PH0PR10MB5612.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ieLGStJBhA6joUEf+Gixa4Iss2cCnDQVxFfzAZiNYHUTvhplqpTzLNMi50XuJCFicqJIrA3OE+sWJXX/fgl+ncRFtAiSdzzWCb27KedmbO+b926Zb1GVFrcH0Q4qnVTiN06yj4a/6gZhjT++a3uLwei3K07SWH2HLZo0yVSGIsjjcxnrtcTHJKbPsTtcTXNAm6CThq84IHJbz4UnUX2I35t4ZSCCTpx3E8jIakHmfcQun5NDCVu4Spa3E8soqhqtZZK3LER+2gAnA7yhTiDdwUZ+jkENlzBU3/rPVUS5w+aMU3qF+s0DPCRFi6o3sh+nCK4WhBMvmTw5Ui7bg3zNHjG/NeqOoFIf6kWjwy3Pg0MbEEazOgMfgMD8qjV7paf0EqslRd5Tzspv2viyR9BgPwGG6xutly9h0WxGmgrxIN2G4/yXUMfMI1Dnql5evRRnda7a89vr0XbY7762y+JHANSugI179zpmp7u0I6p13MeU3gn9XS7PECy984cPWZbYNDZOUrcr5iX/o+v1sSECuIvijA2Is0es7rjNRqmWMktdYeqkCOWmQC0uGHC7kcZJrWZPHClPQOYc3fZt3Dmy3Y1O0/R6hZDnIBAk67wCA21S4AFwM9BVdnj/kegf0VwrVA1h6EdZzI7UGzJB4ppxc5A7EIkcVBWJFRGFOQpwdTu9oc3w6llVLMCapjBG/3jCoBcsa0kwXGluscG5L+ItMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(86362001)(186003)(8676002)(6916009)(1076003)(316002)(66946007)(66476007)(66556008)(2906002)(2616005)(6486002)(6666004)(6512007)(52116002)(8936002)(508600001)(5660300002)(38350700002)(44832011)(83380400001)(38100700002)(6506007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5LNg8RDvQ0G2SChhB+seuXQ9i8iJ319A4oU8VY3fdS3fxrjde4VKxcOLJ+b/?=
 =?us-ascii?Q?ptW2J98OjF83rSyiqMEWL7+wff3eHW6sXp8q4rHQnv+JnhCUSiyg3zj+LD8t?=
 =?us-ascii?Q?LmNH3HqLs6mtSHEZCM2ScZ2DoQlPZf1B6IEvYzhyh5YaKn471Lgzm1pcnuYk?=
 =?us-ascii?Q?KJ6qBvswA5hkUlXI+HEN1fvIDSFPbI+AQHzxLgu1PxWs6dH+PimZsrZ62J37?=
 =?us-ascii?Q?jap4UkMuN4b6VHjyGPYZ0ptMVOZ3uCkJeqm+CijdbpTqEGnJDOCM53WqUDfY?=
 =?us-ascii?Q?Wz9F9bRz13ZCp2qfDzZkucjQYbidGCPLs4iL4e5x4GIRSs23nhncnVj3ENdr?=
 =?us-ascii?Q?l4UVKd8NqPnYM2onggma9aa+Su4sWFb1Gc8Tkz83wiTmZH/u6t9ggeHYo3l7?=
 =?us-ascii?Q?rtivm5719UUsXI26N+NDM5tM742Dh+bHfIY1fXhNqhamTzKxy+P4KiWHSwF3?=
 =?us-ascii?Q?mq3APd29buYgN2hUFVIKw++D3VnExA7bhELcDxBmDp6AeSAr0Es4o5caQ0yY?=
 =?us-ascii?Q?4on+tDKAbZZr2VaX5UXfWZBmjkeVRYXwTgajqrFv3EQIkcbuu6/xFHO+zJw3?=
 =?us-ascii?Q?wyU/PI56QfypldbMUyyLxk1GKQb6F171c2I3/tW0rK0bMVQMV6RZUCRHPDHB?=
 =?us-ascii?Q?ysUYMll4rRIuO9xdvCmhXz7gJqy4dyfxrfMPOU+irDbo7FUlKziK0KXsv2W0?=
 =?us-ascii?Q?i+KIT7dKj+UvBX0VcvjVbEvwuj/Y9/v+MKlzFiUmoVOnRo3YUOR0Pu0171Ig?=
 =?us-ascii?Q?Y7YnqzfKqHfqkJdUeiQURNPL48hk6trjN+Sfw/JFovJUsB6/gy9gDgGJWsRX?=
 =?us-ascii?Q?BLnxBVy+17rNBLioIq/YBRnaqYrHyJ7aXMyqHWOsfdRoz20Gntf3HVhNvwsn?=
 =?us-ascii?Q?NuucErpEnn+vGlvnsGHFYyGTgz+tsV/q2568wRjz2ZTN5TxC2zQKIWWM2c7L?=
 =?us-ascii?Q?J/7/U73TT8J8BIZPFkKStu6EO6j4nu9h9GvaKLYwFeglm9bj7DkTmhmwV6JN?=
 =?us-ascii?Q?aDxY4l8QlRX+dHjVqfEaNEt4+D/R8xTf7r4xBXg3VTg2Z+l9gOzQltED/EJm?=
 =?us-ascii?Q?oqYjU+dRyi9bd2LrlmmFzOKglK8z3yG1vpFoI0Yezr/RvTAXMfSsQnrk7J2C?=
 =?us-ascii?Q?757deGe6pQ/H6NbvXsKErzJi1ZIMh1xoQhJQMW4C5c/kVQN2FR+5z7ZCj/I/?=
 =?us-ascii?Q?pyzTRkbfejxXHHLzeCuhLJhfNKBJxAD7YQychSTc0u8COYjzzjby02Y1wf+N?=
 =?us-ascii?Q?7nAbfB6IRoWKoD3PH9lbzBOIoszMtMcvpg14A/TlEQvKL3iLW5tARmhwBl2q?=
 =?us-ascii?Q?g+3Fjnb3Ae36xP6+ZZbJblfhE+A22Oe5k3qdeUcP4SHQ9UnVF6U0creKJLkn?=
 =?us-ascii?Q?AF0UWdY0GeP08EijjGB8I+Wu5BJtlHL/YmhNEptXWnPRfPKdTPAt6GX42fri?=
 =?us-ascii?Q?jounxDpkRq4kFBcBA1rc4PPGUt2OVFzpbv/L6L9CeBrohZcpgE7QjAydLBxr?=
 =?us-ascii?Q?LaMXrGQrdLufmdjUWtjTHEMZwPn+xnSOegLrzx2EnXps+ro9vCQVWke0yCJs?=
 =?us-ascii?Q?L3GqQbCm4/oo8A0cpLk+8cKO55luz6B4n1c+bnx7q9l8OFcTLVMRGMLQdkno?=
 =?us-ascii?Q?JMaXiTlTehd9IZ9qyN0U/c6LGwAAHYvS7b6BZIfbQIwajClYimHnQ1ViCFjK?=
 =?us-ascii?Q?0XGKxA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4939e3c5-8ca9-4414-fa05-08d9faf3c630
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 19:51:56.1387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D4Wc2wFbt5xqMhTGpAqYifWXggdr5bIERK7TlB45Pn/nviRnhY363hB6rfBGbzRiANrIqlXljmAhXiOLHWfEqFVRdE15b7yJ5gKGXfDzeaE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5612
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280097
X-Proofpoint-ORIG-GUID: lSHSwpq0nKy0B2IAmdoot8MMSluhY5RK
X-Proofpoint-GUID: lSHSwpq0nKy0B2IAmdoot8MMSluhY5RK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a clean up patch that skips the flip flag logic for delayed attr
renames.  Since the log replay keeps the inode locked, we do not need to
worry about race windows with attr lookups.  So we can skip over
flipping the flag and the extra transaction roll for it

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 54 +++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_attr_leaf.c |  3 +-
 2 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 21594f814685..da257ad22f1f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -358,6 +358,7 @@ xfs_attr_set_iter(
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_buf			*bp = NULL;
 	int				forkoff, error = 0;
+	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
 	switch (dac->dela_state) {
@@ -480,16 +481,21 @@ xfs_attr_set_iter(
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
@@ -592,17 +598,21 @@ xfs_attr_set_iter(
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
@@ -1270,6 +1280,7 @@ xfs_attr_node_addname_clear_incomplete(
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_da_state		*state = NULL;
+	struct xfs_mount		*mp = args->dp->i_mount;
 	int				retval = 0;
 	int				error = 0;
 
@@ -1277,7 +1288,8 @@ xfs_attr_node_addname_clear_incomplete(
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
 	 */
-	args->attr_filter |= XFS_ATTR_INCOMPLETE;
+	if (!xfs_has_larp(mp))
+		args->attr_filter |= XFS_ATTR_INCOMPLETE;
 	state = xfs_da_state_alloc(args);
 	state->inleaf = 0;
 	error = xfs_da3_node_lookup_int(state, &retval);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 014daa8c542d..74b76b09509f 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1487,7 +1487,8 @@ xfs_attr3_leaf_add_work(
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

