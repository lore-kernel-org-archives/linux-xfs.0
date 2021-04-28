Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A49BC43460
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EC33613F7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237429AbhD1IK0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 04:10:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43426 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235983AbhD1IKW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 04:10:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S8035e015717
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=axtKP2TLLLFxoRvmO7V+X/k/eb6Omt75vxkwITHZwjE=;
 b=csGOzs5vVicpyh9cMwFCLkVmg7GCe5H8U0MY+LYf7uN276ZzWxdZbixq1mn3oBnrFWo0
 odqTAhnhLg3Ldapj4FP++gdTJ1963Dfa1QpBNis4NRqcs2QsDn8sEXZmJ7Uz3Zv8p/Br
 NhLKEWTy3FvBQmAvpwoflQt3Kk73kwXvxDne2v0/2pq6yN91IM+fbwIBsXbX3GsH/Ogr
 KHUQHlFXKTWllvpZpYAbDfZlrY5aI0lOw3AhGcf7rAdjXm2XZPG+DGqCvb02fvmxG6TS
 XHkc+vTOtUmGlVqNWOihDIiHc+IJhS85dlcjQFPd5QBKKnS+9XKpuWBRJOEYWWltQR4Q Aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 385aepyxde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S80oJj196107
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:36 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2051.outbound.protection.outlook.com [104.47.45.51])
        by userp3030.oracle.com with ESMTP id 3848ey69y1-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j17uf7fz7OVMume2xdTt0YuCsBbJhGejhVbqHSPNfYEFS/5vrQk06wBEW0QkREsgwGf2XcEx8NJ60iXchmaYnOBbA/T371x4GFQKNB87utVmF/6nQRQ+cdscjRuzf79hHWlqt/3RT0uvyXtGn0fjacpV+msALKGMuVNnAH83KM/eNvyxRrRC4WKHoNq86IDMBzEimriIMh4xaP9FZ5COJOywu5bqJdpFG6+x6Gl07dwEz8S2wP66o2iS4HJWV9/JBWZMAgMsIADhOjYpG3YEcg7tcrQHun2cLxqXjsuqwcljoXxwx1gbA4nEM/uf0xZQ3P4yU2UWZpzTqQL7mVLMzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axtKP2TLLLFxoRvmO7V+X/k/eb6Omt75vxkwITHZwjE=;
 b=BQYMyGCjYLfTIaLBTcETw/zXHDkGLSSsMLlafC856ToLNfkVuyuJC8t00kXE8gY78SdAY+CCGDC9Fy/u8EJXPICMyMGUiLTuRvZ9QQQqdNWzvq9pYRJGN0F4TMsEgYNZHua7P2LTB4JymUGD4u4hjQO2Njw4eOAKh++Bs+QsKMnzGfTKl4REMr/8Rd+jPQIip9x+Ir0SCJOLEVw6fMzteEKA+HR/Q0AXNZb/KI79uI8Ak+nILZrrJe5ZBM/4mHqd9ra0SVSS+kGjhe957dnaClv394AwS9xoo/kiU/54Dfn/sgI1yO28TjIlK1BuBoI/N9J1DWrIEzflDElWnJgWAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axtKP2TLLLFxoRvmO7V+X/k/eb6Omt75vxkwITHZwjE=;
 b=aLRTZeWQda9nbFILXR1tCPLSV1JHD232AaHjFtb2xjftKGjvFz+QnQ2H+Vm6QRJ9nYQZn90IZ/ivd9Z8aTDUAzdfWEvXnZMteiZmsgFASlik78OvgruSACPO3pUvqyw/VCUdnaUJqhGKq60c6URI6YDtSFyEbl32a+xgieA6JcQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB4086.namprd10.prod.outlook.com (2603:10b6:a03:129::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 28 Apr
 2021 08:09:33 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Wed, 28 Apr 2021
 08:09:33 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v18 06/11] xfs: Add helper xfs_attr_node_addname_find_attr
