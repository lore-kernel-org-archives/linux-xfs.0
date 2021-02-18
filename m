Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 910C7C43219
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 603A864EB9
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbhBRSsR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:48:17 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53640 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234035AbhBRQzV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:55:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGn3nI185407
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=g3h35iPdn6wcTjoeIvuF3jV92mAfDJtAPid4Tjrfga8=;
 b=VDl3L3iuScGnt2DxpRABMu0D5TyunT5dP+3vTMhx+qMxzj6hlQVnpYHLUn7MwAVl0TD7
 As1Fd+3P3eek0gJRt9p+nDsiBsxwur/W8zGEA1aONl0Og9QcL/mvbS/XOoddf1HdjJc3
 29vJ73vda+jLoGy4eDvK9Ghk65Q5of691Dzo4gnhfxPxYx627Z1oLrD1pslyyFE8qsND
 oWHpzgd7jHo3pVLONNZg2IwH7O98Vu/NJ3GEZo8SCdpwj+4TIZWP86z7Gp7syzkrGplG
 OleXcoT0xh2zAKrGKJ72JxDD3giigdEmVvWviOOj9W0dKUdp+i7oUEtJUkukwZsoqG/G PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36p66r6n91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGng2t162351
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3020.oracle.com with ESMTP id 36prhufdmr-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ifMggNjSuHGOvV8aCu5RgBUlgTZfANgVDtvNuhjmGS/gYLuQMlr7pO7qfXDvHwNBHt/VDK7xNM5kds45WMahPaYkJAdKAtaDHAUIWyT5Y/gb5iIr2swY0hW4OKfeuh036dd+8IgN7FT+QPL6AMtQehTYcQcdu+QTgX4auvPFnlQn6vit+8UT/5YF3Wcqad8B/ZgQdlUShxvUyJxPry2366WGpJBR76O1Xw6ZdHWxPK0tYkGoRjRziJBaA4yroAy3b8rici41H78r8LfuYbj8vxAEVkHCpbPXT1VYRWM49WQkGbQpnlYwuojgUHQkx7smQHwfFwHJ9b80RvLF1cR7Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3h35iPdn6wcTjoeIvuF3jV92mAfDJtAPid4Tjrfga8=;
 b=PjUzinKjTaKpPkplaJqWG77iyfVP7nEsiPHJ+GVK6oXbxe4pIqvm8TGsXBi1FjaWq9cF89kzeon71DtYR9PiMVRra4WZQ2hW9X+f3aT1ehYSjW4x775EFbbQD51xodb0jyX8WBcDLQub+T4evEz14fllriPkbwQ0dw/lNqezP6a21qw1mx7v2YcokKNwlhn72QqRLfzzkHOQh4oY/edLGQXoJSU3fiwiWeJB8g2lEjSmDQyUgeHXI6ccBltXPAZ7vg1/qGcSrl7Q7lO+jfr2ZqLQXy5Xb3mbB3zWiNGY0c1DBRbz2MwhplrLXr+PyYPxSfbW/s+xM2TFmVp3jxfBcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3h35iPdn6wcTjoeIvuF3jV92mAfDJtAPid4Tjrfga8=;
 b=jKCRLHxK+AJwGqsWzqjzN0QbR52mo14q3CZDifMUnJxIa1FuuB+Ew5tNKIMUOtf4L+mwg5yqoGBfLL+zBdmYfupl2q6YP3dE4PC/zT8TYuwHCNJIveMp+hO1itWk+9F37wsH8vIeRo7UtHQ3MxKX79q3lzB3u+JMCLzvpV0liB4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3381.namprd10.prod.outlook.com (2603:10b6:a03:15b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:54:09 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:09 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 14/22] xfs: Rename __xfs_attr_rmtval_remove
