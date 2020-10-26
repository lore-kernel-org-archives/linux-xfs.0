Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41632C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04DA020874
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:36:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ri3KN9+7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407200AbgJZXgv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:36:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38034 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407198AbgJZXgv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:36:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNP0bT157948;
        Mon, 26 Oct 2020 23:36:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Ra6gL4102Epn5DtVjS2Uy9lDNJ+KMhRBvHfo94RFZNw=;
 b=Ri3KN9+7Z7mncQfQingTjDEFU+jEyp1iLi9+svVxWNByXkZARwwBNxEzZqJbE+1b8T/l
 QXyUC9Wj7Qr+E31dwqx2W/FUjyxAf9YoSF/WSWge4gur0lFwd67LWL/3/uZw83hWwhlc
 M5tJOPcE5ZyEDgXVsqMDpDUnzlLB0Q5m+mhdS02/vR29wn72FzG7rj6rBC33vUkuQsWf
 WONsJT70+cwOfix3g+KZDXEkpdjePPKzoGZQp6j1BC6Lhk32yk3NNVkoZ3a6UQvAMw/E
 Hl8UPu2E37+GOtLo5Sp9s7vZxzO00gLqxnrhEJfcgwDDNF80G441z0Jgd15kf4lki5G7 9A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:36:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPHSi121223;
        Mon, 26 Oct 2020 23:36:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34cx6va6xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:36:48 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNalLU008341;
        Mon, 26 Oct 2020 23:36:47 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:36:47 -0700
Subject: [PATCH 25/26] mkfs: format bigtime filesystems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:36:46 -0700
Message-ID: <160375540688.881414.887151161169932986.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Allow formatting with large timestamps.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/mkfs.xfs.8 |   16 ++++++++++++++++
 mkfs/xfs_mkfs.c     |   24 +++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)


diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 1a6a5f93f0ea..9e72a841f868 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -150,6 +150,22 @@ valid
 are:
 .RS 1.2i
 .TP
+.BI bigtime= value
+This option enables filesystems that can handle inode timestamps from December
+1901 to July 2486, and quota timer expirations from January 1970 to July 2486.
+The value is either 0 to disable the feature, or 1 to enable large timestamps.
+.IP
+If this feature is not enabled, the filesystem can only handle timestamps from
+December 1901 to January 2038, and quota timers from January 1970 to February
+2106.
+.IP
+By default,
+.B mkfs.xfs
+will not enable this feature.
+If the option
+.B \-m crc=0
+is used, the large timestamp feature is not supported and is disabled.
+.TP
 .BI crc= value
 This is used to create a filesystem which maintains and checks CRC information
 in all metadata objects on disk. The value is either 0 to disable the feature,
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 23e3077e0174..4cb79b695921 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -120,6 +120,7 @@ enum {
 	M_RMAPBT,
 	M_REFLINK,
 	M_INOBTCNT,
+	M_BIGTIME,
 	M_MAX_OPTS,
 };
 
@@ -662,6 +663,7 @@ static struct opt_params mopts = {
 		[M_RMAPBT] = "rmapbt",
 		[M_REFLINK] = "reflink",
 		[M_INOBTCNT] = "inobtcount",
+		[M_BIGTIME] = "bigtime",
 	},
 	.subopt_params = {
 		{ .index = M_CRC,
@@ -698,6 +700,12 @@ static struct opt_params mopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = M_BIGTIME,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
 	},
 };
 
@@ -749,6 +757,7 @@ struct sb_feat_args {
 	bool	rmapbt;			/* XFS_SB_FEAT_RO_COMPAT_RMAPBT */
 	bool	reflink;		/* XFS_SB_FEAT_RO_COMPAT_REFLINK */
 	bool	inobtcnt;		/* XFS_SB_FEAT_RO_COMPAT_INOBTCNT */
+	bool	bigtime;		/* XFS_SB_FEAT_INCOMPAT_BIGTIME */
 	bool	nodalign;
 	bool	nortalign;
 };
@@ -872,7 +881,7 @@ usage( void )
 	fprintf(stderr, _("Usage: %s\n\
 /* blocksize */		[-b size=num]\n\
 /* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
-			    inobtcnt=0|1]\n\
+			    inobtcnt=0|1,bigtime=0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectsize=num\n\
@@ -1578,6 +1587,9 @@ meta_opts_parser(
 	case M_INOBTCNT:
 		cli->sb_feat.inobtcnt = getnum(value, opts, subopt);
 		break;
+	case M_BIGTIME:
+		cli->sb_feat.bigtime = getnum(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2008,6 +2020,13 @@ _("inode btree counters not supported without CRC support\n"));
 			usage();
 		}
 		cli->sb_feat.inobtcnt = false;
+
+		if (cli->sb_feat.bigtime && cli_opt_set(&mopts, M_BIGTIME)) {
+			fprintf(stderr,
+_("timestamps later than 2038 not supported without CRC support\n"));
+			usage();
+		}
+		cli->sb_feat.bigtime = false;
 	}
 
 	if (!cli->sb_feat.finobt) {
@@ -2986,6 +3005,8 @@ sb_set_features(
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
 	if (fp->inobtcnt)
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
+	if (fp->bigtime)
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_BIGTIME;
 
 	/*
 	 * Sparse inode chunk support has two main inode alignment requirements.
@@ -3652,6 +3673,7 @@ main(
 			.parent_pointers = false,
 			.nodalign = false,
 			.nortalign = false,
+			.bigtime = false,
 		},
 	};
 

