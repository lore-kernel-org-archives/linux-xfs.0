Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 541D1C43470
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13D3B613DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238143AbhELRGK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 13:06:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55674 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239710AbhELQPi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 12:15:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CGA6SJ028481
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=NYCBjTkB0ufDS/cT1In+t4bRFyWQh1tJLthLRHR8kK8=;
 b=slyZRldL9tqVeHz1VJVGv/B5tGJWkwASgl2jyhLAd7CwbyJLrO86EEt7dPYrULgpXwcD
 eTc2P9mIJMWC3OsDDFMsCOr3OhCcfEHFC1wXr3FyKaZzRQPHlHTWoXFqk7oEuEpIAG30
 Yh+sFnV+ws3uE2M1J22D1oVTaJGBECg7i/OWSxWthqTW6s5ZUts9Zhw01EG/GwB719wk
 PatblIcOLeNDDboQHqGMVzProGh7OkaqK3whUl6pQRm5jltm0xvk4h4bF7mAxiFJlxrx
 dLEwKRjhhLyTYG8iwSGksJ+dRkLYYfsfE4UqcwEYioPB1aprt9umH89W4t5QSONsoj1f rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38e285hua1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CGApnn142059
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 38djfc4w78-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SE31Qs+nta1tSnb+orZcBdFRtijo2tF3ppyeW8gbKXSfmTX4PDE970Z4pPz8X8mQhcK5HVFfoYODXql21xOPTJV6NQCDrEtEyvoNVXSAw64NLn7i3m0v0/6AsoW5nZEl2Wo7FOwNz0mkQqI2ujTbHI+sc/Bz4KX9uD2a46fHkbWjwcYvrDPjYLLVN5WMn8IEZUKuG+Ih1iVOXsbT+g3n4/gaQa+gyoz2l4V/etTo2IqOPkTV59Am20NC7wVci1PqUfEchdLPYd82AiWLC0szDGuB+z8DlEO4Mp470Rk+QKEUVoJAXh8hM52lViQpM9sKcf1aPrtKnZPpTwiJDWICWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYCBjTkB0ufDS/cT1In+t4bRFyWQh1tJLthLRHR8kK8=;
 b=Tpd2uUup/DjnrLGaXvRYtWye0TBx+u0qksdujPnqwHkSiqAlmkh6W124z0gsAMx0NfSQJO47qk5KLa3xAU1gCYHThBRIs0wgB7RsqNL6umEitmg5NYr4dG+by+TFPy2M37Sgu7HZiXdIZuGwUqryGbeVuox+AAXpVEw8Om0UyKuu9XUmmum+GLqtvmSpU7SEuBftWpp9aJiphCyljhckdK4AAIZYP3qzd+R4bFt03vivEi7rHF/+pX2Hpy1kP0L/fw4dKeX8l/5b7eLkjlcrd7shsZLokbKOuGYgDWk31Ilt2ZXSRlqOlq73sqAIJkvyClcv09h4iSjwCJjigFryTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYCBjTkB0ufDS/cT1In+t4bRFyWQh1tJLthLRHR8kK8=;
 b=cTbB5BxKyiLmRtgAgilOzUl3FF5qwd8eo8ikO66zl7HjVj18YYCaJusWHMN013NA6cpBp4BhcKYGD5LHiTIkG+TsP++UeSZGFphSlxCYsh8OxpY4xz/GDW/5u48UR5rYML6j1Drlu8+l8Qezluwuh4f7nktrvgSD4FaKJ2vjxho=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3336.namprd10.prod.outlook.com (2603:10b6:a03:158::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.29; Wed, 12 May
 2021 16:14:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4129.027; Wed, 12 May 2021
 16:14:25 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v18 08/11] xfs: Hoist xfs_attr_leaf_addname
