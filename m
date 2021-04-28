Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 248B5C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED95C613C5
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237401AbhD1IKa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 04:10:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35836 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236805AbhD1IKX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 04:10:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S80g6Q011000
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=lWTj+lTZidiJiPK4WClnpscjlQicWH8NOxdMwtp5Tcs=;
 b=H5s5gelTZO6AKXm1jGvSTPbLergRU8QVRc8DtvtPt0/Zhw0Lioqgu3LaxJotr4T4z/fm
 ET3DSUP24WZzIVq70n7B6LOzTF7bpd0SiB5rWLFeeF1yyKpAoX0LtLUlvwmMqWsl1E8M
 BUdHGLk8dsbOE0pH/PZMF231THePNpXXEFFF8s8JIJvXoL9+RQ44CyyvuFb1tDLU8wFH
 UAJBWs60dMCb0Y4A+G6MwVglUoyj2FnZWvk05HpP/c4HWFQ6n7lyGTxauvIeSboinWdD
 6o6XJcsH6hFHncID+DlM9TEvXE6py/ZcpKtMtRSFzYGywOCZ68ZAXJCOtLqniCI0giF3 Yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 385afsyw37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S80oJm196107
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:38 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2051.outbound.protection.outlook.com [104.47.45.51])
        by userp3030.oracle.com with ESMTP id 3848ey69y1-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jk083gHpKnwU4q7xdQtmONCM6LWApgDt54N0FBc97i4zTbDPpOd4hhDM3l4A++11SOBAHP60NiPQs0wshbgxtMtgA/JIXrEoVmnoaFZ9uHlHrumr8pzKl50yGDzrOPhI0z5pOJJCW3obFovYG/tFpyc3GPZARWn9EMEhiEPX3V8fXmGLDf7UyfrGYQiCglHggc0vF5WVGOv1k+eIutPqtcbICoJg//K/HuduwmXeOyr5/OdEdkT4yFhA1UWqmfR7b9zvaKR/tszDdGP7j0n2+HKLll1rgCnocZNf4a0RBg++r9EG+m9Lm6QuqD+biqIDFz8fsk0lGqtNWh6kFY4eTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWTj+lTZidiJiPK4WClnpscjlQicWH8NOxdMwtp5Tcs=;
 b=NVgUjOigRtw/69+GM1nsgi73Ls4jk4iE7TyMSfi+ntqFBDnBN+FwZ3DqldWkWCpgfomvmN27jXPdVBGmGeP22BMVy+h79L0Bz8vXabAqMFp+9fu6rz5idz6RBwdifWheIz2AgSTw95LNbZr3GO7UOnewQ6ylVJWHI+Tudq9myFlfDDm2g0/lcQYrraRdH5T06hXrvd8nu8VQm3y6SKKBCGtM7vezI05m9KcoColaFcsUQ8qMKzIeBx1kRnLYmnFRHUjEvdilq71ZgIBSFQnHjaepwhQuPVhsrrqmwSoqQI1C4tWI6139zudWKXS8DtXA24rMBAb6+XsRt8R9ysaC9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWTj+lTZidiJiPK4WClnpscjlQicWH8NOxdMwtp5Tcs=;
 b=fK8rObWWBOazJFmI+YnaHVR9GALguQTbI7GSEzV45W+bWHjFQ+dSq7aguuZNq+x/3eIcRMMJ7C706x42+NrzY+1Qe2MKa2UnQeCwNYLWyna8/BkkWL4QK7dnPCfWGkLkt4Kfzzef1Ifnaiff65E4gsYEv7gsW15+V6cZNAZZ5y4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB4086.namprd10.prod.outlook.com (2603:10b6:a03:129::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 28 Apr
 2021 08:09:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Wed, 28 Apr 2021
 08:09:34 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v18 09/11] xfs: Hoist node transaction handling
