Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1774DC43460
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E93916117A
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239551AbhDPJV2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:21:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36514 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241632AbhDPJV0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:21:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99OJu026197
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=0iE6QbqYZW2QHqj+u5esWOrkpy630dIALmY1ovxzaWs=;
 b=wrgp67dwcXXubApMVLXgXbqnyGlxW9DOEyMtDwXS//ZI9lFvxzYV1hEkgIOI+LEKpLiH
 HKEGFM/1gdLYtbAzwJ/zK3cpaV/lJ+gBaTlg+GTFPuiUInNTTxccG+180YsLVyXppaaV
 VX3ZW8UVWBgUwkulmBlCTQS66kbpwKClAGiY00kPpKEVxdpoWGnvR9E7oNWFFbuiFHpg
 gTH1U6FtqS6b4IzyGAnxvEGCgHK6f2cWFUfzVWPgIWCPm3CBdgsaPLIIiglshc6szvii
 uS47JUCw8/83AjN4tp7A5gvn//PmKAoqCVnjIvOl5ni0fS+az0BW+cR9jafKnPeK30yu Ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37u4nnrhej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9AXSx077147
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:01 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3030.oracle.com with ESMTP id 37uny2cegt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afBveZRqDx7WMA2lWXpFjlzvc0b2ouINubi0X7IOItTv8k+fCXqcNJ+zUiEmXnqtlDfk021W3KwEJvqoAHO/K6vQXGf/UBvbWbfFtbFX/r8sZI27tOCihg+5yG0EREFbDiZhjJNjbl+ifMYJL8VzDeNKn7H5IcsqED1Gf2+qr65WfxQyI7onqQhVLz7H0VlyGie1RgW76dHVEOXR2QrfC6tan3o1A9NYakh8qStioYVOtjDtHAhssGZq1sDpXA2jGb3IB/XYNBRUJGBs+2o1Phn18WRAzil5DjFUrsk0qaSyoKcu9d2ntLvIFHsEEIk72s3GnfN3CsNxJFxw+62JFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0iE6QbqYZW2QHqj+u5esWOrkpy630dIALmY1ovxzaWs=;
 b=nWphVCdf5NbWdBx+/L/IcMQJMDFe/xxLJ3y2eqLiSU2c4UqJQ+gR8tAb4QgBuHfdwqgbshikX83LFGulICpE2XIVsPBM67RnCgJ+qUHXOitWzbWSBf3RKtenqpUnwBnjzJ4jxJ3nRWM/gavaJndvGnPPn7OVvsN+Qg3tdEVugJ1WSCm/xLM74Q732zavKzTsupBohfr0vitfpW5TUixLwlBP7hWVS/XdCAHQon9QF6j+4pr3of4C2F5JPsOGCM/bEhv+IIupY7W1K9mg7Yr7K07nLHjhi0Lnb9hLgrZ7y4iNKsc3lD714d3h5NckQ6Or+I/orhcEyuDnnzzIj62W/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0iE6QbqYZW2QHqj+u5esWOrkpy630dIALmY1ovxzaWs=;
 b=ZcIOt032io2WTtsmg3ykzIiGWZqUYIQPI0qfJkO2JfQNHDes00Cma9t3M0kyw6nNSRGH5TRAb6WRSTwqEp8QGaqyWbEbrRUj1QLej9K+x52DEpAnA8/GcrHPQO0Z4pk7LOYlqY0lPxX1yb4vf1NpJIZ0fe2o2pWsHtz7wt7pObM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2567.namprd10.prod.outlook.com (2603:10b6:a02:ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 16 Apr
 2021 09:20:58 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:20:58 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 02/11] xfs: Add xfs_attr_node_remove_cleanup