Date:   Wed, 28 Apr 2021 01:09:14 -0700
Message-Id: <20210428080919.20331-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210428080919.20331-1-allison.henderson@oracle.com>
References: <20210428080919.20331-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:a03:74::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BYAPR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:74::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Wed, 28 Apr 2021 08:09:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7562622-b998-4033-b8b7-08d90a1cf4d5
X-MS-TrafficTypeDiagnostic: BYAPR10MB4086:
X-Microsoft-Antispam-PRVS: <BYAPR10MB40868B4BAF915E11D4F81D7495409@BYAPR10MB4086.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hyBjUZzaJO/6WXnpTkTt5bW8vJuDwQnvuWUNpO6WmTyq5HQzkuW7g9a0EYlxTdyPm4AjHovJ3R35bPTNlQztI84racChBS0MVdoIgmudW+8yUPNbrLb/A3h9cETjH1go0nVtM/6IcSYx1f5mfRqGB8i31YuOMQswyrV0Lytfl6Ah2gCrlmWdMiSKhgWSK3JrbBsEm1YoZsPDPlY9Fty5hskIJVzosZk+oBHupKztCuQQpPxahpTR7w1M8iO0fhOOsctk6pixsWZqazxfVSfX0ijMdrxmDLz7Ms3HCITlADhKG2KqyjzEPtKlUxNaB+FcPEkiApGVAyKZCu9earfjnZcmdu908h+JKJLLCTeUuD/Swov4cB/q0iTOjvZ78oanFgD/YN0dvBRowMIXNyZ/RQUs2DtMCeL2q++fdENSctP55O0Krfv/kVYPmovusuSiGu0zYFkM0gZ5jqvgk/4BQHKuJ/gwy0q6dUeFG6dj/XgtnVOiTvkkwV8R5YhJoRqP5JSOCCq3crww1Q23a7W6ByF699TVktRpm+2oDZN+3353IPzu7eQu5vXDVcbvKZNoCdAn7wBGlTNSYoz9ADE6g3f1LTO8pKdBgRqNwh+8EkNQDmLGRU7tCIJWDsnWKuYS6NDWWLEiK/DjCcKSb079r46mTmd0RwC8UDZTMUwFqf6cprCprx7Ez+pw3SsUG51S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(39860400002)(396003)(346002)(83380400001)(8936002)(52116002)(6506007)(66946007)(36756003)(316002)(66476007)(26005)(956004)(6916009)(6486002)(2616005)(6666004)(6512007)(8676002)(478600001)(2906002)(86362001)(1076003)(5660300002)(16526019)(66556008)(186003)(38350700002)(44832011)(38100700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Uz/A2Q6wdx0zWqpiZkgKglVWSWWxvuts9UhlbSKg8iknZTkBAq5G/NlIvDWI?=
 =?us-ascii?Q?0SiM+W+ITipBRIFsPKNkHWA0Rg4p0izp5vhxC4NRgPtZ+O0fbkHfMo6kq3jL?=
 =?us-ascii?Q?D5Kf+lUu0RosFpF2jFHxIG6SSvxy11Mu71kdtpjNPWyHvJ6voKlVXiT6Spq3?=
 =?us-ascii?Q?pPn3vw3oz+jafh2MFbslTNYEcglh2Ms/c0a50RmXfetmAtjkb8syAmxHxx3F?=
 =?us-ascii?Q?SmbqaVpsO/BsB0wgD2TRrgztffy0uYxSMTJVFmslTQkDZUH1v7gq6GPjUoRe?=
 =?us-ascii?Q?jXJ/V/OB7Uk1oV+EER8SvavJwwy67VV4ovV0jcRjX2I8QB33l+xNzVwEiP1c?=
 =?us-ascii?Q?+eXCrK5NUK+XTSdsY7Em040VZLRVeTIvgiFtt/MFx6l1sXRkbYgLOG7zV5bu?=
 =?us-ascii?Q?1Df9ReeZHzCIG0MnS8TL5wecHTG2g5qP0whXK1Q/SW8NcBi7W3+bewKvPx1j?=
 =?us-ascii?Q?VjhDnQtxMSaEoLv58S+43+B9MzZQxwMLuv3I7fofIu9HupDBrW9lFO7R7NGQ?=
 =?us-ascii?Q?21bOSbsKHbWMw4yXsMrp/9wlJ+gUkdcYlR57pyXjEKn22TSLSdN8tSBJNCzR?=
 =?us-ascii?Q?bNRmDSL9mHoj5EkdQy/JLjHbikf6TSSUEiPiPWijH30xaq6kVAhFZXYRqd/A?=
 =?us-ascii?Q?QWzImwWRLUkZeMvfIQxjcEQKTNAz106YwO0fQAb+7cP+GHupmKh2brOPBArd?=
 =?us-ascii?Q?Yvqu52LJuxi7TJAS8hXHw2uQOYRTuoaGcs//NYQ0L5N7DSn9uekx69Vm2kBn?=
 =?us-ascii?Q?7KKdEXu60HVQWm4BeBcNSNpx4LKcWKqC8ZzPQ2tIY7j+iR4/ZL3Hzq9svBDJ?=
 =?us-ascii?Q?AjomBxl40m8vm+QCJosCCdL20/m+1R8wnD9ZjOuirhgmrZY3PnwGtr3LrSQ0?=
 =?us-ascii?Q?WD8a7f4CCztlOBqOP/rV3hAjgJW6xk1H3BmPAWpubCz/yw93xGND8waBsB6W?=
 =?us-ascii?Q?BejIFdFBNu6RUctibz1sO22PaOYrcujiL5S0ZjF3Xkqxip9YLQQJezI/L+5i?=
 =?us-ascii?Q?+2/ZZRsKzsUupIRady4bJ6PZ97ubQ8mUMaMvkudgo+/SIv9dlpRmi2i7jPm4?=
 =?us-ascii?Q?KCIP+HRyZ/EA6ebw7x5DVKGj1uHWmFGglr/2na3Il0N6gNUwvccuuzr9EWYo?=
 =?us-ascii?Q?oppnkB4T42bjjNozIqQvvZRPGOJ2DrwpltK9INaPU+c/Gg9fI0Y3znPQOxfe?=
 =?us-ascii?Q?+/UAhPq5G0L5tkMP9PYFapRnntb8dgzPMAJisSNODPjLina3epPfFZpKitFD?=
 =?us-ascii?Q?UlptIt39Fq6vhTcccEA+McbYUpwWtEmXNsRUZ/SsI3EyEiO41qXhSTs0dyuf?=
 =?us-ascii?Q?UqSzqE5kVX809uczSHDgMxZx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7562622-b998-4033-b8b7-08d90a1cf4d5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 08:09:33.5323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZmT3qAxyNjvCKn63QGLMmNherTmSCiIILG2CagMAsloIDNCz824VrJZ7CL3dAY1cQeNC8jkhAWV6bthdtkG8EC8k98IjRt0rleqmLg9LCh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4086
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280054
X-Proofpoint-ORIG-GUID: kmei_Xz6tDTXnnrkI-LO1XClMjMGS7Bd
X-Proofpoint-GUID: kmei_Xz6tDTXnnrkI-LO1XClMjMGS7Bd
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104280054
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch separates the first half of xfs_attr_node_addname into a
helper function xfs_attr_node_addname_find_attr.  It also replaces the
restart goto with an EAGAIN return code driven by a loop in the calling
function.  This looks odd now, but will clean up nicly once we introduce
the state machine.  It will also enable hoisting the last state out of
xfs_attr_node_addname with out having to plumb in a "done" parameter to
know if we need to move to the next state or not.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 87 ++++++++++++++++++++++++++++++------------------
 1 file changed, 54 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 5cf2e71..8a60534 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -52,7 +52,10 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
  * Internal routines when attribute list is more than one block.
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
-STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
+				 struct xfs_da_state *state);
+STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
+				 struct xfs_da_state **state);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
@@ -287,6 +290,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_da_state     *state;
 	int			error;
 
 	/*
@@ -332,7 +336,14 @@ xfs_attr_set_args(
 			return error;
 	}
 
-	return xfs_attr_node_addname(args);
+	do {
+		error = xfs_attr_node_addname_find_attr(args, &state);
+		if (error)
+			return error;
+		error = xfs_attr_node_addname(args, state);
+	} while (error == -EAGAIN);
+
+	return error;
 }
 
 /*
@@ -896,48 +907,26 @@ xfs_attr_node_hasname(
  * External routines when attribute list size > geo->blksize
  *========================================================================*/
 