Date:   Wed, 12 May 2021 09:14:05 -0700
Message-Id: <20210512161408.5516-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512161408.5516-1-allison.henderson@oracle.com>
References: <20210512161408.5516-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR05CA0200.namprd05.prod.outlook.com
 (2603:10b6:a03:330::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by SJ0PR05CA0200.namprd05.prod.outlook.com (2603:10b6:a03:330::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Wed, 12 May 2021 16:14:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5940d3b-55ef-402f-a4cc-08d9156102ca
X-MS-TrafficTypeDiagnostic: BYAPR10MB3336:
X-Microsoft-Antispam-PRVS: <BYAPR10MB333686E48FB254085C073A8D95529@BYAPR10MB3336.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kx3T0AgymsH5jOopGHgggqQ8nSB5S8zJ6SSzFSbbA8PYcr41OUk2vuB74f5VuYMTWlfWM5dJ3PtIFUtjEjrnbto65NmwF1YDlIHGiTPrLJw/u9hE5BEbAZR5n/EjhJZd1837oVPgZ4I/Wdz852aFYubL2T43m4ANPKEDMVlo1QmFXd7ohKntt4W7a/ewXhme4DiZknDMCZId6RUGIyJ+gFiz+9T+T/ZEAH6XqkCve+bQ88IwPJO808JSIzisNer89lq5D4wo71W9v8ChCTNC2Qgf8II2v12LQisGH19fWNDBtzs9KFu6rJq2U0XMGntR3+5KxLV6HK/i1WJ8p7CQYKYaFtont9Af7y/qabkV/lYga/ofk5vaojRYN0EvZM7XtFxZPv7HRfqns9tu0s6C0AIBTs+oYT0rygsYlaA370ET9cGtslClG/XS50T5orsw2c8liI4J6Y6NcMrWX7U15U+W/g7M5lQmHSY0KTgnYRVKr6wBtGKQ/3cDc9j2AtJsG0Azki4aMIlsheo1FmBa1FL9MZsqyn1Ps0/uZWR+gixLune0PJlL3MPNipdOC/buZw4q0aqYF5wqOU3K9iC76d3qHjIFjrmUXhx1hYOE+3MkemoUUH7EA84UQ5xXjc8wSb8afivrBhOi3AJ8ND4JxCwUNxmdqUiw4OdN4ZKN/OY14Rf+BrK0U5YHICaXhxEM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(39860400002)(396003)(366004)(2616005)(66946007)(1076003)(66476007)(6916009)(16526019)(26005)(6512007)(956004)(36756003)(83380400001)(38350700002)(6486002)(478600001)(8676002)(38100700002)(2906002)(6666004)(316002)(186003)(8936002)(44832011)(6506007)(86362001)(5660300002)(66556008)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3qTbsV+bvTgqzCQxBXLLm0wOdbmGKmWMsmfOn+S4RvvuYD0eu4thBIygfypx?=
 =?us-ascii?Q?98HMrOy7WOlx3T/sD0iWZOsHH6H3nOQN2ku4B+xIpX7ds7xLJmNShl/zRwtv?=
 =?us-ascii?Q?SuB5xoAXKexH63K50+z/FELCYIg7UpRmd+89NKKwaihkkdSjXhAMa/nti7Yd?=
 =?us-ascii?Q?Qjzy6icVC8Q5dodTqF/IeSi+TryL1DAMUmL1eevMrwyFUVzVaziE5cipBArG?=
 =?us-ascii?Q?j9lErW7wjxOe9gV08k28D/GkjDtuvtcUID41lP7PL/HsN5XX22wM4stYlyzm?=
 =?us-ascii?Q?/Pv5uAlsX8NdmN0oGPJMxv3G4UAefYyefnQoe4s0HXDMLRVRkOlxHfKT3fwj?=
 =?us-ascii?Q?bEI9GMJETuspHDqV6r6MTppHQBdug94O72gKFPR9TlDnxIBo1D3mrChFVunV?=
 =?us-ascii?Q?ycCSrdWrwfo8lpARf8Vvjw0jNPUmFp+zB0bkz0ij4RGXuU3wl8fN7ta477Jd?=
 =?us-ascii?Q?be6FWzSJYzU0Pgmvhn01TUOi1EZA61lOM5NieB8cYQjNAsqWTWxhXK4y6gay?=
 =?us-ascii?Q?bdR/qYKHNlrLx4zlTWVzKKK4ZVq0Hhlc6v9PWHZm5/PxqgWRUtL8jPmhbi6i?=
 =?us-ascii?Q?NzPm8zhW5fOKwl3zCFLNCjMxNxvaZJXY4O63DWKjvcBD0VlJsr//fHnxKpea?=
 =?us-ascii?Q?Sp7L0T3aQkhnLCRYyC6ph/IHnbFqVTZBVW/ZhCwoFNXmWR3vek/PQvFwKTnz?=
 =?us-ascii?Q?epw4iy6rncTwzFdF6/R6Btv1r+IVwndJdCD8oAbZxXqZcX5ykWQw4wr69t3M?=
 =?us-ascii?Q?Ei7cumdjTux70njvvEMmxoppNzhdh6ua21DpiNh7U98tuMv1EFUqQ7QGivFa?=
 =?us-ascii?Q?+Pr9bT69RhnEL3mnUG5mEaNYw/6wUD28P8ahboiVbxNGlvtrSI64A66EzvwU?=
 =?us-ascii?Q?rU+Dnzq8k9HyoC6j2TEnSoVf7/HgekP3tfKJDBI/cnSK8AuaAaG0oGHhByPL?=
 =?us-ascii?Q?/JjlBGqJS8mfbo4/aDeE+xaKdCZpU3gSEQWTvdl+lJfRaTeCNHVAsMXHJJX0?=
 =?us-ascii?Q?v7k+xKaQwPcx1JTEf/u736OTsRGlbtbxbrYei9LStX3RTtp5Un+JQSoRIoeo?=
 =?us-ascii?Q?czNaL3JqsctGHysdyecsHiBaOyHQyNFaZJZXONPM8UqVgPWhMyCdz99kvkGr?=
 =?us-ascii?Q?aaNyeV7BUJprHxvhR2tZjIHbOYPAXixuA4mdREp8VzbdPLiUf85hs2a2+elK?=
 =?us-ascii?Q?ILQZC797P1AoLG03vuS49Cdc6rB3inR8RHtZYzwbRq1/vCr+pL04KDfQixOS?=
 =?us-ascii?Q?E/YY1K18MiL14roMIYAX/qMHD6gFCLdsLBqwNQLeQfyDQffdSyzUEUKxov54?=
 =?us-ascii?Q?ukUMJzK9KWZ/J94dOF5K2Y/p?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5940d3b-55ef-402f-a4cc-08d9156102ca
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 16:14:25.4184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qWniiCvgWVkrxfelW0O5QuijdDB2G+Oc5C60fC3r1YQ1NZQF0KbnFWQWcauPM/DiKV4qgcNXbmX37za9DKHrw8TJNUzJVsnHrhXTlg6/13c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3336
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120102
X-Proofpoint-GUID: vQTF0fd0kCLDpSWzmZVeL5g8FjYNMPHZ
X-Proofpoint-ORIG-GUID: vQTF0fd0kCLDpSWzmZVeL5g8FjYNMPHZ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120102
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
index 3cc09e2..6edc3db 100644
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

