Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E045C4345A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1109061A38
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhCZAcK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:10 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38546 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbhCZAb4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:56 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OmC2066398
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=kiTbsG+BuGp18zaRlXsa9fM7CM5IkipbbE9xe4UMPxU=;
 b=y8YxsNF7n3rsTfxO2nVs7EC8QjyaoazfSzRvzFUfkL5F2Frs/s/2mQa2Vot6FgoO/tZ0
 iTlWYg1QO7KS07A3VhUOHmw5mxZKyu+q+jo87Aw57zkKRpMeB5Bc3GOSlpy4PLA0wjqt
 r++HU8bBVIl6Mo6OWbEI8ZBaCWqobzTwID4qxkTo/b1qZtBZONDqAYUC9DQ56vmHcUp/
 sM+KHmxxaLxpQoUhYqmSuplVV3a0XssXynpny/iHKDmEJ/9QcYgB37ztDXXNEoynP3bU
 6q1yLAZDNoWpyOBnqk4/tkcS2n6lE1647w4xcG1jJsfm3iuUEOjL8G++ciZoWXhub1nC Yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37h13hrh5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0Omv0009664
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:55 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3020.oracle.com with ESMTP id 37h14mft65-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXKNKajQa4firt6MdeiQbPup8a3f1uyr2Y1mh8vhLNl4I+FCMiuCpxK+KdxxAWFZH8KL/AGnfxLhgCeb2PTh2BLXzZmT6PRZrTJw9nK5PPxLYjBc3yymGYoSc74DB9ohU3pW5HaWvyPQL1AxtQtZGCxZc+6+I1+qSjWAPbIuOdMieFa2serE+62iQrZFurjM1fQc5qnbKF+abJuFYiKotlDcqoJy9gbUXIZUY58XoYiN0qjYKOR3Hgc392nHUjT9Coydvec76DVAX41nyl4vTbPWcbVQJJNO7yMmDBUwYFKFewyJdh0qurFyaOiHaRdhSjaVLHAjupHYoOz65ooEYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kiTbsG+BuGp18zaRlXsa9fM7CM5IkipbbE9xe4UMPxU=;
 b=YeKuHSmZWywuy7+edu2+VJRKa6FQysfP/OG27Itpbh4yskfWnJrP5fLbSpntEkuIlXci677ICZGfIWQnqcb2oQLWYNT0N9G9Jef7yMwwPzYKVgR8wp3Ly/SG7tkvRyh7EawaXwHlWOrBMu68WSQzCfkB8907AkzoqUp0STDBP5bRJZRotgTmaP6J7FhxBtUjbsNBU1yARCUyF2Ar2iT74CMPhxbo8dxADUSn88zzwYQLbfGKrU2KEbJ/PFI/3jqSfOHbjz/YJ2z5crG4foktIGAUhDM8NAD5+nI18NrFzPlfrkjGOrI4BZy6Rp8x4XlWNUc6DjydZ6vJZ2ceRmiXLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kiTbsG+BuGp18zaRlXsa9fM7CM5IkipbbE9xe4UMPxU=;
 b=ZLckw4yY+vFxhlSE8dWjS02Y8Tt2mPqmLsjlueL0mMgPmYbbHks20vAG1ubFmor85MHVP3nCyPZe561BW2am5VLnLqVF41UjHiXMUjptGO4rU+wj40E61YF6Q0W6JZh8KO5dZCdEYbY0Jotur35KtssPJYC0tnUYWohNRk8WErU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Fri, 26 Mar
 2021 00:31:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:52 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 27/28] xfsprogs: Add delay ready attr remove routines
