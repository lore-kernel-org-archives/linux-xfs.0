Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0ED0C11F66
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9891061CD1
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhGGWYP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jul 2021 18:24:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23328 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230418AbhGGWYL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jul 2021 18:24:11 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167MCVHx018224
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=7OBeJxzbnNeLSPJQAFz55sxEJws3Kl3FfLRvYuyDl4I=;
 b=l+1SQdvIMSMxc2ujSA5fKvy3+k4cz8WZhOy3J5Bu8SJSJvWj8bj5anMZbQtUeCMyUYkl
 uYm53UsXfd8gb2GL4sPLc/aHuQP70AH+DmdC6I9RMPNNnW9bTLqeBqsIb1h1EZ9PKOV4
 CBKt3Sr7ktt3BNCx1P9iJewHVF9n7ciAdCxfWqIcsevbEy4KHTZ0P0uzfxpVrRszPuyR
 l//DJ939VRFhP+ocDJ2VjAkgJuJtXgcIYFTD0CsLHjD8Oysc8uBPHcVoJx46k/d+EDdB
 mmfiV4M66ePtsBTAyvCJGu16WObYoaNFYOKX/ANMqESf7VVr3p1W9mlapWAPJuRm5WQR qQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39n4yd1wb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 167MKZD5092555
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:29 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by userp3020.oracle.com with ESMTP id 39k1ny0hrv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwzB2W0sEM8WMmcP8wZR4HRvGw3HxvALBa6m2NeV+ksuYjzs+fFS+z4Z7HvUVvaLc3lBTDrgHeLjPs3FIN3+oKk2BhqyMxgEZSjm9OhfgChPWSfZ1aRMKDyOywtUcVDUbp1rHpjno+UHTBW1uJ+EqCTPg5YYkLoxBnxzfuePNELiFRULSyT8McZfPkRp3k1NZvJRP0XQFlsBVUiO+i5cuyFLQBn4GVE4+rsPl9tSZKq+ZZkxMov3JULZe7Z+LAmx6dEFgHS093KVX8OTXzyp4pG6ZNcfFUL+6ZuBAVqSbJtklhcvZHIfIZS7QS5m+BPPxumnc9NKAlBmEIV3w5Hikg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OBeJxzbnNeLSPJQAFz55sxEJws3Kl3FfLRvYuyDl4I=;
 b=CxASh3c1SP5+Bpu1/MUfO0aL1AOc5mEb4aDXiaJBA2Bvo6LIxlIPCnZfoYpslv0p+MwE5k+jkkY64haB4WhKYpBLJg4U3H6HooAamkNl/UbKmA2pSd14+IkzeZiZ+ZBnij0cyPaDenQ4hI7GxQGBVD3XwgtWu48BJbTPBaK+Vtrr3nDCaPCTzZdQj+PFCYZzs2HIuNbrgGYxgbEE8Q47WEI2kZEvREOxRhAsLxI7XImtmBBIHGIcLdba4KrhG1Gs66jXXed2umbVLNM4LQpGHkC7p3TAqMI7SQTpBiibRCJEsKqkQEVGgEtw+gDgW2J3smh7Iha1LUop133r1domLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OBeJxzbnNeLSPJQAFz55sxEJws3Kl3FfLRvYuyDl4I=;
 b=YOUc9s2JDQGHdMJHiqXK2sogpxWKfGJT36P2JLVhgB//V7YrHrqCYRTPmJ/J6WHxKQ9Q00KiisZiYP4HA3d20bA23UxrxjpfBgDUJTcwPfoJGSrkytd03cu1UQT9Ymgwq5cm+EBTuz0E/4X/N7UXc4LsonLbW2osoXHpXAIaMiE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4388.namprd10.prod.outlook.com (2603:10b6:a03:212::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.31; Wed, 7 Jul
 2021 22:21:28 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4308.020; Wed, 7 Jul 2021
 22:21:28 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v21 13/13] xfs: Add helper function xfs_attr_leaf_addname
