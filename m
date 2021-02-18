Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9FEBC43217
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89EDA64EC2
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbhBRSsS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:48:18 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53482 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbhBRQzW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:55:22 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGsCoP016460
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=k89aHfpJ+hmy+EuDiAe0IndbGhoF6nEKFvWe9tlW7Ak=;
 b=GtbPo9rrIAUjhXSgyoJoSM8wYBZTLrPakjx4RPtz49BaYwKtEk3eK0nJUyFSfAqBwOs3
 8ntvC5F5YlKAXrr0N92V6VVY2VllfVDKw1Z7OTo0dDKAemBO7jOxfYXrqBBb6mJXpMRo
 NNMt85X94MQ+1XgNvk2Zdhs+ZSKNsMsbyJdxFYMf4P3j4PqjRXN87G7PnzXLicl3Dj0F
 45Ufs/atmGmPm7oLIhLiXhz6mPI78xxyQ95VN26hEUaX+4WHbC7Da6N3OSD/i59ZgDBO
 YQfPpMBtJaBdfzvWsenG1cIL5qWooQxpk12u6MCul2l2dEj64qSL11KJlrUbFUc+F3/8 MA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36p7dnpj6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGng2r162351
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3020.oracle.com with ESMTP id 36prhufdmr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VjnDYM5h1AdF7dQfftz6plVdjB2jjVjm6YGgUo0m6X7qaUutmd7P7/xgJy6NwDSU9nT6NKFakjRrNM4HFfM3MMRZeoz9wvEELSrSFgl0NbsZXQrZQIo/CIoXc302iFmEnqpz1vkpKUbBGSS2ER+khktwTta1shyNb9RPqQ8r7uDxBlDLGTC2n7TmzgmY28eznbJ08PXOp/VETEjVTusmHpzTuDE2WIv6naKY1NdwUfDm0eO+PvJUFbPCQZACmWCRx9IdZYaOKgIiWLqa09S1GOwKHxyFhDWtdbLYSW/6DIt6PgtWFwU9Cdb7uk3mC2IdiQpmC/ac8vMfla7kn2tyXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k89aHfpJ+hmy+EuDiAe0IndbGhoF6nEKFvWe9tlW7Ak=;
 b=AW+mZ91FXjwQF1DscK08crzIP10Rmf1jUUcKu1k9zkvUB+B1Ow1W4T9vrSIg+/NpKFnDV8n5519kDUqILPB1pdngxp/UJIJ8XfXi2qnswJPny/WQv/Qte1I5XeN3Df4syIhIJj3JR/kzYU7Wf+iRHgUefTuw16ZH4DfVSXBfPON3KFSqyF2zkMAOe/TSJqe0koc34bdCWodgBwjm1wx7vtxxvnTGK+h062nxyuHAA1Ez0ruK7l3kAcdyxIikseMSO6cUB5Nr0rkW6XHmJVcnkyAnJowtA7YqKnPBo/euaD/MHofBI3aC2s+6vIEU3tAAiApsOYL1h1n+5Xo/6RcInA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k89aHfpJ+hmy+EuDiAe0IndbGhoF6nEKFvWe9tlW7Ak=;
 b=b6hEBjmkJWlsnPEpTP9h/ZfoQur2gG4c6wu/MJ2DFK38PpNZVhEBbsWbMgqkw9bGEqq4UYd1QOvroao2F4qhYGCuPs4s2Et+G1pDticMHL6B/jUA74Cp9u++OY2n+rsvCcLOSW6Qr5sy8WHpw2auY5DaccTBcbWCGWDylLQ2OE4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3381.namprd10.prod.outlook.com (2603:10b6:a03:15b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:54:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:08 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 11/22] xfs: Add delay ready attr remove routines