Date:   Thu, 25 Mar 2021 17:31:30 -0700
Message-Id: <20210326003131.32642-28-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326003131.32642-1-allison.henderson@oracle.com>
References: <20210326003131.32642-1-allison.henderson@oracle.com>
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c005f3cf-803b-4ba9-76ad-08d8efee8d14
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2709327265F1297E47A3625795619@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VTZ8kCt6AQSiPsFB6aezfvAOMt8I/lPOHQmjSADzxpe+Qn8Dc0GZLo9jW9n3vNMNPo88ytkWxDHnZ8Xy5M81iArq+jHBw+uA216lRXZpP1QKJ/jhLus23A3Cexb5Z5uFiLPp+0YoVaQ1MDeTpSW0nSouMecyV3ui1g91DfG+XSS+LjqmfDg/jpN0399B+2pV5q3Q8mH7Wean8j1XLuri5F+G0gk2cqpQA1wmBdm3UmnpiRMMoLOSIvmxQJdgeCbNYUoGtQ1tIY1sIiiF1jC9JTvNjM4oo9RK9c1Fu5b8pUnF0YqGZFM6uIgyAeBmKMLGOEQK+/YnO1yV+IPNRelvYfqL0UacSHfC3GLRcvhIKcqFbeaO+YhKyeWz4U8Av5IgwaHG/H9/kYygkvfA0YQMQG1OdGZHY+vAMV/M7vs4rHlCK7iIX+10klCag8zatWcv6dT+dDRFhCByECd6cBUjAhvprrs+46CJV0enmGVT0hbQKAmy60VzVYYu3+V0zfChN8FherOsP3CnYknQlX7fzOF8UvUadNfckX3nacLMk2S9Ts8hp9oL1Sbaef3ROTUSejJ6Pzu2xlVPWFLHtfl8GPI6rZV49AlFKIiYnhvYeHjiYo+7HKYa4f8LYq8+bFYYH1AqxhUAxZz7vH9WtXxjIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(396003)(346002)(366004)(1076003)(8936002)(6506007)(2906002)(6512007)(6486002)(52116002)(6916009)(5660300002)(8676002)(83380400001)(36756003)(66476007)(66556008)(30864003)(86362001)(38100700001)(66946007)(956004)(6666004)(316002)(2616005)(478600001)(44832011)(16526019)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4qDZN+b6xKqMiBqLKoQPgI+ghuplBGCtXAw2Og1ayMXLcqndAeMrLjoFjjmd?=
 =?us-ascii?Q?aer7Jn8Z3Hi+jddAQERoYsTfS3AGViq/Wi3zIMLYQrq6xF5N75Cr0BODar7x?=
 =?us-ascii?Q?GaUDu8thnXAjx+ZC+WP9VyMPlZzV1HirHgkmb7oYxDDG0RWsiN4PEKkvDul1?=
 =?us-ascii?Q?x7GbNCLRnVFcpnoYvV8H6uOqMf3P5559IZDGswN2DJAApKEDUab1xzEIFAFG?=
 =?us-ascii?Q?xVxL+1+wbTz/HjesZtKGO2oy72dDyjvxYaG5t0Z6UnLwwha17G6GpSChgqQA?=
 =?us-ascii?Q?Ut72qFESyurEatr07JOrrdl4w2plWKzXJr/EirUeoIMriytaNDwLamcocHLr?=
 =?us-ascii?Q?6CFPToNKlVjeCnrfDCtV8CScXtrEEdzAm79CQFIvJZo7Dj7Bwr9oIEdzWCa5?=
 =?us-ascii?Q?0K8zYerbwG+aP81ukwe8CvGoKjmD0zWPONh65ui/sGQj+FpK8XktNWQzBJbs?=
 =?us-ascii?Q?RxZo0chGpgrvX/QRqunqbhPjbS6gE7Fs13j56bLnn3ZxfGDA//ng6h9Y2uLb?=
 =?us-ascii?Q?iT3EqV/jnlRTD/fOhYjrFdeKOAlI8uHYM/1Zh6SwyyrvCr+I0M10EcV+N2lL?=
 =?us-ascii?Q?JmsNuMcLt9A1a8I34q5tSbH0+t9+yPLG3bqn1ERV3GkXTR/AVXqacspC4FpM?=
 =?us-ascii?Q?FxYaMoJB57SCbSZAvqky2WEvXkOyiLfXGFlzSzP0s2AZZ8RSiTJojmT/snji?=
 =?us-ascii?Q?dU9JsG99Lx7AhTX1xkjB1wVl52JCSrxGhC6xF6qLWd9+P6uWmFqDHOgiOo3p?=
 =?us-ascii?Q?rdd+oshOkeQCiyFXoGZRf8Da5TJAASdtlrTR4pudwjZeaTLnABigWSXYQYaQ?=
 =?us-ascii?Q?3+4RXJiD21EziihqCp0IXj/uVZSZ48AFh7J6cy5a4q5tcGN59oNkAcJW5a3J?=
 =?us-ascii?Q?mckwHPcbVd4YrinyYWUhEArMUHHgKMg+bCQAJLL7MjVj6lZSaJ13Zh7Pgvk+?=
 =?us-ascii?Q?rPv9tb487cRQFa9YLnBEMH2BLRetO5MJJDAFqTO0kHgKoZIN/n1dVvswkAOm?=
 =?us-ascii?Q?XlueGVo9xAJhLBWoD4RapDuRsad6gEzcjzS59VSFjvoNkAvIO4VFWF0YiVKv?=
 =?us-ascii?Q?O8WzAF7f0kVspXiA9h39LaEVJKN0ONPQzOFsf7yW+3fwFgf+IQDVmOvWZM7l?=
 =?us-ascii?Q?Teh8hafXQaTAgKht/dfMtwOono1JK4cabgSQ2oxC9OVKB0KmB97vYCjKYkCz?=
 =?us-ascii?Q?ElBU2A6YP7znNac/Pg40pz6uQc7ScEF2hb064DZU+lyQxsDrk7/z5Haq2Hhn?=
 =?us-ascii?Q?rB7owUrEnjTRnwu5yQyJJfmpT/wGVg3mK9xc6aDgwYgApk604p/6f2axCYd+?=
 =?us-ascii?Q?dhyihik5GG507wNJ4Qyc9/gl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c005f3cf-803b-4ba9-76ad-08d8efee8d14
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:52.3498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WebsQCsg7nHvO6UTkOqyVrKgJ+K3fm6ZgyEtDsh/2HArkJMu4teV6q3EJHMW2MLxgYo8DjprXe+9YoIi/7GcgSuuQiWB7MKvN9hSvsgED8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
X-Proofpoint-GUID: BFj9zwhRIeOUa1iFmLGmIMYk2iVe7ipc
X-Proofpoint-ORIG-GUID: BFj9zwhRIeOUa1iFmLGmIMYk2iVe7ipc
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch modifies the attr remove routines to be delay ready. This
means they no longer roll or commit transactions, but instead return
-EAGAIN to have the calling routine roll and refresh the transaction. In
this series, xfs_attr_remove_args is merged with
xfs_attr_node_removename become a new function, xfs_attr_remove_iter.
This new version uses a sort of state machine like switch to keep track
of where it was when EAGAIN was returned. A new version of
xfs_attr_remove_args consists of a simple loop to refresh the
transaction until the operation is completed. A new XFS_DAC_DEFER_FINISH
flag is used to finish the transaction where ever the existing code used
to.

