Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F12C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 15:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F32752053B
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 15:45:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tzxNnjWB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbgHQPpp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 11:45:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48834 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730573AbgHQPpH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 11:45:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HFX693186414;
        Mon, 17 Aug 2020 15:45:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=nvS8qtHJcPEzfablWUF2Yff8qxtz9VzVOsQtGit1/pE=;
 b=tzxNnjWBFPplgp6xnoX1C2bwIt1wEhJ2WJQDtqzqFjtJfOK9cwHhw82SEr2ZuitpjZKN
 3Jt7rygs4Zq660j/cGKGd2oxCH6uyk/YV0YPRzKzgnOXBjyOj0SwKEzBt7/tPnoEH2ZN
 MGier6T38fSl8oKt9s+XPOH6gnTuI8kDtTy8E7G8MsCI/F9b6Id/oETTuZX+fhKbrHYD
 63vszBGwJ/xi26UjvXlSlraf+uksixxbW5wJmrW1rIUZg2pzcB3sOCCJgXZP/4Q8Zli6
 hSZAKX4+Mrt7dKnsXrBBJ1kLYOp1jDj/gYaRPtjU9WLEYlMQEaPvMzrSFyLH3oL2Oq0B DA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32x8bmyh7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 15:45:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HFXwNe109391;
        Mon, 17 Aug 2020 15:43:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32xsm0cbmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 15:43:04 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HFh2NU024999;
        Mon, 17 Aug 2020 15:43:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 08:43:02 -0700
Date:   Mon, 17 Aug 2020 08:43:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 4/4] mkfs: allow setting dax flag on root directory
Message-ID: <20200817154301.GL6096@magnolia>
References: <159736123670.3063459.13610109048148937841.stgit@magnolia>
 <159736126408.3063459.10843086291491627861.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159736126408.3063459.10843086291491627861.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=3
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=3 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach mkfs to set the DAX flag on the root directory so that all new
files can be created in dax mode.  This is a complement to removing the
mount option.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
v2: minor tweak to manpage text
---
 man/man8/mkfs.xfs.8 |   10 ++++++++++
 mkfs/xfs_mkfs.c     |   14 ++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 7d3f3552ff12..0a7858748457 100644
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
+Directories will pass on this flag to newly created regular files and
+directories.
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
