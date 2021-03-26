Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C76C433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DC3761A44
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhCZAdh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:33:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58844 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbhCZAdZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:33:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0NrUY110904
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=WLqVEIn+affmeKWJT39nHlvfz2asjXUnkmIDJn22heE=;
 b=UjojKSIvsW/FLZsyh57W+3rjl/50w5AIVWlzU9JgKU3cHBhy/FZhUMWHzpKRXQmuksLC
 b4tI/H4eBTrJwqFqldo+4o9FR4GJHXYPog+H1FuzmdyX8djAlsvpgVLeHYRSa9P1JR69
 Iwf9/u7oWKcxX7H8NcYHBV4X4rUPqWNobLhI2wuEQZ0brTHZRCYCVgeIQAXUjlS505WN
 ZRkvGkkYJwomboP6Rr4IOPrrTa2SttlY1GBSXxcIpNrNcCqowov4gwW+ZOWRIMaXlGSB
 OCukSwAocFYJiFpmmT/Tjc2pbrDq0JBEvt4e9BgvJjJHG5xtHab29JrMtrc5bk4Kq8ln lw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37h1420h8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PYwM096811
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3030.oracle.com with ESMTP id 37h140qtxx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVlaSE7VdR3RAgreZE/J9DVAYvXh99HHy38mRQ0rZdhh+7BhFUSpsCCt8sC7MIHS1hiGe3Bv+bCnmJKkg+kItC4sD8TBXiSEuZB6T/LFxzwORCpSoi3+Ic594KjMcqhQPYMVZNcaEKmMMYQNYVrnu+kFrqo0Fn02MZEQlWvJKHvSd80WyawoOMasSimX7heUw9pQGWfP7mEWaDau3NBwLMxsb/9u2PV7ZfM3CaYlahRO1h4P9GueIwNZC9cCs55ojSUrKXztBZX+oPmoxQQ3wiza4FFYJ2PenXC/tzijxmTDYg5dcjTJGGUJDK6kMYi4pzR1ACKHi4lZ8WmFM9ezCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WLqVEIn+affmeKWJT39nHlvfz2asjXUnkmIDJn22heE=;
 b=ema5X4AmW+3CYX8swn0HAUAtKCyfWThELTIF/egnn64ifSr6DAXIg0zl5W+u3FF2Xsas9RqHVjTY45yuYyj4BqgDAsGh3abZ5SygbcJOFCyfyO1/eXyLUvz6Wj+Kkb9Tf1UwNiXe7lyewBebRy0/fG3ljmwYuL75L4PTQ1mIMTMoAjd/mZtcEfHutzv1N03TFUQ/GTwNGdqGRL8iU8aEHrwhGFJ1hXcNOMjLvDNqrECkDwrz0d3yWgXlsgX/mU0iE/ZEv13+p0ZFEuTSlbiD9zBpCH9MTtiDuN0aOxWvsM7sywkIMxCaD7UYq/ZfsLDFPamw7rdqaKJTBuvik2a4cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WLqVEIn+affmeKWJT39nHlvfz2asjXUnkmIDJn22heE=;
 b=S0SYjPj80QlA8jTo9THViQIX5vCnmXtqK7CzDJ7CbkBmXNXUg7pe1h+yCLl5FPVwcXhVMxnu5G6bz391IFkljI58IxEHuH4oTyA50bFz24aSFasJYSdT3zSUXAblYSD15/TKD3wF/NxeWauUZDMJdUfkYfMHozqVk6w0K6f4W54=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2645.namprd10.prod.outlook.com (2603:10b6:a02:b0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Fri, 26 Mar
 2021 00:33:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:33:22 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 08/11] xfs: Hoist xfs_attr_leaf_addname
