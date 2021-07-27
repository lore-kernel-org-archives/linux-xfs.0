Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EBEDC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE5B761107
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235103AbhG0GUC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:20:02 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50406 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235668AbhG0GTu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:50 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6Gotl007292
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=jVAlxL6WsQ+fanM8OIXRjTGo/OUGOsUQWmk/Aq0NKwU=;
 b=mtnaj1kjYyuQ79BpNMKcefxJD8GBya5dquAT2zUmHoCxLyDOkfCbUgH7MhRZ036aeAgY
 AeVebbBh6hZvhxwKbEwHfnmX/oI2yHW2Zr8fQGsl1dQjdjqOBkBm8gqj4dM4gN7TfiN6
 JH+AXp3+i1BZX3Eo3GSkFk93AtKNnrEPhkx5C2RfGQFKeA+WcDBJUtHqPuuu1JIBFy5U
 WNtTfE8uISHZ1eaQ7Lfb6ibXos3cUbQ/qwpf8CzKVW3+hr6TbwwFIgW6M1Ha7HzF8UTl
 E+kvo5pzYc20qpfG7WoRfa8BznaKSk9NWeuJsC1WGI9edNFs7TIZtfTESiE2kjrHK7Eo eA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=jVAlxL6WsQ+fanM8OIXRjTGo/OUGOsUQWmk/Aq0NKwU=;
 b=IV4SflIPmjda5/yBZWzhH8zsayajUk4VQGJ+FDJhL7LxA6AXydxP09M6wOhHrfVPxTcg
 1+DoKY1oRge3JjMEVtJqN++lre+KJlQA0msh018MjbX99jgfM1dDlPc84q/hKPjlEDOL
 xna1xd8xBfgPkgz03BQ+xWbqRsB32b1RZ63sJCqRpZ9CK4rmjYdfzHkanu/J483RtPBg
 9ePXPsO0FaHtOLMVJLuiAEsityr8ipCuSyWUAdtyebsqzV6139bZxRohFnZl682zNep4
 uLwQ6QvniqZXEl8U//vNYsYxEmoIrws76pnr7H1C15H0dI5p684Rg6PRw2fySW3T3QZn Zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234n0udx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6EiaE065026
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 3a234uvntm-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvIlsREL8I1jAzcVZNWyBRuAuc9m3SAQol/RV4ydjLkpBRebAMIALY645JecyKKdllW/ukPwvkR0Z0OZAahSRfE/EPf/IBNLqsPIDKL7PZqHn6Xthz0QsQnAzSp5HAfuVPPEEy5MUaOEF2fvH+pBXWHAlQU7ruDSlyhosB61DMZRPxjENbCTbh7pcpfqIicLh3ojGKf+W14dFWmxtEHsE07LYP9CUCEIQs4Esaad8xCJfLS2WYf1ENl+dervOjTSIXGkonZ968BpGSQ48/wb42wncLvDl8PXmb0+sbBslrw3mFbzjqpdLRxNCA6T1Aigen5fBBbcpndXuF+djhCetA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVAlxL6WsQ+fanM8OIXRjTGo/OUGOsUQWmk/Aq0NKwU=;
 b=e6sXWw4jkOFB6Ane4i+4OkNOX1E7sHUFpNReXwkryiw+Js5tHu7VHbNgSkvCBd24x1/AdjhkwnfpRKBGMHwDkNiQEwQ+XltRSP0PPDY3hnirC+JVnuG269g8C9bEzvm39PhjsStoaIrT/4pcMWs90mBu4YPeYmDU8av6QwcSY83XHHbYOuBmO1kIv8KX6BIVswWPqnyOgMXVp5qb2WhIQbQMgSoXbn5bhL+q1cg01mAqK4sllc8vsXQdgDqhbjZTnRsaby60R4GxLBq1QBjksUSUzHOTmzp7QqSUtt1m1CXDHKUmlB1MXm0/GyK4gkJwfiPHb2uItOJ5OdoomQXsPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVAlxL6WsQ+fanM8OIXRjTGo/OUGOsUQWmk/Aq0NKwU=;
 b=Wh3rlg+4bWus9IjlV+9zN8w88srVkQQUcH88SZTg/qrit1V6kDft6xhOEUYCoF5C+xA7lyR/TaRXJIEU6BxAU84BLOQOPJklPk3DOVro5CUKmA5X9Jwjny6IVOadjpq9e0+9wl7Rsxc2y4pVOySLyFn5QuQDcfy48EhWhc+a+pU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3669.namprd10.prod.outlook.com (2603:10b6:a03:119::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Tue, 27 Jul
 2021 06:19:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:42 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 09/27] xfsprogs: Add delay ready attr remove routines
