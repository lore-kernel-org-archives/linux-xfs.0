Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD27FC432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9EAD61009
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbhG0GVU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:21:20 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:41572 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235687AbhG0GVR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:21:17 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6HBxn010840
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=xPuGCOaWQnHiTm/jEZNPedCKUc8yraDazP1GcvaTR/Q=;
 b=RNk8P15TezRiGaHSZnGIOZls3UQaYOX8S5rMuN5nVUYFSTKpvvkuztwtMduaTuc/TtsL
 +hPVv0n2DIR0zxrFKabccqSlGW57+DANW7jloi+W6Hmyweyg5n6xk/OdF5a63rVIzx3d
 E99sWbpaRWqVF5k0h13g2yrPbQ7QIyh9YBmWlc51fuVL7LHS3aipLTbhflr/2V1gmjv0
 YRN5szfz26/8RLwnQIrsrSmlH9rOnjist/jWEgUJhCGRjPCpGtNnt3cInVNnKs8BmTEe
 7k/wYZ8wV9UJEBUbpCxgHMJvKbFtcEPTpYfhWM1KaxHOTHLdOlPwOWxaybJ+3PqtUBHn MA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=xPuGCOaWQnHiTm/jEZNPedCKUc8yraDazP1GcvaTR/Q=;
 b=XfGRgc1Gp4rzLAuAgVwwmcr+YtMxCvwzkS1hzYWdj9hhj/5Y6VHJrmQ9EQEh+YGDQ/7s
 UMDsrGir1efWLLFfQblfDxhpT2rJtL8HmlfWc1+HFmH5Pq6dVXgGQIvdP8EIpjJ3dczK
 YknwkIS9BBaaprKtxv5BoPqhosAWIlCWdMGlz9JGn8jogNZXIw886cb5UYWp0HPo/l0q
 +QHK9sF36RCrTG8HZrx3bRc7OfTMIInWbF5npFNVE/budv5VmZBcCAGIbzHt/IfWG8Ed
 jGClftV0M/55KLhChb/IyLlAqXbCatOStz/6OFjDtpwBPXY89TnHHa/Ucyx1r+W7atki BA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234w0v9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FT1x019894
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:16 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by aserp3020.oracle.com with ESMTP id 3a2347k0as-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REhC/QoIE1kFbRtch7RMs/1/MAdp2NLrLWDFdTg4aevSI+52Lmn0RYF55S+0iKBY+KUsUJq9bu+1KRk19g9+st0lbc4bt08no2fuuxTYinf0Oq1ExpRqcCxnF9MtTsUyT4SfM754Zw6MiQzK2RSqDWoWRJuNtRyvoogQ9RTzwwTTcaX661b2Sqz6RXEvNbrnT9s8eJyy4NxVm+bW/PrBpeqTu1lcF0657UwQ05BYCDt7AJ3QKaiPlRTeSqNEzh2mw9ZvtmEri0cD/5cohmJz61rLVTE78n8aNbs0MkGb+1uiru4n8btobu5Cew6hWZX8+2JFxNZzpz2tUeunFBMBeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xPuGCOaWQnHiTm/jEZNPedCKUc8yraDazP1GcvaTR/Q=;
 b=jKfCkyb9rZieADAF83YmLzKHiatOp5qgVkcdp30vdWqRUuegRb9DH5ELaEYZaLqP4i5yzERpqIteKPCeT5KwL28xyct75aTECrSMg84Bvhvz2L+d8QvhIM9iFiMTYcNE/kyfdYyDXBg1/C8LmXDWlMkQrvkB5Pqn7DYHG79nVTbHTsye1iQSma7+Wu0MbiBA+Qx2iVfgHby1vPy7f/9c8g1ZtUsR1xB1A09a5UdWUwJeGvwqWXy0Yih6xOspgcmoNSjRkqtsJwBhWrfXWyvWu/weQvee6dMLNrzrykEeIWn3j1Xwk7ZjhyD0lUgCfCtkXSAaTYFdAUGsnqY+sTI6DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xPuGCOaWQnHiTm/jEZNPedCKUc8yraDazP1GcvaTR/Q=;
 b=O/bSY04N5p5BwXqToD3D8lekGMQOaOdJLyXANwetLwSv2LHs/d/H55c7MRZhw/g3Llpt+U6Cxav1F0h6+uNZZousPdyWQOiCIWlPK48V/dDPQF2bfMG4piZ3TVxqcJUpxb62l4buK3MialcxIXPz+BWpiXgLGajB9p4iTXPmsIQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3383.namprd10.prod.outlook.com (2603:10b6:a03:15c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:21:13 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:21:13 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 13/16] xfs: Add delayed attributes error tag