-/*
- * Add a name to a Btree-format attribute list.
- *
- * This will involve walking down the Btree, and may involve splitting
- * leaf nodes and even splitting intermediate nodes up to and including
- * the root node (a special case of an intermediate node).
- *
- * "Remote" attribute values confuse the issue and atomic rename operations
- * add a whole extra layer of confusion on top of that.
- */
 STATIC int
-xfs_attr_node_addname(
-	struct xfs_da_args	*args)
+xfs_attr_node_addname_find_attr(
+	struct xfs_da_args	*args,
+	struct xfs_da_state     **state)
 {
-	struct xfs_da_state	*state;
-	struct xfs_da_state_blk	*blk;
-	struct xfs_inode	*dp;
-	int			retval, error;
-
-	trace_xfs_attr_node_addname(args);
+	int			retval;
 
 	/*
-	 * Fill in bucket of arguments/results/context to carry around.
-	 */
-	dp = args->dp;
-restart:
-	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	error = 0;
-	retval = xfs_attr_node_hasname(args, &state);
+	retval = xfs_attr_node_hasname(args, state);
 	if (retval != -ENOATTR && retval != -EEXIST)
-		goto out;
+		goto error;
 
-	blk = &state->path.blk[ state->path.active-1 ];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
-		goto out;
+		goto error;
 	if (retval == -EEXIST) {
 		if (args->attr_flags & XATTR_CREATE)
-			goto out;
+			goto error;
 
 		trace_xfs_attr_node_replace(args);
 
@@ -955,6 +944,38 @@ xfs_attr_node_addname(
 		args->rmtvaluelen = 0;
 	}
 
+	return 0;
+error:
+	if (*state)
+		xfs_da_state_free(*state);
+	return retval;
+}
+
+/*
+ * Add a name to a Btree-format attribute list.
+ *
+ * This will involve walking down the Btree, and may involve splitting
+ * leaf nodes and even splitting intermediate nodes up to and including
+ * the root node (a special case of an intermediate node).
+ *
+ * "Remote" attribute values confuse the issue and atomic rename operations
+ * add a whole extra layer of confusion on top of that.
+ */
+STATIC int
+xfs_attr_node_addname(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	struct xfs_da_state_blk	*blk;
+	struct xfs_inode	*dp;
+	int			retval, error;
+
+	trace_xfs_attr_node_addname(args);
+
+	dp = args->dp;
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+
 	retval = xfs_attr3_leaf_add(blk->bp, state->args);
 	if (retval == -ENOSPC) {
 		if (state->path.active == 1) {
@@ -980,7 +1001,7 @@ xfs_attr_node_addname(
 			if (error)
 				goto out;
 
-			goto restart;
+			return -EAGAIN;
 		}
 
 		/*
-- 
2.7.4

