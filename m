Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5174EC4743D
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 23:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B34B613BF
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 23:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhFDXoe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Jun 2021 19:44:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33310 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbhFDXod (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Jun 2021 19:44:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154Ne6sf062244
        for <linux-xfs@vger.kernel.org>; Fri, 4 Jun 2021 23:42:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=/0kr+2CVZ0D/nnuFADMy7+oShmgC1zOjuTk0MG5Scb4=;
 b=BVK72dZcwfuJjI5agsJzvklwVj+mwxciZDvBu9VaGHmpOcBUVyzGmZNT7y9o3/LZzDg9
 7tgeHAhLNVLaYd4frSX4pN8IGfu+9/S2opL9Z1otEeRKgn77GwNRnxGB6CJsmbbLpDcR
 tVWYPUGr/+921JqD9uHUYC98Lm1+1vMWSwF6hzMzGFXUgh8yGQWsntbfygt1n0HTnBmW
 nw4+xjOdLQa6cqJMe0qVz/G8TOGhl2rYZNvkzs7FKBqfSHFyDBvXtwf4KXMp4AiK/YCy
 S6qwzxWDz5k395CFg+kpx69yHNeQcqTEHHy2FHOH96idOhkHBIfyXUtCt7m8jNlSQreC CQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38ue8pq0gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 23:42:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154Nde6X038999
        for <linux-xfs@vger.kernel.org>; Fri, 4 Jun 2021 23:42:45 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3020.oracle.com with ESMTP id 38xyn50rqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 23:42:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YLDobFoFG+OwkG1Y1XlBBN1MCu5wIweWVAtZxJF+b9E8K3RFelWm+lERAITo3bqDNLDr4CV+l82WM4sM1Pnxl24cVLQXiF8bZ8B4kX9ApyfB++u8CBmdSQg0yNvzZ+/+ZCKSo2WTI8seM9SFxIhcXXK5vA9zLvZ/8KNjf/z1Fas2f5twrse9TFu1l45kRwPXtUpUYyxZOD/4weFIBCS0343HkonSEOOL9ledyKjbovIWKb9gMpyJXTJF2MKNsPU4rj2gjliKQXg8l5H7DOm5q3dctCIKut+sQjscsHkpMB7iBpVpvriBgJGXhGzmFOqF5q62OffIywUxb+Kh+Y8p3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0kr+2CVZ0D/nnuFADMy7+oShmgC1zOjuTk0MG5Scb4=;
 b=VVO5a4aLoLS/S4Qpph1qi2OCRbGghnG2Ux6hFf0A9I+QeuuONXGwu5v112S61wfdolClKrBCyMQYOAvaL43tmmoIvIVP4kiipoPOhLSO1A8qIREgogZA4kE73xv4J7NQQHFa8h189ydku33g1bgSrrFm1JA122aRNYQoeHISplIGLZllbFnffC0wOS9zL77TwxV3vDzhey3fREjILkaXTuqdyzzd/teNoMCeiLgT9LfDVlYLYHElMoJdB5YaxLR6OGcdTDPSGH8Qbr6iICa1RdtwOz0o4GOXhi+XDTcaXL7CI7fW88B+BRdLheWjykEb7L8bKHfajwUOT6KtUO+VZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0kr+2CVZ0D/nnuFADMy7+oShmgC1zOjuTk0MG5Scb4=;
 b=ICyvLeHinigy03vCPsmxGfTZnoNXnqzEXXO/97H33CfW6+tYj/i5C3u5gBPGm0dFz8MbMBjMI+MMMJYzHBno6uCEikxpUVZE1Dw6onUF0KSx8sE2Dq3oQFR9B0dGF5VCDnzPFUYMY3Gk3/U1hfVme4q3ZetS4m2s01rlx3IpLZM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5485.namprd10.prod.outlook.com (2603:10b6:a03:3ab::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Fri, 4 Jun
 2021 23:42:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.025; Fri, 4 Jun 2021
 23:42:44 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v20 06/14] xfs: Hoist xfs_attr_node_addname
Date:   Fri,  4 Jun 2021 16:41:58 -0700
Message-Id: <20210604234206.31683-7-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.210.54) by BYAPR07CA0095.namprd07.prod.outlook.com (2603:10b6:a03:12b::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Fri, 4 Jun 2021 23:42:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d543f933-67ae-49fe-1503-08d927b272b3
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5485:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5485FA5370AB327C048F2DDB953B9@SJ0PR10MB5485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6pVO448RBAy/ekEAQ+7zyCZdrBGbLcpephuSOVZYxvTMmMmTZjxRxzUsVy+x4+g91yNnVDgETg0A1QYP4xw7Vs3ZkTOmwOyi4lSspzO/urd9ebrH5ImT/7cxsHxfcAo6+Yb6D+8f6ExFW3fAzSigbcYk0Vgpas6hUL7a+wjsC2X9BceDpwMDVxWowQ+zz7hNC8DmGamfC51G82CHQ4Qr1npGEdZG+YKsUtPM2DYK/1ExcQZ7LcvaTdOR4SfJFFu4r+MFtBbfqp7MHVdHtmEY3U+uDDO4NLEpyEKZKOCW7UO7InYyyR+llbcfuXE2ieEIqq0wix49Ao7ivylfIsgW7tjmS+/zHCicpR+hrVP6UdbVRevR7KCVMQir0RZFBb5kHD4yFtB8c/wR7FyFjj80NIZ/78PmDqyCMeOsjHlvWmA7J5uK1ZtqLNscWdvrs5ael6W8p4rWv96OrSROF+m5lr3DB/IipWPqQhdyOtF/g208Whtq7FEO+m9+VCn0P8Sp7BNZ974h9hsuvL4PQLwCa2GG8UjGuRnvyJoB4KYYsgdyt041rgL8DTEQMUkat6tKbnNc5u8mhiVFTbN9npYEHVZVHXgLDlSh7Rr2XemBbP+DiHn8zS5qSH11rit/b6xPZn13M+HeVzMSWzvVJhDI7WD4jQHBr9dF1MY2d41etijzXEN2kI1BsMyCVuj1trEh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(136003)(346002)(39850400004)(2616005)(66476007)(66556008)(2906002)(66946007)(5660300002)(8676002)(956004)(316002)(186003)(16526019)(6916009)(86362001)(38100700002)(478600001)(38350700002)(8936002)(6666004)(36756003)(26005)(6512007)(1076003)(44832011)(83380400001)(6506007)(52116002)(6486002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7ENUthyLp3MDaHxoCSHANtDLLpHTAHjvZR5YAsF/JQbAu2xn+mbFi3gJmI1S?=
 =?us-ascii?Q?0UzJdbLCqFCZ1eBW9Kg873T6wFCGhjTvPGXABtBdS8tb+WIBbhA7VV6tpqmj?=
 =?us-ascii?Q?6ythc5qobMs3ozTdx+H4CsDj3PCmafMImFROfKZTRb/p6BDw1KflJDLu4nSs?=
 =?us-ascii?Q?KHl1wLzxfGX830oWXoD0LGREgF4763TkFYbmxmMMXRnXO8QZECQi7ZHGuPp5?=
 =?us-ascii?Q?eH+PtlxjifJj8+uCyjXPJJXxkyoM7ZqzNTJu/AxD0Pgjuj3e50oh4Ox7AQSk?=
 =?us-ascii?Q?zQN6OItUOThson5/acdzfYc4LDrLjtJ8RRvfGjvR22Rqq/Pf5U3j52JqmS5M?=
 =?us-ascii?Q?txQxFpWCKVIWk4vav/pZU7NskB1j6gjhTjdRreiD4v7D+ADDnGdsC9berd2Z?=
 =?us-ascii?Q?5/jbp3KYKojQmvCUl48hQXIgqwuCIYf9R/yEouoGdpuZZQVooC9m3Pq2c1LT?=
 =?us-ascii?Q?wgv01QMWn2itJiRdN9BO+mnERdUiNLSF6HPkm0JwMv8K6pD5tM22GAnngzuK?=
 =?us-ascii?Q?3h7AXiHM+f91c8nlCrjVrTs5gOMC0nXFsE3L8N9FHCRhpibZ7jDjycircXY9?=
 =?us-ascii?Q?KNEBUD3824fHf2i0fahwQADcOR7bSM54KoPoCaNkGs1uOZRc2koWjOkpFDOc?=
 =?us-ascii?Q?c2O17fywUkyWYzvGoXZnZqXR5HN2TJQubEXaql8pf1tIynvYt1nIeRZF6SQd?=
 =?us-ascii?Q?KZtR7tcnJ5niZPDaMA1agJhobbV+3Ts2Vc1nin8Z0i9aQ+XKI4ZF4l81ZFir?=
 =?us-ascii?Q?FPkQXSXw/ed5ap+MEJrjXaMTdmC2yqXaBzG2A5IyP4KBs/Bxw1iJzDJ6qobE?=
 =?us-ascii?Q?gZRmn71gqD58jnK5TeECQIJCt8OSqU+0cnS4+EfiMQhPniNhBQqZzQbsO8lV?=
 =?us-ascii?Q?Dlzk9Hj6Yad3OyBvGv0W6kNa4rMLiucJe9NVQDdtEzPAJljSztW6BCW1A/Wg?=
 =?us-ascii?Q?xXiKRMLJ1C5VREnrIsgVQr53gbhboDhw/doyeZMTshbHhJpNSaHVDyEuHdX6?=
 =?us-ascii?Q?Bv0bDWkevZ5ZfcnrEM8TUVy17C/lCOciedB1i2h1CIDzc3oJJvAU0UJd+Vdb?=
 =?us-ascii?Q?kJdvuAgdA3tB0NqsarOD6CYAHAoa8EnK7dE3uUkfd/HqKLMRhmCUmRaJPBNs?=
 =?us-ascii?Q?P/MJj85p+J+/W3MaWDw+LbhwBA6ukQskIPp3Hxf54sEtH+qcMX7tvrSkDucY?=
 =?us-ascii?Q?afRcsp1afgJJynL1yjq8Ji9hBVEzZ6gpJzo9N2kZDevpDa8FRnj2/VAsP1FZ?=
 =?us-ascii?Q?PYjCJY+JUn30+7+0hXNxPs8rMWPkuCkww8x4TgX+/gzkdpOkkXmf/Tdh2Fhb?=
 =?us-ascii?Q?JrKjxTuRW+JFW1aBvo1XbtxX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d543f933-67ae-49fe-1503-08d927b272b3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 23:42:44.1254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 48/t1rpfPt7mOGYFFnMrZY4LuNpxcr3ts1TtkrbhNpwz8I6qQuaGzLtU6XQZB+2S1bVZ+52cmS7urKJGRoqnHO7m6d1U6gepGU2p8PnMy6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106040162
X-Proofpoint-GUID: NrbRMNPn_jCOdNf-yclTcKbUeBXOfKxO
X-Proofpoint-ORIG-GUID: NrbRMNPn_jCOdNf-yclTcKbUeBXOfKxO
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040162
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch hoists the later half of xfs_attr_node_addname into
the calling function.  We do this because it is this area that
will need the most state management, and we want to keep such
code in the same scope as much as possible

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 159 ++++++++++++++++++++++-------------------------
 1 file changed, 75 insertions(+), 84 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 5f56b05..b35c742 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -52,6 +52,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
  * Internal routines when attribute list is more than one block.
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
+STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
 STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
 				 struct xfs_da_state *state);
 STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
@@ -290,8 +291,8 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_da_state     *state;
-	int			error;
+	struct xfs_da_state     *state = NULL;
+	int			error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -342,7 +343,75 @@ xfs_attr_set_args(
 			return error;
 		error = xfs_attr_node_addname(args, state);
 	} while (error == -EAGAIN);
+	if (error)
+		return error;
 
+	/*
+	 * Commit the leaf addition or btree split and start the next
+	 * trans in the chain.
+	 */
+	error = xfs_trans_roll_inode(&args->trans, dp);
+	if (error)
+		goto out;
+
+	/*
+	 * If there was an out-of-line value, allocate the blocks we
+	 * identified for its storage and copy the value.  This is done
+	 * after we create the attribute so that we don't overflow the
+	 * maximum size of a transaction and/or hit a deadlock.
+	 */
+	if (args->rmtblkno > 0) {
+		error = xfs_attr_rmtval_set(args);
+		if (error)
+			return error;
+	}
+
+	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+		/*
+		 * Added a "remote" value, just clear the incomplete flag.
+		 */
+		if (args->rmtblkno > 0)
+			error = xfs_attr3_leaf_clearflag(args);
+		goto out;
+	}
+
+	/*
+	 * If this is an atomic rename operation, we must "flip" the incomplete
+	 * flags on the "new" and "old" attribute/value pairs so that one
+	 * disappears and one appears atomically.  Then we must remove the "old"
+	 * attribute/value pair.
+	 *
+	 * In a separate transaction, set the incomplete flag on the "old" attr
+	 * and clear the incomplete flag on the "new" attr.
+	 */
+	error = xfs_attr3_leaf_flipflags(args);
+	if (error)
+		goto out;
+	/*
+	 * Commit the flag value change and start the next trans in series
+	 */
+	error = xfs_trans_roll_inode(&args->trans, args->dp);
+	if (error)
+		goto out;
+
+	/*
+	 * Dismantle the "old" attribute/value pair by removing a "remote" value
+	 * (if it exists).
+	 */
+	xfs_attr_restore_rmt_blk(args);
+
+	if (args->rmtblkno) {
+		error = xfs_attr_rmtval_invalidate(args);
+		if (error)
+			return error;
+
+		error = xfs_attr_rmtval_remove(args);
+		if (error)
+			return error;
+	}
+
+	error = xfs_attr_node_addname_clear_incomplete(args);
+out:
 	return error;
 }
 