Date:   Mon, 26 Jul 2021 23:20:50 -0700
Message-Id: <20210727062053.11129-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727062053.11129-1-allison.henderson@oracle.com>
References: <20210727062053.11129-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0191.namprd05.prod.outlook.com
 (2603:10b6:a03:330::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0191.namprd05.prod.outlook.com (2603:10b6:a03:330::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:21:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2104a80-b6d8-43b8-034f-08d950c6bb60
X-MS-TrafficTypeDiagnostic: BYAPR10MB3383:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3383AB2CE428A9B8364FD36095E99@BYAPR10MB3383.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KQdejxoTdx4SS0AYtfd4uEA4wwmcm1oZOiBChFnKC/8gH9ARJvk3n+1gBfJaCg5RSO1s9NHC9prjVrqHe0q+aalBVwxRzeotIklo4YYA540+fH3vYQ2OR0/so54b/PKtTol6tltGSjZyBVslJmI/tYAnTekN8TfzJBUWU8/CxFjESJ2sRAbDTQ9PRm+78c/q6ZTB4jfbSy/ZDVMUuXev4dR9L0g8hk5KvOBL7WqWb5/f/wMcVRdlMbx1lkil8qfLlxq600f3JtEI36bSD59zBM80f8njiA3BqOEzdcf9pJlB/kfQjpqrfDhGI4LrcCrDAKvmUBgHGXj08Yr+1cmtFB5C8z/aHH5yCLo3BuUnnHcjRa7vT7sc++t5b55ZBykxWS2l4eVOTdfitFDo1AisZNiSQaNcxm+f0NWUXPkY+QL2W+EubXCrmtXsPQbJ95BC/vkO3xdOFSokVa6A980rZzOy05qk4zieY2wqeTD9PUcrOJEdUy8cZkeNGFBx0XtcpLUhnG7s+dbs5rX3AfJgvmKBEyHJWaRnj3VX8BY0d8RsaD05bwI+iNNnbeXZTziA1zOvF2YXsxYZzZebbJUTqg/u2IRzEVvv+3oZnoit8BST4UbbamBasD2wSoIb5GR2bDwGOja+OKnFowaknOSu25KKpto7arAFIx+U1yoeMM4pbJl/C2Rwewwp9Xhm+7U/JN4nnwDLGd1zSogA6P0nKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39860400002)(136003)(346002)(44832011)(956004)(36756003)(26005)(2616005)(6512007)(6506007)(186003)(6486002)(86362001)(6666004)(2906002)(8936002)(1076003)(6916009)(66946007)(52116002)(83380400001)(66476007)(66556008)(38350700002)(38100700002)(8676002)(316002)(5660300002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TJAFhi/BAOYxY9lf+S4zAgE8Lz95KDlyOO6n0wr6b8p4MkY79BbEfltLgLvA?=
 =?us-ascii?Q?3LXvwZtOcffZU7ap1Oe6W8UCwecYbyAQQEzIgHhRsGrSJFmiewleKuv+mBA4?=
 =?us-ascii?Q?m3jyY5pgunkCJ9+9u65UD00bOKYlq2uPyoizl1E0ulxG02PIn1DbIzU0WtDo?=
 =?us-ascii?Q?gEwh3WM5iE46Hez57xH8hwrg5HigmBOSE7fdWvOUPV4VcO87FI+50LBVMelw?=
 =?us-ascii?Q?TW4hh1gg/3arHkrhiZUTYMzbMgkLWa1hd6og93NvzsydfmSWS2sGNvFxcdJw?=
 =?us-ascii?Q?3eT/0CIdSt/uHsdpmlR29gkJcBfJG0r89q4/NuvbQ/P3G0TawL2FBMJ+5kI+?=
 =?us-ascii?Q?x0Q3Oj6CknMEPkEYcCfc7JpPzhEn23Vj62i5X0HKBTCWvINZLNr9noUz+aUE?=
 =?us-ascii?Q?c1Y6ioguMdBOFxG0nILQOdUli90cWdFuyS8XrZfIcs72a/M15B6E0pHp2MHT?=
 =?us-ascii?Q?zFn0wSge13qA2Zb3t8AJJBdZ01UiwAMzYDbOltR9VxyZN7VqvcuSKhevqbuI?=
 =?us-ascii?Q?5LYV4IWKqPBxk9hl6gL1Zlwbmv9xFoPPNAZX0wvjXd7jwDMwueLbk19WYeh6?=
 =?us-ascii?Q?Iuh22PlL7klNAJ+qsoSXDzNBcNZRxrW7CcUoJz2jQ7MpHn+KBxgvrCKJ+ItY?=
 =?us-ascii?Q?ky2lM0bI28pVt7Qcuckb+QM+kfdl2MaHFz+iL0/r1fbKjdHg1QCNz3ZT87Oo?=
 =?us-ascii?Q?+2lNe058jGMvfH9G4iJIYpC/Z0Vd1cR3pRtPjpvNpv5UGkLwsjO8iI8c3zyp?=
 =?us-ascii?Q?ANpZtEG837v5cy2STl1YDxPPTZ0ZhYo+SOkmmAEIw482eDACA7BX2xXJVFtC?=
 =?us-ascii?Q?U3dH3hbgM/MNfEnpkbMeyfr/eadA55hLFNEcB8hSyGsQydoLqv2ILN3aghrn?=
 =?us-ascii?Q?X8QQz4i9IZkM3r7/Kvw0w2T/H5MMX7PwN2F1UijUKVHK1PL1FINw7dAIpx9t?=
 =?us-ascii?Q?ix1y/CwghZdp+VZkk01PV6BRir6F3Lry4eMmpWQrzkOCcVUP11mbwuIgyA2b?=
 =?us-ascii?Q?er1Fjjn22xZnD9Nc5B0an8Bujj1I55HmeFyhNxmzPYJPnl0Y6rsBJKE+kb66?=
 =?us-ascii?Q?QzpAKezBSifjxKcZpAdrWRWysFgusqv3rnNZMNoRj9qh8yVxr054Za3Z1amg?=
 =?us-ascii?Q?+GwAj9v4HKsZCJbcjS03WeVy+w+7XbFWUAXTyj5QaOSTrOewDAlp+6bOJvLI?=
 =?us-ascii?Q?U90poOXfx6H67KMQNfBnKuL4Z1OmsRwR8R3E1mXB7nSiJU5yhPaRo+bGoz7F?=
 =?us-ascii?Q?ZBXoR7ojs9SC9PrqMhArJhWXm/c+T68dvBuHO6qOF8+E7D7BknSD+zxBk103?=
 =?us-ascii?Q?SJ4URqzz3ZfHHcyU+BxnZHVC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2104a80-b6d8-43b8-034f-08d950c6bb60
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:21:12.8527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3I5S01b3O9Cm80MnXfs6s/exQ03lHovacz7mhX72YWacKzVjdz+lER0Xq21qopy1XJtMWylYjEia2Lmj3nNurV+hMNcQXSqTlVfeKtUgXFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3383
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270037
X-Proofpoint-ORIG-GUID: zP2mqW66Mtqf2dPz8WcwKJ9Cmom_zl7p
X-Proofpoint-GUID: zP2mqW66Mtqf2dPz8WcwKJ9Cmom_zl7p
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds an error tag that we can use to test delayed attribute
recovery and replay

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_attr_item.c       | 7 +++++++
 fs/xfs/xfs_error.c           | 3 +++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index a23a52e..46f359c 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -59,7 +59,8 @@
 #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
 #define XFS_ERRTAG_AG_RESV_FAIL				38
-#define XFS_ERRTAG_MAX					39
+#define XFS_ERRTAG_DELAYED_ATTR				39
+#define XFS_ERRTAG_MAX					40
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -103,5 +104,6 @@
 #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 #define XFS_RANDOM_AG_RESV_FAIL				1
+#define XFS_RANDOM_DELAYED_ATTR				1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 12a0151..2efd94f 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -34,6 +34,7 @@
 #include "xfs_inode.h"
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
+#include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
@@ -296,6 +297,11 @@ xfs_trans_attr_finish_update(
 	if (error)
 		return error;
 
+	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_DELAYED_ATTR)) {
+		error = -EIO;
+		goto out;
+	}
+
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		args->op_flags |= XFS_DA_OP_ADDNAME;
@@ -310,6 +316,7 @@ xfs_trans_attr_finish_update(
 		break;
 	}
 
+out:
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index ce3bc1b..eca5e34 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -57,6 +57,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
 	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
 	XFS_RANDOM_AG_RESV_FAIL,
+	XFS_RANDOM_DELAYED_ATTR,
 };
 
 struct xfs_errortag_attr {
@@ -170,6 +171,7 @@ XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
 XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
 XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
+XFS_ERRORTAG_ATTR_RW(delayed_attr,	XFS_ERRTAG_DELAYED_ATTR);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -211,6 +213,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
 	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
+	XFS_ERRORTAG_ATTR_LIST(delayed_attr),
 	NULL,
 };
 
-- 
2.7.4