Date:   Wed,  7 Jul 2021 15:21:11 -0700
Message-Id: <20210707222111.16339-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210707222111.16339-1-allison.henderson@oracle.com>
References: <20210707222111.16339-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:a03:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Wed, 7 Jul 2021 22:21:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cac8549-29e7-4fa7-37ba-08d941959083
X-MS-TrafficTypeDiagnostic: BY5PR10MB4388:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4388F903A75A62B25F075EF1951A9@BY5PR10MB4388.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XCZiG3HrQUzPamKb3Xoxi7bnSNcdzL5yfGtnZ9XU2pdNRpMqS6WE7rodyaTi9o5L80k+ZSU2EA0u1WrsLEZA1/IE6tfKhTQE4nEUPoSih7M0ASNJd7fe4bSDnQespMommV9i72KIWiZLeJd0JlBafBxJB3MrAl9DJbGIGxDMfjOXtswQ1VlLOmP8efD/y6hhcuMwACUA00A3X/1APY6wZBvSZ2ortofvwEIKTMx18bgCP6y62PBd3U9xSyjCIpm1y3R+ffvQXxo48kCuJfSO/hqZcdpFiNOM8gFwHLdbCdF8bYXx1EpQw5qITEHA8PwZWu6JhUoN/29yVP7p6mBr7iQqKRnIJpupHgUvzxJ74oTx/Ms7ZIx5rWkQ3/28mHykESjwikT/TsIPM3MS2K9gXLVlMyXMpxEQvxLjLHFc/wBHIj4iNERGw79aPSS9NcoVx1LoyV697xz7tiJ2jBlUWh2Aic+jQ78+z11v1FLy4su+/KQwDzeLIui34oR4pqxlrzRIHii1aoKFzBu3G39f4COyVklJ0jHyvRzYvUpWo/6BpyiHr8icE9F/Yd+zf09w59uJb7VTWI79/FQnfWLOFHhwhA/JLksPFucH+oMwOTGTRO9ZZtFcrTnulxizUFpDaqrztCPViNCIm3vjcZamNeUUcg+WnqxTUhYq9j6RKqTUZMP3G0eEqic0DAJ9oXMM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(396003)(346002)(366004)(376002)(6512007)(44832011)(26005)(5660300002)(66476007)(66946007)(66556008)(6916009)(956004)(478600001)(8676002)(1076003)(186003)(8936002)(83380400001)(52116002)(316002)(36756003)(2616005)(6666004)(38100700002)(6486002)(2906002)(6506007)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fTEedQHJ/IyTpHPFec2ggtKpyFcVxiPVGDn9D868M47nS7Dw/7Vow6yu7m6b?=
 =?us-ascii?Q?sBShrajh8b8fG1LOCKEMUVVe1xSyWYyBTrJSroRx1TsAUH32klwSYrjLcZiF?=
 =?us-ascii?Q?NwY7fHawDlFs5EyPvNgFzJ0V5dC+zPuZThyGHlfamtbaGk96D31QDUHTGF8R?=
 =?us-ascii?Q?PNbDYhKtuoenLjFi4i8JAs3qm//sUI9l4k7Ah4kOEYkD/u9g/bWZ4o1aB9QM?=
 =?us-ascii?Q?f+GDQddLFbnd5VGIUBouWhInE4Sh47/istuCKsBQBfzSpZTrQYjH1LgbLIM0?=
 =?us-ascii?Q?pKlOLbNES7oyvsUvLwVZaeW62z8wcIqgGL6w31B0CgFGhBCCJOHGvRUs6NPW?=
 =?us-ascii?Q?0Qmt6l/y/j+/pvF1XZo0lgyS8YKwO6cD4kQcVmiQ1Ik1tRef/q2AqqxHLOhY?=
 =?us-ascii?Q?mQlnH0E0IOHmNUGgVpU0NEynG9QMa0xCO0aPOfYrTVzR8wnnr5NcVEl4dfC9?=
 =?us-ascii?Q?lmKPOLtufc+jMCdxXbloAMKBDFrLIPih3JXJRzbih4V2yhxsHzE23jb/UFb1?=
 =?us-ascii?Q?uJPwlCeQmlHOLcWR3OAjLcO+KQSH2kuzhq4j3k8Gsu5i0Y9UBzL6koLL111a?=
 =?us-ascii?Q?yI1tEFZIFB6h+jMfmz7jNayTYX+WAJTVniPSmuBpGBdBiIc1RuLz2a/TTbGf?=
 =?us-ascii?Q?u3ApQOr7KD7dWapMayZ0cWcqCdrh3Xtflm9qM5aOV49sNyaE/WZBqz771EXf?=
 =?us-ascii?Q?b0VzGqX31Cz6mQwY4RGF4WX4LtUydfoNDiwPv4amzHIpQ46vQ1EmhBRrQGtr?=
 =?us-ascii?Q?FqDiBN6BvmYs5y1lrxVnGeCn9aBEyIF+xrBhbIoG5sd6Ao/29NUEX46+T5Rl?=
 =?us-ascii?Q?H6/Uu0dMwMtlwCL3R5Lsld9BYIcZ7/j9/SmxJc6RrlVsRSkPICwVM1aYloFw?=
 =?us-ascii?Q?0ni3t1M9KUFIOBMdmB5CIlPLnzo0C0c/7zcPUoaWj7FecwurXAFHfyzysAUe?=
 =?us-ascii?Q?B2sWH2Fv8mgWjJqrz2imSyWrPPgTy1HrLHrJNyz5v0cRj9cFUvTk1a47geAp?=
 =?us-ascii?Q?1XEMxIqiT90PIMLUOqeNtwfvDA53ywqdMoZUpwQK0TOVdbJDChKIYNXg0hnO?=
 =?us-ascii?Q?nDtu0y4zMI2Te2fKs9BqpKiimPsHOUMiMi9pqSq6rx1cfA14iPPdBm61k0Q/?=
 =?us-ascii?Q?s8nVsnXjn55cPphj1pValUsk2maPUXmz8edq9ePeQ7v4H/B0BtRvM0OOJQ7y?=
 =?us-ascii?Q?tJeY+mpEdf2uaYs9xEXyLDXbOoa/izRWbmR/cMVl4IshwoAI8SSbPJrXoViy?=
 =?us-ascii?Q?dWMIzlSAXDFfLIn8QPLA8VzAjbNBKhrBdWYM+mZbXm3b5TCTTo4jVgLORRQK?=
 =?us-ascii?Q?WQeobNTu0w0yPmN06boCnuPk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cac8549-29e7-4fa7-37ba-08d941959083
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 22:21:28.1968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3NEqFh+/DZWBPKGjCgzMMgN5HVA7s7SNbK3Nu3lZ8YK1bzayJlop+69SJnuDe9QyneUvOv8CvjSxprbQ2P7ARSx+smPCcSjfUbGVaEA8vWo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4388
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107070128
X-Proofpoint-GUID: 2nSGn7TSSFdR52QahB2XXXSMjD_2fkQI
X-Proofpoint-ORIG-GUID: 2nSGn7TSSFdR52QahB2XXXSMjD_2fkQI
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a helper function xfs_attr_leaf_addname.  While this
does help to break down xfs_attr_set_iter, it does also hoist out some
of the state management.  This patch has been moved to the end of the
clean up series for further discussion.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 107 ++++++++++++++++++++++++++---------------------
 fs/xfs/xfs_trace.h       |   1 +
 2 files changed, 60 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index cb7e689..80486b4 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -284,6 +284,64 @@ xfs_attr_sf_addname(
 	return -EAGAIN;
 }
 
