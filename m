Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 429FEC4743D
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 23:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C360613BF
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 23:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhFDXoh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Jun 2021 19:44:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58792 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhFDXog (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Jun 2021 19:44:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154NeF0f029724
        for <linux-xfs@vger.kernel.org>; Fri, 4 Jun 2021 23:42:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=QftG14Ie9+hiiNeRtV7kTMEXLO4BuF0eUx9rNA/vsjY=;
 b=xU5aY3xgGKZzreJBP/ySNp5j8Ug0O6DmAhQ/2gfi4dRX4zCzUZi733DN6AWbesfbY5GE
 LAJcpHG0xS6nlcUfpjaNFOHwsNAFVV3bJiuZp16N5/5aOJONINsVAzw3Q4Uq605+z8fR
 xUvgFpIHOMzMFRK8LxrEI6OAn1Tff1A7KrsxHu31drk5mxskfjONBa7dJM8RL9P+bK4t
 ElM5dCl+myYWHsNpkCAjS6a/MEwdlKLIA/0n8eNvmdU6HYO/UjRyS8+Fw1Dmmk9yXTHG
 DTUouJub0T8x5n+tHMGNqja1EmKnc0LZ7FzfkC6rytIbr6njkIEfkevGP03rEKYK+eN7 6A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 38udjmy0w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 23:42:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154NdeCI039021
        for <linux-xfs@vger.kernel.org>; Fri, 4 Jun 2021 23:42:48 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by aserp3020.oracle.com with ESMTP id 38xyn50rsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 23:42:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kufIrysafj5WJ8IE/vP2TctveWk1U7bvOnE4j5vYSf2rHKMeeiqEZwb0gYO8qu3W3eT/2pzoDlV92z8yRP56WiDX5T8qXfiLML1tho+Nylpda4KZGemBSGFIiuPnj8ylPA1bS6+an/2O51rqMiHW189OWV0c7kJzndP6tJtgcsB8MinZZwznzEdqNtNPAFZchU3TI0550bnQ2jC4UZ/V3rmbitKWC05GeA5DJpJkVhL5AgGiNaFqFH+oKNsyG4z87IZnL6kuMOSyvb/NR9xQmCnak7U+gcJ6jgJK2Lk3ZtWKHnV5lnpolNzepC27AjtNMXMicPOPQ7nHiBuOSapvBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QftG14Ie9+hiiNeRtV7kTMEXLO4BuF0eUx9rNA/vsjY=;
 b=VDVyG5w7z6D41Uun83/cuKoDJeD8L/wW9pM5yDleU/nvfFZ9AUERTemAJbMOmVYhoA1kP1qFqtJvEQEWvqSuxtI2Ni5K9naf4tlUyU18lIdbDNxiNk528Hu50vc74DLDrgLVEaFD7u1IQ8eh5Ak2ntRZf7LqyQW/O+48ifNriUHcoapyfECwaiPjZWpMe6WiRqvb8fQ9yMSZuhikolNuaYRH7vrwyM4iFlVwd+G2yq+10omtmDBlD5cpARKC8mJ5de6/IlZ7jAjXX672E5SrQvw8aqVf7MnW/7d9cLlBX9CiIob5jrfQcs3AxsWfd083afk9jxU/0Ii3SVByktwpkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QftG14Ie9+hiiNeRtV7kTMEXLO4BuF0eUx9rNA/vsjY=;
 b=adKlpu3prz7ZeErDbP6lYbbujCD3JVojidkBz8+4eK3cuv0B1TJFYzaIlDruEhhehrjp+w3k4cTgyayic5xnFkuG+ERrb1qUThV5GDIKkq6L1gXWw/cUonx6BUc7ZMrD75QnGKwDXO4EGN814wY2sdZW5bPSCEaB9o8qkrXOVk4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5485.namprd10.prod.outlook.com (2603:10b6:a03:3ab::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Fri, 4 Jun
 2021 23:42:46 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.025; Fri, 4 Jun 2021
 23:42:46 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v20 07/14] xfs: Hoist xfs_attr_leaf_addname
Date:   Fri,  4 Jun 2021 16:41:59 -0700
Message-Id: <20210604234206.31683-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210604234206.31683-1-allison.henderson@oracle.com>
References: <20210604234206.31683-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR07CA0095.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::36) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR07CA0095.namprd07.prod.outlook.com (2603:10b6:a03:12b::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Fri, 4 Jun 2021 23:42:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9eafb0d3-a7be-4216-2d0c-08d927b27380
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5485:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5485D1888AC81473F6D696A9953B9@SJ0PR10MB5485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5NSgDlmx/JbGXo2pmeA2c1kDqjlvb+uMOqlBaMRvbupA6m9CVPh+QGQDrahBKge0nZ9K5BjoHXXi+kYM9eBobTnjdXFUd7xdCwhEY5+UhUPanH7JcBb1WnefbAwgtgm6iTThg1hUHR6W1E7kvLCBsnVVspp64Z5MyRgWAMR1AFK2XbXmZAw314iOudkJ27iNHWUdaxmzkhuOnNYM0i7Mft82nz0tzV+4Y8jzhrHy3iWnwYuJElUl9Sv24AigYSVFmyDyvc4tZ+O85XggT3k89FEwPBos/g4RTDir2kL3z7KKeQK3t9UqGRvjzJnTZgXvH/ZCOQhTSaHHQfyLNaZfTsEy2OK+3KNQk/xlZf9n336zGR4OCYwG6coWWW5xCZEsqwvzubunfV3zrDBBg/50W78axP7SVkuKIbx0sTqvRtCNIhIBc36CrdJGBHeqmYtPfU6o9g39ek8CFhVN2EoibW23px9x3rO/GHvsE5RzyLSp0oJkPBzlNw9qobuN3YwXB3afdly5TLR7vFyBJQz0S+yZW5TYOUp5trqaOTB+BfH6W5XtMNiTYdne8kDqLoZW9wAZYPGeAxwBC6h6DEGhVIp5OGxL8fjALHv/qSwc5MlOQfGKlxapn4bQsp/l5Dna33tNjviIBXSvnlpfiis3c0I1oG3DQGAbEYfl3QgIMu6KIZd7K6Q6dPMFyU+o0ZUt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(136003)(346002)(39850400004)(2616005)(66476007)(66556008)(2906002)(66946007)(5660300002)(8676002)(956004)(316002)(186003)(16526019)(6916009)(86362001)(38100700002)(478600001)(38350700002)(8936002)(6666004)(36756003)(26005)(6512007)(1076003)(44832011)(83380400001)(6506007)(52116002)(6486002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tAUeH50V1ywfASAZ9eA0fGE/YV9hOMhFhE8QiXGL5QL43VpbJYPXb4yMXzZ6?=
 =?us-ascii?Q?DXHGYq+zTgM1mJdIACjDPRpZgN5YLgu5KFAhjbZzcl03cNzQb2ggv4ggX85h?=
 =?us-ascii?Q?nhxxXBXSVK+cnyIBL0nLihCCzZmbooxAtApZSvoCfRIgTJHpqkQvhQW/0zm9?=
 =?us-ascii?Q?7eYgRtpLHDbE2rbVX3Q6w5Dal+xKR5vhtjDH7G3sjrxN+ldfLedHy2ZEGw1W?=
 =?us-ascii?Q?HNCfVG7BVJWs16/EVI6gGMr3+mWL8g858qNl+aACIFmYTIsPqVb9PGIm+B0x?=
 =?us-ascii?Q?DWdKupo7sLtKSfUT3/nzOBt0yN+2k/Y6CZkezvcBIOMcDP32WKfECT1pkukl?=
 =?us-ascii?Q?JAV/maDWfvXqrEVX/gMrnGf6xjMRYHfwmcn8OqeoMOAN4OP+c2/i5AabO2i5?=
 =?us-ascii?Q?AfVvI2EpWGZtqJVMB0ACt9G1L4HQKk8g4mhrmKluEfbfNpctURdxSmOVLchZ?=
 =?us-ascii?Q?Ndbf7iUMn9FTDPNd9QbAb4Tu9dLvLY6/arsSfS0tWp8HlAIP38alzD9WdXGE?=
 =?us-ascii?Q?yN5VqbYkUEK6AjF44P7/Z4rf2WUVd6BQPb83t8WYc1yiit3LHCtyKrqCRlJA?=
 =?us-ascii?Q?R8psHKvrzESc1autRqsopyZ/66zyZHLjJS+9AbKY2v5zJimGD/s5BKD8m6Y5?=
 =?us-ascii?Q?y7EARG4vP0bEXkNwoi2Ya1Q8aSl7aEnJR1kmeIJdP0bFnZ4vsp469T1zcl0j?=
 =?us-ascii?Q?5xVOWP25EVANOVKvOGhR5/Dvz6Yc5mGmAbUgfVgpsbpaSM/txU+wgwueAj0+?=
 =?us-ascii?Q?NRkn5dWwrg7gmmZhAJAp4HMeXeWYbcHTqzdQ0WUlKawUChMiol5I0pkSloWL?=
 =?us-ascii?Q?69a9zIGf3VpsbeITwpquW9k9BftmTAgmUBQuE7odEYWsJeIPEYiEO/fhBrid?=
 =?us-ascii?Q?so3WeYcM28Efv7pcBsHisucVVunxB9vVVUxxnlCf5K1NREJzPUdcqMNrFo4p?=
 =?us-ascii?Q?eLoX+9YEAMvCXKlKEpyKtuZXf+8ndWzz7pOMWQlxV2XeMs3wKvhr0Lws07n2?=
 =?us-ascii?Q?KcHrVZgU1a0E3B8BLXzItn1uUYsp129YPYQMiTUTGU5jCWpjacER7jWa/AbL?=
 =?us-ascii?Q?TaZ0LLk3HndeQ8smUaJ8Juwiv3szYP7dyRwPqsBE6uDPj4EDiocWkfR8c69j?=
 =?us-ascii?Q?bJ+olXbyi4a4mNDC6CYb+ehhGpuUm2/Hk09cXqvIs8g3UOwlr0VHRicelA/x?=
 =?us-ascii?Q?A+D2qxFdtTPzzmNlBNW536LxsMNYtcDULpx74vFKdpxTSgOhQzMyThXKeJNS?=
 =?us-ascii?Q?05CsMEaA2bodd57nutxcEpTPNYVXD/VpQ8bQqrqumv1RdgG7ACi3F0IHjpfg?=
 =?us-ascii?Q?TG0r2NbwFlQwsedgEEfrmcHs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eafb0d3-a7be-4216-2d0c-08d927b27380
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 23:42:46.4472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YuqqUOv7J7ZjHXPj2b00casbW6CDJOBNy/o3OX1KllyzJal9ZsI9kdykdF6xC6nQ+4zdbVL95/lkgHWzyYBMCqi5OvH513pS4e+Jxd0ACiA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106040162
X-Proofpoint-GUID: e6yfqVRPj67DoSJiqlTg41syCS-ry9sM
X-Proofpoint-ORIG-GUID: e6yfqVRPj67DoSJiqlTg41syCS-ry9sM
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040162
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch hoists xfs_attr_leaf_addname into the calling function.  The
goal being to get all the code that will require state management into
the same scope. This isn't particularly aesthetic right away, but it is a
preliminary step to merging in the state machine code.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 209 ++++++++++++++++++++++-------------------------
 fs/xfs/xfs_trace.h       |   1 -
 2 files changed, 96 insertions(+), 114 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b35c742..4bbf34c 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -44,9 +44,9 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
  * Internal routines when attribute list is one block.
  */
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
-STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
+STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -291,8 +291,9 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_buf		*bp = NULL;
 	struct xfs_da_state     *state = NULL;
-	int			error = 0;
+	int			forkoff, error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -307,10 +308,101 @@ xfs_attr_set_args(
 	}
 
 	if (xfs_attr_is_leaf(dp)) {
-		error = xfs_attr_leaf_addname(args);
-		if (error != -ENOSPC)
+		error = xfs_attr_leaf_try_add(args, bp);
+		if (error == -ENOSPC)
+			goto node;
+		else if (error)
+			return error;
+
+		/*
+		 * Commit the transaction that added the attr name so that
+		 * later routines can manage their own transactions.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, dp);
+		if (error)
+			return error;
+
+		/*
+		 * If there was an out-of-line value, allocate the blocks we
+		 * identified for its storage and copy the value.  This is done
+		 * after we create the attribute so that we don't overflow the
+		 * maximum size of a transaction and/or hit a deadlock.
+		 */
+		if (args->rmtblkno > 0) {
+			error = xfs_attr_rmtval_set(args);
+			if (error)
+				return error;
+		}
+
+		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+			/*
+			 * Added a "remote" value, just clear the incomplete
+			 *flag.
+			 */
+			if (args->rmtblkno > 0)
+				error = xfs_attr3_leaf_clearflag(args);
+
+			return error;
+		}
+
+		/*
+		 * If this is an atomic rename operation, we must "flip" the
+		 * incomplete flags on the "new" and "old" attribute/value pairs
+		 * so that one disappears and one appears atomically.  Then we
+		 * must remove the "old" attribute/value pair.
+		 *
+		 * In a separate transaction, set the incomplete flag on the
+		 * "old" attr and clear the incomplete flag on the "new" attr.
+		 */
+
+		error = xfs_attr3_leaf_flipflags(args);
+		if (error)
+			return error;
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		if (error)
+			return error;
+
+		/*
+		 * Dismantle the "old" attribute/value pair by removing a
+		 * "remote" value (if it exists).
+		 */
+		xfs_attr_restore_rmt_blk(args);
+
+		if (args->rmtblkno) {
+			error = xfs_attr_rmtval_invalidate(args);
+			if (error)
+				return error;
+
+			error = xfs_attr_rmtval_remove(args);
+			if (error)
+				return error;
+		}
+
+		/*
+		 * Read in the block containing the "old" attr, then remove the
+		 * "old" attr from that block (neat, huh!)
+		 */
+		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+					   &bp);
+		if (error)
 			return error;
 
+		xfs_attr3_leaf_remove(bp, args);
+
+		/*
+		 * If the result is small enough, shrink it all into the inode.
+		 */
+		forkoff = xfs_attr_shortform_allfit(bp, dp);
+		if (forkoff)
+			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
+			/* bp is gone due to xfs_da_shrink_inode */
+
+		return error;
+node:
 		/*
 		 * Promote the attribute list to the Btree format.
 		 */
@@ -737,115 +829,6 @@ xfs_attr_leaf_try_add(
 	return retval;
 }
 
-
-/*
- * Add a name to the leaf attribute list structure
- *
- * This leaf block cannot have a "remote" value, we only call this routine
- * if bmap_one_block() says there is only one block (ie: no remote blks).
- */
-STATIC int
-xfs_attr_leaf_addname(
-	struct xfs_da_args	*args)
-{
-	int			error, forkoff;
-	struct xfs_buf		*bp = NULL;
-	struct xfs_inode	*dp = args->dp;
-
-	trace_xfs_attr_leaf_addname(args);
-
-	error = xfs_attr_leaf_try_add(args, bp);
-	if (error)
-		return error;
-
-	/*
-	 * Commit the transaction that added the attr name so that
-	 * later routines can manage their own transactions.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		return error;
-
-	/*
-	 * If there was an out-of-line value, allocate the blocks we
-	 * identified for its storage and copy the value.  This is done
-	 * after we create the attribute so that we don't overflow the
-	 * maximum size of a transaction and/or hit a deadlock.
-	 */
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
-		if (error)
-			return error;
-	}
-
-	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
-		/*
-		 * Added a "remote" value, just clear the incomplete flag.
-		 */
-		if (args->rmtblkno > 0)
-			error = xfs_attr3_leaf_clearflag(args);
-
-		return error;
-	}
-
-	/*
-	 * If this is an atomic rename operation, we must "flip" the incomplete
-	 * flags on the "new" and "old" attribute/value pairs so that one
-	 * disappears and one appears atomically.  Then we must remove the "old"
-	 * attribute/value pair.
-	 *
-	 * In a separate transaction, set the incomplete flag on the "old" attr
-	 * and clear the incomplete flag on the "new" attr.
-	 */
-
-	error = xfs_attr3_leaf_flipflags(args);
-	if (error)
-		return error;
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-	if (error)
-		return error;
-
-	/*
-	 * Dismantle the "old" attribute/value pair by removing a "remote" value
-	 * (if it exists).
-	 */
-	xfs_attr_restore_rmt_blk(args);
-
-	if (args->rmtblkno) {
-		error = xfs_attr_rmtval_invalidate(args);
-		if (error)
-			return error;
-
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			return error;
-	}
-
-	/*
-	 * Read in the block containing the "old" attr, then remove the "old"
-	 * attr from that block (neat, huh!)
-	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
-				   &bp);
-	if (error)
-		return error;
-
-	xfs_attr3_leaf_remove(bp, args);
-
-	/*
-	 * If the result is small enough, shrink it all into the inode.
-	 */
-	forkoff = xfs_attr_shortform_allfit(bp, dp);
-	if (forkoff)
-		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
-		/* bp is gone due to xfs_da_shrink_inode */
-
-	return error;
-}
-
 /*
  * Return EEXIST if attr is found, or ENOATTR if not
  */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 808ae33..3c1c830 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1914,7 +1914,6 @@ DEFINE_ATTR_EVENT(xfs_attr_leaf_add);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_add_old);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_add_new);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_add_work);
-DEFINE_ATTR_EVENT(xfs_attr_leaf_addname);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_create);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_compact);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_get);
-- 
2.7.4

