Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29BCC43461
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A566C61006
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241684AbhDPJVb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:21:31 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49770 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235280AbhDPJV2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:21:28 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9AZ20043198
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=dqi2bBnFzGGb1FkLhGADDXrjUZrQJbciyykmlsmnP+k=;
 b=J+Hi68BN4CYWbE3T9mOwA9WqmLF8a5403I2k5ICAWD+//U1mVbaIRmS3dk3ku+/Xh5cW
 hMyz9JQmbzkErHEoCPBiEMZLwcv8IbXcD36RGEP8azQpZNnle6QT/m2bsx8Br8ne9m5A
 XuUjjkmV8GxcnCvX7PfpnJYjKIcA29v6eZfVMUYGT2nnj+kaIHYGbV3Sr+ASyntOF9YG
 kqPPMnkZbFkZNbrkvowxKMAHmwTE+sE3Z8i7i0/84BU2e+e/y9ptisOhxDoIRss20X5D
 3SVI4m27Mgeh45AOiiqZFgpCPm6l8HlZnd5DfSFnSwpNA6S2y1dgDsMY7oBu30SLQYHq BQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37u1hbrpfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9AXT3077147
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:03 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3030.oracle.com with ESMTP id 37uny2cegt-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnz5ghYoBFXiEDSv4ij7D1O773ZAwz6IF2gTpQGMn3r0M4yCuqPPQzBCVehTnZc/uiDk+ojxcxzzjHqs94o3BR9wFv95vpFPvfgHRttLs1smvcSjqDpCdfqI6/XzBG0MxER+tQ9ZdgwHjlMnmQZeSChKT5bf3RM8cclgnfjShQ54iSRjG7I+c4CcaAUANPNspHRNrWTJKQWU2OPsPQ4odBpllctaBPRj77+xo0e4Ghnb05xOHBPM0QamKWTpCvakoLOM+F4wasDTL5L5EspMkikRNjMeXvAaJqf/k2wM811OFsRYWYC3oJ2IIyy0FhrdBNKk0lTgzcTdYLexA9hETw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dqi2bBnFzGGb1FkLhGADDXrjUZrQJbciyykmlsmnP+k=;
 b=RKYFlQN3HuAie50ExXu+XWC2bGMc5fVBb6LkUQR2RGDaypBcUi/U/G1HWCF1gUTBSD8utTjelL+Qva8VZYyK5Y+uj/6lze4B+7escMZ8HetPLwCqQNU/InghQ/P/im9v8fgffEWipRReVbRjG305AqO8ansXG9OfJ52H1LmV7H9+LIP9/LQPU1vyD8KO/I4hSi0IJZTPYlj2tJW581kbI/XvJWhJCHsMykhs7WZBM+Zi7Miz2mZ+93P/16oMrG2RrzVIgbU7x12qOH5pEBvDYxk/1Aam3L0CFTQ5y1usXBXQrGH8Jgo74W9q7y5mvrRALRYQseyN42ISu0aNYQ1nEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dqi2bBnFzGGb1FkLhGADDXrjUZrQJbciyykmlsmnP+k=;
 b=lQpig2lYb8SdlfFmD4LCtbC/im6vQioy48P8GG2n7R85RN4XUc6kipaAZESNzw+pYzKVOFHDNlt4fbG2LZH/NJ+ZaqfLQehijqX8xw1g96Swy+ftIVJyaNx5NzZjB2Vz9KSs1BNofYhdV8C6OJZiriVmYnZy2tLykXcNhD7ckCM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2567.namprd10.prod.outlook.com (2603:10b6:a02:ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 16 Apr
 2021 09:21:00 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:20:59 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 06/11] xfs: Add helper xfs_attr_node_addname_find_attr