Date:   Thu, 18 Feb 2021 09:53:40 -0700
Message-Id: <20210218165348.4754-15-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dda8f19-adde-48bb-258e-08d8d42dcfa6
X-MS-TrafficTypeDiagnostic: BYAPR10MB3381:
X-Microsoft-Antispam-PRVS: <BYAPR10MB33816CC15F2C187E0A9506A495859@BYAPR10MB3381.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cDp0grS0cmHL0lj+hmOeH4hDxHmSVCn0xZZ/VQtT50XKCkautAi/whUoiamLL6/gLh6hvuAkuRaIwU4sgmmvXOozFpwYpp+sfajaRCXTAYaMQUVhsNhtlZAaCUifkVo2dRXwGkO05t+gxoLZqqdGcjeKyAvBSOck1HI8A7UlU3YApmtlJ/3benYKMQAXXNvAWqbDvA/gFsUA8SuTWL00vPuSn2ZVhzSdbUOEfpdge3/RLoA/ySbfP37n9xmshsUpuGnvdemKbZRYhr8rHRBLLhMKNVSelCYcPhQSxnzyShRfCSBFyeNEJwuUImXn2i2tKP+6rESeMVK67UkYNjGBNGREhbPmT1pe4VAIozuZxsCP3vQ13Tcg0/cFbtEACMV15KiuZ+pOFYiF9PndrZO4yuzL/B4z7wD6uKfGvs95k4XlMf/XpKQWMWOP7IVGuM1Jidm+qgdU9BBQRpoQGc69m7z4W/PMpnUMWZB69vYCYk+D4RLBvefxf3oz0Ckaht4kiDbmqu9V6LwtvAPhE3uB5SULSJidjumSCDP1Ocg5v3HxKdHgbChPIfNg+pqVqHqfrSgWMboexaR6PZ23FWnlKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(136003)(346002)(396003)(186003)(26005)(1076003)(16526019)(66556008)(8936002)(69590400012)(36756003)(6512007)(66946007)(6916009)(6666004)(86362001)(478600001)(52116002)(5660300002)(66476007)(8676002)(2616005)(2906002)(83380400001)(316002)(956004)(6506007)(44832011)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KpE5ZNV2vCnEgdlmLiuhMDoN4I56SbvN9xj1mR7gY7HGVTwf+v9Ti9hRZ37H?=
 =?us-ascii?Q?JcTBfUUsbiJU3wmqtL6za1rVIljIxhKUoh26kjMrdC3v4P2zIgTMct73F89m?=
 =?us-ascii?Q?bECId6g89+BVSBpi9v5tHeVIkkI9xOoZwBFFkIVxTDRS+ir7t5YWsVaj3DbC?=
 =?us-ascii?Q?LLiryyZCEQuJR0eXZ6wrVbIh5gJQSI2Pi/x1mKeDXdV+R2jeYUAOaX3xiRic?=
 =?us-ascii?Q?x7niPd3YOEgRUGaKIB56N1agvstVfleYKoFxKeYAyH7ncKX+FTVq9itbtbgS?=
 =?us-ascii?Q?vJNEXIUlUsbtAtK+tozpxUOK8opxx2UN0GgJ8zF/aPaHTH1Tp7YoFgTDaeIM?=
 =?us-ascii?Q?jyGKsA/2kaQSGeRSqfWkgalDOrK6xnODIrdacRKrJjjNQt15zJbUG6ItcQ8G?=
 =?us-ascii?Q?+d/reRrtdFGJEuiWcFpdeC7ByEv5EdHqbNW0eQdaYwj/qojze5w8TIZN72yr?=
 =?us-ascii?Q?hIUoiAuo/UyMWNRN8swaPNnwhEn8Q12C2dzw07mRsuCb8t+t01j6Km01NubQ?=
 =?us-ascii?Q?2gB7Gfno5+h4HWx20behZ8Vb9NF2sEi5eVP2c2ijSiqSCgAWERbE3wtqSije?=
 =?us-ascii?Q?fnj1ZpDbJtbXUzEN4VjhdWDJstL3d5KSRVLFNAi8lq3qe0o7iAJ19Ji44i7I?=
 =?us-ascii?Q?PsL5NFVIyyX660jLccDFRUNqhwq6u67DZhSpJ9DS9IbLCu+DQyKYotmbdjTb?=
 =?us-ascii?Q?wdVP31xxbCudF4XoObo7iI8/nW1/VwHqqyJILC35LHVsDwqTm6G0p/N2bOWf?=
 =?us-ascii?Q?MHtYG2DMUnDx87Kb6zuqadRQZPKm6ol+NyOtyFGjsZENoIKEcYFvqFwtvwx3?=
 =?us-ascii?Q?kyMkOc8XS2uOVMQBUpzYJZWOWWEop72eSt1qhHD2vceY4fj3KMymTLuTEzhs?=
 =?us-ascii?Q?L/eh+KTzXRzgNK1uamIh/PhKFEhxJRNF+aPBWjSfs+foEpuKA5kKL1q3itsy?=
 =?us-ascii?Q?ambR4HDUXTg4Q6IoOvK+Rp/JleSectOJzKXVO7+6qFipCE6IsAM8n6mh3W3O?=
 =?us-ascii?Q?ImdMc0XSAKUSc8EH6rwJHsr+bT/r77XG97tWvR/lB3kbyh7AfNDX8Tz7m2sQ?=
 =?us-ascii?Q?VvGcSQs71+dEB+qgcaCCy9zUlXBUYG8dakTXTjd54rCh3ouVIiyOhuK9pxOq?=
 =?us-ascii?Q?6fxKviaIX72gGfjBN4+zRV9ieJrgVikKcnlZaSO66ri8YCjESfLCQyFbWZVZ?=
 =?us-ascii?Q?l6qT+utRUaqpTuAFsGyqbbroYGUQfT4LWdW/LelXtvdziKjBU8T01mxBZY4N?=
 =?us-ascii?Q?Y973r+uk7UMIWvokwvB3x1vXhSR1LGp2r/vijsCi/w7cEYLPC4mamb+tdNWQ?=
 =?us-ascii?Q?EpoJCeEFi8dTnGdEQMwSrgZD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dda8f19-adde-48bb-258e-08d8d42dcfa6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:09.6319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Ia1wmyv26kcJhD34YCZHY7DpsrczEnHs/4xaBAO0zbwooqvmA9TuC9Ci9I4jc37hmWPQ7tdT6KPloyEGQHMRZn3/tXCkevum/lGiAu0uuc=
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

