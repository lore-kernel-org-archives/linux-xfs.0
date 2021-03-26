Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85230C433E9
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6921461A0F
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhCZAdh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:33:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57580 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhCZAdZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:33:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OJ9J057396
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=9JWfLLMHh9FuUy7F/QPdDZSUMvXZ8qkkmQeUODCuZ0Y=;
 b=eJKpS597dLqVWdAib0rdorj6k6J6kOoaEI44V5PCGSnaNOnsYhucrho85FGjk4fCUfT9
 LiLLpZBTuYoqcQdNV/jXUBcPGQkhfgAwIox/hS2vv7vepXJw+pSiia7J8xNOGYVqjPNn
 SvbolxnhY7WHCiNFWFrnjVUXEF42BWdlwdenqwC9unIF+jli+PLpzIbtb7EfwqocxSsw
 WFPs/mrYqWZ8anxDVtSDAcz1oTxPxjxFEUxp/yaM+3zLe9AKCxf1kUSO7joDaxJkYaGA
 Bxt2iS4ofcwajlJF8BIHzFy6Hd8zUXnHqycaFsYPBZLgbdwHwFDOSNzSTiyL8baO3wMw NA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 37h13e8h64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PYwL096811
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:23 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3030.oracle.com with ESMTP id 37h140qtxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RbORL7tP4T0phuv02m3N9uzejTzyvWVSa7IRzqD+CVeLYdANgu/tu6ReCW9Ba/EG9QR6hIXnWxB0xuyMVuDEkzg6Vj7d9BQouPANYiGe5uamnfTeWjFT91ONWTLLzElN93ouyElZDn+7wGDbpe5tZEapyWB4OOYlxd5c7mLqxseKo5fZCJcajfCoXEZHW02SIOg3F7mbZW9fEajlzUX4zHPgVhU0AXCqWRzZG/HyBOqClqfg7eC+5kMTPtK2ynfbOpjrmvFFPI5gJUZLjPfXzK3Ct8F/COOIimvuHhpHKpzrzeU1NRBQdFckjuhl1bUhkSYYV2lRxxRX/JJVuJ7/YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9JWfLLMHh9FuUy7F/QPdDZSUMvXZ8qkkmQeUODCuZ0Y=;
 b=iuEU4aJDz9h/4N1h6p/S/ICcvx5vwBL5qY7ldvfbL/mnipFskcuALXWoIg8YEjWp9iry4Oh7aMshKDVPHbzRHvofX+IlU3DckKXNQ8Yn+3kdcPvn6B6ssv6GLBnS2Es8iQpw9wEtix6h+wEktKAjRoFC4i6uMcoD/IKRfmyqTZ7Lv/64W9OeamAI4FDpm50mMj5BrRdEkoH8/FvgXLLw6vvvklZEpcn2YEM9WDg+7+2SRb7QcZZSsgO4vnz24h8zRZcw1Skt/wpHOxtLbc0FEDFh7qZTcRLjyKLbHh+CK+u+8uHb3s8J999YpKJrcZGHzQymuwaYs8EFaHcTn2yFWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9JWfLLMHh9FuUy7F/QPdDZSUMvXZ8qkkmQeUODCuZ0Y=;
 b=HcSY2Ll/8HbxoXmy3x81rvBpuGBZtmleGQgxFj+IjTTKxQdsZArqBXNdJv2Bf5yayBVg7McmDnleff9OgFG57zXwYCpwYPgeTYpXQEI4LYLUEgYgv2/+n1WHc74NFg7HV3LxAur9bCqPDd3hx9U9oBOqn3GiYgAkthvZbjTAbNk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2645.namprd10.prod.outlook.com (2603:10b6:a02:b0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Fri, 26 Mar
 2021 00:33:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:33:21 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 07/11] xfs: Hoist xfs_attr_node_addname
