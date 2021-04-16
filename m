Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A90C43603
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B44E06117A
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241673AbhDPJVd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:21:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50102 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241666AbhDPJVa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:21:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9ACN8166770
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=15gncFFWXs1dJz1YJS3RuBiC7K5P0RtLfgKt3XrjKrI=;
 b=uptqMChVL+gBtPQt6aterH8koWjUFIjQFeIyc+7Yzz4qcRE8CNtOXnITB3D5FuQBviIj
 OSy74F9XE3UB5bGL58LWIOLGUtfjF25uLtsScy+vkuZm1vW3vNYm7GEaegJUFOmqDJsL
 i5St8oiDgno7J5aKMk7JD2m/06ZRsxVMGoFXOubn6njOllYCfNpGKyTsVEvtZ7SxpPzb
 MsNrlxW5qSQLPy5K5yfHIu8JuGrIHqATPOGxgdU+zm9Sn4nHyfjSxgKO2II1KrrFKlLg
 X5hBcwENFFGpLeOU27otmaZhb0u+VFoei3p7FMRj9ZmmbbMYPiCxNI4Ye2ExI3p4G3fi WA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37u3errkmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9AXT7077147
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:05 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3030.oracle.com with ESMTP id 37uny2cegt-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSMuzZ+2DVlEeEXBOqm6yVtH9dZZ8qfprl4UErJAff2xfHDcnKEkDe7euh8OPsp6pmP3PsmC5nBRUMau/2ddNZ7upKalspZKOuYz4XD/unqRMtpDSafXVQMS+9b2+rMl0FAntJtWSAwQ5Kh1GRfbbYC0JZ0NajfCEslqSEhVed2YIU2JKh/d4vJ1BVgg954CwAeiS9CO8tgoBRkykcpGVx2FYmscUhzU5zBgtCztFx7GipYsleQWxdV86Xkq8Apej+zn0rhQ3K/kCsG2Q8DDpOJhbL2F5/TARVMxhKirGhEyIAMdLJl0Rc/qUnQBH9oj0oAu2CJuMN3r2qt4FeUVQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=15gncFFWXs1dJz1YJS3RuBiC7K5P0RtLfgKt3XrjKrI=;
 b=oFaiptmNsp25qr09zv9MP6hgKy254Falo4zlUL1mV7wkYamrASmaT6w6FtTOxASVgyjCfr9uqikoTv8/GPOGW2vH7qICkk6/Dpv6V24N1RV9e2Z3PpTMKu9virGHMVR7nIVA/qXfM8lbNizT992L0JK6A/9yncEI7J99faxIRZrgu+rzVVffvwFGoOiPltKX6SJs6mlmFtIN4wN2KOnlpLavHPxVPsJHB0dAkJYZxrb0K//qKV3xdJiHHoNOR1XUSFQR9yNYDc2pjfxKg+3tFPxwI9cTm5APLrzs6IkivKaH6Etn7DKfwNmhjghSxGaRYnUzjED/j21zxSTU3wl5RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=15gncFFWXs1dJz1YJS3RuBiC7K5P0RtLfgKt3XrjKrI=;
 b=q0iQ15ROjUStfp55aG/o80JeMnLwQZQnzmUxOvuaAM/W7YA6vaJcQUXYZIOXgLy+X98j2BEAc6/YvLnZif6SMvdy7mJbkYz2MsZ/DsTGWNH+0hPKaNjjahUlqghiifS1R3sEinbxQg1Y4foI2gSWBAzoAw9lIiejRvPLeat91WE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2567.namprd10.prod.outlook.com (2603:10b6:a02:ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 16 Apr
 2021 09:21:01 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:21:01 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 10/11] xfs: Add delay ready attr remove routines
