Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B0DC433C1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9AC661A02
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhCZAdg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:33:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58834 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhCZAdY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:33:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0Qp20112886
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=DEmSWLxmYNQZ3iM+FsGnGMwvNhGLdFqIIubfOpQpbbM=;
 b=r34hOeIlZpSD1xVSA6p8YGD+F5/70p6iFjkjNZ1UYkCiX0BbOI2RicYdqpA0YIJEu6AJ
 nfqyovtk54OIQPu6T8VRWF49KuBX25rRyq++ojOXjjb9DMhHP8qRltCMyLRjpNRD5mkE
 hnUqvgRXxX57q3CA29Grtg/glkOWvmWhHgP4QJEPU++wkb8FA6sUmu26HjEGgSmLYVXc
 4fq1+BTR627GttqMER/23OrDYMH5LMbpZLw36gtxTbx92PvL3TJwrWVr7bLbq1IibKza
 2pMotIwY2NwKlgEazqLKnivE3aNdVLBRbxUU9alqs18anUtCf0tyBkE0fNDGbHW6Mt5d 0Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37h1420h8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OlNM009463
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3020.oracle.com with ESMTP id 37h14mfud0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RHhXa7TXml24lmntvuhq6m7b7n8y3uS1Riw54LfWkZZhfu5yl3P4WYxY/V9yDtx60qlxYAWybpmkjrqpT2MaPgvvYkDaAFmUaoILrDtDW1xtnM820N/bmejiXt1aGORfC3DH6w6FDlq6iZskhGBoxkmFXZxhyUYrdlGgNvxX25ajLnnbTeJml+k9+kisK0jy4fChMWEdvzrqOv8pudeg7VNuJ245XHAtOPmeRdI4VPw4gkN7nmWowSGUahaT7FsdTQyXbkesVZ63D6IRGJH4RDIPVdxMlRktn72XrIDlIo2dfhStGBvMCu71b12oyR+piK7Gvk7TaVo8OAr6BwcO3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEmSWLxmYNQZ3iM+FsGnGMwvNhGLdFqIIubfOpQpbbM=;
 b=Xvlqt3a5EntwIIBzHvZaG3lXkgSItlm0ykqHLwmDH5ADaByldQ1uT5T4INF1BWynYcKWxFsoANw34ZCzFJH62oUGPjbt473Ey/Jm1Y4Noc0/PXik9xvpywy3xS3h15HOKGyz/RFAtXyIQq+PMAZ2Q74bjPlRS7qqxGPxK+/r8rXN4OW4PfEeywnS9pYyVAEPO3ytQOoRl2K2Nrj6jdwNJguN+RPbsrK+mQMH+vizbhyauCGvzsLv1SLV5IIOwl1BgKUqoFKxUUA0QjZhAb4thV8pWRM7RUprLvWg2nTYJ7/5Pl+Je1uKlgQYHOE+1TaOrhVbMpLw+028PfEubPDtwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEmSWLxmYNQZ3iM+FsGnGMwvNhGLdFqIIubfOpQpbbM=;
 b=U+b7qiPiNp9CKk9zS3xsyKwEn+S/dns4oC3gWfeDdoLKFlLZ7SPt0UEa0/EV018W5utyfvl3lFZ7aU8CNrxSAr8jVN6cLWXqasSJfiJqI94gH/lWR94alik6YY73yVNSoTgbmWns5qDU9+e/8QBmdabpX3ShrQqG2p58Us9NkRk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4162.namprd10.prod.outlook.com (2603:10b6:a03:20c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Fri, 26 Mar
 2021 00:33:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:33:21 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 06/11] xfs: Add helper xfs_attr_node_addname_find_attr