+STATIC int
+xfs_attr_leaf_addname(
+	struct xfs_attr_item	*attr)
+{
+	struct xfs_da_args	*args = attr->xattri_da_args;
+	struct xfs_buf		*leaf_bp = attr->xattri_leaf_bp;
+	struct xfs_inode	*dp = args->dp;
+	int			error;
+
+	if (xfs_attr_is_leaf(dp)) {
+		error = xfs_attr_leaf_try_add(args, leaf_bp);
+		if (error == -ENOSPC) {
+			error = xfs_attr3_leaf_to_node(args);
+			if (error)
+				return error;
+
+			/*
+			 * Finish any deferred work items and roll the
+			 * transaction once more.  The goal here is to call
+			 * node_addname with the inode and transaction in the
+			 * same state (inode locked and joined, transaction
+			 * clean) no matter how we got to this step.
+			 *
+			 * At this point, we are still in XFS_DAS_UNINIT, but
+			 * when we come back, we'll be a node, so we'll fall
+			 * down into the node handling code below
+			 */
+			trace_xfs_attr_set_iter_return(
+				attr->xattri_dela_state, args->dp);
+			return -EAGAIN;
+		} else if (error) {
+			return error;
+		}
+
+		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
+	} else {
+		error = xfs_attr_node_addname_find_attr(attr);
+		if (error)
+			return error;
+
+		error = xfs_attr_node_addname(attr);
+		if (error)
+			return error;
+
+		/*
+		 * If addname was successful, and we dont need to alloc or
+		 * remove anymore blks, we're done.
+		 */
+		if (!args->rmtblkno && !args->rmtblkno2)
+			return error;
+
+		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
+	}
+
+	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
+	return -EAGAIN;
+}
+
 /*
  * Set the attribute specified in @args.
  * This routine is meant to function as a delayed operation, and may return
@@ -319,55 +377,8 @@ xfs_attr_set_iter(
 			*leaf_bp = NULL;
 		}
 
-		if (xfs_attr_is_leaf(dp)) {
-			error = xfs_attr_leaf_try_add(args, *leaf_bp);
-			if (error == -ENOSPC) {
-				error = xfs_attr3_leaf_to_node(args);
-				if (error)
-					return error;
-
-				/*
-				 * Finish any deferred work items and roll the
-				 * transaction once more.  The goal here is to
-				 * call node_addname with the inode and
-				 * transaction in the same state (inode locked
-				 * and joined, transaction clean) no matter how
-				 * we got to this step.
-				 *
-				 * At this point, we are still in
-				 * XFS_DAS_UNINIT, but when we come back, we'll
-				 * be a node, so we'll fall down into the node
-				 * handling code below
-				 */
-				trace_xfs_attr_set_iter_return(
-					attr->xattri_dela_state, args->dp);
-				return -EAGAIN;
-			} else if (error) {
-				return error;
-			}
-
-			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
-		} else {
-			error = xfs_attr_node_addname_find_attr(attr);
-			if (error)
-				return error;
+		return xfs_attr_leaf_addname(attr);
 
-			error = xfs_attr_node_addname(attr);
-			if (error)
-				return error;
-
-			/*
-			 * If addname was successful, and we dont need to alloc
-			 * or remove anymore blks, we're done.
-			 */
-			if (!args->rmtblkno && !args->rmtblkno2)
-				return error;
-
-			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
-		}
-		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
-					       args->dp);
-		return -EAGAIN;
 	case XFS_DAS_FOUND_LBLK:
 		/*
 		 * If there was an out-of-line value, allocate the blocks we
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f9840dd..cf8bd3a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4008,6 +4008,7 @@ DEFINE_EVENT(xfs_das_state_class, name, \
 	TP_ARGS(das, ip))
 DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
-- 
2.7.4

