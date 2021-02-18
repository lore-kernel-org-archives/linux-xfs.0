Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD3FC43381
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C74F564EC0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbhBRSr6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:47:58 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53596 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbhBRQyx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:54:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGnCY5185493
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=FQn3udCKPfejLb4mQYcU0WpTDXjzEA9MqxMMyJ+Z2A4=;
 b=hbyIVs23doFqZYmDbSZCOWbPyzpLuJTTgJHOX36NAUr6fomosuxSdjNvehKipmenbcPH
 ynpToqiAS2mMMj+SkINWCLT2e7nZdv4/2+zq7B/NeHaqBWDA+zSVA0M485RY3v/dJzgg
 gdcwmCaxWtIKV9vx0DUZ6zuHBHXY/fLhAECa8oScOSjKC7yGaz15l2Z623brrkLzagfy
 wsHLYqB36NDABp3MS1uMRe9pk72ZczjMILS3tqeiI6pp8oHo1XVDwWsi8ErvDkzqIVKr
 ymAFewCozp9UX1jXXe8bZg3usmp8xJ+w2JGZgtH3Z44nHD6sZcLQRWCC4Qctap/UAAsd mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36p66r6n8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGng2q162351
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3020.oracle.com with ESMTP id 36prhufdmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GI3/WKsWWJBIqEBPoBPaN18qy6x8J4QhDSplQDNVZXzohwN5voVk100T/obnnlrH+0qtWD/akpOlw49MZWexbsmHRhzSZ1Uy48/MkWx2DPI7COlNLBnmqEQiWPBAVd4bDg5Y/Td93v/29Xo+76tV8yYiGFdcN1K+zzTVQ/o5Wu9Y2VKnbqAEwpz8ax8rfZ4LORy81+Nyw+a6qfPLU3fVSsh2dp/Kh76Cqg8n4xOow5xTtmUEaawvkwc8UmZj19qL/c3zfsIMefC3dwBMM29pUSltRu7gjj/uGUyjBq8OGFEAmHtCgPxY6l0pBEEsgu98m0+ONNG5zP3rM4J+cc90XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FQn3udCKPfejLb4mQYcU0WpTDXjzEA9MqxMMyJ+Z2A4=;
 b=CAsj5XwaekkAxas4/X7VDcUgDNCe3L2LwhXCkAodmXI6e/1YkSbnmfFvcVICA03nb3HiJHhRwRedMOQGZ8dXxVzx+lLe2fDpa8l0D9jFGhr9doepcyp7abXLzDu3tiCo6RYlI09DcsBBdpmmi/QOKyA5LDfi/qHS++ar8wYhpewJuXk7NWXyS42s6iKeAFAMIc+kyrRluRMmCH/4dOFueCvBun7GfITpYYzEjHFBKjFZEOnAcwW5Qf3VHKU7ZkKy0HTSCWlc6m7yiZozyBGoIgFVRVcxja26FQ07njUkXegYPWZkMzqL4p8FvFz9QKT+Ls5JUbwpowfo7GeDVINKSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FQn3udCKPfejLb4mQYcU0WpTDXjzEA9MqxMMyJ+Z2A4=;
 b=cHW2o6nn3tEhFtCmA5D7AuQfWiJd0exYNzkrcQyo1QU3FpTxd3HaACxbKNvf+blu0fiXL/JrBb5h94jZtw9MqUyDdFny2xR/1iajI72qjMgBhoaYk72C4hhoikJfKvjBn9N8FAwzitfGRtQWJJG8LjEZkMDlwx7MbiWb0pteD1s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3381.namprd10.prod.outlook.com (2603:10b6:a03:15b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:54:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:07 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 10/22] xfs: Hoist node transaction handling
