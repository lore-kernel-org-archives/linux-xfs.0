Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39013C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 05:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240948AbiAXF10 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 00:27:26 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:37400 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240913AbiAXF1X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 00:27:23 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20NJ0Sx0007794
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=piXmY+S1S6x5J8G42q3OPS42p4KfHP7SjH6+nGTm5Xw=;
 b=xkFNP0R/OdHf6djgCvGU4GrXd+1XqzYxJmptMFn7i79JH4A5J2aP6xcea5dqSg9/PhcX
 2O6Ypnl8irASnxLmNvEXV+MhImixzI2JP6lJtQSiiNtkoQn5MtNk7Zc1rfkLRgfp08Pe
 r6Pg41ZydhXhiVHypT0tUkC30rR+H1ch03B9eJ9t3mW+OPOUYpw8WydXBUE+u0nF8nmb
 V0G6LQgziwdtn22Rel55TQus1MhhCH8PxeqDdMROC/ziR3uEMghpRkadKWj16cdHEW26
 nhZ10u7GREC+INJ/5GlEmp9ROazNURLM0iTkkzfhWrAC34ouUzvCOLQ+lj3Obmq/1GgI +A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dr8bdk30a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20O5QKJC012201
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3020.oracle.com with ESMTP id 3drbcjr27k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c/XhyMoICpcG94oXwXWVEo3s4sedzGfg95xDwPRvC8g+1rx1zQt8K7W37QrjGIENQjxr2h6G9B5yxf8o7wSpcgzXSDeK8SyUd0V9S3+IYUVveh720DtDfPdt/Vu8MN/Yd6OKklXkBMBUX62R9L/yr3lHuyk1mr7rfXEPdnllpYXY1CCqtgScRVIk1/l9IL3Hr4ivyNLxTIOV4UllHHle6T6oX/mkj0XnoAGep9dSvq333gSoCiPPGoNlQ8EjVi1FiIQUZ2tYBWWGapgkiHAUkcJueEBZPbeyLOMmusrXJRBxaRBOaeV9Js3stLnGuc4YLRrfauO0uKuvdy4MFt2BSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=piXmY+S1S6x5J8G42q3OPS42p4KfHP7SjH6+nGTm5Xw=;
 b=oQf8u2eJs2K0V7AM+IszuTzpyjz1PCPTIWV1xnf0HXah4FzWDh16gZHd2VZdNCFkHCHj2uX0ISpS7J3cqKeGyBI1LKCgiLKj0hxo4oDI2bXCuymUxDWVPZprkFR/GCkSZFA2pEkXeCQEL6KJG8o7vre05s50Sph1GJ0k/5bT125/Eko268Qz0CvGLBm5EP3Rqg1mOeNj+Ame2QUvZZxRRaguVZntsSjS4sWU7pBCWSa9OtKLBzhs04bl5KrJSz0vHXoWej8bYxLpSaDFuqmiP+eV+ij3a3v4vKw9WzWUTZ3dUQDYKiSPElDkToMmcyD/oII18gWaibkFSANo9zC19w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=piXmY+S1S6x5J8G42q3OPS42p4KfHP7SjH6+nGTm5Xw=;
 b=YTKOq9NEjZNUXWFUSOJjlYLDUBHq8SuXVksZ4ajuX559y670Qf4iIqfF12AjIWEOxYkoHOn5jG95DJSeAdHOoWB4W4zkT8wfC2cXo88xKz1yDEnQUpM/x8IaPzc3b5LEibCT7uD5eztwhW3Hd6tt1DQG8XvbFzb3Ab3EuTuvmfc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN8PR10MB3523.namprd10.prod.outlook.com (2603:10b6:408:ba::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Mon, 24 Jan
 2022 05:27:19 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350%6]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 05:27:19 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v26 06/12] xfs: Skip flip flags for delayed attrs