Now that xfs_attr_rmtval_remove is gone, rename __xfs_attr_rmtval_remove
to xfs_attr_rmtval_remove

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 6 +++---
 fs/xfs/libxfs/xfs_attr_remote.c | 2 +-
 fs/xfs/libxfs/xfs_attr_remote.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ba21475..2b8e481 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -496,7 +496,7 @@ xfs_attr_set_iter(
 		/* fallthrough */
 	case XFS_DAS_RM_LBLK:
 		if (args->rmtblkno) {
-			error = __xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(dac);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
@@ -615,7 +615,7 @@ xfs_attr_set_iter(
 		/* fallthrough */
 	case XFS_DAS_RM_NBLK:
 		if (args->rmtblkno) {
-			error = __xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(dac);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
@@ -1414,7 +1414,7 @@ xfs_attr_node_remove_rmt (
 	/*
 	 * May return -EAGAIN to request that the caller recall this function
 	 */
-	error = __xfs_attr_rmtval_remove(dac);
+	error = xfs_attr_rmtval_remove(dac);
 	if (error == -EAGAIN)
 		trace_xfs_attr_node_remove_rmt_return(dac->dela_state,
 						      dac->da_args->dp);
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index b242e1a..b6554a3 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -737,7 +737,7 @@ xfs_attr_rmtval_invalidate(
  * transaction and re-call the function
  */
 int
-__xfs_attr_rmtval_remove(
+xfs_attr_rmtval_remove(
 	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args		*args = dac->da_args;
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 8ad68d5..6ae91af 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -13,7 +13,7 @@ int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
 int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
-- 
2.7.4