Date:   Thu, 25 Mar 2021 17:33:04 -0700
Message-Id: <20210326003308.32753-8-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 25109b17-a098-4f03-796e-08d8efeec270
X-MS-TrafficTypeDiagnostic: BYAPR10MB2645:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2645F22C2CF3B007CDE51FF195619@BYAPR10MB2645.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dr+0XcgvTDtqu9p4QE7xGUE8Gw5s31CMsxqEsM1gD9TinqU40VN7Px8MRFvNlpBzTQAYiMyf47BueVrs+CZqVVV5uRIKQu4A+cKcc6rxEHQXMwObgqVsPX1O+i2jT7T/94Qc6ht4/thFg6C89aguJmnszH1MMZEQ4Qq/EOHhSxjSF9s/WVLzrsuI946tymhV7DslZJY8CHj0f0/mShz0301DZYGPFZ6NrApp69Qvfo7i5CMd5kEWo9vU2yD2RZp53QHkCRLxYpkxlWcAt4IMlvYriFoMZ2keWdxjhepgvf9KETYFfBIBYTJxSdcRMSaxsByQTcNYEDicufpXGl7e/MCzN4P1kM3PJMf+iqVggRyjrJQmAxnI5mjpimRp0JWhQe03SJ6HdKFXTNTlS7mbHPHeDVZBn/gcnU+TS3BnGc+oQZtd/vERF9G3qZeU5lh8mglcpAL7SAdtxU90tAiDwNbvb1Frr/+PO2gabAieHw6t3HZtsnqGoH0wADGpOudXrQcePmexH3CGzMUJHXEMb/nsSypD8mrZGNFEHmyYBCknA3L9pbOmC6jbxvDn2TynIShQUxnVH6MZ/LS7Yma5OhHkrC6C5xVy9AdoHK+6uTz2NB+yn7NSWA3acSmd7t58I/uZcr/PnvwgJQ9GmlA+ZjUtQ1LfuZg97EI/SgDxWbsD7SOi9U3aAzp++nfvbATi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(136003)(39860400002)(66476007)(478600001)(6666004)(8936002)(66946007)(86362001)(8676002)(1076003)(6916009)(66556008)(52116002)(5660300002)(2906002)(956004)(6486002)(83380400001)(26005)(6506007)(186003)(2616005)(16526019)(38100700001)(316002)(6512007)(36756003)(44832011)(69590400012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EY2VApNb+CTN4XKeJpGWn75AE1Dg9q4uqhZ21YDDrVw6wkLeOkJoaMh/wzKm?=
 =?us-ascii?Q?tlkkwF0KA2n4YkCYLN0L0NVLQuA4fld7IL6cOxt4iHx1rQ1HlJBd1qZ+/UgI?=
 =?us-ascii?Q?O0yiIuUFDWa6KZuIpBKv21JdxL8M+SIasF4qu/2PJU9cGwXp6aXk8ZRelfnb?=
 =?us-ascii?Q?FEcoAka24YQ1XOlfD1vUMGmZOCrYoDuSpJ970Sbg8F4Z+dbDqQTm/GeSz6SO?=
 =?us-ascii?Q?CS2aRhqrqco6d+P4ZpygbpZVKZvXrK55EsLtTlecfcQ33nnXNwAfwxHB7Ah4?=
 =?us-ascii?Q?Ic1c+xERAyIrduPeBLpdW+4SPeo14HEk5UEq2PVfuHkwpdhWuddF+bhQlVZX?=
 =?us-ascii?Q?Y+u/0T/Gg9kwCXOPpCxd8L9DiijOvS+9RbMultZwT8W4+rhZxb91iKW2z0RQ?=
 =?us-ascii?Q?46sFRaClTc+8vHfoILUFlp5eoQZE5h1BbIQnEpKUnTC0ctbks7cNMOeBGvVi?=
 =?us-ascii?Q?etqiY6SWJHIDqGuiG338gtKH3Ve55k1kJbJo21ABQrp4fVocpW1yLyvkLmHR?=
 =?us-ascii?Q?vFTFg/syaSx5QLeC3BqE/6qiKXfQMWUoA45mpRnY3Z1MffcjtW+j9Zp2zUBU?=
 =?us-ascii?Q?1MuA2fRiAIY96vhKZk4ixxJa9d42ij9e381qv4fv2fC1KLcsFlmrZ36f1s1K?=
 =?us-ascii?Q?GWbzPtI+9Rv8viJom67cCdt/f5NWW0u2XsqcRyudf8xl4fYY1kIgb8f+r1qW?=
 =?us-ascii?Q?MnRay8LzeZpiO4e02ikiQQ6q29ucLWTlhDqWcVzbmSE6crUkERpTJlrRGaWa?=
 =?us-ascii?Q?rPeNmR8dcLxggYlmVNsVB8RBFeundlLTnchSkgGIeP57x3ZTHWVI0+SrIc2Y?=
 =?us-ascii?Q?csRyL8c10Zb7x++0miEd1ZUC9Q9gqo9HGiO9txz2l0HfJLlsV6Jf3G1Gjla1?=
 =?us-ascii?Q?rPdaxyIcER/M+CjHqiAYMtijKCKXEQvlTv7dFG5KbVlXWb2ezaMVOnsbIP3p?=
 =?us-ascii?Q?pThC6pF0ZDpEAk91VwWWbCxCI8sydYQ/pAtIgPtlccWusJGqw5LgnqwM0gis?=
 =?us-ascii?Q?GXJJ7/KujJl92uHTgKy81GFvBDACcEvaXxbHW54hqZ9YTa2EkJQor/88zlVh?=
 =?us-ascii?Q?P2JY6U37Ks0bRjMYN3i0Ra3+knhQoK8bbqKi1ncSwt+qU5Ib/tW+csHyrxk0?=
 =?us-ascii?Q?2DRC/ukfOEmF5DX/ohEC1Pij0+4RKvdzyvzFbZCaAHmfXA5t5r7fIA4RejQz?=
 =?us-ascii?Q?V7x9uDkU+VeRPWtu0LjlsaBWkFABDe9oo36LZX5t++Fws5BLPBzdNEDwZk4R?=
 =?us-ascii?Q?+mG62uWLuDwvh6/jQ2f70KHpLYWgPgaDGFT8hJseuK8+NSA2kKniusyT07PG?=
 =?us-ascii?Q?xf4inE5aE4ORNggybNLBoFiD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25109b17-a098-4f03-796e-08d8efeec270
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:33:21.7734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hv9crwFlsZGB+wHpvscoBzD+krHglYRaEXWEVcEvwxDNYSU4PCh4nkZyJU0DFf707DIS8F1l4UF9mA8LBA26Ave/KISRqY45f6y4qX6nz0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2645
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-ORIG-GUID: SuWO7oeZE6zVMrDJoFCWs-ECUJv_8Lc2
X-Proofpoint-GUID: SuWO7oeZE6zVMrDJoFCWs-ECUJv_8Lc2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
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
---
 fs/xfs/libxfs/xfs_attr.c | 161 +++++++++++++++++++++++------------------------
 1 file changed, 78 insertions(+), 83 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 16159f6..5b5410f 100644
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
@@ -270,8 +271,8 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_da_state     *state;
-	int			error;
+	struct xfs_da_state     *state = NULL;
+	int			error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -322,8 +323,79 @@ xfs_attr_set_args(
 			return error;
 		error = xfs_attr_node_addname(args, state);
 	} while (error == -EAGAIN);
+	if (error)
+		return error;
+
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
+	if (state)
+		xfs_da_state_free(state);
 	return error;
+
 }
 
 /*
@@ -957,7 +1029,7 @@ xfs_attr_node_addname(
 {
 	struct xfs_da_state_blk	*blk;
 	struct xfs_inode	*dp;
-	int			retval, error;
+	int			error;
 
 	trace_xfs_attr_node_addname(args);
 
@@ -965,8 +1037,8 @@ xfs_attr_node_addname(
 	blk = &state->path.blk[state->path.active-1];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 
-	retval = xfs_attr3_leaf_add(blk->bp, state->args);
-	if (retval == -ENOSPC) {
+	error = xfs_attr3_leaf_add(blk->bp, state->args);
+	if (error == -ENOSPC) {
 		if (state->path.active == 1) {
 			/*
 			 * Its really a single leaf node, but it had
@@ -1012,85 +1084,8 @@ xfs_attr_node_addname(
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
 out:
-	if (state)
-		xfs_da_state_free(state);
-	if (error)
-		return error;
-	return retval;
+	return error;
 }
 
 
-- 
2.7.4

