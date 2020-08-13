Return-Path: <SRS0=yY6+=BX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D11C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 23:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEA992078B
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 23:27:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DmYXiyg/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgHMX1s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Aug 2020 19:27:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40494 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgHMX1r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Aug 2020 19:27:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07DNIA9V116433;
        Thu, 13 Aug 2020 23:27:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hh5rvYV8ZH+D5jX6i8nDMT01GFvNXgfTEQ6fjjM+Di8=;
 b=DmYXiyg/zL3mzafUz5NfLuxFEV+SadlXZ4Axq5HDQojAnVSs9B8+AdjwW/eoVlaDga65
 48vlT6gQz5Ce1ctJV8W9gyUCXzDpJrsEo4Yc+v0SREuRXJXmFL9oNyvWaff6nzM8NeL6
 AtKG3c941yeQcyUrDgPGUA0dS4s6CxMzu7JGqut6gqbrWQC4+E21YB5T/fnZCB9o2gp1
 H5lNspBeJG4sBFAZaM9Txu9us5hGZ4KhWks2f75OrQU9WCvHWHRVnLGtmJ7xYNhUbJPS
 RIsMjzA/9MxhpSX/hS6P7BPUlcNbxztQwxvleXQ+wW36aW3hJg/Fzum+mNkYiqZTR7DE Yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32t2ye1vdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Aug 2020 23:27:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07DNDbub190271;
        Thu, 13 Aug 2020 23:27:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32u3h63tsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 23:27:45 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07DNRicP017069;
        Thu, 13 Aug 2020 23:27:44 GMT
Received: from localhost (/10.159.233.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 13 Aug 2020 23:27:44 +0000
Subject: [PATCH 4/4] mkfs: allow setting dax flag on root directory
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 13 Aug 2020 16:27:44 -0700
Message-ID: <159736126408.3063459.10843086291491627861.stgit@magnolia>
In-Reply-To: <159736123670.3063459.13610109048148937841.stgit@magnolia>
References: <159736123670.3063459.13610109048148937841.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9712 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008130162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9712 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008130162
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
 man/man8/mkfs.xfs.8 |   10 ++++++++++
 mkfs/xfs_mkfs.c     |   14 ++++++++++++++
 2 files changed, 24 insertions(+)


diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 7d3f3552ff12..3ad9e5449f58 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -398,6 +398,16 @@ will have this extent size hint applied.
 The value must be provided in units of filesystem blocks.
 Directories will pass on this hint to newly created regular files and
 directories.
+.TP
+.BI daxinherit= value
+If set, all inodes created by
+.B mkfs.xfs
+will be created with the DAX flag set.
+Directories will pass on this flag on to newly created regular files
+and directories.
+By default,
+.B mkfs.xfs
+will not enable DAX mode.
 .RE
 .TP
 .B \-f
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2e6cd280e388..a687f385a9c1 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -60,6 +60,7 @@ enum {
 	D_PROJINHERIT,
 	D_EXTSZINHERIT,
 	D_COWEXTSIZE,
+	D_DAXINHERIT,
 	D_MAX_OPTS,
 };
 
@@ -254,6 +255,7 @@ static struct opt_params dopts = {
 		[D_PROJINHERIT] = "projinherit",
 		[D_EXTSZINHERIT] = "extszinherit",
 		[D_COWEXTSIZE] = "cowextsize",
+		[D_DAXINHERIT] = "daxinherit",
 	},
 	.subopt_params = {
 		{ .index = D_AGCOUNT,
@@ -369,6 +371,12 @@ static struct opt_params dopts = {
 		  .maxval = UINT_MAX,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
+		{ .index = D_DAXINHERIT,
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
+	case D_DAXINHERIT:
+		if (getnum(value, opts, subopt))
+			cli->fsx.fsx_xflags |= FS_XFLAG_DAX;
+		else
+			cli->fsx.fsx_xflags &= ~FS_XFLAG_DAX;
+		break;
 	default:
 		return -EINVAL;
 	}