Date:   Thu, 18 Feb 2021 09:53:36 -0700
Message-Id: <20210218165348.4754-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218165348.4754-1-allison.henderson@oracle.com>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 853aec3c-c2ee-4f21-2964-08d8d42dce63
X-MS-TrafficTypeDiagnostic: BYAPR10MB3381:
X-Microsoft-Antispam-PRVS: <BYAPR10MB33814F4002A5405B4F9003E995859@BYAPR10MB3381.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9dSG27bRlprOyrL+f+kuWp0fY/JUahkp7Jv6esScojm3bl4Z6qfPwJuGRRERtNNQvl5Y1+nWYNz4szmdpunEqRJNlGaScGvv1P6g/ICjKQZxuUcrco3V4Gdunk+cASeUGtPpVlY0VaAEKem7ircf6d7E2mfN2j2TKr5XGw7if/lNZRGW3Qaz5aoxemcI1qv2p7smO5vy87wBurQ07XbG+OHOs/sC6rVa/HHA6YZO/FoVD1zxKOSErusMjCVDAwsSicLu1GSAjsMgm+zeATOvtqQM4hsPyOw2qhPwdq1dpa0QTVoPgXGqugDXNFyvPz0+4MVoxhBEOz1udtqS4SnhZOyh7ENPFzqHJ0fmb7fUsj05w2ZDnnMn+lOiASzHHbGxM2mBgRmX/6un8HW5tEq85MufqRWnrcOC/1B/1+Vi7Gl6v1OYNucVTdGoXSZ0C3n+Cq7/Yd+uKiP4buyt8P7o499OIg5GT9ciIBbcczU+UhnJA35RKbI28DfQpH7qEFciTgDMuiGzdd6GV19V6aTE5KkpK2iqHPaVS13RsGH2+bWzPVMNsJf9t6v0GExY5NmaSjTeZZZ7YXqtxh01odSWww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(136003)(346002)(396003)(186003)(26005)(1076003)(16526019)(66556008)(8936002)(69590400012)(36756003)(6512007)(66946007)(6916009)(6666004)(86362001)(478600001)(52116002)(5660300002)(66476007)(8676002)(2616005)(2906002)(83380400001)(316002)(956004)(6506007)(44832011)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?p2oFluaY6+YKQSwZSOrYUgfSS3Q5ZQ7WsKhtgsFOjQoQWOcZSAy9pify/ee+?=
 =?us-ascii?Q?Oh33cs6yD71LLgBJm+fWa2Pda4dR9YiHUM2wF94FnVEMHWVPGLEldJsraLzf?=
 =?us-ascii?Q?R6sgFfbgHuM3FCseJggurihBzD7qn1ZgBFnYwSItKwQTimUjjSywDrOari79?=
 =?us-ascii?Q?P/DcnSzCxYuhYmRc+kLF5xgjVOriAG4WfkHT+7MjJOnwXGC7TBba1zw2AKF+?=
 =?us-ascii?Q?DGxaxjpCB9HezoiPtXA2wEkbwpu8vZIdESKjia5a1RRZzljc85oELp033F5/?=
 =?us-ascii?Q?7IZu61RUMs5o7UZ6gSLZzDh3GUVIi6CnsiEpVn0u8tjdjjqDW3cjkH/unas1?=
 =?us-ascii?Q?v5W9pN32P/g1lOzxdX1xWGypmWdhE+nrRrLB9doZZrNucv9qyzFii2mvJ37x?=
 =?us-ascii?Q?E9F8kq/t3nR3lxG1JGHHOiRBeZlqpRKCMyjEo+B/FqfFrHAh7oMh27sEglFY?=
 =?us-ascii?Q?+bSbgzcLpjugLaa6xKudRoFimR5tvhMTCDIgWJWZMt6BJK6I+/ZNrD/LmT7l?=
 =?us-ascii?Q?6WN67yBujlka0KCEJCKkXbOyotsdZLbLqsf3Vl14xtUbSKB78k4f5z0v+f5w?=
 =?us-ascii?Q?FkxjNZr60pvcryt3Pd2s6iGkC4lNSLi5SGLGu3GIdn/bY1OBseonify+mOrL?=
 =?us-ascii?Q?sO/D+Kn7SdDcxjbH/Zb5oMhum+mhzEws0AlST/2/4kAjXFVNDEy/2ltHspf0?=
 =?us-ascii?Q?Fe5BsVF4Yj8N1VNC3MAHVcMBnv36iqhCQKZIIEU6XXfA12M2jFLWGWrh11e4?=
 =?us-ascii?Q?NXavhIHNaeyrQSz4IhMu2seDEAwca/lZgeC1YCQ1eJ4I8aYmpr/NseidOO+C?=
 =?us-ascii?Q?GdzYqewQWMebjkeLIZ61wUjvtSdKBGCMUOb0mQQBBi+ud9C9UwZFddJAwR3X?=
 =?us-ascii?Q?rYUZMBba1qUgN02UjUSYzdBU3j0Uvzuw/Wm/ZcBFFuUQlujwTVSRK/R4Z/K3?=
 =?us-ascii?Q?l78kdk77hKqBnY7HWMzVMc0xc0udJTn1VFtVEK9kOQAvEspAKIzrt+x4+5c4?=
 =?us-ascii?Q?KT04QBZQuXfXCJjkYX9FpUF/NaU7Cd6fRaxzE2TI9PaaReVQmleOeeQluxAa?=
 =?us-ascii?Q?Z7o5kB/kOsoMBqTATz8dgqRLn/OkJgZrvjzNb3O0FPgr45Ab/pisflLoyVKR?=
 =?us-ascii?Q?1VnbLu6DKiOwIbnDuGlTa3gQY8x0Uqd8L+AW8HJgBWs+8LBlLXWg1c88VQQB?=
 =?us-ascii?Q?J33WTsoTt9netA5IJyAzyMSO+23ImfxyouF8Be0sY7eRyCM11KGiZaOFLMUR?=
 =?us-ascii?Q?IJFgFJpWwMJSDkjQVh7OTK86W2tI9td+No5Vn8eswsFoPz2oB9FWEg8sw27j?=
 =?us-ascii?Q?deuBcgDm6OXsNNhKiEhDTmX7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 853aec3c-c2ee-4f21-2964-08d8d42dce63
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:07.5949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XtOrqCwyXzWODD/2zQLd8X15uK8awznEXdFvH2jEdJuyLAOfjFIgRZvXUmKJFfVJBvhL4e9XTcPWifGmk3tHMK/pTsAj27Agq2Q0VF71LFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3381
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180142
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch basically hoists the node transaction handling around the
leaf code we just hoisted.  This will helps setup this area for the
state machine since the goto is easily replaced with a state since it
ends with a transaction roll.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 53 +++++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index bfd4466..56d4b56 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -288,8 +288,34 @@ xfs_attr_set_args(
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
 		error = xfs_attr_leaf_try_add(args, bp);
-		if (error == -ENOSPC)
+		if (error == -ENOSPC) {
+			/*
+			 * Promote the attribute list to the Btree format.
+			 */
+			error = xfs_attr3_leaf_to_node(args);
+			if (error)
+				return error;
+
+			/*
+			 * Finish any deferred work items and roll the transaction once
+			 * more.  The goal here is to call node_addname with the inode
+			 * and transaction in the same state (inode locked and joined,
+			 * transaction clean) no matter how we got to this step.
+			 */
+			error = xfs_defer_finish(&args->trans);
+			if (error)
+				return error;
+
+			/*
+			 * Commit the current trans (including the inode) and
+			 * start a new one.
+			 */
+			error = xfs_trans_roll_inode(&args->trans, dp);
+			if (error)
+				return error;
+
 			goto node;
+		}
 		else if (error)
 			return error;
 
@@ -381,32 +407,9 @@ xfs_attr_set_args(
 			/* bp is gone due to xfs_da_shrink_inode */
 
 		return error;
+	}
 node:
-		/*
-		 * Promote the attribute list to the Btree format.
-		 */
-		error = xfs_attr3_leaf_to_node(args);
-		if (error)
-			return error;
-
-		/*
-		 * Finish any deferred work items and roll the transaction once
-		 * more.  The goal here is to call node_addname with the inode
-		 * and transaction in the same state (inode locked and joined,
-		 * transaction clean) no matter how we got to this step.
-		 */
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
 
-		/*
-		 * Commit the current trans (including the inode) and
-		 * start a new one.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
-	}
 
 	do {
 		error = xfs_attr_node_addname_find_attr(args, &state);
-- 
2.7.4