Date:   Mon, 26 Jul 2021 23:18:46 -0700
Message-Id: <20210727061904.11084-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65832d28-cc03-4406-0c7e-08d950c68597
X-MS-TrafficTypeDiagnostic: BYAPR10MB3669:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3669FA0972F4C350DDB04C0295E99@BYAPR10MB3669.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D2a/99dc3IFi+dRsBUunh3m6O3O2w7u25z0EDoCGC3LiKQhWEM2sHftGvSlBKXA/3Yg3HaYBR3y2ISHAo01Kiz3sJqL9DG+Lv8jmNmLv3/PKTnsfXq4jzD1wI+zWGnU6XgMJmZQbPxn1NG2wVXxr6AHB41aPs3VE1YTXTW2tKDTwu1ZAeJ4AXlWYF73mrTXAfkt0E7qmeQgZJj/5b7n/RMATksSO9O4kBtIlUuQF3UQpfsoOgp6rFGcrYxdN1q13W5e2gNPmZqv0Dv2BGYYXoDzzKkpoA6Y0cwD9+1qQ4hVPNl46LKwBaZU/2EkVNXgAYLwBufpEZ/GmxspsqQSg4V3iD1fUEMmysvrDTkkZZb/fDsGT7dUaqHSb5Qvork31qCx11NU4oEwTznFKYZyLdu/xLujFAwjkxXGHRvi92nenbufnbRP9hw7ibVMs93VTg0R6qYJALASW93eiupHZLrYaQvym/D22v2PQUwlcmCZZvLfRIyVt6coy5LF0kFSjwZ9Wu/anmPvtsDN2yayqWcH18QQiZoHivBNjMEctLB4SBSKT7jc2yu3xuJA0klEib+SUcMi94TgULDyjQccXou9o/mkxVGtSMOLrq1DHqa5WP2Vq9WpZj2Cw23AKrbDMkna1p06xcwo1+uq1a4RwUXlz0HPG3GhD/Dj+rwonpUuA9kfByL2JskQbPLaB1pLZ+NUfOaeFeS8zdZ8oVx57EA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(44832011)(478600001)(38100700002)(38350700002)(52116002)(2906002)(6486002)(30864003)(186003)(6512007)(26005)(1076003)(8936002)(8676002)(83380400001)(6506007)(5660300002)(36756003)(6916009)(86362001)(956004)(2616005)(316002)(66556008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Dv3T8oYyz0C+gzCMZ2jbNyveLJBsIH43g5rJNyWu5CHXZ2n/mjHB8AG9sDX?=
 =?us-ascii?Q?TmaQcpX0S1uhjcxfMakTRG3yOLM78ojVpCXHcUNl/EhhK1ywryMODeeX83qK?=
 =?us-ascii?Q?PfqNx2j0VRnELuczQw3QFFH37oWedEKf2APq48Y5oTxfZZFhachvzYJ1i9cA?=
 =?us-ascii?Q?81dYE3QdvU/V7UekA5W+1D/qgoVjAV8A7wCGEacQGBvAI+LNmKaB+TyCpe+7?=
 =?us-ascii?Q?UkD70rkWvcVAYf4HQWww6cT6/ficL08go/FtylP06YyPmZl7TyxJgxUbGcO9?=
 =?us-ascii?Q?v9wN4oh73wxqd41KYOEvB74EgOM2nrReKUfoB4vdp7jOK6ZJoW2PRXctDaOh?=
 =?us-ascii?Q?4d90G7sOYJbrOqkOzGfA6d/aib8MBY5q4e3EGrAujk+2qG/7uCwZTTkdDdNK?=
 =?us-ascii?Q?NF0JNxHYid7jNXHxdmD/jRZt/eKU34ekIdkzNszCI/8RhjsNJVMXyQrFnFOx?=
 =?us-ascii?Q?Hi2eHd/nEa43mjRGap7uvk1Pb0BdCycF5BWdR+4G62ohqn9qXQPJcH2okpCM?=
 =?us-ascii?Q?CFIhWNSNMcZf6RITYnA8ZOZXSJAGcKMdVLe+vxtRUZ++IhpWEc+GD3UYBB5A?=
 =?us-ascii?Q?9zFCSzCQy3GuVKgQlOBn1PpsPhv5XG3bhe00vnYdSVCz2v3kTdnHMxiFzrWn?=
 =?us-ascii?Q?ef8enCZi4BdHpvCUrBgskO7XglG+nMtFtok6biy1JuLNQB+Sen2rtYhQhFnI?=
 =?us-ascii?Q?MiaS6Smp0M4DsK9dBbgIQxv54pHz9gE8OxTG4jtgfuwa+n8IVDZHbNDBEGPH?=
 =?us-ascii?Q?jSQNVlmcrE31X3s/PuMKPz5iJkFXE8JbWSLTU+YR0rf/fI1Z2+ZIbBpFWkuU?=
 =?us-ascii?Q?P1tUAUNMLje2e9MRPHzneKHDtGtutWsAM2b0ReNtivLPFsasXFdE1v26sl4i?=
 =?us-ascii?Q?5t2U1UkDm7Myj1lIRt1l6bbbQTey3S23mI4mn6FEHuDofpo7PG+Q2J5MioY4?=
 =?us-ascii?Q?J6zFzA0OfYy2Q2JOQ9Y9HkjjvLZmri00hMcP/lVjjzk6HmMVRZ0bwqXS7DdT?=
 =?us-ascii?Q?I+09ZanrnOgQ4PBPVI+4d+suQ/CVw1u49u7dxOjl8TwqXruMcuqGG2c/dyvF?=
 =?us-ascii?Q?+5g6rMghus2DpyRMoIiDOgVtZzj6mlc0yuXSemXGTy/wfqKYIRrUCQmRyYXm?=
 =?us-ascii?Q?L8sBYBl4fK6FVJ+/kzAUWQmDM8NpNJ5urlicM8+v31iFpsyVoNMscXTp/Pka?=
 =?us-ascii?Q?tiKRkRc364QJ13VDjXcGq4Qk3cpTLGvs5SE2Gumej5d9dicDSgTVkSlK0Mtp?=
 =?us-ascii?Q?Cn/ZrxmvHqda0oY9a6cDbDD/tkR2azKA3QcyUzFH9yBRYppjEpppjUuqzMcE?=
 =?us-ascii?Q?zFRkxMdy+DSZ+ehQnp+IT6HH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65832d28-cc03-4406-0c7e-08d950c68597
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:42.6393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bvei/QWFFGYnz72/jn1XBolDjOpRnmvStR43/8wQgiMVxUPT1bfHb7/OLRbHxFXjhEhIaOOlNA55qe1Y+5Lh9VV7JbxdBVvLY8i95tLnZwQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3669
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-ORIG-GUID: 8tforv4Vs_mAwxCTTfBmxCbd9aVbcA62
X-Proofpoint-GUID: 8tforv4Vs_mAwxCTTfBmxCbd9aVbcA62
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
values across multiple function calls.  See xfs_attr.h for a more
detailed diagram of the states.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h         |   1 +
 libxfs/xfs_attr.c        | 223 ++++++++++++++++++++++++++++++++++-------------
 libxfs/xfs_attr.h        | 131 ++++++++++++++++++++++++++++
 libxfs/xfs_attr_leaf.c   |   2 +-
 libxfs/xfs_attr_remote.c |  53 ++++++-----
 libxfs/xfs_attr_remote.h |   2 +-
 6 files changed, 327 insertions(+), 85 deletions(-)

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
index 118ec0b4..94da860 100644
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
@@ -241,6 +240,31 @@ xfs_attr_is_shortform(
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
@@ -544,16 +568,25 @@ xfs_has_attr(
  */
 int
 xfs_attr_remove_args(
-	struct xfs_da_args      *args)
+	struct xfs_da_args	*args)
 {
-	if (!xfs_inode_hasattr(args->dp))
-		return -ENOATTR;
+	int				error;
+	struct xfs_delattr_context	dac = {
+		.da_args	= args,
+	};
 
-	if (args->dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
-		return xfs_attr_shortform_remove(args);
-	if (xfs_attr_is_leaf(args->dp))
-		return xfs_attr_leaf_removename(args);
-	return xfs_attr_node_removename(args);
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
 }
 
 /*
@@ -1197,14 +1230,16 @@ xfs_attr_leaf_mark_incomplete(
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
@@ -1213,12 +1248,15 @@ int xfs_attr_node_removename_setup(
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
 
-	return 0;
+	return error;
 }
 
 STATIC int
@@ -1241,70 +1279,133 @@ xfs_attr_node_remove_name(
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
+ * functions will need to handle this, and call the function until a
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
+		/*
+		 * Shortform or leaf formats don't require transaction rolls and
+		 * thus state transitions. Call the right helper and return.
+		 */
+		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
+			return xfs_attr_shortform_remove(args);
+
+		if (xfs_attr_is_leaf(dp))
+			return xfs_attr_leaf_removename(args);
 
 		/*
-		 * Refill the state structure with buffers, the prior calls
-		 * released our buffers.
+		 * Node format may require transaction rolls. Set up the
+		 * state context and fall into the state machine.
 		 */
-		error = xfs_attr_refillstate(state);
-		if (error)
-			goto out;
-	}
-	retval = xfs_attr_node_remove_name(args, state);
+		if (!dac->da_state) {
+			error = xfs_attr_node_removename_setup(dac);
+			if (error)
+				return error;
+			state = dac->da_state;
+		}
+
+		/* fallthrough */
+	case XFS_DAS_RMTBLK:
+		dac->dela_state = XFS_DAS_RMTBLK;
 
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
+		 * If there is an out-of-line value, de-allocate the blocks.
+		 * This is done before we remove the attribute so that we don't
+		 * overflow the maximum size of a transaction and/or hit a
+		 * deadlock.
 		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			goto out;
-	}
+		if (args->rmtblkno > 0) {
+			/*
+			 * May return -EAGAIN. Roll and repeat until all remote
+			 * blocks are removed.
+			 */
+			error = __xfs_attr_rmtval_remove(dac);
+			if (error == -EAGAIN)
+				return error;
+			else if (error)
+				goto out;
 
-	/*
-	 * If the result is small enough, push it all into the inode.
-	 */
-	if (xfs_attr_is_leaf(dp))
-		error = xfs_attr_node_shrink(args, state);
+			/*
+			 * Refill the state structure with buffers (the prior
+			 * calls released our buffers) and close out this
+			 * transaction before proceeding.
+			 */
+			ASSERT(args->rmtblkno == 0);
+			error = xfs_attr_refillstate(state);
+			if (error)
+				goto out;
+			dac->dela_state = XFS_DAS_RM_NAME;
+			dac->flags |= XFS_DAC_DEFER_FINISH;
+			return -EAGAIN;
+		}
+
+		/* fallthrough */
+	case XFS_DAS_RM_NAME:
+		/*
+		 * If we came here fresh from a transaction roll, reattach all
+		 * the buffers to the current transaction.
+		 */
+		if (dac->dela_state == XFS_DAS_RM_NAME) {
+			error = xfs_attr_refillstate(state);
+			if (error)
+				goto out;
+		}
 
+		retval = xfs_attr_node_remove_name(args, state);
+
+		/*
+		 * Check to see if the tree needs to be collapsed. If so, roll
+		 * the transacton and fall into the shrink state.
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
+		 * This is our final state so it's safe to return a dirty
+		 * transaction.
+		 */
+		if (xfs_attr_is_leaf(dp))
+			error = xfs_attr_node_shrink(args, state);
+		ASSERT(error != -EAGAIN);
+		break;
+	default:
+		ASSERT(0);
+		error = -EINVAL;
+		goto out;
+	}
 out:
 	if (state)
 		xfs_da_state_free(state);
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 2b1f619..1267ea8 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
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
+ * immediately resume from after being called by the calling function. States
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
+ *   │ attr has remote blks? ──n─┐
+ *   │          │                v
+ *   │          │         find and invalidate
+ *   │          y         the remote blocks.
+ *   │          │         mark attr incomplete
+ *   │          ├────────────────┘
+ *   └──────────┤
+ *              │
+ *              v
+ *   Have remote blks to remove? ───y─────┐
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
+ *              │                   XFS_DAS_RM_NAME
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
+ * calling function to roll the transaction, and then call the subroutine to
+ * finish the operation.  The enum is then used by the subroutine to jump back
+ * to where it was and resume executing where it left off.
+ */
+enum xfs_delattr_state {
+	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
+	XFS_DAS_RMTBLK,		      /* Removing remote blks */
+	XFS_DAS_RM_NAME,	      /* Remove attr name */
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
@@ -92,6 +219,10 @@ int xfs_attr_set(struct xfs_da_args *args);
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
index e13e83e..08600ea 100644
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
index 3807cd3..e41bbb2 100644
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
 
@@ -684,31 +686,30 @@ xfs_attr_rmtval_remove(
 	 * Keep de-allocating extents until the remote-value region is gone.
 	 */
 	do {
-		retval = __xfs_attr_rmtval_remove(args);
-		if (retval && retval != -EAGAIN)
-			return retval;
+		error = __xfs_attr_rmtval_remove(&dac);
+		if (error && error != -EAGAIN)
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
- * transaction and re-call the function
+ * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
+ * transaction and re-call the function.  Callers should keep calling this
+ * routine until it returns something other than -EAGAIN.
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
@@ -718,12 +719,20 @@ __xfs_attr_rmtval_remove(
 	if (error)
 		return error;
 
-	error = xfs_defer_finish(&args->trans);
-	if (error)
-		return error;
-
-	if (!done)
+	/*
+	 * We don't need an explicit state here to pick up where we left off. We
+	 * can figure it out using the !done return code. The actual value of
+	 * attr->xattri_dela_state may be some value reminiscent of the calling
+	 * function, but it's value is irrelevant with in the context of this
+	 * function. Once we are done here, the next state is set as needed by
+	 * the parent
+	 */
+	if (!done) {
+		dac->flags |= XFS_DAC_DEFER_FINISH;
 		return -EAGAIN;
+	}
 
-	return error;
+	args->rmtblkno = 0;
+	args->rmtblkcnt = 0;
+	return 0;
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