Calls to xfs_attr_rmtval_remove are replaced with the delay ready
version __xfs_attr_rmtval_remove. We will rename
__xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
done.

xfs_attr_rmtval_remove itself is still in use by the set routines (used
during a rename).  For reasons of preserving existing function, we
modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
set.  Similar to how xfs_attr_remove_args does here.  Once we transition
the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
used and will be removed.

This patch also adds a new struct xfs_delattr_context, which we will use
to keep track of the current state of an attribute operation. The new
xfs_delattr_state enum is used to track various operations that are in
progress so that we know not to repeat them, and resume where we left
off before EAGAIN was returned to cycle out the transaction. Other
members take the place of local variables that need to retain their
values across multiple function recalls.  See xfs_attr.h for a more
detailed diagram of the states.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 include/libxfs.h         |   1 +
 libxfs/xfs_attr.c        | 206 ++++++++++++++++++++++++++++++++---------------
 libxfs/xfs_attr.h        | 125 ++++++++++++++++++++++++++++
 libxfs/xfs_attr_leaf.c   |   2 +-
 libxfs/xfs_attr_remote.c |  48 ++++++-----
 libxfs/xfs_attr_remote.h |   2 +-
 6 files changed, 297 insertions(+), 87 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index bc07655..02d97c1 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -168,6 +168,7 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #include "xfs_ialloc.h"
 
 #include "xfs_attr_leaf.h"
+#include "xfs_attr.h"
 #include "xfs_attr_remote.h"
 #include "xfs_trans_space.h"
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 9801a2a..0840f87 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -57,7 +57,6 @@ STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
 				 struct xfs_da_state *state);
 STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
 				 struct xfs_da_state **state);
-STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
@@ -221,6 +220,32 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
+/*
+ * Checks to see if a delayed attribute transaction should be rolled.  If so,
+ * also checks for a defer finish.  Transaction is finished and rolled as
+ * needed, and returns true of false if the delayed operation should continue.
+ */
+int
+xfs_attr_trans_roll(
+	struct xfs_delattr_context	*dac)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	int				error;
+
+	if (dac->flags & XFS_DAC_DEFER_FINISH) {
+		/*
+		 * The caller wants us to finish all the deferred ops so that we
+		 * avoid pinning the log tail with a large number of deferred
+		 * ops.
+		 */
+		dac->flags &= ~XFS_DAC_DEFER_FINISH;
+		error = xfs_defer_finish(&args->trans);
+	} else
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+
+	return error;
+}
+
 STATIC int
 xfs_attr_set_fmt(
 	struct xfs_da_args	*args)
