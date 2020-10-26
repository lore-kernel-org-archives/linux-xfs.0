Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09F4C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9775220809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:34:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nl9E3pNM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406511AbgJZXeC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:34:02 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42676 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406509AbgJZXeC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:34:02 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPZ2x177137;
        Mon, 26 Oct 2020 23:33:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7zwIo757IjhrqhUJIVccqVMDhQeq6sRMMaG00yXrz1I=;
 b=nl9E3pNMI5lsLTRRyKLgZaY73qD+trT67/gloYf1MTb/mZQ0/LGtLC+qCy4d3HMK1GcX
 bfAl21pFIm5jv/IA0knKXS+s8BqQ4qf0KFFmApNDrql5JKug8r7Hd0jImrCmOJcuL1eY
 1SJKEYgM79XE/i9JAzZZPo18Xg2gb9Sml1DmEfjoKgNF/EP7e7rz4KL+aBPNeNVumqh5
 YANb7OuViQRIemI9V6xvvkRIrYG1SfTOoTzGL3sBAwZ1Hfs5/rMX3M3PXvLuyUS7auoi
 vdEDzAiQbRdFUOv3d0n0d73qXlZjgRqrFXF3+Xbb7/9SEbEwlTCN6/OPJY0TnsmCDnbV 7Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34c9saqd0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:33:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQNJI058412;
        Mon, 26 Oct 2020 23:33:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34cwukr87m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:33:58 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNXw5B007261;
        Mon, 26 Oct 2020 23:33:58 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:33:57 -0700
Subject: [PATCH 8/9] mkfs: enable the inode btree counter feature
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:33:56 -0700
Message-ID: <160375523682.880355.16796358046529188083.stgit@magnolia>
In-Reply-To: <160375518573.880355.12052697509237086329.stgit@magnolia>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach mkfs how to enable the inode btree counter feature.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/mkfs.xfs.8 |   15 +++++++++++++++
 mkfs/xfs_mkfs.c     |   34 +++++++++++++++++++++++++++++++++-
 2 files changed, 48 insertions(+), 1 deletion(-)


diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 0a7858748457..1a6a5f93f0ea 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -184,6 +184,21 @@ option set. When the option
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
index 908d520df909..23e3077e0174 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -119,6 +119,7 @@ enum {
 	M_UUID,
 	M_RMAPBT,
 	M_REFLINK,
+	M_INOBTCNT,
 	M_MAX_OPTS,
 };
 
@@ -660,6 +661,7 @@ static struct opt_params mopts = {
 		[M_UUID] = "uuid",
 		[M_RMAPBT] = "rmapbt",
 		[M_REFLINK] = "reflink",
+		[M_INOBTCNT] = "inobtcount",
 	},
 	.subopt_params = {
 		{ .index = M_CRC,
@@ -690,6 +692,12 @@ static struct opt_params mopts = {
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
 
@@ -740,6 +748,7 @@ struct sb_feat_args {
 	bool	spinodes;		/* XFS_SB_FEAT_INCOMPAT_SPINODES */
 	bool	rmapbt;			/* XFS_SB_FEAT_RO_COMPAT_RMAPBT */
 	bool	reflink;		/* XFS_SB_FEAT_RO_COMPAT_REFLINK */
+	bool	inobtcnt;		/* XFS_SB_FEAT_RO_COMPAT_INOBTCNT */
 	bool	nodalign;
 	bool	nortalign;
 };
@@ -862,7 +871,8 @@ usage( void )
 {
 	fprintf(stderr, _("Usage: %s\n\
 /* blocksize */		[-b size=num]\n\
-/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1]\n\
+/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
+			    inobtcnt=0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectsize=num\n\
@@ -1565,6 +1575,9 @@ meta_opts_parser(
 	case M_REFLINK:
 		cli->sb_feat.reflink = getnum(value, opts, subopt);
 		break;
+	case M_INOBTCNT:
+		cli->sb_feat.inobtcnt = getnum(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1988,6 +2001,22 @@ _("reflink not supported without CRC support\n"));
 			usage();
 		}
 		cli->sb_feat.reflink = false;
+
+		if (cli->sb_feat.inobtcnt && cli_opt_set(&mopts, M_INOBTCNT)) {
+			fprintf(stderr,
+_("inode btree counters not supported without CRC support\n"));
+			usage();
+		}
+		cli->sb_feat.inobtcnt = false;
+	}
+
+	if (!cli->sb_feat.finobt) {
+		if (cli->sb_feat.inobtcnt && cli_opt_set(&mopts, M_INOBTCNT)) {
+			fprintf(stderr,
+_("inode btree counters not supported without finobt support\n"));
+			usage();
+		}
+		cli->sb_feat.inobtcnt = false;
 	}
 
 	if ((cli->fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE) &&
@@ -2955,6 +2984,8 @@ sb_set_features(
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
 	if (fp->reflink)
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
+	if (fp->inobtcnt)
+		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
 
 	/*
 	 * Sparse inode chunk support has two main inode alignment requirements.
@@ -3617,6 +3648,7 @@ main(
 			.spinodes = true,
 			.rmapbt = false,
 			.reflink = true,
+			.inobtcnt = false,
 			.parent_pointers = false,
 			.nodalign = false,
 			.nortalign = false,

