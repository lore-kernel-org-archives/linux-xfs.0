Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 984CAC4320A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8578461009
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbhG0GVT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:21:19 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40318 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235616AbhG0GVQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:21:16 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6I7sw006844
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=QLvkAtUcnzjQwzFOGOIZWDToG2A2ABmKJEqTbZlPgyE=;
 b=y4gCNGxrFI8GPlKsOfAksrMAQR9Q/L0ZQq6oFAfcmv6cSpNaZTn9JRWM9SCbQrB+O4pL
 TmM4I+YNs2Djw7YeNW2cEMLIT5YekPSaUqAf1MllGqXuVTUngIvCrmVnHG/pD8ucvV2O
 cOHaZ/c877C9dLeZvQilX0xlnJRi/qZ1EbWZdo7YEJZaKk69ejur1jrWfbGqvgkODTvt
 ghghvenbiEGbfwsczxOJze2B1z9Ho6UauhgGH+bAIUFhp0QCe/et/12L5BR1kuis0j4r
 LYAHr75dn9LnobqWYh39saIbBzErXGv/cduTQK7eEzCwt1qWNdGs6ODKoCaN8OyOR8Dy +g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=QLvkAtUcnzjQwzFOGOIZWDToG2A2ABmKJEqTbZlPgyE=;
 b=OniBBaxAVqnGNY+JzCxt+Pf+YMCuOZMOxlrMr5qICKsrHXRQ8oRcvYYNbA+aLguAkNjP
 FkDa/ahynpcVvfCPlZ3F+hG92msFBpdYaiaRxleD4YgsDuAe8tRI9rYOY/Fl2F+ZsixD
 rCaKTecI/S8yH/l4fOgb3Jn4r4bJiC8tIm6p7YHwNTNfA3ogWWHVuey7iptlMxSRitJk
 KXd/x/9Dh71Ew0aYReQiNnqHPgN4GPxHL1qFy5D4FVINvfNoNot4f2frZkAM537FioIY
 V/AOViIhXAtsCaaoKpJi+fGBBOrsOHgWmlutdFsXl6M92A74JCdsOy1ePGYSDlVCw5o0 lQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2356gucw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FT1u019894
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:15 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by aserp3020.oracle.com with ESMTP id 3a2347k0as-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G5uYLIbXSso3KRZ4NOdnOMYocvzVdtivp4T4ew2WP+53L/FfffuRXxo8dAjoZNi5nHA2alIygAT0zq8ZJJ9Nb+1866be8DaAqrslAaCVNmUD4CqgUumgX7YX89DRmMebHvOiVxauxW5ga/KqJXx5i2+NTUZYE0IdExHph0k0ddUKyzzH599ixHUndAlxRvpIg5Lo9gRtzJW6q//QfaPvnKVl4OuuxS34YdJ1YMst3evTI2NjescAEQK3F9W8Z4maqoyWjI7pZKOj6GXIkeFwErN6vd8WRs74xlwrcBdT78gytFN/3pyme/Q6lQzcdYh/J+jJAcdCHKxxXAADts2s2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QLvkAtUcnzjQwzFOGOIZWDToG2A2ABmKJEqTbZlPgyE=;
 b=MdNrURgAyIR6znX8vPnwDkzcD+QdVPzT+Ccd73iKb9B5NqXDwmjDf9A/5upFATzrsAR/kvfwnAKxdKkaur6Q8Bp2eyt9IFrhvh2MhtTulNytZsTUpJ2q3nPXKjmp2/OUrS1hl/PHleZD/RPit/jFfnBJSlYSszn3EwBXyk/J4gUuet/9vAV+F9HEY3o85+B9CVCl8+DpndlmSI2DK47kyHyJx3VHv31i5mFFd3P7AIO3h15lRapMPv5JEiE9uXOObg48kz2myXVMgWX6psJl+C+xG7cI6L4g8LIyLwcVc0IK2y9ELCpwW7k/fkZw7wlrPZptLaPngVkrHvxULXWExw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QLvkAtUcnzjQwzFOGOIZWDToG2A2ABmKJEqTbZlPgyE=;
 b=EC67FPmPEGQg8m7dg6WBywB49W8g7e5a9PycG0cYFq8st372HjoTkbNfmB/Me8zKbKL2NHL9MlZF9hHwieth5HN+PTi0ZFfIXPNXOOq+4UKGyDnD/OYivb2aD+pPbLeIVui2K5MMTOH6vXgXNWkADjpGKRiuXTHcLx0gGO4cr64=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3383.namprd10.prod.outlook.com (2603:10b6:a03:15c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:21:12 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:21:12 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 11/16] xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