Date:   Thu, 25 Mar 2021 17:33:03 -0700
Message-Id: <20210326003308.32753-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326003308.32753-1-allison.henderson@oracle.com>
References: <20210326003308.32753-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::8) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0003.namprd03.prod.outlook.com (2603:10b6:a03:33a::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:33:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc5dbd5b-497f-469c-46e8-08d8efeec23d
X-MS-TrafficTypeDiagnostic: BY5PR10MB4162:
X-Microsoft-Antispam-PRVS: <BY5PR10MB416252B0842C5C918980DE4995619@BY5PR10MB4162.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a0SGRXkpbIS1Zf0tUO09VpVTgHrk70qU55CzAb5h4BosrZbHbTA6ugsLPoO5xlddXBIRHvIokjDFJw2xkfrrPySgM3Zn8OHjMi7r77ZvJrDV6Vt8Tfk39YOpkpBo52mnxQTHN/fQAOZ6sBcVb1lSRzavCB8rHnQ73S815bucXsk31nzJcixQqmOH1R8KK1yV8ifoTzzTTybcmoytQGO/oGfO2O3LWwI6hZnoCJevhPQN/DNiCckxy8hv1B8iYuPhTXa1DKYRYj5xPYTrtzse+sW+zidc/cniqhooDc+73HeBUBUbkfJBTBDwFOd/HaiPZ7VAuQWukfdSE9OEiv0zPViKiCnMzKJ6C+0uZD/veLtRyA83YSvewWSWd65AMpxEmL4dwd75UZYoD74QemRpQC2JqE7D233QF2eUMEuMQyvC9v5d5pyoOqIomsYUtdD3jwk5pA7bYcq+l2Jo3/VzOhtK5QlU+qBWEFhqSfk7uZufUU7piM7Feu2KMijjJnJc+fyINVuzJu0p1dtiaC/2lmcFKkNH8YM/rAlyTRZ0T817OqtEJCR5EImORAoVnfg8JGR78VViAI/45/rVfTgjyILGTnlkQP4xQHgWm02/lixP/skRGAeR/Gu/z9CndBqtPApgwxnJCCWuBKawPJ6ewMvWGz3XcM6Ta5VLS/JJ7nYpKTXpqxpvDBNvtTDNGj3r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(136003)(376002)(346002)(16526019)(186003)(44832011)(478600001)(83380400001)(6512007)(316002)(86362001)(6916009)(26005)(956004)(2616005)(36756003)(66476007)(6506007)(52116002)(5660300002)(8936002)(69590400012)(6486002)(2906002)(8676002)(66556008)(6666004)(1076003)(38100700001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YcIx7mmtTuyoj9v0edGg+OPocrDO/2pSZ0CQGNvLXUa8xJmhoPh6LP7a0F+H?=
 =?us-ascii?Q?i92uG97EK7L5nRSet+GfCD2KOHsZsAOt7CFYXxtzgaVRYiD7iJ+k+F9JMqFl?=
 =?us-ascii?Q?gqFzRv0ccZctawSQea5oFhVLGJSmVudrta1ocHoBRnAeZbvx66H1ZUOUfnBS?=
 =?us-ascii?Q?hsRXd25e27yPVr68yWvGFh2b7/vg75sOpsPxPDZi3Q0r4AzdnAnvJ1nj1Dje?=
 =?us-ascii?Q?Wvo9AiLOX2WqmKR2sDNxBKpJUopIRt1pKmcpJ9rFTkB1NggTp2sWty1x6WcT?=
 =?us-ascii?Q?+OI8breBLCVx2q4UidzGYPFqhg0++TjS/54jtD4HCtT7I76LUYBdV9UdgZV/?=
 =?us-ascii?Q?mnJMwfOH/dGSBPKvffEJVQjVcjUpAM0Uz7NzOidOhWc2NSKvxGpVUMGL7yYW?=
 =?us-ascii?Q?tdkHdIkxgVYEb39OsiJSA0RB6nYMXLSgeNJGtZA46paishhRxnVVg6NkglzF?=
 =?us-ascii?Q?rOGNyFrDBDK8u2fa0kEoDvqk/oWnWgqZ6SpXN8qmDE3QNHysMbMc8zM/IehE?=
 =?us-ascii?Q?6bo3kM6NzWKI3xKDK2W3rVYYH5or4B99jR9QCsl6SHeOGtx4ZfNkPwIJM5ln?=
 =?us-ascii?Q?KiTG2NnIANrvL+Wtj0f0SzPhrFsW7mxAkt0NSOW5vaJufkSR+S3ExL6ecS9O?=
 =?us-ascii?Q?9rYCez6g8dudeN2cZp8qH4v1bOlVf94XEw1kFWpLFXzRvJErQPUAdMf7wi+n?=
 =?us-ascii?Q?6nLr8oB2hchgaI78NIoNvy+6zM/xmsFwFD4xOYYaCtn+o2ki+udjeLdwD6/i?=
 =?us-ascii?Q?TzN7+erf5orBTd3JveLIiZXb77AWiRa+DaoTxs3ir+1wqVv0U0k06343jdfQ?=
 =?us-ascii?Q?DMdRKVXoqe9dQj0Eg4G8fWpjzgY6OXnfqrF4o+0K64PacLhZ2HiCGjUJwDNq?=
 =?us-ascii?Q?bBqhbBvLDnH5E5ULH2aWoyJQRYlf3y1ZMqcGHPyqawioXtR8WfzaRyW/BhRK?=
 =?us-ascii?Q?VwCajX80gkteh8gTtcxyATNPOH+X4uA7KB5Kn7nFIIOpcO9e2aBMhppP4YC9?=
 =?us-ascii?Q?1JpBLDkvx//ucm7luyv6V+wNrlk59nbeu5rYQ4hBHG0TjQiz2isDZiX75MJE?=
 =?us-ascii?Q?z9rrx1W5cdKEnZIt8RLuT6xFdA2qPa8mCuVugjC/+kgH62hKEHHn1TYmlLaQ?=
 =?us-ascii?Q?24JKTqZpV3KhswTJsiwivBhOsIW1M1yhdd48huHBoDVkX6xVLUguysNKO+0o?=
 =?us-ascii?Q?VrY4RlajJmnc9ozrRQr4HVQT9PENfb2c+G9JcOsUUQ82jCncnfjv8ZEEuxHT?=
 =?us-ascii?Q?B7ZbVXlHoNQYB/I4y6VRNOgE9fewh858HaSHH47ICxXYSVkBgq2RReo/TndH?=
 =?us-ascii?Q?yTrogLAPfvovXvbd7c7SnYsV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc5dbd5b-497f-469c-46e8-08d8efeec23d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:33:21.4230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JR/+jAg7DbyTBDAcnf1mtrRO9Dfvpyb2aSg1XGXIO9BBgz+kXGR8rUziQf1kKxWFuSPuIiokV45fXX25AZHMRkAkab4jC463bpcMgkhzc84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4162
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
X-Proofpoint-GUID: dlbILE5X--4yNY2CkgccXMT3dF-La5Cp
X-Proofpoint-ORIG-GUID: dlbILE5X--4yNY2CkgccXMT3dF-La5Cp
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch separates the first half of xfs_attr_node_addname into a
helper function xfs_attr_node_addname_find_attr.  It also replaces the
restart goto with with an EAGAIN return code driven by a loop in the
calling function.  This looks odd now, but will clean up nicly once we
introduce the state machine.  It will also enable hoisting the last
state out of xfs_attr_node_addname with out having to plumb in a "done"
parameter to know if we need to move to the next state or not.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 86 ++++++++++++++++++++++++++++++------------------
 1 file changed, 54 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 531ff56..16159f6 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -52,7 +52,10 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
  * Internal routines when attribute list is more than one block.
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
-STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
+				 struct xfs_da_state *state);
+STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
+				 struct xfs_da_state **state);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
@@ -267,6 +270,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_da_state     *state;
 	int			error;
 
 	/*
@@ -312,7 +316,14 @@ xfs_attr_set_args(
 			return error;
 	}
 
-	return xfs_attr_node_addname(args);
+	do {
+		error = xfs_attr_node_addname_find_attr(args, &state);
+		if (error)
+			return error;
+		error = xfs_attr_node_addname(args, state);
+	} while (error == -EAGAIN);
+
+	return error;
 }
 
 /*
@@ -885,47 +896,26 @@ xfs_attr_node_hasname(
  * External routines when attribute list size > geo->blksize
  *========================================================================*/
 
