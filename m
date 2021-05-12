Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B77C43618
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21D62613CF
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238981AbhELRGN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 13:06:13 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:52566 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239720AbhELQPj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 12:15:39 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CGA0gq188859
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=KKFXo4sujt3AaXUtS7xAiZK703t1SfcnASNuiJzD8ps=;
 b=R48/BCFyl3FFSEzj6yMMfFfurlPrr42ZlIexHCjtLgXBCkeF1ZOhoFed85HE5ZwEWvNE
 3QRifq5pky89RDBSAmRUEDOI9GJZXx6Z022ijKfya28tInVTmgY1HdFZ8rWHjy0QpaSS
 fa+iG7353SoOIbSMO2BgkEhLJ12vk0aExs6qVPT2vfvG7Qnbg7KcuzF1R0Yh27qztN0j
 jY/GanMklD//JpcNxsprhtYLU4Q2iteweq2p7K471sNWXcsRc2+0/HwBL/RZ11XYYczM
 ml6p3VhZePeiz/coe7VJvK0Mwh1BANveMmANaOc7Skgs0225/wTMD/d4KqdUrPaeJs0G rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38dg5bjpnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CG9fYX021006
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:29 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by userp3030.oracle.com with ESMTP id 38dfryyw0g-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxtyGBmvG6xmk+fGCdwfYO3eJoYSDma9vyCWGFOlVui6TikOsU/4lmojum18w5iS0M85+vZntEbLy31k/GnCPOFlcHdg4DMA5P0mvdDGIqe3DPGh8ZZA9MX27pZQ1CKE06Erb58zXIuSfOWQ1NG9SQqkoE+pBAsQfVVDEx/ioRxQzThIGZh6ugPmyDvRQRaXx1elqoJFSx+sny881JqEBCrvvCBHTmVfhnOd+TMjMP5Eb+w0GqhKvR4boliqLETMPsISfzTKbHbKUskfs2N2xVXnRxEm2IZQtwGgjXxUTCCwfn+dmcsOA47JKwuE/oWbtVSVcj4TcM7YReUHPZMTYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKFXo4sujt3AaXUtS7xAiZK703t1SfcnASNuiJzD8ps=;
 b=LKapVyS4KCHXnEbsesfGUzQ/DzCvX10teQhoc9L6WBfdv+g/g378gvvbnvl59TJs5k5o1rVN17PTPdScC932OqIcbK9AXN8NGbgAhKcViQN9/EH5iY3aEqTzxmBxoQeGxLQdhn6Mhesfw9pLNFbjmxY3ail9i+9aK5iNaJ5V1JNyaabG3Y2fqYnPNUydUlW7sqlNlzkIHrnpCqn74DE/14lAjbLunF4kcMb0Cw8hkTYC8W8rjliF7sFSUYnUsPik1iisb4nUMWE/3BgVLxy356FjfEYW3YJvkw2x4XXQT6CHwukDa8LoWhjJurMCW0UbTdbG3ssZjChDKmeicLb2tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKFXo4sujt3AaXUtS7xAiZK703t1SfcnASNuiJzD8ps=;
 b=uR04kCOqI//Q9Ro018qjylipU+cw/xqZ8Yw1lVsyRZsb1o06jxDPMM23+ln5OKomSr+7n8IHjY4RMPaiNdkPwluHLE8UvBVm3CIDuFUV1GidGYUPmm+4tdlqXWnDVK31chtehbPCWsXAbhX4yRqk6HE5C9/gEr+Lgst/yHWrNQg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3112.namprd10.prod.outlook.com (2603:10b6:a03:157::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Wed, 12 May
 2021 16:14:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4129.027; Wed, 12 May 2021
 16:14:23 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v18 04/11] xfs: Add helper xfs_attr_set_fmt