@@ -530,21 +555,23 @@ xfs_has_attr(
  */
 int
 xfs_attr_remove_args(
-	struct xfs_da_args      *args)
+	struct xfs_da_args	*args)
 {
-	struct xfs_inode	*dp = args->dp;
-	int			error;
+	int				error;
+	struct xfs_delattr_context	dac = {
+		.da_args	= args,
+	};
 
-	if (!xfs_inode_hasattr(dp)) {
-		error = -ENOATTR;
-	} else if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
-		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
-		error = xfs_attr_shortform_remove(args);
-	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-		error = xfs_attr_leaf_removename(args);
-	} else {
-		error = xfs_attr_node_removename(args);
-	}
+	do {
+		error = xfs_attr_remove_iter(&dac);
+		if (error != -EAGAIN)
+			break;
+
+		error = xfs_attr_trans_roll(&dac);
+		if (error)
+			return error;
+
+	} while (true);
 
 	return error;
 }
@@ -1201,14 +1228,16 @@ xfs_attr_leaf_mark_incomplete(
  */
 STATIC
 int xfs_attr_node_removename_setup(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	**state)
+	struct xfs_delattr_context	*dac)
 {
-	int			error;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		**state = &dac->da_state;
+	int				error;
 
 	error = xfs_attr_node_hasname(args, state);
 	if (error != -EEXIST)
 		return error;
+	error = 0;
 
 	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
 	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
@@ -1217,10 +1246,13 @@ int xfs_attr_node_removename_setup(
 	if (args->rmtblkno > 0) {
 		error = xfs_attr_leaf_mark_incomplete(args, *state);
 		if (error)
-			return error;
+			goto out;
 
-		return xfs_attr_rmtval_invalidate(args);
+		error = xfs_attr_rmtval_invalidate(args);
 	}
+out:
+	if (error)
+		xfs_da_state_free(*state);
 
 	return 0;
 }
@@ -1245,70 +1277,114 @@ xfs_attr_node_remove_cleanup(
 }
 
 /*
- * Remove a name from a B-tree attribute list.
+ * Remove the attribute specified in @args.
  *
  * This will involve walking down the Btree, and may involve joining
  * leaf nodes and even joining intermediate nodes up to and including
  * the root node (a special case of an intermediate node).
+ *
+ * This routine is meant to function as either an in-line or delayed operation,
+ * and may return -EAGAIN when the transaction needs to be rolled.  Calling
+ * functions will need to handle this, and recall the function until a
+ * successful error code is returned.
  */
-STATIC int
-xfs_attr_node_removename(
-	struct xfs_da_args	*args)
+int
+xfs_attr_remove_iter(
+	struct xfs_delattr_context	*dac)
 {
-	struct xfs_da_state	*state;
-	int			retval, error;
-	struct xfs_inode	*dp = args->dp;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		*state = dac->da_state;
+	int				retval, error;
+	struct xfs_inode		*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
 
-	error = xfs_attr_node_removename_setup(args, &state);
-	if (error)
-		goto out;
+	switch (dac->dela_state) {
+	case XFS_DAS_UNINIT:
+		if (!xfs_inode_hasattr(dp))
+			return -ENOATTR;
 
-	/*
-	 * If there is an out-of-line value, de-allocate the blocks.
-	 * This is done before we remove the attribute so that we don't
-	 * overflow the maximum size of a transaction and/or hit a deadlock.
-	 */
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			goto out;
+		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
+			ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
+			return xfs_attr_shortform_remove(args);
+		}
+
+		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+			return xfs_attr_leaf_removename(args);
+
+	/* fallthrough */
+	case XFS_DAS_RMTBLK:
+		dac->dela_state = XFS_DAS_RMTBLK;
+
+		if (!dac->da_state) {
+			error = xfs_attr_node_removename_setup(dac);
+			if (error)
+				goto out;
+		}
+		state = dac->da_state;
 
 		/*
-		 * Refill the state structure with buffers, the prior calls
-		 * released our buffers.
+		 * If there is an out-of-line value, de-allocate the blocks.
+		 * This is done before we remove the attribute so that we don't
+		 * overflow the maximum size of a transaction and/or hit a
+		 * deadlock.
 		 */
-		error = xfs_attr_refillstate(state);
-		if (error)
-			goto out;
-	}
-	retval = xfs_attr_node_remove_cleanup(args, state);
+		if (args->rmtblkno > 0) {
+			/*
+			 * May return -EAGAIN. Remove blocks until
+			 * args->rmtblkno == 0
+			 */
+			error = __xfs_attr_rmtval_remove(dac);
+			if (error)
+				break;
+
+			/*
+			 * Refill the state structure with buffers, the prior
+			 * calls released our buffers.
+			 */
+			ASSERT(args->rmtblkno == 0);
+			error = xfs_attr_refillstate(state);
+			if (error)
+				goto out;
+
+			dac->flags |= XFS_DAC_DEFER_FINISH;
+			return -EAGAIN;
+		}
+
+		retval = xfs_attr_node_remove_cleanup(args, state);
 
-	/*
-	 * Check to see if the tree needs to be collapsed.
-	 */
-	if (retval && (state->path.active > 1)) {
-		error = xfs_da3_join(state);
-		if (error)
-			goto out;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			goto out;
 		/*
-		 * Commit the Btree join operation and start a new trans.
+		 * Check to see if the tree needs to be collapsed. Set the flag
+		 * to indicate that the calling function needs to move the
+		 * shrink operation
 		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			goto out;
-	}
+		if (retval && (state->path.active > 1)) {
+			error = xfs_da3_join(state);
+			if (error)
+				goto out;
 
-	/*
-	 * If the result is small enough, push it all into the inode.
-	 */
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
-		error = xfs_attr_node_shrink(args, state);
+			dac->flags |= XFS_DAC_DEFER_FINISH;
+			dac->dela_state = XFS_DAS_RM_SHRINK;
+			return -EAGAIN;
+		}
+
+		/* fallthrough */
+	case XFS_DAS_RM_SHRINK:
+		/*
+		 * If the result is small enough, push it all into the inode.
+		 */
+		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+			error = xfs_attr_node_shrink(args, state);
+
+		break;
+	default:
+		ASSERT(0);
+		error = -EINVAL;
+		goto out;
+	}
 