-/*
- * Add a name to a Btree-format attribute list.
- *
- * This will involve walking down the Btree, and may involve splitting
- * leaf nodes and even splitting intermediate nodes up to and including
- * the root node (a special case of an intermediate node).
- *
- * "Remote" attribute values confuse the issue and atomic rename operations
- * add a whole extra layer of confusion on top of that.
- */
 STATIC int
-xfs_attr_node_addname(
-	struct xfs_da_args	*args)
+xfs_attr_node_addname_find_attr(
+	struct xfs_da_args	*args,
+	struct xfs_da_state     **state)
 {
-	struct xfs_da_state	*state;
-	struct xfs_da_state_blk	*blk;
-	struct xfs_inode	*dp;
-	int			retval, error;
-
-	trace_xfs_attr_node_addname(args);
+	int			retval;
 
 	/*
-	 * Fill in bucket of arguments/results/context to carry around.
-	 */
-	dp = args->dp;
-restart:
-	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	retval = xfs_attr_node_hasname(args, &state);
+	retval = xfs_attr_node_hasname(args, state);
 	if (retval != -ENOATTR && retval != -EEXIST)
-		goto out;
+		goto error;
 
-	blk = &state->path.blk[ state->path.active-1 ];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
-		goto out;
+		goto error;
 	if (retval == -EEXIST) {
 		if (args->attr_flags & XATTR_CREATE)
-			goto out;
+			goto error;
 
 		trace_xfs_attr_node_replace(args);
 
@@ -943,6 +933,38 @@ xfs_attr_node_addname(
 		args->rmtvaluelen = 0;
 	}
 
+	return 0;
+error:
+	if (*state)
+		xfs_da_state_free(*state);
+	return retval;
+}
+
+/*
+ * Add a name to a Btree-format attribute list.
+ *
+ * This will involve walking down the Btree, and may involve splitting
+ * leaf nodes and even splitting intermediate nodes up to and including
+ * the root node (a special case of an intermediate node).
+ *
+ * "Remote" attribute values confuse the issue and atomic rename operations
+ * add a whole extra layer of confusion on top of that.
+ */
+STATIC int
+xfs_attr_node_addname(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	struct xfs_da_state_blk	*blk;
+	struct xfs_inode	*dp;
+	int			retval, error;
+
+	trace_xfs_attr_node_addname(args);
+
+	dp = args->dp;
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+
 	retval = xfs_attr3_leaf_add(blk->bp, state->args);
 	if (retval == -ENOSPC) {
 		if (state->path.active == 1) {
@@ -968,7 +990,7 @@ xfs_attr_node_addname(
 			if (error)
 				goto out;
 
-			goto restart;
+			return -EAGAIN;
 		}
 
 		/*
-- 
2.7.4