@@ -968,7 +1037,7 @@ xfs_attr_node_addname(
 {
 	struct xfs_da_state_blk	*blk;
 	struct xfs_inode	*dp;
-	int			retval, error;
+	int			error;
 
 	trace_xfs_attr_node_addname(args);
 
@@ -976,8 +1045,8 @@ xfs_attr_node_addname(
 	blk = &state->path.blk[state->path.active-1];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 
-	retval = xfs_attr3_leaf_add(blk->bp, state->args);
-	if (retval == -ENOSPC) {
+	error = xfs_attr3_leaf_add(blk->bp, state->args);
+	if (error == -ENOSPC) {
 		if (state->path.active == 1) {
 			/*
 			 * Its really a single leaf node, but it had
@@ -1023,88 +1092,10 @@ xfs_attr_node_addname(
 		xfs_da3_fixhashpath(state, &state->path);
 	}
 
-	/*
-	 * Kill the state structure, we're done with it and need to
-	 * allow the buffers to come back later.
-	 */
-	xfs_da_state_free(state);
-	state = NULL;
-
-	/*
-	 * Commit the leaf addition or btree split and start the next
-	 * trans in the chain.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		goto out;
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
-		retval = error;
-		goto out;
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
-	error = xfs_attr3_leaf_flipflags(args);
-	if (error)
-		goto out;
-	/*
-	 * Commit the flag value change and start the next trans in series
-	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-	if (error)
-		goto out;
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
-	error = xfs_attr_node_addname_clear_incomplete(args);
-	if (error)
-		goto out;
-	retval = 0;
 out:
 	if (state)
 		xfs_da_state_free(state);
-	if (error)
-		return error;
-	return retval;
+	return error;
 }
 
 
-- 
2.7.4