Date:   Fri, 16 Apr 2021 02:20:36 -0700
Message-Id: <20210416092045.2215-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416092045.2215-1-allison.henderson@oracle.com>
References: <20210416092045.2215-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BY5PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::42) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BY5PR17CA0029.namprd17.prod.outlook.com (2603:10b6:a03:1b8::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:20:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20febd88-6343-414f-4115-08d900b8f1d2
X-MS-TrafficTypeDiagnostic: BYAPR10MB2567:
X-Microsoft-Antispam-PRVS: <BYAPR10MB25671193E21A1F16A62768A6954C9@BYAPR10MB2567.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l/TMo+yD/PfgllsyMsq/q54pQpKHf+X1X+SLxqFcJf2TQnGeZZmNDo4FAgbth0w0mINi2QYphSATQhyWiTuDzH7Yt6v+rWdxLD9knyFJFoFy549tbHNyGD6tzwJY/b0JBU4spWnkKd+rRADvR9DVt5F7sM8m/vOf21HqL4xu1VpGg8r6MFniYaYUuFT3z1bHP6VMrob3ry+4N0FaRXsWwzM5qb6jedUI86kh8NuuSP0DEFyhW6H71250aeZxZqsph/VdNY0IX+gVYPyb8hubXP7Tadw0Mrz0OflWi7sLpLgrVpCRYcWBdrdBvdVVKa4GCxgqDzl7fLuiz5nBUXKT+Xno2GaQQb93XMLvEQli8G0MBcX51NXQGU5jQrdxZWDhIksgB/DjiZM3k16MEzoIsmIJOe5iW/e/Y56NZwmYMJHC6gkHNKpuAzPM6ZKC5OUT9SlW/7SJsIKN9DzjeCSl2sVx1DY1yp+UdNhJEfW0FPmnJU/olwLPLXrxSMpYZUScjw7LrjbrUG9xoTjjJbdzBhzDTac0jhXYpD1kGm2FKvyKMEgL5mp7eRMdn8tQvpqJxY+GS1Vwa0P1PIR0bR9msycZS5JMwNl9GhwzAOfK/TJAKY2HvLP8tIiN6CSTs257kd9n9s2YAb3FKrUfZjpkPg1gI+MpNlz1QJLxyvDAuJGIWPH1CrdC89XZeOa7z8Bp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(346002)(396003)(376002)(16526019)(8676002)(36756003)(44832011)(8936002)(38350700002)(52116002)(6666004)(69590400012)(83380400001)(2616005)(86362001)(66556008)(26005)(6512007)(6486002)(316002)(186003)(2906002)(1076003)(38100700002)(6506007)(66476007)(6916009)(5660300002)(956004)(508600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?13T7pM+yk9AmXQdVOMcAUKmn2hjfA3wQXaOlRcKqBEqf4LSrpsO+FqCK+X+A?=
 =?us-ascii?Q?UGwuliUzfByjhb83QVHOYmabW2ewLIZwp6zVhx7ErMazFESJhAI6BCfS388U?=
 =?us-ascii?Q?sAxNPe+Z1mKYJGslQNdzyLgoDsbrzVgnhq+iAxONnFxu2RP7pQ2cRgNZdD19?=
 =?us-ascii?Q?5PXPyQHwsz/R5zgEP6RKVm6zTIBo0FNu4aasX+yvL3/psv8fJeXyQmPhirNE?=
 =?us-ascii?Q?sZdBAhVgdDsmJ6KbW9afXn1Unxj9/BVdHhujYcu1U5fwyBNzEuDseWrjfy3v?=
 =?us-ascii?Q?7Lw5gmadCryRhagPRFJ7CoTB4P19j5gfsix3k6TV1AHsbOvF9nX4l5XNe7B7?=
 =?us-ascii?Q?Uas+q8x/khD/kw2ZFOgZgX3FIjgRnSKD//9YBYRy3vxmWqJvRSK5sqXY+hcD?=
 =?us-ascii?Q?ed2uWf9rnGEqEQg7UWNrJldwC0MaPKC5NbfxN1WZyrXmBFD2I7+3g5MdBJcA?=
 =?us-ascii?Q?hBtmcHV6QTHDRj2m/CUy2lma/WxFeSZHSEmPvBpW4z9+nYi3Ih5syvV0OzJR?=
 =?us-ascii?Q?MnrAYeIcnHdMCpizbSWhcfqSkMFziaey+1hjaEi+uHp7vaNcWb1FKuaUkeJe?=
 =?us-ascii?Q?XjlSHOJSmsL4Lyos6A1u0mFaqmqUTRzctByS3eemXw9DstXqU5bynyXsRf0H?=
 =?us-ascii?Q?r3uorQXYlNCCL8h5yr7XJDexmlMMc1Nc7zazc2Kz4PKvGlrD4Uw079UWZi24?=
 =?us-ascii?Q?OKlWZqx1ATjJZ88qXbW4adXKTCSrSg3r/ScbkK1/vM41CSANW2KjGz/UKhC1?=
 =?us-ascii?Q?u1SJU3/Q2oU4O+3OfWWvD+0IetFSMq6K8+AdAdYddlynaT67qMhV6sCppJ2K?=
 =?us-ascii?Q?udyfTpkZL57uGOezemq/yquMIyGUr0toPyXJU00tsTcTsotbGJw0ruFBVCoG?=
 =?us-ascii?Q?Pwx9Ds0kBfurqP2A17ARKv3p/ZN+B+BlRta/4R5q6PSeXnkyJDmzleaNgA5o?=
 =?us-ascii?Q?4LQ6uZJnmXVjhpN5XIK/PSykW1+0ZRoUv2VOo86BHxxLCODZGanYZ3gFqEg/?=
 =?us-ascii?Q?3WsbGCS+fCLQOBsBsa92/oGQFW1AydBZzE6iMrZMh7L1VshZESNX6MJIsk9s?=
 =?us-ascii?Q?mR4zY1Hi5fwAe349T+z+xv3H+il1RVaN18F4uC+yafg82khhwN66XyK7Cu/o?=
 =?us-ascii?Q?pdgZ0GLctnzErW8mTwfREX9WLE0ifah6L0t9k44nOQfZMyb2d9zB5x1odIw7?=
 =?us-ascii?Q?yZjcyen3d62MI5gHaNM1+CAV5hUMwJS+W/nneeoXBOhvq9YaO86WnW7zBIHF?=
 =?us-ascii?Q?ejD1eZGiVSs2f1tfccsPm2olYtlrrYQwx/9aVMiF+/kby2uFFXhdV1r+Z89M?=
 =?us-ascii?Q?WGxVqK8+y2IJZKqJ9VNYKgjS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20febd88-6343-414f-4115-08d900b8f1d2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:20:58.2150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zc7p/PMughVhmwVBnCU/ZheqATdp0BZgdTF8DWsA4Yj+76Bf9pK8LNvM1bmzu91qQYeFOkFE9SHqu/QuXq3PvLL85VRIX3I0PFRU7FoC8ig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2567
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
X-Proofpoint-ORIG-GUID: Q9FKI1YMl-mgBN1nGDFMe4fLE0eYGaTF
X-Proofpoint-GUID: Q9FKI1YMl-mgBN1nGDFMe4fLE0eYGaTF
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch pulls a new helper function xfs_attr_node_remove_cleanup out
of xfs_attr_node_remove_step.  This helps to modularize
xfs_attr_node_remove_step which will help make the delayed attribute
code easier to follow

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 94729aa..1832bbf 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1203,6 +1203,25 @@ int xfs_attr_node_removename_setup(
 	return 0;
 }
 
+STATIC int
+xfs_attr_node_remove_cleanup(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	struct xfs_da_state_blk	*blk;
+	int			retval;
+
+	/*
+	 * Remove the name and update the hashvals in the tree.
+	 */
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+	retval = xfs_attr3_leaf_remove(blk->bp, args);
+	xfs_da3_fixhashpath(state, &state->path);
+
+	return retval;
+}
+
 /*
  * Remove a name from a B-tree attribute list.
  *
@@ -1215,7 +1234,6 @@ xfs_attr_node_removename(
 	struct xfs_da_args	*args)
 {
 	struct xfs_da_state	*state;
-	struct xfs_da_state_blk	*blk;
 	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
@@ -1243,14 +1261,7 @@ xfs_attr_node_removename(
 		if (error)
 			goto out;
 	}
-
-	/*
-	 * Remove the name and update the hashvals in the tree.
-	 */
-	blk = &state->path.blk[ state->path.active-1 ];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	retval = xfs_attr3_leaf_remove(blk->bp, args);
-	xfs_da3_fixhashpath(state, &state->path);
+	retval = xfs_attr_node_remove_cleanup(args, state);
 
 	/*
 	 * Check to see if the tree needs to be collapsed.
-- 
2.7.4