+	if (error == -EAGAIN)
+		return error;
 out:
 	if (state)
 		xfs_da_state_free(state);
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 3e97a93..92a6a50 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -74,6 +74,127 @@ struct xfs_attr_list_context {
 };
 
 
+/*
+ * ========================================================================
+ * Structure used to pass context around among the delayed routines.
+ * ========================================================================
+ */
+
+/*
+ * Below is a state machine diagram for attr remove operations. The  XFS_DAS_*
+ * states indicate places where the function would return -EAGAIN, and then
+ * immediately resume from after being recalled by the calling function. States
+ * marked as a "subroutine state" indicate that they belong to a subroutine, and
+ * so the calling function needs to pass them back to that subroutine to allow
+ * it to finish where it left off. But they otherwise do not have a role in the
+ * calling function other than just passing through.
+ *
+ * xfs_attr_remove_iter()
+ *              │
+ *              v
+ *        have attr to remove? ──n──> done
+ *              │
+ *              y
+ *              │
+ *              v
+ *        are we short form? ──y──> xfs_attr_shortform_remove ──> done
+ *              │
+ *              n
+ *              │
+ *              V
+ *        are we leaf form? ──y──> xfs_attr_leaf_removename ──> done
+ *              │
+ *              n
+ *              │
+ *              V
+ *   ┌── need to setup state?
+ *   │          │
+ *   n          y
+ *   │          │
+ *   │          v
+ *   │ find attr and get state
+ *   │    attr has blks? ───n────┐
+ *   │          │                v
+ *   │          │         find and invalidate
+ *   │          y         the blocks. mark
+ *   │          │         attr incomplete
+ *   │          ├────────────────┘
+ *   └──────────┤
+ *              │
+ *              v
+ *      Have blks to remove? ─────y────┐
+ *              │       ^      remove the blks
+ *              │       │              │
+ *              │       │              v
+ *              │       │        refill the state
+ *              n       │              │
+ *              │       │              v
+ *              │       │         XFS_DAS_RMTBLK
+ *              │       └─────  re-enter with one
+ *              │               less blk to remove
+ *              │
+ *              v
+ *       remove leaf and
+ *       update hash with
+ *   xfs_attr_node_remove_cleanup
+ *              │
+ *              v
+ *           need to
+ *        shrink tree? ─n─┐
+ *              │         │
+ *              y         │
+ *              │         │
+ *              v         │
+ *          join leaf     │
+ *              │         │
+ *              v         │
+ *      XFS_DAS_RM_SHRINK │
+ *              │         │
+ *              v         │
+ *       do the shrink    │
+ *              │         │
+ *              v         │
+ *          free state <──┘
+ *              │
+ *              v
+ *            done
+ *
+ */
+
+/*
+ * Enum values for xfs_delattr_context.da_state
+ *
+ * These values are used by delayed attribute operations to keep track  of where
+ * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
+ * calling function to roll the transaction, and then recall the subroutine to
+ * finish the operation.  The enum is then used by the subroutine to jump back
+ * to where it was and resume executing where it left off.
+ */
+enum xfs_delattr_state {
+	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
+	XFS_DAS_RMTBLK,		      /* Removing remote blks */
+	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
+};
+
+/*
+ * Defines for xfs_delattr_context.flags
+ */
+#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
+
+/*
+ * Context used for keeping track of delayed attribute operations
+ */
+struct xfs_delattr_context {
+	struct xfs_da_args      *da_args;
+
+	/* Used in xfs_attr_node_removename to roll through removing blocks */
+	struct xfs_da_state     *da_state;
+
+	/* Used to keep track of current state of delayed operation */
+	unsigned int            flags;
+	enum xfs_delattr_state  dela_state;
+};
+
 /*========================================================================
  * Function prototypes for the kernel.
  *========================================================================*/