Date:   Wed, 28 Apr 2021 01:09:17 -0700
Message-Id: <20210428080919.20331-10-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.222.141) by BYAPR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:74::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Wed, 28 Apr 2021 08:09:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad1a4845-c852-4d9c-d730-08d90a1cf5a0
X-MS-TrafficTypeDiagnostic: BYAPR10MB4086:
X-Microsoft-Antispam-PRVS: <BYAPR10MB4086736AB8E7F5B648083C0995409@BYAPR10MB4086.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: heOdfnXS78xKtqfSxQ4MFZlr6M8OwhdBa8IhgVznXkk/xRPuClF/TXvMQcpP4vk5kwlz358WKLJyXWvleqiEcdH0DbiY04q6UPBoxk/LUkchjPvSrzxhoaFlVwR/oNkdkDQX+OjYkyCCiPoY1h/diD6pgu31nKvDUd7sItOqGfc6q6p5NdS/MjqiDK0ljLbXB9n/c6qeqZtRGOm/WN3y29/x+XKDMjk1g5P+w/25nCRzEuX48/fzmD2yP1nrd3K0GOb9JCNBf3o+p54bBqGnx2VLvDS8La0ssPA3hjt6ED2NQk8loVXHE7UWMKnF5GdJrMmkYkl+5h81kLbejnLmy3xCPmMu1ZWwsOTar5jr5xKs/uIdnYZfhIAN6nLfXDFLXNi1e5ZqrVBVHFRTT44wAbq/u26J3FWjdYKs5CqLoNJlgQ0LEbyduL6NI8R/+W/f0YhJXxS8BOTw02aJejx2GOTd5b0Ef0prNhotMBKM3/6OeUmZCzv95ztydA4iWkpApESyWaiDXbQXrMSK5H9PUy0kvOftfsXJeyYpv54jg++EI4QjjB4Ou2haKb+aI5YqdctMKp0GFJgo50mIdoQJWuKRoAEiYnYYB8ocz6qF4f0WBYm/vhMZqG++v4je87e8QcrAys++MJR9w9ODMWwAj51IMdJEjrjpeOq85KKfd9Ae5ol1WHptxBDQgU97vSnB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(39860400002)(396003)(346002)(83380400001)(8936002)(52116002)(6506007)(66946007)(36756003)(316002)(66476007)(26005)(956004)(6916009)(6486002)(2616005)(6666004)(6512007)(8676002)(478600001)(2906002)(86362001)(1076003)(5660300002)(16526019)(66556008)(186003)(38350700002)(44832011)(38100700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?h6B9iDds/hDnOPEZ9X2g9wE8lrUFoVnIkZZb4o62NGKREmB/WfmGxZCmFkVd?=
 =?us-ascii?Q?FQAus62psoD2fMCJmOxjFGeUna3o6sxexKaSpNJ44YlI90zkwiHEzt79/7ub?=
 =?us-ascii?Q?AJrfnsUDXb+lKmH3v6HT79mF2rfJfxLK51KOAmxNzdhpa1fUV4q0vf5bIu4i?=
 =?us-ascii?Q?AuSgqbgEG7wIeQMdWgzIJ4jKMbiVENHyMrPeoVjpOUOyok601dHZKcwGdDPw?=
 =?us-ascii?Q?uoXaC/pKLl2d2t/L1cSKIm4VDmDIxBuue1SF4nDl/DJp5kaTpc1XA7Rq4WYt?=
 =?us-ascii?Q?vqPXWpH0fbUYcM+W7o7dj5z+AEy21kfgWbgZRMeKbRVZe1CW6OTS2VnwrZMK?=
 =?us-ascii?Q?KEU5Ge/LXdqk/slK6TPgVymhz3/bbA8io1vIx37Ku3vmnPu8fOwyP1WZsQXh?=
 =?us-ascii?Q?gopljkukxsIiQIB9sCBhoTxtEJ9dwWL8/ZWWnMtS737o/LnK4qZNwUJ79qbw?=
 =?us-ascii?Q?PuUfpgLAwdOiw+lDOGSe6FzbqXkyxQc+z0c5YdgDH+LWDWJGT9RNEqPwr7gj?=
 =?us-ascii?Q?hf2w6rJRvK1vhUmlNNAHgGkb1ELS8i3BQ7nclKHYVcXXlrX4Fp1+uA34fKXr?=
 =?us-ascii?Q?RapsW7k3UqSx+zvnI9UScGwfQ0zPMfIh+qDUxIO8C49FWdjXIos+S7ahfJFg?=
 =?us-ascii?Q?4Ewn7VpiGgCig2Fk/m5xNijGkjLAqr7WK+LmDnQiXxJ2bfmD6+K2AMMYRDQv?=
 =?us-ascii?Q?wsex7pcFZ30maD/U556OVEkiR1m6IuSQ6w1hv7cm70WZZmNLZ4y+H7OS05Fk?=
 =?us-ascii?Q?YeIjvXM3PvYC6f3twUC32q4JinVyvhWRHxYOH/6YG+GQ4f+wAMfF0sFGBoxX?=
 =?us-ascii?Q?RCjLzDySAJTYS3ZzbiXb30FRXphHMLeb+Tx+kwhCUb6ys5l4Rtn1JKO2UKCg?=
 =?us-ascii?Q?ExdpeXkW7g0R/pHIvtMgtcnDIX0ECcZEjA38kNlgmgxpYbWWCcn3VgXkdbaE?=
 =?us-ascii?Q?CmLzi6LOBqxRo8qguf/Woks7PTdyOHzXoxa0MOaA4VKgGUvlOP7sAHxL4OAF?=
 =?us-ascii?Q?5J+TogNtOwALZ2qGqsSZU2Z4gS4160iW3zizQMlEd5sAWop4CpzfElqtWRt3?=
 =?us-ascii?Q?M/xd4tTFV4UlIBfdeu/gNs3nEvn170H2XnotBYGgTW/BqSFSvRzmFZF98xHF?=
 =?us-ascii?Q?u2Qg6y+3akKYIj/7PsxyVqgv+9yA07vU4vAmHD7uEH3hJ8H5wIJQ78u63Z1t?=
 =?us-ascii?Q?B+UkpR+dBafYjkbIQCvGjgkshYW//DOLyg7VJJw8GkoZEOSNB81O8U9lUVef?=
 =?us-ascii?Q?XELpzr1dZOj5riVt88jdPrBIk4Zl5YqsgP2mbur9KKalZef79oWRYa5kWYIv?=
 =?us-ascii?Q?rmzeroT03tsKlGIb7EuCaVF4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad1a4845-c852-4d9c-d730-08d90a1cf5a0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 08:09:34.7987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dpyymyI7rtYJ6ZBkVdxKpBXGXsqigEhKzKTyV7rokH6geRgrW/1w7F64mxQpl3O/8KxcCMdjpXMyLYpb9zEHOCSpTqD6Zb4j61IG4AJiOro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4086
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280054
X-Proofpoint-GUID: uF9u-0-vUAAyr1y5nxcyP_gHeIOnMXXt
X-Proofpoint-ORIG-GUID: uF9u-0-vUAAyr1y5nxcyP_gHeIOnMXXt
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104280054
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch basically hoists the node transaction handling around the
leaf code we just hoisted.  This will helps setup this area for the
state machine since the goto is easily replaced with a state since it
ends with a transaction roll.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 55 +++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 6edc3db..21f862e 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -309,10 +309,36 @@ xfs_attr_set_args(
 
 	if (xfs_attr_is_leaf(dp)) {
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
-		else if (error)
+		} else if (error) {
 			return error;
+		}
 
 		/*
 		 * Commit the transaction that added the attr name so that
@@ -402,32 +428,9 @@ xfs_attr_set_args(
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