Date:   Fri, 16 Apr 2021 02:20:40 -0700
Message-Id: <20210416092045.2215-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416092045.2215-1-allison.henderson@oracle.com>
References: <20210416092045.2215-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BY5PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::42) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BY5PR17CA0029.namprd17.prod.outlook.com (2603:10b6:a03:1b8::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:20:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eddcdee9-19d6-4ece-0205-08d900b8f2af
X-MS-TrafficTypeDiagnostic: BYAPR10MB2567:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2567C58D430DB1F7756FF409954C9@BYAPR10MB2567.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mzp40lpr+1U53UGaEJISM7hOUP42OfBmFojn2nsosx4A0FC0A4UF9B3Hp3qoyJOGRix4SK1v9GtsP0kGVImKN7Gsm8Ql2tl8U2WKtrRWd0kxO/RhGfVpOgz1sFJb2yL7jE1+LUx3yyAe8uNAyH9s1Uq5sDoRYygtaaJP5wC7OJ7Qzrc/LrZgVp/dqPHyHVieF+UEMrcbMQ4BZlU3+aKYEKwWhqVj9FEfKhsMzCLUdviCqRwirDe0CDTHPU13WG+tOeEv6PfbxPmy9/aATdcj+pKJlEdphs7guzcSgDmpKmX2iAUFGp95olIpjSYad36wdWqJbGXw7dPCtDT6Yb/13Ts235CJxXhNKTB9NqeCKKefxV/iI4w/uWeKrj6zJjA2GuNLC+RS/VmwLLp6852AVHoRoH+vqUUQ1jIQdT2TENfqOrc2Akc/DQQf1+HRveOqQJaVfO00kHCZIwW3iE9qWN5mt2+PomBtpLViAek5mlfYqD/VxPvxw69glqLLY5M6FC7A/t3gGgkonOVjLZRZWtF4E7Ji41xwhwQia2WreLA12NxG1tHnXwYK+Q92DevjCLDYcffrb7mXnd6Rit0eacoDrDgb2/pQNJu/E8EapgauUcfAcN93d/dbim9aQiGfd5VMq/epoLB9fGPqcCSbkVD21/kmRvgL9Kejfadu2Tf/0hxQNhzvZBzZsmO4XUFC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(346002)(396003)(376002)(16526019)(8676002)(36756003)(44832011)(8936002)(38350700002)(52116002)(6666004)(69590400012)(83380400001)(2616005)(86362001)(66556008)(26005)(6512007)(6486002)(316002)(186003)(2906002)(1076003)(38100700002)(6506007)(66476007)(6916009)(5660300002)(956004)(508600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kiX5fkOnvMnnKw5n917S6th34sZymT5ZVxi3+T/XNMS7BZAEMkJFRqOSFGHS?=
 =?us-ascii?Q?RD9+MQNg7HkEQDDVYvdTz2XjgVOb5r4Yw+G/RqJr1gK1XHoTvVOtb3t5ekKR?=
 =?us-ascii?Q?koiJvp/prjhiJiQAsbhqW/D/5lP0DWkFWR4dMG2omPd8bxaDhMqeraEjJQGe?=
 =?us-ascii?Q?xW6kH1ngxDelVW6nZxIqmSwdQ7mUSlhAwTCT4e79d9MGzKHu5B/LQgUS7ncc?=
 =?us-ascii?Q?imugtM0jzSaCCDz5+6a0WWZLQgnTBdVickXUD5wW9cSQAGoOMWfddeP+KbKs?=
 =?us-ascii?Q?bs3Ai5EkVBDRUfHfwHg9YJD3B+bBmfzRKEZ6Q+lpuRUPykPjFo6ldVHj99Ww?=
 =?us-ascii?Q?d9pAhwCHhss+zTszQ5j5KfzW8cvYoHEgphMzYcwd5Fg/D8hFlFlWK9PkbC6f?=
 =?us-ascii?Q?QuEv/rYo3H947MSaYXFh/wgYje1HyTH7hXC4dGUMvrnmiSnYM+L9nKVix064?=
 =?us-ascii?Q?dRW2bsKrao+LJ8JrZlM/xjHCkdvbsdLYdDlpJ42GrG3BQq2OZP2hdBPGV2lI?=
 =?us-ascii?Q?zHlHWvnKo7H0r+mRxqc9UfCHEqk5wQlJjgGaiQ5bzR1PqPOHH1KfC8az+bo8?=
 =?us-ascii?Q?FZip+6Qjbd4tiQxBFbg0nwVw4la/wCX9xt7my+V6V+9YwHDPlu7nfS4GBW7V?=
 =?us-ascii?Q?Gryqp8n9DwJ0QYmyERFbt9THQYrxsnjEW50b/tVpwwlv5qAcb+f6vPR64JQf?=
 =?us-ascii?Q?howdwuWkPUeXL/dvQlChlM4CKSkEt/B8O6yMnn97ksCq95D4sAaEetbk4twb?=
 =?us-ascii?Q?LMxgHoqPF8WF2Id09Nlv/5u3jnKAggY2te4V2soz66q21enCQmHqerUEyASM?=
 =?us-ascii?Q?Ub8IsEeZxG9VrYoVXspCaxzwW5kG7L8Ai7dFXWM3tv0hwQ21/Efbk0EtHp0z?=
 =?us-ascii?Q?ySQVanG+vgjKspJ4JmB1H0lBoiX/xSiGhfvyxxT0lPtaim/qi28vhQvUWIy6?=
 =?us-ascii?Q?qJWN3a96qIXcp3lW8LrvHcKUtUhiI8ZIk6XF7gXTmaAzzwO6zDJrmenJbzmX?=
 =?us-ascii?Q?OARnMgR4S8iLGapy1ouToFan2B/TZVMIWON5ftlgK4/LPv35+DqC78N6I0UK?=
 =?us-ascii?Q?RJUIo+31IqCVLUP1N0QpFD0eHlk6R88UkIXfbinWb12QQChuuL0bVbCuFcVI?=
 =?us-ascii?Q?IqRGdrGrLASUyvLLiXBlFUeggx4vQcF/kh2AjaKiU7/GCsWANskh2+47qgvO?=
 =?us-ascii?Q?zEn6gKPT3OGBj8Q9XEO79q8QMh/FpnuZVqssctswswT9ZMSOTkVi8xuPW+/v?=
 =?us-ascii?Q?JKSl3c8dS+itlDdrE2/wYEpKdLm1u/WuaTD7NMgXcVQHYDSRjCXnlWvecoBa?=
 =?us-ascii?Q?9YbzL9eNxSjNk2KTaQc7Ryqk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eddcdee9-19d6-4ece-0205-08d900b8f2af
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:20:59.7145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xt0Sc5wBWF3mezalGuYVBeTOhnAcqXg5w29rVLitlTp4q8x7JF9qAsAJ6sPlhzKuXcwSb3IBikgqc9/eFcBujQOr/Li96aiNivgpd7xHojY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2567
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
X-Proofpoint-GUID: YZC2kiAtjyuLF5uEUGc-z3CSK79HbEK8
X-Proofpoint-ORIG-GUID: YZC2kiAtjyuLF5uEUGc-z3CSK79HbEK8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch separates the first half of xfs_attr_node_addname into a
helper function xfs_attr_node_addname_find_attr.  It also replaces the
restart goto with an EAGAIN return code driven by a loop in the calling
function.  This looks odd now, but will clean up nicly once we introduce
the state machine.  It will also enable hoisting the last state out of
xfs_attr_node_addname with out having to plumb in a "done" parameter to
know if we need to move to the next state or not.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 87 ++++++++++++++++++++++++++++++------------------
 1 file changed, 54 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d9dfc8d2..16159f6 100644
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
@@ -885,48 +896,26 @@ xfs_attr_node_hasname(
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
-	error = 0;
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
 
@@ -944,6 +933,38 @@ xfs_attr_node_addname(
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
@@ -969,7 +990,7 @@ xfs_attr_node_addname(
 			if (error)
 				goto out;
 
-			goto restart;
+			return -EAGAIN;
 		}
 
 		/*
-- 
2.7.4

