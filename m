Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15270C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E21E42063A
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:00:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w15yC9oC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgHQXA4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 19:00:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41996 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgHQXAy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 19:00:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMvpd5136692;
        Mon, 17 Aug 2020 23:00:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=jYfZliOjEtZ7AeTenxorrrPHGqsvbH77Xk7DxM5OzIQ=;
 b=w15yC9oCXjfA7sI9mb5keQdQONrD0+tXNRnBsw/tI8XhyOi6i2YpqXsIniBTgVw6oNwe
 QBPePsScls2eGxdCdeHW68m/caefqXRRmUXEHl9xn7RC1MzpKteWMk/2YrAGgkHaMhJs
 UT80wOsiHMR6wEAYyn1Tg9OHKr/oPBwlIcQPETc4y+r6qnWXUwCaQeEMBdtI+wbPR5ut
 73qVS0f2C9mdn3R0YOwgUe7CAxda8K5s+Zo+n+fqfgxpX2z34jCLhXyIQNJylBChylUc
 lidC3DXlEpMiQq9SDlBuJMAV37ERdJ5H76at/iBHqDuqH+HTBthhfbV9PFGviLRiP10E sg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32x8bn1g51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 23:00:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMw81V139087;
        Mon, 17 Aug 2020 22:58:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32xs9m9yng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:58:51 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HMwoX9017714;
        Mon, 17 Aug 2020 22:58:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:58:50 -0700
Subject: [PATCH 7/7] mkfs: enable the inode btree counter feature
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 15:58:49 -0700
Message-ID: <159770512916.3958545.6841622093942206375.stgit@magnolia>
In-Reply-To: <159770508586.3958545.417872750558976156.stgit@magnolia>
References: <159770508586.3958545.417872750558976156.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach mkfs how to enable the inode btree counter feature.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/mkfs.xfs.8 |   15 +++++++++++++++
 mkfs/xfs_mkfs.c     |   27 ++++++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletion(-)


diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 93dcd6583f1b..082f3ab6c063 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -188,6 +188,21 @@ option set. When the option
 .B \-m crc=0
 is used, the free inode btree feature is not supported and is disabled.
 .TP
+.BI inobtcount= value
+This option causes the filesystem to record the number of blocks used by
+the inode btree and the free inode btree.
+This can be used to reduce mount times when the free inode btree is enabled.
+.IP
+By default,
+.B mkfs.xfs
+will not enable this option.
+This feature is only available for filesystems created with the (default)
+.B \-m finobt=1
+option set.
+When the option
+.B \-m finobt=0
+is used, the inode btree counter feature is not supported and is disabled.
+.TP
 .BI uuid= value
 Use the given value as the filesystem UUID for the newly created filesystem.
 The default is to generate a random UUID.
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 66b0c759b1cb..037246effd70 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -119,6 +119,7 @@ enum {
 	M_UUID,
 	M_RMAPBT,
 	M_REFLINK,
+	M_INOBTCNT,
 	M_MAX_OPTS,
 };
 
@@ -665,6 +666,7 @@ static struct opt_params mopts = {
 		[M_UUID] = "uuid",
 		[M_RMAPBT] = "rmapbt",
 		[M_REFLINK] = "reflink",
+		[M_INOBTCNT] = "inobtcount",
 	},
 	.subopt_params = {
 		{ .index = M_CRC,
@@ -695,6 +697,12 @@ static struct opt_params mopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = M_INOBTCNT,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
 	},
 };
 
@@ -746,6 +754,7 @@ struct sb_feat_args {
 	bool	spinodes;		/* XFS_SB_FEAT_INCOMPAT_SPINODES */
 	bool	rmapbt;			/* XFS_SB_FEAT_RO_COMPAT_RMAPBT */
 	bool	reflink;		/* XFS_SB_FEAT_RO_COMPAT_REFLINK */
+	bool	inobtcnt;		/* XFS_SB_FEAT_RO_COMPAT_INOBTCNT */
 	bool	nodalign;
 	bool	nortalign;
 };
@@ -868,7 +877,8 @@ usage( void )
 {
 	fprintf(stderr, _("Usage: %s\n\
 /* blocksize */		[-b size=num]\n\
-/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1]\n\
+/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
+			    inobtcnt=0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectsize=num\n\
@@ -1608,6 +1618,9 @@ meta_opts_parser(
 	case M_REFLINK:
 		cli->sb_feat.reflink = getnum(value, opts, subopt);
 		break;
+	case M_INOBTCNT:
+		cli->sb_feat.inobtcnt = getnum(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2033,6 +2046,15 @@ _("reflink not supported without CRC support\n"));
 		cli->sb_feat.reflink = false;
 	}
 
+	if (!cli->sb_feat.finobt) {
+		if (cli->sb_feat.inobtcnt && cli_opt_set(&mopts, M_INOBTCNT)) {
+			fprintf(stderr,
+_("inode btree counters not supported without finobt support\n"));
+			usage();
+		}
+		cli->sb_feat.inobtcnt = false;
+	}
+
 	if ((cli->fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE) &&
 	    !cli->sb_feat.reflink) {
 		fprintf(stderr,
@@ -2996,6 +3018,8 @@ sb_set_features(
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
 	if (fp->reflink)
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
+	if (fp->inobtcnt)
+		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
 
 	/*
 	 * Sparse inode chunk support has two main inode alignment requirements.
@@ -3664,6 +3688,7 @@ main(
 			.spinodes = true,
 			.rmapbt = true,
 			.reflink = true,
+			.inobtcnt = false,
 			.parent_pointers = false,
 			.nodalign = false,
 			.nortalign = false,