Date:   Fri, 16 Apr 2021 02:20:44 -0700
Message-Id: <20210416092045.2215-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416092045.2215-1-allison.henderson@oracle.com>
References: <20210416092045.2215-1-allison.henderson@oracle.com>
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BY5PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::42) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BY5PR17CA0029.namprd17.prod.outlook.com (2603:10b6:a03:1b8::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:21:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9e7e4fd-b755-4eeb-71a9-08d900b8f386
X-MS-TrafficTypeDiagnostic: BYAPR10MB2567:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2567B5F8FE708593A170EC29954C9@BYAPR10MB2567.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j730QWn7Kphf7LqurTTkqIka8173nd5+Y6TG8vSIBWf6j51AwsG5C6ldeObySFluewVr5HNUxwMnToidtu7Zd9aPHtWkdZJ812nxxbsG+4VzU6hfD5kC2S4fQ+oXoXYpp1Giy/pnQcUOgEARowvvUFOPmbEAc37EZpd8BHNjJ7Eh+wrhsU5PJhoZjU9oOEGPhM3UXF1+wY0oRarWtEqA/8jJcQ0Eb96lPghj2IzifIK3YBV4yxr+c2CTy/a8kAcd2Wdqo8Lca+DZl8wYhmYX+gMGljCSRrqcFyegTVl/fYPtVYJxxikPLOkkkC/u2aILG/2mHXt/VS3InJR+0+bpAmWTvsNOGiPRFdVjnvD6iWFK8xhRKfagmphywZ49N1ecF/knfA3ZIJeBTiweCDMDK484KX5hGQ4aMnzhSKhh3GbWUJuBPK67qZiKdiH84TPgS0fHRKU9uXxm6olGfRW7/LakrOvXB7OYDoiHA+KnQM5NmTRcX12lWKOhw4ZyWg2mxNKId9qSkIB8QFwZcKkblVpGOxFVZ7JJ9D48BlcxVfhx1Bai5rGNj2ft2j6E2upBwgUttxA1BIn6XIjZdk/Ym5Jwte0dFfmQVzDmxuS1NPiwQiR2PlUkrVy4ncWfhoUP93iJVVYxdY/aWN9niVyriw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(346002)(396003)(376002)(16526019)(8676002)(36756003)(44832011)(8936002)(38350700002)(52116002)(6666004)(83380400001)(2616005)(86362001)(66556008)(26005)(6512007)(6486002)(316002)(186003)(2906002)(1076003)(38100700002)(6506007)(66476007)(6916009)(30864003)(5660300002)(956004)(508600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?98511q8WwEpu/7WDiCToh28oW+gQhrXu1xc+UIsL+FI6X26dGSJgc5SppPrv?=
 =?us-ascii?Q?p9YXbUTcwYWbPjGFH98Yc20AMaenUEQ4lzasljmmH5rBkNa0BOSWt3OcY6ef?=
 =?us-ascii?Q?G6ETcc8FpWjT6OUG5iFFTc4DjSESRkKQjlLXcLMtqobPRZ4Ismk0V4K9++gE?=
 =?us-ascii?Q?X4uFyOHcnbPGObumQRlj0zIqbOb1CRf5dI3b9d567zho4AZkbxjDr8Z8f4a8?=
 =?us-ascii?Q?UDtNM34G7lHy7M+T31KmMH/X1tUYJ0w2YtesuwnIpmhS6WZ/IIJrOuTVwoaS?=
 =?us-ascii?Q?WnLnfcdoZbya2lcQnp48Vu5r/oXTzRQI+XXmFhHPL9SxcKV2CTImoziOBd7E?=
 =?us-ascii?Q?7Vj5ykk4W+WwOO56cT1BOfdUJSeM7v3Yk7VzZF7PI9rtUjtKB/zBeuS9n4cX?=
 =?us-ascii?Q?x74vDR+v5M4IFCaAhrh1eiRdzE9HY43wfw8RBHT32Cqj3BXN6Qy0yc01UIG5?=
 =?us-ascii?Q?ZErLzm5qvXhXM28JjvyuWMKYozl11dbRZUq9w9X04uKRObo/0RWyGVhqrjg2?=
 =?us-ascii?Q?w14/hpw71H3o2/LwFVv5ZowMRp1Ox1Ir6oioVUGAGug9sMjxliqGCyrJ4Lx1?=
 =?us-ascii?Q?lgvXC0b+cZar31sOP8avV/WH3N/9nXFVxz3IbSTdzdm9yRjRYSsgHp8ISRuj?=
 =?us-ascii?Q?xM0IHps7OA0Ds1jeioQJ2mBSq09eozN8/trwN+56+em0a0dC7EDB4/TmnML4?=
 =?us-ascii?Q?qkS2ChUejonvCJ4/du8bbI50HioU7kFV7KsBweUHf2JAcrRYMmg6Cot6rqGV?=
 =?us-ascii?Q?7uEj7YYvDwm+PhPgfh9N/8EOD5BPfrX1Fu3nXRNu6TEKfP7Ysec8cvz3pZLt?=
 =?us-ascii?Q?esK+kX9oVG9fg1xZyyHDDqHgjn5lDLs3ljeItNmJrOxvfSIF9zhsF3bxsecC?=
 =?us-ascii?Q?CGNa/3aTeDcOuj+rF21jUhTP9vD/aYe1jFa9KsyD6F5zPQmEgXl8cR9aeXmh?=
 =?us-ascii?Q?eioj8hbAa9gWqz8d6MqWvrS7hwWRliWy+IO9meET9VPjPWdCJPDC/qmxJ1Fe?=
 =?us-ascii?Q?uZhLnBr62lUuLx+a+rWhT+afOB1MSZnPXO07a/IwLC1lyFeGXXrXfaCIUSfV?=
 =?us-ascii?Q?VnaLGwL8WjSpx41uIxcl7+VU4Qm+OFEcbLm+lBg3GZzgTxMt0J/WAdeE+1te?=
 =?us-ascii?Q?cd+zPZma6vzaBSz3Z/9/6WLowyqGR9UKPAAgnMsOmq4raeVHShlSsxOcgych?=
 =?us-ascii?Q?/i/RqEPxMdsY36eyM9cE2+WCRd2ykRQ/udVSlKDp7MNS3DXVt5Cl4eupSnZI?=
 =?us-ascii?Q?4lydHvkmP3YaqzeOM3wFfnzMMR/PhnN3k8qaH2wVqCWzs/yDe847/LDqyfYm?=
 =?us-ascii?Q?OKDr4xrcoBswoG0IV3CGAozH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9e7e4fd-b755-4eeb-71a9-08d900b8f386
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:21:01.1194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Udp5r4cQOvFMJEAcaLxT916S3ZIe2FPxYP4l5hChuMWpcBiqohWETe2A+t5KCGbJi4i4SYRqpNH6T/ZOfCkMnuOQyKnd3Z+pozCHBQSPWhU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2567
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
X-Proofpoint-ORIG-GUID: 8y0fm-OLasvSJrPe9--8y2gakz6BZXrH
X-Proofpoint-GUID: 8y0fm-OLasvSJrPe9--8y2gakz6BZXrH
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
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
 fs/xfs/libxfs/xfs_attr.c        | 208 +++++++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_attr.h        | 131 +++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  48 ++++++----
 fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
 fs/xfs/xfs_attr_inactive.c      |   2 +-
 6 files changed, 305 insertions(+), 88 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ed06b60..0bea8dd 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -57,7 +57,6 @@ STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
 				 struct xfs_da_state *state);
 STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
 				 struct xfs_da_state **state);
-STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
@@ -221,6 +220,31 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
+/*
+ * Checks to see if a delayed attribute transaction should be rolled.  If so,
+ * transaction is finished or rolled as needed.
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
@@ -527,21 +551,23 @@ xfs_has_attr(
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
@@ -1187,14 +1213,16 @@ xfs_attr_leaf_mark_incomplete(
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
@@ -1203,10 +1231,13 @@ int xfs_attr_node_removename_setup(
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
@@ -1231,70 +1262,117 @@ xfs_attr_node_remove_cleanup(
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
+		if (!dac->da_state) {
+			error = xfs_attr_node_removename_setup(dac);
+			if (error)
+				return error;
+			state = dac->da_state;
+		}
+
+	/* fallthrough */
+	case XFS_DAS_RMTBLK:
+		dac->dela_state = XFS_DAS_RMTBLK;
 
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
+			 * May return -EAGAIN. Remove blocks until 0 is returned
+			 */
+			error = __xfs_attr_rmtval_remove(dac);
+			if (error == -EAGAIN)
+				return error;
+			else if (error)
+				goto out;
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
+			dac->dela_state = XFS_DAS_CLNUP;
+			dac->flags |= XFS_DAC_DEFER_FINISH;
+			return -EAGAIN;
+		}
+
+	case XFS_DAS_CLNUP:
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
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 3e97a93..28fe719 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -74,6 +74,133 @@ struct xfs_attr_list_context {
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
+ *      Have blks to remove? ───y─────────┐
+ *              │        ^          remove the blks
+ *              │        │                │
+ *              │        │                v
+ *              │  XFS_DAS_RMTBLK <─n── done?
+ *              │  re-enter with          │
+ *              │  one less blk to        y
+ *              │      remove             │
+ *              │                         V
+ *              │                  refill the state
+ *              n                         │
+ *              │                         v
+ *              │                   XFS_DAS_CLNUP
+ *              │                         │
+ *              ├─────────────────────────┘
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
+	XFS_DAS_CLNUP,		      /* Clean up phase */
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
@@ -91,6 +218,10 @@ int xfs_attr_set(struct xfs_da_args *args);
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
index 23e2bf3..ea019e0 100644
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
index 48d8e9c..908521e7 100644
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

