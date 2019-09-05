Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CAE1C43140
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62B3F2070C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TmoMkh9R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391140AbfIEWTL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39030 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391144AbfIEWTK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ8e1084677
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=8w26he1AYNfrvoebUZOnkR1VPvR77qjmmBrxXOaS8Os=;
 b=TmoMkh9RXWEAGEx35f7cp0nI6vQfYmP9DJSpbXZqXxRkb7S4XF8veIJ+bfW/Ux9Efh+V
 801hqQyLnQ+2iN45z/uxWDFyGS1MMwqK0BwnIlV7Ns45TB6oHB/VEG/Efd/XPTsoxLKv
 kksyiN3dYg24g3R4zz94c8UClX4Gew2aLBtRjPQxxm5S4OV0WRxDoFvccDF0cOQ4aXQD
 hoPF9pr5Toh4iSU4X/3z70EhCCS8RxB3BEWG/IgiX/obgwUG9s+wpIO/MKYRaMN9hQMs
 L20LTNDws5PnkTUVC28qHC2/R9HODB1Gf6kHIRMERv0awGO0c0TorBr5Gzv7AKfttBe/ 6g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uuaqxr2e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MIOk4101693
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2uu1b946v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:06 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x85MJ68r032591
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:06 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:19:06 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 21/21] xfsprogs: Add delayed attribute flag to cmd
Date:   Thu,  5 Sep 2019 15:18:55 -0700
Message-Id: <20190905221855.17555-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221855.17555-1-allison.henderson@oracle.com>
References: <20190905221855.17555-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

mkfs: enable feature bit in mkfs via the '-n delattr' parameter.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 mkfs/xfs_mkfs.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0bdf6ec..1f1ffda 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -92,6 +92,7 @@ enum {
 	N_SIZE = 0,
 	N_VERSION,
 	N_FTYPE,
+	N_DELATTR,
 	N_MAX_OPTS,
 };
 
@@ -538,6 +539,7 @@ static struct opt_params nopts = {
 		[N_SIZE] = "size",
 		[N_VERSION] = "version",
 		[N_FTYPE] = "ftype",
+		[N_DELATTR] = "delattr",
 	},
 	.subopt_params = {
 		{ .index = N_SIZE,
@@ -560,6 +562,12 @@ static struct opt_params nopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = N_DELATTR,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
 	},
 };
 
@@ -733,6 +741,7 @@ struct sb_feat_args {
 	bool	reflink;		/* XFS_SB_FEAT_RO_COMPAT_REFLINK */
 	bool	nodalign;
 	bool	nortalign;
+	bool	delattr;		/* XFS_SB_FEAT_INCOMPAT_LOG_DELATTR */
 };
 
 struct cli_params {
@@ -864,7 +873,7 @@ usage( void )
 /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
 			    sunit=value|su=num,sectsize=num,lazy-count=0|1]\n\
 /* label */		[-L label (maximum 12 characters)]\n\
-/* naming */		[-n size=num,version=2|ci,ftype=0|1]\n\
+/* naming */		[-n size=num,version=2|ci,ftype=0|1,delattr=0|1]\n\
 /* no-op info only */	[-N]\n\
 /* prototype file */	[-p fname]\n\
 /* quiet */		[-q]\n\
@@ -1609,6 +1618,9 @@ naming_opts_parser(
 	case N_FTYPE:
 		cli->sb_feat.dirftype = getnum(value, opts, subopt);
 		break;
+	case N_DELATTR:
+		cli->sb_feat.delattr = getnum(value, &nopts, N_DELATTR);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2012,6 +2024,14 @@ _("reflink not supported without CRC support\n"));
 		cli->sb_feat.reflink = false;
 	}
 
+	if ((cli->sb_feat.delattr) &&
+	    cli->sb_feat.dir_version == 4) {
+		fprintf(stderr,
+_("delayed attributes not supported on v4 filesystems\n"));
+		usage();
+		cli->sb_feat.delattr = false;
+	}
+
 	if ((cli->fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE) &&
 	    !cli->sb_feat.reflink) {
 		fprintf(stderr,
@@ -2974,6 +2994,8 @@ sb_set_features(
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
 	if (fp->reflink)
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
+	if (fp->delattr)
+		sbp->sb_features_log_incompat |= XFS_SB_FEAT_INCOMPAT_LOG_DELATTR;
 
 	/*
 	 * Sparse inode chunk support has two main inode alignment requirements.
-- 
2.7.4