Date:   Mon, 26 Jul 2021 23:20:48 -0700
Message-Id: <20210727062053.11129-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727062053.11129-1-allison.henderson@oracle.com>
References: <20210727062053.11129-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0191.namprd05.prod.outlook.com
 (2603:10b6:a03:330::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0191.namprd05.prod.outlook.com (2603:10b6:a03:330::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:21:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57837e50-eac1-4e16-1c2e-08d950c6baf1
X-MS-TrafficTypeDiagnostic: BYAPR10MB3383:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3383B96E1435B15611477A0F95E99@BYAPR10MB3383.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A510Tymv8Ju41XLUujw4vBgk3aKui4xhgGlGV2LJ+egjwrSf86qmy4nnm5zWTrqvJc6r+hVfeyspOdoZ6/lrt8cseUBLNwbVibOXoBMHm+z/d1vAE/6BwtKP2KAUEbioZTcRotbt4y9HM8cTFivE/BSwaMwEWcrwXd/pISaeG4qFew1JnKCs/oAj+9PDBZ6CtK8aozBezRKj4xlaJ+cdc0GFCZv8oV8BlKdowlrkkjPyRH6UZ93ZKC5cS4o4xyReP2elBFTt1IVUjkmsNUzv86P9+ZJntmBF+jAAABckP9MmBDaBaGzckZxBZZY60mIkeANbNICa5m51OjoPfiSRd5a8pKuGrL3mBlPZd7sXELuu7x5ABvsm6Zi6hmyK1ZBIdqxycAqt1ikhEa9Z6AqwRk93u2IOWLN6sznfeZ8FnxIGkTffiSdmp1TMEtXiU/1lHmvskEtb/7D5891qP9Z8mjDnXQXqGUF9hHwLN8VwHNDJ5Fc4A0hTWr3k1prNUViNhw9Kyg3tg2SFN8IbYhGoX8EEC79IXa+5WpQs8QT2If7/YzeoyXrlJ5JhB3CA6XjbXXFi47Mko7qL88hLg4nKhjUCBB1bRfSo7JODZxn2Zc7LxiPBBvcU9ejhbb1gVqJ/OEjmirxJdmyc4wjfhKiL5MiB3wSOJXLedBbO6Rim16x4OkymqGAhT9Qk9DXOM7LG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39860400002)(136003)(346002)(44832011)(956004)(36756003)(26005)(2616005)(6512007)(6506007)(186003)(6486002)(86362001)(6666004)(2906002)(8936002)(1076003)(6916009)(66946007)(52116002)(83380400001)(66476007)(66556008)(38350700002)(38100700002)(8676002)(316002)(5660300002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aGuXTDDY4eNUBn0wMvPtR/kCRG7/KzexX7r1CWTiMCtlwL7UFO+XCtMMxBGW?=
 =?us-ascii?Q?9gjV9BDtChV+YDvO2SJi03IY4uP0a3QONBWmFDN/51PXDnw51uG6GN+BcKTe?=
 =?us-ascii?Q?x2s66aep7GVKmt59Cx2BfR1oIhVpSM/Tl2Pmbk8HCK9PQGo0JZ2vKcFnqdyn?=
 =?us-ascii?Q?bCdMVNEEyJWY24CdzlfwARoJW0/M2Hvgl0bbqFxOJR3E1YU3nyrQ31hUe9Cg?=
 =?us-ascii?Q?tojMa/AeMybuYKulGG0ZjK409A0T6rt9dEHCnDNZcc5G31fLE3WeViw93bPw?=
 =?us-ascii?Q?P73IZxWvywlMqF2vsDSEviVNiVXJyJz06EQsSYLdOHTknG2qNjs2d0iGtBfG?=
 =?us-ascii?Q?fHxeSfPGhWiIDkLJqgj6YMtGv8rduX13NkSX5oc5kxYC0KrFa4r0WQ0hrGp9?=
 =?us-ascii?Q?vabHmMJT0Ea5U4sSRQ7j739WWDQNYvyH0IwOesbeH22Tckhp0ejzm1z/spV5?=
 =?us-ascii?Q?Lle/BCXPZulV9xUAPaig0Bn2lmSpTzTlCM5oaJ0JAnETPwPoSaBR1vYig5qL?=
 =?us-ascii?Q?s3yM4Cw4+xtLZzWbEvWoLh5WfqFYp586Mq/AYVSELROeQnNJfukIs9Hx77RP?=
 =?us-ascii?Q?KHCbR2Kbn23tpXAHQi73s57WldOGuYbL88uFigav69IejvY1NvsD5Tchc9Ra?=
 =?us-ascii?Q?iQnJvzy6QWIuvnNCBz/dPVmiOrpye0ib3HD63TGMu8HmooCH6ieq4ZGar174?=
 =?us-ascii?Q?xNqN9951XnKWJ4oSUTNU1BMCfiTVA+ErDtrOmv9s7LndExlHFcMPqm7Tk8X0?=
 =?us-ascii?Q?6NzWtuXyJBa3V7cpKOF7jG4xm3HGXu4nYyeXBlHnBTZUYLF6apBtRcsVvXNF?=
 =?us-ascii?Q?/6kVyg0IOMLxLukn3TOcvQq89UdgbyP7o3AVNqETVqC/O82EkkIBb1aYS6UA?=
 =?us-ascii?Q?S2is9D7xFuZ/8b7dhmSruTOcY3ZO9DLWNoBOH55Gq2ZH7oFYFqVT68FKxe48?=
 =?us-ascii?Q?RHwHxZtJYF/fwNjewi2x58/MwoOY1OlE/1phXGMTUKOWG6g9FCZqyaWrddlY?=
 =?us-ascii?Q?2M4Wc3P7x88vKFVwkFQbzuR5R0aTk7cpazAT43VgGsElYef1GHhzhSXi4a/g?=
 =?us-ascii?Q?Ds7KNnUcmMgvCX5APVJgJAKvmagE5YF/gwEcWr4+1oiCz937pbWfZIErykGO?=
 =?us-ascii?Q?vLiskLns+YzuPeFdsRo4s+kdBskpjPF/rRh4BwEXLjAXTpsxr/z9At4fqvr4?=
 =?us-ascii?Q?A01/wZmN8ZbZAhs38XlSTJ2kEKQQ8uSH3Cf6HtPcjoeel0Z5EkS0iPUTmcyJ?=
 =?us-ascii?Q?vuH7p7HhGZ0UBjD/2+U+XcleCZx4Zoty9PjhGc8sITpfvKaxQkPsg+ao6eFv?=
 =?us-ascii?Q?67FQfMIR/iH42sJ5p+cp8fKm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57837e50-eac1-4e16-1c2e-08d950c6baf1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:21:12.1259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SqXVr9Ev15F63pj9JCPjGVr6guEZ3dEEm143qkrnTVz1ZPJ6uOa8uLHnPuYCl/bDhLkuql6aDGYBaN47e5rGyhvRerl3inI54xA6Px5bNUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3383
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270037
X-Proofpoint-ORIG-GUID: jCRn1Io6TEIeoMfj0w-2W0AOFtPwXiCO
X-Proofpoint-GUID: jCRn1Io6TEIeoMfj0w-2W0AOFtPwXiCO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

These routines set up and queue a new deferred attribute operations.
These functions are meant to be called by any routine needing to
initiate a deferred attribute operation as opposed to the existing
inline operations. New helper function xfs_attr_item_init also added.

Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 70 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_attr.h |  2 ++
 fs/xfs/xfs_log.c         | 41 ++++++++++++++++++++++++++++
 fs/xfs/xfs_log.h         |  1 +
 4 files changed, 111 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index eee219c6..c447c21 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -25,6 +25,8 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_attr_item.h"
+#include "xfs_attr.h"
+#include "xfs_log.h"
 
 /*
  * xfs_attr.c
@@ -779,13 +781,19 @@ xfs_attr_set(
 		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
+	if (xfs_hasdelattr(mp)) {
+		error = xfs_attr_use_log_assist(mp);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
 	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
-		return error;
+		goto drop_incompat;
 
 	if (args->value || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
@@ -803,9 +811,10 @@ xfs_attr_set(
 		if (error != -ENOATTR && error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_set_args(args);
+		error = xfs_attr_set_deferred(args);
 		if (error)
 			goto out_trans_cancel;
+
 		/* shortform attribute has already been committed */
 		if (!args->trans)
 			goto out_unlock;
@@ -814,7 +823,7 @@ xfs_attr_set(
 		if (error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_remove_args(args);
+		error = xfs_attr_remove_deferred(args);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -836,6 +845,9 @@ xfs_attr_set(
 	error = xfs_trans_commit(args->trans);
 out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+drop_incompat:
+	if (xfs_hasdelattr(mp))
+		xlog_drop_incompat_feat(mp->m_log);
 	return error;
 
 out_trans_cancel:
@@ -844,6 +856,58 @@ xfs_attr_set(
 	goto out_unlock;
 }
 
+STATIC int
+xfs_attr_item_init(
+	struct xfs_da_args	*args,
+	unsigned int		op_flags,	/* op flag (set or remove) */
+	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
+{
+
+	struct xfs_attr_item	*new;
+
+	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
+	new->xattri_op_flags = op_flags;
+	new->xattri_dac.da_args = args;
+
+	*attr = new;
+	return 0;
+}
+
+/* Sets an attribute for an inode as a deferred operation */
+int
+xfs_attr_set_deferred(
+	struct xfs_da_args	*args)
+{
+	struct xfs_attr_item	*new;
+	int			error = 0;
+
+	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
+/* Removes an attribute for an inode as a deferred operation */
+int
+xfs_attr_remove_deferred(
+	struct xfs_da_args	*args)
+{
+
+	struct xfs_attr_item	*new;
+	int			error;
+
+	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 463b2be..72b0ea5 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -527,5 +527,7 @@ bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+int xfs_attr_set_deferred(struct xfs_da_args *args);
+int xfs_attr_remove_deferred(struct xfs_da_args *args);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7c593d9..216de6c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3948,3 +3948,44 @@ xlog_drop_incompat_feat(
 {
 	up_read(&log->l_incompat_users);
 }
+
+/*
+ * Get permission to use log-assisted atomic exchange of file extents.
+ *
+ * Callers must not be running any transactions or hold any inode locks, and
+ * they must release the permission by calling xlog_drop_incompat_feat
+ * when they're done.
+ */
+int
+xfs_attr_use_log_assist(
+	struct xfs_mount	*mp)
+{
+	int			error = 0;
+
+	/*
+	 * Protect ourselves from an idle log clearing the logged xattrs log
+	 * incompat feature bit.
+	 */
+	xlog_use_incompat_feat(mp->m_log);
+
+	/*
+	 * If log-assisted xattrs are already enabled, the caller can use the
+	 * log assisted swap functions with the log-incompat reference we got.
+	 */
+	if (xfs_sb_version_hasdelattr(&mp->m_sb))
+		return 0;
+
+	/* Enable log-assisted xattrs. */
+	xfs_warn_once(mp,
+"EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
+
+	error = xfs_add_incompat_log_feature(mp,
+			XFS_SB_FEAT_INCOMPAT_LOG_DELATTR);
+	if (error)
+		goto drop_incompat;
+
+	return 0;
+drop_incompat:
+	xlog_drop_incompat_feat(mp->m_log);
+	return error;
+}
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index b274fb9..1e461671 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -144,5 +144,6 @@ xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
 
 void xlog_use_incompat_feat(struct xlog *log);
 void xlog_drop_incompat_feat(struct xlog *log);
+int xfs_attr_use_log_assist(struct xfs_mount *mp);
 
 #endif	/* __XFS_LOG_H__ */
-- 
2.7.4