Date:   Wed, 12 May 2021 09:14:01 -0700
Message-Id: <20210512161408.5516-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512161408.5516-1-allison.henderson@oracle.com>
References: <20210512161408.5516-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR05CA0200.namprd05.prod.outlook.com
 (2603:10b6:a03:330::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by SJ0PR05CA0200.namprd05.prod.outlook.com (2603:10b6:a03:330::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Wed, 12 May 2021 16:14:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2b66e3d-bcff-4e19-55ce-08d9156101ad
X-MS-TrafficTypeDiagnostic: BYAPR10MB3112:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3112C2FF6AAE769AA6EBE25B95529@BYAPR10MB3112.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kW+8ne1vlgY00fh95puFzXbfIHFbGAlEAckbDCDhiKK6GplZzsAYkEzyI4S+EnJKliDiRMe6kekcZLCKlj510RivZpUvXR6nNVDzKaU76Pq+9NBwgRlGIJzAkdvpV6wktStfhn7lVyjhRpjSSoOydzxI3Rv+DSJtHIKI7vvhVoS31h3d7BSW6oY91+zSmZrPcNt6dzKhCSFYqVzTzYBAnmuC5fSw8FXRy8klmvtBGlVw4M8NQWWM63BoAdDHSPmWUBOifGYjkfeckBTAmgbI0JZ3ZQxmtTxFOwmvqlRZQzFk1TOaAosqnD7PP7vQlClsXneQD+N2SYFWlYb21bXXYE/jGDKkknRoI8As0koHZuoEiMl7UEjbtCz0BWGi2U1AXO5IVGAsSsnzM7awrmYkznzwHBMLErko0Sp0l4pnocCnKW5G6ZpNCutOxpf1Uvi9lGz7dsqE8RzNkEyxyOtRk/ksIdYohZDeNJJtbNtgwoNLV1+v6iuXQ661J+5EmAqJ7TDrBmuymcxMDO1gft06BM0J5bCTIwX9ldYfLb/t3tJLWSsaMsanKG3MVhzX4XZd+uG8fovDWB0qS+uFZ9eUUkIQffc6r4Yw60sqB/1itaBhm1GbL+1UmcmzazbC8Y65n1qDaWLGZrWXts4DrcNoZxVIQaNoPVY5YrsWfLc0M6NUvMgp2K5LGkXDdc7NJeyy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(376002)(39860400002)(366004)(478600001)(316002)(66946007)(38350700002)(1076003)(52116002)(2616005)(5660300002)(36756003)(8676002)(8936002)(66556008)(6486002)(6506007)(83380400001)(44832011)(2906002)(6916009)(186003)(26005)(38100700002)(16526019)(66476007)(6512007)(6666004)(956004)(86362001)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gPgbgqlTpn69hiIA38IWZAIFfqakpkg/Mde8tLeUNHTJTeTMn1PlspAqgDMe?=
 =?us-ascii?Q?QGWldMWEYFd5xQclFW+U1XoFYWlUoBRcfjoOL9zjNrxkVM+tc3InAHbuFalN?=
 =?us-ascii?Q?OewT19dl4uO89KmPXXcW6WQvYfWbIdvJc0PpIQHa5vYrkB+yJ2ovtKWvlERm?=
 =?us-ascii?Q?BQiPjF7XQclUYE7jXTVUwMNdxtyggjHo17eU6q4/1Qn1/8RtQzUn0jOmBsKU?=
 =?us-ascii?Q?abHNYW8tZFTUycgDyvshNxBYysFOktIC+jdCE2gu6UQVVy6RbdpWCcgqEDcn?=
 =?us-ascii?Q?C5QRXAaI3IBW4mElRGZ3zWeErHfLwOUGsk367ygLBE3yxX9ZISTmpbnXcyp4?=
 =?us-ascii?Q?tF2t8w2JZLjYGbKnxHXCdDsMZjQzSQWmQMrtHr+51n9KIloKbJSIAqRXlgYv?=
 =?us-ascii?Q?6GxtjZXZq+T4FsEOr3lQrL6QyXaaePlClyI1Iqby9gzp+1n4YzAa7xH0Ha2b?=
 =?us-ascii?Q?IkAQvsMfvKXKTFVZ0xwmeOBQlQQIqZ79byU3voJXQskfnoKm7avGKfNkT7Q0?=
 =?us-ascii?Q?gNoOraifpqrckep3fekmVCA0jNhZyJzTqydOCSuCcSCpthtCECMOPBI/mqxb?=
 =?us-ascii?Q?t0OaMIF2elg4lMlxVFLvGz08h4Q5D5ioMizWv5JpdKOyZnCOouhUoGt+LYuw?=
 =?us-ascii?Q?3fokntuYBbkPpy4pormLedc9q6R0GrK6Qxt94DQDUpuc+kKVg05nOw9UX8g6?=
 =?us-ascii?Q?n/GE5k43KDH6x4pNV+QJP5L1A23MaBp/a1qP1vISYNTR0CICQIZiFmgEIwn4?=
 =?us-ascii?Q?f46AN49N+wiQOASEggsv2Xql1oBXfw/Efc6Pnym0ZFNF6oOBuCjnpw8o3NFv?=
 =?us-ascii?Q?0zn+oioygAXr0CtyKi36nZaW4Jjo2FTbEJXG63gaw7Gl9DRelrFPXBE40AY9?=
 =?us-ascii?Q?W27bMacjnwkbPPawmStpra26pl8YbqFCtqTM+7Tmz2pkv0AT0h4Myk0A+8Rz?=
 =?us-ascii?Q?5Jy5rlMquj55pBGPriuVPNp4hM0C8qraKzQqmRKmullO+sBD8c7JU60uhoKQ?=
 =?us-ascii?Q?1eBVjiYdZCvsYBNyKpNiSLiVfZdo2d85/tvgbTcO7UUF6RtzsqByNlzb+v2h?=
 =?us-ascii?Q?wHPe0pWqAsR8V6NwISq3UQyIbWt8zvvtk7PKQ89MrvMxPMoP0Njy1maeph4G?=
 =?us-ascii?Q?XFCtGOHB5FWgkHvbTlmZ9BY55uSC0QXc7FWPckFDcbgpaoOIYtIMFPWkjThs?=
 =?us-ascii?Q?NrXVyhPO15JE+gjR7h+IIczJRAGz0Z/jFUQo9udmDYaBAvm+EIZQKxlfQZgy?=
 =?us-ascii?Q?JZdFxsXqXWhanHu9UlYML3JPquUGMFrMFBrQv0z177r26S+3RObHeNKkwd9C?=
 =?us-ascii?Q?JLXl8wBUirHN2H8q9chkmYEZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2b66e3d-bcff-4e19-55ce-08d9156101ad
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 16:14:23.6123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FZ6rhBCijyxoxjIfLWT7ZraHjvh+/dcX1I7fRqHixc7w6Z+mQh8EOtIhmcv91oqqvczNd/CeZ+V7fanh9TB38OGqmx638g7cCCpTkaJ4Kmg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3112
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105120102
X-Proofpoint-GUID: _uQQMYaLqf5D7aTdcVoPeeS3rdlXji39
X-Proofpoint-ORIG-GUID: _uQQMYaLqf5D7aTdcVoPeeS3rdlXji39
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120102
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a helper function xfs_attr_set_fmt.  This will help
isolate the code that will require state management from the portions
that do not.  xfs_attr_set_fmt returns 0 when the attr has been set and
no further action is needed.  It returns -EAGAIN when shortform has been
transformed to leaf, and the calling function should proceed the set the
attr in leaf form.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 79 ++++++++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 32133a0..1a618a2 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -236,6 +236,48 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
+STATIC int
+xfs_attr_set_fmt(
+	struct xfs_da_args	*args)
+{
+	struct xfs_buf          *leaf_bp = NULL;
+	struct xfs_inode	*dp = args->dp;
+	int			error2, error = 0;
+
+	/*
+	 * Try to add the attr to the attribute list in the inode.
+	 */
+	error = xfs_attr_try_sf_addname(dp, args);
+	if (error != -ENOSPC) {
+		error2 = xfs_trans_commit(args->trans);
+		args->trans = NULL;
+		return error ? error : error2;
+	}
+
+	/*
+	 * It won't fit in the shortform, transform to a leaf block.
+	 * GROT: another possible req'mt for a double-split btree op.
+	 */
+	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
+	if (error)
+		return error;
+
+	/*
+	 * Prevent the leaf buffer from being unlocked so that a
+	 * concurrent AIL push cannot grab the half-baked leaf buffer
+	 * and run into problems with the write verifier.
+	 */
+	xfs_trans_bhold(args->trans, leaf_bp);
+	error = xfs_defer_finish(&args->trans);
+	xfs_trans_bhold_release(args->trans, leaf_bp);
+	if (error) {
+		xfs_trans_brelse(args->trans, leaf_bp);
+		return error;
+	}
+
+	return -EAGAIN;
+}
+
 /*
  * Set the attribute specified in @args.
  */
@@ -244,8 +286,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_buf          *leaf_bp = NULL;
-	int			error2, error = 0;
+	int			error;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -254,36 +295,9 @@ xfs_attr_set_args(
 	 * again.
 	 */
 	if (xfs_attr_is_shortform(dp)) {
-		/*
-		 * Try to add the attr to the attribute list in the inode.
-		 */
-		error = xfs_attr_try_sf_addname(dp, args);
-		if (error != -ENOSPC) {
-			error2 = xfs_trans_commit(args->trans);
-			args->trans = NULL;
-			return error ? error : error2;
-		}
-
-		/*
-		 * It won't fit in the shortform, transform to a leaf block.
-		 * GROT: another possible req'mt for a double-split btree op.
-		 */
-		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
-		if (error)
-			return error;
-
-		/*
-		 * Prevent the leaf buffer from being unlocked so that a
-		 * concurrent AIL push cannot grab the half-baked leaf buffer
-		 * and run into problems with the write verifier.
-		 */
-		xfs_trans_bhold(args->trans, leaf_bp);
-		error = xfs_defer_finish(&args->trans);
-		xfs_trans_bhold_release(args->trans, leaf_bp);
-		if (error) {
-			xfs_trans_brelse(args->trans, leaf_bp);
+		error = xfs_attr_set_fmt(args);
+		if (error != -EAGAIN)
 			return error;
-		}
 	}
 
 	if (xfs_attr_is_leaf(dp)) {
@@ -317,8 +331,7 @@ xfs_attr_set_args(
 			return error;
 	}
 
-	error = xfs_attr_node_addname(args);
-	return error;
+	return xfs_attr_node_addname(args);
 }
 
 /*
-- 
2.7.4