Date:   Thu, 25 Mar 2021 17:33:05 -0700
Message-Id: <20210326003308.32753-9-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 63301d5c-0044-4319-d2e8-08d8efeec2a3
X-MS-TrafficTypeDiagnostic: BYAPR10MB2645:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2645418F84C6332F22F024C895619@BYAPR10MB2645.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HpPBqS/mEaxicaXdYrP7qx/GNxw4f/OaFDcmsAgyDHhCMEYvKxgNMJoz3a+LrXMOsB3M28sVivoGGd0eJJBDFYg4IAqjV2jsPxz3K6/LnE7C36XZTd+Kfgdt5kjiqp+MV9zJzc2hrmCFCsAm+0HK6x8C776MG53NqWd7VjR189tmts6i8OUMZ8Rzd17zt+zaMtsIgqZ372kfJn7IP48w5SmMPZb2SpjzU9Wp/3CPuU7KtNRVJPPTPE/skc9TM6h9FGXC8fd41pySISACnvgJVXNFKlU38caSo71darz6iq0K8mwtMOsNoryy+Hp+Wzkr9yJ6haqWONYGrgdw/0bA2owLyn+kagvu37GE1hfAmF6xLa+JrNINZ4nfhqZ3hAfExtXPfU6nnh2psrrI+k4MelEzLRnAz93D71pbvxexHSLumf/JUcGdK2G/CE/7u5CFFZStO8U6+pb07FhxUbKhB3MCvX+8kNzlqQZ0okCEuKDodyIDQe4LcxBm760G7kYuXgsoQKEVG+ttIPl/f+Vs0BtB3H7poAWQH901RBlPaITidBBxV17gLirfCtIjXKylJ3NsBTffpJKT/5ysCTRepqoedXqCbAsPe9cfBftBr52L83PLi5dUtkOX05AI17LWeaKBJfnszBnQ25DJ7XLIky6H3O6MiJoEFwfaKWgp9cE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(136003)(39860400002)(66476007)(478600001)(6666004)(8936002)(66946007)(86362001)(8676002)(1076003)(6916009)(66556008)(52116002)(5660300002)(2906002)(956004)(6486002)(83380400001)(26005)(6506007)(186003)(2616005)(16526019)(38100700001)(316002)(6512007)(36756003)(44832011)(69590400012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5u30lKXZeHRDH0mHItuwdJJWSTIUYllsCwq2REfzhQYewbuBL3LOKEBF9pbO?=
 =?us-ascii?Q?ngIqOuLDaNWgbeKHfGdHhf4goValRJ8Avw6e1ZqFuqkwEsHzVo66OuIieIi7?=
 =?us-ascii?Q?IYHyRSANxzb2vGxDrOddAVUoPS3O6GLQH+ijX7xm0RzDH7iN36uQ2f3ubBnO?=
 =?us-ascii?Q?PHGgpIvixGe4Iw9t6hh9FIV/J20icd+tkF7GONRhuTOof0KNdNdbWxEDbWI/?=
 =?us-ascii?Q?xn4tKzRArXLX3IiUrBju2+eZvyNy9aO6TH3JWGfTXaDC2HE6r1QL/24y444H?=
 =?us-ascii?Q?a8/wPRI4Jf1AgMWZbKW7FvQmcnCkOs7ExUHVw4VKD6w95AJ/wjpU/IfjgxWh?=
 =?us-ascii?Q?QjTQXQjCOM+H3CG4790sphGqf3PIGvO18xolErTFPJrSA30Zx181Dd1Mvvtv?=
 =?us-ascii?Q?j8pRpPT4nt92mSPui2lP3EBmzY5qtaz/01EjSGzj5OQg0VJm0SiyruEeHD1x?=
 =?us-ascii?Q?sIF9qPs4oSGXiWlzQcOaliTXEUHuzqeHK29ihwR6jDFAZMFGf1JvmQbk9RXf?=
 =?us-ascii?Q?rstBaGf1XPb/q0jwijkuQmGXOCw4w7wPnagjIZJpWIsT9e68JsGtQf8CWRAk?=
 =?us-ascii?Q?WqlXcH3mVALPivcFjd4lxVOYCE2+z+FezhWi2voVDfWxk+qjGKSdRD70a4CL?=
 =?us-ascii?Q?vFyda5PnP71vCnumL00O+bEJiPCr6yztCkpAxkJ41SqaV0v14IV7+OzYfD5N?=
 =?us-ascii?Q?1EgtBbBat4B7GD8gF43WTA2Z77wJIUPTd0HrZ1oCLJ07hJgBoDDMmL2HmErZ?=
 =?us-ascii?Q?CG9tWT+1O2TM+AB+Mqx42GIVdP2acm3T6Ppm0alzOnURmeVDNEjO8tO8hkbl?=
 =?us-ascii?Q?ZrKTM+uFDDhcffkx7tJJIWjNTXWpXSZJ83AfaeKFgsqlxjb2tkL9DUlDbzza?=
 =?us-ascii?Q?dF6mbwG5biBiO9qENtM2FjuDlAh01XxnbZuJ1hOtth0gLAK+m8kTaKl7JB5M?=
 =?us-ascii?Q?cVPqU6wRWLx/Xa5PqWQLxAL42xozygJpdGToRjdpT6qOPuyDEhO3pZr5OSFX?=
 =?us-ascii?Q?9P0ujm2LJGBPz6CRJ2CZFB79b/EVQLV6Bmb+GuI0fQGvQxQt/QKzRi2KNt6n?=
 =?us-ascii?Q?qqYIMklmNE0ODZiqpvJwq9Ue08h0v2F79uQxTpKNOIrdOph99KlNmmENGArx?=
 =?us-ascii?Q?AZ6hSyL0oEwAcKXZ4vDzxbCwXYd7Thryt1ordCbar0+pYbMwlVgbI9A3h4MW?=
 =?us-ascii?Q?qMhktti5KYkEUdErHqv+QWIxC3Nm8TQowaoiaNHXlTnhwwss4S+5X2qJy7kf?=
 =?us-ascii?Q?RB3NT4pLmpmCM0B/ZIrnr6Na+AcdeTM9MdWXknxv2bHPW6mn3kwJdQjrjjT3?=
 =?us-ascii?Q?FmXZQmfQaW7O4aZha/lGrfSH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63301d5c-0044-4319-d2e8-08d8efeec2a3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:33:22.0851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xh0D9iLcSaC99KVI8yOSGcdFRQsVjYmOTtdLOlYE6mjByY60QPToVPUlzwdL0ZgFmtT58qmlwpcSulXHDKoYWNIi9xk8JIaZGR4IHZZg3x0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2645
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-GUID: -hjTITV9awgTw39nOPLcWnPWcHbS2Ccs
X-Proofpoint-ORIG-GUID: -hjTITV9awgTw39nOPLcWnPWcHbS2Ccs
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch hoists xfs_attr_leaf_addname into the calling function.  The
goal being to get all the code that will require state management into
the same scope. This isn't particuarly aesthetic right away, but it is a
preliminary step to merging in the state machine code.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 209 ++++++++++++++++++++++-------------------------
 1 file changed, 96 insertions(+), 113 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 5b5410f..16f10ac 100644
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
@@ -271,8 +271,9 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_buf		*bp = NULL;
 	struct xfs_da_state     *state = NULL;
-	int			error = 0;
+	int			forkoff, error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -287,10 +288,101 @@ xfs_attr_set_args(
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
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
@@ -729,115 +821,6 @@ xfs_attr_leaf_try_add(
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
-- 
2.7.4

