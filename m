Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CCE1C433E4
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49413204EC
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:00:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ULSEcyxp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgHQXA4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 19:00:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36350 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728168AbgHQXAx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 19:00:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMwCxX164183;
        Mon, 17 Aug 2020 23:00:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Iuz9a7wR40ETUC1+oUndSlH4BlGONlpBt9hoDpeC0lU=;
 b=ULSEcyxpyzRQ5viBEWsgtz+El8Yc5uNLFOtIrEjxe8e2rA8ALna0fuBl0tuX6mKYGl3B
 TMaFsPj0FqAfu+qr7FJGeBgRvwW4Un0Xkx7hv3Xzh7TCzJApwLdlWi0z5J7zZlS3ddoy
 O5lb4YmxQn/kBuOWVg50Fj3VS/nZk1vb/F7kyi7uifYENBY55N3UC53PtdFAWVRkfo82
 PzYEGPHoT0+GMpJYk1GiQvEFPLQAau+jPtJ3yN09lW9CYYYVA2STdaubcTIVTpP4EHiL
 zMV1y1Zp41RQirC/PI23EO5RThBQ4EVNhTSzcEj4onxsWVqnCJMlJLgW9TNi6l/ECJje FQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32x74r1my7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 23:00:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMw7IN138964;
        Mon, 17 Aug 2020 23:00:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 32xs9ma1aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 23:00:50 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07HN0n0H017951;
        Mon, 17 Aug 2020 23:00:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 16:00:48 -0700
Subject: [PATCH 18/18] mkfs: format bigtime filesystems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 16:00:48 -0700
Message-ID: <159770524797.3958786.6498012041319904192.stgit@magnolia>
In-Reply-To: <159770513155.3958786.16108819726679724438.stgit@magnolia>
References: <159770513155.3958786.16108819726679724438.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
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
index 082f3ab6c063..7434b9f2b4cd 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -154,6 +154,22 @@ valid
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
index 037246effd70..f9f78a020092 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -120,6 +120,7 @@ enum {
 	M_RMAPBT,
 	M_REFLINK,
 	M_INOBTCNT,
+	M_BIGTIME,
 	M_MAX_OPTS,
 };
 
@@ -667,6 +668,7 @@ static struct opt_params mopts = {
 		[M_RMAPBT] = "rmapbt",
 		[M_REFLINK] = "reflink",
 		[M_INOBTCNT] = "inobtcount",
+		[M_BIGTIME] = "bigtime",
 	},
 	.subopt_params = {
 		{ .index = M_CRC,
@@ -703,6 +705,12 @@ static struct opt_params mopts = {
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
 
@@ -755,6 +763,7 @@ struct sb_feat_args {
 	bool	rmapbt;			/* XFS_SB_FEAT_RO_COMPAT_RMAPBT */
 	bool	reflink;		/* XFS_SB_FEAT_RO_COMPAT_REFLINK */
 	bool	inobtcnt;		/* XFS_SB_FEAT_RO_COMPAT_INOBTCNT */
+	bool	bigtime;		/* XFS_SB_FEAT_INCOMPAT_BIGTIME */
 	bool	nodalign;
 	bool	nortalign;
 };
@@ -878,7 +887,7 @@ usage( void )
 	fprintf(stderr, _("Usage: %s\n\
 /* blocksize */		[-b size=num]\n\
 /* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
-			    inobtcnt=0|1]\n\
+			    inobtcnt=0|1,bigtime=0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectsize=num\n\
@@ -1621,6 +1630,9 @@ meta_opts_parser(
 	case M_INOBTCNT:
 		cli->sb_feat.inobtcnt = getnum(value, opts, subopt);
 		break;
+	case M_BIGTIME:
+		cli->sb_feat.bigtime = getnum(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2044,6 +2056,13 @@ _("reflink not supported without CRC support\n"));
 			usage();
 		}
 		cli->sb_feat.reflink = false;
+
+		if (cli->sb_feat.bigtime) {
+			fprintf(stderr,
+_("big timestamps not supported without CRC support\n"));
+			usage();
+		}
+		cli->sb_feat.bigtime = false;
 	}
 
 	if (!cli->sb_feat.finobt) {
@@ -3020,6 +3039,8 @@ sb_set_features(
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
 	if (fp->inobtcnt)
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
+	if (fp->bigtime)
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_BIGTIME;
 
 	/*
 	 * Sparse inode chunk support has two main inode alignment requirements.
@@ -3692,6 +3713,7 @@ main(
 			.parent_pointers = false,
 			.nodalign = false,
 			.nortalign = false,
+			.bigtime = false,
 		},
 	};
 

