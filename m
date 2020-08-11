Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3A8C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 16:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BB9D20771
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 16:42:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YaS6fWp+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgHKQmh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Aug 2020 12:42:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44686 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728975AbgHKQme (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Aug 2020 12:42:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07BGaoKr045233;
        Tue, 11 Aug 2020 16:42:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=WA5Vt75niXNrp25OSSf0gJv+cQ63FRhX0XUmzkxbQII=;
 b=YaS6fWp+ttg9cK7S1SlglyWYgHkqaCj9qoeXIutzT8/7x+mYq3AYGuhqkQ17846++LjN
 ysUjw0YfRPtg7FT7Qn7wHi2JK6fDFQUhMiXBTYpmpz8p4mrLHzUgPddyYdTJlqyfvccu
 wkYb5TDYvZDFdqW0mJpMhgzQRjgkRwrU4VTwOZIGDgNtMBa1pdIUztO5PGtmCoO4Ewno
 9gOrjHfWvCvAZUt+Tl+1bfF4VzSd2tgGKTL/GRrJqVQiePJ0aOwZAG+PEihi3la3zrnJ
 EdRjaLds9CjaX1qAyCj8cG4ewtH9vbQYTeYjz9Nl/gfwFAWbrneV3LG9v9rvJGGP7C/r bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32sm0mnu3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 11 Aug 2020 16:42:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07BGcSk9078384;
        Tue, 11 Aug 2020 16:42:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32t6000p4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Aug 2020 16:42:32 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07BGgVfJ007825;
        Tue, 11 Aug 2020 16:42:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Aug 2020 16:42:31 +0000
Subject: [PATCH 2/2] mkfs: allow setting dax flag on root directory
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 11 Aug 2020 09:42:30 -0700
Message-ID: <159716415037.2135493.12958426655000840394.stgit@magnolia>
In-Reply-To: <159716413625.2135493.4789129138005837744.stgit@magnolia>
References: <159716413625.2135493.4789129138005837744.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9710 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008110115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9710 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008110115
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach mkfs to set the DAX flag on the root directory so that all new
files can be created in dax mode.  This is a complement to removing the
mount option.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/mkfs.xfs.8 |   11 +++++++++++
 mkfs/xfs_mkfs.c     |   14 ++++++++++++++
 2 files changed, 25 insertions(+)


diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 9d762a43011a..4b4fdd86b2f4 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -394,6 +394,17 @@ All inodes created by
 will have this extent size hint applied.
 The value must be provided in units of filesystem blocks.
 Directories will pass on this hint to newly created children.
+.TP
+.BI dax= value
+All inodes created by
+.B mkfs.xfs
+will have the DAX flag set.
+This means that directories will pass the flag on to newly created files
+and files will use the DAX IO paths when possible.
+This value is either 1 to enable the use or 0 to disable.
+By default,
+.B mkfs.xfs
+will not enable DAX mode.
 .RE
 .TP
 .B \-f
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2e6cd280e388..33507f6ea21c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -60,6 +60,7 @@ enum {
 	D_PROJINHERIT,
 	D_EXTSZINHERIT,
 	D_COWEXTSIZE,
+	D_DAX,
 	D_MAX_OPTS,
 };
 
@@ -254,6 +255,7 @@ static struct opt_params dopts = {
 		[D_PROJINHERIT] = "projinherit",
 		[D_EXTSZINHERIT] = "extszinherit",
 		[D_COWEXTSIZE] = "cowextsize",
+		[D_DAX] = "dax",
 	},
 	.subopt_params = {
 		{ .index = D_AGCOUNT,
@@ -369,6 +371,12 @@ static struct opt_params dopts = {
 		  .maxval = UINT_MAX,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
+		{ .index = D_DAX,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
 	},
 };
 
@@ -1434,6 +1442,12 @@ data_opts_parser(
 		cli->fsx.fsx_cowextsize = getnum(value, opts, subopt);
 		cli->fsx.fsx_xflags |= FS_XFLAG_COWEXTSIZE;
 		break;
+	case D_DAX:
+		if (getnum(value, opts, subopt))
+			cli->fsx.fsx_xflags |= FS_XFLAG_DAX;
+		else
+			cli->fsx.fsx_xflags &= ~FS_XFLAG_DAX;
+		break;
 	default:
 		return -EINVAL;
 	}