Date:   Thu, 18 Feb 2021 09:53:37 -0700
Message-Id: <20210218165348.4754-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218165348.4754-1-allison.henderson@oracle.com>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 401cf0d9-47d0-4255-1c5b-08d8d42dceb6
X-MS-TrafficTypeDiagnostic: BYAPR10MB3381:
X-Microsoft-Antispam-PRVS: <BYAPR10MB338197AF0D0393B5CA2879A095859@BYAPR10MB3381.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iGdrF3cwfxg7Q0Kb3fckwNouFGUORKMso0wRYvoK0FJR6Cjns6cQsavBzV6ARJX7DeYE6a6C9Afka51UQHzeKGVkQM6DW5dk2CdZ7TCSUjcPNV7n8eaYN9bn4LW9OxezSj/o0ROX2TGN0SZk/qOzzUmMSXk6aK2eiRO8Dhf5bn9646TUyWlXjb2h8KZ8r03Jh2GDgfY9orbJdCr2xp5QJ/UxwFMQFnZxpRoMqBDq8aSSld+D9I1XG1yFCawgtVbMYFAMHNmtVsR0jrDp9TGOulc5eDgzGo/5WjrqbnAWLVpMuChSlPYQskmq4RtVuZuVcZtQTYXrZ4Js2bLs7MvACPR3Mv7fwVqoG45b7vq217DfXZO/KEDf3BmbzLSUKhWqRboG0j14nKiWuMDVuP6xokJm4TE373B+MpDU6zFaW/BhxmREGLxoatdPnqvB6qxrhq16wbJdieqDwD2KmyagZ8Dd0ONLPIIyaLWooYBWSIEVSA74CAVdOcLuwhiOOoD/KHDd9pvCb/2BXtGVdtWL3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(136003)(346002)(396003)(186003)(26005)(1076003)(16526019)(66556008)(8936002)(36756003)(6512007)(66946007)(6916009)(6666004)(30864003)(86362001)(478600001)(52116002)(5660300002)(66476007)(8676002)(2616005)(2906002)(83380400001)(316002)(956004)(6506007)(44832011)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GovWGLtyMJ/P+gdjZJmQyQUgwG0k4uIXyFsib1FSzZEX0aOvUS3Xi5cW3c9+?=
 =?us-ascii?Q?7GhpyxlTIrCSX/RETVSFYzrJanXKf9K+TLVffLctPUj0/3wL9lxkOgDKmHlU?=
 =?us-ascii?Q?8Dkxwy2CJMcC9pqyXOxFgnF412xVwZWzZJw3dl55sLAIiUbZm5Z58gGQKdGB?=
 =?us-ascii?Q?uerGU1njZKCMR276AGPzItjsiJhf3uRiActrl8TNZf9TqYQs5VUUTYJOPHi2?=
 =?us-ascii?Q?1iDJzIzk/WIedq86wYxpHMC0ze/yshF9QMpEmfoENxZvGChmu6S5hg4EWF52?=
 =?us-ascii?Q?rErVN2ZTg9XP6hT/RmEDgofYnyiH3zv8ors3xu1wmMoTk/Ky0nVZbXoR2Ywl?=
 =?us-ascii?Q?cjDJsIdVPvJ6Ta0/RoaolAHTaGNkfXJ4GLwT/641l/xPqJCI4QDk3RXO1B9o?=
 =?us-ascii?Q?+hVy3IDVT9digcPkLy+51k+iZaUlRT/A5dy1fvtwMLz9wPezyrbziSk8reVq?=
 =?us-ascii?Q?36JPtr98UKj8ZP426ZbRwmG1cqhjib7w0I5mlydw0pDqvgwZS23QAuCu5JmG?=
 =?us-ascii?Q?nE7y6CR4S59KFfIeQoWDF+sMj1GV5OR7tG8du3mSb6nwgS1IyFFHDN4d7WaQ?=
 =?us-ascii?Q?G1ne1RoAbw98qeSI/ppvJnt3MGYK6vB7Ppj98LpInsFDk9dsKr0c+YjCs8eD?=
 =?us-ascii?Q?5GH3EAhokt57xx4LpqHpqwXrJRBaZv1lJxaQSUa0iArtnfuYOiXaziC5WV8E?=
 =?us-ascii?Q?BBNEirqoWq4bFZSCvSE5cHJH7o2lx1VoRRsmYvkW+YWK4U76iYGkCSxR9cws?=
 =?us-ascii?Q?GF9nay4bGh/GO2nCJ7hQ1/F8xqXFmtlJjnCJlJff3GHRSgvjmiW5jdAbh17K?=
 =?us-ascii?Q?OpwbAP06BwaV821uIRbjk/DUWg/uwOubbfknuN1H0gjPQIeVnUQZRsKdsHLm?=
 =?us-ascii?Q?+Q86yB5I7jL9rWwIj4zy6yDJFtE2N7Y8kdGyEd8YV83xL5YRSDNmwQOy+BYC?=
 =?us-ascii?Q?ijSxZ2jUw7ahgzAc/l1scYKJyzbsWPerywGv8IGkjM6rTqt+8nJ5KwiUGzTt?=
 =?us-ascii?Q?d7E6J6c8dGVMCaFLO7OaGp9TqjK15r6PbmVuHAwYPG/qBaTFEkjO/bt8ShcX?=
 =?us-ascii?Q?B+fEpdJsYwj8pbQFHWQrjDQuWmXoBlJvaTitrTTaUhie/9POLAiXHD3MSe3B?=
 =?us-ascii?Q?2kUMu1TbRYB5LIjTFfbitiyAXAc9NhdW+99Ttc/rSogqgHYhlEM4GZWjT0ps?=
 =?us-ascii?Q?M4VQuRCLGDHHLz0heN/pII3zDPtR+WNa3QpkkbKkrAjq2HSrjOAjiBCgoiLS?=
 =?us-ascii?Q?Sovf+dkGSMVqy1540nBcPQKUjhwy9x5nveRYALFRzoKgkaCO2jyuQAMVsMGO?=
 =?us-ascii?Q?iqN9bbKTcKC/VTHl0OyVOZgF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 401cf0d9-47d0-4255-1c5b-08d8d42dceb6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:08.1654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MnqWpFLYi5C57lmq6iz1h+EBJ2p9VU5oRi2VlQeKVPzAjspv7MJ0roywbEh5Nyu0V7t16+L/1tcQ6Ad8zkKKOEePCkmDPDpZswb8TFLbBAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3381
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180143
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch modifies the attr remove routines to be delay ready. This
means they no longer roll or commit transactions, but instead return
-EAGAIN to have the calling routine roll and refresh the transaction. In
this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
uses a sort of state machine like switch to keep track of where it was
when EAGAIN was returned. xfs_attr_node_removename has also been
modified to use the switch, and a new version of xfs_attr_remove_args
consists of a simple loop to refresh the transaction until the operation
is completed. A new XFS_DAC_DEFER_FINISH flag is used to finish the
transaction where ever the existing code used to.

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
 fs/xfs/libxfs/xfs_attr.c        | 223 +++++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_attr.h        | 100 ++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  48 +++++----
 fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
 fs/xfs/xfs_attr_inactive.c      |   2 +-
 6 files changed, 294 insertions(+), 83 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 56d4b56..d46b92a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -57,8 +57,8 @@ STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
 				 struct xfs_da_state *state);
 STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
 				 struct xfs_da_state **state);
-STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname_work(struct xfs_da_args *args);
+STATIC int xfs_attr_node_removename_iter(struct xfs_delattr_context *dac);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -221,6 +221,34 @@ xfs_attr_is_shortform(
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
+		if (error)
+			return error;
+	} else
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+
+	return error;
+}
+
 STATIC int
 xfs_attr_set_fmt(
 	struct xfs_da_args	*args)
@@ -531,23 +559,58 @@ xfs_has_attr(
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
+
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
+
+	return error;
+}
+
+/*
+ * Remove the attribute specified in @args.
+ *
+ * This function may return -EAGAIN to signal that the transaction needs to be
+ * rolled.  Callers should continue calling this function until they receive a
+ * return value other than -EAGAIN.
+ */
+int
+xfs_attr_remove_iter(
+	struct xfs_delattr_context	*dac)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_inode		*dp = args->dp;
 
-	if (!xfs_inode_hasattr(dp)) {
-		error = -ENOATTR;
-	} else if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
+	/* If we are shrinking a node, resume shrink */
+	if (dac->dela_state == XFS_DAS_RM_SHRINK)
+		goto node;
+
+	if (!xfs_inode_hasattr(dp))
+		return -ENOATTR;
+
+	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
 		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
-		error = xfs_attr_shortform_remove(args);
-	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-		error = xfs_attr_leaf_removename(args);
-	} else {
-		error = xfs_attr_node_removename(args);
+		return xfs_attr_shortform_remove(args);
 	}
 