Date:   Sun, 23 Jan 2022 22:27:02 -0700
Message-Id: <20220124052708.580016-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124052708.580016-1-allison.henderson@oracle.com>
References: <20220124052708.580016-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:254::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cf6f406-36f9-4104-fb9d-08d9defa2fb4
X-MS-TrafficTypeDiagnostic: BN8PR10MB3523:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3523F47D1C4B49AD153D77B7955E9@BN8PR10MB3523.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QC0nkyu8mky02JKMRUdUsJtxy86lU3fwVfHLCg/JMdpDoxnTiN2ki/4BDWYjXaZlZFmsxese2GFTtYv4ibCxRzvEWzlw6nRMyaXsq5OFGbmFS2qXVu8jmaFKhcs9QPbXRkh7oZhmEF896xGR/bfKzC7wbynqD9FOseyv4HMQr7n1v56HzPFepsZqHI+YVUE+CKxs8q2WFOgc1166atiVHZW472hjSSpiSTJ3dzjrOq2eo1kV1uEFZ7KwQ3jle1nSpGuJZ8WmKT2J546FpTsveznoeFBRgnh0KuixmxXaAB/Uap1TKOQnIkkeejylKG4QBWoxqiVC8BZ7qQJ428OypHG1AwiVnEPWDzzAUboPu36fawAeyjoT6kKctDJge3tSbz64c935wMmJsRyKnUabjfoD5tMi6SeKj8lCfdeT3p+S4qToI1M6H3ZRTSRBNrmGn+jJwuyeQtTyPXb6LeIrXAA8sLdNDLeVPaAEeEucEMzrk5sWdz6KjPM7IaxfqJhJjCQbv/T16NtWvaqrf6rBBz3yNkAA+5BfTc4lkqOZQYwFoGlE+DMnaH/jl0YfxWLgqrevHlrOCAS1/N6e2LZslpzLQqDGV3461o+u/UsWUwphnXhriwUseR8a92ClVNz3bglGdXhSPuK72PqNjhuA1EV9rxpQnoLfN/qpiJdFz6PNOfCyUjYToJ2na21cMgiUtt9oxrVekO0McdBf6Af8Vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(83380400001)(2906002)(26005)(8676002)(86362001)(2616005)(186003)(52116002)(6506007)(44832011)(36756003)(508600001)(316002)(6486002)(6916009)(1076003)(5660300002)(66476007)(8936002)(66946007)(6666004)(66556008)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jv1h7jUGl3Mpk+ExIkRocu2fbB+fNRirxWIRYJyuAsOi5l/gzTNqYKkltDNz?=
 =?us-ascii?Q?8MT+ROpCZ4z9abwMlVUAtCwpoTezEE9YSVS9PVOqmqeeQqgLu7jzIQ+Koruo?=
 =?us-ascii?Q?Q3GFBKVcjlEUON53DNAVpgbU/OoGs1m1ope0xAjuMuMXDb1oPtYg/Q4Swk3C?=
 =?us-ascii?Q?CIRIiJ2p3zcrNlBAS81xFSL2QU5gss3bE+Ue5Rn5ABmCqpLNfGHKpzTWudgj?=
 =?us-ascii?Q?Bb3KwtwLntM9XNxc9pBGc9ig7b0AnrRX8lZnn4NQFkR1Wv/+pLtiJEvZ+ue3?=
 =?us-ascii?Q?1JrYGoiRxoExNsVg0GWpNjGH4C3wT24wzpIImrIzSc5wlmw4a+/wl7N1JBCE?=
 =?us-ascii?Q?D8LDvQJnotN+aI7nVFuOD9JUEqEbL/WJfCiUzWu/f+D2mcg7v5D3IQdbaDi3?=
 =?us-ascii?Q?ae9Tti+5UKbdcsOBfpy/tAIBR8aV0TdfNwQu8u4SdXKuo7uOAMlR1jT/PaNj?=
 =?us-ascii?Q?t6B3Z9t8G29fsbR4VI6K3vynehH5hGemORKoTiS8pZcKC7wOzXIWbDveeUcS?=
 =?us-ascii?Q?c1itLsLM9Bs4dLpnlbNe8/Yf9WBFFxslgWAIjhY22ovU4zGxWm0IMxPdpa02?=
 =?us-ascii?Q?qUAvZK9Wmt7MCccTFfW2QlAYXs780mvfaApXKgzunsBFa9ZdQKuDXq7ejBvD?=
 =?us-ascii?Q?fVWoupXnFKvuAJHBefYkl32vl4BmE/JMzrBX2Ny3vae/i8J/QjdOMl9y79a2?=
 =?us-ascii?Q?iBKT6ZlPle4V+P+49SJa3WrjhfTpj+byLueI0oEuI+MGoaSmzAzNdYgi+ZwM?=
 =?us-ascii?Q?JnzNJ51yaozjbbqc2r7zd6bXaR1wYGpoAgArSMpfEUFprkA+pPVVxPbrS57x?=
 =?us-ascii?Q?j+Oh/TbwAzdY/ewkc3xS6XlnNRHwZzvC1JBTPqManmQr2vw/t/ENJjmwMf4N?=
 =?us-ascii?Q?DJgFDr8zT5psr5zH2QH1ohB76L1Pzp2UhvN9y+DpUm6lUME8g3iPP+8gNQjZ?=
 =?us-ascii?Q?h9RQTJLfVdZIsC7eSowekdmvM8dbfQCM9dV8aUF5hx8Ht4n8eYM6pvYUcRDt?=
 =?us-ascii?Q?ml+k3hEcSBEmgdxqFUfS2r/SkUu2AGzN2z9r6yoMQALDHKdgb/lk0FXv784z?=
 =?us-ascii?Q?zVAYObsrdQTMRnuNg+QKicESotQP3fRiMwtFGRAJplKNVlthGd/HkHuc/r3u?=
 =?us-ascii?Q?mkdLaFkyUM2IMjTwveAV8NM91Pw6K9DMdrW9ur5gdQXAipOSe3B6/hZ+DDwT?=
 =?us-ascii?Q?CN9CNYbmARrnwGKOvgzqIEA5vd3Ax67IKyymTzM9un5hEVoiIe9EQgf2d+dG?=
 =?us-ascii?Q?0HVbAmO/9Gwszvy+p2BaN5Lpj71HlSs88+8NYJj5r4Fs+Rolw40YgORBrApC?=
 =?us-ascii?Q?2XdnOZi6Fs3U4zk1sFbeNlxmkdLmWp+A5ucAEjWrDyyxq9BJbQD1xynt7yV3?=
 =?us-ascii?Q?KMMue3o/MI5/+OAG5NlGBP34nn/i75fdNYYDxKIU+gAkakTeTHMrvtN8CSnD?=
 =?us-ascii?Q?KGk0vDUNU3AWj3kUT0PtYXjmwVbMCqc7nH+pFFPEXQSBS1OZxWpeow5BqnW1?=
 =?us-ascii?Q?EF16jmVWyx6tIygyTobI+2Q4C2q+4doU1Qs66C7xGDPi76msdqHZ02f2lYHe?=
 =?us-ascii?Q?tVWQgRWHG8cLx7FwwWvJ68caFTASJIYbksf/z19bw/0XviFYGRRaKV6akfin?=
 =?us-ascii?Q?+/j4V+mjDRL0FyvbdNnFQFYRP9NNZKNV8YrhhN6fnWwsWr2AOr+uhqKazF/Z?=
 =?us-ascii?Q?B6EWEw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cf6f406-36f9-4104-fb9d-08d9defa2fb4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 05:27:17.4634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y7EK6MWR06DgZw1c7wCcPV1o9UbGuVI39ZBi48qVRVGYy5LtdBTvJZUH3+tCNDjt0cpTuki2D0dJgz+5i0p9XOcMWcUAQfkHUcTtwwH21F0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3523
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10236 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201240036
X-Proofpoint-ORIG-GUID: QRvPqT5RD7bCeyPp-y3102M2l5nyXmT7
X-Proofpoint-GUID: QRvPqT5RD7bCeyPp-y3102M2l5nyXmT7
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

