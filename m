Return-Path: <SRS0=+s6N=D6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3889C56201
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74FB022253
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:33:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WSn9OtfQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372779AbgJWGdX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Oct 2020 02:33:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41458 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S372802AbgJWGdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Oct 2020 02:33:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6PbTW106826
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Uu5eVIFCmeVkuq3Tto5FmNjKv+c7wREVyGK1cXIojv8=;
 b=WSn9OtfQHlosLx9heWjisLHGIubageOjM1ioUyviquFqEAx4uBg0E5TbmzLhmTLhcPKT
 auxE+JiInF8FMtlTEBOWeo7Wm459qKUajchAZIMeU/PPs1NF7CHuudj81zDlJ1QaAq8T
 ALLCRiEz6HG8tYC8A0PYmsyuvF+IP8sVCgs6rK2HCSUlnbYfe314ZubgBR30ByVZJRaP
 /sIqOu0HbBdNjhT3ld9w7FNg7V1F886dVR8j7YWfj41cme8GYv0sRgHVQqlJwhm8jREC
 ECn/+jCyrhLCHCG9CAQ5wqxhJg0/o/0BpTjnvGGmo7o3GI5GWnmZ8bUUIpyJzO/W1pII LA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 349jrq1eq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6Q2UI123374
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34ak1aqy9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:21 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09N6XKuE012231
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:20 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 23:33:20 -0700
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v13 14/14] xfsprogs: Add delayed attribute flag to cmd
Date:   Thu, 22 Oct 2020 23:33:06 -0700
Message-Id: <20201023063306.7441-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201023063306.7441-1-allison.henderson@oracle.com>
References: <20201023063306.7441-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=1 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230045
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

mkfs: enable feature bit in mkfs via the '-n delattr' parameter.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 mkfs/xfs_mkfs.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8fe149d..e18fb3a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -94,6 +94,7 @@ enum {
 	N_SIZE = 0,
 	N_VERSION,
 	N_FTYPE,
+	N_DELATTR,
 	N_MAX_OPTS,
 };
 
@@ -547,6 +548,7 @@ static struct opt_params nopts = {
 		[N_SIZE] = "size",
 		[N_VERSION] = "version",
 		[N_FTYPE] = "ftype",
+		[N_DELATTR] = "delattr",
 	},
 	.subopt_params = {
 		{ .index = N_SIZE,
@@ -569,6 +571,12 @@ static struct opt_params nopts = {
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
 
@@ -742,6 +750,7 @@ struct sb_feat_args {
 	bool	reflink;		/* XFS_SB_FEAT_RO_COMPAT_REFLINK */
 	bool	nodalign;
 	bool	nortalign;
+	bool	delattr;		/* XFS_SB_FEAT_INCOMPAT_LOG_DELATTR */
 };
 
 struct cli_params {
@@ -873,7 +882,7 @@ usage( void )
 /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
 			    sunit=value|su=num,sectsize=num,lazy-count=0|1]\n\
 /* label */		[-L label (maximum 12 characters)]\n\
-/* naming */		[-n size=num,version=2|ci,ftype=0|1]\n\
+/* naming */		[-n size=num,version=2|ci,ftype=0|1,delattr=0|1]\n\
 /* no-op info only */	[-N]\n\
 /* prototype file */	[-p fname]\n\
 /* quiet */		[-q]\n\
@@ -1592,6 +1601,9 @@ naming_opts_parser(
 	case N_FTYPE:
 		cli->sb_feat.dirftype = getnum(value, opts, subopt);
 		break;
+	case N_DELATTR:
+		cli->sb_feat.delattr = getnum(value, &nopts, N_DELATTR);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1988,6 +2000,14 @@ _("reflink not supported without CRC support\n"));
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
@@ -2953,6 +2973,8 @@ sb_set_features(
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
 	if (fp->reflink)
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
+	if (fp->delattr)
+		sbp->sb_features_log_incompat |= XFS_SB_FEAT_INCOMPAT_LOG_DELATTR;
 
 	/*
 	 * Sparse inode chunk support has two main inode alignment requirements.
-- 
2.7.4