-	return error;
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+		return xfs_attr_leaf_removename(args);
+node:
+	/* If we are not short form or leaf, then proceed to remove node */
+	return  xfs_attr_node_removename_iter(dac);
 }
 
 /*
@@ -1191,14 +1254,16 @@ xfs_attr_leaf_mark_incomplete(
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
@@ -1207,22 +1272,28 @@ int xfs_attr_node_removename_setup(
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
 
 STATIC int
-xfs_attr_node_remove_rmt(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	*state)
+xfs_attr_node_remove_rmt (
+	struct xfs_delattr_context	*dac,
+	struct xfs_da_state		*state)
 {
-	int			error = 0;
+	int				error = 0;
 
-	error = xfs_attr_rmtval_remove(args);
+	/*
+	 * May return -EAGAIN to request that the caller recall this function
+	 */
+	error = __xfs_attr_rmtval_remove(dac);
 	if (error)
 		return error;
 
@@ -1253,18 +1324,24 @@ xfs_attr_node_remove_cleanup(
 }
 
 /*
- * Remove a name from a B-tree attribute list.
+ * Step through removeing a name from a B-tree attribute list.
  *
  * This will involve walking down the Btree, and may involve joining
  * leaf nodes and even joining intermediate nodes up to and including
  * the root node (a special case of an intermediate node).
+ *
+ * This routine is meant to function as either an inline or delayed operation,
+ * and may return -EAGAIN when the transaction needs to be rolled.  Calling
+ * functions will need to handle this, and recall the function until a
+ * successful error code is returned.
  */
 STATIC int
 xfs_attr_node_remove_step(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	*state)
+	struct xfs_delattr_context	*dac)
 {
-	int			error = 0;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		*state = dac->da_state;
+	int				error = 0;
 
 	/*
 	 * If there is an out-of-line value, de-allocate the blocks.
@@ -1272,7 +1349,10 @@ xfs_attr_node_remove_step(
 	 * overflow the maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_node_remove_rmt(args, state);
+		/*
+		 * May return -EAGAIN. Remove blocks until args->rmtblkno == 0
+		 */
+		error = xfs_attr_node_remove_rmt(dac, state);
 		if (error)
 			return error;
 	}