@@ -91,6 +212,10 @@ int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
+int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
+void xfs_delattr_context_init(struct xfs_delattr_context *dac,
+			      struct xfs_da_args *args);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index a59660f..2c7aa6b 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -19,8 +19,8 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_attr_sf.h"
-#include "xfs_attr_remote.h"
 #include "xfs_attr.h"
+#include "xfs_attr_remote.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_trace.h"
 #include "xfs_dir2.h"
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 3807cd3..affff4b 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -673,10 +673,12 @@ xfs_attr_rmtval_invalidate(
  */
 int
 xfs_attr_rmtval_remove(
-	struct xfs_da_args      *args)
+	struct xfs_da_args		*args)
 {
-	int			error;
-	int			retval;
+	int				error;
+	struct xfs_delattr_context	dac  = {
+		.da_args	= args,
+	};
 
 	trace_xfs_attr_rmtval_remove(args);
 
@@ -684,31 +686,29 @@ xfs_attr_rmtval_remove(
 	 * Keep de-allocating extents until the remote-value region is gone.
 	 */
 	do {
-		retval = __xfs_attr_rmtval_remove(args);
-		if (retval && retval != -EAGAIN)
-			return retval;
+		error = __xfs_attr_rmtval_remove(&dac);
+		if (error != -EAGAIN)
+			break;
 
-		/*
-		 * Close out trans and start the next one in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		error = xfs_attr_trans_roll(&dac);
 		if (error)
 			return error;
-	} while (retval == -EAGAIN);
+	} while (true);
 
-	return 0;
+	return error;
 }
 
 /*
  * Remove the value associated with an attribute by deleting the out-of-line
- * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
+ * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
  * transaction and re-call the function
  */
 int
 __xfs_attr_rmtval_remove(
-	struct xfs_da_args	*args)
+	struct xfs_delattr_context	*dac)
 {
-	int			error, done;
+	struct xfs_da_args		*args = dac->da_args;
+	int				error, done;
 
 	/*
 	 * Unmap value blocks for this attr.
@@ -718,12 +718,20 @@ __xfs_attr_rmtval_remove(
 	if (error)
 		return error;
 
-	error = xfs_defer_finish(&args->trans);
-	if (error)
-		return error;
-
-	if (!done)
+	/*
+	 * We don't need an explicit state here to pick up where we left off. We
+	 * can figure it out using the !done return code. Calling function only
+	 * needs to keep recalling this routine until we indicate to stop by
+	 * returning anything other than -EAGAIN. The actual value of
+	 * attr->xattri_dela_state may be some value reminiscent of the calling
+	 * function, but it's value is irrelevant with in the context of this
+	 * function. Once we are done here, the next state is set as needed
+	 * by the parent
+	 */
+	if (!done) {
+		dac->flags |= XFS_DAC_DEFER_FINISH;
 		return -EAGAIN;
+	}
 
 	return error;
 }
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 9eee615..002fd30 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
+int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4

