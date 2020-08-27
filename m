Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F25A0C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0953207CD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:31:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FiCNdR5f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgH0Ab3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 20:31:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38924 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbgH0Ab0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 20:31:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0TItm165381
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:31:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=fCip9Xu22wOnVWO+HvVACp82Uc/5x3BamYZ7FaQQ5E4=;
 b=FiCNdR5fCvHVCboBdisMhUUYohEbagPTUOTAvMRD5V6eans68/MG/38rr296zhLXz3rr
 ePXo+J0Io9utvkZq72Zu3vt3L6cWyaM8nSaxTZCWravSii5j8ucOHijuxG3rugQoZB+E
 pIGGvBD1u1yys+JxOxCqoRV4SCtZ1k6xeiJ3rd/PR1obn5Ule/IZgmgP6wf2BLDIOB8i
 vrG3bEWvs3MxHbOCFqlchemd/fiPYB6PBTWsBo0zr3y3tHZpmgI2+MLiNU6d8+964FCG
 xZA8Ks6IBjfjZ3fbzVD4qvbFipUWJWFUjYdlkM1YnW0+kNSslSVCbM402Ahp2IZ8alf2 5g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 333w6u2027-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:31:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0Aq9d025905
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 333r9mswx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:25 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07R0TOSX024995
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:24 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 17:29:23 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 32/32] xfsprogs: Add delayed attribute flag to cmd
Date:   Wed, 26 Aug 2020 17:28:56 -0700
Message-Id: <20200827002856.1131-33-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827002856.1131-1-allison.henderson@oracle.com>
References: <20200827002856.1131-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270001
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
index a687f38..b7ce5fe2 100644
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
@@ -2951,6 +2971,8 @@ sb_set_features(
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
 	if (fp->reflink)
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
+	if (fp->delattr)
+		sbp->sb_features_log_incompat |= XFS_SB_FEAT_INCOMPAT_LOG_DELATTR;
 
 	/*
 	 * Sparse inode chunk support has two main inode alignment requirements.
-- 
2.7.4