@@ -1285,51 +1365,74 @@ xfs_attr_node_remove_step(
  *
  * This routine will find the blocks of the name to remove, remove them and
  * shrink the tree if needed.
+ *
+ * This routine is meant to function as either an inline or delayed operation,
+ * and may return -EAGAIN when the transaction needs to be rolled.  Calling
+ * functions will need to handle this, and recall the function until a
+ * successful error code is returned.
  */
 STATIC int
-xfs_attr_node_removename(
-	struct xfs_da_args	*args)
+xfs_attr_node_removename_iter(
+	struct xfs_delattr_context	*dac)
 {
-	struct xfs_da_state	*state = NULL;
-	int			retval, error;
-	struct xfs_inode	*dp = args->dp;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		*state = NULL;
+	int				retval, error;
+	struct xfs_inode		*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
 
-	error = xfs_attr_node_removename_setup(args, &state);
-	if (error)
-		goto out;
-
-	error = xfs_attr_node_remove_step(args, state);
-	if (error)
-		goto out;
-
-	retval = xfs_attr_node_remove_cleanup(args, state);
-
-	/*
-	 * Check to see if the tree needs to be collapsed.
-	 */
-	if (retval && (state->path.active > 1)) {
-		error = xfs_da3_join(state);
-		if (error)
-			goto out;
-		error = xfs_defer_finish(&args->trans);
+	if (!dac->da_state) {
+		error = xfs_attr_node_removename_setup(dac);
 		if (error)
 			goto out;
+	}
+	state = dac->da_state;
+
+	switch (dac->dela_state) {
+	case XFS_DAS_UNINIT:
 		/*
-		 * Commit the Btree join operation and start a new trans.
+		 * repeatedly remove remote blocks, remove the entry and join.
+		 * returns -EAGAIN or 0 for completion of the step.
 		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
+		error = xfs_attr_node_remove_step(dac);
 		if (error)
-			goto out;
-	}
+			break;
 
-	/*
-	 * If the result is small enough, push it all into the inode.
-	 */
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
-		error = xfs_attr_node_shrink(args, state);
+		retval = xfs_attr_node_remove_cleanup(args, state);
 
+		/*
+		 * Check to see if the tree needs to be collapsed. Set the flag
+		 * to indicate that the calling function needs to move the
+		 * shrink operation
+		 */
+		if (retval && (state->path.active > 1)) {
+			error = xfs_da3_join(state);
+			if (error)
+				goto out;
+
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
+
+	if (error == -EAGAIN)
+		return error;
 out:
 	if (state)
 		xfs_da_state_free(state);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 3e97a93..3154ef4 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -74,6 +74,102 @@ struct xfs_attr_list_context {
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
+ *        found attr blks? ───n──┐
+ *              │                v
+ *              │         find and invalidate
+ *              y         the blocks. mark
+ *              │         attr incomplete
+ *              ├────────────────┘
+ *              │
+ *              v
+ *      remove a block with
+ *    xfs_attr_node_remove_step <────┐
+ *              │                    │
+ *              v                    │
+ *      still have blks ──y──> return -EAGAIN.
+ *        to remove?          re-enter with one
+ *              │            less blk to remove
+ *              n
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
@@ -91,6 +187,10 @@ int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
+int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
+void xfs_delattr_context_init(struct xfs_delattr_context *dac,
+			      struct xfs_da_args *args);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index d6ef69a..3780141 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -19,8 +19,8 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_attr_sf.h"
-#include "xfs_attr_remote.h"
 #include "xfs_attr.h"
+#include "xfs_attr_remote.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 48d8e9c..f09820c 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -674,10 +674,12 @@ xfs_attr_rmtval_invalidate(
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
 
@@ -685,31 +687,29 @@ xfs_attr_rmtval_remove(
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
@@ -719,12 +719,20 @@ __xfs_attr_rmtval_remove(
 	if (error)
 		return error;
 
-	error = xfs_defer_finish(&args->trans);
-	if (error)
-		return error;
-
-	if (!done)
+	/*
+	 * We dont need an explicit state here to pick up where we left off.  We
+	 * can figure it out using the !done return code.  Calling function only
+	 * needs to keep recalling this routine until we indicate to stop by
+	 * returning anything other than -EAGAIN. The actual value of
+	 * attr->xattri_dela_state may be some value reminicent of the calling
+	 * function, but it's value is irrelevant with in the context of this
+	 * function.  Once we are done here, the next state is set as needed
+	 * by the parent
+	 */
+	if (!done) {
+		dac->flags |= XFS_DAC_DEFER_FINISH;
 		return -EAGAIN;
+	}
 
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 9eee615..002fd30 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
+int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
 #endif /* __XFS_ATTR_REMOTE_H__ */
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index bfad669..aaa7e66 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -15,10 +15,10 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_inode.h"
+#include "xfs_attr.h"
 #include "xfs_attr_remote.h"
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
-#include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_quota.h"
 #include "xfs_dir2.h"
-- 
2.7.4

